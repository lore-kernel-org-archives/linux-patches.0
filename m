Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2082.outbound.protection.outlook.com [40.107.237.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AF21373
	for <patches@lists.linux.dev>; Sat,  7 Jun 2025 00:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749257676; cv=fail; b=kAx9yOcZey9xmMYOHxx1OyEJ9qF7J5ntZY1lxhv1hKHQtQLPaSRaQ5GwLSOBEH30E7zSjEa9cD3so/o56SIhPVY2VjdX5p1ROnm/g5MYvWOnpFt3XpKfNjpWJ7FnkPGyJIOLUbw6UdJ4aclamPtAZ8geV5hIZMixTp+OLcQve5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749257676; c=relaxed/simple;
	bh=pd0yWoI9xiX9rHUKlsdg6pkkXqoc/+GBlUq4Yg3ERNc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QJK0hAPmvuPQ7yedLce/UFL7m2gQJ0A4mdMfjXoJGwZrB7tomkdr/8+IyTmaxskf2QZezOwLTHaPStI7+SzapdSI0fpHTIBUvX5q0E4mJhp7ZWI7i4P7+8gicmTu1awi6Ox3BR4gX3BrVaxugi3MdJ4E32XXuh148lV+BjDwzqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=W1vsCcU9; arc=fail smtp.client-ip=40.107.237.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="W1vsCcU9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=abmWtu4/RUCfeBbMVnQuWa92OgKA8hdVbTHLnv5G9N1I9WYDYJsqisuFZimLUt4GtLbLBRQN/kDzCDxs8A5joj6dvamaVExb5nBqylt4KpfOYESy6MVABS/qMFEDgkipuSlEOL7pCVt/a5eEf7vWARggy4r9H1tA4E/StgeKeLenyoqgjEfxjRhGabjCtXNvkJdACuIUpR745Tc3DCOSUDZEi097drgbGdh9YTGIllXCnH8i3I5Q+72fWMnh2kXIske8+SlENXAUEPgm/NFJPXq0Fn6mWI/uE9BmfUbHgLwWvHrZ+z3zsFspH51gyp1Lp6Ntxsj9cWpYhRb9X597Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2bzdj7SvdNaQXn3bWDlMKMR6gCSTw5s5OmrSAJX4qX8=;
 b=lXTD4WCaplEhvX030R/Tp4MAMEAQTpxkDa7iSA/bvRrE5sSRtwg5n2N471c5vaja92RzTwg4EtGIg+jaX9dbCfL2SBv3isgsWxkQ3QErMAcTDFGSug9qLCIxgtDSXWBbUZ9XOuzPc6nhHxTi64UyXb7erJc92+ARx8oBBbEvr/SFj5EJWKx3k0FQrJ/oTTfceGT+wXO7RhKawHEBNnC9rBLGPZnWRRO6M4rfOLTvomhH391vmkl68Z93kqEzj7DUBDYQwayT1wP7zJyKw5i2+fxKrSItSncFNdyD17mbK2nSMkadLvA9i+34DQi8gsmESbNiRevtfja9Nlbtun0fhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2bzdj7SvdNaQXn3bWDlMKMR6gCSTw5s5OmrSAJX4qX8=;
 b=W1vsCcU9lLQeJ9XNsuihlGS0bgDqweg8W7n6Nt09g+k4NEyS94DkSPQpivEHqe9YxFBVA5sRbYl4gPYgR3QaHxSCB1jzdSpBJI7HWIgnPU/E4Zd3ghAQTWo6exhVNVIsZmA+OyitKqRg8Y0qNW2UTOp7aEU69vG25wnc5JT14GaoNRmnUbiZAhsEnpPHT8EwsYXfE5dF+QAIPT+njkg97tbOcY9ygNrw8b5pb6jH7WPF6VALvXJekqvA9/LPNrycMSKnZEDs+AUECFBU2zWUiIRstM6PGXgkdqiAzq60dGDGL7Ne1341WLxIHxS7qgxdlggAKzii5QI/phWV2q39Aw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2667.namprd12.prod.outlook.com (2603:10b6:5:42::28) by
 PH0PR12MB7930.namprd12.prod.outlook.com (2603:10b6:510:283::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.35; Sat, 7 Jun 2025 00:54:32 +0000
Received: from DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2]) by DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2%6]) with mapi id 15.20.8792.034; Sat, 7 Jun 2025
 00:54:31 +0000
