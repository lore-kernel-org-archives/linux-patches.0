Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB2C1865E5
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 07:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737529500; cv=fail; b=jqKj9UV0I7PuWvuxHyf35cscFmVQefmrzYKaEbU5eN24nrwUDSeNwkDmBT4PgBbk48kYeFy4qkBlAj9MBhx126G8nGCWkky2iaeR9jR0BzxAXyqntDPJpOhTLBUfsifxr4p9BNe026UOHZQE1f6AV1TUv96XGi6r/qFZTGhcoM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737529500; c=relaxed/simple;
	bh=Sjngqudr7vwWIpQcbSpm8reXxoH35XrTfBwosSAOIbI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OTyf/Y5MPyzWB/8i3l+17ynkim6RCtN8K2fG3RJHzFBk3MgNNIHUqAWrPSvtJvBsHLAgwrjqAR36W1pT8aqFCOrTifeisIewke2G+eGbFh8xGIptqosgCcAoLEeLizFyFH6WRk6/5qvk3JJMZnbQRc3IGwx1vaDkg6fpsDhmJCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lRU5Wl0R; arc=fail smtp.client-ip=40.107.237.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lRU5Wl0R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u0a6Qj5SlpeCF5TfTst/X7iryCZ20NOSbbuCOF7B0M5z0kXjKCPUWebY7Jsrcqb2+mG176sybtnbFm7xPYzjwvZPQQFBkd49bfBTY/W3OilZ46WcXu+jTc/70a1VVjOw0EjDG/5lmbUdYDIgll1miEuviXJ6QJe82wqs6tLDnAKEj3TCJOE0HwkKtR55uUMZsMEl/8R/3MZHyBhbfzcUnGj6AoIN/YQ194Itakw2U2SDdqIqzSXEEU3jzq5YcDWL4dmFtu8lFcO+i3rvIvj+DsbPA6IkqF3ajHtiD1YPCNH5IuKp5IK5hy08OsJmR1KIEEOIVlXR6v+ULtlq0fXzQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3pWnYm/3sxBrilHQ3BONiGnObVxvAVhuOO0iZ6rsVQ=;
 b=XUZ8UXE42XlrmgaydPF6tKR4hJIgqqeR+GDxsfBI7UMpxO1mEaqgr/KoE/PDuSpErLN8MCx04M15+ydk3+tgb8srTRNeJcM9/0RoA6FRgWlVOJ44E0A+gTKqux20h1KSsin3PPzfCFpyNANN+5JmtZpGv3HGoPK+Yr5QlatEoO85BGlu6+FAwIMk5NjvJPDb5YQdBFRoavKWZO2Me/qDhQrqr9DnKa4QAaeY/5/H+x+jzmyCerhtU18HfPgENLrzuRa5C2vqfDMr8w8UUT/Sa7jDzYTh3MsJfNsU48C5udjXkJqT8OZ1FfWKm5G4V3E05fmcASQc9tJGooFyNipB8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3pWnYm/3sxBrilHQ3BONiGnObVxvAVhuOO0iZ6rsVQ=;
 b=lRU5Wl0RVNCjZF/JOb47bmQCxH5dzPAxuhG5a/CiSWCuO6hSeWTcbkIwzr6C0rBmLmPVvQjX8QV8xtadm1pEPs9mitprc6SdX+z15FnVtJzB38kz9j8UILhusL8AZIwHMuqDAsDDPqF8mhQrqPztxAVj/n0pOIoepO6gMhxqOiGTsthdOBZTT3LKJ8Gs7kof43Xuv7YtVKLJ23TqfzcCS0sDWbX8s6Gjm/c0FvV2O1Dj/YNouE3WLvIHY4omuTfFqhX6xgB69Y4Ez+fLK+bxoSv9nD207BW7rSLLiprgWhEq8iFcjMM3yR9Ihh7hKng2Vd2bh3Uyy3L1+UFuRO3BQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by SA3PR12MB7877.namprd12.prod.outlook.com (2603:10b6:806:31b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.16; Wed, 22 Jan
 2025 07:04:54 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%4]) with mapi id 15.20.8356.020; Wed, 22 Jan 2025
 07:04:54 +0000
Message-ID: <449456d8-4e9a-4ee3-a3e8-8675cbde4a5c@nvidia.com>
Date: Wed, 22 Jan 2025 07:04:47 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/122] 6.12.11-rc1 review
To: Salvatore Bonaccorso <carnil@debian.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20250121174532.991109301@linuxfoundation.org>
 <Z5AVm4cQDGjnDet2@eldamar.lan>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <Z5AVm4cQDGjnDet2@eldamar.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0007.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::12) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|SA3PR12MB7877:EE_
