Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0B02114
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 04:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755144840; cv=fail; b=Vs8a4ukOEjhWZiqC6ptld0EbISZqqv69MEkbNcuMhg/K+8it/bFhyPbzEaghZyA6SoiwfRyNNjJBQjgik2gH+a5FxsKSZ7TMMwp8I6D+Zt0BbrHflBDHV7Yamh1drnnNzbkZBGUyMY6v1mfktOT7q5orv7soQJly4nvoKFRo8rg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755144840; c=relaxed/simple;
	bh=DSpPJsOgLVFugJPbOF7sw/0Y5mwxjz/dOgtDgan06M4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FYIOTUGv97Yfjt61ZSGRAyp1D2JM9KFRXMxwN8+phTjlnGIXi2vEvBm8mJgq++G0kwndQYIbKUCOEkA2k1UDe7kNYpHiBiWdYTM26QkHBRE6upOa+fG1OZQh6oURupgQlob+vmbOx7tH3MmBU4bsGhZ3NtVNMt4G+qToxcKx3D8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XXMV9mBR; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XXMV9mBR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755144839; x=1786680839;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DSpPJsOgLVFugJPbOF7sw/0Y5mwxjz/dOgtDgan06M4=;
  b=XXMV9mBRsWK14ncANxkgNNvrYeeLyu5FPR3/YvFhbZLUN2TfKZP/oJMi
   Ngfv9aro7AyOxGh1SmNoWZtnDF8YDAWQARfwH+0g4/PO3gJzKdq1wfH/H
   n+L3H6XgvIo1NpYCmfGANx45yzwpG6gc5YMT+MeZwO0fk55wKIouvHDrF
   DR33G2SFFvdj3YDa6CyI6jtLxyvUsZoDldSshs84hbWP2Uo6Qom8DViAJ
   Gcv/pURcdryGGZr9gQ6BFSvBgDBopGDylOEEa4St7eWswt1GXMLJkzA+a
   bUvAl9XtDfkvtDcQHSBkg8r609lAyVh3Kjn5lUUN3uHJKw0BUyv4KRHsp
   g==;
X-CSE-ConnectionGUID: 6jqNNlSTT7aPlMRb1m086w==
X-CSE-MsgGUID: ijrGHpV1Sa+5xbKvMq76Zw==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="56475697"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="56475697"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 21:13:58 -0700
X-CSE-ConnectionGUID: NBCG+CrDTLyPdHktBD+m2Q==
X-CSE-MsgGUID: sQbXx7ctQkuTahxvw/aLTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="197648507"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 21:13:58 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 21:13:57 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 21:13:57 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.85) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 13 Aug 2025 21:13:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t8aZrIoY5hoiTSZ/LTK5Z1z3/sm0o75AfDs8N7cfvH5V+wculbMOv6zIr4AMItJ+4+LTePHF1atD6CXld9QETPl2ebEjHpAQh6bv6Z5Yc3bDoMayJRZhmtvqs+59ikBXksPFcv1JRubbj/vVeVK5YPUx19UhgHwU8+KUr3uejPbZjkzSFiuAEqTsgeZQ8Hsznq+/ys+vVjF47yxaI5PX3SofuYul3ZGzkmGqjcQRophalqDt7FpVOargNRXW7Z03YF25Z8K4uSQaeC0DPC0FpoCQv1B5XuIj/sa+hnZNgSnhMux93u+oJo8Gb7ZOovfREpHYETIlJGt03NBnMiB+Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kctYUtWT/ULMwgvNZ7lru3nX04WZmBamLaht4RsyCI0=;
 b=YyIwli4/Q/vGImkJwKIXzGGDl2Kpf8/0OjQVsA1MyeWBMWl7Cho1/V3HDXx4ialGz38v7BE6DTN6ZSYmQpsbRPTN58nzOgtXQc1lYxE5pIFE0u9hJSRsauIlujveznez4agdexF56h9FnXH/2fHch/ZNKzPNIWWvwEAlua9vdxpppLNXQE4xOVzdQT5+R93HQphfJqrd4YHJGxe9X/3OpPQkEx+9UpMhTYaSklUk8ZO35sFwSi84unfy1Mz6/Wo5CqCutoUJq/rF4QElIIW9bNcvMtnyJW3cVFnQhTgX+ORpgq/zK9Es+1cE5paGhBbGrMuk/mz2PLVS7YD9uxhV5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7135.namprd11.prod.outlook.com (2603:10b6:930:61::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 04:13:55 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 04:13:55 +0000
Message-ID: <5056047f-95e9-4a33-abfb-95c9c9b266a2@intel.com>
Date: Wed, 13 Aug 2025 21:13:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 14/32] x86,fs/resctrl: Support binary fixed point event
 counters
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-15-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0081.namprd04.prod.outlook.com
 (2603:10b6:303:6b::26) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7135:EE_
