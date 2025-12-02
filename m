Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B5628468B
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 16:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691678; cv=fail; b=NTtS+17yd7rlJYuICoc08HP1v+zv0O4e7X0LNQQba9QWfQNVHswqfPKod1v4BEgKdUXWWn6mjoOe6UuoA/ADB/T1hQWqa4nkIMhfKKP4KS8l9vkhXT3nmxGLX8PR00lEt0FzVs1bqDcMfCddWkx2GZX/ejaUntcOlT3S2sLYrsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691678; c=relaxed/simple;
	bh=fHCj/msxGm41VbQvtqH1BCAPcZXGaH8DPghmQM4KzNo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hrx4T/7iI4AxGOXJgrrJukU7rY/6ZIKwiHP6nv5jrblALOp/8KJlh8xLLhtGKwMIuWd8PvJlY3Zs6RrS62TIHxmKwJCVw9MKfSLlfDbzSbjX+FeKxlpNPpFMBbI9m+F2U/OmHgGppKOxSvP6rytMtNqZNy0OTdOtdqIRcaFTaCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YFTtoGv2; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YFTtoGv2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691677; x=1796227677;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fHCj/msxGm41VbQvtqH1BCAPcZXGaH8DPghmQM4KzNo=;
  b=YFTtoGv2Lrf9mTcbzcZEuiU7R4eJnHrMMEg+1sFXlWzkyA3Bjf8+VZVf
   XTlEe+AQmoHwcEwbLc/s9YTGJ9qdvcZy4w90Rc3Wpv1smpo7hq6QQYOT9
   nCgUgtWw0MlFEp5ZQaKg5E50+FSwxb8/gXfxxO+JKccbMbfGo19XfKoSB
   1WcD8x1snAebLxVOkhTq2I+IywcCmHFyNa3RY7+0XCmqS7jJLXkk6bgjL
   Ej+DRRwmkkxJjKh704hrDAwwuGzC41itA8cFZoEMjagJa8ow1AVCv6Yhh
   tX4d3zhUplt6CippD0X1yUNNTdU/XTzNyjPH1kRPR1QBkC+16Fv8T7C3Y
   A==;