X-MS-Office365-Filtering-Correlation-Id: f412088f-da81-4047-41a7-08dd3ab312ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UzROQzlkRXc2Tnc4eW5hbHZSaUh6UGgzM3d5c3NqRHZSWnBFd0hrMk0yZEZy?=
 =?utf-8?B?NExrNnY4WGliMHExQkJKTzRWSzNHU3g5VndrbUxyYW5JMDROSlRHZzZzc0p6?=
 =?utf-8?B?M1lGa3dFYXNUSlZyR2xOWlRONEVuNGhkTUVZWlgzc0xKd1ZvakV3UVZaRitx?=
 =?utf-8?B?eGZDV25QU294U3VDV3Ayc0Qwek9MSkxBK0M5QzdFT1dYb2dZUXNKaE1kU09p?=
 =?utf-8?B?VEVIV1J2aU5jdWM3c1pPZERrdldnUjNIMWNsOXF5TXhYZUxwT0NmREsyOGN4?=
 =?utf-8?B?UGI0czNsOWlHU0VVZjhHdWJENmNCSDc5UEw3WDdVRzI2dE1udkI1TjQ3TmhD?=
 =?utf-8?B?aHJ4dzZ0OTc1Szl1dTJwdFU5TjNqYTlXVDdENTVhTHV1eUs4a1kvdVZ1djYx?=
 =?utf-8?B?enhadmpQRG03cGFIRkVVbHlGS3VhU2UyR3NpdVVRUlpkb1lJaEhlTmRVRzlm?=
 =?utf-8?B?WnNtZmJpQXlrWkJGTDZNUG1iY3I3SjZhOG5ZNzRhRlk2Uk9hZWFVQW1qUVp5?=
 =?utf-8?B?Q1lWMUhCWVVMMnJuWURTUWxJQlVFb09KbFVZbWhZTDFXVkRKcEN3VWVMay9k?=
 =?utf-8?B?YmFVNE1Oa3VLTlJCR3ZkSnJNN1ZzcEVURkZPVmZUS3ZUSEtUMGlBU29SMmdw?=
 =?utf-8?B?emtzM1ZjNnI4YXNBNXdrL0xsTTlhMWR0M0pMdXlDalV0ZWpoY1MzMEI1Qits?=
 =?utf-8?B?bzFQOUxQS1QrOXdDRUhiUklHaHZGOVVkbnZuVXByS3c0NXVvV0liVVVQcG44?=
 =?utf-8?B?Q1dUS3N6cXdHUnFkK3BYMGJhQ1pMdnBpczRWRW1ST29wbSt5d3FLcXpWUGNm?=
 =?utf-8?B?ZEVLZVJkeHRxbkU0aUp5bXFTQ1AwM3lQV2pmTnBNL0M1SHpZZEVKTFhtbGJ6?=
 =?utf-8?B?MVVrU1FubzNzNDdYSmF2a3JFU05UWU56bVhWeU54NTdYdm1WQlBvQzZFOTJM?=
 =?utf-8?B?ZUhneitMcFlad2hDRTlKWUx6WEFuNnU1Mityc3cxWldOV2t5bnArdHVKbnV5?=
 =?utf-8?B?cG93b1A4S2NwMGdibVByZjR2dnhpYzBPdU1lZEtVMFErT0lEbHNOL0w1WEpZ?=
 =?utf-8?B?VG9ydXpQdnJtYUk2eGJ6ckpGamVhanBWODc5clJqS2hlOVNOMXdWMFpZeXBO?=
 =?utf-8?B?amR4RHBYRENqZlJjT0pQdFMxRXVCaXh0WUhKdkxvSjIvUjR6cnltOXR0dDg0?=
 =?utf-8?B?T01HN0xRdDRlMzdFNUh3Vkh6RW1Oc0dzbnBqQVI0MytNVEhrVkJ3NHoxY25o?=
 =?utf-8?B?dExrMzZmL0hRSGJiUk5jcWVBSkRsZUMreHdWaVJqcHdHNDh3bktWTEJzN20z?=
 =?utf-8?B?bnZYVHRhai9qTGFTb1UxU25TeUZHajhrTjRaNE9pcGhjQXhXOUpISXZ0OHMr?=
 =?utf-8?B?NDJ5RE5Jbm9Ka2JnYzBTaCtBZHdKS25qVFdnQVl1Q0ZrTWRka1ZBTjJLR0tu?=
 =?utf-8?B?VlFkQTJJNjlYNEdZSS9sYjZYSWNJN2VxcUF5YnlMR0tDNWZXczByMGRSek5R?=
 =?utf-8?B?dVVBSGJqR1ZWbjBoRXpSSm9XdnlIRmF2NTZCQkdxQjZCNGp5VlNQNHdyVmNQ?=
 =?utf-8?B?alFUOUQvMFk4SkJpWk5mWUpEN01UbzFBYVNveHF2Tk4zbjJoVWhOYndRc01u?=
 =?utf-8?B?U3VYMkMwMGszYm1XcUpuR09wN2JCaEk2RHEwZDl2MkFKRUsxU3ZWajF4U3NH?=
 =?utf-8?B?STgzQWphU0NjUlR6TkIxY0hpSnV5dERSS0U3S255alRkQlBDR2U4L0toYlV6?=
 =?utf-8?B?am8zWkhhZXFuTHRqQlFaVmo4cXBKYVZ4czgxbFl0ZXVxVlhNODhLVFh5V0N2?=
 =?utf-8?B?L1NYejF2OGRScHRTL1g4WXF0aXowelUvbGZYRElQRVhEc20zTlpYNFRGaERI?=
 =?utf-8?Q?T8IgMdxYQSVgL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWRFU0FjWWNjTEdkSE4zVmZsSXp3OGlMVUFQYmRTbXN4b0ZNSE1haXkrbDZK?=
 =?utf-8?B?UFFwL2JoNUVieDVoN2VkbThSaXNYdGZ0amFUZTJmUDZxdkwzT0VXenFYRTNa?=
 =?utf-8?B?U0x4UUxNR2ZIaXJXQkpYQldBWW9qZ2cvcDhtMFhPVWM5Vlo0UFJDcWxjak1M?=
 =?utf-8?B?b1FBWFJ0R0c0TjZOcUxEdGN6UDJrN3hRNHY2WUp1K3gwWVRhMWUxRGlJVWwv?=
 =?utf-8?B?bEhNT0ZPM3hzQ000ZXZIenMxcDNjbHRtZGNkWjg4T09CSHFRRFI1U1RrVE9W?=
 =?utf-8?B?N2wvNG1MUXhTSGIwbWtsY2FyS2tRQ2dUZFFxRENjMHRwWjJ2SVNIbThaNlVD?=
 =?utf-8?B?RFZxdU5yNVQ5T2dlYmFvUEZKZVg4Yk41VStRV2JWdmsvcXoxdzlkUG5JcmQy?=
 =?utf-8?B?MndzeHlXZHhKMnVPZXVpbEo4bndJb1dqc0NrYVlScDNVUk5EQTZYOVRnSWtm?=
 =?utf-8?B?M29LdTBQTFhsNGd6dmVkWGtjYlNTVW1FdVJIbkRtRzV0bHFOSjBBbk5TZlZ6?=
 =?utf-8?B?WmFibGpIeGcvM21Dck94SWU2cG04d2V0TFZpQkEwZGFKdWhFS2ZicS9ISWRP?=
 =?utf-8?B?TTZpa2orUlI1eUdBNkZYWVBhZEFEWDVvRG1rN05SVzVnRGNpNVMvTjh0TWo4?=
 =?utf-8?B?Vk5NcUNkTTFJN3BQQzNnY241bHBhRDNyckZxMjZRMC9aRGFpd01UYnNkUzJE?=
 =?utf-8?B?cUdJWk5FNWNxWVg5YytPU1Q5OWJiM0lQazJ6QlNTb1cwejEyd2Ewd3YvdWxJ?=
 =?utf-8?B?VFNFTy9WTE5CQnVWdVllRmM3Y2lleXNvSmZoSTU1RTBYWGl1K3pUTkhvQlBy?=
 =?utf-8?B?MUlLQkNEc3o3TTZyRFEzb09xNzlXaHZnOEhIWVBCdHZ1OE9Vd0lwaFlFSWRa?=
 =?utf-8?B?T0E3M1B3aFdXRHZXTXBxeXJBdzZrY1ViUlc1OUljeUdoZURReWd4ZlhXN0cr?=
 =?utf-8?B?UmJyM2Nwa2dCY3VhU0tKK2FXRFBwNVdhQUNtbVpsVW4weTdmWWxqTFBLMDRD?=
 =?utf-8?B?cHV1bEVhUGNWQ2ZsVHpBQjJMRmhCMVJQbjZaTm02T2t4WnFVVlRRYkd0YmxC?=
 =?utf-8?B?b3ZNYWNjUmY1M1plNDBFM1ExSU1neFp2Qlc1OHkwdlVHUFVRb05BZkI4TTFE?=
 =?utf-8?B?TjZDdHNCeEtqYXhXVUNNNlpVemo3cG4vSFZndjBrdkVHRWxyYXJwbHFiQjhp?=
 =?utf-8?B?RVV5WlJHU3FORFp5eWV4VWp0bmljM05DUWV6Z3prN0V6cDJWL21weU1SVkpR?=
 =?utf-8?B?TGJldUlPS3F4LzNRTm5JL1Bxc3BoZkxXRmlWL1pCRjNzVVZKbjBuWHdzZVBm?=
 =?utf-8?B?UkQvZ1lYdE1wOUNMKzBZdEJ0d0ZWVnJuYTRldC8weTdmZTJxU2JUV1c2NEt3?=
 =?utf-8?B?T2p6Y2xSUnNKR1BXWVZremFCTVExS0MxQTJxbngrZmRUeEFVUVc3ZG9sdnlV?=
 =?utf-8?B?M1R1UVJGV01mbVVSZWRRNHJpRjFEUDNUaGtweHBJWklHR2lwZXp3WlBVaHhT?=
 =?utf-8?B?NXJvbWxvSm04dFovMEhYTC9tWjUxaWc4RG1GZ2E3SjcxdkxqMlNZa0REWEhP?=
 =?utf-8?B?aTZyQW00L2cyR2hNZHV0TVg4a0YxYUgrZUYrNGFwU0tVTG5XQ1V0YUoxUDJW?=
 =?utf-8?B?VG1nMUFrVHdhd0tSRFRoaW5udGdYaWl4ODh1WUNtbzR0ckk0Nk42WkRaZ2FS?=
 =?utf-8?B?QVBwa2J3Nnc5cDlrRDJXd1NBTmdxMGFMZndQV1VOZW1HWE1pUHlqTGZDMDhn?=
 =?utf-8?B?VWczMEd1YnEvWGZqdU5BTmxsc0lkYlFDV1ZWT0ttd0sveGVXZElQZXVweWxk?=
 =?utf-8?B?bWc3QXdrS2VRRjhQUSt4RUJJMzNOR0FJYnhSano3c3FrZTVNd2p4TE84RXBa?=
 =?utf-8?B?c3JJelZoRTVDN3FxQ3NBNkoySnprMTlvR0tMSHdoYnIvYVZCSHZHb0lWZ3BZ?=
 =?utf-8?B?N2J6aU5Mc3NFUFEwSXNLakNkN0krK3FMdGNYa0dZSXNHdTJIUlJ0SHd2VW56?=
 =?utf-8?B?d2FHYmZUY1BqZlIvNmdjZ1JOUDdyRnhlVDNhQjVtWGMvNThvU1ZaSFJHRXdj?=
 =?utf-8?B?b3ViKzlvNFNvbWRWd3dUZGQxME1MQXBka1g2bXNsWFhTbFVCZ1lvUjNGOTd3?=
 =?utf-8?B?QTVkWU9GdFMrK04vY28rOVZvbnVleGRieTJuU0t0T0FVYXR5QS9sK3NrMWxE?=
 =?utf-8?B?MU1FRU1EaEtJbFhVQU5NS1JtRGFTREVZMmtGOXJTYkFjL21sTDhaem5KZkkx?=
 =?utf-8?B?OEZzRTVNY1lJTmhCcEpaNCsyVDdBPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f412088f-da81-4047-41a7-08dd3ab312ab
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 07:04:54.5559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zv6rfe+tyo8budWaUosH+WlDGmTJk5fDeuGKoZBez1l5AlMvKjpUbKfpe8PGwx0uWE3SMiKTRyZK7G4IQECD/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7877

