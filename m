Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011049.outbound.protection.outlook.com [40.93.194.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA432F0C6A
	for <patches@lists.linux.dev>; Thu, 22 Jan 2026 08:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769071413; cv=fail; b=axA5dqEI7j7ctxJ6RKYSyVDVlL7WtVMtVZ8bu8KZojtdPWU0mLSAROwSk/mdP3DriR4F3zBY2/rPEsIvK4UnvL+OaorWkhidPoCJNWl9ZZ6y24iYilmxqo0uXonPasc36VOfcT7nRORicqgJyXBo4eggQnIIC89HHsabeMt6Sp4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769071413; c=relaxed/simple;
	bh=jSmQk3yBacj4P5zu1DkybveI+1SxUP9veY4KPQxcaWw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=NREuzbPSfUJMEccn6VW4FVgnW000hEUMuSi/5ryELDHAH+DuWPAUL45Tbqea9F0Gp+vOiZJ1n2STgc9ViBEK8OROUNPzsOWMM6jnBRBV0DAXqiXU06GGUAPJRg1hvWpV5rs4xLExV0QfLYSqc6vq3yQr9x4jLTr1cvrpOgdWyOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q7Zde8jS; arc=fail smtp.client-ip=40.93.194.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q7Zde8jS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ABMXSm0s8VadSfQXv+pqVGFZd6E3aSaib4qyA28zgOa1VwhUazl0gDf5wR+kvA1bAN7pdM/XupPZegiOqeGpGYFAKxbeeny9lfnu6ypU+qrUmE7Q9ENjfmBGofwZz3qNyYk67nFfxVlZCn7jCDBHQ3UYlB7RU5t2mV+dTnFVaJU3OGPQmwKVEh64U2rdSS1sVz+9/qA8se5hVeyCJfJobDgcT+bWxWGCptm1dQVnxJ+N73Pkj0aTpTokal0tYazh5ee7BPQ4/NE4OTJFDa14HGTsmrS2LTnOW+CaMqrJr0ZxrLplHSiE++651v1dQ9yCLZLh5nM/rtjZN5tjirGntg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dOT+LYhSE5KuoaPAx6pK+iFS5QEznFQWclTlrYSYlJE=;
 b=XYv0uNeNPpWlJITxrmtJt+C6HlMhubb73pmmybStLMPtWedPxMbB2La5mr0ufB7TYQzpbipq0fqYgKcnirknqoa4WAbWd0nY2oOGiyxPSYSy7Lp9FCHbcqqeWr2rjZw4p5vu/APtQn5uebARK73Z56cWGX/88Qd/4HCh9pECahoKK4gqqvrFNfEA+AVJXmNweIJMpwZ9xja5efezqPD52Lpvr3ibm5jy8v7EHnY46COZu6AOYHXUAA2RwrhwpetC7+PHNVF4DDbHxi9UGRWz66GsC1J0dllh9oEIY5XQb5vTpBGK5qJ/swG+qvdJYx8oiUlnUkUMtqDWQBGb5PHGNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOT+LYhSE5KuoaPAx6pK+iFS5QEznFQWclTlrYSYlJE=;
 b=Q7Zde8jSrTuCBmRWA/FU1s7RlHwxMCsc6g6lsq93hpyv6x8e7cQUaaU7VMpQjp+CIev89UyfPKm6UyNJSfHy8G+uiHdkveCYpXhEkOkGX2ypGIPEjhRIMV2VATUiHeKtJa+e/gXkp+rp3D2Jyq2lE3Lgggc7fx1is6fWZUKSsCvJcRwW3rCXDT7pgt+nFJhc98o/xNxsY5PQ3rOCQDXkrOA+QTn7KXXtqLWlFBczunYBnMePcclR9l+pLc6DyFA0ey4NM9uxymXQ1khr2s/AeiAiQ9iyGF7Xc8OjeahrSYLaHWyftum9TI1zOBSh3Py/IqGuDwrs9pS7kXdu4hndaA==
Received: from SJ0PR05CA0044.namprd05.prod.outlook.com (2603:10b6:a03:33f::19)
 by IA1PR12MB7615.namprd12.prod.outlook.com (2603:10b6:208:428::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 08:43:19 +0000
Received: from CO1PEPF000075F4.namprd03.prod.outlook.com
 (2603:10b6:a03:33f:cafe::7d) by SJ0PR05CA0044.outlook.office365.com
 (2603:10b6:a03:33f::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.5 via Frontend Transport; Thu,
 22 Jan 2026 08:42:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000075F4.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 22 Jan 2026 08:43:18 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 22 Jan
 2026 00:43:00 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 22 Jan
 2026 00:42:59 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 22 Jan 2026 00:42:59 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.12 000/139] 6.12.67-rc1 review
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a78ea061-cfec-46d3-9247-918e2a19ead7@rnnvmail205.nvidia.com>
Date: Thu, 22 Jan 2026 00:42:59 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F4:EE_|IA1PR12MB7615:EE_
X-MS-Office365-Filtering-Correlation-Id: 3163791c-8d03-49df-0021-08de59924aa9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bDVKTG1OTGw0UkVJUmpqb1VJM2lqMEZTVmlKVDlCb0x4a2hNTnovdHcvRGt6?=
 =?utf-8?B?TDYrUEltaTJLQnZQRW5wcHVMQmVVQXkzMW05dkZCOXhTYTlJMkZVZitDYzBB?=
 =?utf-8?B?OGZYdDVxVGdVTWU2T0JvdVhuaXhlVGFQQnJKU29pcUVicFlxOTFqYnphQTQ5?=
 =?utf-8?B?ZnQzVTJyL0ladXdMaiswVjJUNGxQVEc5dkx0WllCYS9KamlzWFc0eTNIYUJG?=
 =?utf-8?B?bmR2RkJPOWJlU0x5TmtRYjJEUUxKbjBuamdyV2pydFA4Ry9vZjY5a0RaSU9L?=
 =?utf-8?B?NUo4WUI4ZkNEY2gxWGtmZzg5elR5ZEhIVWJyUkQ2MjJjZzlrUnV5bEFqamN0?=
 =?utf-8?B?TmdGTXRFU05tUUszRFRlWGtCU1NQVEZXZ0hqTXFBc1RtTlc2akdRckxqcUpC?=
 =?utf-8?B?cTA1SW51OGRJQ3ZIazQzT2VpdW1EM015RlhuamwwdG5kcFlKLzVZQXZNUnR3?=
 =?utf-8?B?aUJUSFplMUVxamJWYVhlNEFmdlg5WStwdkE4WHVPN0Y2VmQycXpaVklIQmVL?=
 =?utf-8?B?YVRLZmpiR2kyeDVvNm9ZV1lxb0F1bFQ5UTBPUWdFdFZBdUZ2bmVHUGt2K2pz?=
 =?utf-8?B?bVdvTytGSnlnM0lmZlI4ZE1rVng5NTUzRnlseldRMi9vS3dBbnZ6U0lSODRz?=
 =?utf-8?B?L3FQSElwY3ppNGIrTWVxU1FVRWhYUFRhek1zZ3NzeTBwcjhFbE1raDA0K0Fs?=
 =?utf-8?B?WjEyVWJFZFN1OEt1bThTVTliK0FLQ3dSTjVlWkZrVWJjWWQydzZVbkxoUXlK?=
 =?utf-8?B?QktiS01KRzFvdVVNMG4yZlNLR01ZcVNBMTlwRTJBU0ZKMmNuc1ZRaVhEYTJo?=
 =?utf-8?B?YW52a0w1ZFY1L1hVUFM1a0NzaXlJNUJybWVwdC9abHBDV3dWK2l0ZzlDN3FF?=
 =?utf-8?B?eWh4cG9kcVN5MUpiRFZoYk1SckhRZitTUzRvdmE4WnFyZVUrc3VnWFhiMzNj?=
 =?utf-8?B?VEROcDBKSk9HQWduMG1ENEI3Qld0VzcwWis0ZkhtRjdCcWRuOXdtRXRTSjFZ?=
 =?utf-8?B?c2xjSWpYa0RFTWFTRTIzSGlnZS9HOU9uWHVtVWszcDZ0bHNvaWRJNEptaDlE?=
 =?utf-8?B?MURJL2NvN2RyU0EvaGgyaXpoSXl2bW9FUVc5ZnUxeVU0ajN6cWJIb2lRdXZX?=
 =?utf-8?B?aGdIaXRZTFJyTXRSOGF5YzZhL2Z4ckZpTXpNM3pyd1RUWC8zbHBRdTJ3S3Ns?=
 =?utf-8?B?amM3Qlg5VGNWSk9Xd0xXTUk4NmdQdkZxS2Z2V2Fvc2NnRTNUNUR4eTduc1BZ?=
 =?utf-8?B?QjdnY3d6VEppRXVpdFNwR3JuREdETkk4ZWIwbzV0bXJhU3ZMRXhmUU0vSHdz?=
 =?utf-8?B?VytqNGxqVlBBNHd3VnRmYUt6cnJHSEZTekFiYW9CK29saDNJQ3habS9BRDls?=
 =?utf-8?B?NE45cmZKbGFZVnhnRExUUlZ6cy9IUkZ2RU45T3dhdXI5eGxWNUdVa0xqemt0?=
 =?utf-8?B?bjRKWENCbHdIVGQ4c0tmTTBuMENWd0hqTlJid0Z5Nkh3YVhZNXhZVmRFclFF?=
 =?utf-8?B?S2pkUzJyRnlXNFZYN0JPVGZyd1cvNVBreVJqWHdtWUlFWEl6N3c2cXVKdlZV?=
 =?utf-8?B?UEMxa3Z2b3FtWnAxcUpaM1p4SDR1YlZhY3E5Q2E1dUJJeTVsTWRWVnZjdVY2?=
 =?utf-8?B?MjFLK1RBS3lsczRxU2t3YkJWMzRydmxaTW5nSzJtM0MxSWxYcVFTOTJINnA3?=
 =?utf-8?B?THhwdWd0a3YxclZkeEhjY3E4RlVlRWRDTUQxOXJhSHVGVFgrdDNsSS9hay90?=
 =?utf-8?B?Ny9EbWV4UUVMeWtFcmVzd3djdEpCQVgrN3p5djhiREJGUHY4SVBWRVFwcEdP?=
 =?utf-8?B?azlhcXFVaXJHRVVmeFlIdk1CbktRWGZsOHN0M3VpWFo5U1NrWktqSkdUYW5s?=
 =?utf-8?B?NlN1bzUrYyswdjY3V3RPazY1MXpsbC8yelJlWk1ZU2lBREszT0tQVWVBTEVx?=
 =?utf-8?B?VUVNL09Ic0RxbHdLZXpxV1pNeWZjeFRWc295K1ZvTmVHWWk5VFUxdFB5bGhx?=
 =?utf-8?B?cHUvV0lCRHpGQ2RZbmgwaU8xdE5UdmkyczI0L3lrbm92K1dVa2N6L055RGRi?=
 =?utf-8?B?QjZ6ZzFIZ2dwVis2K1cveHN6emdpYzRZU3RLaTZ6QUZUZ1dQd2xlY1RSRVJR?=
 =?utf-8?B?SHpRL2plRU9Zb3ZLTituSXhzZExYand6WFJRU2E5bnFEVU5oUTNacFJ6azB6?=
 =?utf-8?B?SHZjS3RGU1Z5RHJ4NGFTWUhRT1NkdDBIQUh6UkhITWVLeHpyaklKRWgrRHZI?=
 =?utf-8?B?a0R2cmZDQ1dEOWdNODVpb0s1YzRnPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 08:43:18.4771
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3163791c-8d03-49df-0021-08de59924aa9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7615

On Wed, 21 Jan 2026 19:14:08 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.67 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Jan 2026 18:13:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.67-rc1.gz
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
    133 tests:	133 pass, 0 fail

Linux version:	6.12.67-rc1-g90b48e374092
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
