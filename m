Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E57435CBB2
	for <patches@lists.linux.dev>; Wed, 12 Nov 2025 22:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762985803; cv=fail; b=AVpI/qzvBTKUh68YpaDPu/uGJVNOulU27klWb9scyHqpDdNzwc036hqnWW60O6VQFIWCT/FqiUsaJa7+KLCuisw6jZ0PNmRb5O0C09HFQBYqClUjBhL3RJLSqEiAnC+A/4u+o7PqonvXu+vjr9PuuXYEsm5jME7jntmGFIg4ebo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762985803; c=relaxed/simple;
	bh=ewnb5Irp++X79G9LWCVYTXNmByp+D/9BLf9ZMxrBncU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kAkGqyQEkA3y/EQ3N9BgBr7WJczPGucTZYK9o93HLlhssolNNvNZRHmDYsIm+Iv/bb7VN8n63UO6QcSqfgCsFbXMmjWQoYDVMpK2e+uTLTy0ZYaVz03JIidIhB7ubUI4WkdrD6J9Biij7KJ40UpOqQtp8hUOBbyRQ/paj1nDrKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j/2cdpSQ; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j/2cdpSQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762985801; x=1794521801;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ewnb5Irp++X79G9LWCVYTXNmByp+D/9BLf9ZMxrBncU=;
  b=j/2cdpSQ54gdCrvPXhDpqm6SF2w/6Dhr4IcXbibm+25y+XYzAXe8Mq1C
   AozozMszpnAet4G9GB0ncw2eJV3YfWfxtN9NdgcSXi8Kn/aoZNLwHLl/n
   KZJyzakTCFdj7IRgBDtJKGNm04bkELbjHof+Ygmt4hFTkQ6OqLtBgYui6
   4H1ZMl7TJCqgoe9ewtCd50j8HHul9oV6cmshnyLzOILOLEmvaTQfQ316y
   7kFqrsE+qIPJGGDAJ3Bu18G1ftT1HIIzfHWo7Q+tNXrkeDzNtFxeZWVjK
   IGOp0QwioUVxUeNfTwm2sSNEJ5cwer6zLSyA3l3xnvXEdj48FEfnXB6Vv
   Q==;
X-CSE-ConnectionGUID: 4ih8pbZ5T+OVEskUCzSUWg==
X-CSE-MsgGUID: TBbHub0CSje7xgHkVlEFfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="76522351"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="76522351"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 14:16:40 -0800
X-CSE-ConnectionGUID: VpFyDpjfTlK2b3Ot/J1Vfg==
X-CSE-MsgGUID: 2XCStvbsSLycDUr1wcGNSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="212731033"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 14:16:40 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 14:16:39 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 14:16:39 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.39) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 14:16:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xEiWCPNhS+/zEyl3qo3MUsUtI9iPjzqHvc1DfuuwLyJ8rQnkIsCKo68W3EkNEYMb7JuG1ayJx0+/Ct741L85Jz5GWuC3Dq/Q/xrPRGrxaXu1nmG30ef5GdcC0TlVrp1QlbMZH/o6S7iVmbn9enKpkXl1o44JJEhbjSp8wlU6vFjmZp+WTzy+kXKyJ7RqpJ1kUwGeHY0TrskMbhbhjwZXUfwnfMpXs4BX/6/Nuc52guLgJXKZuFbSklxs9aN6rG9PM199FHZc+7wrSJIP5vu/lgBhbGANo4xPsXJ+sF3HhUCvI2pUDr+qU6gA3R2nUvJhZZeCFiTdWOvf2viMZ6Vwcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdYFld/51jgfucb3VG9WBngvzshr9QRSN2PmPYaPNOg=;
 b=M1/k7ZkMJz1HZl9aXRJCHFKrt8KNp7PR++7rLlmQcqT7Z3s4WS1YREzqtTrWMp24oaJdGn4FUDF4SQb5B1Wo71rmhJ0BziNC6ye/2c7WTplaTivszKePxv26xAYqX0eCdCCPDA/PYcsKbWrQT9Sb3vrmHxwvElTFPlcv0yc+tIgG9S0bxQzWMkKmH+JXp2AWryeAW0p24gZc25ABM6usoBFskK24/cfkQIsaz79zo6GITOb8hfItWOYmxHveb5iclWt6Mj2iSm/z0GV5SgmlEbOZAGQopaHHEsdBOpRctU7EF7ip/+Vlj8kGwR5WcPZQLx6pV7XT4qqlFQAFVuk5sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8683.namprd11.prod.outlook.com (2603:10b6:8:1ac::21)
 by PH8PR11MB6926.namprd11.prod.outlook.com (2603:10b6:510:226::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 22:16:36 +0000
Received: from DM3PR11MB8683.namprd11.prod.outlook.com
 ([fe80::5769:9201:88f6:35fa]) by DM3PR11MB8683.namprd11.prod.outlook.com
 ([fe80::5769:9201:88f6:35fa%5]) with mapi id 15.20.9298.015; Wed, 12 Nov 2025
 22:16:34 +0000
Message-ID: <215e9744-e772-4cc7-8d37-12c8aef6219d@intel.com>
Date: Thu, 13 Nov 2025 00:16:29 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 638/849] accel/habanalabs/gaudi2: read preboot status
 after recovering from dirty state
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, Koby Elbaz <koby.elbaz@intel.com>, Sasha Levin
	<sashal@kernel.org>
