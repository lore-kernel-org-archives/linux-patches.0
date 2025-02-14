Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3225227BAD
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 11:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739532278; cv=fail; b=Jj8Zn8TQfOr7P6Kjun3VyewTH28XwrO3rfgqY9+gasL+DtTCOHvTmOqgk+xaQY9U5rstzA9ZJH7EeAZlyPYqmfhaiYGqq9Qq3po6BZIoMWZcSH97Md1C2k+2ooxxl/isEEVHDpc17wGXfXcOaAbqjSP61D6Rml8vQ6boNQbJI9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739532278; c=relaxed/simple;
	bh=2KcUL2aROG93VGW+kdv6femMJucA7AvRrCyYMeZQU/Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j6yN+Jv4KNIILlEVXj6wbCffPAWSog2bwrf2CJ/M4cAuB8KFsa5Aei93CyP2M7wsiwKHZFgZjLNH4Du4+g/oeeOx/7uGwWH79Krz4hJzzSe0aRecotUfv3fTr98p2C1rMo54xzZTJ78tHLaI2GX5zVkxT1NVKMYBuWto7UPAXC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Ibi+gcDV; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=pijBBNqX; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Ibi+gcDV";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="pijBBNqX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1739532276; x=1771068276;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2KcUL2aROG93VGW+kdv6femMJucA7AvRrCyYMeZQU/Y=;
  b=Ibi+gcDVMiqiirf2dviu2siZFbEY00v5mSTADa+LGxfX16Ad2UVBshd9
   H7KHPqQd5OWd7oiYZYrxBDyDWdOOyQsEMM+n4lNMg5IFXALprmqxJOSbc
   3ayaRplvHi6MVvGzXjDrduv1emuBNjwCzBLDcCGAKmMf8vB+3woWFnKDF
   LfUvbJTEoq4uFIQWIfKlDTpq0bb14+JkoJiBru13EQeC8hTCC9peMbMEL
   rWH4LnfIOMGA+E+QeeJE75JOaOAQIWfI/YKLo4iVBNdFHdXJR9HehbMOY
   pITVj7oHlr7PgypngGaJtCtz78ZcBlwofdaEsP9PUdMC12SK/CtjW1mFp
   A==;
X-CSE-ConnectionGUID: fkyQusy4TVCPHWr37tGyzA==
X-CSE-MsgGUID: rxMNiAnFTjC0ZU6t32tg2w==
X-IronPort-AV: E=Sophos;i="6.13,285,1732550400"; 
   d="scan'208";a="39728307"
Received: from mail-northcentralusazlp17010006.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([40.93.20.6])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2025 19:24:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hC2ysPNCnBYY/J22M6TwPr9zxosBOoD4+SaT+qUnyG35C4N9/HXXL0tElHKhMkV6VtWTCafnH4IPHr7lbu8LcBAQj+bq+cV0CQpVm5+S4L0ocUsBVhjHV9arz1c8LJdgWC8XXV5ZCX17I+yMpz84T06TK/8YNHF/BfmV0N2dv/heWE49YLIQ/EchxvZWWgbfTdS4wcY3jg2taRekf5rdbVKtP99S+KVmQoA6eaCNBKSX3/Pm5r8HyTdKKUasz2C9uhSD3Xd3elPiST/xOmiK9e18Fgt3TGTfZycTIY01TspNR+blYpUipC9yhf5LjcLRBO3n15lctGktlQHnLDVr+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3z0wFenFrbtqX9vQUVn9kH3O/gwsWKNvpkJLKhLScYU=;
 b=wEXlc+LmIWGItvx2g2bRrF6Y169nFNLuLaKGjWfLXMOke01hK2tgUZJrn9CgPFRQWI4G/eeIBe9CNpcWS1UyntgeGTsA+6C++6vNZKnrcuOyW1Ck6u+8vTbasHCegt6riOnrZ49mARK9VXIR8iV5VG907rmdjofTLQSX6wdsIW7No98cQq5ezm1X3ZTH1czi6cxh6r/rGbpUx7j6K3fB5pp3+Ax41Wlmjqjx3PK0BPUNYy2sFSnrgMpqrI9tMUW7V0jLFgncoZL63b/gFxNNhr7jlbJERxUtAC8xZCDEL3xnd3Ci9M+zlMPaVpNRZyaDQLQmks1wZHMU/x/y1d7sSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3z0wFenFrbtqX9vQUVn9kH3O/gwsWKNvpkJLKhLScYU=;
 b=pijBBNqXUn+DCQ3FhKkryW2r7eXs+VCEe/52fBA+cbtidZvndiwMZis2xkGoT/agN2c6FJIkXv4V2lHqX8OSr3dVappSRFLLUEa6u9kYpI7jIPl61/gNIkOdBtMvUT8muwPWwQ7jH6Wl6hrCpyoucoMO4UqAcLsdnHUMCDm7VYY=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CH4PR04MB9129.namprd04.prod.outlook.com (2603:10b6:610:225::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Fri, 14 Feb
 2025 11:24:28 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8445.016; Fri, 14 Feb 2025
 11:24:28 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Luis Chamberlain <mcgrof@kernel.org>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"hare@suse.de" <hare@suse.de>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH blktests v3 3/6] common: add and use min io for fio
