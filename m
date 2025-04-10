Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C212283CA4
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 12:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744286880; cv=fail; b=frk/VwgB41Y0jlbLrx6Y1UKc0bcDthnfDfN4pbSJtgDUG8Hg/jxK79b2SpHp9smH/aXN4FyFGFl9M8IIXU5kPrRcX2REJPv+EsodX6AwtXsfM6dqn7a+3isv0CGOYDyMkoCP2atT/8bgiYiAPCG1CiUwi1oURm2dT4j3GkH2eCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744286880; c=relaxed/simple;
	bh=to3PasnjUyEI946mKf3T3QTGCupzPNGm7BgSlIBN6Yk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=A6y6ITnLgRFswvonc8zJTsmZfpo9G3Adje4du821jVSeGGRGLqMlwuWnJrNEnIxoYVDXc9Z7O1//SQjnf7yGdoVTT+mA7G8Gnac65sh9r1S9u1TZ18EdoqHz/B9ShchLJiz7itV7304Zg7SJue10i+YAqUTk/ayYtj5BL1yYDAQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YGe4+cpI; arc=fail smtp.client-ip=40.107.93.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YGe4+cpI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gM1+4f0DppK34Ye3fD2fFcr9TzbGkb1ScxgEroZ2XmtcHfgd9G5v+kmRjOCKHqaxdniEb9BmF+BdxJxulZJfDQYEOm/qaOYM0Rx09QBA/mi/b/VKyiAFmzcCXbfPy3rKXvLLwBjAzyOX5vb66ESUPFb3maT0miJF/MhsKpAvT8ShwIjSfcZxJg28+erQJz0q/LfK01dVqTSmXr3j35IVnLG1Q6PpQ21+QNRd9vJQ8VL7JoY7YqsP6Jq8YVTQaNCRiyuze6fUvNon4BXRycYt8jB40Q3Ic3ISh86XqcgpXXdziTmqH2HNBeXV2ASppdMcQ8m+Rlyv4HMmSKd7eY7HIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zqBSgJvSTjZER4Js9ddkDPRX5Ci6SNoOz7Zukkb33G0=;
 b=UOfVmKMi2Xe6skX7Xx3bWfSAOqqD4jQpF+zirSOQLnIdWA3fuTTWeQVvw6ktYUvZdzolt+/XkDN8lo/dkt3LEDsB8XrQtDqo3Z16tRtIIrzHiXEEnThSvkcZkKtkh29yFcOAzkLAMu6BkOTaJCgcYe/BZwBb+74UtxG94xschkp0ISEAu5yazg4bz8hsfSAIZaxUxW0yRgSTNTDEZbehtY582tBw3hecCr7LyyDLGn7J4eKKGZnVuEAaI1ftTrrsMglQWKNLVwPBg4YPNhDqXqq/NQgCP1xu1/oYEvNxd1sRR/714R1rriPl8JdZpEPztsha4Utbz2qG7a53BLfdbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqBSgJvSTjZER4Js9ddkDPRX5Ci6SNoOz7Zukkb33G0=;
 b=YGe4+cpIixm2K4mzVfEyPuOXrbhxfQ2szZLGXLK0To2EaUa+YAhDohnJcOxBdx9nFIiBEG9xMtA5JUk25qTuXtE/lqXbTm1XMa9Rc5UfxUVXyDW1sCQXkO0bw0t2BmhO/Cdi+ggl/xtB1wOG1KO4QZ1EAQDEOisA+v4Qm18zbFmIvOY5xOf6GYsAtmbVllUVISEdK+ZnNlegCdkwxmXskAbkdX4Yu9KUezKrqeBsEXV6ZW17zMG7ilm1M7pFvIFs++vXBFl/m9AVUQvlyaWjeM40OMIGClnmBGF5MAKE+UClVuJYzL98RMYVVORaI3RJG/X5mvRZMTnB3YrFSmqCIw==
