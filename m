Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2071.outbound.protection.outlook.com [40.107.102.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD6F1EE026
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 12:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736253895; cv=fail; b=s7Mh/+R0Kw05qbuS3yHFzEhS+s/y0GBqU4r2Q3e46y4y7Wh6PijKUDHHo+daXcXXiQ4WeboU1NaYepappwfB62+PpGuDn4gNmKM2K9yQJOsl+mQYHkDtz5yB35cU3q2XQZ+rcoMJ7as7NjotNvbwVNsxS8JBprdX1vfRJ7a+kzw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736253895; c=relaxed/simple;
	bh=pgGvymGWewU3tzhlhkPhy/7xnt7Q/TjTtrknk61r4C8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Z49sHvWsZbpTxl0wMEzIX28XWcdl4DVnv1QeugbGnLRBno8J/7dcKeOxzrO7c4WENOJD/B27jyHqEpqUtjfB4yLCAZCEq2CBNs3IjUtA1EoaMZ6DsqocUsF79ZMKCZOfruIsgMakgGdV51WeuMvk69BL8KYNghUxli4NMrIj7xY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HNYMD7Ab; arc=fail smtp.client-ip=40.107.102.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HNYMD7Ab"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nXR2zkvy7OOsVBM2ODlbe80Jwg7OPSGIWID2f8nylKaE71EjpylsnIp62MyGYYID/MqgYkFIPFUdeS3ykooolGjmPKXFzBdTI012TkOQ9Mslfof933uj6Cvx5TuZvsJjMUKGGzqcK5ac+Mb3BWe8ifVpsCNiZDAuJJwTTs1z5ULy3Q+EfJRxCLLgBPpz4Hmx7EcYCUTYAcQf5PgpH692uDkCxXFKR+YOhToa2VGcffE7GJhShJt8sc+M3jGQg7GRfR2N3OVfrSXd7u92Zwz1ue1vM6CgiPvN1g3EVV4DtI8LTy5Tb+FQVsYbX26lrolxDVeAkoLUxoh0Bq//oYgeag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=arqwdTj94BuxwaNARf3f3f/xy5bm6xb426x4ZsDYlMA=;
 b=CS8VHlnxcWNMEAp4Jh9B8MCX5GSlntbvffnaamVDMYXzLeW3KwujaKPDIq9fTsps6qJ0JRbxs9fbpJdHTA4Op/uJYpmyKIpz+MAzPB+NfMF28t0kUZ6qYEy5QiI3S7mNzGEW9DFf7HOg5t8+p81gjznHRZc0+JxfT/sxPsNpYtm3tL8wrFY1wXWjQACfCtg/aHLZU5O/AxWIvhzZwlEy+PumdEMqozVxFmsPEKHYQPf8QM5d1OCVNZPc+os7Oh9tNlz0QfZ1LtnhMkSIdSMlLzKRt2NazYopxEQkNLTqnEryswrJZDmXdw6C2hou/SHwiy2Wg78SVnu6PHnFw28iGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arqwdTj94BuxwaNARf3f3f/xy5bm6xb426x4ZsDYlMA=;
 b=HNYMD7AbpgECaz42lc/Vn3tGn5Bndkpm+Xe4ScWcQTIkVk8+xvyU8Q70bzdJObr1rX4SQ4dB0C6dEv46GnFacgJ14yOMkKQ0x3Yrp/Fi2NST9OUcQtIvZjLutFqLCabFYkygBC1fhp8GaZQEZZr3wKKKDGibzjP+Ao/y1D62fnW0zKNP/YT5HzHZcUjoV+kTNqz0t5XMVtw7LNTydcrsWWCq/+q5Ngn3P73BEECiWWtCGu0XdiXydlnIj6uUHyV3VztIBJxyvAjDSKrDUwan8zlWhZr2OpalPt6lMZCphzM1WmkXfIFlntokFJKZa1deuIDdnfX3WEjlpKACrjH/nQ==
Received: from MW4PR03CA0021.namprd03.prod.outlook.com (2603:10b6:303:8f::26)
 by CH3PR12MB7668.namprd12.prod.outlook.com (2603:10b6:610:14d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Tue, 7 Jan
 2025 12:44:47 +0000
Received: from CO1PEPF000044F7.namprd21.prod.outlook.com
 (2603:10b6:303:8f:cafe::af) by MW4PR03CA0021.outlook.office365.com
 (2603:10b6:303:8f::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Tue,
 7 Jan 2025 12:44:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044F7.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.0 via Frontend Transport; Tue, 7 Jan 2025 12:44:47 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 7 Jan 2025
 04:44:28 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 7 Jan 2025
 04:44:28 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 7 Jan 2025 04:44:27 -0800
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
Subject: Re: [PATCH 6.6 000/222] 6.6.70-rc1 review
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6cf00437-4b3f-428c-9682-dfb0ad3c199d@rnnvmail201.nvidia.com>
Date: Tue, 7 Jan 2025 04:44:27 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F7:EE_|CH3PR12MB7668:EE_
X-MS-Office365-Filtering-Correlation-Id: 85628e4f-9e0f-43c3-b238-08dd2f191190
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bDNncDM2Qk9yTmZtbWQrN0x3UGxpd2IzTm1kV2dCbGpicEFwODNvcFB3RVZ3?=
 =?utf-8?B?akFqUGxleE05azBXNG04ZnJpbkhvaW41NlVwZEo5YUIxcUllWGhwT3B2eElU?=
 =?utf-8?B?TUlsL3gvVzhLVFBIU1NGVnlocmFJOVFDbVhvZUZMdnlRNGZWN1AwZmkyclY2?=
 =?utf-8?B?YnhoRUVLbXE0V2puQTBod0Exb3FkeG1nRTcwWXltakVzZlhjRGNTNldYTXJQ?=
 =?utf-8?B?Uk9wVEcyVlNXblZVNWk5M3Q5UGptRCt4ZmczTDk1cjhEUnZnKzcvWVBoUVNm?=
 =?utf-8?B?Y2FEcnN1blhQNGl2KzlwYVVuSktoM3NGTmhWSVBTUVdBVnU2RUs1aFcvY21N?=
 =?utf-8?B?UVkzSVpFVW95SE1yWUpuU25YNWYrK2cwSG5WbHNWT0UyVUlEUm91T2Vqekxz?=
 =?utf-8?B?bDJKZW9GUzZvRzJnbXVEOVhDcExCZ2h5b3BKTXg3S2dZc0phd3pPL3FCNGNX?=
 =?utf-8?B?MEJMVmNEZjlKcFB6RFdVY2dKcEdoMi9SL0RUWERsczhSQlZyay9BMUU0WDZt?=
 =?utf-8?B?NjFXVlcvOXlVNGZrSTYvMUs1REtqelZQL0wzRGRDWENpM3dLbFZpWFowY2Fj?=
 =?utf-8?B?bFVMRjdKTlhVWXN6c1RMSUExTjdSVCsvSjVXVlpkSXd5THlST1R1cjI0NVBm?=
 =?utf-8?B?Y0Y1OE84cTRuK1lLVFlyb0dXOEtBNFZrS2FCOWkyVERsc3RYbjNvNHY0b1lj?=
 =?utf-8?B?WjNhS3pVWUlLM0xNZ3ZYb0YrYXFpSGs0TWMvOFlFUFpVdnExSU1KbEVENis1?=
 =?utf-8?B?b2lzbG9hRzVEZDlpcThYRmFBOXR5WTQwTi83eWxlTFJNWG5KZ1c1TkQveU5y?=
 =?utf-8?B?NGxzUXdHb0Rhdi94NSsyU0RxVC9IcHhRSkxBejlRSHhCTEord0RYVHV2Tk80?=
 =?utf-8?B?NlQrRFViVkJBUVJkSis1b1orclk5YlNURVZrY2ZFTFNwUXNiSlNPOXY1QTE0?=
 =?utf-8?B?V0k2SzhRL2VjcTM5ODVQWldGMGMxb1Z0TDVYNDJxSUlDYkxDZWRMQzFYS09R?=
 =?utf-8?B?ZHZNd0VBcGwzNmphMDVRMENkOTdIRGxWSFp1MXpOYWplcElPZ0tmaHN4SHFm?=
 =?utf-8?B?Vk01RWhPdkh4QlpUNXBoNlZGTFhzUFJaK2k3czJZaDcrbHAvbTR6bnIyQXNq?=
 =?utf-8?B?TFB3QmtBOUhYOHUxN0liYTdRbzkxYzR1L25iTHhQSlgxQnM1MW1jWEVkM1k5?=
 =?utf-8?B?S1I0bUJTdmpZNWJCUGY3R3ZFbzd5L3RmSzNhaGdyZ3JXY1hGdURNMFByTjQw?=
 =?utf-8?B?TzlaOG84dGZiWjNoZTZhdlpDaVpNRHpiV29ZbHNLRzZGckZkMFNBdGQzUTNW?=
 =?utf-8?B?UVdNUnV6K2QwZTdiQ2wwSGRweFdqbDNTQ1dGczUrTkJYQkxJWFZLd0E4Ky9H?=
 =?utf-8?B?L2tFRDNkVXFVTFN6YnVhNjc4NkpGN1h4ajk1RUl0RWQyOENoZ0xRRjdIQ1E5?=
 =?utf-8?B?TndPcFQ0bjJUcFF0MndIWjBTallMa2tTaGZxTzZKdHhJbk4vRVhOTDN5Z1hz?=
 =?utf-8?B?aXo1S2RrclNwWG54bFdnZWtJbHppU3ZzU3BpaFhIUC9zSmdTKzZ2cXZvaXpC?=
 =?utf-8?B?bE9hbVQwa0VnU243ckFKTytzU0I3YlZMZC91WEZNcVU4enhtRzN5ODJBZUFQ?=
 =?utf-8?B?emJGTDJtVmc3bWVxMUozcVdQclh1RWZzYWZId2FSNWVMMjYxbGsvU3h6N2cy?=
 =?utf-8?B?NnFnTWVNN2crc1RwQ0ZXNS9VU0pNK2NWRUthVzk4UWRDdWZVbDJoZ3A0d1p5?=
 =?utf-8?B?dVJnWjIwZnVxTVlkRC81Ri9RNTM1LzRxdzBzSVI3WFdjUkVhaXZZa1Z6cjVI?=
 =?utf-8?B?RDBWUEhhcVN4bFhvOVduTDNQd1VhY3lJS2I3aWQ5a1hOOFhJQkdoWXR5TXFl?=
 =?utf-8?B?eHVKZjRLVUhMbUt0dTNoRTVaM2F0M3dQd0hDVzFTZHhsNitNTmhYRHB5NW8w?=
 =?utf-8?B?Q3l4eXIxN1Z4OCt2RmFzaUhBZnQzUTRPcjg3OTdWeGtnMFpWSWRQc3UzMDlk?=
 =?utf-8?Q?v8UoM4Z8DY8hdzHWMxYsTblZKPhsfs=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 12:44:47.1080
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85628e4f-9e0f-43c3-b238-08dd2f191190
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F7.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7668

On Mon, 06 Jan 2025 16:13:24 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.70 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.70-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.70-rc1-g5652330123c6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
