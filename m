Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E6819E7D0
	for <patches@lists.linux.dev>; Wed, 30 Jul 2025 22:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753913127; cv=fail; b=QsnYb2uwAcm04qiXyVU2bCfBiGapRfeL9D4b8CstYhd7bevhfd/B2WtmNuC2yj8GlQglQ6FWCb8gxISP/GCaFZXaMzftW4C8Ixwfw0fQPa7joqb3hd/7eB51mzqc8F7k7+9Bi3tuqnSDV/cjl+n9uiJgf4WPmZyORqaoF/9WQSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753913127; c=relaxed/simple;
	bh=vsXwsuQBggM0JGS3Zy/k6EnU3PKm7mFoFt7eUTCe6PM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=k0CMIf3xzWJNDfkEIoBOTCXc+6zYNCyCrxuhgJ3aX2WxMGs2kbnSepzfmG5zNNi79wx5EkLBYU3oDg6VPaI2y2sAwSDNNJRrNSR55cs1b20KeUot6uNmoSXW/SJsy8kd0MrlvdhWnNBoq1PnMdpQBkxw+xL3Mh0SLnP83L6O/OM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tn3ls8Ys; arc=fail smtp.client-ip=40.107.236.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tn3ls8Ys"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iK1JDWXiStIa1cMWDXqUX65DpstXBLANznoUXiurlfwHf91opuaGZwaZK3+odnXEOgAmieNVEnViZDKgyXolaPDKbODE9///N9cmybb/KXjzgYv7Q+rEkNOkpHlhxawXnhdVDFhwd9/YBEyXyB5ookyVyypyOWuJuCFefwCVS5FQRPEmnnP4mAyJUpvq0amAjaZ+DzX4f02YdeEOwM1/dPVIQCLrCGNTB4+7PIIH9SxOaSPMEEyLMRsBTIe1o0y6pEGNl1dVJey8c1tfgZF9VYUOyus/mUywbkw6tObyAdmfB3ztpKy/dzsdjRSHHg6TPKVe+FnMzaDbel5DK+MxAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WtdDUWUNvJWtyavcZF5WUFMbl7EzDHeoIxIuqolHwxw=;
 b=GfYGKBNl4YTgqOA+y7zm19kmMwCvGBQ1fvjl7RYT6YZMdHVrxmU53ttA4NG1ewdu26wNCdjgJd6bRzCGhEozSgXSR6ggQomxdsQuexRS8d+s3WujM2R7QEBB54g1oj5QXHTUNdKCQhQP+Wg0DhUqV85a5HoIvv77qY1VJ7H4A8Ki5ai6oZO0Irn27H1mjGVsrpNfDd2QTL2CkG3bLWxqDDawy9FCbvNlTzzZs8kLmhpWT2FBU+5jxZPfqc919oIbwgEwf9tOv4Rlq7u8H5wDRgJEi4Id+toS4orgvo+gAHb2h/A4IihjnlK5qytZ1fJrKBQ907bCWirzZkSVnUl62Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WtdDUWUNvJWtyavcZF5WUFMbl7EzDHeoIxIuqolHwxw=;
 b=tn3ls8YspeyzSvJ2al8izhfF5hvEer6fEOoXRsVS8T8QGkaWWpaim3NvGe/7k050mJgotNGR1JP35+NHQhbz+sikrM/xgtZAUVzC3oiTwgOAbmWja79ZXjWUsTMSF4sb0TNPGdi3WBkdBdmFgKJzlquWZ52PUckfXEGOV+4NaN8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by DM4PR12MB8521.namprd12.prod.outlook.com
 (2603:10b6:8:17e::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.12; Wed, 30 Jul
 2025 22:05:21 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::bed0:97a3:545d:af16]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::bed0:97a3:545d:af16%7]) with mapi id 15.20.8989.011; Wed, 30 Jul 2025
 22:05:19 +0000
Message-ID: <6eaad2f7-016a-427f-9d2b-6da548c8610f@amd.com>
Date: Wed, 30 Jul 2025 17:05:17 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/31] x86,fs/resctrl telemetry monitoring
To: Reinette Chatre <reinette.chatre@intel.com>, babu.moger@amd.com,
 Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
 Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20250711235341.113933-1-tony.luck@intel.com>
 <91258652-7573-4065-9590-3d03e13c9e0b@amd.com>
 <866fddd9-edff-4a81-8b11-ed017b9a9d9f@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <866fddd9-edff-4a81-8b11-ed017b9a9d9f@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::16) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|DM4PR12MB8521:EE_
