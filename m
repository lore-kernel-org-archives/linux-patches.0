Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9590D26D4CD
	for <patches@lists.linux.dev>; Fri, 27 Jun 2025 21:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751059345; cv=fail; b=H0CKIGsmUMbytxFnmdsx90KuXz6HYQzwqGNu87JEI28Ves7j0vXD3Iwpx/CeZ6/J3eACc2cPMKED2nIsalYKxZyn80BikBsc8PhfbJnBOlthObiOedYcij47Kjusy/dkXmIrxvdYJB8WHdyNIDyKXdphEW9NbbqYPFH40vvvr34=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751059345; c=relaxed/simple;
	bh=pKGmdvMDp6CMpGGxagHPbis9/kGnx/pCP+FeLE1kLFA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AE6M7h3R2XrdRoWbkpW1IEtg9iDJ1tANPXAnXr9OGNPNo3vF1HgEZUeQ9QmpoYha8EQMfvRWnklc4uCWiGU9JL/ynDX5BDZ6V2lWEphNHxmv3fz19mvHiAAsy744ioAxacebakliwrQHVD30XfUzcNecbQBEl51/BO3F2k7kbWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tRaTr/XV; arc=fail smtp.client-ip=40.107.244.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tRaTr/XV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DfzzEfc6gtcxeN9LhARxhhti59gj/i9uucuiG2bj4P0/rR4IWhS50nHHgCQeLwjF4Uxb7Yp7t8phbFfBAdihfNgu6g2SqjhnG8twm3zqcu2Q3RGDKyBacmIUABc9sVMtu6rQ+caStwkLl94sjOnPtz8OVCMwnH+9nWqgm+DN/qgQ7Mq1O6HTMvyl8pKkFchj2JmjVIUuITbwOzy5dPkWLo9if8+Cxc3HVK3o3KNvCyKhBdSOgyWpQ9np5Q1wkp9Gl4xXrtvAnVBSAcm5G6gF7I76E1Iz6y5jiV134LmYHUq/e8IOzmJCcGNPUSNP04NcmTlsMhEaGYB5M+0wkM+cSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sMyuuyqQtY7ztctiqhSJAzZp3GvOHSAwlh56Hjqcu/Y=;
 b=aU55HH4yyU9wIeEwDw25wIKpyzTgIZbMIyFMM49SHDfhpAQiAj5qyHRffyQRRtzf/03u1bgV2VuyDmX3i94e9eR2v94QJY8R2uJb9/hOdKPaw26742fuKWkpEouiX3gIRKm+riRJrKyCN+1RfZFqb3iBOFclmzuE4wSdAjSJssCAMUxKBdtyXkyOao7TXq5ZJ9wf1lUo7gonkCIEcYUKBQZ/mP/CmFiP+NUBo5kobC1f3BoFUjIhZ2v8JSLUvIB92bsg5sDNdvEb/GuiKlyTnfJLiPyygwenOSYzgWXP/qtweDaSXhHJ9nbdbLY9x2vmUxyNTH79HvWXc40Cof3F4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sMyuuyqQtY7ztctiqhSJAzZp3GvOHSAwlh56Hjqcu/Y=;
 b=tRaTr/XVQ4mX4Cje/u4vNtwuLz7wDCw2TmxA5mpv7bjgJ/sRwByAOfnha9MD8aVp0dbk6lmHo1A42l5l/yfunWuzEQ8aAzRZAMBv/0D8XFXUkNmk4qaaT3fPx45MNkNYlfT7hhRD61TI96VU+lrcIVLMxEvlW3JEsDreM6eVMR0HIysS8QOlYAICBc+jIE8iNUy9Ymbl5+NUIevrvZO7E0HIl64dMbQE9ve4TcBKayRUuLkMUp/NbfxOFet1joUznfB6XCd36AhvucldvVmGGBJmKb4pBLMcAoEKxF0dm3zZQj2QmdzKfvXbn2m4OtbjOWma/sxZERGLdqsf5JKQnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2667.namprd12.prod.outlook.com (2603:10b6:5:42::28) by
 DM4PR12MB6375.namprd12.prod.outlook.com (2603:10b6:8:a2::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.28; Fri, 27 Jun 2025 21:22:20 +0000
Received: from DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2]) by DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2%6]) with mapi id 15.20.8835.027; Fri, 27 Jun 2025
 21:22:20 +0000
Message-ID: <a14b2ed0-c319-43df-85f1-f97ecd6b688b@nvidia.com>
Date: Fri, 27 Jun 2025 14:22:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/30] x86,fs/resctrl: Support binary fixed point event
 counters