Message-ID: <9ca45c27-7d1c-4bcf-bcc9-baa24fb7c95d@nvidia.com>
Date: Fri, 6 Jun 2025 17:54:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 22/29] x86,fs/resctrl: Handle domain creation/deletion
 for RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>,
 Dave Martin <Dave.Martin@arm.com>,
 Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
 Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-23-tony.luck@intel.com>
Content-Language: en-US
From: Fenghua Yu <fenghuay@nvidia.com>
In-Reply-To: <20250521225049.132551-23-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:2d7::32) To DM6PR12MB2667.namprd12.prod.outlook.com
 (2603:10b6:5:42::28)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2667:EE_|PH0PR12MB7930:EE_
X-MS-Office365-Filtering-Correlation-Id: d24005ef-cc22-467f-a069-08dda55ddd16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cDdEQVJmbzd2YTg5dEw3K0ZyckllNlhoYzhhamJGdmlONWFIMGdQcm5YK3Nx?=
 =?utf-8?B?em9pUXRvZ3o3TXpMaVlOb3NtV2MrQ04rL1RLaVdud0g2b3UyajlKWjhLUXpF?=
 =?utf-8?B?T0lhUVJPbkZiQk9qdEcxN3NXQXk2UXVUZGFkZEtRM0xoY1QzWkdBWG11NExB?=
 =?utf-8?B?OWVBTFIxSkNiYVJBN0VpeGlSUUpMU3BIbFNhYWJDSXdCUjZaa1lnRlhBbmVH?=
 =?utf-8?B?NFZHdFdhZXVqdnRDRTdvVnZmZTFKdHl3RUMwZTc2eDNaU2xKbHQ3eGtLakhR?=
 =?utf-8?B?eDhybmZBamFleTJ6eGVOcVNrS1YvZzBqYU5nbzZhSlpoMk8vRnk3RVNpajNv?=
 =?utf-8?B?cDQvSzIwY0FNTWJZMGVTZFVnRFB0THF5NFVwU0VFRE9FVytGeXBsa0F3dDZP?=
 =?utf-8?B?OGVEaktBN2VCUFNhT1VWNVBzdWRXYVIyT0x3dEJDZkdLWEdVZVVvOEYvOU9i?=
 =?utf-8?B?TVpHYlZuUGo5dGdLb2hBeXFpdTdxTXIzNDVJbUpaVWltN1BHVlcwR3Bmdk0v?=
 =?utf-8?B?Q0FXUUNITmV3a0VWYVphNGsxUGRzbmNManBUQ0x3ZTk3eUxjMGVnZTZtUlBZ?=
 =?utf-8?B?RmVZTnlYNXcrR2dBK1NyTnpURHlxQksvWjlqTTlpMndTaUF2MHJBNVVOZkRT?=
 =?utf-8?B?aGxoSHgvZXZKNVo1czBhRmxDMjlDQzRyZ3luZ1ZvTVZ5bVZuT0EyeVZPSlFX?=
 =?utf-8?B?Q2tqS0R0QjdTOGthYVFVcWVYS3hrckxqeHh4QU1ONktlREdmM0tua0NMSDlJ?=
 =?utf-8?B?dXdkOWtwNkN5UnFOVHE3d0JBQ1JRekFYVDFBNGNaWHZ0VmhNVWVNLzRTM1lZ?=
 =?utf-8?B?QmZKQWVPZkxrclJ0SHlVNnpSeE4vTmFJUmtyR20rUnVpTmp1U3BPbXoyWEFR?=
 =?utf-8?B?aWM0ZDJtaFo0cTcwbjlmOW1SY2E4WmU5cDNlVGp1Z1pnYm5SbjZ0VEIxVzYy?=
 =?utf-8?B?SmcwVjZxUHpxcXFtdWJ6N2tJTjVQNWFFUXMvVno3S0cwN1RDQ0JCam8xM0xE?=
 =?utf-8?B?NHZPbTBoc0ZYNTBjemdvUGI0MWR0MExEL29wcjJzSW1WUG8rNXIwdEw4SDkr?=
 =?utf-8?B?ek12TTJEdTlBRTdPNjJSRDRFbkhCOExoU0pKVGlnOW1LbnVEREZmRldwMDhn?=
 =?utf-8?B?RUo0L3JWcHo2RnhiY2lWWnI5QlR2WlZ0KzNVclFxQ2ZVdTdqR0x1MU9kN2Y0?=
 =?utf-8?B?UjdUNEdjUGxoM21heXlVNmprQkZzVDFTbnoxWWw5SEc5SFhjWHRIVXMzUE1w?=
 =?utf-8?B?bU5IOGw4MDU3ZzlreVNQZEFPalJmdldrTU81UmgybU5tZzAyaUN5TEVtL1Ju?=
 =?utf-8?B?TlVwbHUrOXhBNThkWU12QVN0RkJsR3o5cnNkZjNPMFk5aGNSZnFYYVdiOU5V?=
 =?utf-8?B?RmhFSUt5UzJBaW92ZEdFVEpRblFUb1N5UWI2d3Iva1A5RGxmemxldkVSUDBw?=
 =?utf-8?B?enM5eWRTNkxnaU42OU5jN1pDc0svNU8xV1NLREgxK3FXU25zUlBPVHVrb29m?=
 =?utf-8?B?TmdwcXNBdDJOSFoxSHVodmd1RUJTLzNHbExqT0ZyclprZjJsNnAvY3RWODRL?=
 =?utf-8?B?UDFiNllHU0NKZGtQM2VQajRMREhtbnBteURTNXUyalNkWStxN2tKY3RveUVl?=
 =?utf-8?B?MTBLbExrQ3J3Q3BJeUcvaEtWTU50Y2dWeGV3OEFyVjFsb0tJYnlGZG5QcE1n?=
 =?utf-8?B?M0JYZGRiRzdLQWRkRFBGNTZpUVZHN3F5V0lqNExlVHlPN09jbzFXOS9GS2FH?=
 =?utf-8?B?SlBnbllOaWVLaGozcEJ5a00wMlBUL3pnR2hzckplTWJHRmhVTEdxMnhKNDMv?=
 =?utf-8?B?aHZYZlZBelBEeFQxWVlRVFc0MSsyclJFTjBPSlR5cFhBdFRoYVdPWTc4ZU5Y?=
 =?utf-8?B?L0NhU25Ua0JmcW03MkRkczltRHdRSUZsUTE1VVcramU3bFIyanQwU3JjUDFm?=
 =?utf-8?B?czNveWpIMEtGT0NXRmZiSngra2ZTajBpNUp1TlRZeFgwMUhuYWhTaFFlVGhR?=
 =?utf-8?B?RzcwMU1OMkNBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S0o1ZUpkamswNkpqeFpaMjQ0S0J4dkhTWTI4Tm8xblN0MHNOZDFKRzdmai9E?=
 =?utf-8?B?d1ZhUnRQeitPOC9JTWc4Nk1aSFhaTlZUS0ZiYTBvOGxLTkNnU2JwQTBzRUh6?=
 =?utf-8?B?S21rYW0zUnZ6eVpoaEJCSUt2empLbElVWDhtMUJ3SGFOS2Z5THdHQTFHUkFS?=
 =?utf-8?B?S1dyMEZnV2U0dks4YWk5RWtDN0ticldvVnZZNnhzMENmMGRhNlNCZlh6Qzl4?=
 =?utf-8?B?K2laOEJkOUJvazVTaGpZNlAxckE0U2VKSmhkeGtXeCtmRjZRT1JlNnErakdX?=
 =?utf-8?B?MjJFRDh2TCtOMnFqT0ZmZjNzeUhONjN2M052ejBKSGRoNlVEVG1PeWNGMHZu?=
 =?utf-8?B?SVNWdmRTb09LNGxaeWN3WHQ5U0tmdHVBV1Vmd3NwbjJxdm54b0ZiWHRQREE2?=
 =?utf-8?B?OUEydEhMUVdmelNSQkVEMWhnZ25RMExXV2hHSWd5WkVtU2doWU4vSHk1bzU1?=
 =?utf-8?B?V2FLelhEMXN3VThHaDI3ZjlPL1U4UUpBcGNCU3d3Z2hONVBKTDY2SkJhOGQ1?=
 =?utf-8?B?bkhibU1iRGtyUzRtai9ISUE0VDRCUE5MdDg2YzhyWUpTKzRacWYrQnMwT2Z3?=
 =?utf-8?B?enp4OHNKMFA2TGhNK0wxbzFVL0k2SDR4YWlWdjl2RDV2TTdVck4yZTNuc0sv?=
 =?utf-8?B?RHVsaG03ei9QNFh6a21YVTFwY3h2NStRVzA0QzBDbTJ4SS83K2k0ZGJQQnVn?=
 =?utf-8?B?dTNPL0hQVW4zSEZzZ3ZxMktHckhzSCtRN0laTTBZU1Fqck5tRC9tSzdMWmhy?=
 =?utf-8?B?cEFJUEk1T0JWbkw3OVFnU0xrU3FRbG1pQjBUTVNJWUhidVR1cDBJdDI3Nndw?=
 =?utf-8?B?RUI4OFllV3lndWZRZ1E4V0xiMTQrUVJxVFdobzl1aUNwNURhMFRpckJqZGxQ?=
 =?utf-8?B?MmRxVUlWUFFrdHZNU1B4RVEvaTdwRVlHZkw1V3hUM0ZZSy9qa0cyemgyclN6?=
 =?utf-8?B?NlVybm91VjNkWkpUdEtnTCtyaG9OUUtVVEFYdUZmMWFKTGJEQ2xsanBKZVhw?=
 =?utf-8?B?TGFyU0M4TFdhaDZRNTRuWXhqSndlQ0JISTdwcjNHQlg3NlhsaUhjcnBneXhT?=
 =?utf-8?B?MTVmdDVxM29nTDBzYXNPek05bC80aVlSYWFYQjVqL0g4ZnN4cG4xT2ZuM0xL?=
 =?utf-8?B?QVRqQzJVb2lNMERHQjFINmNOUzBDWTdLVStmRUVlb0t5bmRHTm1mZ1NkSHhV?=
 =?utf-8?B?OG8zM1pBWU16ZlBEODQ5elVxUlB6MkRFaHBsNGptQ2ZwLzZVYkRBYU4valZP?=
 =?utf-8?B?QThRazFKZSs2bE9UZkoyWlVVNlJhaC9UaWduTUNJRTkreWNpczRKWUNvOTNl?=
 =?utf-8?B?OEtMcGgyNjdXM1lwMTFtS0RmaXpJT1ROQVd0Wmk1TVNLQ3o3d3l2NU90aUJH?=
 =?utf-8?B?UGxvQURBUlRGTHY1WjQ0Z3BwWkE4K0xPak5tMUcrMktrQ0tXS1BMVXBqUG05?=
 =?utf-8?B?aHlPeEhmU21MTUM1dmM5bW1pRWNmVkFTQ1p0c3lzaktKd2ZhaHovUmFISVJD?=
 =?utf-8?B?ZG41ODgzL1VlenRNaXBtY0tScVBkZnNKYjRoa2VWTVRQbVpyTm90aFNVOFdG?=
 =?utf-8?B?cVcySUVFeC8xNkZGeVlubmNhMFdMSjJiS2ZaNmltS0k1WGl0b1ZsNnltaVVJ?=
 =?utf-8?B?ZUNaV2VOTGFwODJPV0t6YTY4dGpDOVVTcG9sb0lRMzFvM1lIOHFWTkFQRXJy?=
 =?utf-8?B?Y2M5bmdmMkpzM2hTMnM1UjE4RFJ5anZNU0FPbG5iNU5hNHpESjJUVlBQQXly?=
 =?utf-8?B?aXNLQVRKUThndGJlRWZJTEdPZVNrMUxPWXgyYkVXTEVUcjhZNlU5ekh0Tyt6?=
 =?utf-8?B?MzB6WS92Nk8wWHFyTXp3WTVMNTlVSnRCNExxbSt1QzFjdlplaWcvUDRPYVdL?=
 =?utf-8?B?dFVaU05GUmx6cUtveEI0U3dQcDlZYVBxYWgyckgweVlSV3RCNEE4NmlCM0ZO?=
 =?utf-8?B?cDVxckQ4S2hXODRxUSt1S0NIQlRUSjNJNzV6amw1TnNsSTR6NFdLblA3aUl3?=
 =?utf-8?B?dnhpbXhTdzZrM1BMa3NWUXFENGNBZUJuTGZNWDZuc2ZJYlMxNEtZbEtIUGQx?=
 =?utf-8?B?TWlZd3pxVlFaK2dMZU1tM0wxdUtxaE0wWlE5U2U1VDdxVGhXUHI0OFFZUTJY?=
 =?utf-8?Q?iC5yCK+FVR9vvYbMUd16yNxD2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d24005ef-cc22-467f-a069-08dda55ddd16
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2025 00:54:31.7990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SFbdEq0c0TQfV7QH3zAinDD+bztktb7pb76eDEoEmpk7TOY5NUA6ujU6bRhgF/exC1x04AA/R0uay0YIxRBMEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7930

