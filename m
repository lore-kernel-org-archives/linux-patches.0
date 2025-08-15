Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2041.outbound.protection.outlook.com [40.107.96.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E7B227B9F
	for <patches@lists.linux.dev>; Fri, 15 Aug 2025 16:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755274847; cv=fail; b=O7rCONIvMLecNDL3XWRVxoAl28dVu+lYRqGfitOjRBO2ZSbyC7KkNGLFnQQ1x10Gm+g0Vd9WSFSM4/B/TQacCyEr1eO1V2uQTx/BqrdZU5sk2CBcP1QP16b0JQOYSNQl+/5e6Rbul01SzlOTzxTQHJRdmPf9x4v5fu/eu32dTP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755274847; c=relaxed/simple;
	bh=kL/1NpJrPIB0gYkJUYgJUqzxqc3GSUnumjOyevD+Y7A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GaopJ5TGTnCVSckzlQ5bZPMdTkM/TbbJoM2Mz1o4Mme6z0J1pzJoO9R0r9pZMSPSowFIZ2SxzgVstKUTeR3+Pz6vZh6HRez9R8vCWEnc+Fubp+3ntTcXN00wFvcX5U09XaKf7nd0HRDO+z7ao/Mp9pIBFr6hvnO/uMtt134PVPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K9Hb5axM; arc=fail smtp.client-ip=40.107.96.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K9Hb5axM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dX/bpHiaBqHyUCaKcwdLnFsnNcNRWupZ3nYOWg0vS7R4cfdzUpb/rrTvmOml3ng5EG6K2xKz9PJ4nptkgoLWq0M5Gjd0F1o+6UvUND9K/8xyAMu9xQuP/v1n7tvN+aLeICzoPkUtsDLBedcU3MeyL483QxSjy094xIX2wB67wb6rbvJI6kmLju5BKzQfPQ+nAvUYQqLFphBcFUPs3rVzmpmdPoAm41DP4Fxuu2gp7TPB2IH/GcZTIM8XDynjNut3OV05fDsP/KuOOPh/On7DAYwK5r4PM6GBYhAliITL23h3ST8J5DNHEsXraWC43L8TiUzZi55OksRkmX2JrszGww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GoECe2/D9uHfHmi9PHeuSRxP0e0N63vC2pMUPUdOuAM=;
 b=Pkk56TH6w8UpoOYgIMBPwEZOg/yaUju1lH7b4ykuF4TW0F3kMBH6rMiXO7v7SZHllMakqb6NZLmmy/Qo71vIb3GyT7m4kQPc6NulyqT1zI1FA/sQXkGg0VYLBtWezmN+i01Evy8vTYQUgNT69gNmSLBYhhQ1+11GA88MMvS2+zje9ip7Tza+I7/wK2Qc57cKZgIUBhlS4d7DS+0RT0YC2fZ1J0uBwAbzamk6WHhn3V6D6iPPabsNEcB5kcCS9AaJ5Ezks7DImNMdJGw3623d2nqvWyIon25X9MTJ/M49fL2MB2cjSpxkITtd+Qb+qBo8rxT89mX/DnJ+Fq5RLL2keg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GoECe2/D9uHfHmi9PHeuSRxP0e0N63vC2pMUPUdOuAM=;
 b=K9Hb5axMMAjYepDI95bCVg9OzGLJDAzX75TNv/nks/7nii0R8V9eumnADkpJtckHfhOAbVmDahw5SKGs0pPgViU2fnPOK+2tnLIKO4+9B9gxNbaehloZcvfJQGOPBxw2eY+xwh18zdfJd3TMaSoSd4Ui5mVhTXUnvmGM4flSUcxDx3bFRA9y+an/KuowHa59hZJtBou4RkrNmzXnVsxeBhD2hZTwk8F4P75/fsZJKBvDgBm4vBF9Ml6LDXOmoQXOP3LzEAzPN1WBCU3BJqSM+jk5N0soeTag9QX4HzVRaztD/+jtbbknfnwUNoheJERc5gzwx5s7TgfvJF679urWLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by PH7PR12MB5805.namprd12.prod.outlook.com (2603:10b6:510:1d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 16:20:41 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 16:20:41 +0000
Message-ID: <91238bb8-cc10-4816-948e-eb14cf385f89@nvidia.com>
Date: Fri, 15 Aug 2025 17:20:34 +0100
User-Agent: Mozilla Thunderbird
Subject: Re:
To: Greg KH <gregkh@linuxfoundation.org>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
 conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
 linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
 linux@roeck-us.net, lkft-triage@lists.linaro.org, patches@kernelci.org,
 patches@lists.linux.dev, pavel@denx.de, rwarsow@gmx.de, shuah@kernel.org,
 srw@sladewatkins.net, stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
 torvalds@linux-foundation.org
References: <b892ae8b-c784-4e8c-a5aa-006e0a9c9362@rnnvmail205.nvidia.com>
 <20250813172545.310023-1-jonathanh@nvidia.com>
 <2025081451-afloat-raisin-7cee@gregkh>
Content-Language: en-US
From: Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <2025081451-afloat-raisin-7cee@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0210.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::30) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|PH7PR12MB5805:EE_
X-MS-Office365-Filtering-Correlation-Id: fdb92ce3-efa9-4c75-45b6-08dddc17ad8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cUdNbGtHenBWdnl1YTE0SnF1emdveUpRdWlIdFk3bWtxcHo3YkJzK0ZuZVlS?=
 =?utf-8?B?SEI3S1poQ0dHcGhVdktlWEdNd2ZUTmNlZmlFcXhqR0syU2N2djh0Tjc2a3M0?=
 =?utf-8?B?WWRhMEREK1dkekZRMHQ5QUNBYlp4aHdRV2hrZHFzckxWdGh1dDFGVW1zcm9B?=
 =?utf-8?B?cjFXbUhHWXFtYUNBZVBjRy81TDVidFJBNDhPcTRvRHlKaUtrSjJiZEFNT3hH?=
 =?utf-8?B?RGdjY0tyalA5dkhSUzNrc2Jyc3RTUFoyL05GS1I2V0pFYzRFZ2JkM2NEWStj?=
 =?utf-8?B?U3R6R0l3RGhsQmY3RlhIWHhQVHhMVUd5UlMxUllhNUpSd3Jwa001Wk9TUVdJ?=
 =?utf-8?B?QWN3YWRQbGY0WjJ3ZGhFSlhtWXJRbVliN0wxOWhiRHo1Vm96TW5tSmNHVTZ3?=
 =?utf-8?B?NGZVdGI5d3d6Qm9jOWJoRkNLdlFVcHA5QVpMNmVQNnpvL2UvUlRqVUJLTHI0?=
 =?utf-8?B?TlAyM2owa1htN20xQTlKVzlRcFc1MUdzNFpJOUlreFE1UE5MYXczWGtySGln?=
 =?utf-8?B?TTE4QXhwT1c3dVB2TGt4R0F0Yk1PVDVNYzBlbmZKRS92QXJDRmFUUFRJQ2RX?=
 =?utf-8?B?TkhjNm1mVlpDa2gyZnlQaC8yOENYWVpxWnlSWlY4TmRmcUtoZFVUWnltbEVV?=
 =?utf-8?B?Q1RaaDlnbUhReFN3QnBKS05DWFNFWTY4alV3N2cxcDRCd3IvbG1CM3pIV2s4?=
 =?utf-8?B?WXZXMEFBNlB3U3FRQ2I2M0tTVThaTXFSZ2tiTWIvRGZ2aWhOeGd4dUZ6Q21q?=
 =?utf-8?B?Rmh4OVF0azhMYVVZNGM4MWtsSy90RUlvVVZEb2lpWkJzaHVUTXYydmYzbzNO?=
 =?utf-8?B?U3hlQksydjRMWFpGbjZmTytXZDdWYndXTm9kcldGNTVrc25aVndSOE1lMEhY?=
 =?utf-8?B?SURUaDYwK3Y1Z0xuWTdvRWVhU1NvV1hnVS9OenNsS21JT0d6aWVXSmd5S1p6?=
 =?utf-8?B?UnVwRjNvNEFhNFZjMCt3SXZaUmt4Z0lzeTIwRHVwMmNrb3ZXUStqNXB2Nis3?=
 =?utf-8?B?K2l6ZFA4NHY0NklScE9BYmJPdHJQRzY1ZEJYRzNKR3JyNUgrVnhnNkRuVlpM?=
 =?utf-8?B?ejZncWZ1N1VlNStTZGRNMExHYzNvNUtJNHEvOVBUNW9vL0ZIYkVoSWdVY3Z6?=
 =?utf-8?B?dUEra0hJRjRzcGxBdFl0eEVyWG1qTXpoQkNiVWdCUmlzQitKaG53TW1oZ0Rp?=
 =?utf-8?B?VG4xcU8xL05EOWcrZ0luNmdpQ0tYMHhtSnZQY2pVRzhvRFE5ZWR4a0dLYlhS?=
 =?utf-8?B?eklZL1ZYbnY4WlZmU2Z2akdKcUltS3ZBVkQ3cDFiRWd6SjV4UWYrM3dJVTVN?=
 =?utf-8?B?bk5ObThwYlo5bVNWRittVjdaclprQTh1STQ2cWJ1N2t2RlR6Sms1UGcvT0lp?=
 =?utf-8?B?ZkF5RVUrcnFpMFlIV1c0Mk41RnppWWg1cFpxVEl0dTVOcW1VbUhpS2taWmFr?=
 =?utf-8?B?K1RxWHNneXgwdmEreGJyc0lZS3ZqdStNYnpVTG0wb2JoeUdkNklPMzVSWVAv?=
 =?utf-8?B?aTZ1S1ROVytPQWswcStSUnc1TFU5OGZtSXR2dkxBcGVVSTRWdmhSZjllUmtB?=
 =?utf-8?B?c0ZReno3K2ZtK1kzd1pmL1NhSnNXVWU4azc3ck1zS3JHR1BhdFduNVkwdFY4?=
 =?utf-8?B?SVVjQUlQL1ZVUGM3SnQ4MXo3b0RmTm5xa1Y3S2VLSHByUjZydEZ5RzV2Tmwx?=
 =?utf-8?B?aDhlbXFieHd2UnlDMHZ2ellyUmkvOGE5aElBYlJHN3lZQU9UdUI5dDlkbEkr?=
 =?utf-8?B?ZitsQi9uaXJ3dmxGSGRtNWdHUmlIOFlsMHBySjV1dzFQWUU4bjVJSTVtakhK?=
 =?utf-8?B?cmlxQm5ncGpsamZVVkxHbnRpVjc1MmdGd0ZoUTlLYVlwTzhRd2V4ZllBcXI4?=
 =?utf-8?B?bmpjeEFtOGdteGZ6UWpBQ1hWVlFwbks1ZVBtQlVkZ0VCdkJnUzVPbXpmSnlR?=
 =?utf-8?Q?nrRquUyHu/w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2dFbmNEb295OW1yL3JaSjdnTDhnT0JXbjlJSXNuN1Z1bVNZV1hvSS9Pa05H?=
 =?utf-8?B?SnhCYTZWOXRBNldDa0ZOdDVGS0Jndk5ueUl0ZDE4LzBvaFFMWDR0cUI2VXdj?=
 =?utf-8?B?ZUZQbDIyenZETDB6SzdpeVBLaERmU0QwVk8xQ1ZueTZUZGZyVGREM2x4Wlp5?=
 =?utf-8?B?c1ZQSlhHMHpNcS8xSXAxeUp3bVZUU05IczVrRHlxT3FaQkwxdWRBTE9YcENs?=
 =?utf-8?B?ejN1Y29lSE5VaDg5cnZjWEp0cHNLSHY1azkySGxNSThITHhTb3c3VXlNQm92?=
 =?utf-8?B?YzQrdGFxUC9NT1I3MXpmSG9PWGxVNGZzanJVZkM2V1dkRFl2dFV6a0hoYUQx?=
 =?utf-8?B?NEE2cW5rcjdzT1lhV3QyU245a1BjajlzSExWaVVpaTBtNXBpcDdja2RpQXpF?=
 =?utf-8?B?OHJ0K2RkdVRVM09JSGpHcDVCMm95NHVPUEFrUDUxQk9ubWUzK1d5c1RaVTcx?=
 =?utf-8?B?S3dmekhpa3hlckJWZ0s0UVhuVU1EcWQ2enJGRXMzbEx5V3p2ekRvUHlTeVh1?=
 =?utf-8?B?SXZXOStlazcxcEtJSGlNaDMwbi9POElvT0pnd29CbkZMNDVTWlF4bWVLTmNn?=
 =?utf-8?B?NnduRDQ5YTV3WkpJMEV3UkFFaUlzdFdoNWFNRHFWc2wyWXcrUjAwOXlrSC9H?=
 =?utf-8?B?L2szam4zSHhBNTFXSHlRd0kwaHVGVjdDejYxeE5NeEk5c2RDa2JpTEdCUFhN?=
 =?utf-8?B?d2thekswZU1xd3F4U0RyTWdVQ01IOHdMaHg4blNPQks1OFRIUnZUTFlrS3Fm?=
 =?utf-8?B?WUx2K3lYNnVKeFNLU3FQeHFHSmhUa0dMSGNEQzg0eW1DWnRuQTJXUVZ2ckJP?=
 =?utf-8?B?aDZZbXZDTE96QWNhbVhNSXB5Wmt2eVcyRk11MDYvV2RPaWRzK3VmaGpSVHVj?=
 =?utf-8?B?T2lsaDArUjFYTHhwQTQ4Ny9KUnRINk5kOGFXZjM3d01hTjZveGdzUWphNGkr?=
 =?utf-8?B?T0FNNUNxYWFmeHJWNS9NNldLNlQyaGRRYzJJV0hWcVFPT3N0N1pXYW13bWVa?=
 =?utf-8?B?bTFrTklxMFN0N3VvNSsxN3NTK3hGZEo4d0ZGYjBGZExuSndGQVRJME9YVnZ4?=
 =?utf-8?B?RXUyb0lzYzZ4NExWRTNJZ3FYWktOUllPTTdRUFRjQlF5T3JsQ3VVU1JoM3Bj?=
 =?utf-8?B?RGdjNktrOVhWMzQ1eUxML2F2dm1YWXJjVTFpNDA0YzVueXd5SHJNd1lHVXBs?=
 =?utf-8?B?N2lJREt2UWZpcDBLNXNZL0VBbWhPQ05abFFEaXhLVS8ybWxsNW41dGlSY3RX?=
 =?utf-8?B?NEUzTTJMa1V3dzVIN0s1OTFjQlJZQ3NFcW5CSGJiYi9lMDBUNTZnMDcwd25Z?=
 =?utf-8?B?YndaeU5rYjNmc08rb1lhTWt3NWdNazJrM1VFMytMMFZnenI3VnQrdHB1VnR3?=
 =?utf-8?B?K1ZSZ0pOOStRRGovQlVKdkJ0Qldqc3ZhVldhOSszendKMGJtTmtUZkUxbTBu?=
 =?utf-8?B?N29Nc21obWRPcS9iQlJhcTFDYU42ZFRyRGowRnprTnZqdS9neWhkaHYrM281?=
 =?utf-8?B?TGIvempiS1FuemJIWW5weUFydXo4aE1DN3pLTG9HbXhub0pnQ1dNV2VmU1Z6?=
 =?utf-8?B?YVFnV2FldzFFOFlxQUZHQjJqVFRCdnVRNGhlSW5LZXdFNWRBNTFjZHkzT0FG?=
 =?utf-8?B?Q0pnNjk0ZW50WXdsSkcrRFBFMTVXRTBsQmhDSUFBTEw1a3BWdFNieTV2dEhz?=
 =?utf-8?B?UkFpbWdKM2t4cjZOUjBEZWJ0bWtkMVhyNlJyVmhKMyt6L2FKZU1maDAvL3NO?=
 =?utf-8?B?L1RVOEN0YkNnNzUrNUJVeTVFbUErUmE3V3FiMkR6cklWeHkzNm5MWnFVM3ps?=
 =?utf-8?B?NzMyZU13VHNUZ1d6M29ONlBJTU9GQkNSRHV3VmszUnJCYVBsbXV3YW16WXdL?=
 =?utf-8?B?YmNwZlRtejllRk1kZ05CS2d1Y2dhYUZVa0xLUkQrbXJab3NXazZFSk5HSXBs?=
 =?utf-8?B?dmJNa1YzVkUwN1VFWEppeW9DNW80bVhWL0FJV1hnbkhsUitLUnhJZUpTTkdp?=
 =?utf-8?B?SEFnTFdtQk4vVDlQa2ppZ0Vxa3lSbDlUdXAxS3ZtV2JDejNuL1FhS1FjNXJ6?=
 =?utf-8?B?OS8ydzB1L2hrb1JLVnN4eHFmS2lDdlUrOTI3M0FVOUpWVkhDWTJmelJSem1y?=
 =?utf-8?Q?3jaJZQye8emXEgWcv3uTa1BCa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdb92ce3-efa9-4c75-45b6-08dddc17ad8c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 16:20:41.3176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z4ogRgmscD8Cxq0qx6IvUtaKDVfcR0qLe/MdhVPPM112FX9Kc7H2aJY6Xz01yp9lSSq/Ri4MtRwdlVxTRtxI4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5805

On 14/08/2025 16:36, Greg KH wrote:
> On Wed, Aug 13, 2025 at 06:25:32PM +0100, Jon Hunter wrote:
>> On Wed, Aug 13, 2025 at 08:48:28AM -0700, Jon Hunter wrote:
>>> On Tue, 12 Aug 2025 19:43:28 +0200, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 6.15.10 release.
>>>> There are 480 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Thu, 14 Aug 2025 17:42:20 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.10-rc1.gz
>>>> or in the git tree and branch at:
>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>
>>> Failures detected for Tegra ...
>>>
>>> Test results for stable-v6.15:
>>>      10 builds:	10 pass, 0 fail
>>>      28 boots:	28 pass, 0 fail
>>>      120 tests:	119 pass, 1 fail
>>>
>>> Linux version:	6.15.10-rc1-g2510f67e2e34
>>> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>>>                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>>>                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>>>                  tegra210-p2371-2180, tegra210-p3450-0000,
>>>                  tegra30-cardhu-a04
>>>
>>> Test failures:	tegra194-p2972-0000: boot.py
>>
>> I am seeing the following kernel warning for both linux-6.15.y and linux-6.16.y …
>>
>>   WARNING KERN sched: DL replenish lagged too much
>>
>> I believe that this is introduced by …
>>
>> Peter Zijlstra <peterz@infradead.org>
>>      sched/deadline: Less agressive dl_server handling
>>
>> This has been reported here: https://lore.kernel.org/all/CAMuHMdXn4z1pioTtBGMfQM0jsLviqS2jwysaWXpoLxWYoGa82w@mail.gmail.com/
> 
> I've now dropped this.
> 
> Is that causing the test failure for you?

Yes that is causing the test failure. Thanks!

Jon

-- 
nvpublic

