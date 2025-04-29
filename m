Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10F7215F76
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 02:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745892497; cv=fail; b=nHoWqV/PRpF3NniZTOh7O+30eJozK4425KmofOWTRkPeL37xSuZipGIi1zYdFUAARieKx+prkkwn2dnyFXQcY4pL2zI6XJ621eoHVemeBXMkHiRlsoVBi6p+C7BsesULPNJWnlyDRBW3GgudIlY0P6Fe976ooJkGJAxLpo77OZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745892497; c=relaxed/simple;
	bh=JWKsIARcfySALNPWjIAEJRkkmAR7j3kFMkwMMILADAU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=reJoQoPLvSVacDFwdoFWsAp7VguBiJoBWXJTx9kitev/ia/vcXhMThyvhTbJ7nKi5xubUkyzTIMMU3myqWxlewhK9zJfOGNeh3ikBDVNe5Rni5446pMIqd2fzylbndtYgozNQIOGp4eDOQwXLdJYGiV+TBxQGji2EY4NeDik45E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53SB7iFG019475;
	Mon, 28 Apr 2025 19:08:00 -0700
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2045.outbound.protection.outlook.com [104.47.73.45])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 468ts3secg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Apr 2025 19:08:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=llLagB+jMyPNCZQavCR+eRe9zAKlCJK+Xzx1FMqErt8pfjSLb5zN3RlQ28/xFpcLIWyQkp9otE58s5ersbcY+KTKDM8x/7z6q6bYAjMjzPsG79FxPnM/uepg3NKPgyuROPvN6wEsdsIXn9nl9WtQl9rEeaGh3bI2WkyQoZrgT2URMrtZxw1UZ7MKv5H4bEgQXaGP3vJJG9aQGMlGvc0Q7Bh/XWYEH2fcQusWHzk79QohvnmlW8m2/EfYHaMheqCrMDiSoX0mLVz0rZDuCVETB8rnIRQUlDwj46PWgjw2fNifqdFff4vvIZ6cv6F3BlMAV4RiMWiDDOK2y8B2Bj4XkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbob4CQ+rRwsvGFabjx0n7TTpnThqqdInYL2DqSOvmk=;
 b=nj0wqx6z23HTX5HGqYi8t3YzKo7L6+nSU+5r/TKUUNJ3YsuYSfkQmAnEJLRfbFj/BQcbf3xsh/rR7xDTTi7PQDn/1D5HhNdt/Jl65lKkO6etekQOOdCQRhStnJ7HgDxUGdb+l67/g4ZqPPpKcY+lcLGydDynrY5e3p4ShyVVJiUyktfhwKJGL5a1Rsrygaes/FjTo2itq4+Ji6+MFwQnu8VfJhUd6pkS731VI5KTnOYAQlHJWiQIep4lNhfWayBAR3xkQonBQwzSBpVhaMi2Q44GivNBTV83O7br++CZQZVNVIG9MmN4W0BE2qDSpf0aN+RTCisHYB683OxQ/H8WRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from IA1PR11MB6170.namprd11.prod.outlook.com (2603:10b6:208:3ea::11)
 by IA1PR11MB6265.namprd11.prod.outlook.com (2603:10b6:208:3e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Tue, 29 Apr
 2025 02:07:55 +0000
Received: from IA1PR11MB6170.namprd11.prod.outlook.com
 ([fe80::f850:53da:e11b:1653]) by IA1PR11MB6170.namprd11.prod.outlook.com
 ([fe80::f850:53da:e11b:1653%3]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 02:07:54 +0000
From: "Ren, Jianqi (Jacky) (CN)" <Jianqi.Ren.CN@windriver.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com"
	<xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org"
	<kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.swiatkowski@linux.intel.com" <michal.swiatkowski@linux.intel.com>,
        "He, Zhe" <Zhe.He@windriver.com>
Subject: RE: [PATCH 6.1.y v2] net/sched: act_mirred: don't override retval if
 we already lost the skb
Thread-Topic: [PATCH 6.1.y v2] net/sched: act_mirred: don't override retval if
 we already lost the skb
Thread-Index: AQHbuBO3T/45kqXRK0W7E9ZjTIlKQLO49hWAgADwHSA=
Date: Tue, 29 Apr 2025 02:07:54 +0000
Message-ID:
 <IA1PR11MB61703A24C42BAA887F5263ACBB802@IA1PR11MB6170.namprd11.prod.outlook.com>
References: <20250428080103.4158144-1-jianqi.ren.cn@windriver.com>
 <2025042844-pavestone-fringe-1478@gregkh>
In-Reply-To: <2025042844-pavestone-fringe-1478@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB6170:EE_|IA1PR11MB6265:EE_
x-ms-office365-filtering-correlation-id: 89b94b6b-3dcc-41e7-9437-08dd86c2a77a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Zzzrr7dp8bZPxFTQ7guxxGh8LYOwmh6qc3ktk/zHW/V2FfDxmkMPJpdtGKDT?=
 =?us-ascii?Q?HhzBHVCMpxYrCyYHhdq9Rq5gocf7LOijjcH3X0+9CWH5us+LJl86sgsQcxEK?=
 =?us-ascii?Q?xYHvRgO2lBE5c30X2H4EfeYOluFZmajzUS/BpwI5Ss8rlqGXaAWSIeX8jNoR?=
 =?us-ascii?Q?Kd3x9maR59obMBq9zoRUCPDxDeYtnaiICHHhdud8ObbAgUsMu+87ljE6MHyt?=
 =?us-ascii?Q?WmHniHidlRpowHlqZOEu/bvhy8Uuevcfhp/J2ASjmuIi0oR6gAp9l9Ijnmb3?=
 =?us-ascii?Q?CPuvgrFLuoLc1fHZ1qFRXWfAkbimZGs8iGkLtaEjnKE+QaA4lVlr9YkeeHOE?=
 =?us-ascii?Q?Xh7mxVFKdAflAANo7UrI6xr7vMAFc2akZN897x0Kwm+BUVm6z9qDx6n6x6XI?=
 =?us-ascii?Q?59TK+fcnUcZyqIKpk74y3mqyT8/slzuPBCQNLWiBo2zd6h2G1NcSyv9Ab840?=
 =?us-ascii?Q?Ksuv45DQwvIpIe2cEemDy2PMQUInRj7XX3LZipVaTAcNAmpzWzi+DsCaFFS2?=
 =?us-ascii?Q?DwGJgOCrRNLy2xaW2FF9bUHxwQIq6IENDBZu84FwH/Sw/zF94kCcXWcNW8u4?=
 =?us-ascii?Q?YGausqkYDfvhlxbW0I3iNqZgNtLo08bG0Q1/mJS7Q9tKNlVQ39ibCbvB6FP7?=
 =?us-ascii?Q?aP5zi9Vr/B5YMI0JcqT8QUk5UBMt3aJA9uWgRddwDMuiXFX9HC9CSNAE59oh?=
 =?us-ascii?Q?QRXzXQIF6hq9hZwzxV0IuL529S9R/kFH9cHcek6K0Xfnz6JdOotPyU9MZ9eh?=
 =?us-ascii?Q?LFsAcVCpmG3aGYInlWjxLFE+LsDH9xl7sc740Qq/XZuq9wYVfkYuM1vFduOa?=
 =?us-ascii?Q?L+FIC7SIYuuG3BojAFJz2QFVPDI2EfCsTyOAZHpLicIZKc0WIr6Y/SDm9wvl?=
 =?us-ascii?Q?gQQZIPSm0MDimtcBp9qLI0O82vec6Awxbig9JQsRUU+jGrhMKm4TFEzZK7Uu?=
 =?us-ascii?Q?MlG5LF13UrQqFoQ/W9iyiPUJ616+63Gbti3Jp6G3HSAtT3SKQApgMOjpagJf?=
 =?us-ascii?Q?4OZ0VnCJ7LQJsWPp2787NH2wjMhS49qTk3dEYcQr6wO+34wx8bSXWHXS6cNu?=
 =?us-ascii?Q?4I2a65rQKz/4Rdy6p1F151X+edzhESlAwwKmmD9C+fNze5h2wdazHO33hsEQ?=
 =?us-ascii?Q?KNGbPCkIoyn3a4gwX7HV9bXcAAYi5qrdmJK15I7GKxIJOmTgduvaOikkS+ZM?=
 =?us-ascii?Q?0JVHJCffv8pfeYTButOV9k8g9d2xK/RQ3SZh1z+Xxu+n0w2KX87OUGT3size?=
 =?us-ascii?Q?Ufo43RfMZrEoES7vgY/wpeTMH6e5KW0ZFdEHXjVW3c/aj7HvfOHt8T/o8wWo?=
 =?us-ascii?Q?Zgi9dMm7nNsjlfwjvA4wawTDoyHLLgDtsY0ptP2yIKYhdaJR2pBqqA9QzqhR?=
 =?us-ascii?Q?EzY2pvQiVz7HcB4gKdvtuSJZG/go9krDswuGgPJhM6UeZVlu1UtimR/m1WdO?=
 =?us-ascii?Q?Wp6jnILMTVA3VfqIEWBGJuLGQ55u4gMCQhQq8jooLxBwShDYCff3oA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6170.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?oRR8fKvyvTDZ5pMMqfmNu6j3kWC3YPj4+XZfjkw+rPQpkzhu+cB5vPKf2VZ5?=
 =?us-ascii?Q?7HpNu2Jn71hU4TejtFtUlq9whLqE4204TpLv8tv1igEWZub3mq82OBWek770?=
 =?us-ascii?Q?C4yrYsRdanSnI4/o95CImvlv/ioHT4atp5XRJHnetVQpu+NEXEIizO8wRiu7?=
 =?us-ascii?Q?C0Psl1NWHDHbcM/g3qasoxHp6eukO0COEuwFm6ZLFH87EKbOBoARfSxp9IYm?=
 =?us-ascii?Q?QZ+t6mayk55hn9Y5fWCQzYNs3fhuTxo0O4XheKDDWgxwObNAh4xMbMNRnUjR?=
 =?us-ascii?Q?7exRAq6DdZNe6TmwahAB6vgbJJTJoMJXhzGLHoO+iy2oWrQgbQVKgM5o4l/3?=
 =?us-ascii?Q?KxRHST5z2fSVI9Nwg6KaTmjwOdRfznrV/AAC11XNhPw14nErX/BZGK4RsaKz?=
 =?us-ascii?Q?TNp4tFeEjpDJwrKygR+iLdlvES8K/g42+//snWFWjfEbcFklRqI1g89Aog8F?=
 =?us-ascii?Q?3eJSOFDZG8VTxTral2W5IiHWpkftRoijFB3YG1D+Y0N6sfR1+4bsPa6u+OJD?=
 =?us-ascii?Q?/EAi0s2n9fCRL9z5kYFihTX7Q/ZVhppDfe1B3ZUaONm6AcOreRbNY6YwBaId?=
 =?us-ascii?Q?Z0zmiPU1ROlTmglriLE8CLMOp9+G2fFwedTQrG/9UEUTsdcNayX80U+XN6gU?=
 =?us-ascii?Q?sVNITQWFTCPobKOzNRd8J/KxefADXPSihul69e3fIfx0xIXY30Hsj+ulQKv9?=
 =?us-ascii?Q?yqlUlubLPtm65ZZtW5eiXJL/Pm0sNuMbzSxyXCu9D6RGFf7wD7D73NGjhfWu?=
 =?us-ascii?Q?L1o7O5kv6zDuCHdqe1tGSWhxVg3lblo6gdD5WQLTovnTX0ym+Es26+pnX1il?=
 =?us-ascii?Q?bBeh7saa9YYJ3nD8FCR/FXxmdt6s6gZ219fjX6kFc55a4o+DXf0DiC5ROk+O?=
 =?us-ascii?Q?9szHb/eIVIWbK3KQNj0yUBQgDxa9INyWM7b5KquyMJdi8bfsu6DdWFRSm3Mr?=
 =?us-ascii?Q?f4X0xKfOKwHIrRoFDbPV+sBDj4VqGUpCXeFi+V6USDh30xZU1f+CIEZmbf7U?=
 =?us-ascii?Q?mmdnLSfDJNlE72FQPomtjRuXma7CPhch88pU2h8HKsRg2fbuQP0TdjGJ62Dw?=
 =?us-ascii?Q?QQcE4SDDqyiSSD5G134inpG/RSvSEr17N6fxQAJsXfT8Cr+DmGVOqFnI6Zyu?=
 =?us-ascii?Q?/WDkRqtMs3jmMTH6nEyVEmVf1FraSikNuL7JTGxkkmO0qZATbvGtPJs7dXPD?=
 =?us-ascii?Q?/OF73YtQOKxG7pgeKzRlcTMJuzg/GGwbWHlP2CgByDxJgViR2mjpaHGaHvwa?=
 =?us-ascii?Q?6qUsZ8p+EM3j7ruWViNGZVlkS8bqCmsSo9n/68+GQKa3m61326nN9JFhiXHm?=
 =?us-ascii?Q?QHMRIjNzyUgAV5Hn7Jjkrqscxh9RwD/Ov2kF7x5UVyGAds/tYz48ATxNQ24k?=
 =?us-ascii?Q?ocTrzRJJs3lMJOUnYSi6iSczJPRui2J8L7AihhC3L8RjN3HrSlfF1IvHIx1W?=
 =?us-ascii?Q?hSVUPzpnwWIsBQATktMfZ0NtsOOveUQXknmww5YJ90f6WThi6KgXxwVhcxo8?=
 =?us-ascii?Q?4qAQLpOJ9L0TVryQ8WxGy01ILEt2O/sbez/s1qnm60Olhcy8TvX4QOqa/smy?=
 =?us-ascii?Q?5jzAPvWPLc0E6QXNQSuYXJty47/Ssh1O3MGVBkQM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6170.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89b94b6b-3dcc-41e7-9437-08dd86c2a77a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2025 02:07:54.7561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ct4eid/EGsJELn0qmhYDWfnCC+Hzz32IJeGuMEZvZLAc0DvJC/cOHryH0bvN9GrN54R/TPRiDCBbqOeeruYh/FuJFeB2ItEvKfCnIatWjPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6265
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDAxNCBTYWx0ZWRfX1iTTQNP69+Km ddGAJewjm68cEF/Zq3aMrIN9H0LOYfdfvenoYXgjpf42xQVkWpDRN5s7xKTOSTi21npkMXFjQiW hG5UI42QVzihyuauCV6Bj6Aitu2sASnn8KMg4VcrIavVzCRbFzvYSPb1aRnbM2dmqFpJf0VeU4r
 0aMerud+DMWzSIB0SG8HdlcQHQR+HKFuUKaa/eo7/QoH+wPO/+r1t1Mb7mIrKBb6SYxyoe7Pi7I RhmakYoEkQ44y6JCthuXZykDKl2jxUX8T9qy1/eYZnC8nMUKCAhgPmV/B/EHk/bTd6aXrTw7M1T uP+vrt1hZWKd8HpwSwraXpy2rjBa411ougXwL2w8eri/B5j6zQpYOWpRzjS1Cvut3lKHC0MwEFt
 jQh7SgkiJhcy06dd64HcIKcIAhiABng3QwOSZrXBumsVQWJkcuUKgFDF0jOqZ++IJgm16xdz
X-Proofpoint-GUID: xDWgJbFO1cgEwKNpmEooh_-QIPQBMmWk
X-Proofpoint-ORIG-GUID: xDWgJbFO1cgEwKNpmEooh_-QIPQBMmWk
X-Authority-Analysis: v=2.4 cv=YJifyQGx c=1 sm=1 tr=0 ts=68103480 cx=c_pps a=o99l/OlIsmxthp48M8gYaQ==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=t7CeM3EgAAAA:8 a=A7XncKjpAAAA:8 a=pGLkceISAAAA:8 a=J1Y8HTJGAAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=yj-aMKAYKbz0kkd27lYA:9 a=CjuIK1q_8ugA:10 a=Yupwre4RP9_Eg_Bd0iYG:22 a=FdTzh2GWekK77mhwV6Dw:22
 a=R9rPLQDAdC6-Ub70kJmZ:22 a=y1Q9-5lHfBjTkpIzbSAN:22
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_01,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 phishscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=999 mlxscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.21.0-2504070000 definitions=main-2504290014

Hello,
I have already dropped the first v2 patch for incorrect comments(Maybe you =
missed the dropping email). This v2 patch is just I want to send. Thanks!

-----Original Message-----
From: Greg KH <gregkh@linuxfoundation.org>=20
Sent: Monday, April 28, 2025 19:46
To: Ren, Jianqi (Jacky) (CN) <Jianqi.Ren.CN@windriver.com>
Cc: stable@vger.kernel.org; patches@lists.linux.dev; linux-kernel@vger.kern=
el.org; jhs@mojatatu.com; xiyou.wangcong@gmail.com; jiri@resnulli.us; davem=
@davemloft.net; kuba@kernel.org; pabeni@redhat.com; netdev@vger.kernel.org;=
 michal.swiatkowski@linux.intel.com; He, Zhe <Zhe.He@windriver.com>
Subject: Re: [PATCH 6.1.y v2] net/sched: act_mirred: don't override retval =
if we already lost the skb

CAUTION: This email comes from a non Wind River email account!
Do not click links or open attachments unless you recognize the sender and =
know the content is safe.

On Mon, Apr 28, 2025 at 04:01:03PM +0800, jianqi.ren.cn@windriver.com wrote=
:
> From: Jakub Kicinski <kuba@kernel.org>
>
> [ Upstream commit 166c2c8a6a4dc2e4ceba9e10cfe81c3e469e3210 ]
>
> If we're redirecting the skb, and haven't called tcf_mirred_forward(),=20
> yet, we need to tell the core to drop the skb by setting the retcode=20
> to SHOT. If we have called tcf_mirred_forward(), however, the skb is=20
> out of our hands and returning SHOT will lead to UaF.
>
> Move the retval override to the error path which actually need it.
>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Fixes: e5cf1baf92cb ("act_mirred: use TC_ACT_REINSERT when possible")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: David S. Miller <davem@davemloft.net> [Minor conflict=20
> resolved due to code context change.]
> Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
> Signed-off-by: He Zhe <zhe.he@windriver.com>
> ---
> v2: Fix the following issue
> net/sched/act_mirred.c:265:6: error: variable 'is_redirect' is used=20
> uninitialized whenever 'if' condition is true found by the following=20
> tuxmake
> (https://lore.kernel.org/stable/CA+G9fYu+FEZ-3ye30Hk2sk1+LFsw7iO5AHueU
> a9H1Ub=3DJO-k2g@mail.gmail.com/) Verified the build test by cmd(tuxmake=20
> --runtime podman --target-arch arm  --toolchain clang-20 --kconfig=20
> allmodconfig LLVM=3D1 LLVM_IAS=3D1)

I see 2 "v2" patches here, both different, so I'm dropping both of them :(

