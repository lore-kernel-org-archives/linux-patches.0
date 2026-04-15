Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5728A1A267
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 18:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776276929; cv=fail; b=fbIXDZG6AfGBMAiDfkis4Plx56rObNP4FEEfosSYCm5jqbKfeVdhZNz/DLcvfBDqE+ncQNia1vP2YWAekLTMMueW40LFFibsRjc3bVFrHHViFfHEH80PQOHL9cG9NJSVGLpSOyP1JdZhMn8787puv4Q+dte3qOnKZTRABFXe1js=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776276929; c=relaxed/simple;
	bh=Xbta7JcJjJuFOBGeDjKh+/nMSFpECtwX+hkn9iIEULU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y5AFRRTR09SZn/GzdLk9Copd38sEPyhu6ZRheeYcKDD437PQFSg3E6RWzF7MRBg/IaKWoTRAgQBM42fNNgX0YvrkkWje1mQhg2mPn8pkvYETkhcdc4K81YI6bZfhEDwsJ0e8AH/1gdofUFr/eKDne6eQXCgg78lmJkBSrSM3nJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e9TnXkHD; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e9TnXkHD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776276929; x=1807812929;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xbta7JcJjJuFOBGeDjKh+/nMSFpECtwX+hkn9iIEULU=;
  b=e9TnXkHD6zyi3aNQwu7k9BzG+6TR1DLpqTTbeuo/IyXkMG31ck/y+ZoF
   vBRANpZWxlFoYkHMSnmLy/lPrOuOCJbCiJc6SOxc7+dz80mvQTmaQEspp
   LcLIKYx6CG8oYe+VBPNxShdNTAgdRUcV9suRQJa/9V1s+pVqh+fqJcXpd
   H+3shIJhUGzVDHw2wBzkVuOUTTe5StmMW6Bif1/lIOlkXSRQmk1/zEWzB
   3MRXYlbtpGmzdSA7M+iK7g7hQcg3CvgN0nZizQzVTjcz/MX69WL5JwQ12
   FUxzeWfdT4Qcm6pF8CoXwZbEgyuyEVxc88d9Q6TpXKaCvaQ19GlYLu/Yg
   Q==;
X-CSE-ConnectionGUID: XvdLrjGMQ6CViFWsjs50+Q==
X-CSE-MsgGUID: ORLOkra9SXuXSTkYAzPwmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11760"; a="77239787"
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="77239787"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 11:15:28 -0700
X-CSE-ConnectionGUID: l0yVBwmwR56vlyJGHijRnQ==
X-CSE-MsgGUID: dJyURgvvRwSWKu1TMg7YYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="223992405"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 11:15:28 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 15 Apr 2026 11:15:27 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 15 Apr 2026 11:15:27 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.0) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 15 Apr 2026 11:15:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bBiZ4WETwMJ22KSYJntrzsxYBBD4E2Tf8OD3/T1hyeqp2cSg7zUrOoYUK3dxRigdmvWWY8rdPF41lkzhyE9GLK870KkMPpDsD1wPOB/0pEn/dgOlyy2MpyNhZnEbR/WlN8mYjqmkvYPeWHg6TQj8oq9CIY5+ONLxeff3aKeGarPoxb41dQ89xw7xeVY61+wQyfxQfAlFFyJi2mdMhXtULdEDrDlf/YyhJg6pfpirSzPNJjdY4QULguJ0KrXO/WtrgQkT4esOwJU9VMqxl8cspMzJU8gopssc2m4K2n85JGEZ9EvhrVATHi2AykLhvBFPfCxdmF9++n1nPcRjLSpQ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xbta7JcJjJuFOBGeDjKh+/nMSFpECtwX+hkn9iIEULU=;
 b=AFEjO9ESzIJ2ihhQym7VDJ4i7Cda1Exi9x8YVN4TJ/N6oxiIACBDmbwTiJoIjVgsRJOlQiYwPpcaJIOcQguUaEpk+/wCJStRdW5MGbjAL98pjhNTBnl9rvpj8RvTe83bE1Qr/EZNvFxM3SGtlI54BfMS3H3S++wtwp1aZd1/XMRiEwvt8ZzTdAVoN1zjy8agig0rrOv7cwpshjeO6F2AmB6jlsXtsxHQyrEfm6QDoxN1kcJjhMTTdf8kqkuL/t65hKiHrp4STY5ySKis7hty07b4DRoWbaCJi+y9yfwHA/0+C2R2boR81HmIybhpPeDP6OR6Ya2HBb+h1nR1m9JbWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA4PR11MB9345.namprd11.prod.outlook.com (2603:10b6:208:56c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.21; Wed, 15 Apr
 2026 18:15:25 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9769.046; Wed, 15 Apr 2026
 18:15:25 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Jiaqi Yan <jiaqiyan@google.com>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "Li, Herman"
	<herman.li@intel.com>, Zaid Alali <zaidal@os.amperecomputing.com>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v2] ACPI: APEI: EINJ: Fix EINJv2 memory injection
