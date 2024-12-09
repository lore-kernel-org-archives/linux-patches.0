Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B587913775E
	for <patches@lists.linux.dev>; Mon,  9 Dec 2024 17:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733766801; cv=fail; b=d7IgKPfytO+nQIzzhLPciuiHIQgOzzIlJOB5VdYx/zUR2z8JU+RLP3yFk+ETQgV7+3jfeO1Jm0mf0DWUiVOEFC+UcE/XmxD3aIhGhznsixPTId37ZWg4KQfp+ql/mMsKXHmpnWaS7fNnk+WPPxk5ZONm5Xg5Sz6CDC3niIVfAxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733766801; c=relaxed/simple;
	bh=rn0gCeruox56Z5qdemXR4jwPMAamwlJQQOCVExDo8g8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=INnbXAd8vLz5k70OxTM/2fzglr0AG8qdD181EL2WMk4J+0petekp56LhwD2iLUP60dh69ZyTRRPWD39vCmVoXJKazNBRAmje2iW5Oy8/e3MdZUVqicEQPZHHSmhKutMAf5YHR2VidMMlBE+2T3Czma0yI0n/U07gESkG56vBzFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DFZXi8IR; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DFZXi8IR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733766800; x=1765302800;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rn0gCeruox56Z5qdemXR4jwPMAamwlJQQOCVExDo8g8=;
  b=DFZXi8IRncJCOtqxWi39oJ2ucTLTJxSCNisigRYhp6KL6jBD1LRyCICu
   +A1H+Xlg8ppllJXMfjoAEv/7WmmlRbRFQ9xuwNTlKJtCYKVnwzxU3WUV+
   8YEDgXuWWcBLdC42jj616NQ0RIxKOERhM0uZcXJVI0Z7CBzQx0dc9EPTh
   IVy4cvgVHtQr9UJweK5WQMsyuvjNNHLQ8w1ve0anjzMSfNSmIhdLE5Jez
   4YkFl0cneLwnXSEFnkTS54gf/D6SliSm3RMCjyTS8VhdkkU1BAPet+eJu
   bEVjMcX8rsLDZegOd7OgzE96sXwEQsMA1rsODEjAz2Lf+mi5Gyu2PNu5J
   g==;
