Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7A820DD41
	for <patches@lists.linux.dev>; Tue, 12 Nov 2024 23:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731454971; cv=fail; b=t+BAlvBYEkMbu0KvxWUrZ9MWLpausP20v2sVUOrMfkXaH8iNjB4bUkSRMgywE9a+ZMNp0RI+DnCGpdS2NXLc60lwXBtcYViYyMR+tMzMEi/qDHlMWKUH+qrODq3mOknrvZcN8OiVXSZ2xgbCtP4lBj2NrTNwChWKeFDnN3A2rQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731454971; c=relaxed/simple;
	bh=9RLQhjPb+geL7aVLs5kxV67+KmnddKPBapq9LeXEOz0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VqR5QS5FNbv4oDr974JZyCiDkNAAeNGDcW/JJoXuo3RCZJBfIy+wn9DtsnMSDEXV36IeGRLTRsZxMKHdprWM7MP8rvpzwEpzKHvSjAVJ6UE1FPe9Pms1sImNKH6grJJi+ARYnjTjI3CRmdUe8kmzWvgtRAmUMrthK1k7LutANDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=juab+VR6; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="juab+VR6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731454970; x=1762990970;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9RLQhjPb+geL7aVLs5kxV67+KmnddKPBapq9LeXEOz0=;
  b=juab+VR66ZjyRkkCq6/VJaI8Qr1MtWCgBoWXhotqYDfasn++mUuwsawY
   BYi8/ub3HZzwrRoeT0ekxhpoUGM2Ols+0iK8ZaljgnnnD43ikQP7DjvhK
   NPhc7d4dOzKyvl7MCwf55sJ9F1VtLNx37RH3+DxJUvi8hV+sn4uIROmlA
   KE5mEuKi99J4twcbxNR7BI6u5R/9XPvYh0J473DpurSqkIPt2RcsZaO3S
   PPGQj/0o0+k7sL+okdDwgx2TcAgMNtiewyRuA7ila498NkJ1rDQtnTrjr
   c9OHRaeW90fHAd458Pdj+2LMLc9P/bOZeUASjEEg8Zboe6IVA4N4y+U1n
   A==;
X-CSE-ConnectionGUID: tHjCJs/TTAu7BOe68KdjdQ==
X-CSE-MsgGUID: BDhvagwLT7W4HsZUcrJmkw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="42434002"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="42434002"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 15:42:49 -0800
X-CSE-ConnectionGUID: 77nfg2kjQnG8tMQ934ECkg==
X-CSE-MsgGUID: bQeVIOf6TkqRwRI3zva2Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="91731525"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 15:42:48 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 15:42:48 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 15:42:48 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 15:42:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TCIAKliJjoLwrUmRIZMEIqnKqxJ2QSi4cwLyhN7Bw82DTTeQ67/LGDAkslnvgSx/PDwKbPREbtCMVsi3+RD0pD2fbtgavsKkqT9ukj2e7bT3ZS0VJR0Gl+K7Z4VLUsEeQIJ61oLTGpzsW27fsmw48lGWgbw4t0x0x163AYs36SZj61TY4d8ZK2zmSBaNviZI04GyOtNAHYYSZ5bq8hBwD+D1Ytr2XH38Cqny+GgicYLV1UHZUIwhrxEc0S/ExT7nhrVMwNcTPq2GEZqZTC1jmwKOdA/B5PJfZ7dytUY2uZh3TDWjOYnfQGIbMFQa9DPIzcut1Jvc0pnsTtc/x7qaYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9RLQhjPb+geL7aVLs5kxV67+KmnddKPBapq9LeXEOz0=;
 b=f8crLHJiNosCVY/mgTGEgibY4fLYzuNGssVflSFmLk3XrJZsOVXUPTREtKOiqHj0KRlupMrv9sGD08hbudhWSpCpnLdYYgw+b04uNdlWhLUY766WzfTCwCZy0mrVnZLmlg52lVBdmOLcKYhUT6nkHvguzvD+yY7EaRd19skQ1jIVDSgoRLzcA5D51cezGjcYbdpSa8tsD/UFJCrsnu3rjlLkDFA2swNS8Gw8eqX+8HuMr53a7zVVOp9XLPPTq6tcfvO186DVseQwLvBV256WCSrXDP74yxyG+A3bOe8sy+HVmVReYr81FIMQbEDOu5qshs/TVHJIH3pW41WtjsG+bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS0PR11MB6494.namprd11.prod.outlook.com (2603:10b6:8:c2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.16; Tue, 12 Nov
 2024 23:42:44 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%3]) with mapi id 15.20.8137.022; Tue, 12 Nov 2024
 23:42:44 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, Peter Newman <peternewman@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	"x86@kernel.org" <x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v8 5/7] x86/resctrl: Add "mba_MBps_event" file to ctrl_mon
 directories
