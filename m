Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2048.outbound.protection.outlook.com [40.107.101.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8DE218E90
	for <patches@lists.linux.dev>; Thu,  5 Dec 2024 14:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733409552; cv=fail; b=ZAYCe6jmBKKw/aTG+n8w5AdrUruhaGzSGsWv/qAlazNIdE/fDbzGoEVT0v7X99WTnTuqHxWFR326U3ifgvJ0QrYn0uXfFOcgvszoZvvRcC6CjNbI7J1apwm66aLVaCOWLqpWzIHaoKXLTwNqNlrTgjPRF7T1ZFjsQQRIK9AlymQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733409552; c=relaxed/simple;
	bh=cn2i74pUBCbxt0qF1w+2JjcZ/EWAgp/HgZxmlWYy/aY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=cvb8CFwj2Dm52q9ru4BFGrvdVarRQUWPYZLNPlsfV7hiQ744QK5OLCoRBJB2XJCKuh/kayotvf178fPRfoDHTb4f9/7OhzYaH5H9/yfkVzeNs6WZ0r5Nf3kbv2S2/IRJCgDSzkCK1SLFX5fHQNaoF9UyZgN1/RD1dmKVr2GA4cY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iw+Fq7Zo; arc=fail smtp.client-ip=40.107.101.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iw+Fq7Zo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QwGL3h+1L+fkDBhusUSWcri3o7UTw0MoDg+1RtI+GXU3+7zj77OXGQqDqYEoNKLZ+7bl1cvrLBo6R+FsSa31qOJ3F/LUL1EUS6wo460Vu6mFRPkuazHr+HCIGIXi62Fdvtt0EgrTtHX+sFLw6r5FF9eh7AgFVxLxM03bNM8K2MJUdj4PiQOAIp859rv3kysbz3w+Nl6KAuP9TGUOdDzj8LU2x/uMhjEifRThVtZaLePi5x0VQ26Z2ha40m1l8K4nxh7EAyRDTT/J1V62akf967QfrZyQrtK+tnZcqyo6LqC6nI+M1PxwfzUn+50RpCynPzkDVGBKOiM+68L8a/cyMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6jxAuBpkiK6uSwhqy/71g/1CANOsl3VfWwBKnoB2LWg=;
 b=s3K7jvOihwkafmzM266d0Ykdk98Ts3g94h1lqXH89fwL752nSAr52jbJpzpfgm52QWPG2Q1CqY3OlxFS1OK4cxd50Pb2fFoqNgf8jobDsbagnm12ZnZHdOpM3CLSHCkPVyAouPnFwoSuNPi+2b45Kzs0SA/lLk0Gp2OWMdoyPw0bU3pODeFvJwsegBLqJrZqSCER/4MJf7KPJtTG1Wyx7JsmVDWnc3lscwqDYJI/aomYi+Nq/dpWziyyM61/IZMqsVPS44bDhiSEX+FHAHIc96HjUTyWLfm6JYEQXrZ7HqqDgHxK1o31nqOpYpT9rg69P3YjCBRZofRbpU/P041cyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jxAuBpkiK6uSwhqy/71g/1CANOsl3VfWwBKnoB2LWg=;
 b=iw+Fq7ZoM4QHv+/p30TUiFsGqPhWnQN201vXKxDI7viNqpMNVHDpxACxeiNdHGPL+xFzAewP3uwpC+UOfwPgfDQth3Ux2NRD8CzguNGd/zDjBnVcl+NQYVnIMXC7jj+aM8tUSbIr60otgUOPsGIkxfTxTHVEWhIl5G+7MU2aETRXDGgZmdzZZPPhi4gjtno9scdoOsTBLdjf2AW8MLhmuWM0tXwBrkrUkDPvYrc8JG3Z52/7o9/bs6twcQVbDMWE5MryFdZ05lr7MyqlasRq5j6LB1y+FXYrGlU1bsLUfTU8l/5YXDfpqKqvW/lRyT5gspMgPAHS4FP2bCtvL59W+w==
Received: from SA1P222CA0109.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c5::26)
 by BL3PR12MB6401.namprd12.prod.outlook.com (2603:10b6:208:3b1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.23; Thu, 5 Dec
 2024 14:39:04 +0000
Received: from SA2PEPF00003F62.namprd04.prod.outlook.com
 (2603:10b6:806:3c5:cafe::80) by SA1P222CA0109.outlook.office365.com
 (2603:10b6:806:3c5::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.12 via Frontend Transport; Thu,
 5 Dec 2024 14:39:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00003F62.mail.protection.outlook.com (10.167.248.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8230.7 via Frontend Transport; Thu, 5 Dec 2024 14:39:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 5 Dec 2024
 06:38:51 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 5 Dec 2024
 06:38:50 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 5 Dec 2024 06:38:50 -0800
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
Subject: Re: [PATCH 4.19 000/138] 4.19.325-rc1 review
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <71fc98de-2f61-4530-8c03-dcd7fa3bf470@rnnvmail204.nvidia.com>
Date: Thu, 5 Dec 2024 06:38:50 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F62:EE_|BL3PR12MB6401:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f968b16-698a-41e0-9b3e-08dd153a90af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODM1aXNFbnIxZnVrQVlHTGdhcXVsY0htL0NzRVpCOEgvNUIxNW1sUXZpTU5l?=
 =?utf-8?B?emxNNjJCSmF5VUk4MjNXQ0RPVm41NzZPZ29GVFd0WDJ0RDhoeVlBSi83YjFn?=
 =?utf-8?B?OUlVUUp4Ymp3Qkp4NDlIdzc1Z3RHSnFYNWRTM0E1d3lYWks3K0t0SHJNOXZ0?=
 =?utf-8?B?Yzk0Ly9wZ0xiZVFGbDVZclpJbXA1NWw0QWVwTUl3dENNcXpaY1VBSEkvWE91?=
 =?utf-8?B?RFhpY2lXSUVmandhWHRIREY4K2FjTHN2WTV3MStobmE5ZWNWR3VFL0MwY1ds?=
 =?utf-8?B?Tk1hMWZRYU5YbUFnc1BFclcrUmREYUlwSk11TEhpSXJTL0lIRXBZWS8zMU1w?=
 =?utf-8?B?dTBoL0N3NTFYOUo3VEVrTkg2aWVXcnJuN0k1MmU4OEk1dUZ4RWo5VndSME56?=
 =?utf-8?B?clQrdlZmd3ExRTdpV2J5RVVOd1lqOGI4enZ5R0RKdnZnOU50N0o2ZTNMWEg4?=
 =?utf-8?B?VFpzWlZYMmhQbkN3Zjkrd3VvakhsbnVZUlRFZUJ1TnY1dENwdWROakJoZm5L?=
 =?utf-8?B?REtzU3VSQldMNkxqOGMrbHUrQS9YUXM3MEtMTnEwYTYwWWEweU5GaU4vYzZV?=
 =?utf-8?B?R1VhZTRTS3JsSEx0cUVGdGVSOWU1S3ZvcThBY1RkWDlKQ0FrQUZ1bzlOcUV6?=
 =?utf-8?B?NWhHQ3BHM0dzTlB0ZDRYb0EvNHpVT1dyeWVZRDNXaDZ3YTNCSG1WajRaaVE5?=
 =?utf-8?B?MS9ibExyd0pVdVFKeTY5Y0hSTXlTaDR6Ynp6VjVtNlhzdVZRNXgybENISDlF?=
 =?utf-8?B?ODZ2ZkZWbXFlWndiWnZhRk1jbXZCL1B0TFpjVVhYTHIvTjYwdkx1clg4aVpw?=
 =?utf-8?B?bUF4NEx2Z2t4SXFoUkt3RitsWGw2eVhJMy9RQkZCaTQzUS9JN1AwODNKVjl6?=
 =?utf-8?B?NU54Nlk1SEdhcHMxQkR5NFdsdHpySmxlQnY3N2tqUVMzTjV1UDFQQXJQTEl3?=
 =?utf-8?B?V1lxZWN5ZnpsTE9Idmt2NDE5MGFaRHBvWGJIZTJ0NzJmMGZna21EQ3JsNFhn?=
 =?utf-8?B?dVZDZDFNcmlNbXhkbUxqb3NsNzhKMTk4UGtRbDhyaTNEOWg4QlZJMUJhYndK?=
 =?utf-8?B?QXV0UkhCOXBSYjhoQlRySlRtVTZSWWlnZnpMR1o1RlhhSFpXVFg3UURHb0VQ?=
 =?utf-8?B?WW1Jbis5d1BBVlRlUVEwYjMvcERmUTdIaFo0bEtJYVlVeVJtR2dPTlhFUDNa?=
 =?utf-8?B?ejVBd2psTGN3VWlmZTFmWjZLbnc1cEZkc0w1dFlUMk9hSFdoQ3VJMGtWYnpi?=
 =?utf-8?B?WlFPaFBOT0hYNVBnRTVZR3pvZ2g2TVN6WnBwNjlmb1h5Qzlyc09ldDhpUVRE?=
 =?utf-8?B?TSs0aHVIR2MwME9ITm03RjVoZkdoMVJuNFRQanpkZC9xb0hhc2JVYStpSk1B?=
 =?utf-8?B?bG1wNlc4Y2lrVENuL3haZVFLRm5PelZldmJHcXpaNFRZd1BGQW9iU3RRSEEv?=
 =?utf-8?B?RFhMdXhVN1g3KzR2TStXTCtFRCsvbklhaWs2WGlld3lncGt3bWErYzh3TUdl?=
 =?utf-8?B?cTd6cVpHNEExelZEeGQrdTZTR2NSeGg0dGM5MFdGeStPanQ4YjNZQXBlK2di?=
 =?utf-8?B?NzN1VTU4c3NLK05nMTlSc3RMdG1aNjNBcHJRekhjczhBdWR4VWhhelp6VHJL?=
 =?utf-8?B?RHNWQmRMV1hwd2xwZDAxdGNsSjdoT1lsMmlEc20yMUp6WmhaQ3BXSEhobTFG?=
 =?utf-8?B?NXVQZHlXZE82eE13dXhtNlg0WEc0MkU4QTVFTTJMNGE5anpveTdpSGx3ZTAr?=
 =?utf-8?B?M0F6M0FaOHJ4RTUyY3dzZ0kwemNtYVV2dW1PTjhlTVN2TS9tZzkzSmJOc3ZH?=
 =?utf-8?B?cWxiLzA4TDQzeFpVNzFVZC85b1dvTFlZYmhTSFZ0SS92ZWdRRWY2UGxxZW1X?=
 =?utf-8?B?Umd6Q1dDSDkxY2NNaHlHellETWRXSksrU3o0M1N6WlRXdTdRV2FwMERKTFNa?=
 =?utf-8?Q?TRq2SI4ZtziwAKGzyDyInCTbOTgOsJqG?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 14:39:03.4630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f968b16-698a-41e0-9b3e-08dd153a90af
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6401

On Tue, 03 Dec 2024 15:30:29 +0100, Greg Kroah-Hartman wrote:
> ------------------
> Note, this is the LAST 4.19.y kernel to be released.  After this one, it
> is end-of-life.  It's been 6 years, everyone should have moved off of it
> by now.
> ------------------
> 
> This is the start of the stable review cycle for the 4.19.325 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Dec 2024 14:18:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.325-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v4.19:
    10 builds:	6 pass, 4 fail
    12 boots:	12 pass, 0 fail
    21 tests:	21 pass, 0 fail

Linux version:	4.19.325-rc1-g1efbea5bef00
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Builds failed:	aarch64+defconfig+jetson, arm+multi_v7

Jon
