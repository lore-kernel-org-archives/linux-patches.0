Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013004.outbound.protection.outlook.com [40.93.196.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89670272E6D
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 13:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759583930; cv=fail; b=d+duSOWYcBGlTVRQAoORWY0OBDUI6etnmGseTrKcg77HbgWLzfyOTDSBDHFijBFEsKLWUTwpboSwxjwmOoo0GuEwuiNecqUs3dc9SwjY3d4A5vNqnk2lWW8iIXJdn8xsBrYavIvQNnFBH23acSSlSNjipnTQRYQ9v164byq/9Sc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759583930; c=relaxed/simple;
	bh=1b12hc8wCJ6bE4z4G4ejS8KRv8ITJ6xFPpbWmhI14MY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Mtcq9qSICkWQz4P7xHDpI1xwXflf5MeLpCZxeyR0neYCWvPfHXOMs34aaesrzkdiTA5Eq8bKnuMcIbEeovjeZkBgOLt4lQ+9hlI53bnj9zSrvhOa2YBdTcrogi8sQeSHtnW63hd6uahO4RsqM5mmCrwrbBxDc6u1NI7J7bk4/js=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=biqHlEYF; arc=fail smtp.client-ip=40.93.196.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="biqHlEYF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VjY4UZ4IC1/m8I34YHS0JnLQIY9mbjmciZwlfGdC+3ggIHU7LpJDFwb++Sei8OA9eZN/PTF+QvfvqVfGbXjJ+CqeJOArOuLi7fMJRGpgqDdmBlHpOMTqhr+iUMf/bhyxDhoVadBSFO+sPty9lY774ClgjtLUXfkavAsgLEWC6ku971tRIBe7qVPUlpiQL0OhAcr3qdDEqhO3h/Cf9j8dvT1NVHi9AAMYVIo2UH61a7fvkfxXctqeHS6y9+LdD4LgOvV6zy/gRLy3D/n41foBL383DZmyk43UuO7/Ef7qfZ0spVrN68alVLoWtER1oXotpI+4OkyNLqXggWLXFXIvaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1hR0qDWizmK8Hn7wA41eSZ6N5oYvIDuHFluIDXhvb30=;
 b=l88WvdqEGS/ZCV8TzC+8j68p2DEAGoE81J24VkY7gG62p6RuQFGb6pFFhFklX/ktk7o3+gZbx1UPjqih+6QeOVnfoQBxYgNhq1S40XlFGB8uQwWkqitgcEkLSihRGvFMZvRiYme4Di+2ofW3apZ21ndC3Ny2KqAMohSy9t8bAuYnUSR3y4eEQk+TRqAsKLOxT80ENGRzTl4D/N4P1nt4eCF0vsP+WuoSybqEhXBC8WyqfqriYO9sgAGYgy6Ehd6JqUeITBo0pwsYAT8bKjvAkjOGSM1tU31wjmLoK/u+UQvQ93JuAZ4SGWShpaO2/oFeoXGs5XXU25ludJmVj2deNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1hR0qDWizmK8Hn7wA41eSZ6N5oYvIDuHFluIDXhvb30=;
 b=biqHlEYFUxHbYBCJUB+GvyVHRmj+/EfXHHrx23mNqi5y0z6HMkcrR5ddSFsFSEvZ6RRVIj1jpJ+iuHyypMvrg/WJEjXK1JtX0WSo4yUSi5ArQJp5gfX2uXZpOJLjjSLbTvdPKxfjkUuTx5NSr0IkCxCe0+6CdvbSZl5x/4NwoEV48kwNnUKbi6xVTVGhq9r3SGIZvCQq8lflfFEqvb84p8rnUmUn5VImHdhbfQSBUlIPK6mUnstGSCjyYWTusmd/MDBo9Ifn6/Ckc5rfnUs4YwYzuLZOvNxaNhl9ky1dMWjxbaKKY0a7grsfBkaESLRDWNJjdxUCUZrYDmHdGMZcUg==
Received: from SJ0PR05CA0010.namprd05.prod.outlook.com (2603:10b6:a03:33b::15)
 by CY8PR12MB7170.namprd12.prod.outlook.com (2603:10b6:930:5a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.16; Sat, 4 Oct
 2025 13:18:36 +0000
Received: from SJ5PEPF000001E8.namprd05.prod.outlook.com
 (2603:10b6:a03:33b:cafe::41) by SJ0PR05CA0010.outlook.office365.com
 (2603:10b6:a03:33b::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.6 via Frontend Transport; Sat, 4
 Oct 2025 13:18:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001E8.mail.protection.outlook.com (10.167.242.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.15 via Frontend Transport; Sat, 4 Oct 2025 13:18:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.34; Sat, 4 Oct
 2025 06:18:26 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sat, 4 Oct
 2025 06:18:26 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sat, 4 Oct 2025 06:18:25 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.12 00/10] 6.12.51-rc1 review
In-Reply-To: <20251003160338.463688162@linuxfoundation.org>
References: <20251003160338.463688162@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <4c0d02f5-1bf2-4ae9-a0d3-126789d1eaf3@rnnvmail204.nvidia.com>
Date: Sat, 4 Oct 2025 06:18:25 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001E8:EE_|CY8PR12MB7170:EE_
X-MS-Office365-Filtering-Correlation-Id: 86e4b2de-1d35-4951-7932-08de034886e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eVBJQ1cyMkpIT3NDbmt3Ny9VeEdqa0cxYm4vVjYvbDM4bmgrVzBlMVVhSGg3?=
 =?utf-8?B?ME1uNXplRUtZTTZ6US9KMXFNU2lOMklROGNRWTlTcUxxZXJtL3BPRy9FQUtk?=
 =?utf-8?B?TU1OZjlCWlRzNEdmM3FjSnRNd3A2ZzBOUHdQNGNkNmhVcUtqREFFb293SE9R?=
 =?utf-8?B?QW5rSHcxemV5blZjK1BYNXhlWkdPeGd0UlA3cy9IRDNTNWZKQkczTGI5eDlG?=
 =?utf-8?B?K1FvMnJWcTF3MkxJM2N2Z0JhN2RINy9KdHVSOWJyTVB1aHBTWWE4Vm10cmhh?=
 =?utf-8?B?U3dSRnZqNzc5NkQ5WE1TWTJISkhzY2ZvaEtzTzVCSkVsRm16bW1rNk94anBa?=
 =?utf-8?B?UmJTKytrdDJFT2tqcDhweGVFa1Z1bWNqb21GamNLcThscExCMmd5NVFpVzVq?=
 =?utf-8?B?V3NHRS9NTzVEbGpuOVovS3dKTHY1eVMydmVwTEF4b1RUTmRPTUtWYzRkTEpa?=
 =?utf-8?B?NTJxYnJDTDJIRmJldlZZaUFTMFdHaUk5UUlWUFZzKzI0RHdGVlZvZCtkZEQv?=
 =?utf-8?B?YVEvYzJPMkNxSHBUTUtjQW5LVHhOSVdDUnBLbkxJekg1TStpUDhRUEhuSDNq?=
 =?utf-8?B?cEZ0TndoYksyRVArbnRMY1FpRGFyWkx3blUrUHNPTFJiRHNRWTRBcjZxRTl2?=
 =?utf-8?B?Sm5WTVBaVGt1K1FOOHJGNjFCaGplQnRIakZvUGNnTW82b2dXTHZUcGFSd1JL?=
 =?utf-8?B?aXVvZk5vbG9QWEJLL3ZkWHk0aldoNzc1cDVwWUhYaDMzSTNpZ1M2WWVGbGhY?=
 =?utf-8?B?bXhJcGkxNTFSSzJNL0xnQUQ1cHBZaFpQZ09YbmtTRWZMOGFGRGJqMDk0Mytp?=
 =?utf-8?B?WkoyUEtha0kxblJXNUlOUHNtdXlUYzErbzNzMzY1d0FFMFFMUGU0dndKVFJL?=
 =?utf-8?B?VjM4Nis3aVJZRXhIa0Fxb0NqVEpMSVBka3dXcVJVTzRRTGI2WWZGekVaWU5N?=
 =?utf-8?B?VElUdlRzT2NBZXdZWDVkak94Y3RxYWlqcHh5U1JreVdTcllUbnFaQWdRUk1Y?=
 =?utf-8?B?N3BvTHljcEZhN2lvMmpibkErUU9HSXhBZlVJYnoyK3hoR1hlcU9uVWFySUkx?=
 =?utf-8?B?U0MwbDEvOWp4Y3lGaWZieDYwR2FZT3lDOStaNGduU0wvSXFrZjg1NFI0ZjM0?=
 =?utf-8?B?eXpyN0xEQktFdjdjakI5b3UrNnEyc0t2c1E0SmdFKzRWZi8ycTBHSzUyczdC?=
 =?utf-8?B?MTQ4Umg2OW8xWDdUcC9QWHlqRVpZVkZIRFBrYUI3SGxIN3V2U2tkMFBVWGg1?=
 =?utf-8?B?bmI4dFFWNHREZjZtRm1URXN1ZHkxb1lNWUg2aVpac3NFbkoxMGh1STZqUjY5?=
 =?utf-8?B?SzBLMTNMZGV4YUVsYkZ2OG9EZUM4TFFZS3orclkzWTdXRzFXeS9rVWVmdkto?=
 =?utf-8?B?bnhUU1JUWlNCdi8wNU0vV21vQTZtU0Rnb3huRTdoQjk3RzdNSVhvL3RIRUlX?=
 =?utf-8?B?SjF6V3FEQ1RjRWxNckUzTVB4Nk1tQXhNWjdpczJVTFBHeE41N25uNGpMSkZN?=
 =?utf-8?B?ZEM5SmVvOHJDemdRNEJUODRVRzdOWlJLbyt4NmJyQ0lCR080cDFhZmcyc1hu?=
 =?utf-8?B?b1pXS0RJM2NISWtTQm10emw2RUtuS2tDR3hXWlhROUlIQVM1MkVWU0E4TlZV?=
 =?utf-8?B?YkFUaFZqTDNNd01QZ3grR1h6bFEzQWZNbHpUVjh3ZHpVYnhqZVNJaFZ4SUdi?=
 =?utf-8?B?bXhDNkNaT1JwWlVpVE1YMWhHVHk1bW5IcUdlUzZGbkJ6LzNhVWgvOWtpY2l1?=
 =?utf-8?B?MkVvdnRMRUlSRDgybzhwb2ZTR0NQYjUxb1RvZW5UMTN5ditSMUZ0cG90d000?=
 =?utf-8?B?WUp3NUxZWTRDWExpb08vcEtWOGZEYmw2WmtuaVdKU1lwRE5CSUFWOHpDdkNw?=
 =?utf-8?B?YzVJZi9jM3d0WHhGSm1JM0RkdFJPMXRrNzFwYW5yZlhPdWNPR0lnRjU5YzhE?=
 =?utf-8?B?bjlidkh5YU41YXNsUERNWmZnbkJ5MHowT2dzUlkrWkcxL1VBZ1JmeXkxTjVX?=
 =?utf-8?B?c1N1ZWlXdVUrd1YyeXYwTHVrRzlLckNXRWhUTytEZktadFZ0VTU5NWNFWHpx?=
 =?utf-8?B?cHVEQXdYTlI1ZXl6YjBTRXdLYXVKVjIrTFFkVXRqdnNPNHB1amovK0xSaUtT?=
 =?utf-8?Q?N4AI=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2025 13:18:36.7462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86e4b2de-1d35-4951-7932-08de034886e4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7170

On Fri, 03 Oct 2025 18:05:47 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.51 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.51-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.12.51-rc1-g791ab27b9c00
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
