Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5D8263F52
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 16:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764692482; cv=fail; b=Aj7FC2huMil38M7ZVPtkqk8HY4QhOhbWPKWfjZ9JsSsQndWg6zlPlB6uPHx4VyewB33KfbydWXIEWfbZs0Hcn15p4ZjWSk60GO2HyOQjUEbiTBJlMibHP9Wxw+gxL4DXpxjnZwRqw4QWgvGtDixK1ygAov0s/1YUZgvG90aWN6I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764692482; c=relaxed/simple;
	bh=CxRvnaRScXtriBD3iHedFJ/9iIbhOGUpMToD/aurOg0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nP+GkAn2SGeMudD5Vz3FVnxGNCEM2XuQFI7eHqEwZl4FZy39bW6F6si4ZnI5XfwC1a9ZexVd8r2whpSUQjXUj6ZypHBmJ4yqOn9ZaMaUAxCcxcfILOC7MPHDagqjMOM+EIiiSBU69i3O8cmCha/BoWkpCRXWFo7AXOhDhAtfobA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aJkyOwWz; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aJkyOwWz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764692481; x=1796228481;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CxRvnaRScXtriBD3iHedFJ/9iIbhOGUpMToD/aurOg0=;
  b=aJkyOwWzxfLw1rnpJq/bl1CNCJOA8hOhPDhvWI083g+PrxfdxVaEGcQu
   93WAX1k/TjFcl5+z7dwiIZhWd5RphLYqHl29uX8ohGaf35kaCKH1CLIFP
   mG7q2qakiBpNS5IxTBl4yRlRO1ec30I6Y2GrA4jwuc12kLPny2B/JJ0i8
   QSmFfdYUNgbKurPXgPvj+/4WXZIxMyxglLvVPHP6PEtBSMRED8xI2xU+L
   +jTB/Vj7I/oe5lD/IchOKkdF0lzuic/fu0HXnSCc4CT6Krp0YLwvVp4R7
   E9nk0/t9fvozmrligFWqVgTWRTFo4UICGPJAwQyKNqKZe4XwPcm5BTRzr
   A==;