X-MS-Office365-Filtering-Correlation-Id: 45ddc987-6581-40e8-50d7-08dddae8fbf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dXI3VmhNVGF3U3pDVFo3WDI2cmNqR1pyNEs3aTZlaW0xN0lndG56NEFaYjla?=
 =?utf-8?B?YmZ1SW5KQ0xQaGRHdVFZSXowOEZkNTV3NUE5eXBId3FNdk5pbUtldUZ1TEhX?=
 =?utf-8?B?eCs0aFZnOTFWYVptZXVZSFFGWXdZY01tb1ROdU1zMU1wVnJ5WHYxSCtpVzg4?=
 =?utf-8?B?WXlDdTZWbTlNZlhHSm83YjZ0aXdQbHA4VW1tdkF2d2RpQTVTRStFRFEyUUNF?=
 =?utf-8?B?MWU0bEZCR1RFOGN5SHprdDNydzI4ei9VbklyMDd0SzEydm1KV2Nwd2xZRzVi?=
 =?utf-8?B?UWJmM1FORjMyZ2hyUjJnK1ZIZ25VV1drQ2VMeUZTblNxdnRCUEJFcGdLdDZQ?=
 =?utf-8?B?dE0vZWJWYzVaVUxad08ybmtucHc1MlRWcGladjR1bGk2cmxJQm5wM2hCK1JD?=
 =?utf-8?B?MmIwSWpBbEszTlltbU9jTmZVcmwySk5tS2VmVzRra0N3RVQyUTVzNVZ6WGNI?=
 =?utf-8?B?T3p0ai9jMm9KcE5RODBFWU1ZMEhWZTJmbFRSMmY3R1RpNUg4VXN6STM3YWdy?=
 =?utf-8?B?c2xVSVU5ZFJETnpmbzV3NTQrZUl5VWpVb1VnTllQUlk1b0NBSTMwbUFiS0Nq?=
 =?utf-8?B?UzFGSzJqRFJoeldxYm9jSXRNNTlWR0Ntb295SGZmMTZ4NWFoRE1yWTRzNklH?=
 =?utf-8?B?alNoeUI4NHU5TWZmaHZDQ016WGtlV01qUVF2am9DbFdqdXFwb1VnNndpNmhP?=
 =?utf-8?B?WldyZ1UzaHZZOFI4cGx0UCtNQ3NURnVvdGZ6ZVgrcG5Da2Q2V0ZyYlZheHB5?=
 =?utf-8?B?cVpzU01TalB5R0tNR3VRVXV4bGlCMy9wWksreFRYUHU4OEJZOCsyU1gwcW9j?=
 =?utf-8?B?R2Zic0VCUVJoQmdDTXd3cXdqS1JrL1Q3djV2MjJtaFYzOVJRWDl4WGtJb25y?=
 =?utf-8?B?YWdNcmxVZE1XNml4NllUbTlvMmpEVmVRak9RR0lkUnNPOW9kZ0tqV1pHOENo?=
 =?utf-8?B?amUzYVpBU0x6WTh4NjdpdWVXMW8wSExNZ0xpVlNDc0VwR3Y3VlQwT0VQK1ND?=
 =?utf-8?B?QldINThXUWwyMmxqVFhIeXZwaGVlWjM3YkVNZXVkU3NEVWlrdXFYcWdGaHRx?=
 =?utf-8?B?M0Z0NG1NU1prY1pSbEdOZkIvOEVEVnlaUmRCR1lsMjVIWGZGaitBd1RDTEx0?=
 =?utf-8?B?emt4aFMvdVJzMTl4b0NWVE03S2FXZm82anJyL0ZocXJjZjA1ZVpsUHVnVXRE?=
 =?utf-8?B?V3NpRFVhWEJIY1VWKzlYN1MxWS9zTlNHdkkxZGFaMndsUGJSQ2ZXL3Fha2ln?=
 =?utf-8?B?QVZRelp3d3NRalhTZ29Dci9TVlRlUlNkNDlqQkVBaUh0UG8rR2wrZGNPT1ZN?=
 =?utf-8?B?NG8xYnVYRFo3dkc2Y0pFbTNRQ0FWT0NyUVorNnZ6d3ZXMnlGRGFKVktqQVly?=
 =?utf-8?B?OHQxUERnbXBjSXRrajlobG5STGhyNHJMQ0J2MDViVHRDU3puaStYUjcrU2t5?=
 =?utf-8?B?MnpWM0JYNVMxR0tSQVA1dHcyRU5xYlUzcGxvNWNyVld5UlErblVtMENJdlhQ?=
 =?utf-8?B?ZEQ0d1Rrd1pqTEMxaVQ5RExlc3BaUkZUbVliUjE4b3E1VFdjcHFMTTVJU00x?=
 =?utf-8?B?L3M1bHorUlJmcWVvT3dZdVdxd1AveG15Q1djc0NTMWx0aU1zaXhjcmZ1YTRq?=
 =?utf-8?B?Y2p3c1VmdHRQTlJiWEx1aDkxYmxEeFBtWGNHbnlQUjJubUVQL04yMGlhVktt?=
 =?utf-8?B?OW9RVFdqbUtFR2REaHhNaExHNHRqVG5rSCtqV0Q2NFhpeWpEOUU4dk9tKzZj?=
 =?utf-8?B?dmlWVEJXVGd4ayt2L2dLQ2tDTURjY1Npd3o2dy9URmVwZFdwMWhHdW1ObXI0?=
 =?utf-8?B?U3UzMnpNSElTZHdZVU92TGVBakxkSlA0TnZNUHR3cFJXanFXMXJUTEhoaG5X?=
 =?utf-8?B?OStkWlFIaGtteDJ3cnpUVkhQTVBZYXc3MmEwT2YvWnd0MUJiVUVMbHBDQitp?=
 =?utf-8?Q?tLI9piOz5Co=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzRaV0NUaW5FMzFabXlqVmRZSnoydHdXV1dVbjBvMm5aMDRmOWU0Y2lFcFNE?=
 =?utf-8?B?VTdKOFBQNXRkSFczbkhjWFh6eiszeVhTTCtWYVR2R1FubnphUUZacjgxcVlj?=
 =?utf-8?B?MjVIVHdsNFh5MktYT1VaaWFidGE1NWg3MUhQQkRFMWhwOXp1SUlqNTV6Y29p?=
 =?utf-8?B?MWtQVEVoK2JWMXVIdUVFWHY0YzJIUFVtdkgvLzZhb0wzbklHZmZ6UkJoQmM1?=
 =?utf-8?B?WWZablhZM1VkM1l5azFZb2d6RFc1SXBvV2Z6U2FEYUJTZUhSZlRqVWdzUHoy?=
 =?utf-8?B?UWdHejdZdkowUEwvSTF5dFNEam5sUHc3YzZTM3hIZ0RJOTBmVmdhTUVCN2hW?=
 =?utf-8?B?dnFlWGt0OWVJZ2VyTVBOajg2MFpTVklwcE44b1Y3MTJlYUZGMy9aNGY0SzdC?=
 =?utf-8?B?Wk9mLzJXRURrOUwrWVJvdDZLd3Z0K2VlYnh0UjBVcndGOEU5NmdON0pmOUdL?=
 =?utf-8?B?NDFzRHYyNVR2cVJkZEVEMUxSZStZM3dqb01maWRKSE1oaXBYZDZZbVE1cE9J?=
 =?utf-8?B?ZU9XVG50dXdYN3MwNzVPSXFkSFpXNE9wTGY1WmJVY0xXVDZ2ak9BWGUyTWh3?=
 =?utf-8?B?aW8wVUNTU2xqOUY1dVRhMThwQVlwMjFhSTF4b0tIbFUyb3FKUXExS2x5alcx?=
 =?utf-8?B?bzNLd3g5RlF5SXdLQ21CaDE0aStsVVdiQkVWYmFtbUJBRXk1ck15aFpYVWRU?=
 =?utf-8?B?N2NFZXlxVkJhTGhyY2hPUDVSQm9UT2xBVU5zTVkrOXA3UEowUnNMMTNMU2tN?=
 =?utf-8?B?a2gxeHdwdWhQVnJsRnBnd2Y4T1RmREZYV05xR0RLcmM1My9tTUNiMlNxOWgy?=
 =?utf-8?B?QmgzRDlIT3lrcmFwWGVOMlc1VUxFeGZSVG5xdFpUcWpydjJQcXZ0UGZpbFlm?=
 =?utf-8?B?ZkxFb0cydUtGaFVnNlRoem5jV3RGb0RpQ0RDNEZwN2lEWGQ5RXFId3lOZm9I?=
 =?utf-8?B?Qnc1TktPaWdxRGNsRXNKMG9oRkRhcElSdnhBOG9oZ2FFbkJlWkdQOWJZQnhN?=
 =?utf-8?B?WEQ1KytxaUI2aW1BNlRXMUZzZ3FpbFVoWi9zcHJBSmhrenFMZ3ZKN0NBK1BT?=
 =?utf-8?B?TGRYTXhjYlBaQW1yTkdLbFp1SnE1UVp5UlJqUklzakxLekJhazVOUm1EUENS?=
 =?utf-8?B?VDFxMExCV0NUR2h3RVdOcHA3MDQ2M1dvWmNEOVM5MUFBNThYcHhOcjNaL3hW?=
 =?utf-8?B?VDl1SHFSLzczbXpVMktScitBazF5VGU5akJSMW9yWS84K2VwaHBsK0FVblRK?=
 =?utf-8?B?d0NJZTY1SmVSOVpUSGNsQ3pxZWk5MkZ1dVplV2U1Nmdhd1JySFUwODNjNU83?=
 =?utf-8?B?aEtPbnRyNkRVUkY0TWVsd2YrU0hSKzdYZjBub3FmNXljS3VhdWRQYmxFVUVY?=
 =?utf-8?B?KzRuTVlCTW8xUHhTcDhNN051WEFGSjJlYnIrM2grTExmYTl2ZS93RXRVZG5t?=
 =?utf-8?B?QjMvUlFmenpSTHF1clpRam9iay9ucGVaaVFKNzRIeTJGSCtZSGNsblRvUDZJ?=
 =?utf-8?B?ZG5udUNQSEYrenFheHlHRnd6R0JZOGtoWGg2cy9oWUxKR2RURUVWOEdHZ1Er?=
 =?utf-8?B?Z1U0ekxtOEJmRnZobXhJeXNtTWlobVJJRUNaZVE0THF1NHEwUGlHZjRLeE9j?=
 =?utf-8?B?VlJRN1NBeGZmeDg5YUJpdCt5VmhIWUhQVlI3c3RJOC96VEE2OHVsUU9VN1lq?=
 =?utf-8?B?OTNDei9uc0V6aHplbWV5MzZaWVFoZHRBWGwwNVgzNjhuV0JDQ25MV0VGMTEv?=
 =?utf-8?B?V2ZzVXNITjF4Njg2aWp3ekVlMEQrZi91Q0xLQWZ1RnlVMTkwNVZRcjhkUGxv?=
 =?utf-8?B?anFaRk9hODZQYlUxK0EvTFlWOFNYeDZNT1ZHSDFjeUlxazlDZkRaN0o2aUw1?=
 =?utf-8?B?NzErREorUVlob3JwNVRVVnpWSmVrRUtIWndZaVMyRDVVb3dhYTBjZjBHY3JC?=
 =?utf-8?B?SnFjL2hWRVpJd2plYjFVL0tORW5kNUhoNkdKODVVa2I4RW5mNUtoS1g2VVBY?=
 =?utf-8?B?L2x6aUdPeVZ2SzZVVm00VnhxRVc4TVh0ZzlUNmh6SHFSVXlxWTZmTURHMTlB?=
 =?utf-8?B?QU0vcmpmcVJrTmNaWjFPSXBwaHZ6eW1tWWk0V2VyekFMMy80c2EyYXkyZDMz?=
 =?utf-8?B?RXB2OGdRRVZONVh2emNheXVQbDRtbWlwUkg3OUptcDNyYm1hT1EraEhFWVBT?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 45ddc987-6581-40e8-50d7-08dddae8fbf8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 04:13:55.2538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bTQr6ssDjMPBSRNBw+xf4VtE+ngg/vQi8O5fVdDzrVeUix7JidW/eXU29RW55sOyEdLRnoRwo7MfC/Bjxs+71FYAEGFkLUmUbh4v1ZrEOqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7135
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
> resctrl assumes that all monitor events can be displayed as unsigned
> decimal integers.
> 
> Hardware architecture counters may provide some telemetry events with
> greater precision where the event is not a simple count, but is a
> measurement of some sort (e.g. Joules for energy consumed).
> 
> Add a new argument to resctrl_enable_mon_event() for architecture code
> to inform the file system that the value for a counter is a fixed-point
> value with a specific number of binary places.
> Only allow architecture to use floating point format on events that it
> marked with mon_evt::is_floating_point.