Thread-Topic: [PATCH blktests v3 3/6] common: add and use min io for fio
Thread-Index: AQHbfZBfs25ngl/O6kiRmKQHFPWtibNGquKA
Date: Fri, 14 Feb 2025 11:24:28 +0000
Message-ID: <aeoy5udl4zyv6ab7njnqxswcpz6itnfcyctiwc4qt6oqsa6nxa@z5l5qsqif3bo>
References: <20250212205448.2107005-1-mcgrof@kernel.org>
 <20250212205448.2107005-4-mcgrof@kernel.org>
In-Reply-To: <20250212205448.2107005-4-mcgrof@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CH4PR04MB9129:EE_
x-ms-office365-filtering-correlation-id: b5f949a4-947a-4c4e-23d0-08dd4cea250d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?wtw3XHN423b7Fglk9VQ1yAvQwMRb6mD4+nnML1IUz6IJ1PAGOrJSOJZ/cxFw?=
 =?us-ascii?Q?y6v7oPUMFAtZfK0e8GaMyRY1U+LjPIi5PrKm08lTOp8mkHE1pzOpGbbA569J?=
 =?us-ascii?Q?k/IcNj7yEAgnghigxlF6qcJSeoKX09HvN122ATVCb0Xpih5GJuYBmCz6fkN/?=
 =?us-ascii?Q?VxCuDUW4eDezNRYTNkcV7zGDJnDFneYHkA3G3D8VvXB3bvQoI04Ky4gRlhi1?=
 =?us-ascii?Q?8NJo3rImczP4WoBT33N7lk7MAG2AuOnqV94pORsFZCALc0cancPncCjP9+DF?=
 =?us-ascii?Q?X5Ckiji08uQXtv6b8WwSAbDJXR5fAYO2mNH1DO0h1NXBANJ4t/2HlDMX4OOB?=
 =?us-ascii?Q?e97wTGdXgPMoL8sLivRYC5PwFMzNo7H7tEawv2l4BXjz7wZapR+8Uy5nIvfy?=
 =?us-ascii?Q?LRtJBNIzTaTL4uYhKC/1+Demc+8T3RB+RtyKbSyR01o2Un+vk9V3N6oL2GF4?=
 =?us-ascii?Q?9BGSnt4CY7OqvjI/PTGKF15M9D5VCa86LvqLqDcon8suP6bdnfigZru1jGI0?=
 =?us-ascii?Q?BNc5L94CBk8mbu5LTnXzOmu/GTdpIcJigIN7f4PDcAjQv31bkN90GKMJ/5Ay?=
 =?us-ascii?Q?FQLU+aglUV/rJGDeoBDcFVDMYaISIa2PsXWY09GUQFDNVeY6mfwBUmINZA/8?=
 =?us-ascii?Q?aEGsjZND/rUQd+JFp2uVtpa9KZEpuB1xfVtouE2s2TkWJunS9y0zKMSq3G+X?=
 =?us-ascii?Q?8940f1DBqc/xq0BA+oiaj6du/Ncdg54L1I9rN5gaHg809dHemQOE0t/3OXbX?=
 =?us-ascii?Q?Inq+G7JnHVSdcVEjnBlIhYACWzSX7fcUiRMxgxJl8HHnh3LzMSrm48Yn2SMU?=
 =?us-ascii?Q?ef1whxHGjz+cZ09Pi6A3h6y/50kUyhq4zR7sFpgerTbC2LT9kkdt3PZXbzij?=
 =?us-ascii?Q?0jhut4T+uZ17Su+/ZEoRkjpGyPfS2SsSvss+RYRrKmTiRtfIDrnj/+Q4BR1B?=
 =?us-ascii?Q?anQmlEBMrmeYs75X6t7MNdAeHdG/0zu5LnKv9kjY6VM0p3xRxwDqZHVH4CCI?=
 =?us-ascii?Q?oLBz9ONUIx8H/dW7FaXBMOU/Zl5ULtpVBi2X7nejKyCT8kReQnQuP69aaI0m?=
 =?us-ascii?Q?zYYgEPEIe8FRdOYlL13lJYvya/zCA1XRGate5OtOI/mb5BKJT8l0tr3QiGlp?=
 =?us-ascii?Q?JhA3a75I0XZmFBXyQ2B4PevqmE/zhu57hK/0BqmiAeivG5DrnWXudLvZNFu/?=
 =?us-ascii?Q?mkgL+XRrIuAnVBszQHQLiAJyRPtXT80Q6DBkNfLjGq7Nl+mOyFM8daPHxwXH?=
 =?us-ascii?Q?3UjH9wsrIv1KJZ+dM6YkAFhq7vtbJsA4UEKtNcUUUFKAybDoADUxPTE3LYVj?=
 =?us-ascii?Q?n+M0eA/FnNlNb10u2ww6aNDjf0Y7RgpNVf0avv0APEJF9OvxJ0TzXgMUg/u5?=
 =?us-ascii?Q?jckf4KPRC1hNURC4ijwcHxHUlMhN3M4DeCxtjONxqTzPKMZ75OqOQ6R3tNMp?=
 =?us-ascii?Q?5yNL3Ukmuz5n7CNBrrRbstVoNcSHq/8L?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?cqryXtjjdPBQT27XgvDpKKf3gbRLpbCT9om5IqSJS9lQUIAWAeq7vc0qfq0h?=
 =?us-ascii?Q?jOtczy7ZlYhvw6FHpLqMMa/p2xWMIgD3ZyKBNearkUb4kbLIjSdCzuSU+cTx?=
 =?us-ascii?Q?LwLY6bXcAEYR636RJkXQj9GoHXnCVjLCNr4rrpA9li5YOE+UMDGG7DQ2wuTY?=
 =?us-ascii?Q?naYE3NQ/RBlddRk9hi4kE3RTNV/eTaHJsYaxq9WNM80XR+6oRDO2J32p5HMc?=
 =?us-ascii?Q?Zabf6KC9THlXGTEAiHm/wBpHGXSHcBImrpI+ztQNNrgdWrTjNdIzlgye/q7P?=
 =?us-ascii?Q?TtimLvrD1EtxMc4SixF1+4EvqDG7Dr++WEhydMlfsFzeH7LSHeGyS8qcEkft?=
 =?us-ascii?Q?G70hwPmm0ztgkIrIHuJu5zKIDVRs7dERObM0Q4IwGwsTVRfgNGufZaCXY4Nl?=
 =?us-ascii?Q?M1IQHW8z35NP3WAEfRvTsL1wgx0BVf7msAC5C2SpwbzunGdowpLgGGd6HYMx?=
 =?us-ascii?Q?TACBnvx/m/7/GBp3vDPprWDx94fGDKZo5hDHAfHAg978AsD1RoeTrDVhdp1T?=
 =?us-ascii?Q?JFl6HR/7+mcGx2stepoavUAdxvHmi+dv0Ijsull9Y65hZm1kc/zjVH9vRBhp?=
 =?us-ascii?Q?qyFw2ppUQP+LSO4vd8iVKbiS43fCXVXwmRjPoG+oiFBPso4A8FD+ljOTOOIj?=
 =?us-ascii?Q?J3r85EAQW8UP2ZvdttWbNJZ0mpdAPcDls1JJHRViQxwmCf2gY0U/6VKBosPy?=
 =?us-ascii?Q?8iH3zGy/115PcR441LPYdgjIHoxiHvVBpmbAYnFV166yRFVlIQ6U2/zG+30c?=
 =?us-ascii?Q?ca6dcPRpP8KbkYOmPNP8cZW/Fg2M2vePDFVFLdJ7XcIExkOu4rxHLoY1u3HZ?=
 =?us-ascii?Q?JuLKHCajYOOlJ0SLgAh4dQwcfiA2lCHYGJYvQcyzR7Vy1+2aPqN5VS0gfjQu?=
 =?us-ascii?Q?i/6dcN2yzG+ZHpUVBhA2KrsBLpqX2HTVvLpTYPR1NLpRnixqEj5odBK7PbMd?=
 =?us-ascii?Q?22J05R5Hv5OsXvXQ+bGg9D4rT1rvYEQZSCGJwemYbcTWr1UBoffqZvhSvs83?=
 =?us-ascii?Q?oHVXG0U+dWwCvLowYQWSh+H6kQKzMNCt7owxg5wdID78BpRh5Ryi7GX/gh7s?=
 =?us-ascii?Q?hZtsAMQvYjIDE+Hw2GWPafAfZdPZDlCSyOmvjLVxjzuMj2YKevHkzA1qdRiu?=
 =?us-ascii?Q?Qhar4J2i0Tx4sZyQSChlhi54JBhmB1s5LOKw0S18Ls4OWjF0FB72VcK55LQv?=
 =?us-ascii?Q?lEmE0oZyW7yc8I2tjBojIxHPvciEKKaZ1skwMfn3Pa5onCATQKPQG6smjEAi?=
 =?us-ascii?Q?TDjCoEcyUlQnMnPtNt96DZxhmdBD/pwLpUkrG5dge8EDOZeOEmQL2kZiEBuQ?=
 =?us-ascii?Q?vM4Ky0wii79SmDL4B5FgWIywX8/5Sl4YxxlqSHSYdt5ECYTBchTHXfomqcLA?=
 =?us-ascii?Q?hkKuMoFEC21SqCODleXJ7k9MN96XxwTQi/Iuokl1fiivy+i9BHj5NN/ge3Jg?=
 =?us-ascii?Q?k0FzfSszHnrNV3eV3O2+Nq4to04s6kf6hZN1tdFVEE2wQi/PQcNg+PNp7u+c?=
 =?us-ascii?Q?QDvvCPpzUOusJ36EriJRRUNNaCwPxBWKcTNITWz76CckvGTSNjfl13O+r1nI?=
 =?us-ascii?Q?c/3hRXiCqEbor5g4bwLS1iHYDhKVxzyZZNcZ+qWaB/zbkNUgHLzhpdiOcRgW?=
 =?us-ascii?Q?yUUuqfXkG5sTH8idZaBaAO0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C07845EF1674FD41A122B20661628A3D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1Apd3cS3Ol01sst8qBvb+af5Uxg0e3nyYkH7klyEUtUwClcxnqrB05zKy3coWPYVyu03wsd7UutpmhFiIhIK26yRUJTP2NpCk2S5vJrqzQSWoyixYQSyfp1fC7WOlOtH3Sa5FwlJQVT0aXfv8MLnscNnYyiE1/i16MzJQVde8s7O14j7So/TDC541862D4zzptrDduKGoUiREF9WPsVNVJ6HSWxu/QEVCzTYMfsNl6SFQ7uahwZolKo3Q0uiUnEdeAkDIAfEVdGUJHmlA0AVfcp96B6t76LReoVlokrwYyixHr1el94LBxBh5JOLHRecuGVy/i27AbPAUgZXewsn7Chk9r6SyvTLoHvoU3pcVntiyUsQBA01rmSSVB0XJpJLoYj33Tq3+No4/B6DRIaC8bkg330AvJovPBw0jTs+6rwBhgDKQC7Zy1TeMfSj1DT27SqF9Kiw9MpdgVAEgzZ3lsCYRnhbXI8eJMFmDMz5lkdQ/YFvThWIEQx36D6p6a5PfXDcWQCeUI1WPqjcwVHmS1LFdv1gmOvceWpCrtVge1Mg1GSq9RyMFc6mrr2hBBZrrc4rDvZyqrtQXtxQtiDs1gUW/zeAGviu/Jz0QGsW0Uu1iSd0UO3/Muo935UzLuKc
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5f949a4-947a-4c4e-23d0-08dd4cea250d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2025 11:24:28.4130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7p0IgZRnaJo0+9sEHNaq66NXS03Abj1RP/nWlgSFnQ3h2zk1XwKkLIeUgzHAsuzZwpqjxofe4S3bBAnbMllgkF8NjDVuOw0O+Hukm9WSOdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9129