X-CSE-ConnectionGUID: ftZjkNpVRgWNIJMh+Ta8EQ==
X-CSE-MsgGUID: +wVlIIyuQESUf8oOWpHJRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="65668697"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="65668697"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:07:56 -0800
X-CSE-ConnectionGUID: rXLXS++DR8+5lpTX5mDC0Q==
X-CSE-MsgGUID: j/8k6t3WQEWLVRH8VN99ZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="195226162"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:07:57 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:07:56 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 08:07:56 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.21) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:07:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OZNvPB0szzSwGf6i5PGhf4tEZEyZ8QV16EZicc8xik+B9V1bK2yt8S7JJxP6Hr/TSrQN1A87CqJHyEaV+61sA8T5XBF8Q33QcMadJsuOK8j6vtJvkOyOe6cSG2HL41o7x6ZtOkxhlZjoawB/L6GSPmsSg1kWOCPtOtf8DKGEyzCaUKb0qbWA/hJ2IWasz2G5W0WHdx7An7sw2DI9prE5ax+G/MbokL08M6JEzLV2CuEe60IPq3qH10Pchr3iBP9YeCvFH7inZwdvDvvdMR1FjJAYtlzuv51q2V8rfFLVLfKbh3q29TCzE5rkMzhmOmndzEDalBB1pokOQKsA1fc/RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JNV4gXkyfzh3IoqVoJ1pbLL5ZQ9qHmLDsp/9/N0AlSo=;
 b=KBiDVHR0UibkCXjzGp0bwIrScMGULQ3+syVsO5HYlLaYTf8geDzm6g6BIR5cyB4ZqxGVMoDgV0DDZxNsuN4xL1waegi4FphAIHfrHI5qP0bw9l9UaQleKY1VqARnHF/mf969tkUQ/Ad71Xhds5CIAyriq3zDGjdEzJfeTsYlqx4UBr0JGSARxRyqIvk4AtwnSX1940+ZzCR6HeW+zx5o4SPH/gbyjnBYryrFuU4i3O6Z2KEmVAIAZ0nQmoG/p2SzaiK4B1NbfiEZF7GXHeerGR5JL65fL2tQFqkqm+mfa+dD6xhF2hZlNEKh12Pj4kv0JMeZgcR1Hn5z/gGBKDCKIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH0PR11MB5251.namprd11.prod.outlook.com (2603:10b6:610:e2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 16:07:54 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 16:07:54 +0000
Message-ID: <4fc6b3fe-ea2a-4d43-8885-f96feb966ad1@intel.com>
Date: Tue, 2 Dec 2025 08:07:51 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 08/32] x86,fs/resctrl: Rename struct rdt_mon_domain
 and rdt_hw_mon_domain
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-9-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251124185412.24155-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0132.namprd04.prod.outlook.com
 (2603:10b6:303:84::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH0PR11MB5251:EE_
X-MS-Office365-Filtering-Correlation-Id: e60ea57e-448c-407e-a3e9-08de31bcf358
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q0RENHpCanlBU2hFWkczQVBaRHE2THJsQmVmSnI0dkZqdm44bTVlRHBvaGNh?=
 =?utf-8?B?VmxwRXE2Ukg5VjkyL1VQNk1qdllYWHUvWlZ5WHJmV1MxUm9RNlFPZHEvYUM2?=
 =?utf-8?B?a2gzU29IdjRjQ0FielR3dFBxN0tFOElkSTBTWHJ3Y0Jtc3FYRUlaUUtMWkF1?=
 =?utf-8?B?UHZEZlZ3SGVkWmlGanpSVTRqT3FZbHM0TEpqbGNXUXBqVkVkR1lRaWF0akht?=
 =?utf-8?B?QW1VNmJWN0ViWmR2a2h5cWtRNjhodGhFMDRWUmpxcU9KWno4dkk3MjBERHVT?=
 =?utf-8?B?UkpXandEelMrbFJMOFE2cWRyaEtVNGNaVS9rTkEyV3p2ZkRQaGoxWk1kMmpz?=
 =?utf-8?B?cmtPMFR3Ri9OaEJXcnVuSmRwN3RULzc0VElSb0gyQmY4dHJzY0wrVHZRZHZy?=
 =?utf-8?B?bDlETjR0T016VDJ2anBJRk5WTVFzNXZ5dlc3elBsRjZpcjFob2hWOU9sWDBn?=
 =?utf-8?B?M2JrbUdNN08yYkFSalA1REdhMUoxMlFCaFNuM3VHUHFkMEt5WU10eW5DanJG?=
 =?utf-8?B?U281Q0N0cklDNFQ2MHpQR0plT25IOWpCSUp0d0JzSkJvcUs1Z2N2cE9Vd0tx?=
 =?utf-8?B?b2l6YmJzQmFMNjl3SEJKQXpCK05sdG0wRXhiSUJydmhBWlpBSmJyQnEzU0tu?=
 =?utf-8?B?REtlOUdpMWhPeW5HdnJsczlCODVJd20vc2t6bjhZOGdHN2pOSGhDWE5GdHB3?=
 =?utf-8?B?bllveEpDZFNrQlNSZXI4N1FtN3RDQW5SVDMxM3BYZDI5ZTlVaTRIUjRFREpP?=
 =?utf-8?B?REwxOEdISEF4Sm85c1duaDRNUzVCdDJqMGZHWmk4b1hCeWtUOHErVUpjSVBj?=
 =?utf-8?B?b0JhYVJheEhFeXBCNHhBTlJ3WENwVXp4QTkrZHEyWThyRWJDODZnWWdRc3Jo?=
 =?utf-8?B?bm1wNHNTM2hhWHdKNGFONjhXUVRkUGdVVFRsQjdzcFBRR2N4VVZsNVp1VENX?=
 =?utf-8?B?UXQyaUZRVWZJV1hkL3RQUDVodnVXTWFCMy8xMS9JNHlMd2o1OHNIMWJrcC9T?=
 =?utf-8?B?RTlia0kvbHVabERSQlFuM21DdnFnYmZGYnUrYXVmZnhVOW8vK00zcnc0WWQ0?=
 =?utf-8?B?eklWV2lWd3hYWGFUMVFEVlRBc1U4ZE1xOXlrSTh3Rms0dUs0Ynp0Y25kcVFX?=
 =?utf-8?B?V0RoUzVIOFFIVzJaNmhwRG1rWWpKcllqL2QzYlEyRWNnRElMZEdaaDE3d21I?=
 =?utf-8?B?UGtkS0JQUS9CQW1Hb0hPbTA3K3V0WmtRUTFGb0YyQkVsbGhaMGZLYUJOZEhP?=
 =?utf-8?B?MHhvYzhzM0JlYmpiRE5NOGdwYVBJRzR1Z3FTS0lPMWJkeTRuakhnM1VFZ3hO?=
 =?utf-8?B?cmRmQnNJWklDVnNvZDRmRW51cHMveEd3NU9hdXBSelZ2ay83Wm1qaVZsdUtX?=
 =?utf-8?B?QmhBMWdrUHpsTSs0bXBKN3NMTFlNNEhGUnFqY3A2c29xZWIycEtlbklMRjhF?=
 =?utf-8?B?S2Q2L3F4WE5jcEVNK3BGQ21zQk4wajJaSzZqekZzZS9oVUlEcElLTUpvempO?=
 =?utf-8?B?K3A5UmFoT25Rc0VuZTh2V1U5dEd3QWFTcTZROGJQUHRFc3N2ZzNBdy9EVHl0?=
 =?utf-8?B?TE9MenQ5N0hQT0luVEpHZ1hXSFFiNno3eFdvdmV5ZSsvR0VDODdUcnE3b2du?=
 =?utf-8?B?NTFRMEZ4SUMyaUJRdDR6bU1LNEEyOFdXNnAzQUhMd1B6M2MzdUU4NHVJSEda?=
 =?utf-8?B?T3c5UkMzUFFDak5ib1dKeWNhbGNvT3BNS0tscDhwMmR3VExDWURlejl4SkRS?=
 =?utf-8?B?S0hFTTJhNVZkWkh4RGJvKzdzZkZMOWdiVjE0ZW5QcHRFOGdrZXFhb3R6eTEv?=
 =?utf-8?B?dVExMnRwYVZXdFRVbFpwK09LR3M5cExoQktIZXhpaHZ5WFdtem5vK0tyZDgr?=
 =?utf-8?B?VlNHVEdVOW1tS3pMeVV3KytOUXJXWHZ3R2pjZVZKUCt4bkUzcy9oOStKR3gw?=
 =?utf-8?Q?V3sxabaxReeRC3HFNM3CRgQ5FX7axE4R?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1duMjJ5NlowQUNXOXJ6TkZHSy9VTFFNTDFwRHVzYk1yNWVrRXphQ2FSTU5a?=
 =?utf-8?B?NXdYWG4vcXNzMkxvbFhZbFV2bCtCdnUzMktVZ1Mzc0psWmRDbWd4ZUxHbnF4?=
 =?utf-8?B?VjhjTWFCQnhZWGQ1WFozZmNoWVU3aVY3S1VVM09WT0JnSm9ERGh2Ry9XZXJE?=
 =?utf-8?B?VHc4WTFHdXpJdDV4cXMxZ2xJU3lqWC9PbWptQ0tRYVgwbjkxR0RPa2Yxd25n?=
 =?utf-8?B?MGJRY09FRDh1eW9TQWtHTG9wOFI5VXhvY3oydFVjcHprc0I5YTVlUGFLaGw5?=
 =?utf-8?B?blhBaDd1Zy85a2lIamZOekM1aXozWTd0WSt1Q3B5VXEybUF2NzVFdHVEMVNT?=
 =?utf-8?B?SU94Ulo1RmtXaHR6emF3b0ovNXBUZjFrbEpRYk5Md3UwRUFrQys4Q3VaZEJJ?=
 =?utf-8?B?ZVpYck5hVUsrd2xOTWVjalkya1UrTFMrNFNURG1QTnJzVk43cUtRajZXRnZ0?=
 =?utf-8?B?c0p0akxYakltWUN2UFd4TnhYTk5XV3p3Q2p5bW9UbU9HdzM4ZVVSNld6cnBp?=
 =?utf-8?B?RzRRV04rRldhM3d3Q2Q3RW1XRHA2RllsTmQ5dWx1SXNQRDVlZnRmSWRJWUZK?=
 =?utf-8?B?TXEyYzVXRFA4L1NDMVVBSnhtRWNLUU01TnJZT040eEpndEF2QTQxcjFhZFdY?=
 =?utf-8?B?MFYxN0MwZm5ESmtQVHFwS0Z2SVpGU01ET3hXVWNRdk1INXlEc1BpY2x6MG5o?=
 =?utf-8?B?amwwcDB6eWhZWFJxL1g3UGV2bmV0aHNLWHJmNGV3TndoUFErQXdDeFpnTTh6?=
 =?utf-8?B?RllsdkJwQ3UrYldEemV6Mk5lT0d3VWdmN0xhdFF3R0t0eGZiWmpwRGhOSXBG?=
 =?utf-8?B?eGRvdW5reUczYVFLdi9LbzRuZUxQTGtUMkVzMGFQS3ZTMXQwSnV6N2YzTG1v?=
 =?utf-8?B?SmVmNjdqZVo2VTQ1cEJGODhSdGxhUFdWZjREL2JEalNsWFBiWGRaTFoxVGhi?=
 =?utf-8?B?NFJjWk1mcUdWUEZJMnlIZFh4VFhMdkpsOWpLaTlOaUVIbk40S2ZGMkRXSTZs?=
 =?utf-8?B?eXUyMXllTXo0YnJuZVFQUjdFdEQySWR6Yy9rditpL0tiODRLbUd5U2dzaEZL?=
 =?utf-8?B?TW1ZcEV0REE1MG50SnVpTWFGTUgzd1JlSlpmblJFMFN2RFV4bDFKWkRua3Iy?=
 =?utf-8?B?ejlHK3R0anJ1VjhLNlpvaGhVREpzZTNzM092NTBzNHJQYVErc01JbjRrbU4x?=
 =?utf-8?B?M1ljUVF3ZVdsa3VRclFUQkt5SSszV3ZZb01lVE45RUtkdk9xWHNzbjdSajBF?=
 =?utf-8?B?dVpqYW1jTkFyaXZuMUxiWTNJNlVWaWkzTGUzN2R5aE40T0pyTzlNZGZobmFp?=
 =?utf-8?B?cUlPOHlPWFFBZjhkbmhpV0hFWnZUaGFmcXZPK1NHVmVXZWF4TmsvUit6OHVz?=
 =?utf-8?B?WE9MQ2plK2pEcllSRU4wVXZZQksrdHhycGd1ZHlHQU5JUmFCYVhTS1QxWHV4?=
 =?utf-8?B?TGRsYkRNbG9TdEZkSkJqOXkzYTI3cHMyRzR5YmErT01WSE96enZkd3FqaUFO?=
 =?utf-8?B?OGdPaWkvaVpjUlhZNURBNE82cDdyNTU0dk9qNHd1clkzbkp2cU9MVmwrdldL?=
 =?utf-8?B?Ti9MQUlRWjZHVG9TcHFxRU1pOVcxUy9uVVZIVWZ4RVZZMVFGVmx6ZjhxTWVW?=
 =?utf-8?B?MEdFVElaL254b2RaVmlrOG01RGExTTh1THVXM3V5Mkdvc0MxS2h3c2FhWmFL?=
 =?utf-8?B?bXVqUHF5N0UxKzBqbC8zQlZsOVBvTEpjanUxbFhDdnJ1ekRMVTlwT05KWnIw?=
 =?utf-8?B?dVV6VjVjVHJ4Ty9nTFBVaEV2T3FiWXF1TS9zdWhtMkt3MzNDZnZWN1oya3NO?=
 =?utf-8?B?bzdZNDB1S2JGNnVnVDc3M3hCMjhJYTBOK0phbDhjS2Z1dzZPQXNnUnV2ZTY3?=
 =?utf-8?B?VEtmT3NJT1ljWXMzK2ZVTkZBeEl5NENLNmtXTm03K2dQT0c0Qk9ZbXZoaUFC?=
 =?utf-8?B?R25KSUJFRFhabXN4NGs4OWc3dEw0SmtzRi9PeFJaazF4dUtRVnN6RWQ3OEFi?=
 =?utf-8?B?S1cwcUlWMWEwZGpmemRmcXhxalFZUEc0MkIxcVlhOGlESGV4VmxPVmdFcTcz?=
 =?utf-8?B?MG1uRlB4aDE3Z1N5Ujk3dkVxTG5oam1Ja3hCUnNodXYzajJyZDhKNGNNUGNh?=
 =?utf-8?B?cktISzFmSEQ1b09KMHhEaVpONWQ5ekh3c29LTWNsblJhcWY4NUV3dmpUU1Vj?=
 =?utf-8?B?NFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e60ea57e-448c-407e-a3e9-08de31bcf358
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 16:07:54.1313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VheicctfD70VxWMQKz/LcMusdaUK9VDwmCEoj/iVW0DXBRCilq4NKqfde7JpKCWTRRhnpC3xG0PXe5eFoTUPK80CFbG6Ge0mAuL0Wmin9iE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5251
X-OriginatorOrg: intel.com

Hi Tony,

On 11/24/25 10:53 AM, Tony Luck wrote:
> The upcoming telemetry event monitoring is not tied to the L3 resource and
> will have new domain structures.

"new domain structures" -> "a new domain structure"?
Looking back I made the wrong suggestion in v13. Since it was just taken verbatim do
you find it accurate to say there are multiple domain structures associated with
telemetry monitoring? This series only introduces struct rdt_perf_pkg_mon_domain though.

> 
> Rename the L3 resource specific domain data structures to include "l3_"
> in their names to avoid confusion between the different resource specific
> domain structures:
> rdt_mon_domain		-> rdt_l3_mon_domain
> rdt_hw_mon_domain	-> rdt_hw_l3_mon_domain
> 
> No functional change.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
...

> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 4a916c84a322..d6da21d4684b 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -50,8 +50,8 @@ struct arch_mbm_state {
>  #define SDCIAE_ENABLE_BIT		1
>  
>  /**
> - * struct rdt_hw_ctrl_domain - Arch private attributes of a set of CPUs that share
> - *			       a resource for a control function
> + * struct rdt_hw_ctrl_domain - Arch private attributes of a set of CPUs sharing
> + *			       RDT_RESOURCE_L3 monitoring

This patch is not expected to touch struct rdt_hw_ctrl_domain. Referring to it
as involved with monitoring is also wrong ...

>   * @d_resctrl:	Properties exposed to the resctrl file system
>   * @ctrl_val:	array of cache or mem ctrl values (indexed by CLOSID)
>   *
> @@ -63,17 +63,17 @@ struct rdt_hw_ctrl_domain {
>  };
>  
>  /**
> - * struct rdt_hw_mon_domain - Arch private attributes of a set of CPUs that share
> - *			      a resource for a monitor function
> - * @d_resctrl:	Properties exposed to the resctrl file system
> + * struct rdt_hw_l3_mon_domain - Arch private attributes of a set of CPUs that share
> + *				 a resource for a monitor function

... was that struct rdt_hw_ctrl_domain change intended to be here?

> + * @d_resctrl:		Properties exposed to the resctrl file system
>   * @arch_mbm_states:	Per-event pointer to the MBM event's saved state.
>   *			An MBM event's state is an array of struct arch_mbm_state
>   *			indexed by RMID on x86.
>   *
>   * Members of this structure are accessed via helpers that provide abstraction.
>   */
> -struct rdt_hw_mon_domain {
> -	struct rdt_mon_domain		d_resctrl;
> +struct rdt_hw_l3_mon_domain {
> +	struct rdt_l3_mon_domain	d_resctrl;
>  	struct arch_mbm_state		*arch_mbm_states[QOS_NUM_L3_MBM_EVENTS];
>  };
>  

Reinette

