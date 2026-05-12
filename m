Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2B7368D78
	for <patches@lists.linux.dev>; Tue, 12 May 2026 07:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778570929; cv=fail; b=CnySaZ5n18qM/nQg67qxU0/zGyj46fyn1bGyVKGLOT40mxBZ875+E2+GU85c5IfYmJEwvYs/K+D45YO7rLQx+47ak9/eIelgYJ7P/K6QinVFgDnx2kexpswttOELSyb51f0s7S8kmVcOqwQDY1i/shGEgHV4HY7kUusE0sEOsv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778570929; c=relaxed/simple;
	bh=MXXwaetdK7G35xLs8Xlbz3uvBwdVxDWn+Wa56qVcmmQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rkPTeJwcZYtOTgsybJTAvIj/Y3dqMERdqCCnKE5gqWhGBvEu68U9uLIaHiofQjTE1SCOut3MRgFLYkHxvTdgJL3HqbWlfbwDdo2Pyc0KrRW4a2uHM4p9da/jvCXuugtuHgrLZ4bGe+qnoI/EAX6qVxtW1JV6ULmXnssBGL5nRmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BsXIb72E; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BsXIb72E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778570927; x=1810106927;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MXXwaetdK7G35xLs8Xlbz3uvBwdVxDWn+Wa56qVcmmQ=;
  b=BsXIb72EYiBk20p0OQ07BiCqOHfIYVdSbpfBPv0NN9Yorzh61MrzevNA
   ataDW2RGiDNdNi1AWZZzH86/xq3pU1KlNFhTZUHH9BFAmVAtnRvuPn8xW
   Iqi6IjYvCdLfKwoi1avLmPqArUZlYQQwY/8C919iD7yMawD4BnQqFqhg4
   zwz/s1gPACOym2Gjg9Mc6x+oa++5oSP4cQ57Q97/PG3z0KY2mdIHz67sI
   ko4aVRdbVc5KLCeLl+vuFPiHvDLMZZVTni+83h6h2LdqOF5Yt53U5v8Ia
   MELIivaukxZbaZjw0cfrwB9s2T+FGDhILaW/WxrymurIHZn+iux0qsJ5p
   w==;
X-CSE-ConnectionGUID: dunwh0ZwTg6LvmBE5gS9LA==
X-CSE-MsgGUID: qoJv+AYITt6YdPstHuX9nw==
X-IronPort-AV: E=McAfee;i="6800,10657,11783"; a="89774259"
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="89774259"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 00:28:47 -0700
X-CSE-ConnectionGUID: vOUXzAtsSx2bMYyiiB6Yew==
X-CSE-MsgGUID: AigSHlulT/OUn/gZ+jg6AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="231292257"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 00:28:47 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 12 May 2026 00:28:46 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 12 May 2026 00:28:46 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.19)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 12 May 2026 00:28:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AjpnJ6IzeHOGWG/3M6EzXBXdYgAnObV67AzprVE/T4REaabAeJhE5AkHynhS0wVt3FXlkkHrXlXOmALo4yhMYyYFb3YheZeazfeoLuKdjQAZK1E1vyTPKj79gCjmKq4rY9eNZUKDyixY+Hitk/ufxDlN98+7p0nIDOy4Sd0Dr0SCpNChZspoIwIZp0jMnS4CHRBBi7X+sn9/x6w1ejSmwKOZOzG+fYm9A4Ykw0eJcYxh9KRtqcrBSgA8dwBLeHNX9Qhh6aWLEgldXLrazbdTx96BHkPgZTny8PUOtJaHPXaQc5yhUNAjY7vWhp8uX/ERMwW6klFBkA7lSIrcZbeWnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TzD+MJ155ukV5gk+dHDkiNMgVjHu0IWmOCe+HYYmtbM=;
 b=GLVKdf91uBnCe1E/TVPwwtVpjrRlHOPp/g8O6QUBCD2iensewXs3Afz4upIDrQcYZxTTxesHrJlDOLacUKp2nO3IDbLe0XM9CwDmxoacSeym2vS2LgH+AslJif2yDBvdNXw/fkncAT1NGf9Z34+SOoxCLegs/7xxZKzouULi38aP+BTIVqs1c/d5BZlpQMsnWztryyhmKtGZVZOvhPQwYzJ+R1fJnAsmEZw8QDpi7xAsLd5pl/D+fg+WJnKNTNxzXtStx5QkmUuTi/BshtYWMWFt+LONgWxQGss7ZZcjxSlqiYarh+mTTCVRHwoNpFTU1QvNmelk3YDw2AnGHuo8Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 IA1PR11MB7271.namprd11.prod.outlook.com (2603:10b6:208:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Tue, 12 May
 2026 07:28:43 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%6]) with mapi id 15.20.9913.009; Tue, 12 May 2026
 07:28:43 +0000
