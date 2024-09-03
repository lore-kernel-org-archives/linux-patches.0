Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D370519F430
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 08:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725352974; cv=fail; b=qgi8FgZmXZLDiRdOYt/b7wmNc14j87vny2m0PoQsv0Oc5Pji3NOTmASqW0ZE9Uewzd4+XGfI/lJqqgwHWVbzVh+MtxFvw8kvqXZk79p4x2TohNlX3Tx+Ubl3iXeIwpOnbAY6v9srUevW8DuWnXXPCJqG9q/9vZ4O7FJTUdiRnXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725352974; c=relaxed/simple;
	bh=bHib7BfAuFZJ5dwAWglVeofkYL7CHyKYnD6JMkxEeUY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=j2c5WbzV5ZOTVC2W8KLg7zm7MNu5cCCNRmcw2ppisKlc5x6jW566sgJ/Bu50XIAHA8XjfgbKkCqT6HFxovgwSHZc+31v4aa+Vml3Fpp0x95C42TXrNpzDgqRD30WjtC5puC/4bU+K35/XgEWAMhsQe4HbKs6OxGR5FveqEXtZBc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lof5DmgG; arc=fail smtp.client-ip=40.107.94.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lof5DmgG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RE/IvkNQxz/FKB9bLyQb4fFhlqNVolqoYVO2GHW5HE70kiiGuIXNdv6Yb2veVXM5e3Zn4da8OdI7cQ/djsMb2r9cqps4TPhKPnYbNkB64duPCZURKGDoDxSC1+f60VHsf756tGhcomATo6ll7rbG12qDtv6kyLufe4fFGBrqaWR622txa2fl2yUsF3WIMR/BISST3JfsPGWvtcFb44igh7ckTRSev9lNYnc4ccOSddYU2wmFLsD13jNQCPJpHZdkmb+3k4Yo8sZU+Tcv6/yZif38q+a/TFUR5E/rjxjXX8uX2vo9q5rOfTV9FsOY6AvxI3s5RVm7Ttibq5Bh4LqCcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nQVhii0tA4Om2uJTubK8ioKb/JmlvHFUJleyvo3oXwQ=;
 b=UpaYiopoBZYm0eOPfII8b/a5tseuCOV/6Td9bQyUXoFMEb5RZgXguIfbjG9SdMFiszDtJv2gTIJ1dy4jCA7M/5ylnnKRHmIdu37pwC3V4Aw71jF076jPQD/xMoH2LVmz94IA06c7qIWdlxdVt9+0CFaTeNAhkRkwfI81wN0mLM+5eZW9birNjspxlfIxnIsoxH5ChBPGpLQ0ck+P10hRX7ZR7/hryDLJt1EVfV+hJm1azKmxzOpuaGz+aoar/bIIDhR59P1UhswCb/xUxQY6XbiC4AVDyKw31huGIiw5+sCUdpKWWCofv/ZQSPS6y2jtiT/chkrPqgId3sgH/DBn1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nQVhii0tA4Om2uJTubK8ioKb/JmlvHFUJleyvo3oXwQ=;
 b=lof5DmgGUbKas93NLgIqdKR57xH7Q7o4mTnEaQRGWSgA5VD1VeTiMOgBxf9WVwaTTSiZ+HRBCdu10awhDym96cZjrbzVXRAaIidAFGhoGaoPEdVHLor+oexqmcW7MqMD+k34iYQMlq744AHXfCaoFsfzUyWrTz6EJRwKl9Mtu/BLyewIGeig+WXIPKunZfELHFvbMyrSeGXu1a7UmoV9ZtoibskG0cVO5fGrXv7/9PduAfFJEWja09+CnQTje0mFExC2/1wAi0Q3GzFG7OFyOPGklwWSaTQDz7h1KWtMBV6QH8NM//7VffiTb8zZ9ME1GDq2xIi+ORFtkmsWSO/KMQ==
