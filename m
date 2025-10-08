Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8CF2C21EB
	for <patches@lists.linux.dev>; Wed,  8 Oct 2025 22:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759962612; cv=fail; b=eX8xUV1OJUHIrIiDfuSU14r/pE9ko9K2DCNny7T+NVjhOe3ETAQCsKRLYiORpTtBxpyhWRCOqkcmAyjbEEWQvkTNsfUeK21zQWOtCnlJ8772GKuMGui9lgv3uUAdm3ULUizj7QCsgx+OJ8f7ssU/0AIjExLuMU+GxVGk2pHvVGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759962612; c=relaxed/simple;
	bh=kX6sSYC14Sn28PHPGee0QzMxmEb0n3FjY3XXgYYFKMQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Uh5mIvgoHteCqTylx2/i5sABTLGymPgWi8nKMQubhxzL6zwwHFHpgMoMjceYLDB4q7Ogn0bLqXAAUjxBjVeUj0GLnUxqJRPpgs7wswZ9dKAszIVIElJ33mvsTIs6q7MpoFwDlXUUb3D5StSBnFwnpQgMNm5Co7zTIjNOIsbXAM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dssakciW; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dssakciW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759962610; x=1791498610;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kX6sSYC14Sn28PHPGee0QzMxmEb0n3FjY3XXgYYFKMQ=;
  b=dssakciWPBnuB4ZOtU4atuW/9G4wpkY0fn6x+KG+vHcpeXXtrdC/Y0LN
   b+LEw+XmKR26wbiADeqrkaPZbnWXtARvCipXqZsd+04lMXnw93P87vYTx
   8+lyJDWU9EaDf+NkEjkAm/fpzrIgncfwdtFlpIuttwHyO30Lt0OGPpOG9
   vlHu8D7ZcrE7f1F2CCcp0hRh26t4p+pyfrO2LpBoifbpR8OOXV4AbDWfg
   Y/hLNhRVeW079SIMQzv3XKNvj0n1DlF1wOH2scS0A8tSi1KvcB5qdto+q
   P5La4AunTBJKOhDgmq/PxN/jJXZytxJS5QffShKgSWDA9nT9IEjcKp7B1
   Q==;
X-CSE-ConnectionGUID: U7mm3z10QUmYIGnBwQZO4A==
X-CSE-MsgGUID: o+ZXdb/dToCx/T1GysLg7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11576"; a="72845370"
X-IronPort-AV: E=Sophos;i="6.19,214,1754982000"; 
   d="scan'208";a="72845370"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:30:09 -0700
X-CSE-ConnectionGUID: I4gxWWSrTP6a5oU4v+bJJw==
X-CSE-MsgGUID: wCyj3fTbRSChYWmVRyD2Jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,214,1754982000"; 
   d="scan'208";a="184815578"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:30:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 8 Oct 2025 15:30:08 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 8 Oct 2025 15:30:08 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.32) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 8 Oct 2025 15:30:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HGhg1W94UbL05VCN0NOPi1mJskVewt9vQ7HQs0J3FKnDnBHYpsNRi6vI4eLkbkl2Xi8euJUZZNBs9ItQ2W/7mDb7dQInFSR4Z8Y8SGhpfMqTAfhRagtNGdr3sXWK9SXtdHxlyIoock8aqAfGIVHuiQDD1chlxVXqAqfrk0eWYjAMn87GLr16XU1Z4vRnL5Ye5gdJMcSRCo63Kh1PLg5ldSoxv/xXfp/mYIRFOZB6qCUD6zCj5TNfWzyvbqrwRu3qVe6OMSsICViQsyMovWlEee4BMUl0zoNCukHC3r9wzSF2NDDZPQVOfWwZQtX7KthkTJf712ysEl6g6XyTMt8ogw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kX6sSYC14Sn28PHPGee0QzMxmEb0n3FjY3XXgYYFKMQ=;
 b=vHO0v3vIuRdsB2IyR/5BOJNSEDjbbcOChGQiIAKhwNfjRZftMMhVnSAthzHWlH5jpdwjlaGWkFbMilVctz1pUyByYTl41CT9CCfl3XgGZK8P8el4ZzgiFaU6dQ6vJ6AnndC8qhU2UV3S1GH3C6005dJHD+uH9f8+xvQeZH6Wv6fgwx71/QjuM5uCDcLcX362bCATG4bGjSS99dEvbz4e5A5FNbbkEiEeKgyl2iXShTSYOIwT5eFMHTaU+qrAMUP0u6bspVDOuEAa9ogSkbEyRuu8pMkgv1vC7yAVi8fjOXTlxwpta5uAEWioXN+cB+ti/su30YC/GFEOs6rE0YDlSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) by
 DM3PPFD2F4A0090.namprd11.prod.outlook.com (2603:10b6:f:fc00::f50) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Wed, 8 Oct
 2025 22:30:00 +0000