Message-ID: <69874f4d-e64c-4d74-8ba9-eec30760751f@intel.com>
Date: Tue, 12 May 2026 15:28:34 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] fs/resctrl: Fix deadlock for errors during mount
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Fenghua Yu
	<fenghuay@nvidia.com>, Tony Luck <tony.luck@intel.com>, James Morse
	<james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>, Babu Moger
	<babu.moger@amd.com>, Peter Newman <peternewman@google.com>, Dave Martin
	<Dave.Martin@arm.com>
References: <20260508182143.14592-1-tony.luck@intel.com>
 <20260508182143.14592-4-tony.luck@intel.com>
 <e0f70732-3ceb-4d4d-8ffd-4f2761922e3d@intel.com>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <e0f70732-3ceb-4d4d-8ffd-4f2761922e3d@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TPYP295CA0037.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:7::16) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|IA1PR11MB7271:EE_
X-MS-Office365-Filtering-Correlation-Id: f25f2802-eee4-4442-4661-08deaff8185a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: NyR51dViFyU6A8dxTLYOOqa1iRgP+OfpRjj8ib6MZyu3Y0M0cxHspCF41VhhQ/tEsBtF9k6hImH8L+Y83goGwsJ9bZVqYdI02LQF8DOAG7IOi6QIL5rqjTfkPHm2fSFVSpEtcc44R2e0sDI4DH5004H7Dl0EenEYU449r+Dhtj/cbTFukMDFOQy4d7Irk6nZwF3sUxjlzS8Av6Z/F/SQ0YAPz/N8/W6R7jLYdTrdkVD8Fhgk5AjN8wFxGf2xctCpaXKWmdsp+zkOLlfI2/cXxmc6EO+TG+9Ypl2MK1m4lK53Ba9bdk5QZD8EJjgpyDFgU/sOnhVU8DdowhTnqdIhC46Q5lHE7I/yfPySl2DsHFwKkTU0Q4tG5ueyMWK8+PwkBJrhj7cEw4LWr+d8aVobQ9R2Jqsf5ea4QAG/9GJr6SxEhHf4WdMBP5AMBq5uZzonzTDLojYemtb4yH6JRWplDx1t4/nioPKPulXH/8WJWn094hdoLjT0NieZpwgMNCFBw0A78DanGMURQirIEGZ9P3Bz2FZs2pMKxMtR++QtKT+45h5e1i0Ndj6tXU5VbgBlZVKfWz9g4Qn9ZJM5IiVBCGk4cWxbFJOpZ8NqqM/KhsXjrv5jmWklm0C8D/P4wRdgggOKcCLpo9fVzH9pp8vgiiKB2jw7aT0Vnxou1l8l07XeQVvX4GxBnCoB+0iI9TEx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWhIYjlIbmxtOHNwejVreDJtN244VFpmWkI1VEZ3ZlZ6aVFDYlpYOUxETktz?=
 =?utf-8?B?a0JQSFpLeXdBVytybGN1OEI3aUtHV3VFRG9zQ1ZjOHRTWUdFNEdDUnFpaXdW?=
 =?utf-8?B?U2hpL1FyV0RtbEZidnZaQWJqZi9VQy92NE1xbFNPUFZIV25BaW9LME5xKy9Y?=
 =?utf-8?B?bzhFOTJucFlTRVlXOGpxWlNBbXF0VUsxQndKOWJDRVZnaXFadkF2eTRGSUk0?=
 =?utf-8?B?V2QyQVpReTZLaStrSnNLNWRsTXlYaTJuV29CVFdtQmxkR0R1Zjg3VHdTcGp0?=
 =?utf-8?B?aDdaZmthR256bzdJdzh2ZjZkMmN3QThqNGJVem84ME1UcWk3OE1WSU9QWHda?=
 =?utf-8?B?RW5wUjhCbENLakt4aVVIZ2lWVU95NThRdExJaXRGcVE2K29jUktQTTVEcnJ6?=
 =?utf-8?B?MHJRSkpadmhSN0p3UUZpNHlWeDF2ckNndnUwT0RUWVhsVHNrK1BSMnpGdEYz?=
 =?utf-8?B?U0NrdXprc083bzFQS09hNlYzWW92VWNJS0NwaHJUdnRQT3BPd3JLcE5YUGpJ?=
 =?utf-8?B?YnRXbWlZQS9UbXlDRi9lVzVGZmU1KzR5Z2pQajJIRmZoRnpidzdXRFErQTg4?=
 =?utf-8?B?SDhjakY2emtqaWJzV1FIQXR2SXd0NjJXbVVrMzRsWmZYV2R4Ym9xRDFGcTFi?=
 =?utf-8?B?L01NMDBINEZmY1BlRjRNQlBFbFRpak5rNWFZcm9UR1NaYWpSeEJUaVB2aW5s?=
 =?utf-8?B?NlpJVjZyRk1sNTVScUpielNGSlBLd1FwNm13eG1TcnllY3JuaTl6U1BUVmhT?=
 =?utf-8?B?dDFUMWhTSUFsRFhHWUNTOEM0WGpGR0grN0tWdEozbTJuMitZVzR1WXBiaUk0?=
 =?utf-8?B?aVQ5RlN2YTJ5dmNMMWVvU2VLZEppM3BVYUtDRHlHVnZaODhXaVZ4VVRUS0dr?=
 =?utf-8?B?eEpvL2tuNzN0YVQrNWlueEtXakNaQlQ0Y0VBT1VYemE4NGlaUFJQTXo0TDE3?=
 =?utf-8?B?N1BxS0Mzck5hS0lVMkFaN1ZRcU5ncnVBRW5RS0VxSWRPb2xWUmM4eDJ6MitU?=
 =?utf-8?B?SjdOTnlHQVBlUEcrRW56bE1mTjBzc1BRaHpZYlQzcEJ2YmY4eE5BWnNaYk9r?=
 =?utf-8?B?Z3VhMlpJeEMwbTJDWlpzcjRKbnVaZnlpbU9FUC9zaEhTU2VBQVFTVXpSYlVQ?=
 =?utf-8?B?TmtmbUI4bEEyMFdhZ0IwSUYvR0YrV2JqWUNqN3ViUERITktKUHNmSUovOUw2?=
 =?utf-8?B?VWppOXpyUXpPOFBjTFBKMTBGQWtSZG1LVm43TnlBZEsrUFNtTEp3K3RnWjl5?=
 =?utf-8?B?Y1pzZ3Q3M096eU16VC9CTDBCcFU0ZU4wL1RUTFplSDdqNjJEUFc1STA1QlhS?=
 =?utf-8?B?Q1hpQmxCUlU0aVV6NzRyYWV1K0JEUjFTeFMrTnpQcGlsQUtHT01sUGJsUzBO?=
 =?utf-8?B?Nm1WVzlmOHBpaHNoZnpOajhFZEo5YkZqK2QrN2FjUDZWZkhOQ2dzY21Ed1hR?=
 =?utf-8?B?V0hVZTRwRlNjdElhWXdJd210Z1R4eFJzcXV1M1RCYlRRdjVVUXZvUUZSQzYr?=
 =?utf-8?B?MzRNb2xIVnVHVnZBZllkYTVOdlg4TkdJT1Z4ZkxEMHNGUEorQTh6YWs3S2Zt?=
 =?utf-8?B?NHUrbEErLzBiZW5tdG1remptOFV4N0lNMWRYTFUrR2Robkplb0I4TUhueGhX?=
 =?utf-8?B?TEkxSUN3cXZkdkdIbXhGRWFpakQwSUdXZkdFbVgwWlA5Y2dHWi9WQTNGU2N2?=
 =?utf-8?B?NEgvTmZDanJzTHJlRW00REFCZnA5cHNiUUFDVkRMR3RkQzNpWEdrdkZna0Jj?=
 =?utf-8?B?Ujh4RmkxNGdWT1hBekxiNjV2eENxYmtmejc1UXJoU2s3MkdCdWYxd1c2YzA0?=
 =?utf-8?B?SWl0NCt0UWd3R3JyRmcydEVYbnBCYVpFQk45M2tBeThQVm5leUZHSDZ3elAz?=
 =?utf-8?B?ejZRb242WmFwb0xCNEpOT2twQVpIZUlGQ05HdkkrSW5IRG9rQ0NmNlRtblNH?=
 =?utf-8?B?Vm95Y0dka3cwRU84VDRnRUxzYVk3NjJremxwNm5NcUdSL3A5eGVEMWsxT2NY?=
 =?utf-8?B?dk8wSVE4TGVUaE42TXJLNHZnMFpDUGJLd2MyUkxTMnkwNkJOVHNPaVRYUURw?=
 =?utf-8?B?cUVyZzNISVNzYmgxZzkzTzhPTXEweEU1aThxNHFCQlI1cW1OcFpTL2JiNnNC?=
 =?utf-8?B?OHN5MGhDdmNGVFhiVWJKRjc1TTBuTkpaR1gyRjRiOEx4Sy9DSlQxK1lRSjl5?=
 =?utf-8?B?TEp4N1RKa2ZOMm5qbWNtMkZsS3g5WWZydm04emhYOFZITjhtZ2dLd3F3VjZz?=
 =?utf-8?B?SXBMRGUyc1d3Sm43dGNvRUpsbWpoaXBIZ2tlVEhPUEVFSWJ6SVFlaXlZZVJ1?=
 =?utf-8?B?T3o1dm5FcDJtRi9NUWVqdWkzY3JrajdsTU9QQWtyTG5aWTFHYW5NZz09?=
