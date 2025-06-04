Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5393187332
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 22:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749076878; cv=fail; b=ekw/VW1gsuDcheRpee+UEWW7+Astnx0b0UIhUHp8zzU5AUgpQe9IsQZxPASSUgfF/miAq5H9YbRm475bg5Bly3X+jlpSyuwma0bqkCHpcKZ+i+yYN4V5pUAM4PTXaYSoHxCT+RxOE5ghaPyGHOTBwAKg0Fk/HpiGYr2mu/lGJEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749076878; c=relaxed/simple;
	bh=GAAi+0/qGXlzcWIdob+ILTydq/d0ViDyiTfCGGYmLZY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ftlIttlhcI6Rv+K6sbTLed2/JSG5dLxPlxA90ePQp+CEBF6G0oy6bnyozLi09Jf1DUZ0Rkf1nmeETuNZNaLWSF3lG5jRWMDe6rKTIb56cPnuPcEoVbFI6zd6sihTX26P2/jzLXl2glqUJ6zGwelrnU6IAHG0cYYQDGnxfpIL5Zk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UlSZAMAN; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UlSZAMAN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749076877; x=1780612877;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GAAi+0/qGXlzcWIdob+ILTydq/d0ViDyiTfCGGYmLZY=;
  b=UlSZAMANA1XwWlJGygqExP6SpStuCf0U8RkkT3ohPpXb3eofH1L4RfDw
   Wg+iTyxS9lVJwZAkJoCuZYDpPcRNLRif4NzgtKyEN2ILG47y9iTEo0gBz
   ux65FIqU5mJFcBaPElegqxUU9WTYfte+uPJmxR1g6IYiLr8CFKkjge8Ey
   E62iBneEGXQ7OhMK+OFH8J/4MDSof3boaC8E82mCnKTQttwtA9722z+46
   Prgt4OuoBVQ2gRIr1XmYgPR4dUK53GnONF6S8oVdf2KSRBbsYu/d88nsJ
   haTsm280ZVnyRZFilQgJD22UcwT0aDVOmhNZAVr6p57kmPmtolOkShjEC
   g==;
X-CSE-ConnectionGUID: Mzu4rQVzRlOHro92jnVu2g==
X-CSE-MsgGUID: YdK77h2xS5Owfym7rJvYmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="50294110"
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="50294110"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 15:41:14 -0700
X-CSE-ConnectionGUID: 4uLMUe0kRW6gTIT4BDj4tg==
X-CSE-MsgGUID: awRxfRgLTayFt0mCEYWKAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="150196063"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 15:41:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 15:41:11 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 4 Jun 2025 15:41:11 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.72) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 4 Jun 2025 15:41:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W3vlEfpfa+x3a8YuPH79o9+T+GzFdLVdoBxSAEAqpX8vZely2ajq2yJRmfRXYJUhu+q/HJH5qMEfozQhtWHZGAVeTQR9GZkNJUsGLkZ1H+qkqT2lN5yrSPBffjm1MQTlYAGbdehxa3Qggj0sJrF0is3UphSNV6sPySJNtXwEDxQ3mOZCav9ocoZCaC3NfZbvcY789w5G1wRQbDcHBbZ0s+RPd1kYffasQbr3cknri/NGFOMGoiwU2t53qBNJQwpPjiDyxMkKU7GdSL1uxHWrQwxp6q9/tD/Uhk+pqL/9XVBHCgcKMktjsdweLR1wldDLTjwOsPOp3N1yRdfVdecSJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UfWBaPHEHKGFC4PfVNWLltR30ofeEX2GcdO269FTtIY=;
 b=LYhMPEmASaWpsP4HHsvCdCxOvi5/dF7BbozIIvljhBTJsJvY9zDkUm15QKzh6huwXvQwOrILte6ppt0mM8Mu81I4X1hO0pMX1I3F0KkDzJGrGvrrAsEoQ2RVjId6xL9Xq70m5Vse5T2eb5CECzV6R7ShiuD/0uwS2LwDwhiwCjOAtOkqamx6NzgJTmD2ToHPGlNUyDJZhc5nhmgGdsCEEtWM6wdM7LjSGOy8UCsQ+zIEpM8P2Z4pwWkDIGwCqgICqFIJDbJ14ZX4OCWqpinSZLfmKltpk8JcW/LiWeI7uOtqL69STkPPjpjEOIZ+SbCCtd40s2ab2T/4uLZblOm2fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY8PR11MB6818.namprd11.prod.outlook.com (2603:10b6:930:62::19)
 by IA1PR11MB6146.namprd11.prod.outlook.com (2603:10b6:208:3ee::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.29; Wed, 4 Jun
 2025 22:41:08 +0000
Received: from CY8PR11MB6818.namprd11.prod.outlook.com
 ([fe80::48a1:723f:54ed:a6d6]) by CY8PR11MB6818.namprd11.prod.outlook.com
 ([fe80::48a1:723f:54ed:a6d6%7]) with mapi id 15.20.8813.018; Wed, 4 Jun 2025
 22:41:08 +0000
Message-ID: <2953c1ec-cd92-490e-9b7a-04b10fb98e14@intel.com>
Date: Wed, 4 Jun 2025 15:41:07 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4 UPDATED] x86,fs/resctrl: Consolidate monitor event
 descriptions
