Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F21333891F
	for <patches@lists.linux.dev>; Wed,  5 Nov 2025 15:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762357325; cv=fail; b=gaJeM0SexI/sV1nPWopL3kiYzvm8UMqKaXAX47QsiC+NQ/mffmEeceIB6Yghgj3KPFduhu5Zagd0uu/cYyvhu9lF6G2dXH4JTQHlGKaID0UAbx4vBcZ8ySOwVoy5huUK5mP/YWt1dRlyG8PsXvRVqaE57ytZCqjw7O0Bfct9iLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762357325; c=relaxed/simple;
	bh=ORA0qT5DehTaiqy/1pQFf/07awWEatc7vFQD6zT21a4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CWKPCScqQDUvDrF55pfD3DGglDQ1AfqxffIPldffsf2SWzgxcbhwThmhmzeuiJio7zJyhVZKgYoQ3Gvx/HgqMuHQHKZd+KEyxXxB8SPh5ykGjzIDHrbPGJzPGfa/lBO3C59lrUkzbGWFsaa9pdrMPlDaq/ElccfEWAaTqd83jsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PiowikVs; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PiowikVs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762357325; x=1793893325;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ORA0qT5DehTaiqy/1pQFf/07awWEatc7vFQD6zT21a4=;
  b=PiowikVsjy1fJLrJbR9ZQbSk0uFsUQfSzg6dnb01V3yCsdYS58LMNWAY
   4eUWbhxN4eoKk6Tvug+wtTkT/0XZf+nTHdf6qsTVdiAdIwbtOUt3Wv5lC
   Bqsf8vcZ12ntZ7qZZIQg3iRrQQbBVN0bmjWVuQzPrwLB6qxWwpv09/092
   cHkw8byKor+PRQjoC6haTYKDri7izV0K3WTsQGJukkgHNvRlbJiSJE9Uw
   dS7EDLZUKN3sf/0qBDLK+FBo+S5dL8inLB93l7t+C8p8st9bHt5X9Q6YO
   V4uvMyct2Qtjd6iZpmaxs0n2ELrVyIW8pJCd6HjCecAex+g8mur+109DL
   Q==;