Hi, Tony,

On 5/21/25 15:50, Tony Luck wrote:
> The L3 resource has several requirements for domains. There are structures
> that hold the 64-bit values of counters, and elements to keep track of
> the overflow and limbo threads.
>
> None of these are needed for the PERF_PKG resource. The hardware counters
> are wide enough that they do not wrap around for decades.
>
> Define a new rdt_perf_pkg_mon_domain structure which just consists of
> the standard rdt_domain_hdr to keep track of domain id and CPU mask.
>
> Change domain_add_cpu_mon(), domain_remove_cpu_mon(),
> resctrl_offline_mon_domain(), and resctrl_online_mon_domain() to check
> resource type and perform only the operations needed for domains in the
> PERF_PKG resource.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/core.c | 41 ++++++++++++++++++++++++++++++
>   fs/resctrl/rdtgroup.c              |  4 +++
>   2 files changed, 45 insertions(+)
>
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 64ce561e77a0..18d84c497ee4 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -540,6 +540,38 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
>   	}
>   }
>   
> +/**
> + * struct rdt_perf_pkg_mon_domain - CPUs sharing an Intel-PMT-scoped resctrl monitor resource
> + * @hdr:	common header for different domain types
> + */
> +struct rdt_perf_pkg_mon_domain {
> +	struct rdt_domain_hdr   hdr;
> +};
> +
> +static void setup_intel_aet_mon_domain(int cpu, int id, struct rdt_resource *r,
> +				       struct list_head *add_pos)
> +{
> +	struct rdt_perf_pkg_mon_domain *d;
> +	int err;
> +
> +	d = kzalloc_node(sizeof(*d), GFP_KERNEL, cpu_to_node(cpu));
> +	if (!d)
> +		return;
> +
> +	d->hdr.id = id;
> +	d->hdr.type = RESCTRL_MON_DOMAIN;
> +	d->hdr.rid = r->rid;
> +	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
> +	list_add_tail_rcu(&d->hdr.list, add_pos);
> +
> +	err = resctrl_online_mon_domain(r, &d->hdr);
> +	if (err) {
> +		list_del_rcu(&d->hdr.list);
> +		synchronize_rcu();
> +		kfree(d);
> +	}
> +}
> +
>   static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>   {
>   	int id = get_domain_id_from_scope(cpu, r->mon_scope);
> @@ -567,6 +599,9 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>   	case RDT_RESOURCE_L3:
>   		l3_mon_domain_setup(cpu, id, r, add_pos);
>   		break;
> +	case RDT_RESOURCE_PERF_PKG:
> +		setup_intel_aet_mon_domain(cpu, id, r, add_pos);
> +		break;
>   	default:
>   		WARN_ON_ONCE(1);
>   	}
> @@ -666,6 +701,12 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
>   	default:
>   		pr_warn_once("Unknown resource rid=%d\n", r->rid);
>   		break;
> +	case RDT_RESOURCE_PERF_PKG:
> +		resctrl_offline_mon_domain(r, hdr);
> +		list_del_rcu(&hdr->list);
> +		synchronize_rcu();
> +		kfree(container_of(hdr, struct rdt_perf_pkg_mon_domain, hdr));
> +		break;
>   	}

Why default is not the last one?

Thanks.

-Fenghua