X-CSE-ConnectionGUID: JkYvd+AATCqMg2m2XpuHVw==
X-CSE-MsgGUID: 5wN3K1q0QUKhpaPLAP1/hg==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="21670342"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="21670342"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 09:53:17 -0800
X-CSE-ConnectionGUID: DMCBWk1HSyieZrd6xY9pEQ==
X-CSE-MsgGUID: atxUv/XTRQqJtdatBXWycQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="125974666"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Dec 2024 09:53:17 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Dec 2024 09:53:15 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Dec 2024 09:53:15 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Dec 2024 09:53:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LNrhlenkzZcj61kdwvkPc++XjBOYuUiq33L9W0Bjj7lHQii/LUSkl3yWYXgKU937ynXx9wMqjHSYnDLG6KpA91jnD6zTVy5pq3PL4LzU48viw7Xo1HBbrPO+tGzLg9tE++7SnHEeXFQzdetzgYNpgWsynWuI+h9tIJGTBF9v884pBiY3i5zbzm9fsSQIl2VQfdI/yHXb4nT2/tPeQ0HzSuUdyjHX01iAnxXavEJCVMRhShzpBMD5R+v27mCa/yOlhojMQ8nDwhZruPZ66ZJFexotbbSrQk+uNltfQhppcd3OnTEQfTN4ELTd/sZ/kcQzz76jmGQsgBwMJTrNKapAhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rn0gCeruox56Z5qdemXR4jwPMAamwlJQQOCVExDo8g8=;
 b=szjCElpGJqj7xZgxIG5EPORoeQYJbeRDDRRXW6mGozUGHpZ0qePTrjHsvEBJfCqnX4WPEx6DF6Xo4CXtNlqTxXf3yUaxT/Cl0ieqdAEjrb4hWn99uBRyPfl+RUUQ0wYeH2yQqDStP8RxC509/d4n6+ituWh/THFKJC41hfuOGmaqlUQPoFCFIMZ/lW1wjitwweVYuWS1g/erojoLizDH/OpNqYhcW/xismlXLQILrUJKo0d4gLwjvMncgqpcv/lLTjN9K+Xyqqxhb/xSd56oP/NPRdoZJkoDosLfW04Vh7Ar/A6yDRlL0n7l5lmSLy4t7R1FR+hcJBY0Vf4YvrpA4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH8PR11MB8287.namprd11.prod.outlook.com (2603:10b6:510:1c7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.17; Mon, 9 Dec
 2024 17:53:12 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.8207.017; Mon, 9 Dec 2024
 17:53:12 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, "Chatre, Reinette"
	<reinette.chatre@intel.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, Peter Newman
	<peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>, "x86@kernel.org"
	<x86@kernel.org>, James Morse <james.morse@arm.com>, Jamie Iles
	<quic_jiles@quicinc.com>, Babu Moger <babu.moger@amd.com>, Randy Dunlap
	<rdunlap@infradead.org>, "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v11 0/8] x86/resctrl: mba_MBps enhancement
Thread-Topic: [PATCH v11 0/8] x86/resctrl: mba_MBps enhancement
Thread-Index: AQHbR/xiEtrWpna3wketXHoeFXA8OLLeKnoAgAAFNoCAAABj8A==
Date: Mon, 9 Dec 2024 17:53:12 +0000
Message-ID: <SJ1PR11MB60834A5C5D99F3BE9F2CF0DDFC3C2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20241206163148.83828-1-tony.luck@intel.com>
 <7e7c01c5-f64f-42c3-9364-ddcfd01b25c1@intel.com>
 <20241209172859.GHZ1co28T-rRiQtIMp@fat_crate.local>
In-Reply-To: <20241209172859.GHZ1co28T-rRiQtIMp@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH8PR11MB8287:EE_
x-ms-office365-filtering-correlation-id: 289bc966-8472-4905-0d9b-08dd187a59c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cVFIWmRQQ1JNT1JKMjlja1d1aVBKR3doZDluZzlLQTdvbHAwWFllaG5aWW0z?=
 =?utf-8?B?VjN3amZHYkJvekZ3UytZOG40S1dsMUJoazhqc1Flcmt6ZWcrNHBjMEVpYmdN?=
 =?utf-8?B?VW10b2V6djJ4SXlZRzZXMDg2MmtDenlSbE5ldWRMZ20wUEhxNml0amg0MER5?=
 =?utf-8?B?ZXhMblpoV00vdkFmajBVODlpaVpSdnRGM2U5NzlBcmM5clZiM1ErSW01U0ha?=
 =?utf-8?B?d1plNUh5V1pHeXFHbGlpMFh0TWZXc0tsV1lpVVdoY25GK3h3QUlGSUZuNVZE?=
 =?utf-8?B?NnVOM2pSMHNWRWZDbTI4dVVRSE5ucGFJT0JuanNrUEtVMEF0cnptNnVhMVNL?=
 =?utf-8?B?WTFHbktqSWtJZHdQRG9hKzZmQzROUUVRd0Uyc1RyZWQyQ01jS0tkUGdBY1J1?=
 =?utf-8?B?ZDRrdWVWaXU4R3pWMWZBVmxrVDRXN0wzTTA5SCsvMjNhamZOWXp0UXlhbnVO?=
 =?utf-8?B?ZVA0anFzUVZaczBiTjg4ZmhHSDNabnRTU3lSNTNiWDhaV3FnemJNZUszbHI1?=
 =?utf-8?B?K0Q0RkdYekRCeHhJdGttcWRRY1hOeVZ5V0U1cjZPSVBlZFNxdnNmUlF3dFJM?=
 =?utf-8?B?TGVkZGtUUVh6YTR2QW0zZTVqenBhZ003a3YrTEkwc1ArUDBWZlVWSmZma2Nk?=
 =?utf-8?B?OGs5NHB3a1gwQmJXOXVkQ2VEVzNQQXpOUFlQeHNibGQ4ajFldlBiYzJreEQ0?=
 =?utf-8?B?L0JPcklNMlorM2lVMUNPV3ZEZzVNMFY5N1pSMjZUbWZkaVFlMEZDM0JObFkr?=
 =?utf-8?B?THMrSTVZK1IrUmdGK3FiVy9xcWJjNWtjQStTcUV3M0JQdXQwdHpSMDhHbnhj?=
 =?utf-8?B?UlNkVVR2OEhEQXFuQ2RSL2UzbVpzUmg5WElNNDNGWjU4S2tWNml1MDJHNGh0?=
 =?utf-8?B?RXBuYWcydVZjT3lqZHJoYXBwUlJSUHYrK244K3pMR3N5bHN4cERsTWxBRDA3?=
 =?utf-8?B?R01DcjFrNlUzaG5PMXRuT0xNNnM5b1dscHNSVXpzZFpUVUF5YjFHN3VTdDM5?=
 =?utf-8?B?SUFqbEFsOUI1SUJlckFQSHJuYXRBUHBmL3pSVVR2OVZ4ZGFwL21mZDJGUTJM?=
 =?utf-8?B?UmIzcDNMNjVyc2hpSjZvSXU2aTh0ZXMvbFozNzBrRnFIY1pzOGJNT3dyV3Ux?=
 =?utf-8?B?WDlDcW5kWlJDSDdUZUJoK3dsQUZzZEliWEpBV2lwdGYvK29lUVlzVHdLNDNl?=
 =?utf-8?B?aExDdWRQQTJnVHpJcUVrcnFyWnBYemJxeVZlSk53OXlPMHBobXRUd2hwSDdq?=
 =?utf-8?B?K0dqYmpwSURJQ1l2bzEwK09kMWVmN1FadGUzeTEyVEN5eDZyalVWMEdGOHU3?=
 =?utf-8?B?cHRUdE8yRFNkWDJyUnFHM2UxZmVWZFA3TVJQZWVXZm9ESVBXQWdpcmZ5eGsv?=
 =?utf-8?B?YldFNDBNL0EzazBkNm5pcEVIRVQzZXJLUEhnalpSaTRHeVZUUWxiZllxOEo5?=
 =?utf-8?B?QmNlV0srZURnbFVmT2s3YVRhRTF3eXliY3FjVDZXdHMxWkpCaU1lTzBITTRv?=
 =?utf-8?B?d04xZ1p1MDh0Y281dzZaMzhnODBPQTdCWXZJN3hIdDl3VlpjZ2lPRlRIbzR3?=
 =?utf-8?B?eG1LUzJIZGVpcm5neDg2UDY3c0hiWVBBSEwzQ1ppZmRRTy9YdHp2Y1BjR2dJ?=
 =?utf-8?B?VGVtaVRNZXBLdzV1SW1XTnJIYXNrSVJwazRuRSt2UjM4MFF3Nndubkx6QlI0?=
 =?utf-8?B?K1E5MmpQalVxZzVTbFU4L0MvWkJDQjg4c2JPYzlyRFdMTVp4dnJTR0QvMWJq?=
 =?utf-8?B?Sm8wTmgxUm10YzlYSzBXaFFhcTJYSENFbm43dm5Qc01pU3ZXbFI4VmJOc1Ft?=
 =?utf-8?B?Qm10dHNEajZrK3dkbmRQOVlKQmNpcHFCV0pMTXh0T3p1cUh0MlU2V1dTa3BQ?=
 =?utf-8?B?YUd6ejNIZHZrRnVsY3pOL3FLcGVaZGRCOE9TQThacCs0NUE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2k5WTBUQ0pYdjlJRmNMWHBydnh4NzV0VDUxb3p6VDlGeU15U0gvbG9DMHFl?=
 =?utf-8?B?L1lsK3JCNUhVVHM5clg0Z2JUaXZnb0dad21lZ1g3OC9kSEJXa090UUdEVjVm?=
 =?utf-8?B?aDQ2Y01RWG1uSDlXZXRTY0ZVSDVBamRkQURJUkdFbkNIY1ZtazhhNklRRUt3?=
 =?utf-8?B?T1JES3VQYTlTRzlLbFZEbmZGVmlCcXljNTRLbFJwUDZxNHQySkxEWkZaRkhu?=
 =?utf-8?B?L2ZsYXRwMzAwWWZwSWo2cVRBa1RwNlYyYkp3Z2RDNzZGelBUTzRoWmJPbjRQ?=
 =?utf-8?B?eFprejU4OEQ0ei9KOXlhelpJMndnZlEwK1dQV09GQkJwNkhTMXNRQlU4MEdu?=
 =?utf-8?B?dXBOK0FCWXRpUkpkeWwzVnNTQmhsZThwL1JrZTJLOWkvY01WeWhBbUNRZDBw?=
 =?utf-8?B?NGVWQVpEd29wcGlBVCsvWjJkU1Jjb01IK2RBVnpObi9sWEdrS1piaVdUQ0Mv?=
 =?utf-8?B?SC9qSUthVHR6eXR6QmgzbjcwTThtMDg4OTV4S004L3dyWFpubHI0ZkxZdFR4?=
 =?utf-8?B?VjYyYmt1cVdFNHBWblZ4MURyN2dkVFNpR3ZWb2YxU1ZTM0tCK3kwcGdvb1JQ?=
 =?utf-8?B?Z2xnSHNxMHM2M1hEc2NEVkxzUjR4ekxhUUtybStMU3l2MmVLS29mTkdwZXBJ?=
 =?utf-8?B?dVErbXA2ZzVPVmxubDBRN1NSeXE3WjdaZ2FuQms2ekhuRGFDUnp2SlVoYkJ0?=
 =?utf-8?B?RXRkN0M5N2ZjSkxPNzJwNGZYdy9rdWU5R0ZkOWE1QktQZ0ZXSjVCWDhkVHdC?=
 =?utf-8?B?c05oOVpNMCtwSS9jaGNVeThhbTVlNVdiQXZZVnZacGU2MWZCZ0M5cCtFYVA1?=
 =?utf-8?B?NHp6ZG84N2duRFZXZXlYZEt0V0kvY3NGdUxpbWVVT1J1YlM1K0J0RFM3LzVC?=
 =?utf-8?B?cnk5TERzMzZyMjZieFJqRUhBZFZ6M2FsbWk4K2U1UlRheFpXMjJyYmw2eXNL?=
 =?utf-8?B?THF6QlZSQjVXUzZqTkxnOFppdEwwcDlkYktmU1JFY2wwazRPaTNDaTBjeVNj?=
 =?utf-8?B?ZU0wVWlERk05Qjc0RmZtVnM3UHp2QmFYUDF0WkEvVFRWYnBTdWJ6VGd1Mmgx?=
 =?utf-8?B?aE9IeXg4V2c0UUFybTVKRGNHWDlrNXoxQUR1dWVFQ0pqdDFSK2dJRXh4RDdp?=
 =?utf-8?B?Z2JBNlEySVhZQlhwdVVLUTFqZWV0OHNjeGxvVXA2bHVPVE8vR3BsQ3JLUmlM?=
 =?utf-8?B?cWQ3QXRxTENnVDQzQ0VoT1B5K0ZJV1ZNbjd5RmU3dms0UnBJUTdjSFRVakxB?=
 =?utf-8?B?eGNhRFRQZmJla0hMRWVHanVVUWFmWVVwUC84bEdiVmxlZHc2UFRScGRkR3hJ?=
 =?utf-8?B?Ui9PS3dvMEhZR0pKRlA1SWFIamc4Vys5dWtSMVlUTk1rWTZzOHBYREFXWnlq?=
 =?utf-8?B?YUFVckVsUTZrMUJoTndOWEV5bWt5WHVNL29lc2Zwd2dvTFNUTGs3elRaZ3Vm?=
 =?utf-8?B?OVZhR1A5VkxtYnRVS2tpMCs2UERzVHpCSzQ2S3BKTFhNK2plSXo2eUw5bmdo?=
 =?utf-8?B?eXcrZlR6OStjMlFrMndCY1VRYzhLaU91WmROcitIMXB2ZWxJcERqb0ptTElH?=
 =?utf-8?B?M2VML0dSQjF2bERQeUhuV2NmS3JSUzdjRkxjbkNQS0taazRGYi9vZnhLc202?=
 =?utf-8?B?by9JRGZlOENyb2QxNS9XbXNJRkVyK0NyNlZ0THEwbWZyWG9jenVqWW1iekky?=
 =?utf-8?B?azNnWHhiaWFCWXZiaUtVTVBMQnhtS2FFVnZkVnBXU0JHU2tJcXdUY1FNdS9V?=
 =?utf-8?B?U2V1VG9nNFErRFRqUkFEN2FTa2NJZEgrMkVsWVorcUNtYkNqYXFibGlIN2Zq?=
 =?utf-8?B?dlJhZzl1RFNxVHZJb2lIcUV2UXlSeFdEMkQzYm9OeVJmYUpqRG9FTlFFZXlx?=
 =?utf-8?B?bWNTN29IWStjRW1HcmRQWjlsaEU0T1ExZEdJK0V4QS9MVTh4OTZha291ckdL?=
 =?utf-8?B?dThwN0FvWmlsRDViT2xUR1I4N2J1L2psNHZISVV1dVpFbnNLMDRicjRjcElW?=
 =?utf-8?B?RHlXbEdYM3BobVBUdlp3akJYdzFydm05QlJCNUdpUmhRbFVqeVl5U3g3cDNz?=
 =?utf-8?B?U0Z5b1FKdnN5WFpnOVQ1S3ZtVUVkdFdTZS9VYlJWUTY2QjIwZG5jTk9QMTh2?=
 =?utf-8?Q?MnVg6r9VOVObBoYTTdbWoV/kx?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 289bc966-8472-4905-0d9b-08dd187a59c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2024 17:53:12.7330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LXrnOknJzFrqCDtO5nDQGbrGu3uwkANSQad1Zqq8PlO2MzecHSeoC83iegHtmATAtLH/wW6skypFIJSklX9ghA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8287
X-OriginatorOrg: intel.com

PiA+IENvdWxkIHlvdSBwbGVhc2UgY29uc2lkZXIgdGhpcyBzZXJpZXMgZm9yIGluY2x1c2lvbj8N
Cj4NCj4gTGVtbWUgdGFrZSBhIGxvb2suLi4NCj4NCj4gPiBUaGlzIGZpeCBoYXMgYmVlbiBtZXJn
ZWQgaW50byB2Ni4xMy1yYzIuDQo+DQo+IFlvdSBtZWFuLCBJIHNob3VsZCBxdWV1ZSB0aGUgc2V0
IG9udG9wIG9mIC1yYzI/DQoNCnY2LjEzLXJjMSBtYXkgZ2l2ZSBhIGxvY2tkZXAgc3BsYXQgd2hl
biBtb3VudGluZyAvc3lzL2ZzL3Jlc2N0cmwNCihrbm93biBDT05GSUcgb3B0aW9ucyB0byB0cmln
Z2VyIHRoaXMgYXJlOg0KDQoJUFJPVkVfTE9DS0lORyAmJiBTRUxJTlVYICYmIChFWFQ0IHx8IEJU
UkZTKQ0KDQpidXQgdGhlcmUgbWF5IGJlIG90aGVycykuDQoNClRoZXNlIHJlc2N0cmwgcGF0Y2hl
cyBhcmUgbm90IGRpcmVjdGx5IGRlcGVuZGVudCBvbiB0aGUgZml4ZXMgdGhhdA0Kd2VudCBpbnRv
IC1yYzI6DQoNCiAgIDIyNDY1YmJhYzUzYyBibGstbXE6IG1vdmUgY3B1aHAgY2FsbGJhY2sgcmVn
aXN0ZXJpbmcgb3V0IG9mIHEtPnN5c2ZzX2xvY2sNCiAgIDRiZjQ4NWE3ZGI1ZCBibGstbXE6IHJl
Z2lzdGVyIGNwdWhwIGNhbGxiYWNrIGFmdGVyIGhjdHggaXMgYWRkZWQgdG8geGFycmF5IHRhYmxl
DQoNCnRoZXkgd29yayBvayBvbiB0b3Agb2YgLXJjMSAgKGFzIGxvbmcgYXMgeW91IGlnbm9yZSB0
aGUgbG9ja2RlcCBzcGxhdCkuDQoNCkkgc2VlIHlvdSBhbHJlYWR5IGhhdmUgb25lIHBhdGNoIGlu
IFRJUCB4ODYvY2FjaGUgb24gdG9wIG9mIHY2LjEzLXJjMQ0KDQpZb3VyIGNob2ljZSB3aGV0aGVy
IHRvIHJlYmFzZSB0aGF0IHRvIC1yYzIgYW5kIHRoZW4gYXBwbHkgbXkgc2VyaWVzLiBJdA0KbWln
aHQgbWFrZSB0ZXN0aW5nIHNtb290aGVyLg0KDQotVG9ueQ0KDQoNCg==
