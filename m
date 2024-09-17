Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2051.outbound.protection.outlook.com [40.107.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E00181339
	for <patches@lists.linux.dev>; Tue, 17 Sep 2024 15:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726586347; cv=fail; b=trWF2EucBh1WZotbmgBMfBVn/37kx8ug8o5WyOGiqTZKFZDLNGcMPuvtSRcehV3YV5+w4uLJNJj06mIv+d6l6kG50n6EkoWxsi8Hv69G2ZwNEM6yKVusTwEGU+xUa3ftNCeMh16CUMH0U5FPPn/qJGvgDZ9ywmRLQeYkMohr7ng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726586347; c=relaxed/simple;
	bh=owbWrF6i7iRL5OYUO4NSZWaoXXz3nUlrxQ3+RHi9z58=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=dm7ta3g8Fs3D3ndSmr2+43KgbREsV+euAWNBTCvOhFtIbMnGlaFZR4O6kxUho8UFEfE3RBY9Pkd7+swfwHhbFFyKDaLGizjBtfZ4UjB0nkRaYdtkbzuuW+tQGnrcSCzOsas5HqFYIizD/UEj4SV0Wozuji/i5EDiCGhftosyOZw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rOYgQhNe; arc=fail smtp.client-ip=40.107.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rOYgQhNe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f9xFXC5/k6WgHnZQPnpoJUzJKorh3C36m1lHR6eJV3FHo0P3mTrzwUYp3fln2QFBZoBtn7kBMPNo/iNOi3ssZtpdUpeBMYasRXf3YB6KIA9Lq/zBjPkDVd90fehf0XkONf5xeSziqZSpxwL6Xahv/nBKwXV+84hdaByKw++8bO9qgDGkdosgzYdQTYp4l3fIUXLNEaSlTuOHBJdQXGrjgoDrfnjPFlsaxFIvcWQTwXn0esE8U/QYxHVYtj9o8JHVR1TVJnkQKJKZAwHVI78D4eyqU8jOdLBthAO4JU71JgzVvKF1rYLQeIF7CWkb3ypdMMLyhJi8sD7vj7PUe2xblA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rCrjpHtsvM44uhiTQpk5iBFF6cx1MiGvPhukuZBNPso=;
 b=ZIT1HVvwM+SbqK+Cq4WYK+AgqqGicwKuSnZ9rQwJold3Y0ji1EncOmuGHvEFnejytZRu7hevMt8vGMyOai6SSgue/kzbuFlvFBaXYI1InLWbNPSmvLYvy5iv2k9aCElcsxdKEuM7FLRHlu1wXpjyNHtfJ+kXJVbOLwHs8wmNS2FhVXQjDOhfbkSGHyjkmnGUNR9Wv7G+zLbFH+7Xu9Ow4chq9vUvi1QPPJbXvuEQFFcS324Gn3CZLtgKQR4D5y0NRkm2Q1mEHyApN+u2R7Bd+HhQzbPWc8w5cTf8B2gaqFI8qAlt0kwbpiMLvk3KReZCZ0OgjFZqQxCCIigppFqlQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCrjpHtsvM44uhiTQpk5iBFF6cx1MiGvPhukuZBNPso=;
 b=rOYgQhNeyxma+r2XHMAHpuD2cPBkZEZ12dKJ4MduLJatByAM+jMFMkJV2n+HxScVOmhh0K6ZmP+9D56OPjvqTArzimUr6nf7JHRHaTiMLsjpBmeG3n8CmvpdI6KO2ZreV6i/gjd3MIUgopj1bEAFwCqmL0UP1P2U0tGYvFwbrJ13/rcHy4EwvY0uBDVTL/LAnZzVuQ+sNvXeddvF0nslGuVQqbUzVZ8PHQ4I5qS+mU/UAkD9d3NBPna/xJ/8O9o03n4qzU5vlgmx131zxWe77nTUjXInnTHEqtt3NKYKmqud6VSYTF2tK81SV9YmvGUUGUAePwsIupaoJV7SmNztVg==
Received: from MW4P221CA0011.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::16)
 by DS0PR12MB6414.namprd12.prod.outlook.com (2603:10b6:8:cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.24; Tue, 17 Sep
 2024 15:19:00 +0000
Received: from SJ1PEPF00001CDC.namprd05.prod.outlook.com
 (2603:10b6:303:8b:cafe::4e) by MW4P221CA0011.outlook.office365.com
 (2603:10b6:303:8b::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.30 via Frontend
 Transport; Tue, 17 Sep 2024 15:19:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF00001CDC.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Tue, 17 Sep 2024 15:19:00 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Sep
 2024 08:18:57 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 17 Sep 2024 08:18:56 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 17 Sep 2024 08:18:56 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <allen.lkml@gmail.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 00/63] 6.1.111-rc1 review
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e68c86d2-9a46-4539-863e-1a1e331a5e77@drhqmail202.nvidia.com>
Date: Tue, 17 Sep 2024 08:18:56 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDC:EE_|DS0PR12MB6414:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cd9e0ac-7a04-464f-9b8c-08dcd72c0eae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V0k1cTlJcFR2S0gramVOMlhXYUxQZUZzTi9ycnlKLzRQQ3RTeDRXR1VDT0xx?=
 =?utf-8?B?bkxmK0h3ak9QNThzR1dEZWJKU21TLzVqN2Q0dHNadkEraGVLL3Qzc2FKa2VJ?=
 =?utf-8?B?T09BYnJUYlh5eUF1M2VhakVqUFQ0SklwZlNuZmw2R1UvdVppUEN3S2ZraUEz?=
 =?utf-8?B?UlAzSkpRejBKaCtnaSs5REUrak9NSDgyVUZwaSs2MVB0cUowa3lvZUxYQ3h2?=
 =?utf-8?B?cTRtZFEyMFRtTHovaXQ5MG9IUUFDN0Z6OWtvRmppcGRKNFhSeXFJVVNJS2oy?=
 =?utf-8?B?aW5SY0pLdFJ6TTFGRUVnUGVOVmhJdFNOb2J6dk9RdGYvbVNhdDc0YlNPUnBs?=
 =?utf-8?B?QjlGcnBLK2RGWGhzU21PTVJIYmNJMHFhYllVRzQ1V2pWSC9zVjA4TDdIc0tQ?=
 =?utf-8?B?ZGhrVlhsRW1LeGNoZ0Q0ZjJmdGVOYjdVL1NYUGVDdzZnazFtVnNCSzR3dTJj?=
 =?utf-8?B?VVVWNXk2S216N2huTFBvWW5LM0xQMnFzTG16UE45S3hHMHI5Qy9waHgyQ1dG?=
 =?utf-8?B?aUp6WG5SdHFCV0dNVlJVQW1qZEVTcjF6ZSs3cTVjN0FFTEdQaVFFajVkWU41?=
 =?utf-8?B?ZG9XQWpuV3FKTm9UMTBBd3lMVkhYMmFjRkxScGlWS2xlK2lEU0M4UXJaUEQ5?=
 =?utf-8?B?Q05YZGtTbi9aSWJURHdQRndTTTB2bWdJaFdFSUlocG14SVpyUGhpeGdWVHF2?=
 =?utf-8?B?dVRIclRsVVlYMjRDTFMzSS9iYjJFVXFjbzhHZkxKMEFvcC80ZUE4bnR0em5J?=
 =?utf-8?B?SkFYWHhwMVpHSkpVRzFNRXRJU2haSkdoMWNQcDVSYlUrMERqa3MvNVFISW00?=
 =?utf-8?B?ZDQxRkQyOWV3bzlHWjhDV3hCb0ljL3h6Q1RKaUE2S0R3eEtrRzZHaFVUM1dM?=
 =?utf-8?B?U0RtSW10bmk2SU9oVkY4WElwM2ZydUJabEtnVkRZQlZJVFdJVlQveGtKMVpY?=
 =?utf-8?B?b3ppanZpeHRjQ09RU3NVZkJLaVo4NkZkaSs1V0sxNlQxcXE3cXBYditBVkVn?=
 =?utf-8?B?Qnh1YkhxT1BOQWoySnRMTjJsMWRyRGhmMGl6RnlNbVFxMW5idTM1UUtyRHI1?=
 =?utf-8?B?aFFUUnpTUVNqcWpmN0pzNUVYblY0WWVsWE5tUXFxbHlzRDQ3WTNydTBSYlRO?=
 =?utf-8?B?aXdCd0pjbUtBdzVmL2dMVmVETmdVQ1ZZYW5uR2djQllzNkFGVjJuWWoyaDdt?=
 =?utf-8?B?Z2oyaHZoemM2bm8xWFJnS1dVREdLYmJiQ3dtS0Z0aWZzZmhjemd3MC9rV29s?=
 =?utf-8?B?TVhXc3BnZEZPWkJaSmlkT0wvNEFLcG9UMUpBa1V3QndhM21WL1hDRTVXcmpz?=
 =?utf-8?B?RTdhZDdIRzJ5R3NGTk9KbzQ0M2orTFJ2OStOVWw1dGZBUFRVKzJIVkFRd3BO?=
 =?utf-8?B?N3JJVk9KbWd5Q3VkcUx3ZDkzRVZhN1hwQTFBNHM1KzFzVS9YdjNoa1RuWGJ0?=
 =?utf-8?B?VndYR2F6Ti8xTGFmV2pWQnlZa0FYZnJBdGY2U2xMSVdqNXNyVjFLdjc0SGVi?=
 =?utf-8?B?L2ZVbmRKMmlHMVVYZFNlWldEYzlZQWx3NlcrenpER0puNW50UDNvRlRkbVlE?=
 =?utf-8?B?bmdrM040Vi83ejJzOWlyem5US0l0ZmlsRWhEZmpFVHZObmJsa2UvSFczU21U?=
 =?utf-8?B?MFZYYWNWOE1TSkRzUC9WQ3pvZkhRRTFad1VlOEJheDZiWkhMYUxIRGcvSk93?=
 =?utf-8?B?UFdjeUFzc3BRVWdKNndKQVBzZUJTUWlQaVJFQ3NabkxKdXBYMWc4clBMcWtj?=
 =?utf-8?B?RXNweWYyYXBkTEJqZFRsQ0lOb2FYbFVYVzkycHN5RlhxbkEwTWc3dzVmSUR1?=
 =?utf-8?B?cWFJZ0hwSGtOUzRsb2Y1SVhoRXBZM3k1UU5VWHBDUTVuWXZ6TTZiVVRwUE4w?=
 =?utf-8?B?dEsyaFowbjBCQWVBemlEODNwcDZCcUdkWUs4TFZVT1ZQYUVTZmJRQ3hHQ0hj?=
 =?utf-8?Q?8kpCA/TC5opii2qXs3gjAsgwfswVqOxE?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2024 15:19:00.4312
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cd9e0ac-7a04-464f-9b8c-08dcd72c0eae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6414

On Mon, 16 Sep 2024 13:43:39 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.111 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Sep 2024 11:42:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.111-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    115 tests:	115 pass, 0 fail

Linux version:	6.1.111-rc1-gdc7da8d6f263
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
