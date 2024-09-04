Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DB61DEFEA
	for <patches@lists.linux.dev>; Wed,  4 Sep 2024 15:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725465114; cv=fail; b=Xulu5QgC3TA43IxcjOW2pTU0pHwxEDA3eCxhuPbbRsd0sVkZLvrwo23/vHDqr/INw4vy+Vm/OWks1+DL296Ca2Dp86S8tzqSSD4+yrKWw+OzTmbWbKW2+rnIe/xcyQmeRve6Bim7VEpZiJ+F1MEoaykUE608J9I/lrYQ1hnDOJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725465114; c=relaxed/simple;
	bh=Y3qDNa/vdgN9Wyg5MfeQAxg772sqvqaueLXenberHMQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WbQUuSaQ31iOZsRH1yBy4u+HZQK08G1aVvburPEQTNt5gb/gxpBVPT5ej7gRJAMTBzgEwsdnGJxgUIHzYOHmjyokDBwiFE3Ue1zY8fClAUo4y1fBE8eWyydCYpAydKe1Ht3e1vSfkp245FeRYw8NhpiVHYvSSKsRmLBmlhCUW28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DLARTaGG; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DLARTaGG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725465114; x=1757001114;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y3qDNa/vdgN9Wyg5MfeQAxg772sqvqaueLXenberHMQ=;
  b=DLARTaGGmv5Z0skH+CN9Vb3WmMmmsaMCIcnPcJR1FeAJ2CedU7kn2mYn
   YE6UrB7hvIO+Io9uyjeD0o8gZsFLid/IJ4tvwFYWTahFSKWn0yy4H6SeB
   M9wmUHnrr713WOCCPB2Q/P42pzKyaiAZN0yNo1pHrKbUxgZSf0WQRMvAV
   6VjEXDtHp7ffOnZZdWDkEpV1JzBQBf4hIScWCHhD5dT79mpx+aCpjkGOt
   0Z7qiRb+bO7cBGV0W2PNMvyG89bvi5KyetawW+fChHrruDV7vK3PKqr5q
   HxUHB6eew/PNn98RQ5P/r8i6m4dXqhbUnBkeiPZJ97pR5Krt00PKu/TBk
   Q==;
X-CSE-ConnectionGUID: dielrw7BRGO0ky6DzxcHmw==
X-CSE-MsgGUID: 9eITyggeRSWP5c7Mrp260A==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="23699095"
X-IronPort-AV: E=Sophos;i="6.10,202,1719903600"; 
   d="scan'208";a="23699095"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2024 08:51:52 -0700
X-CSE-ConnectionGUID: n4muUdsuT9O3IA6WVYgRKg==
X-CSE-MsgGUID: hM5M8xMBQgax3m7zjWW3Yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,202,1719903600"; 
   d="scan'208";a="65153172"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2024 08:51:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 4 Sep 2024 08:51:51 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 4 Sep 2024 08:51:51 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 4 Sep 2024 08:51:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ly2mnaKfVphjIdmdZgVPEdMIARODQrQBKE3almEzzRM9xCAqh1l/ojDljXLcdqhKh5F2p1obSqUKel4MldptnY+ZAF6DYQBuQQNh/gGacjmbonowx9U53Zpw5AUzcRltIQaI3ni8asaew+sowhSrcXW6SoZhBLF5m0g+srGe+CO6DLdve5NnwCudN8/kLZjvgxtw5JU6OcIO8IzIKe6Z6yjYjmIEXdl/M+JcAje9+bFyh6iPAUkRS1wZqVW2uHIVWCphIkjpoZzXuDEf1DPFLhH+Kau5RDiUUDGEh7FMypF90Zjoe5moEzh3di3wbj94W57SBibJQHYvRAwjeGzglw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y3qDNa/vdgN9Wyg5MfeQAxg772sqvqaueLXenberHMQ=;
 b=rTgSJ8DvgYR5UC359jJtcQ/Bsch6ES4TkkNiS1kufD6CgtSSRIgFbLYqzWFsKyMg9CIH8idI5bbV08mXvTXS6C8amgYePRi3IENBgGQUSSO8xsYM/1OTor5FrQ/Bx9u7gY28WZNhlKZnsGAR60SM2fGHrGjz4Js8sUjEFOHPowKy7ugLAB7738F6+rFl1ApEQJZeWmSBTJD0RrEnkKSCZrCdVHcedRmpD31gH44nCxumpe/rwgsCIQikeedMtKyLfigXH5e21N/JziQphiXt4U9d0LdDT8o+PKcvrYy1PLDaTy71cOby8jT0AmhLQ/Z7+ofzLxCt4DQrmNl2sKtzmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DM6PR11MB4676.namprd11.prod.outlook.com (2603:10b6:5:2a7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Wed, 4 Sep
 2024 15:51:48 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 15:51:48 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Chanwoo Choi <cw00.choi@samsung.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Dave
 Hansen <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v8 0/3] Final pieces of Intel new families support