References: <20251111004536.460310036@linuxfoundation.org>
 <20251111004551.851781626@linuxfoundation.org>
Content-Language: en-US
From: "Sinyuk, Konstantin" <konstantin.sinyuk@intel.com>
In-Reply-To: <20251111004551.851781626@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0002.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::12) To DM3PR11MB8683.namprd11.prod.outlook.com
 (2603:10b6:8:1ac::21)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8683:EE_|PH8PR11MB6926:EE_
X-MS-Office365-Filtering-Correlation-Id: b8ca47ab-b71f-40e7-41ce-08de223923cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dVlWQkNITmdUOThiM2EyOXR4SlFYNWRSSERESEhKV3V3QWt4N0VpdGFGN0xw?=
 =?utf-8?B?c2szaFFqbk0yZWhydnhpcjdkdnhITHpDMVQxNndreDJHbnV2TnBRazlIK1Rp?=
 =?utf-8?B?ODI1eFUvR0NTakpNckdrdXROTDN1eXNnS0FyRC9RMjNmVWNiOGRkK2FKWlJs?=
 =?utf-8?B?K1VEQ3dkTlZjOVFrR1NqUGNxWW12U2xQcFd5RGxSVk1pdjE3WDhudHE2UkxR?=
 =?utf-8?B?LzV3SW5FQjFGWFZITVVSMmY5b2pwQlhvWWloTVU2NUw4ZjNBOTJtRjdIdXhH?=
 =?utf-8?B?UUpTeGJXVStKdXZBMTBnbUs0cDhKUzhkbEl0ZFZsck9ocDBtZDc2cThubVhB?=
 =?utf-8?B?ZkNSTmRDRVF0dHpkdU94OHBoSWJ6cjZEWU1iOWNaekZIdDN3VVdMTGExMDVK?=
 =?utf-8?B?bFpqWDNWVFNVZkI3ekZoVGNlNVpGVHVqN3FXSXkyWW5Yb2ZaU3UzYkhEbTZx?=
 =?utf-8?B?MllKbHZRV3BGazlNRUNaWS9HalFrWUJOTm8reTN1aUF4TDA3eW9CU1RDd3RF?=
 =?utf-8?B?STdJa3FMcXFhZ29zeWJwUGtsandXMTc4cDU3aWRpTGF0YWc0OHdyZ2VIUnNL?=
 =?utf-8?B?ZVNOendJOUpBYVJ4N3R0VVYzd2RIUEdpOTQ2U2NPQlRCTzRwRTd4bFNjWm5X?=
 =?utf-8?B?b25USmJGMGtnNHFNQkhKMXpIdldHL2JkUDlIZUdXeHdoT1RBRFVIQWZYMmNT?=
 =?utf-8?B?ZFVabzdxYzJ1ZG13dTFRdExNbnBGOFB2YjNTVDV3Y0ZCMWVNMzh3NWlGL0VT?=
 =?utf-8?B?N0xYVGs1cElXeStuYUVqajRiZ1Y2Uk1OdENER0oxdTBSWHowaVRSNjY5Skhu?=
 =?utf-8?B?d0RiN0tCaHptVjY1TEpzRGFKOFdvcDRRL3BMMm5kNSthVjliTDJTVVYvYXFC?=
 =?utf-8?B?QlZFUVowTkVXNEtaNElTVDEwMGVya295cjYwYUNaZ01DQStFc0FINEJSdVNh?=
 =?utf-8?B?dWZpcDhKNVFseWorNEpJclZvVzIxUWg4cHcrOWlTYjBGV0prTXBrck91dTd1?=
 =?utf-8?B?YXdxQ0hIc3Y0TGlSMkN2eFd6OFdRVWxIQjZlcEFadjlRQ3pjdGtDU1NudG9s?=
 =?utf-8?B?Q1I0Z1BjM0JIMDM4OTA5SWVBRDh3SzBoN0RhcWZ2MnBPWEZPKzVabnMwZ0Zh?=
 =?utf-8?B?NHYvbUFPSXVNaWl6amJucVp6WDh1eFhnK1dlV21zQ01WY3FRWktoekVvYmtm?=
 =?utf-8?B?T2VXUE92SG9vS3VmMU9HeTNHNStnYjVuTDhlbEtONzFxaXhrcUM5bEZaMXFl?=
 =?utf-8?B?UjZGQytVK21Pbng2WmNTQitySHpHdmsvQyttVzNQV0s5ZHlKSCszMzlPVXBM?=
 =?utf-8?B?aW5KbERnejZacmJhYlZDbWZ4VzVkL2JtNkZ4OGVCZDM3TFZocEV6eUZCbWtZ?=
 =?utf-8?B?TmVRSzlUZXJJWnYvMjhKTnpmZXpDc1pNWnRCUG9zNmlYTHRLejdzampac1R5?=
 =?utf-8?B?YVRzVUNlWmt5Ykl2akJTUlhnL1FQWnArdWZldVBkZXVZaFo0dSsyLytRWitl?=
 =?utf-8?B?Ui9OWktMUHFyWUhCK2JOOGpUYnQ1NWNnNUdxUmIrcFVDd0d5bmVYUm9yYjZ5?=
 =?utf-8?B?b3pJL2V2UFVMQmlJZ0ExTE1HdDBjRXNGelhHMVI0ZVNiK3V0SXBYbzlPVDU0?=
 =?utf-8?B?cm5wbFQwY2FTSEFZTVdKSHJmNVN4OWUrOTFwY1dRdlNQTVRkYkdCdVBtOVdH?=
 =?utf-8?B?cWJ6YkRaVHJsNVhWbFdXOGxnVDhHb1U1dHAwWnR4K1ZCMDVUR2QxNnlWT2xE?=
 =?utf-8?B?RzVlVW05RUZsSDZFVjl1c3RLK0JZb3hwVFpDYlJCbEhrYkZQMERmQys1dHpm?=
 =?utf-8?B?SzArbzExKzR6S29tVXh0ZXU1NTlGblluUWVTZjl6bUNkNDJMeFFzbjRIUWkr?=
 =?utf-8?B?ZFByNk5rNlZMWTkvV1ZyNGZCNGluay9neXRGc0FldWVvT2pVUjhuMGlKcUgv?=
 =?utf-8?Q?KTpvuZ/Qp9PYeUmkrF6noLCn3MIjCaIJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8683.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QkhmUVNsTUpSZDVKbExSazNlVDJJcFBYS2MxYVp3MTQwU1lOSG5MQ250NjlI?=
 =?utf-8?B?RitCdFNOUGVBQVhkTFBoVmpzZHBqMHJweVJtSUQwWkxIditLZnBWTWwzblNI?=
 =?utf-8?B?RytmS29hZUIzaUt0N2FQL0NSZ01WbWhuanNsVHF3dzBsTEQxUktzR25RbEhr?=
 =?utf-8?B?eitUZ204dHNNQUdLU1J4U25JUENkNGxxVFR0NTJuMmVzckdRVVhOeGpLZlFa?=
 =?utf-8?B?OExxWTNSVjh1TmxYS3QrcndUL2k1MkVhUVRUeFI3MzRuM2ZpRzJERGFzaW1P?=
 =?utf-8?B?OVdsaDZMSFQyVDFHTURRZ1RYeVE4QXhkS3d1WHlKL1poSkJjRFNlNU5CSjlm?=
 =?utf-8?B?SysvMVBFSEdON1ZuQzF3VGNldEZUUDZTalRBQkI2ZHE4VUw2RFFKRTlrejVC?=
 =?utf-8?B?a2JUNUR1S0dHV1VTQm5PbkJ2RmxXZXFHVjlEUHhMU0dMa29VL3h0aklvVjlO?=
 =?utf-8?B?TStJT29YRnFzOVZLQXp6N2NSeE9MbFFocFR5eXpCMVFhbElnUmYvd1ZINktM?=
 =?utf-8?B?UnNacjZEWWhlUXozWHZ0aTZId3d0ODJUVlBZOUNhdUxNbnh1QXR0V2xrcnN4?=
 =?utf-8?B?Nlk3Mi8zR01ndDFwQmFsbWJyeTM2eDhQYnZsdlBtcFNqNFpaMGVUVi85WU5T?=
 =?utf-8?B?K1p0NjVsZnEwN05mUUU5enBQcy82SnU0SDhyYVJ3V2o4dW1aaUJyblo4VHdi?=
 =?utf-8?B?NVN4S0dtT3RGQ1lnU0N0QVZDQzNPamJ3VjZUdzd5ZlV3d1hqbm5mQnorMjU1?=
 =?utf-8?B?TEpXbXZocnVZNk9lbmN1VXk5TVgvUEJVK2RMRHREbFBOcitaRGVCZm0vNWNy?=
 =?utf-8?B?MFJEWFd2NzNVOW9YTFRUM2NDeVV1UC9YRS9NR3NCM2N1dG1pRTlNRVFSS0FY?=
 =?utf-8?B?KzEvTzhMVmhuOEgwdjRGQnZ0SWlCTmlUNmFmZThlMkgwYXpRMTZLVjBVUklC?=
 =?utf-8?B?NUhEZ0hEdUo0S29PbkZRZExSeWZuS01uUDZWb3BlaVdIUC96QXNXN2paQlEz?=
 =?utf-8?B?dXY2RG9keHhib256T091Qk4xdklDcm1VV3EzeDVJRkZIZzcxbnNqN1BqS1FP?=
 =?utf-8?B?L252OUwvS21mbzFyd3ovc0hCT3hkbUYwcGF5NEdFcXZ1ZmpNQnhwZTZrWlBt?=
 =?utf-8?B?UVdoaFdsU2R5TUErazh4SGJsY1NLTjBMaTZzbVQxY3hGR0xTaW5PQWYrWlhl?=
 =?utf-8?B?MGdJQXdmT0RQZVZDdDllWEVyaUYyTVJqWVR6eDdqMVovS1NKNGx2dkJRbDNa?=
 =?utf-8?B?blFCK3dNcWt5VjZpK0twNDNtRS9CbklTTXAwbWpNVzJ6M0FMMDhVV2tDWUZv?=
 =?utf-8?B?eU1WeXV4UTVNNWdGNkRVTFM4OGIzbktUMm9CVGxRRjZMUG1tbUlZaWQycmM1?=
 =?utf-8?B?MnhMS0lPemV6Z0VMSm83d1FmWGJ5dXRMOVFWRWp5Z0xHM3FabmRlUnFvMjRD?=
 =?utf-8?B?UUZhL3duN2VXZ24vK1BCeU1naUIzQTRFMHNaa1REUTdkUjBHZmZvd2JnSVox?=
 =?utf-8?B?MjZ6cFRybEJ6RTlkME5abDZmNzFMdVFjVi8yR3FDR3EyV3MvRHRIR2JYcjZp?=
 =?utf-8?B?WmpoY0hVa0dsazBVc3dsZ3RwUDRmSktvc1E0eVYvQnNWOHJ3dm9hRzJqdC9p?=
 =?utf-8?B?TUtGVmxMSURjaGRRRjUzTGVjU0tVbGJBL295bGRiNEpHYWRIR3BzTG9zWkh6?=
 =?utf-8?B?ZERndWVuZS9uaDBKdkIvS2dnY0l5SmlGYzVWRFVRemJWbWEzbHlCRFo2elJz?=
 =?utf-8?B?a1VoS0Zla3kzVTkycVdTZW1kSjk2N0pHRzNPWEE4b0cyVTQ4cWNkQU5JcXN3?=
 =?utf-8?B?YStSUFlwbGJUUUNKc0owa0J3eFRDOXNpM3ByaVFEQVVPZGNNMndTdWtsYkkr?=
 =?utf-8?B?UW1YWHp1QU5EaFJwZjJVM242Zno3RkdGc0RYL2Vqd3V0V3VHeS9jWkw4cDY1?=
 =?utf-8?B?T3dnaVlLN0NVU0Jza3oyZTdyOHA0YWJHRkhrdUwrdS9vYlZ6TFltRjZnOFdC?=
 =?utf-8?B?bk5LOWpRdUJ6OUNRdnNhWnFYbkhhUWJVeTFoOHpmOXV1OXBheXA5bnN2NFls?=
 =?utf-8?B?YmMxdmV6WVEwYktyYW85L3YrYnFnaTBCRzE4R285RHNEbDhtZGZtbmQ3cnNn?=
 =?utf-8?B?K0JXMGhWK1NudlMwY3p1azVRY3IxaWV2SFFtbE5halA0TVZCeXdxSkhiMThS?=
 =?utf-8?B?a0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b8ca47ab-b71f-40e7-41ce-08de223923cf
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8683.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 22:16:34.4714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B79ZmINnCxY3pgxKKAYZ5U06y+SUA+Jo9TWbStQ3kJRjm0bpElQGBtrgz98p2P2+a1ICzyQzLYgK5eStQl/Ibns0KDyufMAT532N4u5AONw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6926
X-OriginatorOrg: intel.com

On 11/11/2025 2:43 AM, Greg Kroah-Hartman wrote:
> 6.17-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Konstantin Sinyuk <konstantin.sinyuk@intel.com>
> 
> [ Upstream commit a0d866bab184161ba155b352650083bf6695e50e ]
> 
> Dirty state can occur when the host VM undergoes a reset while the
> device does not. In such a case, the driver must reset the device before
> it can be used again. As part of this reset, the device capabilities
> are zeroed. Therefore, the driver must read the Preboot status again to
> learn the Preboot state, capabilities, and security configuration.
> 
> Signed-off-by: Konstantin Sinyuk <konstantin.sinyuk@intel.com>
> Reviewed-by: Koby Elbaz <koby.elbaz@intel.com>
> Signed-off-by: Koby Elbaz <koby.elbaz@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
Looks good for 6.17-stable. The backport correctly re-reads the preboot
status after recovering from a dirty state, restoring accurate capability
and security information following a VM-only reset.

Thanks,
Konstantin