Thread-Topic: [PATCH v2] ACPI: APEI: EINJ: Fix EINJv2 memory injection
Thread-Index: AQHczP6ZIr+DSloHlEG5vW6nMKqsorXgaWIAgAACdwA=
Date: Wed, 15 Apr 2026 18:15:24 +0000
Message-ID: <SJ1PR11MB6083BF86FFA17D90FBF86686FC222@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260415173735.24437-1-tony.luck@intel.com>
 <CACw3F522f6p-x6MEU8t7CEoU1P=PtU8dKy7opKjH8sOecdF1kg@mail.gmail.com>
In-Reply-To: <CACw3F522f6p-x6MEU8t7CEoU1P=PtU8dKy7opKjH8sOecdF1kg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|IA4PR11MB9345:EE_
x-ms-office365-filtering-correlation-id: 66316d79-113d-48e0-e70f-08de9b1af73f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021|56012099003|18002099003|22082099003;
x-microsoft-antispam-message-info: LcAZaFOi8qIyi4Z8DLWu5fee+vaNInMXK/Va3mkLbrNteAXddt9mlY5kFI0HIOxUTydWMapZikY0nEsaDf7R8UZ/2qKP4uLS480N9HrMurgPPMQ0eHEGaGLaSRj0wudA3I5Av++jVn+Wk1SObtYRSPclbTrlymMW6Ogu0bU6NgcQkIeDr1VlsDOAO3uOJvyg/Y9RrO1zJVIBEUpKkjB98MD7VTVldZ4PHiDu1aj1V7lsNR4hlAQ6D8Zmco7c5VRyte3+47gDHp2sIor+9q0cv66a5eIa/F4Ihhx1fmiAJ+2zP3PL14XbhuN6lke+rqzRHZf8t/mcf1fcPcf9ZR2Q156u2Bsp0lWrF6mXSEimT2e1L380vwZ89M08hJxPkywwDffkIEPyIuDPtBcerSYh7oxTgHqcF2J/ewrNWWKWaygxsv7Q35kfn3ueBXPNMv7kjPmqr8tnqBO+qMGoY4ZEKqsmWPCNIwyxw/MXJFstDbCSl8B3l9M2d5d1wU0dLcG+/PCxMcqs1lRZsr2LNRzWLFSj57Ne5Yil874H3tJ9CnyVGi5u3QfX42XK1ZFrA/AofhNrKcFRNBjiZxDi817PWjPJriF/WjlpDwIFeDukcP55xGQdww6uO/hUyoXLgMHf8NfJo2Y/FngGoPCJLu3dFY0zxExmvkYk3PqeNbZX1b1BbqtWxewkhwGqMU/krpQz3eGZEECg+FCIyddkIOmwElmdWwbQQHGxNy7oa6Ijb39iUfSQQvrSDea5oLURCIBUD2t0YjhNfEbuDV//LHaG0HZt5sEW8yM+qWKDPjrL1KE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V3E1SDY3ZG5jTU16Wk1tMUNOWlV3bnMxQVNuTFplVzM3SGdNb3U2U1prRjV6?=
 =?utf-8?B?VVBHcjllbjdsdjZQQmhXcC9TVmRiUDZxVEs3ZHpjQklRWjFEK0QrRXA5OTN5?=
 =?utf-8?B?OUtSaFBQYVpiZlcxSE1yR0dUeTBCZ2QwVjBndEFBd0Q0cTdrMmE0dktlaGxF?=
 =?utf-8?B?Q25DMkEwNTdTbVlqSmN4ZW1lTFpUaGE3bWRLdERmejd2bkx3aSs0Z1hCaUtP?=
 =?utf-8?B?VkNXeGJJTTJZYXZUd1ltTEFVMHJqOFpuNWJCVE1vdHhVZGN3N3Z3Rm1hQ2ll?=
 =?utf-8?B?UEMzYk1hLzB0UUlSUHRoS1llN2dLU2N4Z0RrQlY4UEhlMkVIRDBaNVdocTZD?=
 =?utf-8?B?V1lvTVVhaEhKUEJlblVLbU82Y3pSbUMyeGhCUytVL0tsUjdVYXdnUU5WM0lS?=
 =?utf-8?B?Q3hHb2hsc3hyd2RPa01rcTJwZzNya1p6VE81TEo5eGZzU2d3ZmdEYWRKbVA5?=
 =?utf-8?B?UkRtZkQ0NjdGZ3NhUEVYQ2YyUllnd0VaWkIvMm1USDN2cDBCdEdWMTltYVgv?=
 =?utf-8?B?WEtwOG9nOEdqSzJtQ0JyQ2laNlM4ME5ncUpaemp6bnZjTUVSSVN1ZlRIZGZI?=
 =?utf-8?B?RkdQZ2FFelNkVnN0TXpqWXAxRUNpTmxtSXFMT1pTRDBDMnZGRlBzdGYwWWNJ?=
 =?utf-8?B?anJUSjMvdXBXbDNUV0ZNdnRITE5qbnhKZ3U4Z3JqSXNvRWdoa0VLdFN5SFZm?=
 =?utf-8?B?UTJSNEVsV1k4K1o2Z3NjK2R0NklLa3NmamxiQkJPSHFxZGxwc1dNaHVESk1w?=
 =?utf-8?B?Z092ODlpcGdvazBSYWRGaWV2bURaVWRxM01TWE5ZdUVadnlVditISW01SkRX?=
 =?utf-8?B?b3FYZno2cGNxcHVXMjhKRWtsUDZZMTMwWlVFN1ZJRm54dERlYmJTYy8wQnpT?=
 =?utf-8?B?ZFFPNERBQ3E1eWxlSG96eDM5dmJCQTkvVUhMVmFhK1N2bVNwb3l1K2ZIUWRH?=
 =?utf-8?B?ZTQxak5iNVpOOU54Z0p0WTl0SFNzZGpkNy9qd0dsaVJQRWpZRVc3cFhjZzVa?=
 =?utf-8?B?aUErWVZRZ2M0eEhMK2RLR1pmZkVBdUl1ZytOOFZMc0cvaS9jb3hFekZvbDg0?=
 =?utf-8?B?Y1M3Wjc5RVJYOWgreGNjVlZIci9VWjJNOWY4dm1NNWZyZGtxUFNyeS8zOHAv?=
 =?utf-8?B?cUR4dTNuRnprUDMwaGQ1RWhPK3R0enVpTFYrSjFyT3ZTRWxIRkJlMS9lSVk0?=
 =?utf-8?B?R2o2T2NZNkY3WW9EemNsTEpObjFxYnJTNlcxQ3A3TE1Uc01IRzJDNFNneHN4?=
 =?utf-8?B?U0hpc0w2MFloRjdlSzlMaDcrbThCRDhuYWZOcytIRG5DQ1pNenBiQ2ZMWFJR?=
 =?utf-8?B?UTZHSEYrZ2g5cHdWVXFvSE9VOWhwald0cWZYMEtMMGlDWVZlMmt0bGpCSStm?=
 =?utf-8?B?SVFqazE5ejNMM0hicVFFT0xZOUdLSS82K2J1d0F4M2Y5QlJ2S3c3elNuZWlj?=
 =?utf-8?B?RjZKK2R4SUtaUnJqdk40dVFvT1pab1piV1MwRXN1NTdCUjJOcGpONkVVeTFU?=
 =?utf-8?B?ZVhTaitBaTVlNFlHT3JqeVpTY3N5dFR3cFZraTcyTGZWODBHWXl6ZnJyWUdF?=
 =?utf-8?B?NkE1YTBsRlFMOThHaDExd3Z4ZjRNc0FVN1FvOS9Rdk9YRWNJT3dTM0VLTVIv?=
 =?utf-8?B?dVB2WkxuckQ5NlpwcVFBbjA5Z3VSbXRBM3B1NGtMckYzVTI4cExUamRFTGlI?=
 =?utf-8?B?MnVCb3pnczBzT3dhODhsRDRmUjlVMnRkQTNKRytORDB0RytVWnpzL3lQaUg5?=
 =?utf-8?B?ZjFGeFllN0l4S3BOaFIxdHhGRjBWSE5qSDJMMTlPNi9nZTBiSW1YN2lFN0R0?=
 =?utf-8?B?aHhoTW1rRmxiL0xyRTlmbkRtbWliRHN5c3VRSzhVRDVRV2k3QlduZmIzQjl5?=
 =?utf-8?B?c1E2Y1ZuRFMxVFF0NC9mYVJNaWFYQVRiaUtoVlNRbHhMOGxycWlmbjduNXVt?=
 =?utf-8?B?SjdPRTBGaDl2YlNhYXd0UVFMK2dkeE9XUUhOTytadWRyWTdYbW4rTlBkd3hV?=
 =?utf-8?B?alh1YkRsVHdPRitBaXZWZUlaSTJodzJQOTBEaTBrMGhDQXUxMjlKTmhzQ3Nh?=
 =?utf-8?B?NEQzbHBnSjVoRDRtOExVOGxHRks1WHQzaFpPWExSV2hNbVBndHZmQzdvYnlS?=
 =?utf-8?B?d3lodDRpcFZsUkxDQ0dWdWpTeTl0YmhiN0RybkhQckNzOEpWRjllREpXYzg5?=
 =?utf-8?B?V2NjTGgvMEp3OWRNQlc1SFBaQkcrWGxnd010cGNsbWdNTGh4OW5NaE1Vbzc4?=
 =?utf-8?B?ZXZ4QWx1WW9xdHpsKzlRV0szN1I3YXYvUURMSUYwYWNKdzRkaU04YWduRUI5?=
 =?utf-8?Q?mNYuxSBHQnlx/WzYTd?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: TqXrgplXJJekd4XqS54a12BSl2Pe8JUZuTiut9vXVlg04ndsZSfact0HLwe7sf7/i6thQsAdc+9M2mdFQuW7AheKX57l2Ug+Zu+F+dvnv+ZrBDQ4kCmkPxqKnwV9bxjS4w//3jDw5Awflqe413adbF1PvA/mjobKUJklALbJKiWFyymbXIJtmD4BLC/wADx2fPEEJivzj3k6oaV07lLp5YCB+OcfzpgbWL1WQVUFiTVwFPa6XIiWQaxThH7TKRfxLBRiWvDbPWR9wKbrWFapgMCv73JhmQDw8bZlnhHnXJHAcRMRAuO4209qK/Trst1Korl4pz1j2AP3xhrRsikNBw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66316d79-113d-48e0-e70f-08de9b1af73f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2026 18:15:24.7738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wF4jBgP+vt6ULc15Uc2FrMJHntkDW910Z89Y8iT6HrXNu2MIXmzV9s+pl8vOsu2NUPHnQ4g1sHakF9AO9NMBhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9345