X-CSE-ConnectionGUID: IGymXgEKSbiq4xzSaGUzZw==
X-CSE-MsgGUID: Zd37s3KMSTGMtu8MU+38zg==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="77351360"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="77351360"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:21:19 -0800
X-CSE-ConnectionGUID: E1ahkhwNQ8S6Th+2LKqyzg==
X-CSE-MsgGUID: 69016lOpQBOuHkZ8c32SDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="194506466"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:21:19 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:21:18 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 08:21:18 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.49) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:21:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GD8+6TF5zQNt7i5I6GtN/cVI/rOAfwuHpcCAJEjs5R4v64k9W/IA7XgpUWNXMavfFeC0WBTgfJPtMcCU0tkFKJpQ2MprLpwqv0YiXHUuQNuAp4cmFQDBRFZI55sSJBZugMG0afEG5n7F2KxukxZH6KniQLv+6Uk8oIu0DqzDOXT4B4jiiq9omVCDoShOxc4QXKQelr/4wUqEfskjjlz6480ASXTswnsAsNfAyOe3C8AiPuEuLrwhnNl9chXm0n03+RBoJYxKqk+z5XVoItcbC+5pKaB23sEOXo10RlbJvjrO1kZPo6EjOm8Vh+6TFQkLYFfGNMgsoNfIhAxyJvXFGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+RCW5kf0HPfhUiwmUGM1uuV7rEZ7r7or7xdQqXmdsjg=;
 b=Ox24Vm2chrz1qNyZvFnRYh2evUzGE7FtE9qTNI4pLG/TEhiW72J/sRVyoddo1nVC/L+heICPWkp5+/7wD13uL6p6wuAaEiw9eFjsAurTNL+JkVG9GaxP1Utp7zs9Zs1qk8iwGmMP7sskaAK2CicqojidVlursRqcDTurdWHbAPHGf43QoWjlPbPV1skQ/aNJWz+i32uFF56bPGGXNmw08Iajfz6e0e61koJh2r4tffKxNUH+UOKRnhfE4Ole0WQMclymNMO5kqWWMiLOEmJP0IoOmWJai9CgRd4oygs4Rp+QBUwLngPhsiGw+CSl+wZuOwqsTSUIHckJvFIo9KMypw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB8081.namprd11.prod.outlook.com (2603:10b6:8:15c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 16:21:15 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 16:21:15 +0000
Message-ID: <7315c42d-07c3-456a-a625-ed0042e03186@intel.com>
Date: Tue, 2 Dec 2025 08:21:12 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 19/32] x86/resctrl: Find and enable usable telemetry
 events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-20-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20251124185412.24155-20-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0326.namprd04.prod.outlook.com
 (2603:10b6:303:82::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB8081:EE_
X-MS-Office365-Filtering-Correlation-Id: ed1b88f0-1a3a-4da5-2990-08de31bed0c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ajVHSVN5WGRVMmZ2U1VqN1JKSjd4UlhHTlBRMWV3TVB5dWpacldNMm5rRkhH?=
 =?utf-8?B?eTZBMnpnUzJtQlBFNWFGR0Ixd1MrS2tYNGh6QVFiS01EWFl6d1VwaDBObnp4?=
 =?utf-8?B?NTJHaWVLbEFjNThkRXZXQ0JVMXl1OVdEK1FTM3Q3VGtCWDdDTVBqNm52Q1Bk?=
 =?utf-8?B?WkxDQzA0NlBrdWhyTDYvdk1zQ3FNT0c0RDlFS3Ntc3RmOG83M1l3R0V0Y2pk?=
 =?utf-8?B?ZGR1NGRza1huK3Rpb3RBUGY0bmpOTDh6a2h3YWplQ29adGIxSGtPajhDZ0p2?=
 =?utf-8?B?SW5oTURIQ3RzQUdoRnNMTFJZSndnY0xoSS81Vm5qZXNoU1JTWkRCV0E0NEth?=
 =?utf-8?B?SkdLRDhncDJGaXV1bmZGRzFHS1Vqb3JWSzB0eFNqZmNzcXVWR09yeGxseE1l?=
 =?utf-8?B?ODF1bzJUb2tIQ1NXeDRjVkR1dXJtdTJWU1k3QTMxNzJLMm5tdmNoL1doUWwr?=
 =?utf-8?B?Y21ZaEtib0Yyd2J1UVdZL002eEEvSWMvTDVkRHJLd25haDByd2dtajhaV1Rt?=
 =?utf-8?B?eTFjTHlMTG8vaEYyKzA0NGlpNFhmSFBYcXVnSFp1cHl6eGsxTG5ydTZtTEo0?=
 =?utf-8?B?RVhFUkFLSnEwUnEwTXFZeUpJWEZnT0o3Z24raFcyU25ObnhIcTNIZW8xcXJU?=
 =?utf-8?B?MFNtVGRRYmx4TWc1WG5XVjRtMDhUVUhnNnpIS3lsTlQyU2tzOXo3UnlaREtw?=
 =?utf-8?B?Q1J1RXBBZjZPUEI1QnVhTXFiSmJLUGlKbVlmWExqRkNCZW9tK0pBMU1HQVlV?=
 =?utf-8?B?VGxSRm0rcjY0K0NCbWk5K3JRNG5WVFpRZFV3OG1oSDBMNWlsM29NSkl4aTFi?=
 =?utf-8?B?T2ZZRnh2ME54OWdxbnVSN2VndWtvOWFPQUczZnBHWUFDbGl6d1dYS0M5ektu?=
 =?utf-8?B?WnNscTNLOVYwY21KNW1tRWhWb0ZGWXBjSXZDbWZuQUthcDcxSXFjQ0llQTd1?=
 =?utf-8?B?eHFDb2Y5QkxhV0tmSnJFMVpSZEpwNkwrOXk3QzlwaklDcmZhZWFFOVlkWWhl?=
 =?utf-8?B?WHJ2SG0vNC83a1RRK3dtdm9nUUJrVHpuN3NHc0lLa1Y2Tk5BZks4SkMvNmg0?=
 =?utf-8?B?WnRqQUl3LzZERWExeTk3c3VlOVl3OUtMOVRKRGNkV1RCMEoxdUF3U0RnTmtC?=
 =?utf-8?B?aTNXUjhqRjVobnFycHRoS0drbVhEcVM0Q2NncG5RSHBrUHlKSThGaXE3RU51?=
 =?utf-8?B?YUJhUFNzZlpObzZvVEhxeEZoT3NBa1Nqby9teENIdDhPZk9Eak9mRldSaTd4?=
 =?utf-8?B?RzVaUDdaTi9BNks5N1FTMW0wR3lJMUFRZ1pKb2VHWEhWSWVUSlQ1di9jellJ?=
 =?utf-8?B?a0ZHVUN6WjduOTg5Z2FrdTlyYUp6ZnRmMjVyVzJsbTM1bEwxTm51RGVld1RN?=
 =?utf-8?B?RFdrK0k2dFFNTldXWlBFTStleXJhVDNKZUowMlBZOWNlWTltb1VXZ3A3dXFi?=
 =?utf-8?B?R0NuUXl6UHlxUUppdDlBSEhUUTRoa3ArWng2VDJTWkFMUFpZTFYwc1FPaUtj?=
 =?utf-8?B?MVppSk5HaWpFZExRQmYyQitGNGVYcHlBeWViRVg2bm9FdEl4MDRVNDhRS0R3?=
 =?utf-8?B?K2tFTEJVSXlZVm9iTmRpdllSUEw2VjdpTHJNMUw5Zms1eSt1NnNsTW9ZWVJk?=
 =?utf-8?B?SHNiSFM2L1VYWU9QZDhsRTFDUi9qSHdmNXgzWlNhWUV2SExMUlFHZ2xTNk45?=
 =?utf-8?B?dm95cm45bHd0dzl6YWJBQ0x5MjlIUzFxN2dhNWIzWDBBTTEwb3FrZ3ptME10?=
 =?utf-8?B?UGNDNVYzOVhyMFhXUnRFY2ZabVcwWlFVbWNGTThpSjVqc0hvblNCRmdCMmtL?=
 =?utf-8?B?c0orYjgzdFN2YkhxMEwwajZqL2tRZUp1UCtxVzkrMFVhYW0vRkZ3ZXJ1RjhG?=
 =?utf-8?B?Q1hUYnNHa2drWmFTQVMwcWpYMGdTOURlamQ5Z1dHQmZjajZMZnFkZ09vOVlw?=
 =?utf-8?Q?bOOy+X40GGtwIef2re1rI8K4JdBXDS4P?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2N5Zkh2cXExV1NTQW9SZ3FnK3ZwWGt5a3A4aFBEbHFPSk84NFVIbk9VTjFZ?=
 =?utf-8?B?ZmxMeUZDTEhBcXhnN3ZiWkErcWFxRDBkdG0zNWFKQnYwZmNxUjNkN1F1MndH?=
 =?utf-8?B?L3ZvVUN5N1kvcVBwMU5URUVSdnVLQjZZdUw5VVVTbmhlL21NUjV4Rm1EdG5j?=
 =?utf-8?B?VmRNaUR0cDkzUDdBR24vUzhnVFlzbnpORjRIc3FMenJFdlo5bWZvSVdIbFVk?=
 =?utf-8?B?ajcvSzlZa3JGV29DeERMaGtsNk9sKzcvemtNZnVyamd1MGFqcE1mOUE1OU9a?=
 =?utf-8?B?SnJ1V2lLQzNieE1KbFRqbDVjWlhLWHdkY216bnltQ2RiekdDdzVaai9vT2k5?=
 =?utf-8?B?amhGYXo4S3BySVgxelhyQ1pveVVKRDk1SDl3TDRWQUxWM0dOdmkxT0xnOWwx?=
 =?utf-8?B?STBqV0ZJbkgvcW9odnkycDkxSktPSTJ3MmtZMll2czNtUUVIZTZ2S0g3bm5M?=
 =?utf-8?B?dXBxbEREV1Q1dzFjMkhINFRReUlYdzI3STFpK0U3TGJnblJibTA4TmNBMTZM?=
 =?utf-8?B?Z1pWRlNQTDM0K201a1B2QWsxTm5kZ3hwODhJdGVVVVBpNHNqWTBZeDdyeGVr?=
 =?utf-8?B?SFp4bytWalZVR3VMLzhDUlBINllOUWUyRmV1bUZUSnBvc29YV3VYVmk0TEta?=
 =?utf-8?B?a2VNU2xIZUZnbWtOd0dKVkhrNEFqbGlKTllOak1TUmxPSXpXQWhZUjA5cXdr?=
 =?utf-8?B?Y3RTSiszRkQrR204M1kyc015bklkSTlJN29sMlhtMWhCbSsxaGVCeGs1MFJs?=
 =?utf-8?B?ZnVENkZ3d0U5V0Rqbm9YQitBcHRveWxQNTQ4bzVXSzFSR2FLYnAyTG10T1Bj?=
 =?utf-8?B?YXBadkYyM0NVbnJxN2YxY2F5VTlGVTR3RkhCU0w0R0QwSFl0aDZSZHhDd1Iv?=
 =?utf-8?B?d3k1Wlhhc2lWb0hLUURRNG9EMis5NUlpaVorYlVYYVVrNHpzcElKblVtaG9l?=
 =?utf-8?B?VlhkRWMvaUxvTUJzOTY4VjNoQmVjSGhnYU9FUWNPaVBJOGdTTHVyc0F1MnBC?=
 =?utf-8?B?RWFtcjRRd1dGamlielQ0TWxzOXp4dEZXVmxMWmwxVXM1Zm00dVB0UDVYM1l1?=
 =?utf-8?B?NDZLa3gvNmYwQ3dtUmdpWWlFMC96RWMreDBvVHc4NW5saUo1KzRueDNvU0M4?=
 =?utf-8?B?cXYxZEJsTTA1SVpMMmZOelNMWU5qUWo1dmhyR1dqL0dKQjZaL0pKQngvUWJx?=
 =?utf-8?B?S0pjTHo0eVVIcHJmZGtjQjZtM1NrL0crZkF3T3RzM1YwTE9leWQ1Y0dKZlBy?=
 =?utf-8?B?NFJWU1daWW4zTjhTbHZsWFZuZEM0NXdnOFViN2tlMFlKWDBDTWJlZ2wyUjFC?=
 =?utf-8?B?MUl5UWlvVlNEY0JtMHlnKzBVUTVXczFnMFgxaHZFQkc0d281b000Y2JMUWJ3?=
 =?utf-8?B?R29VVm93RjRmbjJmVklteW5pcUdTYUJPWlBnWXVLS0NYYytNb240UHp4RWJH?=
 =?utf-8?B?c3c0bUU1MlY3VysvR3FCM0VkMCtrOXY5ajB0Y3hrWVpFSFhaYUhLV1h3MU56?=
 =?utf-8?B?U0FFck1HaDk0N3F0cjhvRU56MzBpMVRRaERrZGUvUmFyMi8wTUY1WlJHTDU4?=
 =?utf-8?B?MzNJOEttVHBWSkZ2ZDdWTWVBRGxUZ3RhS3lTRWR2Tjl5c2JRb3N3R2VVSUYw?=
 =?utf-8?B?SnM2SUpnbnpGemRqYWpZUnE3dGNxQzl3TnVvMkRwcUhmVFhCQUxMUitBd2g0?=
 =?utf-8?B?TEhyaGJMTTRlUXlsUWpSTC9JMm1tY2d2cXJ0QldSdzd3UWYrZXNRNkVrYW9M?=
 =?utf-8?B?SUFYcFFQQW1Jcy9XNWFGOFBEYWhrR1lRdWhJNTB1Y2Y0MkVpNUJ3ZTJGUy9n?=
 =?utf-8?B?NHViOTI5NnM3WjRWUWh4SVU3dG4rRE9tVERyVjhtWWhxNXhsWkQ5eVVhUnpl?=
 =?utf-8?B?alJZWnp0MzUyNGVjVmJ6THYrMHA2OWt1U3YwL3dzS1hHYUNMMnl3YUNIR0x3?=
 =?utf-8?B?ZyswMTZrOXVWRWt5MVViU0tDeHd2aWFZR0JkRjBQTWR4aDBaaWR5ZHgyM0Nr?=
 =?utf-8?B?V21RL0RyUm9tcDVuY053aTI1S0FJdGFabmpFV0JZQUM5MDdNRmcyY2Rpb2Z5?=
 =?utf-8?B?NW9RblRpcUlLYlAxbTNJNnNMOHlrUUo1TEgwSEtZUzZCTGpGRS9pNjRHOHpE?=
 =?utf-8?B?K3VGNGU3WlJwYVR5NTM0c3pzSDlGQTROZW9NWEljcTJtNjlGOVdpM0tkMDJI?=
 =?utf-8?B?NlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ed1b88f0-1a3a-4da5-2990-08de31bed0c7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 16:21:15.3434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b6SAf4z+5hRlijQ3WF5Rn3wvpP9xnzY3wLnZLUDncX/R+3PPamhu9N2q5Ees4qCUPd4ljdGtteEACDNpMseH06swYJE6piJZpRXJllugcxM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8081
X-OriginatorOrg: intel.com

Hi Tony,

On 11/24/25 10:53 AM, Tony Luck wrote:
> Every event group has a private copy of the data of all telemetry event
> aggregators (aka "telemetry regions") tracking its feature type. Included
> may be regions that have the same feature type but tracking different guid
> from the event group's.
> 
> Traverse the event group's telemetry region data and mark all regions that
> are not usable by the event group as unusable by clearing those regions'
> MMIO addresses. A region is considered unusable if:
> 1) guid does not match the guid of the event group.
> 2) Package ID is invalid.
> 3) The enumerated size of the MMIO region does not match the expected
>    value from the XML description file.
> 
> Hereafter any telemetry region with an MMIO address is considered valid for
> the event group it is associated with.
> 
> Enable all the event group's events as long as there is at least one usable
> region from where data for its events can be read.