Thread-Topic: [PATCH v8 0/3] Final pieces of Intel new families support
Thread-Index: AQHa/ievli1MwvGgF0mLTuludertk7JGcimAgAAEHbCAAPOYAIAAXaaQ
Date: Wed, 4 Sep 2024 15:51:48 +0000
Message-ID: <SJ1PR11MB608305FC20967DBC2E0DDEA1FC9C2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240903173443.7962-1-tony.luck@intel.com>
 <20240903192655.GCZtdi_w9xN6z9hPGV@fat_crate.local>
 <SJ1PR11MB60832E477464FFA09B248CE4FC932@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <20240904101330.GAZtgyysjdKRJ9sBPj@fat_crate.local>
In-Reply-To: <20240904101330.GAZtgyysjdKRJ9sBPj@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DM6PR11MB4676:EE_
x-ms-office365-filtering-correlation-id: 892f5458-dc64-4cab-5948-08dcccf97c77
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bzJzOC8vczhvZEJPT3VjcDArKzVwb2R1ZDRZK2tDc0JYeGJPVVlyRHdKWXd3?=
 =?utf-8?B?YlRvdS9qQnZhTDVjZ2Y3aDErNkFyRUErR3ZZdGJKcmxPQmxIWUtnSmpRWXAr?=
 =?utf-8?B?MG0yWHk1MVdLYURmOGZFeTdteUJHNXhwMmUxbTcreWdOVDRRQktGOHR5NlZk?=
 =?utf-8?B?SndERU8rWG5oU3FBSXhuQjZYZUh2WS9ZeCtqNTlFS1ZEcEp6ZWc2VFYrcE5K?=
 =?utf-8?B?QUNmUkV3YU1ieXJHaXVGY3FiR2tMWmhMWHovRy9ub2tBYko5ZVVyNWdqd3Nx?=
 =?utf-8?B?dFAvVG1nc1pOSzh1bjRiTWZNU2ZtNGFGUjdVZzA5YjV3VkJLbnNZdjRJOGZE?=
 =?utf-8?B?d0hGODQ0MlI5T3NkbDF0Kzd0ZjlYZ0pBQUVZa2ljUzhpNENOSzRabnhLMkxC?=
 =?utf-8?B?WDF6RE5oYW9VSjZOSmwyRHh6bU9TbHJ6VkJOdjdyeHpvTUdiZUR5WmlCV0Jt?=
 =?utf-8?B?dHYxU0tVTm1qZGI5ZWVBTDAyaVlFeDUrMEVBK284SXZIKzRKU2VsRlcvZzBL?=
 =?utf-8?B?WkE3WUVaN081WE1KOWF0S2hReWt6WDd3SkRHVkF5cDc4RkNyM1FINTdiZ0hT?=
 =?utf-8?B?TWNyZmoybUF0UFZiNk1HRzA3TW9tLzZOSTNQT2VuR1kweGtobzhHWDF6ZC8z?=
 =?utf-8?B?M09JOUlXeXN5UEhNcWwzREdZS1RPQjlYcG1HeGY1dmxIMm0rSm0wZEJjdVB3?=
 =?utf-8?B?eUI3QnhKckpRSVk2RWpEdTcvNEZDT3dzdmgxNUlITUROaW04bGZwNnlxcklG?=
 =?utf-8?B?UWoyZU12cGp0aHhiZEJrS3ovcWdUT2NlZEZUaXlMRGR4QWxFOVE2djVuWHNN?=
 =?utf-8?B?cjBFWkh6TloreUt3VXg4MzBIT2w0Z2tDWDNMS0E1U0hOUjBkNDgyTUtuRUh3?=
 =?utf-8?B?QWpwOTByU2ZiUkNsRjVRc0R2cVR2dDFCVnFGakxxVVZwNXppejhpb0tqMEh3?=
 =?utf-8?B?NHIwc1pHdjQ1cmtTeEN0V3BlM2J4Slo1TUNHQUV4WUNsTjhZem1KMHp6eUNt?=
 =?utf-8?B?dHJjUDhjODVVZEpLd3JNdndZSmdCa2luZzhkTjNNdWJwaWFMa0drMGozV1Jp?=
 =?utf-8?B?dkgwN1JDNXI5K09md0ZhZ1lxV2gvZzNEejJQYTZGL3dEOUlvelU1YTk2TGRp?=
 =?utf-8?B?eVA4ajl2eCs2Q3pCbXNCU0FJc0pyV0NndjcrMXBIeHJFcFVwSUtOeWhMbHg2?=
 =?utf-8?B?Z3pNLzY2MFQ0UnRvbSt4cWcrSHY5ajZWSUR3TFJhRDZUa2Q5QS85ZVdyMHJq?=
 =?utf-8?B?OG96MStmd1hmWDNSOTFZTzUxS2hsMm5EZFlzdm10MldYUTN6YVBMd1dneU0w?=
 =?utf-8?B?MzdXZ1RWN0U4Wm1vck5CM2VVc2I2L1diYVpscDEvb0JVS3VySUMvUlpRQ2tZ?=
 =?utf-8?B?U0szSWNFdWIvTWNQa3dxQmRDWkJLSEVGbTkvYXJYdEtIN3J5UFk4ZHFuUXFz?=
 =?utf-8?B?dnU5d1lXYkQ4VVliKzhNUXBDNWQzMlNYRXFoRTdzdUxrTVloUDlmMHdjV1B1?=
 =?utf-8?B?ZVNHK2NjaDZpSFB3VzVIQW5JdFQ5QVFsZWh0dGo4Q3ZrZWRzNDhhWHVKSC9B?=
 =?utf-8?B?Y0RDKzM0aDFoRDdkMHRSN0kycVVGUWMza2JYeXBGWFdIRCsrVFMvcVo4OHgy?=
 =?utf-8?B?UW1rczRvY0t5SVVnRUhrb1ZpeTVPUTl4WDcrcTZsa0xkMW55NmtkWXJWNTg4?=
 =?utf-8?B?OGt5UVZCYVl0SmJQWEwwd0VBZENZRzl2amFCY1d5VFhlMjBRVzd4RkgwYWlQ?=
 =?utf-8?B?UUE1T0JDZUlsRjE1bWM3Nzh3QzJ6VmYzc21KQkJuQThIajcycjVDdFhaYUJO?=
 =?utf-8?B?WWNGZDl3anUyU3hkSTV0MEhUR2tPYVkxRjRyNnE3c1B1WUVnQ3lhcmFoRkU1?=
 =?utf-8?B?ZUM5K3NQekxUZkVnSjE4NVIwb0RCT0ZQMzhON2dLM0ErR2c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N1ovcWZ4ODVzTlJveE1odDFTYzdPK0FpTmxKZG1TZmZrd1hFMCs4NG9Kdmt5?=
 =?utf-8?B?OWVhRFlPYjU5SU04aTNUNFFTMGg4VzV3RWNPekpDU3E4N2F2TXRFSThqNzBW?=
 =?utf-8?B?VEx4eUg2azFsTW5lTjZzTWZpSEpZMERHMnc4ZmRYT1czVlhBOFNaQXhwRjdz?=
 =?utf-8?B?UWlPUjNxa0FGd0dSTVE1dWdnNFAvV0dKOTBTSDBkN3ZVeTlSMDVZN3gyUVZ6?=
 =?utf-8?B?NW14Y3dDejFxSkZuL05BdzAyUFZ5YUVxeWUxRWlET2JlcDcrMWdxQy83TVFk?=
 =?utf-8?B?TStlb0p2RjhBWEVpK1MxZDVxTUJwL2h1UWUwT0pscHdHcTQxMVJ6eVFFUmE3?=
 =?utf-8?B?aWNaMEh3dXlIa3loZkcwd1pkZisrWG03NnkrZUU0aGM3V2trRW5kaEhzR1Nq?=
 =?utf-8?B?UXlrM0tvaDB3dklGbUdXUjNJakZ1Ym5KeWg3UTZjVDlrRVFNMXY5RlFVRkN6?=
 =?utf-8?B?TS9SQktrRWlxQys1R0VObHYzbWorSkJZM3V2Qld0V3BNVnZZK09qWXNVTldw?=
 =?utf-8?B?UzNPMDg3YUpzYVRCa3BMd2dxbCthOWhpY2Qvc0VpWjl5Y2xNZTRRclJKN2FS?=
 =?utf-8?B?VWxzeVpXZ1djUkk4aFFGeTc2UkN5OWlHREl2OFVTL2lCM2N2V0I5SGIwczlz?=
 =?utf-8?B?Y29adEN3eVkzR0xrdDBlNkV0aGNvVXdkQUt2Y2pjdmtaUDFxamlqZjFMYUJI?=
 =?utf-8?B?WWkvRE5ieDhPczNTc0pwaWFZYVlLeVNoUFNLMDREemVjTk5Zc1FKT3ROYmFG?=
 =?utf-8?B?cFZDeFQ2RXh3enR5bm80amtZVGVTdUZFemVwejVNcFc2SmtIWTc5Y3RTTVVr?=
 =?utf-8?B?VklEU3N5dStNOThtUEhTVEpqNXlYS2F2ODJYZ1g1NDFTdzlLNEV0KzNhblN2?=
 =?utf-8?B?dUdEQlVVU1AzR1dGQ3MzUzAzZERqeGZiYjBqSHYyWmwwV2FUUi91TXZtNG0y?=
 =?utf-8?B?OVV6OVByM0lIVHNXcThrek50NExaZGIxNUwxTENOUmQzcDJvcUl4TUZxR0pq?=
 =?utf-8?B?WityYUJiSE9yVlhaaWpkSVJmbUlqU29oUWc3N3MxVElNSSttbGxoTHBrMnhJ?=
 =?utf-8?B?KzNscldMN2NEVHZ0TDFGNExUVWkwRFNSYzlFZTdkTjdodG5QOENWMWZKT0FZ?=
 =?utf-8?B?amZKdC9heklQT0s1UFplU3JOd08vN091cHpXOUVrTDEzSWdST3hTcmMxcW8y?=
 =?utf-8?B?TWt6Uis3NHlIMUc0R3VaN29HQ0ZiL21FbnovVytTT2Nkb3YxNU4yTmNselFp?=
 =?utf-8?B?WWpoTEJtVVo5aGdFSU9aNW91RThNcTRyenhIb3JFMDdacmJoY3h6S1puNnJs?=
 =?utf-8?B?TWx0OFo1djhMZ2ZacTc0d3NNQUJTWXJ3djMzM0NwR3NxZENka1VLc01hNmxV?=
 =?utf-8?B?cE1ZNnhjcXVkbWpxNk5xTXRmY2pud3doOEcydGdkNlJvaW95KzZXdUxPWERB?=
 =?utf-8?B?YnF2NTJtOEYxVFg5S29oTmE3ME5KZmFKRjJaams4UUVPcUhZRStQbllqL0Jt?=
 =?utf-8?B?cXd3RGhaSG9UUlNZeC9ZcXArTWkvelA4eUlxajY2aUhtSFRTdXBOY3cxUFZm?=
 =?utf-8?B?T2MzWGE3M01EZmJjOW5ic0pQL0RtYWxOVW02cXFyV0VUOTMyTjhFODIrM1Y3?=
 =?utf-8?B?M2FoKzRvYlFHOVlsOXFTQlA5NU1Cc3RVeXR6WlpzTzMzdm55dGtSRGR5cnhI?=
 =?utf-8?B?TEVFZFJ3ODVEUlpvU1FpV0h5QnlhV3FmQTV0TWQ3cElCRWZnOW9HSXpObFRa?=
 =?utf-8?B?Vmg0Umh2TFFmaUQ0dUE3THFJaGFWWExia2k1OFdrWUNUbUw3YkJtUzVYMlRq?=
 =?utf-8?B?bDhuemIwN0Qzem9oanRBZVBNWTlMVE9taksrQlRHUWxsYWxlR1V4R0grYTBS?=
 =?utf-8?B?bkV3L3FsQWdmb0RyTzgraW8xUzIwditBS0hNRHlxa2kya2VUdVIzOHdxV1g5?=
 =?utf-8?B?VUVpTG50LytUTTRGMjU0R29ucDIycThKNXV1TzBZRFlKWThkSlFmUjFOYzFo?=
 =?utf-8?B?N3BhTjdKNnArSTFlOER2MHRDczBzTGRxcldKVnFpLzUwQ2NkSFF1V0Z4ZExF?=
 =?utf-8?B?Um9CckFsbVdTSk92UGNUY3g3N2U4T1hCWkFmckdSZUl6TEMrc2h0NHRFZ3lU?=
 =?utf-8?Q?Vqulqo3mzICRHYqdC8EKt8mj8?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 892f5458-dc64-4cab-5948-08dcccf97c77
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2024 15:51:48.6624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BsZ1sS7cFBSHf5wqoMNjN0zzkSUwc/CLReHrVsV7sCSXel+yxwK9S8xqMyMxQ4kgCr5+o7TAGBRKcljFeg4/3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4676
X-OriginatorOrg: intel.com

