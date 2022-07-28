import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:piskon_suv_ombori/model/data_model.dart';
import 'package:piskon_suv_ombori/page/history_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../model/pump_data_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences? prefs;
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getLastData();
  }

  DataModel? model;
  PumpDataModel? pumpDataModel;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffE7ECEF),
      appBar: AppBar(
        title: const Text('Piskon Suv Ombori'),
      ),
      body: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          print(state);
          if (state is HomeStateLoading) {
          } else if (state is LastDataState) {
            setState(() {
              model = state.dataModel;
              print(model);
            });
          } else if (state is ErrorHomeState) {
            print(state.message);
          } else if (state is LastDataPumpState) {
            setState(() {
              pumpDataModel = state.dataModel;
            });
          }
        },
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Card(
                elevation: 3,
                child: Container(
                  width: size.width * 0.9,
                  height: 270,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          "Kuzatuv nuqtasi-1",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          "Suv Sathi:",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            model == null
                                ? ""
                                : ((((int.parse(model!.data) + 662)) / 100.0) +
                                        990)
                                    .toStringAsFixed(2),
                            style: GoogleFonts.poppins(
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            pumpDataModel == null
                                ? "Ma'lumot yaqin 30 mintda keladi."
                                : "O'lchash vaqti: ${model!.time}",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, right: 20),
                              child: IconButton(
                                  onPressed: () {
                                    context.read<HomeCubit>().getLastDataPump();
                                  },
                                  icon: Icon(
                                    Icons.refresh,
                                    color: Colors.blue,
                                    size: 50,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HistoryPage()),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.history,
                                    color: Colors.blue,
                                    size: 50,
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