X-OriginatorOrg: intel.com

PiA+ICtzdGF0aWMgYm9vbCBpc19tZW1vcnlfaW5qZWN0aW9uKHUzMiB0eXBlLCB1NjQgcGFyYW0y
KQ0KPiA+ICt7DQo+ID4gKyAgICAgICBpZiAoaXNfdjIpDQo+ID4gKyAgICAgICAgICAgICAgIHJl
dHVybiB0eXBlICYgQklUKDEpOw0KPg0KPiBIaSBUb255LCBqdXN0IGEgbml0OiBmb3IgcmVhZGFi
aWxpdHkgd291bGQgaXQgYmV0dGVyIHRvIGludHJvZHVjZSBhDQo+IG1hY3JvIGZvciBCSVQoMSk/
IGxpa2UgQUNQSTY1X0VJTkpWMl9FUlJPUl9UWVBFX01FTU9SWQ0KDQpJIHRob3VnaHQgYWJvdXQg
dGhhdC4gVGhlIG9sZCAodjE/KSBFSU5KIHR5cGUgYml0cyBhcmUgaW4gPGFjcGkvYWN0YmwxLmg+
DQoNClNvICJ0aGUgcmlnaHQgdGhpbmciKFRNKSBtaWdodCBiZSB0byBhZGQgc29tZSBWMiBkZWZp
bmVzIHRoZXJlOg0KDQojZGVmaW5lIEFDUElfRUlOSlYyX1BST0NFU1NPUglCSVQoMCkNCiNkZWZp
bmUgQUNQSV9FSU5KVjJfTUVNT1JZCQlCSVQoMSkNCiNkZWZpbmUgQUNQSV9FSU5KVjJfUENJWAkJ
CUJJVCgyKQ0KDQpSYWZhZWw6IERvIHlvdSB3YW50IHRoYXQ/IEkgY2FuIHN0YXJ0IHRoZSBwcm9j
ZXNzIGluIHRoZSBBQ1BJQ0EgdHJlZSBpZiB5b3UgZG8uDQoNCi1Ub255DQo=
