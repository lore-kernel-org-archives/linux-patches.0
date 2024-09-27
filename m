Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203271C0DFB
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 18:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727462196; cv=fail; b=ioLfLbX2KzVZbRobaMdHuMDmO50yFr4UzrLeNwYiiAu0ygMywjzeASokfc7TMsAgJWunT/yxjatdNOBjQgWRnCt0m8laADFkxFFTbMPGioQfc87fo2XB5hedRp5x8ixAWYryPjVGHku6hrqIM39fAk/jVs0VusnPpfFVbbg+3EE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727462196; c=relaxed/simple;
	bh=m2PTaGwtc6XnxJXfnC10xZ0rH4WzOdJbnc6vD4vDD1o=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=pTAqC1rE/ECJ6AXTjMToCdrGuFxBtJ9XO3v19EJlv1qINuo8jwbVWUZ3nICjZeJYwrK7rKYSrYSNU+nSKFriAMBZQgv8CdBBPVa2pNJOstBgR7ZnqmTKrI1UJ9squDNqslh3+PlxSIOA9zVRp8Rx8EDZNDt0aATfUy9dhOyPYzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iYrtLT41; arc=fail smtp.client-ip=40.107.237.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iYrtLT41"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=udfPCISvNxGfLZky+J43+0GbKp8fFrjE1Y4r0OgsXW0B344t/W9OYmhJ0g1FVRM/6/CsykBIzeRP+SMjQS/uzF1Iey0q+Xw0r6/xzvs4RGLozb2yccekbyXgWbvPcC/two/rmxHdebxaq4/9vrjwSpObg4nbYVW0Bd2hugMoFt/9yuUuoF+OH7SwnEqoga+Hc5/tojhPfrTotAaPrJad12lA24QAUt0geXwFH0ouim9WaKu/HEECNE7UdaOn4TBmw6xvFIqEwL2+zQZI31rdJx6P4qU4ODtlCd6O1YBpu0Vn+/KTV5C/Dqafh2y8JCd4ATYLmJIpdXV4dCrTP+nf7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MWPmMY95lYr1xSUuWkqmNbOASuNr7b5Dymx2Zxvvitc=;
 b=yJDncoVwT6n6T2IVgDurEJ68ppKg+5njZEt4gZGoa461OqSTMq/2hp3f0JA7CD8pvj2g2OrF7cyZroNRhQxmC1ikCbcfEUYgQa2131gS+gPidoqvfwRtFowvbvMuWE8tx4hdy3rFvU7kg3wjm9lnMDxU9ny9kRuGqRbHhfeeKQsrGZaq9Cl8Yhg7M5zJsDg7XC41Y5Ae/t+7qEeLUVpfvE9ednE6v5ctBMYxfDtYBZvx0luRYcKHkjxQrJCtkWhSS64dxxITV8Hj4iynxMc3qiQeYVG/6jUrNuRnRz0/uL5fDixbMhurlqguUu1IfdzBp3Ad1R3B61wmA9tfYtSEvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MWPmMY95lYr1xSUuWkqmNbOASuNr7b5Dymx2Zxvvitc=;
 b=iYrtLT41gHQ8fTzQF5MJuqlPFdQFYA/FLXwBv03cl5BrByUfMTSkN3KGr2SnBD7BZz62EMiCzBALzU4LxR8Br62UbrTIy80vXWTNdc/U0aoD82FDpWZJWkaR5OMJbYmEi5fpHT88dV21fg6h9LiOYpuwrEmKRSJr1VWjg8SUluMrqMLcfdwM9TBAiXyEmRkCS6ZpOnH0nJ5/tPspojYv7pTQlClWPga1XI9LJuQKT97AdKSXsn6NosXsjvQ7RC230an9em7p9jpeGEz0yi+cTFDE38GECx2i6f6Dxpo5s+0oWXqAuMJtpbkgWcx7ZGrso6tHpgyKrT+YgOIhmeXBHQ==