Changelog does not mention the "skipped_events" handling added in this version.

> 
> Note that it is architecturally possible that some telemetry events are
> only supported by a subset of the packages in the system. It is not expected
> that systems will ever do this. If they do the user will see event files in
> resctrl that always return "Unavailable".
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                 |  2 +-
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 62 ++++++++++++++++++++++++-
>  fs/resctrl/monitor.c                    | 10 ++--
>  3 files changed, 67 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index b30f99335bbe..14126d228e61 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -414,7 +414,7 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
>  u32 resctrl_arch_system_num_rmid_idx(void);
>  int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
>  
> -void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
> +bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
>  			      unsigned int binary_bits, void *arch_priv);
>  
>  bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index bb080bdde190..b6b50650e634 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -20,9 +20,11 @@
>  #include <linux/intel_pmt_features.h>
>  #include <linux/intel_vsec.h>
>  #include <linux/overflow.h>
> +#include <linux/printk.h>
>  #include <linux/resctrl.h>
>  #include <linux/resctrl_types.h>
>  #include <linux/stddef.h>
> +#include <linux/topology.h>
>  #include <linux/types.h>
>  
>  #include "internal.h"
> @@ -117,12 +119,68 @@ static struct event_group *known_event_groups[] = {
>  	     _peg < &known_event_groups[ARRAY_SIZE(known_event_groups)];	\
>  	     _peg++)
>  
> -/* Stub for now */
> -static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> +/*
> + * Clear the address field of regions that did not pass the checks in
> + * skip_telem_region() so they will not be used by intel_aet_read_event().
> + * This is safe to do because intel_pmt_get_regions_by_feature() allocates
> + * a new pmt_feature_group structure to return to each caller and only makes
> + * use of the pmt_feature_group::kref field when intel_pmt_put_feature_group()
> + * returns the structure.
> + */
> +static void mark_telem_region_unusable(struct telemetry_region *tr)
>  {
> +	tr->addr = NULL;
> +}
> +
> +static bool skip_telem_region(struct telemetry_region *tr, struct event_group *e)
> +{
> +	if (tr->guid != e->guid)
> +		return true;
> +	if (tr->plat_info.package_id >= topology_max_packages()) {
> +		pr_warn("Bad package %u in guid 0x%x\n", tr->plat_info.package_id,
> +			tr->guid);
> +		return true;
> +	}
> +	if (tr->size != e->mmio_size) {
> +		pr_warn("MMIO space wrong size (%zu bytes) for guid 0x%x. Expected %zu bytes.\n",
> +			tr->size, e->guid, e->mmio_size);
> +		return true;
> +	}
> +
>  	return false;
>  }
>  
> +static bool group_has_usable_regions(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	bool usable_regions = false;
> +
> +	for (int i = 0; i < p->count; i++) {
> +		if (skip_telem_region(&p->regions[i], e)) {
> +			mark_telem_region_unusable(&p->regions[i]);
> +			continue;
> +		}
> +		usable_regions = true;
> +	}
> +
> +	return usable_regions;
> +}
> +
> +static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	int skipped_events = 0;
> +
> +	if (!group_has_usable_regions(e, p))
> +		return false;
> +
> +	for (int j = 0; j < e->num_events; j++) {
> +		if (!resctrl_enable_mon_event(e->evts[j].id, true,
> +					      e->evts[j].bin_bits, &e->evts[j]))
> +			skipped_events++;
> +	}

