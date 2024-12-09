Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9276513B58B
	for <patches@lists.linux.dev>; Mon,  9 Dec 2024 19:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733771733; cv=fail; b=pzImca2e4hxj0aYHpnk7oX9gA7pt8r+oX8/aXd2ATdCjpvQJiBKhVpue24GeLn6fa6RAps2gj6+98OfQcFf3wFBvV/dEwv1RICzIhN988nY2d/jalz9Jwld5PNsmzKpFEQVpWthjlBCUYQS1pYsBjtu7O/D1/mFDinHeU3b8fVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733771733; c=relaxed/simple;
	bh=baWxTfk0lrO2wQNBPScU8RAR6sMxPjDJvt8Rp04/9R4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HaL8RXcpjC81NvrMBaakC0abrUzJz/pix9moVxAkUY6F7SJYqsLfJ+HOkZZzZFo4AE3OJ16ecri5kgakF0ZBKF7d9wxH2qxbswG1pet7+u5GacRFtpCnC8h825FgWOB9SpOpZe4rOOLoHjf1cdvxM8UHXZsnNC1Nmg3SuQPktEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IJwlkrrv; arc=fail smtp.client-ip=40.107.244.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IJwlkrrv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ME6UXzOF3O5zlsxUz6VIkOwxRI0gD6AUhf165baXRAKUth03r/fqE6sxZPLLOqH67/HYNwlKVmO4QN988LfNfmcNOPFKWEYQO9GyVcIBgWROjdVmhgPl4VGP1gKV/p0xO8Sv6npr6ocJwwwiCfigObSnEVjnPXaDEhDoJ7PzMs6FIXSiWnWa3GO68cFObuzMRX4SY/4uxrjOMSTGA8d/BeRQ+DVNn+ufL5c/vNKrSHky4rlJc1F00k+u5lSfDivI5JLw8ORe9BPTAm+Np1SEzfLxW9geSTqd4zNk9IMI947BXc2SpaJ8xMNhZzwh8IZaSwwQ8e9W8cX4xDm7tBjEDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ltJ0veDk9YXIo5pvfl+DqgYeKeUO3CzUXbAwuUUUqlM=;
 b=f4I7IvVV8RN4vXNNW3O7Nk2dTVvNJlxgUDN++G++66WDbcUOSNuOBBHIEpuc0jI5MzvV2fXb2L12mvtusr7sw/b64RQedUcuINm+q6Xs9D/zdkAwP9PF4AwB9VMdFCTNj8nf/AbH1Zx+wtG4RkBdvCwTG+vr559dNy2sSzQi1B/FyfKiLCYOOlPpFFxAsGgH0tSwuXdLjQ+MwsqSjEnjn2UCb9S7rA4Uc8AW/mqpHN/2EeX0pvS8gF3eDqA0fVHNPw0TKZ1+pHSTl7w4sI6WEU09jdtuhtFqnbkSUzIsanwBqFd5xo7FusdphMhBEJRXAqxIvy1uTO2uLqRPTJZCsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ltJ0veDk9YXIo5pvfl+DqgYeKeUO3CzUXbAwuUUUqlM=;
 b=IJwlkrrv2XHGmlJ5mSjgXIhLTXIR2TUKNfBxBc/a99t0eVZvT2YCU8OWQT+C79wNEOS/6WTwR93+T03Mc97mhEk+9Ni632uaMjwkZ9tmKXdegmcwiH2/Mt3hIxz3WE6O40g0DZMjMIxejuzTTFnzlI8A3lJgsVq6xPpjuFURwjM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by CY8PR12MB7290.namprd12.prod.outlook.com (2603:10b6:930:55::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Mon, 9 Dec
 2024 19:15:28 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%5]) with mapi id 15.20.8230.016; Mon, 9 Dec 2024
 19:15:28 +0000
Message-ID: <c5f5b3ff-27ac-41c1-ac5a-858eb82d607d@amd.com>
Date: Mon, 9 Dec 2024 13:15:25 -0600
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v11 0/8] x86/resctrl: mba_MBps enhancement
To: Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Yu, Fenghua" <fenghua.yu@intel.com>, Peter Newman <peternewman@google.com>,
 Jonathan Corbet <corbet@lwn.net>, "x86@kernel.org" <x86@kernel.org>,
 James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
 Randy Dunlap <rdunlap@infradead.org>,
 "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20241206163148.83828-1-tony.luck@intel.com>
 <7e7c01c5-f64f-42c3-9364-ddcfd01b25c1@intel.com>
 <20241209172859.GHZ1co28T-rRiQtIMp@fat_crate.local>
 <SJ1PR11MB60834A5C5D99F3BE9F2CF0DDFC3C2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <20241209175739.GIZ1cvkycetfLpEsgE@fat_crate.local>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <20241209175739.GIZ1cvkycetfLpEsgE@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR18CA0011.namprd18.prod.outlook.com
 (2603:10b6:806:f3::19) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|CY8PR12MB7290:EE_
