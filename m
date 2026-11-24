Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795479110;
	b=Ra4UPD6VvBkLfDiuA+8D1tn0Ubx8wgqd32+2i9Gq+qtQMtl2iMvct0J9CWxWRRVTTNg7
	 tWS3UqUn9yrriq3ShtuZaHDKLRrWNo04OhETyy1HzYpv7EPGlzVY81aNEEHx6CQJooYUA
	 CDJs+jHbPQzJYKQDSW6JJvLY3PWnIERvmz6Kd9drF2LWu7qv6sF8E0Y135Xaafes+e5zm
	 kfNAc/bZzFFBSCklTWOYhbtaOXyH+OKahemFBaGi2Pfu3IlB1KFOF9lx/dPgI02+/u+DZ
	 OGbKTxmpL/NL0vtH1qQvT60jxauieLSwyEDGHMq6Vg79ymJnOrl8qVuDfEYa/GW9B1A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795479110;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=yMq8igLZVcmzI0i0wggxBQy6ZDDEWH71tv9q3nKk7fg=;
	b=dxPE+cgPHvHVXOIFIShX3RaCCCKdPW47nnJDTz0oSfHb4H9MeozPC85Yq3QzN9kUOmL9
	 maV+JolJ7zFqTtI516aONsDhMnIHkpou7Inqz+4KcHVIAfdmjlSbto0LsOBVo9susBbhe
	 UGnYfjL95WCMVajyv7BjsI+4Rm3NVRnQdJZ7klrU4r0/JIP5yulcqwrODKfDuVFV2hBcK
	 g16vAaDP1lAhtARpjc3nqixKRnhXQgUP2VmJh6iw6h41B8S4StyHfQ9JtkQ6T+ytOrlio
	 pjZx04ZLeAKxcR97UuVZyGqhU1c6M4Vq0MvSlc8NMW6EuFXfPbv6KehFWaJENrOX9/w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=qiPrl2vq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.30
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010030.outbound.protection.outlook.com [52.101.201.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE94606A327;
	Tue, 24 Nov 2026 00:11:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFE94606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=qiPrl2vq
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wb5a/Wx891cn03gciHHv+mqGIqHKaUpKmBGQRkKhk0mBu0vbJVUjmKkCMpiDNvN2qj+quLgqs2sG2W3hdRRekwK65jO10MiJATT87CcunBBWqiRlNnTEkBswz4Q6iAWIhzsiEXNRv9/QfyWimolIMsmiFyJ3TerZmh3FRYBpNmciABT6dxTUDCjoSadRQZc+xC8csg7YlvRb7308F3V7OjxENmlVeAFzrPDB0k85KD8bcfPXItBcnMRkeD8GnPGa1aKJ0iy/VHW2hmNF1rx+JBAGWqAMmPsnFpZ6BgUe2UVAmP0VLpjsUWHG0VOd91qol8hPlpDD3Ddrs4djHmXOig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yMq8igLZVcmzI0i0wggxBQy6ZDDEWH71tv9q3nKk7fg=;
 b=j6L8EzW0Hk5SD5AqL67Xk2AZPyyhpAIpRBJk+JZwmzkUO01ZQWzhYvQ/8tjfz1f6gcUSx+2nSns8kFTKT31+yr9RwqoSLWSQNbBMko67MxVbB0fdtIsxO9MNMVSl0H7BtAE2HQUGXddmZRle1OOrJ4X7X2Y/3xvIpD9PuCUi31/MipGdAF6HWgfbw31FlfPChO+rmpAPSGtmhT2rHsmFmxJOhpw5PF0AdDmvcQNGfNX9vF6UKZpPu5HVQA5wgkmHg15t7mdJDorj+VwuDL/acoNm+UTA576zfwuDnYcaj2Pnl877MEHtmSUBEgfn9KXUF9A7oUbzfewOioM/xATG9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMq8igLZVcmzI0i0wggxBQy6ZDDEWH71tv9q3nKk7fg=;
 b=qiPrl2vqTRpY3J4YnbCUNEO7t6EsPTOBcwphCoOPyj+CHRbA5A//gkfUpyt61E5IvonfYtUHZ1Bz4fvL0wmhlPOe+s/hmlpPtPbEQMZkv3aqXAQgG5/LCtu+LPoAPLfKrObKvJ9ELj5GpmLIV1bCkK0uX//UaQ3ceeK3a0JVDWk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by DM6PR12MB4041.namprd12.prod.outlook.com
 (2603:10b6:5:210::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 00:11:44 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 00:11:44 +0000
Message-ID: <5e04323f-dfdc-4956-acee-bcc09926726d@amd.com>
Date: Tue, 24 Nov 2026 11:11:37 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 04/10] PCI/TSM: Defer TSM vDEVICE allocation until
 device setup completes
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev
Cc: Dan Williams <djbw@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Steven Price
 <steven.price@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Lukas Wunner <lukas@wunner.de>, Ashish Kalra <ashish.kalra@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, driver-core@lists.linux.dev,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, patches@lists.linux.dev
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-5-aneesh.kumar@kernel.org>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261123083337.2731019-5-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0175.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:249::26) To SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|DM6PR12MB4041:EE_
X-MS-Office365-Filtering-Correlation-Id: d82dfaa2-1a35-4ae7-57af-08df49bf85cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|6133799003|22082099003|18002099003|261009223027099003|261021123027099003|261021121427099003|261026140227099003|261022075727099003|261022105027099003|261026121527099003|261028144727099003|4143699003|56012099006|10067099003|261102123227099003|261102130727099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	aveDcVu38Ww9ySlnd99sc7zbbBajwIv02D9x9qc30XlEGFKPCNx7EClbLe84+lCSQI6SWDJE1uNf3VgsR7wQYCEl3l4peVCeCFIyy2lbU6+IZMkBP7BbnU1tgg2zCglS11ISSmVp7rT+laaTOq88LMr3JCHLFjjY5o2gUE7oIpidl7dRmRoeiSwjLRW+QE2M3oLxMRCyEtPWP6WQH2z52a8GNsc2o7s/o4VLxKoc5V2Cte9sTpC8bQYdY2jg/0coG6LKav5bWr9y7M4e4FJ+4By3ogPvBXfCe31eUXkfXsnxVscEOTRiTNJJHa7Gwm/alB2wzjwjNrWCIgS2fTzbvoLfSsk7mYDX9tXlTS9ZR26FsqYaLB9AAmiVYwAWw5KcNPbS1Zq97mic85Abyc5b/tA8HyCembmR6rwh4AZQuQA73X40gnDlqqpkQuJndG4IqRXaJGIfdE+4SAZOBEq2DMy5SKpnLaZ56zXSL8+IUj1Xk+YNRVrGUaeLXVhOiLozRCooJFDBP6QTycTp1Vudv9NocHfmsBhznjbKEDRu7XMFcSvs2Z1nz+/Zij7dBhi3WNnjFUDbSMDdTc41pX2xbbns8NtMKCFaMdPYJ3bsf5r/kB+kRaIcSC4YvBecG/hurd3TZRvTE9zkihRhExJCV6UAj1sknX41vwFd0CwrSAM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(6133799003)(22082099003)(18002099003)(261009223027099003)(261021123027099003)(261021121427099003)(261026140227099003)(261022075727099003)(261022105027099003)(261026121527099003)(261028144727099003)(4143699003)(56012099006)(10067099003)(261102123227099003)(261102130727099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TU9sNjBxYVF3WkhwbjIxdUZZelNhaDZ0R21mRzdQeHRLWU4vKzNWWkdKRXJP?=
 =?utf-8?B?ZzgvamdlVU1DbnFMYTdwRVkxMVJRanFKdjBYbm9SSlpVTzNPRTFSMXBxa1Rh?=
 =?utf-8?B?Slp1b2hLYUdDRjhSNzRMZUZHeXhqUFpZMjVQWElVbVppOTI5eDFnSnRlTC9m?=
 =?utf-8?B?S1UxVUh6YmdBWC84WHJCNmNWa3NGNHNSTXJ1cTdsNXpKZlk5em5yNVJTQTUr?=
 =?utf-8?B?ZUZzQVk0enJSTmFBK1RQb1daYm5UK0lXeE1KT01RSG5SNFllZ0FEU0FHczhv?=
 =?utf-8?B?SEtLNkJ3VGVnUjkxdmViSFVTb2FQRmxYbWJmL3pHN1BNQS8yeXZpWVlSOWlQ?=
 =?utf-8?B?K2hHdTZId1IzZmJRZlh1RVV2OUgwM0RTcGQ4MnkySzMvWVduUzUxRklySHUz?=
 =?utf-8?B?Y20vM1pDYnJacllqejN0a3FiZnVkRXEvRHY3clNOc0o1NkQrTjJYbWlPS1ds?=
 =?utf-8?B?Z2JIbzNOdGoyZnpNNnNkWEx3WVZ0QitmbnpROEtLdW1SclRoRmgyajRDZVUv?=
 =?utf-8?B?ZHVTMFZZNzYxU0NHeFFENjZDZGNETnR6ZVlKc3NweGpmbE5tb1dVMG9ST0I1?=
 =?utf-8?B?YXRxMk40UE1QSi8zQmVsNGVIZFg4WmZrem41SnpjeTBWdjhYVmJleTVPejdI?=
 =?utf-8?B?WTRnMmtjc0M4MVZpVi9qakx4Tm9yTWRyMWo1YUlwUU5YT2xNanJQSG45WHF6?=
 =?utf-8?B?MmR1cGQybGVJN01kZDlnWnd2QzVabGhqKzN4MGRiUm5HbFpqZWNBSmk0aXhT?=
 =?utf-8?B?MjB6NXVOWVV6NlUxNmt4TUF2bWJXMHZ0RDVMamdPdTltaS8ycU1lQjZlN0Jt?=
 =?utf-8?B?b2d5QUJNaVJkZElRbzN4UnhndG5hV2plRFJEUDNrNksreHpiaG1DUVZYUUVq?=
 =?utf-8?B?blhhNi9VVWEydXdjcGJBcy9hblFpSFZwZndkZCtZeDJlV1FtL1BuV3NlQ3di?=
 =?utf-8?B?YjN3bmM0ZkNUNDl0UmdMWldRWHpJV1crYytST1BjbVNSVGU1akl0c0FuaXFQ?=
 =?utf-8?B?NXNZenpsWlpYd3VUdDNtZnZMNFBJakF4bURBRit4YjhlMGU5azIva3U5MG1W?=
 =?utf-8?B?cFhwQytSbXNHaXhZc1RlZkprYW5GTEVLTVJDZUJNemhUdFBnM2ZJR0ZaS2dw?=
 =?utf-8?B?NklIRW5Ob1psTW42VU1JUjdjN1hBUVQ0bVpZY1ZySmZhbjBsc2dNeS94VmYv?=
 =?utf-8?B?SmpXNi9oZm44K3NXVnZXMFF2RGwxendhSVhSQVVjc1YrckplMUdic09sWWpH?=
 =?utf-8?B?eVpEa1dwdEs0bTNGR05nbTlnOWp0VzJ0bkJsbzlGWEtBK0tWQW5STDVRUFEw?=
 =?utf-8?B?aUY0TUVXdnhjUWtLMHZXN2hnbWtrdWlGTUlsYmxLa2tVMVQ0UUcvVEQwNks0?=
 =?utf-8?B?V05nWHJzWmsxNy91WmZKTzQ2aDBUcUY4d0Ezd3dET0Z6d2VUVUcrVHhQVUsx?=
 =?utf-8?B?WGNaaDV3bDd0RVArNHdLTmM3dFhpZGtiSG9rNFE1VmdJS00xQm5nYjRSWEVE?=
 =?utf-8?B?SDFWUUplQVBCNEROMktGVGlsTXBMTW95Vnh2d3J4T2YwTXpkdEJRWTFVT0ww?=
 =?utf-8?B?SnV0RG1VMTJ4VGpJUzZUbldZOTczZUNwenpwdldJdmRlL3l4cDJNSS80SFVy?=
 =?utf-8?B?V0F2LzNtclJ3bm4ydjBTSUJoaSt3S3RiSjhXT0hIVkF4aGtCVEJTZUxVcFZ3?=
 =?utf-8?B?NnNWVlYwKzZqUW5LaEpza0xqV1gzQUlCcHFoRFQ0V2RsYk9wUGZKM1hQdXFW?=
 =?utf-8?B?VUlpcENaYkVKd2VLcU5la0RWL3lTRGpNL24zY1lmaGJFdU5QZ2IrR2JTUElx?=
 =?utf-8?B?T1lDNno3eFRIdjh4SkYvYWFDdWpKRjdWRDUzR3NDVS92aGVnaDJwWWJ6S3dG?=
 =?utf-8?B?Vnh3eVJVbWJML0VPVjE2S3hINHB1U1NPWVhtUC96a1R2M3JoRERPMEFocERz?=
 =?utf-8?B?U1Q0eHU4Q1ZZbENNVzJkYm5JNTdPWWM2aEdYUytEOWQydUU3R3c0V0h1Rzdm?=
 =?utf-8?B?L3VHQThDSW4ybEhMLzZEWFZXUnZOZ3BzeDIxNnFMUjJDbW8xRDlrSkluR0dj?=
 =?utf-8?B?MHYzcU16aXhBMVJYK1RhaXAremUzdHp0T250U2JYR3pRTjNXcHdDM0g3VDRm?=
 =?utf-8?B?TGJUVUpJMGE2Q2Uyb2M5L3VuK2c0ZVRGdnZrdFRPaFpzcGNmVDNtQUN3Yllr?=
 =?utf-8?B?eW5mWis0TUdmSUlsb09qMnl0cXlpWUxOUzZmUDdXK2o4R0d2QURMbjRiRU05?=
 =?utf-8?B?T3dLMVZJOVZ2V3FNaHVjeWZZZUpGVERib0trRXd0ang5b0l2UHVQVng1YkNB?=
 =?utf-8?Q?/4/Mp/OefrL8b4roL5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d82dfaa2-1a35-4ae7-57af-08df49bf85cd
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 00:11:44.3294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NZHCyTzonUqbj7ep61vBY2ffE2EyxtV3ihbOxjX0tjBVSH+JHWxV7McxJPxjgXbpK9GSejp+SyGeni4qZGeegw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4041

On 23/11/26 19:33, Aneesh Kumar K.V (Arm) wrote:
> A successful connect does not necessarily complete the checks and setup
> needed to assign a device to a confidential guest. Authentication and
> userspace evidence acceptance may still be required.
> 
> Add pci_tsm_pf0::ready and pci_tsm_set_ready(). While ready is false,
> pci_tsm_context_get() returns -EACCES, preventing TSM virtual device
> (vDEVICE) allocation.
> 
> Initialize ready to true to preserve existing TSM driver behavior. A
> follow-up CCA patch will clear ready during connect and set it after
> evidence-accept completes the required device setup.


If the host is not yet happy with the device, it can simply not pass it through to a VM, what is the value of doing this blocking in the kernel? I'd drop this one. Thanks,


> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>   drivers/pci/tsm.c       | 31 ++++++++++++++++++++++++++++++-
>   include/linux/pci-tsm.h | 10 ++++++++++
>   2 files changed, 40 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/tsm.c b/drivers/pci/tsm.c
> index 2be92bde8780..4dafc5dc6fe3 100644
> --- a/drivers/pci/tsm.c
> +++ b/drivers/pci/tsm.c
> @@ -27,7 +27,8 @@
>    * Provide a read/write lock against the init / exit of pdev tsm
>    * capabilities and arrival/departure of a TSM instance
>    */
> -static DECLARE_RWSEM(pci_tsm_rwsem);
> +DECLARE_RWSEM(pci_tsm_rwsem);
> +EXPORT_SYMBOL_GPL(pci_tsm_rwsem);
>   
>   /*
>    * Count of TSMs registered that support physical link operations vs device
> @@ -293,6 +294,26 @@ static bool is_devsec_tsm(struct tsm_dev *tsm_dev)
>   	return tsm_dev && tsm_dev->pci_ops && tsm_dev->pci_ops->devsec_ops.lock;
>   }
>   
> +/**
> + * pci_tsm_set_ready() - Set when PF0 permits device assignment
> + * @ready: whether the device is ready for assignment
> + *
> + * pci_tsm_context_get() rejects requests with -EACCES while pf0->ready
> + * is false. A TSM driver can clear it during connect and set it after
> + * completing authentication, evidence acceptance and device setup.
> + *
> + * Hold pci_tsm_rwsem for write and pf0->lock through device setup and
> + * this update. pci_tsm_context_get() checks ready under pf0->lock, so
> + * device assignment cannot proceed before setup completes.
> + */
> +void pci_tsm_set_ready(struct pci_tsm_pf0 *pf0, bool ready)
> +{
> +	lockdep_assert_held_write(&pci_tsm_rwsem);
> +	lockdep_assert_held(&pf0->lock);
> +	pf0->ready = ready;
> +}
> +EXPORT_SYMBOL_GPL(pci_tsm_set_ready);
> +
>   static ssize_t connect_store(struct device *dev, struct device_attribute *attr,
>   			     const char *buf, size_t len)
>   {
> @@ -393,6 +414,12 @@ struct pci_tsm_context *pci_tsm_context_get(struct pci_dev *pdev,
>   		goto out_unlock_mutex;
>   	}
>   
> +	if (!pf0->ready) {
> +		kfree(context);
> +		context = ERR_PTR(-EACCES);
> +		goto out_unlock_mutex;
> +	}
> +
>   	if (!pf0->dsm_context_users)
>   		reinit_completion(&pf0->dsm_context_drain_complete);
>   
> @@ -724,6 +751,8 @@ int pci_tsm_pf0_constructor(struct pci_dev *pdev, struct pci_tsm_pf0 *pf0,
>   	init_completion(&pf0->dsm_context_drain_complete);
>   	pf0->dsm_context_users = 0;
>   	pf0->removing = false;
> +	/* Default to ready for TSM drivers that complete setup during connect. */
> +	pf0->ready = true;
>   	/*
>   	 * Note, low-level TSM driver responsible for determining if it wants to
>   	 * proceed with a device that has no DOE mailbox. TSM may have an
> diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
> index 7e91c15ffe3b..9c5f0b6c0f6d 100644
> --- a/include/linux/pci-tsm.h
> +++ b/include/linux/pci-tsm.h
> @@ -4,6 +4,7 @@
>   #include <linux/completion.h>
>   #include <linux/mutex.h>
>   #include <linux/pci.h>
> +#include <linux/rwsem.h>
>   #include <uapi/linux/iommufd.h>
>   
>   struct iommufd_viommu_ops;
> @@ -111,6 +112,7 @@ struct pci_tsm {
>    *	blocks link disconnect
>    * @dsm_context_drain_complete: completed when the last context is released
>    * @removing: reject new contexts while the DSM is being removed
> + * @ready: TSM driver has completed the checks and setup needed for assignment
>    * @doe_mb: PCIe Data Object Exchange mailbox
>    */
>   struct pci_tsm_pf0 {
> @@ -119,6 +121,7 @@ struct pci_tsm_pf0 {
>   	unsigned int dsm_context_users;
>   	struct completion dsm_context_drain_complete;
>   	bool removing;
> +	bool ready;
>   	struct pci_doe_mb *doe_mb;
>   };
>   
> @@ -156,6 +159,7 @@ static inline bool is_pci_tsm_pf0(struct pci_dev *pdev)
>   }
>   
>   #ifdef CONFIG_PCI_TSM
> +void pci_tsm_set_ready(struct pci_tsm_pf0 *pf0, bool ready);
>   int pci_tsm_register(struct tsm_dev *tsm_dev);
>   void pci_tsm_unregister(struct tsm_dev *tsm_dev);
>   int pci_tsm_link_constructor(struct pci_dev *pdev, struct pci_tsm *tsm,
> @@ -175,6 +179,10 @@ bool pci_tsm_context_match_device(struct pci_tsm_context *context,
>   				  struct pci_dev *pdev);
>   struct tsm_dev *pci_tsm_get_device(struct pci_dev *pdev);
>   #else
> +static inline void pci_tsm_set_ready(struct pci_tsm_pf0 *pf0, bool ready)
> +{
> +}
> +
>   static inline int pci_tsm_register(struct tsm_dev *tsm_dev)
>   {
>   	return 0;
> @@ -222,4 +230,6 @@ pci_tsm_context_match_device(struct pci_tsm_context *context,
>   	return false;
>   }
>   #endif
> +extern struct rw_semaphore pci_tsm_rwsem;
> +
>   #endif /*__PCI_TSM_H */

-- 
Alexey

