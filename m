Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3992428468B
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 16:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764692944; cv=fail; b=TP0NUnl8kQpGZ34bVLrm9QbA5Z9QxRWNjexed9Bcdb18x+Hle0uzEgzxSKgUc3p8RqzlfmlkN8ihofmW9B+rR/GIjt09jaHu6IPhSt3DuMcvnGkhwp1AxSulHw1PGlZ6yEeAbqNnJ72FRLrPNxPf35U6HburfuBklOsdeLBfB+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764692944; c=relaxed/simple;
	bh=2DY3lGhdC8rPjACaAZhp6s6tl5gMsojj+bJ+owowFMg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ApxfwL9/f2/Lyg1cSjx1s8tDrAmtgYl8xIXwrBC0Kn2EfwIvHMSSDcyA6fQNeAa+1qXCXZAXV1fPS+ae0cH1R+0VCESKYEwfAqCuwwI2PZGB9p6FJYnsqtfK2DrKngkUXuKh+hWSMwrMDAPw+batGVuWOIsQuhTcBRP4LaPGT9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HTeJXuHv; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HTeJXuHv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764692942; x=1796228942;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2DY3lGhdC8rPjACaAZhp6s6tl5gMsojj+bJ+owowFMg=;
  b=HTeJXuHvh3L0lpx25OR+bafShREz+nU25uis9Kj2S3J0Xusc8BXQoTGF
   e9H57XPBKocJbiIeja1sZtDwpcqAYaNozLbLFV8Mljxd2OGtUqps6zE/u
   DAqOE+IXaAOIlUEWTxg+UWTLRDcSbLkHUnkhbTe4gvSbqKlq9uvQKeOi5
   YpzE7rbeM/64XTO4ycEBWYFBBJBPJSkR5QiAwrEXXi+gMsRlRPeSDrsvE
   JPsPjpXfdeGI6000bNXFo7ldU83wtY0FNoUQg4Z+QZzjMWq8YaQ3XtzKs
   /2JgTHFX0PwK43aGNloiakrneX1ZRuYQIx2xgvyF9BBK7v6LeZRV/f0Ti
   g==;