X-MS-Office365-Filtering-Correlation-Id: 73c6fb7b-5e71-4fa8-fde9-08dd1885d79b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UThOQXNFSTN1K2RuK0RXYjliTUVlVlRvejhMbGVuUDJxZVVTY1FMYWN2ZDdS?=
 =?utf-8?B?aVBzMjJDVnVlemhhRmdwSEh2RWNac1dWSmcxb2MzVU01TEhsWnB4RWxXcjdJ?=
 =?utf-8?B?U0Z0S1ZOV1h4QTVYTVhtNDdNS3F2MTVaOGNPUkl1T1JudkhsRDJyMldpREV4?=
 =?utf-8?B?TE9oSENjbkpubzFqTlBkT2Y0cTN3ZTVieHZ2S0hOTGEyaGs2Q0kxTjNRc2hJ?=
 =?utf-8?B?S2dHbDFFZXJSWE5CYmc5KzRHSmhqR0NOeTFTUVNYZWFjQk1qY3ZVSi8wbUEz?=
 =?utf-8?B?bHV1ZkZEU2VDejQ5bjBUNkNFOU9MNnNWMjlkQWdmdUpadU1GQWtLaEFTcE5O?=
 =?utf-8?B?YmFNY1EyR0pWOVBYbmIwcWdmL1FzV1k3bm9UNHVXVHNpMm8yYXFIbXBDRlRu?=
 =?utf-8?B?T1lMaGNaTXlrVE10TTFzbDltWGJvTVpyWHh2eWJRaFdEVFk3VFhBUHFkRTZH?=
 =?utf-8?B?U1NJc1pxNXBOWG5DNG9RMFFrT1E0SmdOYkhBY0xkSjcrNmpBVUpHY25VS1E2?=
 =?utf-8?B?ZUZVbWxzTldkWHVWZjd0VS8reUwxU21NNHdQSEJZcDcxaGZ6QWxkaU9PY09T?=
 =?utf-8?B?NjdseTU4V3h6eDl2M3U3SEV2Skt5eEx6cDM2bnRpQktIL3hTY2hwMENoaXNo?=
 =?utf-8?B?QzJwVXA2Q0VjZzB0azg4TVVhOEtMaFpJSWZqYzF6L3pValNETkZ4VjVXVVBm?=
 =?utf-8?B?VTY0c3ArZGNCWEVMVTdESUh4cXBDbWRIa3IzcllYTXEwd3B1NW1xZUdTakJO?=
 =?utf-8?B?dVg2ZUF5a0hIWUVOMVViK203RlRjSDZ0RHBaR0NRUUJBcjNYc1BuYVRLTmhw?=
 =?utf-8?B?d1crcS9uQStMMmlDOVlqVmUyZ1J0SldNTmNTY2RoSmpNNXh4VEtONEdZZ0sw?=
 =?utf-8?B?VFhGVURVclZacm40QjRyOThKQ01KcUlwMVFvKzEwUEFzbHgwMGVhTmlETm5H?=
 =?utf-8?B?V0hDVWUrb0VaOTJWTkJvYytEMGN4U1FsTEdCdUh0Z0txTWNXN0MzYmJzTlRB?=
 =?utf-8?B?OUNtdmtyd0NWQ2JnT2dqZm9tV0FwV0tiZFFjK2RveWxIalJiZmNWZFdSSnNm?=
 =?utf-8?B?aWphQkpnSXBSOUNrUkNoV0Z4ejNFWDVSZXp3Zi9rb0kyNmxDS29rL1RQSFcx?=
 =?utf-8?B?UWhwRzJtekJKbUNXczFkV0JiT2lnNnFkb1ZobDIvUXdOeTZRTU10UzNKSlZ4?=
 =?utf-8?B?bk1HamxXeWtOSGE1SzJMakRtdURGaCt5dkliYzBqbStoOHhGU1dqTXFvN1VH?=
 =?utf-8?B?NjJsWDNxbkJpU2l5WDJ0OEJNa2x5NklCakcrVTUzT2RIMnJYYXk3VEgzODVG?=
 =?utf-8?B?T1VnR3FZalgzZUVrUEt5T29BTWgvZXA5L0trQ2k2cnNvTE95aTRSMTNUckhp?=
 =?utf-8?B?OEdiMWxHZXBZcjV3OXZja050NE4yMVBFVGFUK1JRQUpORFVqUmV2YnRLRk04?=
 =?utf-8?B?R2swVy9rMXZvMGRzdG1PQVBYUXUyM0FUdU1adHpZR2pPaFlYLzBRRGh1b3Nm?=
 =?utf-8?B?ZFpyZzRVdjkzVzJoMERmRnZjOUJlWlZyaVVqdGZFTEdObHBnQTZKTW5sWXN3?=
 =?utf-8?B?UFIwdk1DU0pVeE85NU9HUFZzekVuSndTOVlIMHpxVm9xMDUrQ21RR0VyUXkw?=
 =?utf-8?B?OWk5encra0ZKRkUxY1BXY3lxVW02RE8xRG9kejlOT2xMZ0tJdEY2U09QcGRP?=
 =?utf-8?B?K2w5K3NxMzRDRE1ZeTFOcWpvUGp4OXpsRUY0WWFYMTMrU3hIbFlhdElNcjh0?=
 =?utf-8?B?ckw2VkxBeTRUNmRJSERmT3FDV3N6bVExZXluN1BWQVpNcjV1WjFqdWFVK08y?=
 =?utf-8?B?K2VNVG1qR25HemJRWFdGUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RUVrUThKM0ZUNGd2WXpzbHFrZ0Z2Y3B0TVFDeUhxZjMzY3doYm9aS3Rjek1K?=
 =?utf-8?B?TjdzUHRTdFhjOHNEK1NpSVgrRTN2VFJHekdsSnVmUVAwRGc2K1l4N2tIUjJm?=
 =?utf-8?B?Mm5sMGhKd05kbDNCQXpaOU5haSsxRGdUZzBqNDVrR3paQjJTcEVYSjlWTWxS?=
 =?utf-8?B?ek1qU0pWUjlmWUhJajZWMTFYK1JnRzhPSWhMU1JKMW9zOEZuamkvUHJGZ0xn?=
 =?utf-8?B?aGZUTWJhTTlOSGRFVTZkYzZGR3Nlb3RQK01JQmpNUEV0ZEJlVGxKTStBeHlz?=
 =?utf-8?B?Qnl6amZkT0FvSVRXL0t0YkRzOTl2ZWxvazRhTG5BT2Fkelh3MEV5V1BiZ1VK?=
 =?utf-8?B?bXlKWnFZeTVhU3FQcXpTMGNneHdvajlxaHo1Sy9VdzdWUllHdnd1cFdFZjEw?=
 =?utf-8?B?ZWxQU0xyVGNkWUNJa2JSQlJxdEgwcHI1UDdEWHE2WXh4OTlpNkplQ0loaG1W?=
 =?utf-8?B?SmFrbHR3WS9OWXh2WVZXOGVuSlJ1YVdWNHN5L2V0emJPVHh4Y1hyU0xxVkZ6?=
 =?utf-8?B?NVdvR1JCWmtHTGJoR3NkMTVUNDFCSTVZTmlXbmxHU1E1VkIwbG8wUUlVQVVz?=
 =?utf-8?B?SjhhOXExSUlITVJDVTFISkJiZ2RWclYxakVpbXJYMFh3VmlLNFNKQk0yUmlH?=
 =?utf-8?B?dk5kWG5la082RlBuZjZRdlNNSjVkd2MxczVYdlEyQzZETm5nSEFHTXdDQUlD?=
 =?utf-8?B?Rjg0MlhycWQwTXdiNTIyY2oyTWZpY052VWtlY3RUWnVNdVkreVEyWVdNLzRW?=
 =?utf-8?B?TkN3TG56ZzE2c2VkZytLelBDMCtSSlBLUEU5QStjcEhuZWY0QSt5UVZYWlpT?=
 =?utf-8?B?UDdjSGtVTXlGb3Jha0FJeVdXZ3grTWtYQmZodDFJdEltL29WY01TNXluSExm?=
 =?utf-8?B?NllSTlE4S1hrZGdncFEwMVZtRG9Wa2ZvTGZTdFFtd3hLbmV4YWUzVGJrd2V3?=
 =?utf-8?B?dG8rUWhXdEM1N0IvQ3JWeExuVGdrdnJCaFh2Y2tOKytLOE4zanF0d1RHT0Uz?=
 =?utf-8?B?M2tzSU4wbW9jWU9tZ21kd3RlY1VOTDlBMjdRczlFVmYwV1MramNac0R6UlZz?=
 =?utf-8?B?VFJDZm9IdUxVK1F1NWc3L3c3Tmt3bGF4TXp0bzF2MGd3MjlGVk9rS05menpl?=
 =?utf-8?B?VExYNFFoOVlEMkt3REpTaXRtNEpHRjVtOFhhSlQ4WnIwUEpHTXhCVytETmFU?=
 =?utf-8?B?YlJSNFN2M3VEU1hZcElOeGZCQUN6V0kySmpnbUpXc3A1MDI3RTNrRkNZR0w2?=
 =?utf-8?B?eVFDdEpXaGo4Um5lNUFOMFpJS3VITlVURzJLOTVqbTd0SVJJNlR5bldOcCtO?=
 =?utf-8?B?NHljTjc0SDg0YXRRMmJaTzc1UWwySHI5alN0UVFLYXJyTnh1R2xZRUczNnN0?=
 =?utf-8?B?UHJzRWtTejM2NVBlMjBUc1RkTElITkwxQUZjVFFwdXNNWTF6WjVPOVY1dWRr?=
 =?utf-8?B?YjVBWUNGZkdkbVBBYVBkTWFMR25jWFg5anJ3VmJXeXZRQVhQSWFZanpvbEtR?=
 =?utf-8?B?UEhrb0NGL1lidGR2Q3pySmN1QzVzQkEyNDB0WEZBaFdJNmhLT01PcEZSc1lh?=
 =?utf-8?B?YVlHVEhmeHphUWhJL0ltdXc1eTVVKzgyQ29lTmZDM0dsRms5K3dUQ3ZaUVph?=
 =?utf-8?B?ZzBuOTVVMTNPVlUvNWloemd0UHJmei9wK2JJWThETWMrT2UyV2QwQzFMQ2dE?=
 =?utf-8?B?U2RmSXVFRmNyQmp5UnhXOGMxVUVKQzY1aGtEQ0wrZCt2WEllN090ZisyNlZM?=
 =?utf-8?B?NFlpQlNzVlI2bnRWcVg3OGZuUHFEb1NRMjVjTjZJVi80Qm5rWUI3aXMvY0ZF?=
 =?utf-8?B?eDJaekxSNURiVjhmTTlaZHhQNGI1MHVxZlJUQ3Z3ZlJqQ3A1UjUzQUp2NlBl?=
 =?utf-8?B?R3l0WXJkUXdQYStCbGNhNWFWMVdzZm5zU05vMmNCdm5lN1pDWHFhZk9McUNS?=
 =?utf-8?B?MUdGZXAwckpYTkloMW8venZKSWJkcXJYT2JXK3RtYXVQbCtiWS8ybjJoNGVp?=
 =?utf-8?B?ZzlGcW5mc2FISHZkRnV0UXo5dkxaRjJNeW1qUFg2d3o0K2swcnQrZGNEWGZC?=
 =?utf-8?B?MkE3b0liVkYra2gxQjk1bnNNbHNtNENHa0F4ZzZiSDNRb213eU16RnkyQldi?=
 =?utf-8?Q?Hnxs=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73c6fb7b-5e71-4fa8-fde9-08dd1885d79b
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 19:15:28.5216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u0BhFb3x1FmjB3sx1aT2sF7xL7YyZYGxve9De8dqBlIzApV5MmPGTommjjfMP2U+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7290



On 12/9/24 11:57, Borislav Petkov wrote:
> On Mon, Dec 09, 2024 at 05:53:12PM +0000, Luck, Tony wrote:
>> v6.13-rc1 may give a lockdep splat when mounting /sys/fs/resctrl
>> (known CONFIG options to trigger this are:
>>
>> 	PROVE_LOCKING && SELINUX && (EXT4 || BTRFS)
>>
>> but there may be others).
>>
>> These resctrl patches are not directly dependent on the fixes that
>> went into -rc2:
>>
>>    22465bbac53c blk-mq: move cpuhp callback registering out of q->sysfs_lock
>>    4bf485a7db5d blk-mq: register cpuhp callback after hctx is added to xarray table
>>
>> they work ok on top of -rc1  (as long as you ignore the lockdep splat).
> 
> Thanks for the details.
> 
>> I see you already have one patch in TIP x86/cache on top of v6.13-rc1
>>
>> Your choice whether to rebase that to -rc2 and then apply my series. It
>> might make testing smoother.
> 
> Yah, I can rebase. Not worth the hassle of dealing with bogus reports.
> 

Sanity tested on AMD system. Changes look good.

Tested-by: Babu Moger <babu.moger@amd.com>

-- 
Thanks
Babu Moger