Thread-Topic: [PATCH v8 5/7] x86/resctrl: Add "mba_MBps_event" file to
 ctrl_mon directories
Thread-Index: AQHbKigGh0B6ec32lkmFla4NSGoe2rK0S6OAgAAW5uA=
Date: Tue, 12 Nov 2024 23:42:44 +0000
Message-ID: <SJ1PR11MB6083839383802DC9127C5CD2FC592@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-6-tony.luck@intel.com>
 <bb4741f3-009a-41f6-b495-3408d9abbff7@intel.com>
In-Reply-To: <bb4741f3-009a-41f6-b495-3408d9abbff7@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DS0PR11MB6494:EE_
x-ms-office365-filtering-correlation-id: 06a96d83-7f0b-460d-6b77-08dd0373b4e4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V3FmZmx4M0JUT0xxRmpmR3F1dkpacHMwTUhyWkwxOWVXdkNYd3krN1VCcWJO?=
 =?utf-8?B?QUUrK2MwL1N4Zkc3TjRybEpJKzFXbkNJUkdNWlR6VVVzOUpKcXNIK0plSWZX?=
 =?utf-8?B?dUZNazVkVEpNbmVtVDkrL0JCTHcyVUNGdWhTbnBtSFczeW1lR01wVmpoZitW?=
 =?utf-8?B?S3JxYUVBRHdsZVhJejk4elZLdnF5QmJtcG5oNi92aE9CZEFKL1dqaFBMdmNP?=
 =?utf-8?B?T08wc3Nkb0FqSDNtRlc2a2ROb1FPbGF2N2lZOHR4emlKOUdZV2kzT1JZbzYw?=
 =?utf-8?B?UTNjMkdCTGxxU3MzZ1Nld3BBTWNOaUYrS0JPeWpCQWtJWmxETGkwQllreGNN?=
 =?utf-8?B?azNVbHNwSEwrVFVBUDZobzNjRzNlOUFJQWI3a3dKTjFrbjlLZE1mcVdFeVd4?=
 =?utf-8?B?K3VtaGJjbHZPZ2RTSEtac212ZU5yaGcrNVBSMzJTN1BvNDR1Sm81L0o4YkRL?=
 =?utf-8?B?SGZSaGdLVmJUZkpjakM1WG5ZL2JVc05HRlN6SzVSQ2RrSXFNNUlURk9oUzJr?=
 =?utf-8?B?d0ZLNlNoSysrTnFURXdFdnBhRWhOb3AzYkxNS3J4Nk9MaXZSTGFHV2F4YVRC?=
 =?utf-8?B?U3lqaHNmdEpoaDA1K0lQM0l1endBaFNDVUxwRkJTTnhxaHlCVys4SnhHa2U2?=
 =?utf-8?B?U0JDNkoyd016OWUzTHhVeUo2eHVPYkorYzdCZVVkUHhqZk5kNkFxZXc3ait5?=
 =?utf-8?B?dmVqYk1rSk9uMHJwYzNGd3Qxa0JjYVYzM1BEd3VqbW5xaENoZVU1VEhzc1pM?=
 =?utf-8?B?a3BkWDdLTTdaUzg5ZzVVdy9WcVNjSW01Nm4yaHJlQnA3RHllbVNQUTVQREhS?=
 =?utf-8?B?cVF6TUxBV3ZIQm5LY09ZOTNuemxKWjZobUcxYU1xVXNUVXYwQ25FYnF4SnZD?=
 =?utf-8?B?cGllRm5XcWV5TGVHeHlwaGUwMGJMQXdwUUdXWUlhMHFuNHQyaGtMQzF6R1Zz?=
 =?utf-8?B?WFdyNDVHcm9kRXdVaGRUQWpjTDBzcHh3MG1RL0NzNnBiakxRV0pFMDZHcSt5?=
 =?utf-8?B?WTNQWjhmaGw5QVlmVnd3SW1wRVo5Rm5qSTdYaVRFUXB6NG9aWkRqVjJmcGdw?=
 =?utf-8?B?UVJ0dklsMnZVa3B6blVWaHdmNEZSZEdiU21MV3RTMlZVQ1FGc204YktRRCtR?=
 =?utf-8?B?UnZjZE1YSGcvRHRML2src3VkaDhRSXpiRVdEUnV3ajFZZHFTaWxjUENsNlk0?=
 =?utf-8?B?Y1ViTGxuU0RPbzlwNVpJTUlocmpmanZ4Mnhrc0NwREEyV1h5NWVRQVR4bGRs?=
 =?utf-8?B?NGRqa2Zhb0Jza1M1RUUvSHkwRzZBTGIzV0t6WHovU3RSQTJxclUyblNrZ0ZW?=
 =?utf-8?B?c2FNRTR5OXlFWXVHNWw1OUtDb2xlUjhUS2ZIUWZrb05iNWNqQkk5bktOK3VV?=
 =?utf-8?B?Q2NRaU9wVnZGTGlxZytDM1J6TDRGQmN1T3hhUHVGemp2cG91ZkVwZStjYjlU?=
 =?utf-8?B?ZzZaZTJWVGhqWlc0OUJlOTJ1Q2pzVlM4WVBxRjRiZ2ZhN3B6NG03YlErMkg0?=
 =?utf-8?B?OHYrWS9TSzZncko0cllza1ZJbDk0ejlUdkJLRndmRzY0cXp4amw1YUlCN25h?=
 =?utf-8?B?cnVGc2w1bVREbFgxTWlJamtIRlppUGt2R0d0cURaSTVmTUt0Z1lUOHNzQ0VW?=
 =?utf-8?B?eVVwU1Z3TmE4cnpaUUlwS0s2MzdvSThrK1pGMS9MNnBkdkgvcFM3MU5aUUIv?=
 =?utf-8?B?eVh3Q0Y2c3M0UnEvUWRkc3h0SHBHOGpKUnorandscXpqblVNcGlPWFVGNDlO?=
 =?utf-8?B?VFVIcFMyU0tsMmxZNkVQTFRLeFU2UFJjQlY1UnFtellaMSsvQUhrclZZUGxM?=
 =?utf-8?Q?ZUGMYcb0VPfXYcmMPJxiGVazp1n1nqChCRlcA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NkpGdmRSV1lHaHQxOXE3dmlJYnVjeUd5M0tFakNoL0V0dVZzcmxVZDFBUDVO?=
 =?utf-8?B?QkNKdlJ3T2Zsb2FoeEswRmRHZkJFZE13SnQ0dFpFN0lnaDNrS0ZrQTkrSVBz?=
 =?utf-8?B?Z3dNWjdXRjdsQnRoQXBPck96aE9WVnljUzdmeFdqZEQyaWRzMks5RjYwTkFE?=
 =?utf-8?B?VGc2SEk4RWVQREtrWi9jNStqWE15cXF5QmJ6Mng3UE1OU0FMNTJmY3RPWlZx?=
 =?utf-8?B?eWJHc3JFbUpyV2RXRjR1UXlyVUZRZ0ZqOTd4RHF3NmhqeU9aMDJ5N3RYQUov?=
 =?utf-8?B?RGFBSFBHODQ4c1V4K0lBUnNZRVI5YzRaTkZ4eFNWbmpON1prdzVPRVhMdTFG?=
 =?utf-8?B?V3pjSm9PSGJybW5IRHNPWjROYUJ1QU5uZUF5Tzc4OXpudFhzWFAwWFdUblNX?=
 =?utf-8?B?TllJL211dmU2ZnkrbGlCRTFwbzRJaVh6Z2twREMrenhVcG94Yk9NVndrbFZ2?=
 =?utf-8?B?YTE5Qmk5WmFZYTQrVkJxclRtMTY5K2lMbzJ5US9HRDBhNzBtSGlBbzZnZ0Zp?=
 =?utf-8?B?ZnJRY0IwU2RDK1htNFFnMmpMZnVwS3hCalJ4MUtYei8vUDBkMU9kVHV6bWNs?=
 =?utf-8?B?emc5cE5uVFF3bXNMS2RmdXlVU1hiamp5VEM4enRPVDBzdzNLbWhTVG0xNlFG?=
 =?utf-8?B?RVhtRlBxdVpmamN2MTBMOUJvOFBmU2NkWDdRZGtiZEpsUXcvSENQd0RvMzQ5?=
 =?utf-8?B?RzcvNFdyZ3RlNUxZMWpLc3IvNWduWWw0ZDFaU3RNbHd2amYvTW9VYk1QeUNC?=
 =?utf-8?B?b1kybm81RlJwZW02UmVkY2xtRkV6VUtHWERvaFNPc2NRZVhIdXFpWUxzdUFS?=
 =?utf-8?B?SEFOMXBvODFOQTI0K1VEWDdPQlMxQlVJbndpbW9hWWVObEsxaitOOG1EMnFn?=
 =?utf-8?B?Z0syeEF4bXI3Nkh5YkdHZHkrZVhCVFRTQnh4SHg3S295OTUyZW5Ia0hQT3pw?=
 =?utf-8?B?QzJwRDduODZ1TnlOMWN1bFMveUFuZEJZZUd5N052dUhpc3JxWkN4cVkyUEJq?=
 =?utf-8?B?NTJvTlNkczBaR3BrTHBTeFR1eWhZVDZ4NEFaMzlub21YckR1YTcwRTQxSHRN?=
 =?utf-8?B?OXRlcm1RQ1JDYnpaL0h2cFlTZXZQUGxEVjRYUksxbVRPMW1pOHFhU2x2K2sx?=
 =?utf-8?B?UlhzeHVaQ251c3ozOXlDV2pxMFMwYktaeG1HU213Mk4xdHRZQjRzdmV0YUww?=
 =?utf-8?B?MDluNE1LUVp4TnEyWmlhV1N0Y05rVEVuMlVuZmswU1pNaDVlWDJ2Q1ZXTk1V?=
 =?utf-8?B?UjJwdFUycmphVUp3WmpWWnJXbWJOanMrR1QyTWI0dXBQU0dlV000RitoWUha?=
 =?utf-8?B?OWFRWXpTQWRlcjZtYWJkSThsSVJUcmlOWXJWdjIvQnduZWtIUlNRSDRJUUVw?=
 =?utf-8?B?dURjSFhwY2xUb0hYQ0w4UzNCdU9jRHZLakxzS0MyZU9DWGg2d0lsSyt3SGE1?=
 =?utf-8?B?SDNYS1NibjdEemlxWWxQRmhndU9JTm9qclNUclNITDFlaWJZODlEU05aM0ZK?=
 =?utf-8?B?Z2pEUDNxN2p0VzlvWEYrZXhncTRSUnMycHFjUEVQcFdpUGZzUVBpcVh1RFZB?=
 =?utf-8?B?VGhmb2RWb0tqRHpPUHJ6RjJZS091WWpoVHdOMXdLWTN2WWlNWUNwVzIyNzA4?=
 =?utf-8?B?SklrajFvYzlUSTEvNWw5NE41SFEyNkkrZlVOOXhZbTBncW1yMCswcW85Szlw?=
 =?utf-8?B?enJ3ZEJRRDUwbkdHR1V3THdld0pGeVR0YUhFb3JIZ3NIbmhxNGl5QzVCdWht?=
 =?utf-8?B?QU4xWnUxUzFQQThsSUw2aFd0VE03Qm5EVVFyVSttZGxja0dhZlQzWk8yUUM0?=
 =?utf-8?B?QVVLc2x5MWhpamxhR0J2WTlQUm1UQUU2a2ZIYkhzTmd1ZDZGc1ZEVXp1bEZD?=
 =?utf-8?B?UWtHMlh3OE5kZTNnQTRMREZFYWtsWE5yRnhhd01vTDArZGI4enRjMkNoa3Nq?=
 =?utf-8?B?SWdXOG5EYS9jWXNHZHc1VkRCOGRkYjhzQzYwVm9pbmw2Q3ZKbEZBNWVwcENs?=
 =?utf-8?B?RDNXVXltSytmenp1aE00TWFaYno4c3lERnp5cExSbTRnbThWUVMrVVpVT3dW?=
 =?utf-8?B?a3g3RkwxMGZsNGhFVDN3OWVwcHJ6UDZTeXI3MU9EVXlnajEzcUNPV2MzRjJK?=
 =?utf-8?Q?tPBQIAgMAJJWr35VorT4pms8z?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 06a96d83-7f0b-460d-6b77-08dd0373b4e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2024 23:42:44.7366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UScbziOaTHUxDXHewhcaEvOu4Ro1V34a/SwclJ4+FuT8ZMDbBHHzY2buYxu+Tz6uDA+jokzGm6uMrzhPrwWJaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6494