Received: from DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::5502:19f9:650b:99d1]) by DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::5502:19f9:650b:99d1%5]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 22:29:57 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in
 mkdir/rmdir code flow
Thread-Topic: [PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in
 mkdir/rmdir code flow
Thread-Index: AQHcLleU0msvp58alkOhnd7F/4XHxrSxJp6AgASphYCAAsCpAIAAQ86AgAAP+ACAAANVEA==
Date: Wed, 8 Oct 2025 22:29:57 +0000
Message-ID: <DS7PR11MB6077A0323678A68DF5878C0CFCE1A@DS7PR11MB6077.namprd11.prod.outlook.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-21-tony.luck@intel.com>
 <fbd49f1a-ddb2-45e2-b943-df43d2173503@intel.com>
 <aORMZ6NUXMpECHU6@agluck-desk3>
 <ed1a10d2-2f13-43aa-93f8-7dfe8864cf47@intel.com>
 <aObUZU8rnWIDR_tH@agluck-desk3>
 <860ded3d-2003-4d72-9013-a5fe97657934@intel.com>
In-Reply-To: <860ded3d-2003-4d72-9013-a5fe97657934@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR11MB6077:EE_|DM3PPFD2F4A0090:EE_
x-ms-office365-filtering-correlation-id: aa46b837-b7d4-40e5-a979-08de06ba3644
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?R1I0WDV5UVpsaE1ZU1dHNGdua2k5STlVZ0NRTGVwdHN6eHpoUnFJR1hZUGFq?=
 =?utf-8?B?S2hZTU00a1MrejMvWE1hc3hBemUzY0xRV2xKeXpTU09CU3d6dENqOWN4Q25G?=
 =?utf-8?B?VGVZUlNPQit2NDdkV3dpOUR6SkN6dFgyZ25iVVpTOTRmUFp1c0duZnFZRmdN?=
 =?utf-8?B?bEJYUjBacUMrOHg0a0lvSnBJME9lWkxZU1VicjU2TnhQS09EWnNVTjR2aGRI?=
 =?utf-8?B?Z1o0WmNLWFdIWXdadzVyeXZHUFREYzFOQytyV0hzWWQwWDY5ejRadG1HZjY1?=
 =?utf-8?B?ejBkcmZrV3BDNjAwQVFLY1NQWU5Nc2JJeVViK3pyTGxoUHc3SXMzWXhvcWR6?=
 =?utf-8?B?YitZU0psbEFXYzNBVTdJOS90Ujc5LzQ1V0l2MklUTG0xZDl1dVFmM0FXU1M1?=
 =?utf-8?B?T2Y5dHFVeVk5cWJ5MnFnTDRRYjVZbXVuRU5Bd2hIY2V6MFdzdVM5YmlRazhJ?=
 =?utf-8?B?V3pKZnZpaGlXQWU0OTlpWlg3UEVPUm12ZUVIT3J1bENJN3ZCUVFKdFd5ZC93?=
 =?utf-8?B?SkxwZzFLSHB1cEt3bDF4cDFPQUhIMXQxV0t2bVVFMHNHaUlYQU5zNmFjV3Z4?=
 =?utf-8?B?OGtuVnRsUlJMSFF3SEMveHNSbjJ5Qkxib0VyWkNQWVA3QnQ0R3pzS3haQW5G?=
 =?utf-8?B?Y0RKcnhSV0VNa0dMMW9vSjB2T25QUEdBalVuczZZRDlvbStkcWVMQnR4RDRQ?=
 =?utf-8?B?ZGtxdWZYWitzYlN0a2RhaTRYMFJybnBiS0t4NjY0ZW1jb2U1dWY1SkZPQlo3?=
 =?utf-8?B?YWVDaFlPYXBnMHpwSnIrMU5xSVBWUzNNSVBJd1lnYXNuZFRsZDgvZnljaTlp?=
 =?utf-8?B?aVRwM0dkQUtqbW5XeUE4Z2lZTnoyZjcvYjcvMmFTQ1ZtWGtmZFBsaWxTbnRB?=
 =?utf-8?B?RGY0VGtkem9kZGxrcDRqSHJOZjJqTmpSalV6TFMySlpRWWJnS2xNQ09Vbjlv?=
 =?utf-8?B?UHlaalpLWmhDK3NpVjZHNndJbmZ1UlRBcmt6VXg4ay9xS3V6ZE1VVFp5Mjlj?=
 =?utf-8?B?ZFc2UWhVRTJrUDZXVGJnejNSQWZsU2FxczJScDFlaDcyb0FJS3BVU2lEUGJE?=
 =?utf-8?B?NTNMZytOWlhxMXI0L0t1L2p4ejltTE96WXR6NUpXdUp6U1pKSkt6UVVtc3Z1?=
 =?utf-8?B?L0xFU1piK0dXNEl3US9lYlZvdm4rTlF5R0NqMlFodkxRV0duZlRTZTlzWjBR?=
 =?utf-8?B?MGlRSDhSY2ttUUQ3N21OMWNGL0JNRzhVRTBYejBSYXFMWWtKRFJnMjlzcUJx?=
 =?utf-8?B?Sk1vRWQ5cGRPdjNsL0tjQkJORkNqZXhKS0VJaE5MNnRyNlJhV3dGSWlnbmwr?=
 =?utf-8?B?cEs3cCtmOEE2cXRKeHdLZkN1NU9wc1BlNUgzd3N3OG83THZSUmk0UERXZUcv?=
 =?utf-8?B?NmtTNXJkcU1UTjROekg1Vm9GZ2thTE9XbzBTdkh6UG1JQjFxUHlzMGdFY3BJ?=
 =?utf-8?B?ek0rejdXaGF5cnR6WGxYUmlqMmhFR0hYQUI3MGJ0NVRpanN4R083ZUFKYkdD?=
 =?utf-8?B?NW93TmdrNHp4NVAzNTkrL2tJKzg1d1ozdWt4ZEc3QThwdnZsYVJWVHpiYkpy?=
 =?utf-8?B?WFBkbUplc3FtaWRWeUJYdU53SnRWWFdvU2JCUnNEcDNHRFZHZkluZStCQ0dJ?=
 =?utf-8?B?UXRYWlVNYW5TMEEwdU5PbkZyd0FMaXJYMzJvWUpmU09BaHhTaHVkbThQT3dO?=
 =?utf-8?B?SVdqMWRoLzFwSys4bVJ5NXZuSk41SW9Ca3NYNXNFVHlVTGs2T2JwTXdJeE9O?=
 =?utf-8?B?cjdaTU1pK2txSjNESW5zU2o4U29jNU9qOGNCanVrVWQzN1Mza21zenhGTkI5?=
 =?utf-8?B?ZnFmTnlkQUo4Vkh2RkFWRW00WE05N0RyTHQrMXp6UHJlUGJKOVZXQTNmY2RJ?=
 =?utf-8?B?cUlzWVlndHcwSXJEQUVwbHpxK0RaNUdzU2hxd1h0YVIxNmt3OXFtNjdteGZE?=
 =?utf-8?B?ZUpLVXVVZVkxclMyR1Z2dW1XVEMwc1A1RForalM5SGdZekhvbS9ZMnZmclVP?=
 =?utf-8?B?b3dDUGxFamhaTndCdEFhdERMR2RxYnBTNlIvNlVIdGJDd2xmWi9qN21uems5?=
 =?utf-8?Q?EmLo6+?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6077.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UTFxc1NpSll6cko4T0JpN2t0WWVCamo5Y3B1L3VCTEIrNDcxQmRHT3RFRWU4?=
 =?utf-8?B?b0R3dkpjZHdzRHQwL1ZmT3FyS2xydkcyYVNTd3VGcXYvY1B3NnZUb25uM0da?=
 =?utf-8?B?N1gxWVNuUnNDQVUzVUhibmI1UnBWV3gzYllDSlpNeGZ0MG1ySHpnT2ZVelU2?=
 =?utf-8?B?U1Z1dDJYSm42dGdwTmV5Q2dyTEdOYWlicWQ3NEEwTG8xNy8zMkk5eEZ4bndG?=
 =?utf-8?B?V2pISkVrSitsUUZGYXpYbUNjQXhZWHFEM2RvN3JpcDAra0U1bHpvQVYwSWdB?=
 =?utf-8?B?Q0RXTnpFeWNaeDFwME84TENqTXprb0xFb1R3bHFHYjRKRE5VSEZoZGFjMVdv?=
 =?utf-8?B?L1M2VGJjaW4xQ3p0TVVEYzhKa01PaDdyeTFxTGtKaUxtM1dCZHJTbkR1c1R5?=
 =?utf-8?B?L00wR0lWcG0yMFpWeHhZc1hPeGwxUENPcVhUdjZqcjk1aWt5eTRxSlJJMDBL?=
 =?utf-8?B?OTNCaUtLWUJCNFkyYU40cXBncnRPb0k1MGp0K016UE5BVXJuNWhGUkpBY21q?=
 =?utf-8?B?SEJSdDhsYkEzb3lKRFRxbUpWR2lodlF5VndIOTFkb0hnZFVLSENWNkxicGho?=
 =?utf-8?B?NFc4QitqZHBjQmNGdjBKbE41c2F3Ym5kYWFjS2ZQWUdqTXI3MUltZlBlbkFr?=
 =?utf-8?B?UkFDempIcTY4Smtic1ZUc3FYaWRwV2ZpU29mYzRUSVFDQWFyajFXYktPTElx?=
 =?utf-8?B?T1UzeFkxUFl5YzZkS2pxYXFnOW9tZUJJVk5HUVlIUmxSeERFTXlZdTBOYWNN?=
 =?utf-8?B?SDd5alAxcUNaMXVjVUt5MXVpcnZSY29va1RjcEd1MUoxb3IvSG9zSEo0S2h5?=
 =?utf-8?B?V25oRzJ0MkhxQnFYeFAzM0NEQWc1eDlTKytJWUdxSFVyY28xS0ZOWVBEanNw?=
 =?utf-8?B?L2h0V0pLRjNUY2w4cGtpT1Mxck1IR1Bqd1F4OSs1SUZ3UGFESEFtQ3JqbXhO?=
 =?utf-8?B?M0NRM0E0ZFJna25yRVRuSGFjOFVDMSsrVUhXbzhxU2xRZEo5ZkRncjNzeHlT?=
 =?utf-8?B?T2V2dTdEdG1CNlhDd1NYb09La29lNHQ4WThTYzY2MEN3ZE5ZRjVMV013YitT?=
 =?utf-8?B?TGl6YkxWMVg0Nmk2V3RFZ2RlbmVFU29vbW1RRGtoWEJaSVlNSkVLNW5Ubkwy?=
 =?utf-8?B?ZFh6VzFLVDY1bE9rTE1Ja3RhTjhraFNibmc0R2kyaGtsWnFYY3ZYdEFNMjE3?=
 =?utf-8?B?NEQzN3RqVE5vQ1NpUnNjZWZWaVp6ZThVMkpqbkZLdytpSHdpd2lHSEFzeDlw?=
 =?utf-8?B?eFJQS1UyZnVuZUNkWGZ1OEZDYUp0SjU1RXRCMytvbXFsWDhWaVFhM1FzNHBB?=
 =?utf-8?B?SC85d1NiSWF3VVlCMVBENDYyTmdkV0pwSGJmSk55QzVyRTJqUllyeFEycFRz?=
 =?utf-8?B?RThQL0QvSkRhaGhGVDJ6TTltb2w3WE1JcGRRaWZZOEx5U1Q2U0VzS2diRVlC?=
 =?utf-8?B?Z2RnYnhqVGx0clY5YStHZm1nbE9CdmxnbVM1NERRelZTMmdRWFdNTS9Ic202?=
 =?utf-8?B?c1Q3anFFQnE1TXU0RmVCcFg2Y1A0alg4bHJyYXlaaW5QVUJUNmRDMGdMNk96?=
 =?utf-8?B?U2FBaGZGNUxCckRQOW5CMCszeWEvTmVjbWJOQUNUZ1hTRjBwVlNRZWRZQ0gx?=
 =?utf-8?B?dFlDbkZseEdiZyt6bXE2QTlyRjdNVU1taU9Edzh4bVF0NTJja01HK1NJL21I?=
 =?utf-8?B?a2RtbjNpYkZOU203d2RiR3VvRTM5VHNNSlkveVEwZE9PN3QvK1h2OVRVUHVO?=
 =?utf-8?B?Q21kWkVyM0dmQ1ZVRUtSbEVkODE5K3cvUngzM1FHUjRtdVp1cDlBbXZOeVhz?=
 =?utf-8?B?SkFralJOQkxtVzVORS85emFzV3oxNk9ZclhTVG84Qnd2eWc3UVpyRHgweTVF?=
 =?utf-8?B?MnpCK0M4Vy91bG5LUTl3TkZ1WGxHa1RqR3puR3FNemdYK1VJNXQwZS95K1Zu?=
 =?utf-8?B?YjdnWmhzWEtSeC9uODQvdjc2SEJweEpTZ3pHUFVnOWVtbGdIVEllSGoySUJp?=
 =?utf-8?B?bHdYV0JkNGlLTjVMa3RIRUkwd3dQcnRwRStiZ0FBV2c1ck14cHNCRFpzSkQv?=
 =?utf-8?B?S1lvREJFMmQxTFUzSkcxczVyc0txZS9jTzlTYWVGdjJxeVhsdkhLdFcrS05S?=
 =?utf-8?Q?25p5IouJGxa7DR91dSTJD47jv?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6077.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa46b837-b7d4-40e5-a979-08de06ba3644
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2025 22:29:57.7080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hR8F7WR+ubBOnkObw0p7LWSOJp9vfisjLgCsllVW3FhlYW8BEYBJuGcjHdTf0Cf9n8BSyp9EpGiXRotgZyiwaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFD2F4A0090
X-OriginatorOrg: intel.com

PiA+IHN0YXRpYyBpbnQgbWtkaXJfbW9uZGF0YV9zdWJkaXIoc3RydWN0IGtlcm5mc19ub2RlICpw
YXJlbnRfa24sDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCByZHRfZG9t
YWluX2hkciAqaGRyLA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgcmR0
X3Jlc291cmNlICpyLCBzdHJ1Y3QgcmR0Z3JvdXAgKnByZ3JwKQ0KPiA+IHsNCj4gPiAgICAgbG9j
a2RlcF9hc3NlcnRfaGVsZCgmcmR0Z3JvdXBfbXV0ZXgpOw0KPiA+DQo+ID4gICAgIGlmIChyLT5t
b25fc2NvcGUgPT0gUkVTQ1RSTF9MM19OT0RFKQ0KPiA+ICAgICAgICAgICAgIHJldHVybiBta2Rp
cl9tb25kYXRhX3N1YmRpcl9zbmMocGFyZW50X2tuLCBoZHIsIHIsIHByZ3JwKTsNCj4gPg0KPiA+
ICAgICAuLi4gcHJ1bmVkIHZlcnNpb24gb2Ygb3JpZ2luYWwgY29kZSB3aXRob3V0IFNOQyBiaXRz
IC4uLg0KPiA+IH0NCj4gPg0KPiA+IGFuZDoNCj4gPg0KPiA+IHN0YXRpYyB2b2lkIHJtZGlyX21v
bmRhdGFfc3ViZGlyX2FsbHJkdGdycChzdHJ1Y3QgcmR0X3Jlc291cmNlICpyLA0KPiA+ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCByZHRfZG9tYWluX2hkciAq
aGRyKQ0KPiA+IHsNCj4gPiAgICAgaWYgKHItPm1vbl9zY29wZSA9PSBSRVNDVFJMX0wzX05PREUp
IHsNCj4gPiAgICAgICAgICAgICBybWRpcl9tb25kYXRhX3N1YmRpcl9hbGxyZHRncnBfc25jKHIs
IGhkcik7DQo+ID4gICAgICAgICAgICAgcmV0dXJuOw0KPiA+ICAgICB9DQo+ID4NCj4gPiAgICAg
Li4uIHBydW5lZCB2ZXJzaW9uIG9mIG9yaWdpbmFsIGNvZGUgd2l0aG91dCBTTkMgYml0cyAuLi4N
Cj4gPiB9DQo+DQo+IEluZGVlZCwgdGhpcyB3aWxsIGtlZXAgdGhlIGZ1bmN0aW9ucyBnZW5lcmlj
IGluIHRoZSBzZW5zZSB0aGF0IGl0IG9wZXJhdGVzDQo+IG9uIGFsbCByZXNvdXJjZSB0eXBlcy4g
VGhpcyBsb29rcyBnb29kIHNpbmNlIEkgdGhpbmsgb25jZSB0aGUgU05DIGNvZGUgaXMgdGFrZW4N
Cj4gd2hhdCByZW1haW5zIHNob3VsZCBiZSBlYXN5IHRvIGZvbGxvdy4NCj4gSSB0aGluayBpdCBt
YXkgYWxzbyBoZWxwIHRvIChpbiBhZGRpdGlvbiB0byB0aGUgbW9uX3Njb3BlIGNoZWNrKSBhZGQg
YSBSRFRfUkVTT1VSQ0VfTDMNCj4gY2hlY2sgYmVmb3JlIHRoZSBTTkMgY29kZSB0byBrZWVwIHRo
ZSBwYXR0ZXJuIHRoYXQgU05DIG9ubHkgYXBwbGllcyB0byB0aGUgTDMgcmVzb3VyY2UuDQoNClJl
aW5ldHRlLA0KDQpUaGUgU05DIHZlcnNpb25zIHRvIG1ha2UgYW5kIHJlbW92ZSBkaXJlY3Rvcmll
cyBuZWVkIHRvIGdldCB0aGUgcmR0X2wzX21vbl9kb21haW4gZnJvbQ0KaGRyLiBTbyB0aGV5IGJv
dGggYmVnaW4gd2l0aCB0aGUgc3RhbmRhcmQ6DQoNCiAgICAgICAgaWYgKCFkb21haW5faGVhZGVy
X2lzX3ZhbGlkKGhkciwgUkVTQ1RSTF9NT05fRE9NQUlOLCBSRFRfUkVTT1VSQ0VfTDMpKQ0KICAg
ICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0KDQogICAgICAgIGQgPSBjb250YWluZXJfb2Yo
aGRyLCBzdHJ1Y3QgcmR0X2wzX21vbl9kb21haW4sIGhkcik7DQoNClt0aG91Z2ggcm1kaXIgZnVu
Y3Rpb24gcmV0dXJucyB2b2lkLCBzbyBkb2Vzbid0IGhhdmUgdGhhdCAiLUVJTlZBTCIuXQ0KDQot
VG9ueQ0KDQo=