To: Tony Luck <tony.luck@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>,
 Dave Martin <Dave.Martin@arm.com>,
 Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
 Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-15-tony.luck@intel.com>
Content-Language: en-US
From: Fenghua Yu <fenghuay@nvidia.com>
In-Reply-To: <20250626164941.106341-15-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0107.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::48) To DM6PR12MB2667.namprd12.prod.outlook.com
 (2603:10b6:5:42::28)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2667:EE_|DM4PR12MB6375:EE_
X-MS-Office365-Filtering-Correlation-Id: a1025a23-2fbf-412f-4f76-08ddb5c0b31f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?azNYNlpMcmtTaU9sQW1TV0JMWVpFYXZNdlo4bE5JL1d5R2poVnY1OUhhVlBH?=
 =?utf-8?B?TG0weVlIM3dEU2prTlF0Tjd5MnNRSmZQSGIzOVFmbnd3U3R3Y3BQczc5eVhy?=
 =?utf-8?B?cHk0OWxmQ0ZmSnhCWXd2TFc5bG4rY1JVb1d0ZllSNFozTjd0RjRyazZKU05O?=
 =?utf-8?B?enExeFFPUkhWL2xuSDhMT1E4K2NHV08ya3BMY3pwWURQWWl2TkliNkhFWlVQ?=
 =?utf-8?B?NndxY0Q5bFIyVWRZYWFTdm5XYWpqTTJJSW50eG9tZUpHbU9VdVcwUmtpQ1l0?=
 =?utf-8?B?VnhxNCtrRVV6c0VWVUdvb2JhVEF3TkVtQ2piaityZ3FRUlNHNERTR3d0TFQ2?=
 =?utf-8?B?SjkvMUltVGtuMExvWW9LYUt1SkluZnozT2tNQkYzZ3dtR1ZkUlYzQ2txYnFS?=
 =?utf-8?B?RU94VlN5REwyNWQzMGFBWkxyeHpsYlpUZjU5bEFkVXlWRUdRUVI2T0M4bG1N?=
 =?utf-8?B?WjVnZ1IrakJieTFCUjZBMUJxZjRuKzJ1TW5BRkk3akhxc0tvb0NvS2swcmlZ?=
 =?utf-8?B?dGdCb0dCSDVHMzlwTTAvczBZQlFEYlZPTGJDSVNNNEdKWGozbnV1a2VhTjVV?=
 =?utf-8?B?bmlOSncwOWNSdlk4SzMrS21XbExITmYwTno3OTlrLzdjYzN2Vmk3M05hSEsz?=
 =?utf-8?B?TDVJQ3BDMm5rMG1XMURtL205U3VUa0JESFJqL1M1ekZTVnc1NTRaQnJ6N3ZQ?=
 =?utf-8?B?QUgrd3dOeXg4SC85YjJvWCtUTGg0YVFZbXVkM0lOemVRS0IremVqYzVCdFla?=
 =?utf-8?B?bE81dExEYWtYNXFFOXNzanJzbXFIYmEvUHFFTXAxenBrZDlLRm1ZNWtrbzdi?=
 =?utf-8?B?Q2haUjNDanorbTJmMFJxL0IxTlVUMG9WQk9ZWlMxeWhFZHNZa0J1UlJRb3VE?=
 =?utf-8?B?Rm45dm4xdzRkMmx6WC9XdlZmYWFySEFUNTY1cEVZRXNHT0ptbFJuRTR2cG43?=
 =?utf-8?B?Y0xXbmw2bmxrWFE3Y3lTc09xTXZOS3hnUnVLbWZsR3JpanVtUlZyaHRqUHlY?=
 =?utf-8?B?N25HTzhFbkJyRm0xOVA2SUFkRFV1M2pLUnVYSUl3dmJ6dWVTLzNkdEJWd0s1?=
 =?utf-8?B?L1docEk3eXp3Yk1sM1pKUXV3V1M3dXlBeERyZGFhRWFodlBIeGl6ZXQydlow?=
 =?utf-8?B?Z3VQSExzSWRUR1R1VUFISjRTaVNyc1g1ZHI1UFNYaDRJcFR4VXczanlrNW4x?=
 =?utf-8?B?QVlpUitKOUg0RVA1SXRXYmVOZDVBNE1VZTVnZzExSUp5blRVOFc5ZUU4UndW?=
 =?utf-8?B?QzZRK0srNk9kYU9pM3lMcnlLdUVhZGhCeEM2MDBOS3ZqcnFhc0d4R0pENU1F?=
 =?utf-8?B?VXdSRk9EOGh2ZWRUUjV2OFNZMFltazBMSzVkUlhKOVBTaVh2a1YrTTJlSVgy?=
 =?utf-8?B?UVhsVnJrNkMyYVVxMExSZFpJdEpvdkJ5SmF1ZjBXVjJ1OTBOWmVNMzdoRmtO?=
 =?utf-8?B?VWd5UHNZcFFpTkNZZGNqWExPNjI3NGNDNWlXQXVSUjJqRzlJb1NyRkhmVFo5?=
 =?utf-8?B?RS9sWHZoM29zdXlHRFRvbGwwcHNCQjBoKzI2ZHdnaFNWU3ZqS0xDZHJJQmZQ?=
 =?utf-8?B?ZTRLZVRmQlRzSUIya2N2Q2Z1ZnNyR2srUjNhM2lsZDBoZy94RG9ZVWlqVzRF?=
 =?utf-8?B?SVVIRnBRR2c4NlhRMkEzM2lQSWpoTEgvcXI3VXFRU0lsdkltd0tDUFhiQi9i?=
 =?utf-8?B?R2trd0xsc28zeHFaZllsOWJzUFBVazhxbldxLzkzSGNYWlVnaTF1WTE5Q0Fp?=
 =?utf-8?B?dnIydDNIbDYzQ1RmT2crUFR6Vms4WUYxTE9QRHRPREp4amdWdW5aVVgyUVFq?=
 =?utf-8?B?dG0zT0V1Y3k4aWtHcXdrdFpxWTBiMDlLK2FucTNpelFzL0xoa1FnUWx6OS90?=
 =?utf-8?B?Slc5c0dOTmJsbDNhbTJpazJ3dVpFLzFjd0dWK1dNWU1ERHNINlVkY2xmVDRS?=
 =?utf-8?B?NWtGMWlvUWk5cWpmejhnSmlBOThzUWowSC9oRWxkWDNMcmdVa2ZFcS9COFlJ?=
 =?utf-8?B?MThhTW5oMllBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?STNnUWVsaE1hM1NsNXV6bWpMc0VxVEp5QWtlTSttdTFpSkNYdm5rTEZDNjZX?=
 =?utf-8?B?MGNodmxsTStIMEIvMHk1SE9lek1HWmZlV3FaR28wSnlKU0JZWmV4T0UzRll1?=
 =?utf-8?B?RVQ3Q1FnUUtDZTBSYnd4Z1hTTmpneXd2LzhsOG10bjhRNWkxd1ZqWVdDTk5Q?=
 =?utf-8?B?cnpYUS95R3Ewdzl6dlJ6RUpCTWM4VVpuWXc3a3A2amNWd0w1NDJnQlJ1WlNL?=
 =?utf-8?B?M2VuUjZrVXRNb2R1bXRiQlNUa2ROSUtibFFmSFJaM280ZlVlT1FHMUVrSmdr?=
 =?utf-8?B?d0JSVjhmcW9wVlc3VCtTUCtSNXIxcndURW1tNUtKRjJJTC9WS1pxcXBWNlM2?=
 =?utf-8?B?bmhIZ2V4YVVtcDFlVXRNNTBwVlJ6OEdWZE5CWUsrejI5c2NDZXdPYTd0RDFo?=
 =?utf-8?B?MElQNTUyQ2lhY0hNaE8xY2t2MUs4ZXpKaWxYUW1WQXpya3I2Y29RN09xKzFW?=
 =?utf-8?B?L29TN1NjaWRQOEk5aHlsUXBvL3NwY3BTTWJzR1Q4Y3EzYUE2b3VsTUtJR3dZ?=
 =?utf-8?B?NHdiMUNiVTYyU2s3NmozSy9adlpTd1FkZXo0cmEvUUV2L3dmVlVhM1kzaVdI?=
 =?utf-8?B?RmhOZko0cmVDSGtjYVN2UXdVVjBMZk1MVXVsZmhIVmlPa2NGaWdjTXlBUkdI?=
 =?utf-8?B?R04yZGhNTDVPVWx3c3JWK0lieS9INGtVZ3BOMnNZVlVWRlRKUFJBcCtEUEcr?=
 =?utf-8?B?a3BOQlVtV3g3QjAxbnRjV2lvS1pZaG5GQ1dPbDhKMWpDcDI0YUlMc1psZDZX?=
 =?utf-8?B?bGVCdkdQUlNvV280T3JNdGRvdGtObDhRMUcrN1cya0RBVkxkM09kZi9XUGdM?=
 =?utf-8?B?ZkY1aEplWjFLcCsxR24yMkIwcEJPZFpCM1hjSjBSaStlWHhzd21Hcis1SWE2?=
 =?utf-8?B?N3BlVXJEQ0EvZ1RCb1pRR08rVE11Kzd2UVRuUEUyRGllUVhPY1RMVmh0dksr?=
 =?utf-8?B?Zjg3WlUyV21Ha3R0a0RzaUpyczR6MmhDdUtLNjhkMGNQenlGL1RNWlNQZ25H?=
 =?utf-8?B?UlVJd3Y0a2g4ZEM4aEdDNU95eEhTRUhNWWJkZUZyVFI5U1BFZFZLNVNkZVZT?=
 =?utf-8?B?VlFibXUva29HcTlGVmZIcFdORVJRWnM1ODE5RnVjbXE1U3lqcG9RaC9PYlpt?=
 =?utf-8?B?MXkvdm0rQi9NMmlzcFBRVzVoWnIyekdzUmY1dTB2dUNwUzhxRzJpd3FxeG9X?=
 =?utf-8?B?dG9rWGtsTUlXRGU1eXV5MjVaMmpObyszY0wxMkx4bFhacVRabEkzNWtpcTAv?=
 =?utf-8?B?d2JvRjd1RzBSdnUyZHFiNENqQTdCM0t4Zzgzbm51aTJmRlBkbHQ4cXVkTHh4?=
 =?utf-8?B?SzgwWFl1Y05OYURNY3RVamhLT0tadFZpeWFya2Y4ZmdRYnhjS21hQ3hmcTNz?=
 =?utf-8?B?V21NbEVDOFhoT0hBSm05SUtzZmwzbEp6TGV1WU55YmJpSFc1ZkEwanB2bktD?=
 =?utf-8?B?MEZnYVFCYVhQdC84T1U4MndiNG9iZjE1TzJPK2EvUkFzNU0wSkYzVjQraE8w?=
 =?utf-8?B?R1JyUUVwcy84dW56TFh4dzFSbk54VVhvMXp1NVRZaHQ1Nk4wOHNoZkZXNHFG?=
 =?utf-8?B?STA5WGlsa2o0YXNSOXZuUVM3a0h4QVBuMkwxdEpTTHZZWjA0RkNEYmVwUlZp?=
 =?utf-8?B?M2J6SFlDNnE1cDRtcDhRKzFmblhOcUZva25Bb04yWkpBM2RTY0pjT2NOMk1H?=
 =?utf-8?B?V0NMRkIzR25VQ0FhV01WYWR6Z2N2REN4eXNobzF3NnNUMkxoQmJQVlFFRjkr?=
 =?utf-8?B?MlJIZm5vNTgrYTAzc3BWSFd5NzZjcmlFR3NIaElFNmw2bE8wMW5ScEpubGNz?=
 =?utf-8?B?cVVKTWVrSmI3aksvOTdNZzh0UVZ5YlZYUS8rc281NXovWHVVUkltd2lQd1A0?=
 =?utf-8?B?cjhmMDdOVk9rbDJ4UGFIYlovZk5XYWtQaHBDTFhxWFdRSm8yNUhuVnZ1eHV3?=
 =?utf-8?B?NVd6RW9TRWIxNnBLbjVwQ3dtb1JsYmYzUjVHbGVUOXJBeUsxemNTNjlCQ2dS?=
 =?utf-8?B?dmVRa2VWbWVIaGtoaG5MeGRkR29uM2hDTXRrbTRjbmN4bWpnbUQvajhiTTBB?=
 =?utf-8?B?L3hVL2orOWNsK0dPMEhMZy95WFdDdFZIeWhqeWxMUzU1TmFXOFNyTitaMWxI?=
 =?utf-8?Q?wQk3dMoC9bXvHtEEqouPNKncI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1025a23-2fbf-412f-4f76-08ddb5c0b31f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 21:22:20.2254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: be1apZgIfbnEZjXdkyR12Ss7HPvtdAnpAIu5kKRMMEw2tQoUjc0FrNjDotov4F9/cePGdgf2O5TilJmIhqcqNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6375