Hi Greg,

On 21/01/2025 21:46, Salvatore Bonaccorso wrote:
> Hi Greg,
> 
> On Tue, Jan 21, 2025 at 06:50:48PM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.12.11 release.
>> There are 122 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.11-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
>> and the diffstat can be found below.
> 
> Built and lightly tested, when booting I'm noticing the following in
> dmesg:
> 
> [  +0.007932] ------------[ cut here ]------------
> [  +0.000003] WARNING: CPU: 1 PID: 0 at kernel/sched/fair.c:5250 place_entity+0x127/0x130
> [  +0.000006] Modules linked in: ahci(E) libahci(E) crc32_pclmul(E) xhci_hcd(E) libata(E) psmouse(E) crc32c_intel(E) >
> [  +0.000021] CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Tainted: G            E      6.12.11-rc1+ #1
> [  +0.000004] Tainted: [E]=UNSIGNED_MODULE
> [  +0.000002] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> [  +0.000002] RIP: 0010:place_entity+0x127/0x130
> [  +0.000003] Code: 01 6b 28 c6 43 52 00 5b 5d 41 5c 41 5d 41 5e e9 2f 83 bc 00 b9 02 00 00 00 49 c1 ee 0a 49 39 ce 4>
> [  +0.000002] RSP: 0018:ffffbe1f400f8d08 EFLAGS: 00010046
> [  +0.000003] RAX: 0000000000000000 RBX: ffff9ed7c0c0f200 RCX: 00000000000000c2
> [  +0.000002] RDX: 0000000000000000 RSI: 000000000000001d RDI: 000000000078cfd5
> [  +0.000002] RBP: 0000000029d40d60 R08: 00000000a8e83f00 R09: 0000000000000002
> [  +0.000002] R10: 00000000006e3ab2 R11: ffff9ed7d4056690 R12: ffff9ed83bd360c0
> [  +0.000002] R13: 0000000000000000 R14: 00000000000000c2 R15: 000000000016e360
> [  +0.000003] FS:  0000000000000000(0000) GS:ffff9ed83bd00000(0000) knlGS:0000000000000000
> [  +0.000002] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  +0.000002] CR2: 00007f9f5a7245d8 CR3: 0000000100bfc000 CR4: 0000000000350ef0
> [  +0.000003] Call Trace:
> [  +0.000003]  <IRQ>
> [  +0.000002]  ? place_entity+0x127/0x130
> [  +0.000002]  ? __warn.cold+0x93/0xf6
> [  +0.000004]  ? place_entity+0x127/0x130
> [  +0.000003]  ? report_bug+0xff/0x140
> [  +0.000005]  ? handle_bug+0x58/0x90
> [  +0.000002]  ? exc_invalid_op+0x17/0x70
> [  +0.000003]  ? asm_exc_invalid_op+0x1a/0x20
> [  +0.000006]  ? place_entity+0x127/0x130
> [  +0.000003]  ? place_entity+0x99/0x130
> [  +0.000004]  reweight_entity+0x1af/0x1d0
> [  +0.000003]  enqueue_task_fair+0x30c/0x5e0
> [  +0.000005]  enqueue_task+0x35/0x150
> [  +0.000004]  activate_task+0x3a/0x60
> [  +0.000003]  sched_balance_rq+0x7c6/0xee0
> [  +0.000008]  sched_balance_domains+0x25b/0x350
> [  +0.000005]  handle_softirqs+0xcf/0x280
> [  +0.000006]  __irq_exit_rcu+0x8d/0xb0
> [  +0.000003]  sysvec_apic_timer_interrupt+0x71/0x90
> [  +0.000003]  </IRQ>
> [  +0.000002]  <TASK>
> [  +0.000002]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> [  +0.000002] RIP: 0010:pv_native_safe_halt+0xf/0x20
> [  +0.000004] Code: 22 d7 e9 b4 01 01 00 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 0>
> [  +0.000002] RSP: 0018:ffffbe1f400bbed8 EFLAGS: 00000202
> [  +0.000003] RAX: 0000000000000001 RBX: ffff9ed7c033e600 RCX: ffff9ed7c0647830
> [  +0.000001] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 00000000000017b4
> [  +0.000002] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
> [  +0.000002] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
> [  +0.000001] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [  +0.000006]  default_idle+0x9/0x20
> [  +0.000003]  default_idle_call+0x29/0x100
> [  +0.000002]  do_idle+0x1fe/0x240
> [  +0.000005]  cpu_startup_entry+0x29/0x30
> [  +0.000003]  start_secondary+0x11e/0x140
> [  +0.000004]  common_startup_64+0x13e/0x141
> [  +0.000007]  </TASK>
> [  +0.000001] ---[ end trace 0000000000000000 ]---
> 
> Not yet bisected which change causes it.


I am seeing the same on Tegra. I have not looked to see which change 
this is yet either.

Jon

-- 
nvpublic

