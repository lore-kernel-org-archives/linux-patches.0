Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013057.outbound.protection.outlook.com [40.93.196.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7DA47887C
	for <patches@lists.linux.dev>; Thu, 22 Jan 2026 08:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769071417; cv=fail; b=G4HfleASELgzGDY1pQEE3BZOI8aEiaSLj2Y+4hJS6Sir0XcQYDjQEJ3SluUe1q8bqlEDs6diMCZyQgj+LYpWejSIo82hr7uxFLNsT2EGp42/XfOTKRSyMZFVu5dBCQpsLlpC8p7+6e5o5YqxxSr4fToDkOY4++Typubz6vZDEG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769071417; c=relaxed/simple;
	bh=P4j/QKJwWg5HQVZQiw/9MYA6eZn+oKVVz6hueFDUebg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=VE9+5H9XE16a3CQN/mf3woRUITX2EJaGTKZDwZTNZiVo1LSJX/vpk5Tk7IY4Lpeq+I8c8vp/LoUXNYaT8LpvUxHhkMqHDhv9Qn+3BqUPfxTgoXpJKtSVF0McVZJXgQxFs7ltMN3KAMSJ5LOE86blq2ymIFBv/xHpSasbcmg3GJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=elZsdPbn; arc=fail smtp.client-ip=40.93.196.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="elZsdPbn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UMdpC/ZxgQQWtErm3NW3TesBuWyJus07jPq3MVJgfQWaN5rg13z5fj+w6SMRGbsQ2Oq7/3rvbvq5/8ptQO6f23ZhjlnZjvxd34bdKdIWVZOssK2x9EX08DRjtsee147h+If8ZjEB8dEUKtmyiDr7f2j03adNJd8PVGTiC75V5V51+Dwu/CaGdaUKoKThDMTzjtnByzDCBnxlm6NlFknswOcZcLZotdZb9fZzhePVY3j00COKnaoRxvksxXGdnmTsql3FQL24kx4hFLebt9+yTS1trA3ppcGXR6rSofX+jtEM2p3NAzd9WSP52MQEI+0qwRkRtwYIaTop0dhVFtilpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SVTuLGdddaRGDICH4OxxiSYzbnAX67XXz2fjVNIVDAU=;
 b=ow3ZaU+S2tyZS8RD3WR6nQhih+t+fjIz1l9NiIC1JUKKvvsHz0cNCzKldj2bS32WaLxxYJQ+0mOto9h03SIofAq3m2EZssrWrasSqM7j8CTfNqp+TgS7Qric4+1TveafWjWb6BCQAel1Pk3v7zXKT2fl2bOq7qr0bzIlJYlYGp0k5rMUfIjbUljnv2wJ5fveuxf41M/IvLdmgoPHrLYVy/s94apEhYfZ+tlcug/s4IPVlucUOcNXRSyHXhoqErMnAElxNl9TK7cfHX6TsLLfs+qiybiEWlOjxtJOXJw/gsVMKZKWPN2wwsRKChjA9hGgmRVdP2jqR+3gdTnVCe1WyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SVTuLGdddaRGDICH4OxxiSYzbnAX67XXz2fjVNIVDAU=;
 b=elZsdPbn5mLrM2OCzg85D8s83brNNdh1ml9HJQm4okFUnMpIpBn5YeUAe41eDSkcN7yzEgD/Nv3NOIXEaIqrIBW7GwG7Sz9kWqJJTM+sMvQZm1+yOKx1nfyZYljiN81BTigdB9Q8YOB6l4tXJ4b0R/ZY2quh5d++eT2AAuynWKd+d5pS7ztHQUDwNIfuIBU6yMqniUYUaS4HXKeWDzdpB4nxFnUvVXz3eRvqdjsc6ahs9Bz0fmSpK432Iz6NXqZaMpVQIcTvPGg9cPOyFF+YCT6jWdYSQNBe+a+TD7sVzzJgXm2FGCyGP0guyUsK1Zzkn7kEvxjlpbE6KmDCjEeeuA==
Received: from SJ0PR05CA0057.namprd05.prod.outlook.com (2603:10b6:a03:33f::32)
 by SJ5PPF28EF61683.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::98e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 08:43:30 +0000
Received: from CO1PEPF000075F4.namprd03.prod.outlook.com
 (2603:10b6:a03:33f:cafe::20) by SJ0PR05CA0057.outlook.office365.com
 (2603:10b6:a03:33f::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.2 via Frontend Transport; Thu,
 22 Jan 2026 08:43:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000075F4.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 22 Jan 2026 08:43:30 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 22 Jan
 2026 00:43:10 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 22 Jan
 2026 00:43:10 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 22 Jan 2026 00:43:09 -0800
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
Subject: Re: [PATCH 6.18 000/198] 6.18.7-rc1 review
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e08b34ea-a87d-4076-91ae-2525e0de3916@rnnvmail204.nvidia.com>
Date: Thu, 22 Jan 2026 00:43:09 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F4:EE_|SJ5PPF28EF61683:EE_
X-MS-Office365-Filtering-Correlation-Id: 364995b5-5840-4410-7395-08de599251b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WEhOSVg3Z1dHYU1PZ2ZiMC8rczFyczBpN0M2QlRrT3hhSzkyZWtXb29wSTBi?=
 =?utf-8?B?NFRIZVdlTlB0TkJhL3RZMThjSitXSmUxSHdXUWk0VGt3ZXFVa1pYbDRPYk5Z?=
 =?utf-8?B?YS9BSm9MUTFoUWRNOWpkM2U1OWd3TjJGd29XSHZNcVBzM3QySVlGbFkwMlFF?=
 =?utf-8?B?RWZwY0Nzc1NNcFpseURvOUxrenpySVdyZ25ranNjS01oMHNhN1dZTzUwcnVq?=
 =?utf-8?B?bHdFUnVSazNtYVJaZ2xGbzEraFI2dHZGZnNpeWRzdU5JallhZTE1cXJzU0VX?=
 =?utf-8?B?TGFUSkhSM0pVaVRkQXNIbHA1VllGNVdidnczT2xKcUUwd01BSFlZZjNUa3pR?=
 =?utf-8?B?TkVMbG5WN2VzWUsvRU5pVFdTdU83M0xZaGg3bGdZNEhuQmJjdVMzVDU2R2xG?=
 =?utf-8?B?VEFQdjFZV3c3TFZlY050ZXJZTDFmelJNK1ZPcUlsTHAvQVN1cEhGSGNQcitY?=
 =?utf-8?B?Y0JhS0N0eFcxZEJPdCswdFhTSXkxcDl5cTNtWkY4VGoxcGhoam81K2phMkxD?=
 =?utf-8?B?WVg3SWo3TEoxWjVCVFhOUVZPT1JLNnFoRW5iSGtsbGlROThEaDh3dG5YWXRE?=
 =?utf-8?B?ajZQSWh6NWZGZEtZdVp3ejl2WFJmalQ4SkxTK1dGMFJYeDhCdVZQVGVRTXpy?=
 =?utf-8?B?WEk3ZnM1akxmeHFwUmtPN2MzQVJ3YTNZbFBhSzNNQ3ZJZWxwL0pXeVdHS2ZR?=
 =?utf-8?B?TjVVUmNnckQ2dmlTY0lRdmlxSHdvRW1mRWJyeGwvKzUxNmpwYUpNeXV2b3ho?=
 =?utf-8?B?cHY3cGNMZzRGNzhkMXk1U3RkN2liSnBvdEtqZkVsR25zTkpxRFE1YjFjQ0Rv?=
 =?utf-8?B?d1VLSm8wa1VOVDdXV3RVZWpsb09pbnN0VnhzVHQvRDl0OHVVN2dKVUw3Z2JQ?=
 =?utf-8?B?NVk2UXp1aTlzK0hwNWMvdUtiZTVGODZQSG9WbG5FS2F4Uk9xUHEyUVVVSFZs?=
 =?utf-8?B?d3pXVjM3UjllM0tKaGtKWXJDRGV4c3BHcTlnbVRNSWNBYU9ic0ZUaEpDdDhu?=
 =?utf-8?B?UUhlcG9wY2cvR3A4R25lRGdpeWo2V29kdEZyR1hEUjQ2SlNlVXVlQTArVVIr?=
 =?utf-8?B?Z1VDKzZUcUhrR1NGa282blFvaE5HczFONXZ4azhtRnl0SHRvUjBGVWpUS0RH?=
 =?utf-8?B?YThNV2VKdm04ckxtanp2RFpEa0JWaGsvTElUdEoyTndiaXFKRExNZGJqdmJR?=
 =?utf-8?B?enVwSC8xekUzbUdBbXVXQkFvbDVDWHV5dzJJYzNUV1FtelZLMmw5RzRuSG9V?=
 =?utf-8?B?dytQTWM1bGF4bUlHWkRiU0tLVFVLK05jUkxhb1dPaUI4UEVLRWk4WlZLdUZM?=
 =?utf-8?B?SzUzMWE0ZEM5UENsd2crbmpWaTZkaXhCTDVJM1NhWlJ0TGp1TE9RanF2UTNw?=
 =?utf-8?B?RSszSko3NU5HVnNqSFVlNXFTdllTM1pjS0JWd090UStpMk1KTGt4alIxZXl4?=
 =?utf-8?B?Mno5elBFWFo0WVZGU3JsdS9KMzNzc28rM0VuRm95dHRQL1Z6UDdwc3RCQnhE?=
 =?utf-8?B?NmRoU05YTGJuM1cyM2RoMHMzUTNUU0dmYkpVY01sMHNjYVZyV3daTEU0M0N4?=
 =?utf-8?B?T0FVN0JobTBtQm5wKzlqQkp3R0Y0MERkR0RBT1FaYlNING56N0pkU3o3R0N0?=
 =?utf-8?B?VVM0QUZybmcraXlXd21vOFB3Tk1pMmd4Mkc3azNHYk4ycnRIK1VXcHVoOVRY?=
 =?utf-8?B?bUJFeFdOcHlaU29aeVRPZm5Lb09VY0dvaG9Gbllxa1p3MStpemtWN245Y2lK?=
 =?utf-8?B?Nkcva3FKa2FlQzJUK01ta244Q0xyQU5vVklxUkZnUnBrdUpuL1B1ZEMvWG5u?=
 =?utf-8?B?VXhjQjBlR2c1QWFUMlF2QUQ4dU81bjJsWGR4V2ttbzdHQU1sT08vbUJWZENN?=
 =?utf-8?B?eGF5aXR1TFBGYU5xVzlaOW5uOE52dVd5UlJ5eCs2bXVwbWVaS05lSFl2WVNy?=
 =?utf-8?B?NWVoeVpSemV6MUJKN0liMmhibHVyYTZKcXNXVzdObm9Ta3ZraGg3SStpZlRN?=
 =?utf-8?B?VTcxYWNXcGlnYlB1WitxdlorK2JzelNtSjF2djdUU1d0UlVoWU9BR0VWeG9I?=
 =?utf-8?B?NFg2azEySzlNWGlFV0JXNWxOSi9Mb09oMXJTd2VvVWVsVk5VTkNGRWJ6SEZS?=
 =?utf-8?B?NHR5QkZxVHlqMjFuOE9LUllJMUgrMnJWZkZYb0ZKQnUvVkUrQ0M4c0xqR2oz?=
 =?utf-8?B?Vyt6VzlFRW9KOEFHQ0VSNU5WR0YyMTYzY0IxSjZzN3RoeStyWGJJV3Z4MmJH?=
 =?utf-8?B?MXlnek0rakV0ekJYRDFpTXpFeTlBPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 08:43:30.3053
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 364995b5-5840-4410-7395-08de599251b3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF28EF61683

On Wed, 21 Jan 2026 19:13:48 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.7 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Jan 2026 18:13:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.18.7-rc1-g28a73c31d7f5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