X-Exchange-RoutingPolicyChecked: oKUDKPYH5r7vG8DSPAK6FmfACSmSakzXBgGM4qsJ2D9B7t8C/A5B9xB1Zv9rLR3D4Ld7l/Vj8LVdhBzV+8o+ciJhPROv9TrJeHnI069VNpdofzfmx3TQBrXqEUHjxTCeDW9yeYAlXPolfjMRSFA66xq9mRIUKYWmcWo7NTLeAzKwtBZxGM9LdbFCfvtKRY2EI3iQShTCQtNYhR5Fy7Vmy3neDSF7XuZ95Iyu/2aQYEOxJAdr4NMHySUsOroX4h1mH3j10xXelh8E7m9mzug4Qqgc8l10X7nYc4L9K/wBs+XiCT3IJs34JsIVN4/CLMW0V6zLu6Fooo3XRRCWaiwohg==
X-MS-Exchange-CrossTenant-Network-Message-Id: f25f2802-eee4-4442-4661-08deaff8185a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 07:28:43.0730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ov5LwWk3W+MXIyVwdAGcHipc84SyFr2Moi383+ZjrzDc8Ms+xqldFfzWCRPvKxTQg9b+i61SPzgS6MAoAefvTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7271
X-OriginatorOrg: intel.com

On 5/12/2026 6:53 AM, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/8/26 11:21 AM, Tony Luck wrote:

> +	 * Obtain reference with locks held to protect against interference
> +	 * from resctrl_exit().
> +	*/
> +	kernfs_get(rdt_root_kn);

[ ... ]

> @@ -3130,6 +3144,7 @@ static int rdt_get_tree(struct fs_context *fc)
>   	 */
>   	if (!ctx->kfc.new_sb_created)
>   		resctrl_unmount();
> +	kernfs_put(rdt_root_kn);

I wonder if above should be protected against
	cpus_read_lock();
	mutex_lock(&rdtgroup_mutex);
like kernfs_get()?

thanks,
Chenyu