To: Reinette Chatre <reinette.chatre@intel.com>, Tony Luck
	<tony.luck@intel.com>, Babu Moger <babu.moger@amd.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>,
	"Dave Martin" <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250604212208.49080-1-tony.luck@intel.com>
 <20250604212208.49080-2-tony.luck@intel.com>
 <bb7badd8-dddf-41f3-b509-42cdd4539fbd@intel.com>
 <9e8c9810-1b5c-4e30-8b10-c3702810b529@intel.com>
Content-Language: en-US
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
In-Reply-To: <9e8c9810-1b5c-4e30-8b10-c3702810b529@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::31) To CY8PR11MB6818.namprd11.prod.outlook.com
 (2603:10b6:930:62::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB6818:EE_|IA1PR11MB6146:EE_
X-MS-Office365-Filtering-Correlation-Id: b676a237-db44-4003-7a50-08dda3b8e5f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UVcxK2NXeDNTQ3dBWmVyU09BTWdla3BHQnJqNHJkcVMwRlI0L2ZhR25BdkE0?=
 =?utf-8?B?S0MwazZUWGQwbGh2bXpkYWE5bUhhSzZJN3ovMmZDVzVIbFVsVXFrc0hKWW4r?=
 =?utf-8?B?d2dxS1U1SzdTS1pXQys0MGtTRVBkOXZnWWE5SjB2QWR4bHZIci83bjNROGRR?=
 =?utf-8?B?MHY1aVF2akRiYldZeUF6U2pTMGVzWklkcXJvNmxBYUFCZmVXaTZYVE80NmpZ?=
 =?utf-8?B?TnpoUHdDMzl2RW9mS0JtSCtsOGVRQm9mSERQamQ0bU5Jb3hMcjNmaG9PU1lP?=
 =?utf-8?B?NXRmUy9xZG9XQTBVSHdkNlZBRE9SNmwrRFUvcXAwa1N0V1l5enEwWnJITjND?=
 =?utf-8?B?ZnllWXUwWWFUSnJpTmRpVStYOGIzdlVxSGdKOHV4eFdwSEpSZmx3cEdFaG5N?=
 =?utf-8?B?cWorNFBRdTh5WG1rcGQrbFlzcFB2L2NZNTBjNFlGMVZ6WnlaZHJBdzJJMTFS?=
 =?utf-8?B?MUNGb2lQdTRIanhyRFB5SjZiK3pialFZZGUxWmFtTDY0bndCbkhTd0l0Ty9R?=
 =?utf-8?B?d2FoSFRPUUVXWG5FN3VRdHYrRitLeWtXSUZjdWhoWGZZR1FvWGtnNVNDS0hp?=
 =?utf-8?B?eGUzUzM0bmRQeS82N1BKWkFDdFAxMHZSMGlGc2cwZmFLQ08zZG0wZTlkeWx0?=
 =?utf-8?B?SWhBdkJtOXJycUJqTjlsM05ha0sxajAyMXMzakRyamFxeWgvd0xMb1F2MFJj?=
 =?utf-8?B?REpsdDZRUlgrMXBIWWwzc1FxNHh5ODMwMU9oMTh3SDFvT1E1bC9LUnFldmlK?=
 =?utf-8?B?WUd5eWJRMEtwOHl6cHpWTTJBLzFqcU5mWXdWaUEydzB1U2REeUNqdTBCN2R6?=
 =?utf-8?B?T09ZWnVBS2NjWjBqUHh6Mlk4d3lWZCthWWthcmxST1VvbmErRGpVb3prTEdv?=
 =?utf-8?B?NTI1c3JJZFQ5WjVrNUg2c1BRejNtb3RvK0s2ZStxb0pTeTVhWk9pOFA3U0M4?=
 =?utf-8?B?YmRWd2FLMCtsdnErUTRTTExZT20wQU45MHNuRjlQYlB3Qjc5dHErOE9OWStC?=
 =?utf-8?B?R3hoUmVIbjRmMkp6S3lkTVF5ODZYVUNzRmY1UDB4TU9HMkNRdm5iazVsYWd2?=
 =?utf-8?B?OHBlLy9oUG56Ulp0OU4wQ3Rjb213SjFPK1hLK2RMaHp2ZVRUcE1Ga1Jlc0h1?=
 =?utf-8?B?QmxXYVYxOURoSWc0eTNiUUhUR0NMb05Nbi93TDAvY1FacW9qamxiRWlLUFpJ?=
 =?utf-8?B?OG9lVUJSeVN0ZXd5ZXQ2QVhtaElVbXJSSnJWL2lGN1RIaHBsNEIvSTN3Z0VS?=
 =?utf-8?B?N05mTHhna2Z5cVlNaXRoQzA4NkVSaVY0dDEzZ1ZyMnNDbmFweVdLb0NWaTRw?=
 =?utf-8?B?TWNkTjMrWmgwVmdtbjlXZ0szQ2IxNHdEV09oOTJ0dG1uZFY3WitNOXFJeHJP?=
 =?utf-8?B?TFd6Q1luZ0NyenJlaVNtQys1S3JoS1VHM3ovcTh1UzRBak9jR0tHbHE4cytF?=
 =?utf-8?B?RWZuZm1KTUhjQTgxcS9SdVYyY0NueHovU0J1TmNyOTAvcWVoN3R4RkZjQ2tw?=
 =?utf-8?B?bmEweDA5OFRlWjJNYVk4amd5WENtYjQrUXJOSnRGU0FwNUEzeWNqOVVseFRI?=
 =?utf-8?B?ZjVLdnlzSGFHbzNVZjRSUzdoLzFUbmZGREFGR1pHOXdaa2kwZ1hDNys3OW16?=
 =?utf-8?B?bCs5OVIvMk5UemRRVFAxUlhVd1ZXUkZyaVE0aUdQcTdWeXk5Z2t1QkRQRVVy?=
 =?utf-8?B?NHJMZVQ4YVBRSmg0NFVQQitXVmhqd1h0elpuLzYxeDNVTmtiTUhQbXE5d2ow?=
 =?utf-8?B?bm93TDBaTWJsYWg4NXlUbXdqTjg0Smx0em1ybkRnT3JXb0xuV1hxckhtdXBl?=
 =?utf-8?B?Y2xUd3pFeWlsK3NCM3RSbzE4Qi9rMFNUcXAvWDJ3b1FOMlZOMjRwR0RlL3ZR?=
 =?utf-8?B?Y2hwSVNTMXI0blNweXZXTmF3dVpyTzQyZEF1UEdaUXNLZHVqWG1Pc1lwR2hu?=
 =?utf-8?Q?hfhpZX72l50=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB6818.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajBKUEdaMVRiblRFSER2dXJCM1V6RVo1OUJCK1A0anM4RUZXZk1VVXZBUTRK?=
 =?utf-8?B?QXc2TnVEeDd4aWc3ZFVuelUzYTJqcnBnbk9ZbDNFWlZISlpia0dVYXpDWENz?=
 =?utf-8?B?bFg5YUZERy94aXI3UVpMS0t3WCtmckFjVk1INmlRN3BQb0diYjNiWWZieGtZ?=
 =?utf-8?B?VzI1ODMyQnl5bGVKbCt3WVBlT2czSXR2b283NUFqT0IwQ0EvSjkzczlCRmZK?=
 =?utf-8?B?K013QTQ3czZQQ2paTEhsR1ZreGdJRW9uUm9kQU9XbEFOeUFJOUphdTA1YlZF?=
 =?utf-8?B?T1BQNjBHMFJRdkxXdWduTU5keWRpUjUvZVNMSENFYURIdjdZU3ZndHMzbm14?=
 =?utf-8?B?VCt2djMwMEcwQkVjTVUzNThLVE1pcEZCYnFQclQyQVdXNFpyS1pabWhZa3dO?=
 =?utf-8?B?dkRuR0Y2bVExSEp0ODNWcS83cjJ0OUVQOXVJSUZBZ0lKdUphVDRWKzhVTGZO?=
 =?utf-8?B?QlFCZEZtdFRQWS96REYxM1BrZExVaHZaSzh0UU1kZXJiZFNVelRPcFlFMlhO?=
 =?utf-8?B?Q0Y5dmRob0JVaThWVWZnRDZHbTRpT2hGSDZVL0cvb1lTaWNYYklXQXI4Qm5B?=
 =?utf-8?B?N29RaWFGSHA0YVNFNE1panZITmlZU2dsZ0g5SzhGU3U2VGZyS1JJVVhhaUFp?=
 =?utf-8?B?Z25FRG81MVJCQkFNMm8zNjdpOXlCc3ZKMGNHajNZS3o5dVAzcXN2WUZlZGtz?=
 =?utf-8?B?V3R4RzNHeFNLVCtlekxpbHpvVEcyV0pTbER6bE84UUI0R1l0c3J1Nk1pOUhi?=
 =?utf-8?B?SWxScDdQNDJ5Q1ZqbmQ0OWRsVVR6dGwxNWpOelV3MC9mUW4wcXZYQXhRZ3lp?=
 =?utf-8?B?UFA3SjJBY2JLQjF4dmJPR2QxVE9kVk1yVzMxR2Q5US9VL3lyVWpPUUo3eW54?=
 =?utf-8?B?bDlvMWkya1BrTTgwS240eWhoYjFuSjlHVDlxMGh2cDlCbmdPYTltWmxWOXpP?=
 =?utf-8?B?N2h6dHlDVWhYek9Ldktzck9McnZHL3RxeUZOODdpZHh6VmJxNFhNY3hxYk00?=
 =?utf-8?B?bnc1N3VvZjEwKy9XUGppaHFBNDBBSDN0SDh6VENlSUpicXhhSTMrZkgybkNY?=
 =?utf-8?B?US9ManNXNjZDT2JuS3lrdmFEZzZjTjU3VEw0aUpGWGNkT0lxQU1WQXU2UmlZ?=
 =?utf-8?B?Yi85d05wSHdJYnRuRnFTTnBhOUxmaFZkVVo1K2hjOTZ5T29CNU9yeDVwYStD?=
 =?utf-8?B?RWxBUGFDMmxuaHJQK3FBS0hlUWE5dkE1a1dFS04xKzhrejNrQ3FZU1JxaVZi?=
 =?utf-8?B?aWFBV2tQY0ZXMVNPRlQyQmZwcWJoQ1dlbm43azFNV3lNdWRuQ21vMlJpSWZv?=
 =?utf-8?B?VGszUCtOQmQ2SlpiNG0zaW0vSXpycGNsZ29rcG5meUhVZFlFQnJqN204WlAw?=
 =?utf-8?B?d0p1QjduQ20yazlYWlFiZHorWkJFOGNkenIwa2lBYkRkbXYxNndXTHVXVGcw?=
 =?utf-8?B?SFlKYVNjNkxXT2dnSk1JN0F1S0tnbUM1RnlBMnRNUnc2ZzZ3djF1dmlzTnlI?=
 =?utf-8?B?VW0zbkZWR29EZTlFV2RoMUJFWkJCVFZLRjlUK3l3MFR5MG9lUnZldXY3dGxM?=
 =?utf-8?B?OUUybXZ2WmI2UHp5bHd3bm1aaVhJU1hjQitLSWduVTZZdGpSNkRRUFpDbDNj?=
 =?utf-8?B?TlNKbWh5ZzQ2RnJzWVNZcmpoUXVnUzdxM3pucUI4TE9rNFhWck1kb2M1cXl0?=
 =?utf-8?B?WS9Fb0pudm9ZK01LejdhWDU2TWRqekw5bmRpNllyOG1MWWRhV0RmTzJMZGIr?=
 =?utf-8?B?STQ0R2tBL1NtTUxTU2ZmKzlMRGhQdzFDWTRNUzV6eURDZnZsNUN5UnFWZGxi?=
 =?utf-8?B?dVNYdEFUV3RPSjdXMThMSDM3OHBmQkxSSm1SVG52c2gzTlNkajFDUGFydHJa?=
 =?utf-8?B?RVp0Z0kxeVpkTm5mdWVISnRSQnozZEJXUExWTENrM1BTbC9KWFFHMG9MNUo0?=
 =?utf-8?B?eDhRSlRwQmtuSTN4L2I0VUtCVHY0VEVieHVDcy9tOEhjMUx3aFE2OHBYR0pV?=
 =?utf-8?B?MVZnZWhlUTdzK1JKRU5rL09GYlhVZW9aZzJ0dFl1NmgzaXI5Wm5yOTZ0dUZF?=
 =?utf-8?B?V2VxSDF6MEJwSU9ET2NUb29nVUVnU2h6SDVXYmcyVWUzR3RRVEMzVnVkL1p6?=
 =?utf-8?B?c3p2bWU1MkVSMUIxQi9YY2Z0NS9SbkEwQmMvazMzMTFhUU5xTzc0c3A5UHdy?=
 =?utf-8?Q?UoKj1dXP9ONEcpS3daecPUo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b676a237-db44-4003-7a50-08dda3b8e5f6
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB6818.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 22:41:08.6438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y3h4J/X6Rt6Tn7s9SnlkJLFZ81GkClJDvv/y81XquRvLHqeBdSvLabZprPiw02MZ1/aiWELhd3uxw9yZv7vDfusv+Bqt1OJCvUy1149pFo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6146
X-OriginatorOrg: intel.com


On 6/4/2025 3:30 PM, Reinette Chatre wrote:
> Hi Anil,
>
> On 6/4/25 3:21 PM, Keshavamurthy, Anil S wrote:
>> On 6/4/2025 2:22 PM, Tony Luck wrote:
> ...
>
>>> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
>>> index 9a8cf6f11151..71963255ad36 100644
>>> --- a/fs/resctrl/internal.h
>>> +++ b/fs/resctrl/internal.h
>>> @@ -52,19 +52,26 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
>>>    }
>>>      /**
>>> - * struct mon_evt - Entry in the event list of a resource
>>> + * struct mon_evt - Description of a monitor event
>>>     * @evtid:        event id
>>> + * @rid:        index of the resource for this event
>>>     * @name:        name of the event
>>>     * @configurable:    true if the event is configurable
>>> - * @list:        entry in &rdt_resource->evt_list
>>> + * @enabled:        true if the event is enabled
>>>     */
>>>    struct mon_evt {
>>>        enum resctrl_event_id    evtid;
>>> +    enum resctrl_res_level    rid;
>>>        char            *name;
>>>        bool            configurable;
>>> -    struct list_head    list;
>>> +    bool            enabled;
>>>    };
>>>    +extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
>>> +
>>> +#define for_each_mon_event(mevt) for (mevt = &mon_event_all[QOS_FIRST_EVENT];    \
>>> +                      mevt < &mon_event_all[QOS_NUM_EVENTS]; mevt++)
>>> +
>>>    /**
>>>     * struct mon_data - Monitoring details for each event file.
>>>     * @list:            Member of the global @mon_data_kn_priv_list list.
> ...
>
>>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>>> index bde2801289d3..90093e54a279 100644
>>> --- a/fs/resctrl/monitor.c
>>> +++ b/fs/resctrl/monitor.c
>>> @@ -842,38 +842,39 @@ static void dom_data_exit(struct rdt_resource *r)
>>>        mutex_unlock(&rdtgroup_mutex);
>>>    }
>>>    -static struct mon_evt llc_occupancy_event = {
>>> -    .name        = "llc_occupancy",
>>> -    .evtid        = QOS_L3_OCCUP_EVENT_ID,
>>> -};
>>> -
>>> -static struct mon_evt mbm_total_event = {
>>> -    .name        = "mbm_total_bytes",
>>> -    .evtid        = QOS_L3_MBM_TOTAL_EVENT_ID,
>>> -};
>>> -
>>> -static struct mon_evt mbm_local_event = {
>>> -    .name        = "mbm_local_bytes",
>>> -    .evtid        = QOS_L3_MBM_LOCAL_EVENT_ID,
>>> -};
>>> -
>>>    /*
>>> - * Initialize the event list for the resource.
>>> - *
>>> - * Note that MBM events are also part of RDT_RESOURCE_L3 resource
>>> - * because as per the SDM the total and local memory bandwidth
>>> - * are enumerated as part of L3 monitoring.
>>> + * All available events. Architecture code marks the ones that
>>> + * are supported by a system using resctrl_enable_mon_event()
>>> + * to set .enabled.
>>>     */
>>> -static void l3_mon_evt_init(struct rdt_resource *r)
>>> +struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
>>> +    [QOS_L3_OCCUP_EVENT_ID] = {
>>> +        .name    = "llc_occupancy",
>>> +        .evtid    = QOS_L3_OCCUP_EVENT_ID,
>>> +        .rid    = RDT_RESOURCE_L3,
>>> +    },
>>> +    [QOS_L3_MBM_TOTAL_EVENT_ID] = {
>>> +        .name    = "mbm_total_bytes",
>>> +        .evtid    = QOS_L3_MBM_TOTAL_EVENT_ID,
>>> +        .rid    = RDT_RESOURCE_L3,
>>> +    },
>>> +    [QOS_L3_MBM_LOCAL_EVENT_ID] = {
>>> +        .name    = "mbm_local_bytes",
>>> +        .evtid    = QOS_L3_MBM_LOCAL_EVENT_ID,
>>> +        .rid    = RDT_RESOURCE_L3,
>>> +    },
>>> +};
>> As we start adding many more events to this struct(including region aware specific events), this this becomes too stressful on the eyes to read.....can you consider simplifying this with #define something like below in your next version? NOTE: For the feature that I am adding along with Chen Yu, we started to define a macro as shown below.
>>
>> #define MON_EVENT(_id, _name, _res) \
>>      [_id] = {                      \
>>          .name  = _name,           \
>>          .evtid = _id,             \
>>          .rid   = _res,            \
>>      }
>>
>> Above #define can to into include/linux/resctrl_types.h file and the above code reduces to using MON_EVENT as shown below.
> Any reason why the events need to leak outside resctrl fs? At the moment it is kept
> inside resctrl fs with helpers for only those properties (not descriptions!) that
> can/should be set by archs. Enabling arch full control of the event is not ideal
> since many of the properties are required to be the same across all archs and
> dictate the user interface that is ABI.
>
> Reinette

Sorry, I just picked a random header file there....ignore that part but 
my real suggestion was to reduce the lines when declaring "struct 
mon_evt mon_event_all[]" with above #define so more events can fit in 
one screen when viewing the code.