PiBIb3cgYWJvdXQgeW91IGRyb3AgdGhpcyBwYXRjaCBmcm9tIHlvdXIgdHJlZSBhbmQgSSB0YWtl
IGl0IHdpdGggdGhlIG90aGVyIHR3bw0KPiBhbmQgc2VuZCB0aGVtIHRvIExpbnVzIG5vdyBzbyB0
aGF0IHRoaXMgY29udmVyc2lvbiBpcyBkb25lPw0KDQpTZW5kaW5nIHRvIExpbnVzIG5vdyB3b3Vs
ZCBiZSBhd2Vzb21lIQ0KDQpOb3RlIHRoYXQgaWYgeW91IGFwcGx5IHRoZXNlIHRvIHRoZSB4ODYv
Y3B1IGJyYW5jaCB5b3UnbGwgbmVlZCB0byBkZWFsIHdpdGgNCmEgbWVyZ2UgaXNzdWUgZm9yIHRp
cC9tYXN0ZXIgYmVjYXVzZSBzb21lIG90aGVyIHRpcCBicmFuY2ggaGFzIGFkZGVkOg0KDQojZGVm
aW5lIElOVEVMX1BFTlRJVU1fUFJPICAgICAgICAgICAgICBJRk0oNiwgMHgwMSkNCg0KdG8gPGFz
bS9pbnRlbC1mYW1pbHkuaD4NCg0KLVRvbnkNCg==