I interpret two phrases above to mean that architecture controls whether
an event is floating point or not:
"architecture code to inform the file system that the value for a counter is a fixed-point
value"
and
"Only allow architecture to use floating point format on events that *it*
marked with mon_evt::is_floating_point."

I think this needs to be explicit that resctrl fs determines whether
an event is floating point or not and architecture cannot modify this, of
course it could set a floating point event's binary places to zero.

> 
> Display fixed point values with values rounded to an appropriate number
> of decimal places for the precision of the number of binary places
> provided. Add one extra decimal place for every three additional binary
> places, except for low precision binary values where exact representation
> is possible:
> 
>   1 binary place is 0.0 or 0.5.			=> 1 decimal place
>   2 binary places is 0.0, 0.25, 0.5, 0.75	=> 2 decimal places
>   3 binary places is 0.0, 0.125, etc.		=> 3 decimal places
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h            |  5 +-
>  fs/resctrl/internal.h              |  5 ++
>  arch/x86/kernel/cpu/resctrl/core.c |  6 +--
>  fs/resctrl/ctrlmondata.c           | 84 ++++++++++++++++++++++++++++++
>  fs/resctrl/monitor.c               | 10 +++-
>  5 files changed, 104 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 17a21f193a3d..38809c497b44 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -379,7 +379,10 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
>  u32 resctrl_arch_system_num_rmid_idx(void);
>  int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
>  
> -void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu);
> +#define MAX_BINARY_BITS	27

This MAX_BINARY_BITS define can stay internal to resctrl until it is used by 
an arch.

> +
> +void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
> +			      unsigned int binary_bits);
>  
>  bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
>  

Reinette