On Feb 12, 2025 / 12:54, Luis Chamberlain wrote:
> When using fio we should not issue IOs smaller than the device supports.
> Today a lot of places have in place 4k, but soon we will have devices
> which support bs > ps. For those devices we should check the minimum
> supported IO.
>=20
> However, since we also have a min optimal IO, we might as well use that
> as well. By using this we can also leverage the same lookup with stat
> whether or not the target file is a block device or a file.
>=20
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  common/fio | 26 ++++++++++++++++++++++++--
>  common/rc  | 24 ++++++++++++++++++++++++
>  2 files changed, 48 insertions(+), 2 deletions(-)
>=20
> diff --git a/common/fio b/common/fio
> index b9ea087fc6c5..d147214f3d16 100644
> --- a/common/fio
> +++ b/common/fio
> @@ -189,15 +189,37 @@ _run_fio() {
>  	return $rc
>  }
> =20
> +_fio_opts_to_min_io() {
> +	local arg path
> +	local -i min_io=3D4096
> +
> +        for arg in "$@"; do

Still spaces are left in the linve above.

> +		[[ "$arg" =3D~ ^--filename=3D || "$arg" =3D~ --directory=3D ]] || cont=
inue
> +		path=3D"${arg##*=3D}"
> +		min_io=3D$(_min_io "$path")
> +		# Keep 4K minimum IO size for historical consistency
> +		((min_io < 4096)) && min_io=3D4096

I think the 4k comparison above is no longer required, since you added it i=
n
_min_io().

> +		break
> +	done
> +
> +	echo "$min_io"
> +}
> +
>  # Wrapper around _run_fio used if you need some I/O but don't really car=
e much
>  # about the details
>  _run_fio_rand_io() {
> -	_run_fio --bs=3D4k --rw=3Drandread --norandommap --numjobs=3D"$(nproc)"=
 \
> +	local bs
> +
> +	bs=3D$(_fio_opts_to_min_io "$@") || return 1
> +	_run_fio --bs=3D"$bs" --rw=3Drandread --norandommap --numjobs=3D"$(npro=
c)" \
>  		--name=3Dreads --direct=3D1 "$@"
>  }
> =20
>  _run_fio_verify_io() {
> -	_run_fio --name=3Dverify --rw=3Drandwrite --direct=3D1 --ioengine=3Dlib=
aio --bs=3D4k \
> +	local bs
> +
> +	bs=3D$(_fio_opts_to_min_io "$@") || return 1
> +	_run_fio --name=3Dverify --rw=3Drandwrite --direct=3D1 --ioengine=3Dlib=
aio --bs=3D"$bs" \
>  		--iodepth=3D16 --verify=3Dcrc32c --verify_state_save=3D0 "$@"
>  }
> =20
> diff --git a/common/rc b/common/rc
> index a7e899cfb419..6e7bddc844bf 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -400,6 +400,30 @@ _test_dev_is_partition() {
>  	[[ -n ${TEST_DEV_PART_SYSFS} ]]
>  }
> =20
> +_min_io() {
> +	local path_or_dev=3D$1
> +	local min_io=3D4096
> +	if [ -z "$path_or_dev" ]; then
> +		echo "path for min_io does not exist"
> +		return 1
> +	fi
> +
> +	if [ -c "$path_or_dev" ]; then
> +		if [[ "$path_or_dev" =3D=3D /dev/ng* ]]; then
> +			path_or_dev=3D"${path_or_dev/ng/nvme}"
> +		fi
> +	fi
> +
> +	if [ -e "$path_or_dev" ]; then
> +		min_io=3D$(stat --printf=3D%o "$path_or_dev")
> +		((min_io < 4096)) && min_io=3D4096
> +		echo "$min_io"

Here's the added check, so _min_io() return value is always 4k or larger,
isn't it?

> +	else
> +		echo "Error: '$path_or_dev' does not exist or is not accessible"
> +		return 1
> +	fi
> +}
> +
>  # Return max open zones or max active zones of the test target device.
>  # If the device has both, return smaller value.
>  _test_dev_max_open_active_zones() {
> --=20
> 2.45.2
> =