Hi, Tony,

On 6/26/25 09:49, Tony Luck wrote:
> Resctrl was written with the assumption that all monitor events can be
> displayed as unsigned decimal integers.
>
> Hardware architecture counters may provide some telemetry events with
> greater precision where the event is not a simple count, but is a
> measurement of some sort (e.g. Joules for energy consumed).
>
> Add a new argument to resctrl_enable_mon_event() for architecture code
> to inform the file system that the value for a counter is a fixed-point
> value with a specific number of binary places.  The file system will
> only allow architecture to use floating point format on events that it
> marked with mon_evt::is_floating_point.

User app needs to know if a number is a floating pointer value or an 
integer value. I see you document the energy and activity events as 
floating point values and all others are integer values.

Is it better to show the value types in info directory?

e.g. create an info file "events_floating" which shows all events with 
floating point values. Events not in this info are integer by default.

This may have two benefits:

1. An app can query the type info to parse the values accordingly 
without hard coding event types.

2. Any future floating point events can be added here without changing 
the document.

> Fixed point values are displayed with values rounded to an appropriate
> number of decimal places for the precision of the number of binary places
> provided. In general one extra decimal place is added for every three
> additional binary places. There are some exceptions for low precision
> binary values where exact representation is possible:
>
>    1 binary place is 0.0 or 0.5.			=> 1 decimal place
>    2 binary places is 0.0. 0.25, 0.5, 0.75	=> 2 decimal places
>    3 binary places is 0.0, 0.125, etc.		=> 3 decimal places
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   include/linux/resctrl.h            |  4 +-
>   fs/resctrl/internal.h              |  4 ++
>   arch/x86/kernel/cpu/resctrl/core.c |  6 +-
>   fs/resctrl/ctrlmondata.c           | 91 +++++++++++++++++++++++++++++-
>   fs/resctrl/monitor.c               | 10 +++-
>   5 files changed, 108 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index e05a1abb25d4..1060a54cc9fa 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -379,7 +379,9 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
>   u32 resctrl_arch_system_num_rmid_idx(void);
>   int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
>   
> -void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu);
> +#define MAX_BINARY_BITS	27
> +
> +void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, u32 binary_bits);
>   
>   bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
>   
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index f51d10d6a510..4dc678af005c 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -58,6 +58,8 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
>    * @name:		name of the event
>    * @configurable:	true if the event is configurable
>    * @any_cpu:		true if the event can be read from any CPU
> + * @is_floating_point:	event values may be displayed in floating point format
> + * @binary_bits:	number of fixed-point binary bits from architecture
>    * @enabled:		true if the event is enabled
>    */
>   struct mon_evt {
> @@ -66,6 +68,8 @@ struct mon_evt {
>   	char			*name;
>   	bool			configurable;
>   	bool			any_cpu;
> +	bool			is_floating_point;
> +	int			binary_bits;
>   	bool			enabled;
>   };
>   
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index b83861ab504f..2b6c6b61707d 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -887,15 +887,15 @@ static __init bool get_rdt_mon_resources(void)
>   	bool ret = false;
>   
>   	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
> -		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false);
> +		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0);
>   		ret = true;
>   	}
>   	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
> -		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false);
> +		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0);
>   		ret = true;
>   	}
>   	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
> -		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false);
> +		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0);
>   		ret = true;
>   	}
>   
> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index 2e65fddc3408..29de0e380ccc 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -590,6 +590,93 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>   	resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
>   }
>   
> +/**
> + * struct fixed_params - parameters to decode a binary fixed point value
> + * @decplaces:	Number of decimal places for this number of binary places.
> + * @pow10:	Multiplier (10 ^ decimal places).
> + */
> +struct fixed_params {
> +	int	decplaces;
> +	int	pow10;
> +};
> +
> +static struct fixed_params fixed_params[MAX_BINARY_BITS + 1] = {
> +	[1]  = { .decplaces = 1, .pow10 = 10 },
> +	[2]  = { .decplaces = 2, .pow10 = 100 },
> +	[3]  = { .decplaces = 3, .pow10 = 1000 },
> +	[4]  = { .decplaces = 3, .pow10 = 1000 },
> +	[5]  = { .decplaces = 3, .pow10 = 1000 },
> +	[6]  = { .decplaces = 3, .pow10 = 1000 },
> +	[7]  = { .decplaces = 3, .pow10 = 1000 },
> +	[8]  = { .decplaces = 3, .pow10 = 1000 },
> +	[9]  = { .decplaces = 3, .pow10 = 1000 },
> +	[10] = { .decplaces = 4, .pow10 = 10000 },
> +	[11] = { .decplaces = 4, .pow10 = 10000 },
> +	[12] = { .decplaces = 4, .pow10 = 10000 },
> +	[13] = { .decplaces = 5, .pow10 = 100000 },
> +	[14] = { .decplaces = 5, .pow10 = 100000 },
> +	[15] = { .decplaces = 5, .pow10 = 100000 },
> +	[16] = { .decplaces = 6, .pow10 = 1000000 },
> +	[17] = { .decplaces = 6, .pow10 = 1000000 },
> +	[18] = { .decplaces = 6, .pow10 = 1000000 },
> +	[19] = { .decplaces = 7, .pow10 = 10000000 },
> +	[20] = { .decplaces = 7, .pow10 = 10000000 },
> +	[21] = { .decplaces = 7, .pow10 = 10000000 },
> +	[22] = { .decplaces = 8, .pow10 = 100000000 },
> +	[23] = { .decplaces = 8, .pow10 = 100000000 },
> +	[24] = { .decplaces = 8, .pow10 = 100000000 },
> +	[25] = { .decplaces = 9, .pow10 = 1000000000 },
> +	[26] = { .decplaces = 9, .pow10 = 1000000000 },
> +	[27] = { .decplaces = 9, .pow10 = 1000000000 }
> +};
> +
> +static void print_event_value(struct seq_file *m, int binary_bits, u64 val)
> +{
> +	struct fixed_params *fp = &fixed_params[binary_bits];

Is it worth to have a boundary check here like? I'm afraid without the 
hardening check, a future caller may give a wrong value and cause hard 
debugged failure.

if (WARN_ON_ONCE(binary_bits >=MAX_BINARY_BITS))

     return;

> +	unsigned long long frac;
> +	char buf[10];
> +
> +	/* Mask off the integer part of the fixed-point value. */
> +	frac = val & GENMASK_ULL(binary_bits, 0);
> +
> +	/*
> +	 * Multiply by 10^{desired decimal places}. The
> +	 * integer part of the fixed point value is now
> +	 * almost what is needed.
> +	 */
> +	frac *= fp->pow10;
> +
> +	/*
> +	 * Round to nearest by adding a value that
> +	 * would be a "1" in the binary_bit + 1 place.
> +	 * Integer part of fixed point value is now
> +	 * the needed value.
> +	 */
> +	frac += 1 << (binary_bits - 1);
> +
> +	/*
> +	 * Extract the integer part of the value. This
> +	 * is the decimal representation of the original
> +	 * fixed-point fractional value.
> +	 */
> +	frac >>= binary_bits;
> +
> +	/*
> +	 * "frac" is now in the range [0 .. fp->pow10).
> +	 * I.e. string representation will fit into
> +	 * fp->decplaces.
> +	 */
> +	sprintf(buf, "%0*llu", fp->decplaces, frac);
> +
> +	/* Trim trailing zeroes */
> +	for (int i = fp->decplaces - 1; i > 0; i--) {
> +		if (buf[i] != '0')
> +			break;
> +		buf[i] = '\0';
> +	}
> +	seq_printf(m, "%llu.%s\n", val >> binary_bits, buf);
> +}
> +
>   int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>   {
>   	struct kernfs_open_file *of = m->private;
> @@ -666,8 +753,10 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>   		seq_puts(m, "Error\n");
>   	else if (rr.err == -EINVAL)
>   		seq_puts(m, "Unavailable\n");
> -	else
> +	else if (evt->binary_bits == 0)
>   		seq_printf(m, "%llu\n", rr.val);
> +	else
> +		print_event_value(m, evt->binary_bits, rr.val);
>   
>   out:
>   	rdtgroup_kn_unlock(of->kn);
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index aec26457d82c..076c0cc6e53a 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -897,16 +897,22 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
>   	},
>   };
>   
> -void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu)
> +void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, u32 binary_bits)
>   {
> -	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
> +	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS) ||
> +			 binary_bits > MAX_BINARY_BITS)
>   		return;
>   	if (mon_event_all[eventid].enabled) {
>   		pr_warn("Duplicate enable for event %d\n", eventid);
>   		return;
>   	}
> +	if (binary_bits && !mon_event_all[eventid].is_floating_point) {
> +		pr_warn("Event %d may not be floating point\n", eventid);
> +		return;
> +	}
>   
>   	mon_event_all[eventid].any_cpu = any_cpu;
> +	mon_event_all[eventid].binary_bits = binary_bits;
>   	mon_event_all[eventid].enabled = true;
>   }
>   

Thanks.

-Fenghua