X-CSE-ConnectionGUID: YhkpvxyMSaqnRvEPzJbikg==
X-CSE-MsgGUID: qlX4gSdOQWezk1EaFCh8NA==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="68128703"
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="68128703"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 07:42:04 -0800
X-CSE-ConnectionGUID: Kojzq/PhTQOOGAE5ZMejrA==
X-CSE-MsgGUID: EUvHJ4jlTS2pyAedoDBfIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="191846186"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 07:42:04 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 07:42:03 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 5 Nov 2025 07:42:03 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.40) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 07:42:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FzM+tQkYhT4pkb+3FjC0eiYlAjZuTsIsNgWISiZqMB2oEJ39mFgbMwDxd+eaF7/Kay3AFmcBAPKpGzC6VwxbMdBYQQ37N1akCbiPAP3g26CDSxnvOZkDlDby9jHSBLgszZS88iRKN5xpZS9owg4uZJLtqYGL8xz1GBrTtWmAtBDaDrtKBfvCOs0bl1PwbwA+cwbO8r8revTKdfwYDVssBptb22+RdHdIwn0VSlFMKLuQwU59j1kCeOI8HnXY3J0cpbCu6owYDuXGk/x49R/V3fMcWwypatv7F/j6dsD8/Avw2+Ehq5JWtOuusQn1cDpPFCxH1FTO8VYgORTnDNg5hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ORA0qT5DehTaiqy/1pQFf/07awWEatc7vFQD6zT21a4=;
 b=FivKhcfED3OPFU8O9GAciuQJcHMDhw33L3filVQdb3ypemCEEr7SvRz+mjM6jtoeB4yGHVarfGrtDsXkXuJ4IW9PfnkllXtYc51bG/Xbf61R4YOtyxnRa3FqrpOnZyU/aC0Fo0kMOtwXLHMYV3My+H5g8RB7s7iQRU6SHiY4spxrk5mKm6rVSS4uNAWW63Gxfwlbk45bqtz8iUDiC09JctHcW08/Ofqi6lQ4fX4qNnk1LkAKtCJxwO6s1cA4aZTV0hj6DK+gvVIr66KGlRM9vt87VZjVvUDnECJ7ifxzBZW9crqbvDeDPX+poGDAHGCD2+xSkKJgdRbSfE2l+8zs5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA1PR11MB6566.namprd11.prod.outlook.com (2603:10b6:806:251::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Wed, 5 Nov
 2025 15:41:58 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9298.007; Wed, 5 Nov 2025
 15:41:58 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Moger, Babu" <bmoger@amd.com>, Fenghua Yu <fenghuay@nvidia.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v13 00/32] x86,fs/resctrl telemetry monitoring
Thread-Topic: [PATCH v13 00/32] x86,fs/resctrl telemetry monitoring
Thread-Index: AQHcSPAYySEZmJcLb0uXaCTwnPhdjbTZeoIAgArGzwCAAAGTcA==
Date: Wed, 5 Nov 2025 15:41:58 +0000
Message-ID: <SJ1PR11MB6083CFADE3EF56796BA43097FCC5A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <aQJkIqj--nHzUzUb@agluck-desk3>
 <9b0d336b-dd12-4e4a-b324-75734dbe6002@amd.com>
In-Reply-To: <9b0d336b-dd12-4e4a-b324-75734dbe6002@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SA1PR11MB6566:EE_
x-ms-office365-filtering-correlation-id: 02401a1a-8bf2-4108-66b7-08de1c81db3c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?NkgrSTAxamlQbFVQODVHMkd2MDNPZnREYyt4WENBVzlnc3p3b2pyeCtjR0NP?=
 =?utf-8?B?dUxmWlJhakR5THIyOGZvNWFQbDJyTkxsNXN5Z0V1emUrNlltKzBmajRpczBa?=
 =?utf-8?B?alVPYmZuMmhrUXF3R2RNRXdmK21Nb1JMSUhqMXVTS01KS0FWQWxOb0x1SERR?=
 =?utf-8?B?RVBaMFl6NEV3SldOOEI3WVQ3OW1Fa2tFRVM0TDYwSkt6WDZza3RwUE5qNDBR?=
 =?utf-8?B?UWZvUXJtRWVvY2dWalk3WnY0MlFpZURKcVR5bWpKd1liazhUTUN4NzhjNDBq?=
 =?utf-8?B?RDJvWkdUcVZndEppS3pVZE51eVNRMi9WZ09KdE1wTkkrR05TTlFlK0VRc2pY?=
 =?utf-8?B?N1N0R3FsU1VMSm1VZ2g3a3VSM2tkalNrSXpRMUhVcy8zOXEwWFdYTFFzUDZ3?=
 =?utf-8?B?akRCM0s1S0hGNk5JaVdqWWZ1Qy9BOEpMcEQ1enZ1aXZFU0tIaVJ2OEV1NWpk?=
 =?utf-8?B?SCs5Q2g5OFhRTWVVdmRvUFlYZU9Sb0pxcDViOVBTQ1pxOGRhRWQvQmFhN2Vk?=
 =?utf-8?B?V0VPcnZ5RFpuMURabFhrL2EzMDQyTlNFV3VOekdYZkpwc3NFUUxQZlZUN0dU?=
 =?utf-8?B?bExCdjhIdnhoTGJaWmRidWZOTVVOZTJ1M05UVnByVXI0WC84TE80ZzNBVmxV?=
 =?utf-8?B?UUhUblpFNHpaOGpCTENYb1RVVUZGY05xcVBtRjV2ellZTzFkajBwZjYwMDFy?=
 =?utf-8?B?Q3lLcVB6QUJoVTJZUS9mU09GSWpMM081eUlvcTI5dDl0K0VqM3ZYWjk4UlpZ?=
 =?utf-8?B?R2luUnVDMVpTRkFCcUJhenFmYVlZSlVLSDVYemxucXBZTkF6VWtZd3QvQzFw?=
 =?utf-8?B?RDViUTJOak5ObDkyMWRkSlBzV1ZtSnB1THZ6U1ZRVGRUOUdLRlBmUDZSNWxn?=
 =?utf-8?B?ZWN5cVlxNFJLMEcxVXp4Q0RBNTJCMXdaRVA4Q3Vza2IwczVRV0hCK1c5WGc3?=
 =?utf-8?B?UTVlcWZnVzRUTXZyR1NmczNia0I1U1NZZEV5Z1ZRa2VCNzljMTN6UUR4a2Mw?=
 =?utf-8?B?azRTRXRxTTV0eU5FSlZPZUpHVnRnZkM3bUxnVlhPcUp0OWtUdVdHQkg1ZE82?=
 =?utf-8?B?Tk10L2pxVDdPdWlUanJoT2JxYVE5TC9XbXlqMTVJUm0zb1U4Q3lqVWJMNUNo?=
 =?utf-8?B?VzNpTEx4b2VVRE03UFN4RUNrSFkwVEtrREJ1dXNpNjRNMnowdS9KcFllSzlm?=
 =?utf-8?B?Ykd4MHFIbTNrdXJ2d3lFRGxBN2k2eXR4ZlpPYmZBQmcrUFkrRnZTdXVJWlh5?=
 =?utf-8?B?bUpaM1d4N3dIQWNiWU5ENEwzR2QybFkrWUNRU1NyQmlCMVBRdlFSNUcwbEFz?=
 =?utf-8?B?VFRTelRmVkpXM1ZLQkpLUFZrT0JScm1PaFVUSzBCbC94UUxaeWR4RDF5NWIx?=
 =?utf-8?B?ZWFNbGU0NXNnQ0ZvTU5sTVlQMXFjVm1VMno5b1JMMEc3ck1rcmZVblZzVitt?=
 =?utf-8?B?dXF6WE01N21xLzVLZEFDVHFqM3JNTGpzSURMaUJaRUo4ZTExbERKVzFVMEN3?=
 =?utf-8?B?RTVmbGljeDBoY09GbkJJR1BSai9Tc04wVkY1blBCVGpiNjJUWTNCR0lYSDRu?=
 =?utf-8?B?Y25IQlNYVmIxbnhnbkhLOVo4SXNSdm52SEQzdzF3aGFQaHB3VjJZN3RKRXpl?=
 =?utf-8?B?cmY5c2VURWpBd2E4b1NDdTBhUDRqZHNYdDlQZzFzMmsxYlp2bTRaWjlJa3V6?=
 =?utf-8?B?ZWw1QTIzYVYwMWFiWFM3SjNtQ0J3QkpFdGo1MzRndW1lRGI5bmFoVDE2blNJ?=
 =?utf-8?B?VjZMYklSaGx6cUFuTEpTa21DM1JHbkxoMTVldmw2eWZDK3FkdVVqQWNPaWs3?=
 =?utf-8?B?RkZLMFpKcHBUaVFQUHlReGZKSHEvWjQ1U1Rvanp1UVdBbmFOL28xcDRKWVJW?=
 =?utf-8?B?Uzd5V0g2d3g3L2hFUXBVWXBaNzNwMzFpZURZT1ByWVRyRUVGVnBFYXRWRDJ2?=
 =?utf-8?B?Z2IxN2xmS1J4ekt1WUNtcGFuekdFNlByQk1WK1JrMG9XTWcwKzF4NkRrYklB?=
 =?utf-8?B?WElsSk1OcldKTVZmZDArMmZVankzOCthbUZFbkhiVG0vUDFZb3RSRkpaWWhR?=
 =?utf-8?B?L0VrUWRkN2ZKVlZrVmwvNjMrdUdXT25hS1NUUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWU4aWpmT2cvQUo4RlFweG1ZckZZSVljV0JNbFdHbElUaExQNm10NFlic1lO?=
 =?utf-8?B?WWp4T0NFRThIdXRVd0RCaUVMNGRNdi9KYzkwakFUd2R5N3VXRzdIeVNFSTNx?=
 =?utf-8?B?THZYU1BQdmsyVjZzeURQZ2VZS2g0QndpZXBiZkZhZDRSdW9Ud3RGVFJ2QzVx?=
 =?utf-8?B?T01YVXowS004cjlPcmFEd0FMRVpTZjNNLzB2RURtWlp5Rk5GSjZaRmtVdnZ5?=
 =?utf-8?B?V0p1Yy9lWXNSRUhPTWk1QytqMGFCU21mT3NaM01hOFM3MnhLdGNpaFZmbjI4?=
 =?utf-8?B?NFBkdEdNS2FIU0ZOZEdNUVIyTFRmQUxQazBsRHdycE95WGxVSDFXTDJFQ0Qw?=
 =?utf-8?B?SDJuRFdXdkZlaGZHSmdPNUlHNysxdTlybk16ZHZ4d2N3Q3NpNW0vcmttM21h?=
 =?utf-8?B?Y2dKS2Fzc0s1WmVnWGlUU0QzTlUvVXlUc053WW5sdjVmZC9Jd1pPTU9MK01K?=
 =?utf-8?B?UWlMMVNSY3RINVBTZk5PWVVqc2l5dHZnR2RXOVRJNngrNG9UNDJ4NkEza2lK?=
 =?utf-8?B?R3pKRjJXVllrdnd3dHRYV3ZicU1zZHVxYS9ibmxVRWFTL1N4SDJQRFJibUlD?=
 =?utf-8?B?VUZoZG5ZSDd4cEtReC9Mdk10aks1UlpRSU5KQmUxZWwvalNiWVRlS3Y2QVlV?=
 =?utf-8?B?M29sZXBZZzk5Mzl3ZUo2RzdlOENPWVpCbk16bVc3bG85NTJCRGJveHl6dzBi?=
 =?utf-8?B?SDNJVkQ3RlBVTUZQUVo0VGIrTDhad2dhTFd4R0VJMEVzTHQwc2ROQk50Y0Vk?=
 =?utf-8?B?VEhPUnQ0OExWcmdiMU52YWwyWnladXROVTI3ZjhXUUtpNlA5UGM4NGgwblhN?=
 =?utf-8?B?MUp6QTA4MEhJUlpNN3pzS3FWQUVTcnlQQWxsSWhFQW9ISFNqd2htd1RKaEF0?=
 =?utf-8?B?UXBzVEJnbkpDSGphaC9DbkM1VU9ZakVzVkoyYVBMVndyN2tNbi84U2NSV0U2?=
 =?utf-8?B?OERvcXc1L0RySkx0WEM5cU1UYnIycmVXa3hvUVkvWjRCYWd3TzdUcUdIYlBa?=
 =?utf-8?B?WVBnd1RybFBuMkw2NHpMRUdyVW5ETUZNa0tSWlRNcDRiUXpGaU52TnZBQS9v?=
 =?utf-8?B?dGh2V25wb3JkeVl3QkV2cnU2NjRERlpiVGlUOHRxZE5uTStBWlhnN3BzVFZQ?=
 =?utf-8?B?WkNQMWU2aGdnYzJMbkMyRmxIWGJKZWJRWStUTXBVTGNHbnhoYi9UUDBUb25o?=
 =?utf-8?B?dHFtSnFTU2hPOHlVTjFiTC8zSGRuTGduSkdFMkpRSUJnMUc4UElReUZvQ1Fl?=
 =?utf-8?B?cUhHWHAwVmg2N1R1YS9XZ2dSMXdyS3BEM2VGbU90eEwrTk9OL3F4bTFRZEhy?=
 =?utf-8?B?OUVSaittb0dxRCtNbzF2dmxTOGZ6WkxsUmFLODUxT1ZNbE1wUmdMSEFYbkNT?=
 =?utf-8?B?S2JDcWhkcjVXU2NhUlhCVkZtc29DY0kxbDRTa0N5WWlhTDFZc2VwVmxGeURM?=
 =?utf-8?B?bWo5MmNzSnQ1OUhNV2hXc1YxSjhBOHJ0ZGlsTitoWWVsUGo5UTljTG92alBX?=
 =?utf-8?B?T3pjZGtmSzgyTzVLQVZPMDJtMC9iZXNIRzY3Szcrai95Mm53T05wdUxPZEJj?=
 =?utf-8?B?TGFXQ0VXZFQrZGhQNHFzdU01STArOThJSlpmZVQyUXAraWJSYTRyS00yK253?=
 =?utf-8?B?Rk0ybEk4cWNWUjhaSVFYN292SGNTRFFVZDIxbnMvV05UQkh4aVRvdVBjQnN6?=
 =?utf-8?B?SXZyMkJzenZlZ1lmM25tWlZxYU81RGpyS2NxZ1ByenpoTGFzaTZYVURBK2Y5?=
 =?utf-8?B?ZnFKbVBZOUQ5R1BZWjR1aWhIRml0Tk9MVk9PK2Z1aFV2T0tkWTZjYzZUYy9Z?=
 =?utf-8?B?RExWVTN2NmRGcnRvTm1zbURBdHJHQmJTRTFwaE4wK2JtRHFnN0RFb2VTSVRm?=
 =?utf-8?B?RUp3N29wSFJrSzlIWkRwSHZRMVBZRjNQcVNwOEtQS01MeGNxT0lCNEFYMHJ3?=
 =?utf-8?B?SGFRS1gxSVVaY1BvZDR5N3YyTXk1OFlOTDQ0Rkl0d1R0dlg5Qnh6VW5jdTYv?=
 =?utf-8?B?SFcyeldFSHZ0MWRJcG5jbVg2VUlyeko5WGJ5YlIvRFBIN01obDZZN2U5cE5V?=
 =?utf-8?B?b3h5YXhPaDJwRlZINFJoYjBJbU83RDRPTTRSZVlseXphd3VsM2s2dC95dW01?=
 =?utf-8?Q?Itfq/xgqzXPlBpEEZUHYnDPA1?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 02401a1a-8bf2-4108-66b7-08de1c81db3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2025 15:41:58.7541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lfgIssbYVE8IorJv77DwWpWdq/a62klt0zl/dwTHQ9fXBNjVy2rf6mNh8wDTJ8ve5rYzq83oAfAYzXsBX4P3ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6566
X-OriginatorOrg: intel.com

PiA+IEkgdG9vayBhIHN0YWIgYXQgYXBwbHlpbmcgdGhlIEFFVCBwYXRjaGVzIG9uIHRvYiBvZiBC
YWJ1J3MgdjEwDQo+ID4gU0RDSUFFIHNlcmllcyBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwv
Y292ZXIuMTc2MTA5MDg1OS5naXQuYmFidS5tb2dlckBhbWQuY29tLw0KPiA+DQo+ID4gVGhlcmUg
YXJlIG9ubHkgYSBjb3VwbGUgb2YgZWFzeSB0byByZXNvbHZlIGNvbmZsaWN0cy4NCj4gPg0KPiA+
IEkgcHVzaGVkIGEgYnJhbmNoIHdpdGggdjYuMTgtcmMzICsgU0RDSUFFICsgQUVUIGhlcmU6DQo+
ID4NCj4gPiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYWVn
bC9saW51eC5naXQgc2RjaWFlLWFldA0KPiA+DQo+DQo+IEkgcmFuIHlvdXIgY29kZSBvbiBteSBB
TUQgc3lzdGVtLiBJdCBhcHBlYXJzIHRvIGJlIHdvcmtpbmcgZmluZS4NCj4gSSBkb24ndCBoYXZl
IHRoZSBoYXJkd2FyZSB0aGF0IHN1cHBvcnRzIHRoZXNlIGZlYXR1cmVzLiBJdCB3b3VsZCBiZQ0K
PiBoZWxwZnVsIHRvIGxpc3QgdGhlIHJlc2N0cmwgaW50ZXJmYWNlIGZpbGVzIChmaWxlcyBpbiBp
bmZvIGRpcmVjdG9yeSBhbmQNCj4gZmlsZXMgZWFjaCBncm91cCkgYW5kIGdpdmUgYW4gZXhhbXBs
ZSBvZiBob3cgaXQgbG9va3MgaW4gdGhlIHN5c3RlbSB0aGF0DQo+IHN1cHBvcnRzIHRoZXNlIGZl
YXR1cmVzLiBJdCBjYW4gYmUgaW4gY292ZXIgbGV0dGVyIG9yIHJlc2N0cmwucnN0IGZpbGUNCj4g
YXMgd2VsbC4gSXQgd2lsbCBhbHNvIGhlbHAgdG8gcmV2aWV3IHRoZSBjb2RlLg0KDQpCYWJ1LA0K
DQpUaGFua3MgZm9yIHRlc3RpbmcuIEdvb2QgdG8ga25vdyB0aGF0IEkgZGlkbid0IGJyZWFrIHlv
dXIgY29kZSB3aGlsZQ0KbWVyZ2luZyBtaW5lIG9uIHRvcC4NCg0KR29vZCBzdWdnZXN0aW9uLiBJ
J2xsIGFkZCBzb21lIGV4YW1wbGVzIHRvIHRoZSBjb3ZlciBsZXR0ZXIgd2hlbg0KSSBzcGluIHYx
NCBhZnRlciBJIGdldCBmZWVkYmFjayBvbiB0aGlzIHNlcmllcy4NCg0KLVRvbnkNCg==