The snippet below from patch #25 seems to belong here:
	if (e->num_events == skipped_events) { 
		pr_info("No events enabled in %s %s:0x%x\n", r->name, e->name, e->guid);
		return false;
	}

> +
> +	return skipped_events < e->num_events;
> +}
> +
>  /*
>   * Make a request to the INTEL_PMT_TELEMETRY driver for a copy of the
>   * pmt_feature_group for each known feature. If there is one, the returned
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 4ef91fc09070..338a122dfcff 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -990,25 +990,27 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
>  	MON_EVENT(PMT_EVENT_UOPS_RETIRED,		"uops_retired",		RDT_RESOURCE_PERF_PKG,	false),
>  };
>  
> -void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
> +bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
>  			      unsigned int binary_bits, void *arch_priv)
>  {
>  	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS ||
>  			 binary_bits > MAX_BINARY_BITS))
> -		return;
> +		return false;
>  	if (mon_event_all[eventid].enabled) {
>  		pr_warn("Duplicate enable for event %d\n", eventid);
> -		return;
> +		return false;
>  	}
>  	if (binary_bits && !mon_event_all[eventid].is_floating_point) {
>  		pr_warn("Event %d may not be floating point\n", eventid);
> -		return;
> +		return false;
>  	}
>  
>  	mon_event_all[eventid].any_cpu = any_cpu;
>  	mon_event_all[eventid].binary_bits = binary_bits;
>  	mon_event_all[eventid].arch_priv = arch_priv;
>  	mon_event_all[eventid].enabled = true;
> +
> +	return true;
>  }
>  
>  bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid)

Reinette