X-OriginatorOrg: intel.com

PiA+ICtzdGF0aWMgaW50IHNldF9tYmFfc2MoYm9vbCBtYmFfc2MpDQo+ID4gK3sNCj4gPiArICAg
c3RydWN0IHJmdHlwZSAqcmZ0Ow0KPiA+ICsNCj4gPiArICAgcmZ0ID0gcmR0Z3JvdXBfZ2V0X3Jm
dHlwZV9ieV9uYW1lKCJtYmFfTUJwc19ldmVudCIpOw0KPiA+ICsgICBpZiAocmZ0KQ0KPiA+ICsg
ICAgICAgICAgIHJmdC0+ZmZsYWdzID0gZW5hYmxlID8gUkZUWVBFX0NUUkxfQkFTRSA6IDA7DQo+
DQo+IEkgdGhpbmsgdGhpcyBzZXRzIHRoaXMgZmlsZSB0byBiZSBjcmVhdGVkIGZvciBhbGwgQ1RS
TCBncm91cHMsIGV2ZW4gd2hlbiBub3Qgc3VwcG9ydGluZw0KPiBtb25pdG9yaW5nPw0KDQpOby4g
VGhlIGNhbGxpbmcgc2VxdWVuY2UgaXM6DQoNCnJkdF9nZXRfdHJlZSgpDQogICAgcmR0X2VuYWJs
ZV9jdHgoKQ0KDQogICAgICAgIGlmIChjdHgtPmVuYWJsZV9tYmFfbWJwcykgew0KICAgICAgICAg
ICAgICAgIHJldCA9IHNldF9tYmFfc2ModHJ1ZSk7DQogICAgICAgICAgICAgICAgaWYgKHJldCkN
CiAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gb3V0X2NkcGwzOw0KICAgICAgICB9DQoNClNv
IHNldF9tYmFfc2MoKSBpcyBvbmx5IGNhbGxlZCB3aGVuIHRoZSBtYmFfTUJwcyBtb3VudCBvcHRp
b24gaGFzIGJlZW4gdXNlZC4gU28NCm1iYV9tYnBzX2V2ZW50X2luaXQoKSBpc24ndCBjYWxsZWQu
DQoNCk5vdGUgdGhhdCBvbiB1bm1vdW50IG9mIHRoZSByZXNjdHJsIGZpbGUgc3lzdGVtIHJkdF9r
aWxsX3NiKCkgY2FsbHMgcmR0X2Rpc2FibGVfY3R4KCkNCndoaWNoIGNhbGxzIHNldF9tYmFfc2Mo
ZmFsc2UpIHdoaWNoIHdpbGwgY2xlYXIgcmZ0LT5mZmxhZ3Mgb24gc3lzdGVtcyB3aGljaCBzdXBw
b3J0DQptYmFfTUJwcy4NCg0KLVRvbnkNCg0K