X-MS-Office365-Filtering-Correlation-Id: eb9fe661-9dca-4026-3bd1-08ddcfb52c2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MWN1bFhwcjllbkZPaFRsUkc5c2dNSlBsOUh2UGl5YjBmS2g3RWlkdjRyaG1u?=
 =?utf-8?B?VStQMmd1VkY3eTUrdDhZOHNVR0tLSFFnNnpUaU02Z0o1SHNSV01haTdGdTRk?=
 =?utf-8?B?LzcrWGx5Z0VjWVR3WVJZVmlyZzE2ZVErZ2ROWjBqN2gydEptQ2w0RnhGbW9u?=
 =?utf-8?B?NEJvVWpPcnFUczc3QmIxbU9oM0ltdUdnR0JFZXZIcE5rbVBFcmxjOG00cExt?=
 =?utf-8?B?M29ZbDFVd3lIZ0trNUZ3VHZvMVU3dC9qQnlCVWsvSTBKL0JsQ1dMeUR5Mkhp?=
 =?utf-8?B?WXlyMzFGZWJob0NlYWgzWkVuSjhyTStobm1QQ0xCTnZhbmRDSDFBK0QzSFJF?=
 =?utf-8?B?VHhzcHFsSW02RDBvWlhEMUNWdDBnZnRocEtxSzVMdld2MFlLaHlwNmZLTyt5?=
 =?utf-8?B?emtFWW42d1lad3VBS1FFNmFWRnVTNmdnUTc2d2ZFUFg0elQ2Z09RelNNU20x?=
 =?utf-8?B?WlA0ZmNuM3NLZVVaRlJ3MWJrUXdvODhveGdlZ2RuMHRTQ3dBM2c2TEUyQUVW?=
 =?utf-8?B?Zndla2JZazkwOGRJeDh6SUU4QWU5Z0xaZjNwK01sVkRidlhYWkRDY0xQZ1RT?=
 =?utf-8?B?OG9Va1N5Z0dSb0wwTG9pbFd4TDNLWml0TlVORVhudU0yTy9Td2JIS0FaV29j?=
 =?utf-8?B?dll6ZXBtaExJRkZjNDB1LzZINU1KOWY0Q1Y2cDh1VmxtejNnbnBQcVk4QXRn?=
 =?utf-8?B?dEpiWnFKWWRIeW5XK0hYaFhQd1hsYXgwTFJpMzlFbnZKOXJuSmVQVDNucTNs?=
 =?utf-8?B?L3RTdEtkbHFBdVZZcUJjMFVDOXZTSG9VcGN3U3JpQktTS21VTVJEWkM4bUM5?=
 =?utf-8?B?UktERnRSdU5lV09DZ2ZSVUJhdzVEcHg1ZGJ3dUVtbU9abzZub3pTUjhjc2NG?=
 =?utf-8?B?L0xLNWw4U2ZFQTY3SHo0UEY1eGloTFJOUmRJVzJpSEVzNUg2anZ1Vnh6THl4?=
 =?utf-8?B?bDhlUG9OZVoyZXF1REJlNTBBaEY5Q2x5YldNOXVvMzNvTk94dFdhQUhVemVX?=
 =?utf-8?B?QURxN1dnTEt2RXIwQ2NZS3hUSlMrSUVoQ2dIUHVqekliUER5WnlrbjN2SnBx?=
 =?utf-8?B?OTVlMDQ3cHVrekxjM3l4TkJUUk9jWmtCQ1p6Nzk4Tk5JNitiTnhQUEJkV21S?=
 =?utf-8?B?dys5MStUaVhiTVNpRW9kcnllK3RSUFRwUDJYTHNpV3R5d3ZKeHNoUXRuakdD?=
 =?utf-8?B?U25hTHpUcXQxKzJrMk5ZV0NvZVFuVXJ1VzA0L056NTZhYjVCVlJHQjUwZWNT?=
 =?utf-8?B?SmZZRi9JcE1aazBGVFl5ZTRnbXVteTlsNmV5UU1iV0N0NmpwU1ZwalR6UXRr?=
 =?utf-8?B?Tnlac3FacVUzNksvV3cwbmtHWUNWbFJWSnlYOWg5WURmY2ZvSFBCY0ZidFNV?=
 =?utf-8?B?TTJ6TUdUN3VNLzhxbEV3NENUaUtZZkdkTTFab2U1NzJ1TEhMUXVDeWtSM1Z3?=
 =?utf-8?B?SHBNUWl0MEhXUUJvU2hVbzRiWnVtUlZkTVJHcVVzTWVlZ2kvL01vTjdEM2RD?=
 =?utf-8?B?dHBVVnhRaG5KQ0hyQ3lqRXp2cnlLVEhlYUFqa2tRUkFHcUJWcCs0Vitta0Jr?=
 =?utf-8?B?VEpyN3dxMG9VY3lkL2xkenRnRGltVXZubXg2Sk9FdlBvQTJWby9GRStCQTNJ?=
 =?utf-8?B?QXR2cjdXVTNqTS9nRnV2cGZHOFNYaEh6Mjd4SmNzK3dRbnhEWDN1dXg5bk12?=
 =?utf-8?B?ZHUwNDJJUzNtSXBCaHR6VW5uVHNBZHZwZloxSjhiOFRpVVlzMVRRS1FVcUFp?=
 =?utf-8?B?bm1VZVlKRCtHa2loSExtNVl6Z3RkZEMxWC9RSm5CQjhaRUlYS1BPekVoSDR3?=
 =?utf-8?B?bWVUMWsvangzNHFRaExnYm84bUt3Q0xtYzgzK01EMHI1T0grOXRKN3FZTmNI?=
 =?utf-8?B?SkxQTzUvRjNxcHNLQ3Fybzc1dkJJYnBNN3RqYXMwZkZoSGdtMzVBOHFFRGxq?=
 =?utf-8?B?Tk51czllanZGakR2ektvUFBvYXRDY0oxTy9lM01sTFNKRlVSbStFRDgrVlRX?=
 =?utf-8?B?VW5KTGtoT2RBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEZydWZWOEVjVWJ4S1l4RGgzUlh0ZnRKRkg0aG02U2xQRld0MlRxQTlMZGJR?=
 =?utf-8?B?T1FZdno1UmpUbThmNllKR3hiNmZ1a2U0NCtLWDFGN016dk5LOEN3UkVtMU5F?=
 =?utf-8?B?V0k2TGtpSCt4ZndPWnNCd2MxL1ZzYXRRQ05JZVhkMFVsSVRzYnpPMnpQcjA0?=
 =?utf-8?B?YTVnaE14djk3eWxZT2hYTVp3VTRLOTgxYkpwL0s5Nzg4UEQvM2ZsQWhXeW1y?=
 =?utf-8?B?d2pIWFBuRTBMM09WSzYwNkg2cGptYk5CZndiSXhYZDI5eUtwbG82LzY1RFBl?=
 =?utf-8?B?cEJYM2prTEduVnZXTEY0OVNVNTMvQUxoNko2MkZ6QlN5blZyNVBJVEc1a0xJ?=
 =?utf-8?B?QlA0NWhlamx3SkY4RHc1T09OZHdnVXRIalBzU3ZKcnV5V0RYdjlsMng1QVpW?=
 =?utf-8?B?MXk2cWpUMlovbys3ZjlVZkVySkJPVzNGa21xNEE0b0t0VnNkdTRHZHQ2Qjg3?=
 =?utf-8?B?MkE4dzBEQXlWWjZrUU05OTFxS0tBN3J1ZkJMQ1BkdEhwTTd0aWo1RWdHYmFC?=
 =?utf-8?B?cXFTSGtEL1ZjOE5sWGRGNHZnaThUclBZNm1Xbm5pQjhubzNzOHZ0SHVFWTlI?=
 =?utf-8?B?d3E3NEF1QUcwcTBJWVFwNzg4QVVWL20zY2dnYUZVNENMVnljRDd0SHo0YlR0?=
 =?utf-8?B?eWFTRUN4Nmg0ODN5Qi96V3psVHhMOVNqcncvRVphNEZTeE40RWpWRjR6bExl?=
 =?utf-8?B?OWhuUjVVcUFRZ2t5YVhYalFEWCsxbHoyY1pJT2JJRkRpKytyWkIyem81alNL?=
 =?utf-8?B?UXdNTmtOQTg4YXR1Q3p2VE5PUXYzaThSbFJnbzJTamltNEU0WHVJbndTZjVv?=
 =?utf-8?B?NDAva1hDa0lsUzVwOU1hYk1lMGl2OTRmV1ZvL04wdWJ6ejNWVCt0aGV1b04r?=
 =?utf-8?B?VWVvT3VQaGw1ZFliWFg5OU1oTDBSYXlaa2N2S0Z3cDBiUTlyVmp3cmxMU1Rq?=
 =?utf-8?B?T3NVakxzdzVxYmdWbVV4ZzlBc1UydWsrelNTRkpEVmEveDR1Q1RXNUJUV24z?=
 =?utf-8?B?RnVWa1I4bEUxYWJnQTJzOEd1K2FvSzNFUVJqbmtSTEp0RjB3OElQTXh6OHdN?=
 =?utf-8?B?OHJXdEJUZ3o5M3R2eGg4T0hqKytJS3JSc3RCd3I0L05PaUx2dlozUCtEWlV3?=
 =?utf-8?B?Q2tNYVhyc3c1OFYveHFRQzZIaXNQL3NQbGY2bGtCLzFTd0w0Vld3ekp4VnpC?=
 =?utf-8?B?anhGcjRjM2FWbmdCME1wbXBERXd5U2tvbjBncXpxaEYxSnZMN3k2YXB0QWhk?=
 =?utf-8?B?eElxSGVHMFFvTnRhbUQySjVSZE1zaVNnQ3haVjMwSml0aVZ5SFA5bkJMQXdE?=
 =?utf-8?B?YzhxYXQzYjIvOUs3MjFLT1Z4S2JoNmI3ejJhNzA4dGU2SkgwUWxEUXZrYVVO?=
 =?utf-8?B?MGFOdmszbjluRzZKbWNOajJMczVzVFRqQTQ4WStRazBhd2hFZ0VnMEh0WTJj?=
 =?utf-8?B?RjlMTWlwOCs1YzNkSlJqRDBCcmY2MkQxbjFYSlRaY2ZCZnBhNTlkUVhmb1Fn?=
 =?utf-8?B?UXlWRGVPNVkyM2FkeVUxUDFBK0Y4NW9TT2dlbnNBUUlSYVZFck1Pa0RzMU1P?=
 =?utf-8?B?YTl3NHhFS3FtMGFUSHFhdFc2SXp5SlI2U2owdkxweTdPSWV0N2RqcnIzcXpZ?=
 =?utf-8?B?SXFTZU9naDN4QzdSZmxJR0lHUVd2V3NXVkpYSW00MXBOUko0a25zR1RVTGxD?=
 =?utf-8?B?OVY1bHJmcXFDMEh2aFN0UDhUN3ROUUlTSkhGemJLejFsZUhHWVpVWXYyY0Nw?=
 =?utf-8?B?STdqVFZCUW04UVRnVk8zbElKQ2o0RDdtRjBsSHVFMkE3MkFic1lJMEhPcXpL?=
 =?utf-8?B?bjJjWXJoVU9GU2dUL0d4ajRQakk3bCsvWGsrNXZsTkY1L3hVWC9TdnpieC8w?=
 =?utf-8?B?QzJMOHZMSUxtNS9JcW8yR3pXY2JjUXljcmZrR0YrY1QxWG44bUM1QnpEK2Vq?=
 =?utf-8?B?WHhjOWNjUzgyaVQyYkszUlZialo2a2Mrdy9iQlFyNW9CQldGT3BwbXlWQi9I?=
 =?utf-8?B?dGk5dDJHSTBORU9yT0wyYU9udFcyKzd0d2NVYUZNVnBaSzFNcTJWTDBITkVw?=
 =?utf-8?B?cGplVk1YaFdtZktrejBpOXVxYjQrMmEvbFJVcnliY3k4QTJmMHI0dS9YbjFn?=
 =?utf-8?Q?ErFrsAgTBTVk+ohwCOQJgwbCe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb9fe661-9dca-4026-3bd1-08ddcfb52c2c
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 22:05:19.5081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /4rhJhuLquFxNEQuaP/uiNy8j4ERaIlsc3NxundhACqy94BsJkK6fU+6HSuMWfst
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8521

Hi Reinette,

On 7/30/2025 3:27 PM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 7/30/25 11:42 AM, Moger, Babu wrote:
>>
>>
>> We both(Tony and me) are carrying these patches. As we are in a merge
>> window now, any plans to send first four patches for 6.17 queue?
>>
> 
> No. Any resctrl patches targeting this merge window should already have been
> merged into tip's x86/cache a couple of weeks before this merge window opened.
> 
> We can definitely consider asking x86 maintainers to pick up these four patches
> when they start taking patches for v6.18, at which time one or both of these
> contributions may be ready anyway. Will know better at that time.
> 

Ok. Sounds good.

Thanks
Babu