Received: from MW4P221CA0013.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::18)
 by CH3PR12MB8903.namprd12.prod.outlook.com (2603:10b6:610:17a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Thu, 10 Apr
 2025 12:07:56 +0000
Received: from MWH0EPF000971E3.namprd02.prod.outlook.com
 (2603:10b6:303:8b:cafe::f9) by MW4P221CA0013.outlook.office365.com
 (2603:10b6:303:8b::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.22 via Frontend Transport; Thu,
 10 Apr 2025 12:07:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MWH0EPF000971E3.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.13 via Frontend Transport; Thu, 10 Apr 2025 12:07:55 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 10 Apr
 2025 05:07:54 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 10 Apr 2025 05:07:54 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 10 Apr 2025 05:07:54 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/228] 5.10.236-rc2 review
In-Reply-To: <20250409115831.755826974@linuxfoundation.org>
References: <20250409115831.755826974@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <0ab00f08-3308-4c06-8394-460ba12bc697@drhqmail203.nvidia.com>
Date: Thu, 10 Apr 2025 05:07:54 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E3:EE_|CH3PR12MB8903:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bd3a365-0efc-439a-c03d-08dd78285409
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXNEb2dHZWJqckFUMHpTREd4TE4waUx1aUwwaE51VVRkVXZrNys4RkJORzda?=
 =?utf-8?B?ZTc2cDZYd2NCK0VMblIybldKT0pwMTQxOEFSK3JYUHNTK2FoN2dya2JUTzQz?=
 =?utf-8?B?WGpWTEVZL2o5cGU3ejhxbldGNG1Dcm51b0ovY0p5ejRqUHpFQXR4cE12Z1lL?=
 =?utf-8?B?OXcvS1hZMzdzWFhFT3FTSkdpVitmMDJqMm5JU29YZkRZa3ZEVlBwQys1OUFC?=
 =?utf-8?B?M3BST1o0Sk9qbVNZejdCRHJra0dNckF6NFpOTC9pMmRrV2laTFZ5dHp1R0hy?=
 =?utf-8?B?N1FHWW9BQjhLamZ2Q0pLdG85dWVRRmtCY3Vib2JkNnZDbFp2dXZKcGZGUk42?=
 =?utf-8?B?RWV4aGJSK2pmeFQrdHJYcncwN0wrSWFNTHVGT2Iwb3Rvd0lSNmJpMUdkQnlZ?=
 =?utf-8?B?OXNaQm9YZ3Fqc1lWKzMvc0hOblFOVkQ2TTUvQmhqc0ZZOW42N3VRZE5JQlBZ?=
 =?utf-8?B?V2FzMEF2bmlRakpjZWZwMlk4WURPYzhTY3Bab2xxLzErNHM5SVFvTHBNQTVG?=
 =?utf-8?B?clBkQnJyY0FRTEtrZmVvbEo5c2xsMnIrd1lGQU0zZy91NTRjZU5RMGtpVE0z?=
 =?utf-8?B?akw1dVlVRnhCWXFPRE5FOTJOUERLWkhJZkV5TDVNbzIyOGE4c3hoYTIzTko3?=
 =?utf-8?B?QW5RcEh2WTFMeHFJaGNtbWU4SE9KUHo4NVFGdlVhRGNVNjcxM3NxQ3h0Yklh?=
 =?utf-8?B?Nkk2aHhiYmlGd1dHdFJERHVrMjBGZVAyem8rMjdxOFFRcHhyZGhKbkFkZit1?=
 =?utf-8?B?ak9xcmJwSW5JZ0pzWWx6eVVyWnZMUmErTEd2aWoyV1dmRGZtZ005MXVBWS8y?=
 =?utf-8?B?Yk1HMnZSNW1uekYzeStXOWJFMFpPZk5PdTQyNDZxMXE2SkhIUlRYc25TMTdB?=
 =?utf-8?B?ZkNnUk9GLzVWeGZDaTgyRWRvUXNseDZhY1V4M1lkbkxBT2JOcFBqZ3BaeEJJ?=
 =?utf-8?B?bUd3UVBENTZkdGs0UHlDTlZLelhZUU1DaVRnLzIwbXArTWcrSVBZK3NNWXhv?=
 =?utf-8?B?UEk2b0xmdHd3NFN2V2NkWVB3NW1jcThQZGhvNG1SczdJZUtYYktwNjh4VUJX?=
 =?utf-8?B?WjU3eEtTNnlDM1laY1cxK05ObVkzRWJNTXJqMjlERElnWndDMWhqSlkzMHFG?=
 =?utf-8?B?VVdsbjMzVXRzU24zNG9ZZ05IUkNHaDFYalNoK2Q1NXQvM1hOeENkU1ZMdkg4?=
 =?utf-8?B?Y0JQQ2pCN2Jpd24vREZHZW9OSUJaNE9RVldxVmF6dXJTdTNIRDUvVDgrTk43?=
 =?utf-8?B?RDhtUzE4aFhhbllUUk5LZ0lXYU9EOThQc2JPYmZvdXJuR2h0MWIxOThMTS95?=
 =?utf-8?B?ckdYdlNrdU1zc0UxYTI1dER5dHRYVWZIQk1Bbkw3WWpVYUJEVTVJcXJhNkN2?=
 =?utf-8?B?azI0NEFoNjBOb09naW5xcjl6dXN5RnQrY2ZCMkxJdm04OHhTellBZ0xWZkRL?=
 =?utf-8?B?SU0zRHl0SENnQU0vRnV1ZnR2eTlBSTFHSmJ6dmJZR2ZuM2pOODFKNDhDSHZL?=
 =?utf-8?B?a0lvSmM0alZsM3ozcTdCcyswMk5uamg2NTZscG83MDZmdTY0a2NHK1lwLzNX?=
 =?utf-8?B?azAvak1MR2RnQkhxWUljejhNN0VYdktPZ3NPSDVDZWt3TmhCUEdLR3JOak5a?=
 =?utf-8?B?ZGw5Q2hzemlyY1doZldWaXIyN0NtM212emdyRzdwTGpidGNpWXVvbHhIcU1R?=
 =?utf-8?B?Qi9kTTJsVFdidU5BU0hCaDFMY2RjVlNOanE0NEYyVjhwZWI3Tmx5SEwwcWxk?=
 =?utf-8?B?eGptblEzTHprbnQ3VG5NdlNYdmdQWSt0TDFBUXJVcUtZZDlDbGw2djMxVzZY?=
 =?utf-8?B?d09ZYkJZT29ickFjZGJKcmVTSCt2NjE3cVN4SlFtUGZDSmFJVlZtVHN4ZkFi?=
 =?utf-8?B?dGUvZElwM0c5RkNHNjB6Uy8wcDN4TFREYkZlT3FobTAweWludjMwckNZajJt?=
 =?utf-8?B?T3ZycUVDUFhJNE1mdVBoa3dOTzJFUTUvQ294Tjd4cW02ZFBralZ6UHhwZ1NQ?=
 =?utf-8?Q?jNCFurmjcewfAMOZGdd/9ivxL6X7vU=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 12:07:55.9491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd3a365-0efc-439a-c03d-08dd78285409
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8903

On Wed, 09 Apr 2025 14:02:11 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.236 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:57:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.236-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    67 tests:	67 pass, 0 fail

Linux version:	5.10.236-rc2-g5b68aafded4a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