Received: from BL0PR02CA0008.namprd02.prod.outlook.com (2603:10b6:207:3c::21)
 by CYYPR12MB8961.namprd12.prod.outlook.com (2603:10b6:930:bf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Tue, 3 Sep
 2024 08:42:49 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:207:3c:cafe::e0) by BL0PR02CA0008.outlook.office365.com
 (2603:10b6:207:3c::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25 via Frontend
 Transport; Tue, 3 Sep 2024 08:42:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Tue, 3 Sep 2024 08:42:48 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 3 Sep 2024
 01:42:38 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 3 Sep 2024
 01:42:37 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 3 Sep 2024 01:42:37 -0700
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
Subject: Re: [PATCH 4.19 00/98] 4.19.321-rc1 review
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b6ed4e19-bd88-4cf3-8e47-7402f4d87c8a@rnnvmail201.nvidia.com>
Date: Tue, 3 Sep 2024 01:42:37 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|CYYPR12MB8961:EE_
X-MS-Office365-Filtering-Correlation-Id: c288be22-f2e1-43a5-a84f-08dccbf463dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bkl1NUg2RFFmc2N5OU5PZndQU0tUWmpqUTV4UXdTUmt1WVAwY1ZvOTc0RHdP?=
 =?utf-8?B?OHo3NklEOEg2S2xXajJpQTYvMEZ3bFpEZlVxeFRqU1dwRWhpbjJubVRXYzdN?=
 =?utf-8?B?THhoMmJ1Z2hZOEJ5YUxqUjBqMWFzVE9ONFlEWmVOSkFtYWJEbkppcndlUVk1?=
 =?utf-8?B?NWRDN3dXRHNoU0ZZVXk4di9oNkJLOEp4cndPa2NTWWwxekh6Zzg1YThBRUxM?=
 =?utf-8?B?NUF2SGdNNHU1THg3YTRRRjlSWFcyZ2NxdW9KTlRpRlI1OVErVEhvODd4VE1x?=
 =?utf-8?B?alBBM0VFelREdnNxUUdNLzR0R0Z0L3k4dUlnR0R0NHZTZUF4MVZsYjlJaWpO?=
 =?utf-8?B?bVRmZGhzUzFFTDlVejQxdy8wWUhnQ3ZzZjVoK0x6dVl5TFpNMVFRdjc0QVcx?=
 =?utf-8?B?WDV4eFJCRCtxeEZYeG1ydmpWQkc5YjlXU1c0MjM2NnBSK0lQeGdJZ1JIQlV0?=
 =?utf-8?B?ZmdMMFFXTWE3dEJRdys5bktFckVLSjlDblhHQ0UrWXYvcWtKSTUxV2ZGcUt1?=
 =?utf-8?B?STNPYjl5aWNqRkpMa0Q2SGpjOUV1Q1JnelNRdm1mLzhqVGZPMTJUSUd5aVVE?=
 =?utf-8?B?djZTQW1JaFhTSnJyN3ZmUytvVjhQTlNsc2hTK1BXdzBmeHptbmZ6c0txQlFE?=
 =?utf-8?B?RWg1RmNWcVZYbTZ2OXpHK1FYME1KcDRiejhXZmRlVzdPb3VoNUdoaFdzY3ZG?=
 =?utf-8?B?VDFjK3JXYzVFMzljTEtGN0ZlWjJuOGN0dDZKYUZWR3RySTBVYW1ZL1Nma05h?=
 =?utf-8?B?c1N4Qnpud1JQdFhXSDR0WHV5WE1RS25aVWRTdFU2NmxGV1lKT01aanJOcURM?=
 =?utf-8?B?SzF3dW9aUG9PcVR3RWw4ci9Ja05jQk9BOCszdm52d0hhRmw4c0tMZnhIOHVD?=
 =?utf-8?B?Z2tVTDg1cEYyK2wzRU5QakhOSWNsT25LekFlWHJFUnZZMDhtZ3FuSWFhMnh2?=
 =?utf-8?B?WlB4bVJRa2haZHBZUE5vWnBKd1laYjZHRGxsWTdNRm0wb2txNWFyUzVGY1py?=
 =?utf-8?B?Umdka1ZQeitYT1pQWjlSMlc0UEYwemxhWE1HU2haa21DV2xiVzZJSkszVzdD?=
 =?utf-8?B?c0wzTjlmM0xzdXRWWEtseFNCdnNXQ2prTkF3VVFMSCt6dFplTmNnUmwwdFRD?=
 =?utf-8?B?MzNuMlNqeVJsYWZJcVhQenVxdmE2eXVNRzRVZXNOTmJLQUlLS3gvV3ZhSmkz?=
 =?utf-8?B?VXIrNVZQZUFjNnp6TnMzRTdBaEZvUU5lajdZTjIrQ3JOblpVbGtPQ0lOWStN?=
 =?utf-8?B?OHcySXZsaFFsbDRQT3RleGI0ZTRsbTQxeVZiamhhcnZucTlvcjdFcHJMZ3or?=
 =?utf-8?B?bVYrNFh5SGRkUW9Qemk3QzFmVkZsOTJtUU1oZVBTNE1VeU9oZW1KVWk2VjZX?=
 =?utf-8?B?WGdIalFUc1Q2MW1qTWwxMTlpYTAzcEg5ZWRNOGtBRHV4a2wycE9XM2N6NGZx?=
 =?utf-8?B?T1VFSTFwQzU5eVMvazRUbUkxNXRMN1Rzcy84UkpEMm1JbnRGZWIwak5mREl6?=
 =?utf-8?B?T1VUcm8zdlhpNENuK0owNTUyVU9aNVhSOUMvcVlRc0JRaExET0tXWXUyekI4?=
 =?utf-8?B?bHN5T1lsQktjUVpWR2lXNW0yaHd4R1FUR3NPRW1NenpLT0ZML21kRm8vSHpS?=
 =?utf-8?B?d1hIdGVyRlYxbUZMV1NySFpFbHB4Q1RtdE83WkxJS05GZ3JkQU81TXlRR0VR?=
 =?utf-8?B?MStrTnk0SllNR2xvRWltOXcxRS8xZHZtdUNFYU1ZaitxY1A2dGgrcExESmpT?=
 =?utf-8?B?L1Jyc3lHOFd6TGJWS0srdWh3VUVKYjBoc3liemMrRFBiTHljVUhqbWJlSEFW?=
 =?utf-8?B?ZUZiRkczd1RFQmJRMjdjL1Q0WC9YMkJhNy9uRnY1MW9MS2IvWUtpYytUQ0VR?=
 =?utf-8?B?MzhpTm5GYWswK3JvY2puLzVKenY5RmF4cnBncFNpSklXT053bXd6SEVBTVJO?=
 =?utf-8?Q?waekDQs697ZUGMUvF5UqUFNS+1Kv7aat?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 08:42:48.5822
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c288be22-f2e1-43a5-a84f-08dccbf463dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8961

On Sun, 01 Sep 2024 18:15:30 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.321 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.321-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    20 boots:	20 pass, 0 fail
    37 tests:	37 pass, 0 fail

Linux version:	4.19.321-rc1-g0cc44dd838a6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