Received: from CH2PR02CA0006.namprd02.prod.outlook.com (2603:10b6:610:4e::16)
 by PH7PR12MB6442.namprd12.prod.outlook.com (2603:10b6:510:1fa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.22; Fri, 27 Sep
 2024 18:36:26 +0000
Received: from CH2PEPF0000013C.namprd02.prod.outlook.com
 (2603:10b6:610:4e:cafe::e1) by CH2PR02CA0006.outlook.office365.com
 (2603:10b6:610:4e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.20 via Frontend
 Transport; Fri, 27 Sep 2024 18:36:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF0000013C.mail.protection.outlook.com (10.167.244.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8005.15 via Frontend Transport; Fri, 27 Sep 2024 18:36:26 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 27 Sep
 2024 11:36:15 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 27 Sep
 2024 11:36:15 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 27 Sep 2024 11:36:14 -0700
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
Subject: Re: [PATCH 6.10 00/58] 6.10.12-rc1 review
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <677f4279-af1d-4bad-9f01-70c47e60b97c@rnnvmail201.nvidia.com>
Date: Fri, 27 Sep 2024 11:36:14 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013C:EE_|PH7PR12MB6442:EE_
X-MS-Office365-Filtering-Correlation-Id: 3266a1f0-5f7e-4350-537a-08dcdf234b87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?enRtbzlUR204NHdRMzlIUWQ5bjRSNVMram50UDFFQitDM0VCUGJBRHhheXFV?=
 =?utf-8?B?UG90c3JwNU9KWVNNcHRHTTJDNmxydHF6SS9ZbnlubU4yVlF0MHVNeU9Hd1Vh?=
 =?utf-8?B?WTNXWWlMVUNmemlmSjh6b2c0L0NRNkwzeXE4aW9zcERaekNGZHcvdml3VW9J?=
 =?utf-8?B?YjlMMUVxclUzNWxEQnhCaDFXd2FSbU1WejVnNnA0TFd0UEFydXBnQ2NRQkE0?=
 =?utf-8?B?RGh2TlNUdVZuTTJQSEk0VmNaVDl2eVRNZTNuS1pmdU9hUmRXZEgwUE5YL1lQ?=
 =?utf-8?B?TVFhTTJuVzFHYVJ2MHdOczVKZjA4NXFkQWVoMEtmci9nYjgxTjQwQnRNSEto?=
 =?utf-8?B?L2VSOG1QWWZsMmJ2b0ROdHIzcmRMT2xTMXFTT01ETUtrN2QzbktYemd3cm1n?=
 =?utf-8?B?TjR6em9IN0htaWhHRkxZRjdNNHpsY1RVVTFwZEcwdlIrZng0Q0s5aWo1M1VR?=
 =?utf-8?B?NW5iQU5rdEhOTjM1MG1pU3VZaWhmUjVuR054dExsUVBobjIyN1JlR0hqRDdR?=
 =?utf-8?B?WkNsTU5BSy9RdmI5Ykc1M0J3Sjk4bjNDMEFzWklOOUZDbklrZEQ5QldRK05B?=
 =?utf-8?B?ZUZmNE9rbWp6Ynl1SjVWZTc3MXE0NmkxTWJBVXF0UU4yZGJGcExWayt3S3V0?=
 =?utf-8?B?dnFDREtTTGd5NmJKS3ZJMzBqdDRBZnkwWFZrN2JvTXdZWWxvdXI0Mk50c0cr?=
 =?utf-8?B?eEd4OEJ2NHNXeE9yY2tTTVNHdDVaUDM2MzdCY1g4UCtjWnZUWTlxWkVnUkk0?=
 =?utf-8?B?eU8zNklxQ1VTWWZIVy9iZjFDMUZVaHVqZEZFZDhKMnNxcnBqL21uSy9LS1V5?=
 =?utf-8?B?RjhiK0dGQVJMZ1BLV1QzRGFVUkZKeXVSY1RZKzh3UFNieTlaSE9PUjloRU1m?=
 =?utf-8?B?WlJ3Q0hyaTV3QVBwYi9IemdMQlBMY0gwWTBwVmdTcDBTQkZ0aTZGV1FyN0xt?=
 =?utf-8?B?c2F4WnM2bWdxaUVaQ01zRTgvMEhRZVp3d1hNZjhpMHFzY2dmdHRhcnM3em5r?=
 =?utf-8?B?M2k1amU2TmhVSVhDQWFnU2tGaTdjMDNSSDFYSVM5bC9vVVRuS1Vka2NBUEUr?=
 =?utf-8?B?ZzYxNDVyODFXdFVBSGhXaTY5R29sajJvTmVXc3BwRGJtdFNRdXZjUHhYdTNP?=
 =?utf-8?B?QllOa1NyaHZ5VWFyQllsZitBbmxBdTdGcFllSVBuWFJlS0dMOENyUHVFUjNR?=
 =?utf-8?B?THNBbXhIOVI0dk4ySWs2L0IwUEk1RnZDWmtMclJMY2ZuSm40RDRBZ1RxTlNF?=
 =?utf-8?B?NGw5R2gyWFNkNTVrYzVRNk1JSkZPdkZaMG93ZGRJYUtDSWFJVHVBclhqUTI4?=
 =?utf-8?B?T2hUb0ViSkxacVozTUwvdU40QWNpcXZYYTRMYjRsbXMxSG9jQVRYblNZaUo0?=
 =?utf-8?B?TUloRTJTcElzSjlBbUlUSUMrN0ZVSUpFV2JUR0ZqTXNEUEFGSHBTU0hBa1V3?=
 =?utf-8?B?RmloTW11b1FOUTNkdytEUjBqK25YcGdTTHVSaVFTUlN3QjF4dUREemtSQnph?=
 =?utf-8?B?ZTl2M1pvcXdlaWYxSGE5K0cyMUx4KysybFVOOHZ3aVhaN3A0eks3cUxCeEZG?=
 =?utf-8?B?WG81bWE5NkZMR1o3S3Vick5OR29helI1TE5RQ2dpbmd3QVprQXFUY0pjM1h1?=
 =?utf-8?B?a2Zaa0oweWZuQmNzUVBrbFl6VFo3UFdoVDV1UmI4RUVucWpseTg0OEg3UjhB?=
 =?utf-8?B?N3N4eDYwbnFjb290empOdW55Z25RcUhsdHVZT2Q1SkY2U2l5aGZHR0pNVzU2?=
 =?utf-8?B?OC9BcFpqWDU5ZXpSa3hmQks4cTU2YUpIL3FlcE4rUDVjT0JpTkluNmtDWUZG?=
 =?utf-8?B?Y24zNTZGK1gxSDBnVGtZbTdENmQ2dzlNcDFqSVkxVmcrM0d6azNpQU1BejVY?=
 =?utf-8?B?QWgzNS9kMUhVNUdUcUwwOHFxbGw0ZU9hRGF3R3JxaXRINUZnT2JwQ1RjT2Fw?=
 =?utf-8?Q?6M9C0P+EA2Q/F4+PVXspRxfRTBV4WKbK?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2024 18:36:26.2370
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3266a1f0-5f7e-4350-537a-08dcdf234b87
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6442

On Fri, 27 Sep 2024 14:23:02 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.12 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.10.12-rc1-g8b49a95a8604
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