X-CSE-ConnectionGUID: YbIxiAQ6R8OidIixFncECA==
X-CSE-MsgGUID: iq9OMWW5SpaZ7iYXOEKKRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="66384432"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="66384432"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:29:01 -0800
X-CSE-ConnectionGUID: gM1w+cApQMqZPXztTyKmfw==
X-CSE-MsgGUID: ps6w5T2dQVi0CKZYkSp/Sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="198888856"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:29:02 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:29:01 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 08:29:01 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.24) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:29:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=npqrNoeIPRkFbk5qMbqdY8v28Cisc7mZ1VX9ra1CPbIcMBL0oYu8B5qcq4L09iWqoYvep27kXYY2/KyqOWVdOpmDmGhp56p0gX81yD1piUSGOHuM2ietkz3GHfbcglBXGAW1+dH5c6CvzDj0iHqNGWiZMuop56KuQx740Igl8ucMWkwApX8WdrLSPvJc3ZuloFhaXa6iOiS88qGZsy9AWD85KeYyRSV3DqmiFyAxJOJtRQA1wzrJBKfrf9IDoJJRCbjVQCUVNtiuNBUTqVp5o+CQNMenMauWjw4xczTYbNFPhDKx6HlkkCT/aYn2toRG5msMu5eo8T4Rtao6tV8qTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VrvH7mulxZ1l6pEqp8a28vesC9fg/P+YKueFywszYpA=;
 b=yI5Y0yuI00k7qTrOed14N3URYbDbLYf4X5vdoex5oHksUNfF1ZkfBKSKa430i/6ly1aew7aLC1ahp5GQUMHiOU2Ey/66pgbJHCk67E3eiNslH+UI8yvJBatx1qUaqrqKcMBZEidPb3Mx7cuDfQS/Tabx0awBp+BSI+71B91d71oiuj3GRHze/7LCyQXcfPyjfNfHjNeVKNtdzzyCRUtfcwLHRoeAElx6/J9yMke7oShnmb1pVNnaxLGg8fKAh9PO2oo1SNbpt6EvHLnHDFJ2RVUMqt261s1D4OhnVMqPsXI2o3IWFc+dBd1mUPLcV4qWsO66CT8PmNN7V3SaWrU23g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA0PR11MB4541.namprd11.prod.outlook.com (2603:10b6:806:94::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 16:28:59 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 16:28:59 +0000
Message-ID: <ce70e96d-7960-4e00-bf26-8f61424e3171@intel.com>
Date: Tue, 2 Dec 2025 08:28:56 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 24/32] x86/resctrl: Add energy/perf choices to rdt
 boot option
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-25-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251124185412.24155-25-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0197.namprd04.prod.outlook.com
 (2603:10b6:303:86::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA0PR11MB4541:EE_
X-MS-Office365-Filtering-Correlation-Id: d6d82ff4-5cd8-4501-f2e3-08de31bfe54d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NXZ1b0FPRXRVaHFJYzBod2h5MmFheFZiVTRlWU0vZ0d1NlBpbjRGYWxPdUQ4?=
 =?utf-8?B?TDZ6MnhVcHYvL2FEQVgvMFZqWklQT2JFQWVUY0lFZHJobUhZTlN3R0UyYmlr?=
 =?utf-8?B?Y0FRRVZJUW1GQmx4WmNGbHZUdHNBVHlvN0YrTmhCWnZsYndqWnJrZGV6cmdy?=
 =?utf-8?B?TDVvSkFlMm0wVUp1ZVBWelNsckpUcDNJN3lTSkEwQ3NiUkdhSlVrNms2UmxZ?=
 =?utf-8?B?Q1Q1L25XNDl2MENSWlcwVzVRbHMrQXIxUXh6M0JiVnNyN29EdmtuK0Y1Szdt?=
 =?utf-8?B?VFZjZk11Y2FjM3NOVlFkd0drbm1lQ2dFS3pveTBOTVc5RjY3TFNBMFhvRElk?=
 =?utf-8?B?TGhLNk5pZTJlL1NpN016RitQUUxjZURwV1J6WjNPM0wydDE4MDdaRzlzN1I3?=
 =?utf-8?B?bG95VVFUN2todGRnQXF3MVIybm9IRW5VWFlSR0VIQWpDdU5SMENHVGg1RmZw?=
 =?utf-8?B?cXZtV3JadUFFSnhCeW94UWx0K0V4dWdqbS9jYVN6eDFmUzJLYTdTWmVyaHNn?=
 =?utf-8?B?ZHQwazBFaXdqL21YTk5qNmp5Q3JnR2lycG4zdzJ5K3FkQWF5c2lmMzdueVpu?=
 =?utf-8?B?MlJlaGxGeEl3SEx0OTZKKzlPYjFXT0JmWTJWcERibWZoUDVIRmNFMVdVelMx?=
 =?utf-8?B?ODZJN3pWbWRJKzhvUGcvT1BwWmVYRlZvRmlZeFVBYldUVXdySVMvSlJ0OFRF?=
 =?utf-8?B?NDFWUVhiUTVicWJ4dkRLVU9LN3JvQnNaSjdRbGYrRnB3TXQ1dERTWDFpMjZz?=
 =?utf-8?B?ZWtJUkkrUzcxZU1sanczQlVacjFSMVpaR3g1TEFiQ2d0RzZNTU82UGF5VDJh?=
 =?utf-8?B?Y1dkVEpMZ0crWS9zUUt0NStPS3B3YzJaZlRUTFlLUzQ0YzR1bmdvN0NTSi9o?=
 =?utf-8?B?QXBtZG9sUUpCcjhoUldHVGlxbDA4aXdRd0dNSy9ZT0hIZDRzZUQ3L21Rd2Uv?=
 =?utf-8?B?bmFVc3B4VzlndWNqakU3RmdIUUQxK3FqeDBncVVOekVUVFVNMGg2UWVJSDAw?=
 =?utf-8?B?NjBIYm9DaVE4UFZNL0RMVVQzY2lHMnNIU09GdGZRcEUxNENRVndGYUMrTG5p?=
 =?utf-8?B?UnZEcGc3Q0VpWjduTEo5MXFtZ2NOdUROY3lzUE84aStlaXVSSHVsNmxybkZR?=
 =?utf-8?B?Z3NOM0NKcjNBVE1YdmhwOWVkQTZMdWh0aU5YTEF4Y2paa082NWpsbnMwUVJ0?=
 =?utf-8?B?MkVHSExPUlJrS2lpT2ZOdHdmck9UaWNwSW9NQWdtTGY1dThxa0NMemcrcGhU?=
 =?utf-8?B?MVI2QTN1dWdFNnpUSWh0aGtEbGFZOW40WHBjUzcyK3UwNjY3bXRMRjBJQnhN?=
 =?utf-8?B?K0xucG1PYUVzc3BXVDFHaU9XZk1HeWl3Rk11K1RlTHlVUFJKTGUzanIxN3c0?=
 =?utf-8?B?ZWN2dzRDclZNT3hTY1JNMG9xYWtJVGZUYVZqNmNoUStSdDVleGppc1dYZnJP?=
 =?utf-8?B?SHdpVUJTbW1mODg3REZlU08zdy9tdmFhSEpNcGM3MjR1Mmpkb0hXejZtZW9T?=
 =?utf-8?B?RXI0K2d5VE9LSThQMzdLUUxvQ2FReTRIM01WaFl1WTBSUkw2YmFwVUlZUW53?=
 =?utf-8?B?ZWNtbHRLODlmYUdFUlZIUHZodURyRXJVZm45TDZsSzRXQUdmRE4rV0ZNUW5y?=
 =?utf-8?B?Wmh4WS9wWlpxYkJJN2d5UXcxQ0xyakJabGVVUUYyMisrbnZKOFRvbDExSHVE?=
 =?utf-8?B?cWJ0blBPcXhmRE5ubWRSODBKclI1SFhFQnJxaXFueGVQOTVUSXprYlV3L0k1?=
 =?utf-8?B?OHBrbHVZVkFxZSt0dEFwMExGb2dMZHFyUjkwU0hrKy9RVWV5VnZoblZVbjJj?=
 =?utf-8?B?SFg0cEVBNnNKczhpaHJ2Y01QaUthdSt6dGJEYTMwVVU3NHBidHBaMEZrRVZ5?=
 =?utf-8?B?UGErZWpSMyt6Z1NZYVBUcDVJSE03TzZoUG9CVnh4bVdjYUlqLytjVlM4RlVo?=
 =?utf-8?Q?sJRm6F3jZbjaTC8TMGk8q/KnU/KVIwrJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVVibDZQZjRKRitoRTV5S2x6aUN3bHo0TC9wSXNOb3NLbWVvbWlCNy90UHF2?=
 =?utf-8?B?Q0dpN2FqaUZRb00zaHJGRjk5UVphQVVLSUJqWExSZFRTd25pWUM0L0x5MXRC?=
 =?utf-8?B?R1ZLSDJtMlpCczcvQ3NZSHdnbXFmSEdld3FnLzBvM2NNZHlsTUpwcFRRQU9h?=
 =?utf-8?B?dUloWDFQZG9Qc0c1ZTd1ZTZ6YVNTRGRZWHl4QW5yNnNIWndmVWM2d2NkM3NH?=
 =?utf-8?B?Y1ZqQ1YxUk1hSVpXZEFwYVdHQ0g4aU0zazNMbCtBYlkzR3hNeUdFbW5LV2Mz?=
 =?utf-8?B?NXYzbVJ2djBleERneUI4bDVmN3JJbXVLc3RzWWdyL2RRdlFLcnVsbkJ5cnpt?=
 =?utf-8?B?VXpENkpVbG1IUkt5cDYyMHllTDZyNVYwbmF5TlNVRnh3a09kK0tMU2FuV0o4?=
 =?utf-8?B?UnVIQ29MM2hSbjBMRzQ3eVg2V0dZWUhCdjhJay9MS2NpSEVkb0c3NWtmWno1?=
 =?utf-8?B?T3B4ZnBSQ2xWSThHeTVqNEFrV0c1UDhuZ204c3NNMGhCdXVQRzUyVzA2aTMv?=
 =?utf-8?B?NjMvQkpzZE51M01wTDc1NUs2T3NubllYRXRoRXdsMkc5YlNQS1BicmExOWl6?=
 =?utf-8?B?SlZRMjBoUGNYYWlKZzVURXo4WjZKMEZ0NGh6MHJXeWJ3bjhUdEY4R1hrRkUw?=
 =?utf-8?B?THFQNTJ5UGo3U2pMcWlkajUzUWZIeXc2RGs3ZVpOUnVTcTEzY1dod0NRNWF6?=
 =?utf-8?B?VlZEc3paaFFycVYwelpzeXduSzBFSGRHK1Y2dnhmYkgvbkg5amh3cVUxTGxU?=
 =?utf-8?B?UG5kemF1MkNWMEJVL3pLOUtkUmVndGlhMmtERUtiaUlMZTZ0YU1xOEh3WWxt?=
 =?utf-8?B?RjZaT1lQUE1BTy9wbytZakllWmNTM1lsWWs4MmxRZmE4N0ZyZ3pPRno1ajU0?=
 =?utf-8?B?QTd0L0lqR2cwNXZIVEcxU3BpNXh0WWNEenVqTG5YVW5kWDFsbUFBaDBWNXp0?=
 =?utf-8?B?aktBUElDSDZXZlJWclo3Z0g2ZG5iTFVCTFJzR0dKVkFsVmpvUldnVXlteWI4?=
 =?utf-8?B?dWtONHJRSmZaZWwzUDF5YlIwZHlDUnpoUkpFZVZLL2cyM2RLdE02MWRRMEJo?=
 =?utf-8?B?cDF6SW1SNldLSTlQd1JVNjRkb1hjMVgzTGMwR1lpdDZrbGJNQS9ER2FadzZa?=
 =?utf-8?B?dFlmTUNJc1EvK2J1R3I4dTdHQ29KYVUycEJhZGZGNFJOUG1DQklFbFJBMXI2?=
 =?utf-8?B?U1dOaERoc2U2TVBnMWhnMXZ3TTJOMUUyOWt2L1kvaWhEUlBkWUUrdXMxNjJX?=
 =?utf-8?B?Zk1lUWU1RDhUUWpFdDhRRjE1emd2TUcyOUI0L0VYZ0VRdXhXRTJPTHBVMGtC?=
 =?utf-8?B?T1BuOFg2ZTAxNzFraEs4ekNiRWRxVVNwS1N0eDRYYmFaMzJiazgvSStTa2NV?=
 =?utf-8?B?WjRwYzNybXFTT3BzTS9xdktSenJsMHRCWllNNzhqZ045c1lROHIwa054Ulgz?=
 =?utf-8?B?bFhPYXl6N1ZPZUUwRlluT1RUT2JaZjBuc0RIUXFTV0pkNEY3Y2ZmbllWMWdV?=
 =?utf-8?B?emZLM0JhS05XdS84MzJ5SUFUU2gwUVR4T20wZmk4d2lGUVdZc2xpNHZLQnFy?=
 =?utf-8?B?dDk4RUVLYWw1cEx3aDB5ZTlGdGNEck9hLzM2cHlJbE9rMTZoWFdsWFc0Sm5Q?=
 =?utf-8?B?UkpvMi8xUDBib1BLbkpZd2RYNmI2RklXUFNnVGI2dXlGMDZnQ2RDckpXUlJ4?=
 =?utf-8?B?cTR0UktyZS9FM2xEQzMzLzRBTUsvdXo5SjdrV090MTlLZ2tSUHlzQll2akRU?=
 =?utf-8?B?bUNEUU1XQmRtK2JBTEhWK3l4TUVTNURuM1daZTJPSzA4ZmN4aXhYMFZ2eElM?=
 =?utf-8?B?TWZ5ZzlGRHRJNExod041SnRXek0xS2VDUnNCQVdXSnpybVZYQXdrd21TUUFv?=
 =?utf-8?B?ajJyRUticGM4bi9lQm5iMnJsaEVaRHRCVVJvd2JVWnRtcXdUTkROS25DTSs5?=
 =?utf-8?B?ZUIzQWZGbkRWT002T0tzbFU4N1V3QldaN0x1Z0tXdDhmWHNkSEhwR1BBSExx?=
 =?utf-8?B?TzlldFl2eExkRklobndIRGl5M0ozWUlsb2E5eDRDaUdoUGRGMVEraVA0UWNp?=
 =?utf-8?B?Qk5SQjc3QlJSQmwwT0tGWFpBbE9UL2o4bGZDOW13eWZGc2VacTNxNUN5bFdk?=
 =?utf-8?B?ZE9PcGdaYk9teGRscXFRMWVPeW9uK2JieUNNallYYzdXRy9XZDZSVWMxM1BB?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d82ff4-5cd8-4501-f2e3-08de31bfe54d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 16:28:58.9896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KutjKkits19S8qpMCAVBu+Rf0DryiDZgGT2CxphFvHkQ+274AmE319ZsY62uTsZiz0z4anMsqaiIhQ37jiznoSPVJY9h0JvYBIaJlaPgD7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4541
X-OriginatorOrg: intel.com

Hi Tony,

On 11/24/25 10:54 AM, Tony Luck wrote:
> Legacy resctrl features are enumerated by X86_FEATURE_* flags. These may be
> overridden by quirks to disable features in the case of errata.  Users can
> use kernel command line options to either disable a feature, or to force
> enable a feature that was disabled by a quirk.
> 
> Provide similar functionality for hardware features that do not have an
> X86_FEATURE_* flag.  Unlike other features that are tied to X86_FEATURE_*
> flags, these are defined by the feature name.

This needs an update. Above describes previous implementation that was a generic
"for hardware features ...." while the new implementation is specific to telemetry.
(also needs imperative)

> 
> Users may force a feature to be disabled. E.g. "rdt=!perf" will ensure that
> none of the perf telemetry events are enabled.
> 
> Resctrl architecture code may disable a feature that does not provide full

The changelog needs to be clear on what it means by "a feature". Above implies
that "a feature" is all event groups with the same feature type ... but the final
paragraph implies that a feature is a specific event group.

> functionality. Users may override that decision.  E.g. "rdt=energy" will
> enable any available energy telemetry events even if they do not provide
> full functionality.
> 
> An optional guid can be included for more granular control of features sharing

"User can specify an optional guid ..."

> a name. E.g. rdt=energy:0x12345 will only override disabling of the energy
> feature with guid = 0x12345.

New implementation information just slapped onto the end of changelog.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  6 ++-
>  arch/x86/kernel/cpu/resctrl/internal.h        |  2 +
>  arch/x86/kernel/cpu/resctrl/core.c            |  2 +
>  arch/x86/kernel/cpu/resctrl/intel_aet.c       | 37 +++++++++++++++++++
>  4 files changed, 46 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 8c5636a120ee..e47def4a3dd8 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -6207,9 +6207,13 @@
>  	rdt=		[HW,X86,RDT]
>  			Turn on/off individual RDT features. List is:
>  			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
> -			mba, smba, bmec, abmc, sdciae.
> +			mba, smba, bmec, abmc, sdciae, energy[:guid],
> +			perf[:guid].
>  			E.g. to turn on cmt and turn off mba use:
>  				rdt=cmt,!mba
> +			To turn off all energy features and ensure that
> +			the 0x12345 perf feature is enabled use:
> +				rdt=!energy,perf:0x12345

The short "energy" and "perf" is reasonable to use as parameters but for help
text I think it will be better to use "energy telemetry" and "perf telemetry". How should
user interpret "energy features"? While "features" may be ok as a general
term the example is not required to use it since it is specific to telemetry monitoring. 
How about something like "all energy telemetry monitoring" and "perf telemetry monitoring
associated with guid 0x12345"

>  
>  	reboot=		[KNL]
>  			Format (x86 or x86_64):
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 0b7f8317be14..304e6e341905 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -236,6 +236,7 @@ void __exit intel_aet_exit(void);
>  int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
>  void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
>  				struct list_head *add_pos);
> +bool intel_aet_option(bool force_off, char *tok);
>  #else
>  static inline bool intel_aet_get_events(void) { return false; }
>  static inline void __exit intel_aet_exit(void) { }
> @@ -246,6 +247,7 @@ static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64
>  
>  static inline void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
>  					      struct list_head *add_pos) { }
> +static inline bool intel_aet_option(bool force_off, char *tok) { return false; }
>  #endif
>  
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 283d653002a2..960974ffa866 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -820,6 +820,8 @@ static int __init set_rdt_options(char *str)
>  		force_off = *tok == '!';
>  		if (force_off)
>  			tok++;
> +		if (intel_aet_option(force_off, tok))
> +			continue;
>  		for (o = rdt_options; o < &rdt_options[NUM_RDT_OPTIONS]; o++) {
>  			if (strcmp(tok, o->name) == 0) {
>  				if (force_off)
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 46c64419ec10..50c8b4c50790 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -57,12 +57,16 @@ struct pmt_event {
>   * struct event_group - Events with the same feature type ("energy" or "perf") and guid.
>   * @feature:		Type of events, for example FEATURE_PER_RMID_PERF_TELEM or
>   *			FEATURE_PER_RMID_ENERGY_TELEM, in this group.
> + * @name:		Name for this group (used by boot rdt= option)

This needs a new definition since multiple groups can have the same name now.

>   * @pfg:		Points to the aggregated telemetry space information
>   *			returned by the intel_pmt_get_regions_by_feature()
>   *			call to the INTEL_PMT_TELEMETRY driver that contains
>   *			data for all telemetry regions type @feature.
>   *			Valid if the system supports the event group.
>   *			NULL otherwise.
> + * @force_off:		True when "rdt" command line disables this @guid.

Per changelog the architecture can also disable a feature.

> + * @force_on:		True when "rdt" command line overrides disable of
> + *			this @guid due to insufficient @num_rmid.

The idea of "insufficient RMID" does not exist at this point.

>   * @guid:		Unique number per XML description file.
>   * @mmio_size:		Number of bytes of MMIO registers for this group.
>   * @num_events:		Number of events in this group.
> @@ -71,7 +75,9 @@ struct pmt_event {
>  struct event_group {
>  	/* Data fields for additional structures to manage this group. */
>  	enum pmt_feature_id		feature;
> +	char				*name;
>  	struct pmt_feature_group	*pfg;
> +	bool				force_off, force_on;
>  
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
> @@ -89,6 +95,7 @@ struct event_group {
>   */
>  static struct event_group energy_0x26696143 = {
>  	.feature	= FEATURE_PER_RMID_ENERGY_TELEM,
> +	.name		= "energy",
>  	.guid		= 0x26696143,
>  	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
>  	.num_events	= 2,
> @@ -104,6 +111,7 @@ static struct event_group energy_0x26696143 = {
>   */
>  static struct event_group perf_0x26557651 = {
>  	.feature	= FEATURE_PER_RMID_PERF_TELEM,
> +	.name		= "perf",
>  	.guid		= 0x26557651,
>  	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
>  	.num_events	= 7,
> @@ -128,6 +136,32 @@ static struct event_group *known_event_groups[] = {
>  	     _peg < &known_event_groups[ARRAY_SIZE(known_event_groups)];	\
>  	     _peg++)
>  
> +bool intel_aet_option(bool force_off, char *tok)
> +{
> +	struct event_group **peg;
> +	bool ret = false;
> +	u32 guid = 0;
> +	char *name;
> +
> +	name = strsep(&tok, ":");
> +	if (tok && kstrtou32(tok, 16, &guid))
> +		return false;
> +
> +	for_each_event_group(peg) {
> +		if (strcmp(name, (*peg)->name))
> +			continue;
> +		if (guid && (*peg)->guid != guid)
> +			continue;
> +		if (force_off)
> +			(*peg)->force_off = true;
> +		else
> +			(*peg)->force_on = true;
> +		ret = true;
> +	}
> +
> +	return ret;
> +}
> +
>  /*
>   * Clear the address field of regions that did not pass the checks in
>   * skip_telem_region() so they will not be used by intel_aet_read_event().
> @@ -178,6 +212,9 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  {
>  	int skipped_events = 0;
>  
> +	if (e->force_off)
> +		return false;
> +
>  	if (!group_has_usable_regions(e, p))
>  		return false;
>  

Reinette
