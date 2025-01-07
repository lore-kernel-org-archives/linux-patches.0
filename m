Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F6B1EE7C2
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 12:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736253896; cv=fail; b=NbQbSztV2HIIQqH0aYj6+onIoFvOGiMehmJ04U3qx9GJRklsc8+tz5jDSgzxfmm6Hjx6gZGd9+fbo8wk1FY0A2SvKk+AY8LIwbrkHRAzTQotoMH14smH9xQ1cnGVpyd2WAFjmRy+q7+PJA/TDQKDFg+2RD5FkmnMSJdkBQ50Z9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736253896; c=relaxed/simple;
	bh=8aKvwkVmyFJhSWKT+VZvvoKQwT0qD921QwKmcM7OEzQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=PlsZrqIfWGYR9nCEN5VYDRhKZXax9LspweVK3kxxypkLR7LjnePoFrX898+NAXrfiT1ISFOdRWwiidVf/WtWa80BFDyghNrMewLQbtdU9aSfWDE08rA/ffDYmZb6hvldktY34ebPegm480uem41ROX0IUMYwQvG3klPdATBGkBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=douLzBh9; arc=fail smtp.client-ip=40.107.93.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="douLzBh9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MUCDSZKU5s2t5GZuIGSx/s8wSG/OtyFTPPSgi/SsvVzHKRP9SqwMU4tsTrNoiu3dI1IG80tc0lJMYSOjYMdhw78P1O3jwcAg5zZCE9YDltx0vIzLLJWkt1n2Y4n9V3dFl5Aa7l+j0Nov1eL+kawDa/84zYiWklh/JZUFUofCoqOgc7nlu3SOFtNTs1n4SmAQ1EYnnHNelfBQ6y9xdLTEu/UxaiTKiUu3esQn5TteJ0HIXl7z3uam2HcvnXMOGQF+c9LjgGtYl/ER1T1OgA0XeOq9YK0vI0OJd8uxtrzMrQ7qGWsG6L+zgoocr7shg3fICKKHtSny6UG++cKi/YLeIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5bF2s2mB1ZSASgC33QxGJwoC0MDtrlXSMHeq1QqojA=;
 b=PgptIDpXmE3wWg4T1WFh6nFXlM0IxzKy8sDBOOjKMKeU84Gq4BITEzOlSHhjVE6PMmE3PyJihDkH+aNqBsNFBaEMbaxxVh7gLOiH47IjAZOzkoH0//BJyNdwBNlN2VLTIHfkiHC1KF+BgavJ6wRIFu7q+vjlApOriZuvnjrGmaaDkh0X9I8WND+0aFMKze8mIgsA4xCjHm/IRI7AzHGi3TEZYgQJpFUJOFjM3/+r9HPNlVUj2Ekt4bfye2quraRrht4sGNsjb5I1OJ8/MHaoVkamf6UVCB00WJzmZQs/W2P4THK9FiggqOVNyjD6QWsSA6PeqIbKnUodx7KeInroLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5bF2s2mB1ZSASgC33QxGJwoC0MDtrlXSMHeq1QqojA=;
 b=douLzBh9ghAMguipYN6rkxbmBo3IED43hkb7RrnCkDP/PIiPaWURwewnGVpkmvO3rwKTblF2MtZyfh6u1q/nwxeV+Uo2Y63fl90IQ3nyXMRn0zDoFnYMCOQUgbAy93+mAgduAsk8h0ufae0somqxvUE118y3wyLBRz7mZPtZyTHItKkbrmfbwH4l0+9pVfbLPwJKYiVykyzrPjSvSbMELs3x3qv8sqZ+1huc3n60b+BOnHlPXYZz9Vh3Np/PsmYDBZMR++GyuWdm4LYSNjRBckEUHBDn3EiGDX1+eCPXHyuDJLW0wRkoVYNY0fiV/t2MIhVJBALXSJaclL4JcAbEUw==
Received: from CY5P221CA0130.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:1f::16)
 by SA0PR12MB4463.namprd12.prod.outlook.com (2603:10b6:806:92::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Tue, 7 Jan
 2025 12:44:50 +0000
Received: from CY4PEPF0000EE3E.namprd03.prod.outlook.com
 (2603:10b6:930:1f:cafe::a2) by CY5P221CA0130.outlook.office365.com
 (2603:10b6:930:1f::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.18 via Frontend Transport; Tue,
 7 Jan 2025 12:44:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE3E.mail.protection.outlook.com (10.167.242.16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.7 via Frontend Transport; Tue, 7 Jan 2025 12:44:49 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 7 Jan 2025
 04:44:38 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 7 Jan 2025
 04:44:38 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 7 Jan 2025 04:44:37 -0800
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
Subject: Re: [PATCH 6.12 000/156] 6.12.9-rc1 review
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <c2d9f267-7e6b-4909-9464-08b4ee3446e0@rnnvmail202.nvidia.com>
Date: Tue, 7 Jan 2025 04:44:37 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3E:EE_|SA0PR12MB4463:EE_
X-MS-Office365-Filtering-Correlation-Id: 6edeb195-24bb-4eb9-f08c-08dd2f19134a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SklzUjJoaFdMdVc1eWtwbTVya3Q1Z09EMkdsUmNEcytQQWFUY05Wc2FuNDk4?=
 =?utf-8?B?WDBxWHY1c1JldTlMbk8vRzhLMWtXZzgvaHpEbHJQaUpKRGJ6WDNwNms3U053?=
 =?utf-8?B?S0lJdkFnOTM0cHdZOVk3cDRQTjJ3Slc1ckFLT241ZjlBYk5oUW1QK3NFUFNS?=
 =?utf-8?B?YXRuak0xOGNsV0trUVZUWUhhN2FMQjlaYlQ1RDlYSng1MFZ4YmU1S05MakRw?=
 =?utf-8?B?ZUx1aWVYMkdZTDZyK0RLektxeVEzOVpPSkN1dmpuNDduRmJYVlpRMk5YU3pW?=
 =?utf-8?B?OHNjaE9ZbDMvTCtidm54cUNxTDFZN0tPaXB5dmk1R21pNVcyV0t6aW0xalhI?=
 =?utf-8?B?Ui9TZ1A2aC96eS9VcDkwZ3c2OEw4bWlSVm9KbHhTWDJKR3JubHRPTU50QzFk?=
 =?utf-8?B?OXJudmZ6bnBsTkpCY25SYWZReEI1bDl4NHFONUlXTHdkWS8ySk5oK3V0MG5O?=
 =?utf-8?B?MVJaWnc0bEdMZ2lOaXNDcnBnQkxsN0k4NkpvVUxuSjNPWnBCUUI1dVkwN2x2?=
 =?utf-8?B?eGg4c05EeXVCNFZwVFRaK3hFUGJFdmxkMEx2YzlCZEM2dTk4WGtuRGk0bW1l?=
 =?utf-8?B?VmN5NzFna0Y5M1B2eVNqMkNZRGRYdkVCS1MvWnBIaFN0Q2pwa0RRME9TNXRN?=
 =?utf-8?B?OU5RS2I3b0tIVUdOQUZjaVFHMVYyMVlMZFcxY0p6OHZUTUVVdUc0N1pCajR4?=
 =?utf-8?B?WlZ3UXR4Zlh2b0ppME9lTW1QNjRXakp5Nyt3SFlibFMzSUdMR2w3ckhvL3Fv?=
 =?utf-8?B?OCtIdzNLODArbWd6dVlpWmJwV1E0aEpvT21ncU9nd2F0OHp0TUdsYUFwSEpu?=
 =?utf-8?B?MzlmU1U3RlZIazV5d05KUWhHWkQ0MmZHQWNtRWNUV3BmYlRJS1VGMnR4YjlN?=
 =?utf-8?B?QlRmaElUY1hiR1ZNbEM2aWgySUlXQ2lmMTlTZDgvZkp2dVdSNGkydHNDQlpE?=
 =?utf-8?B?eEg2K2NHdnJHQUJsOGxScnZub0xEdER5NFBwaUJCV0FGVjlLZFZETFZsb2xT?=
 =?utf-8?B?NEpsYlhBUWltT1djNk9hTG1rZm0rK282allmMS9hZ1NOS1dwbUo4ano2dUJH?=
 =?utf-8?B?UFdzbE5BQlJ5dkxycVcxcFpvTWNhd1g1RisvelFoRXlibkMxZTBvM2dFQXF4?=
 =?utf-8?B?UlJESDNsUkhDbkFBZTZweXVzRzBhYjcxNUd2WGFCbHVTTXdEdEp1WXpFYWxl?=
 =?utf-8?B?ZXNCZEg0TWRxcmtib3B6aEh2RWhEQkVYd1F1bmZxWThuVng0cXU5TEo4SXFs?=
 =?utf-8?B?RklvbGlEVDNLcUloTk1DVFhwL1lpSUlIYVZWRVZ2ZVhLdWUyTkNlRmIzQVc0?=
 =?utf-8?B?NWhOelNFbHlhRW5nSVJGT2ZibURKSXpoNlZ4dkVmOVBUQURRUDhRUmZvS0xB?=
 =?utf-8?B?Y01GNXlhZVJVb3J3RU9iTThHN09VZUorNDBaUUdKWGtVZzJqRVUzS1JiaVVh?=
 =?utf-8?B?ZDFva0tncEpkMHJ0UHJVeERCWnIwMGlLTzljVXc4T1FiOEE2d2lueVFPNEt2?=
 =?utf-8?B?eCt3Y09IM3JtOSttb0xCUi8zUmFYRXo1UkgvVzY1eWJ1dWVPdjhsT0Ywa0tJ?=
 =?utf-8?B?N2hMVERHTmtmN0JDc085OEdyYitUbm9iREJOK2p2cjFoMEtZU3E4UVNZQzRI?=
 =?utf-8?B?b3pEaHZnQWFBTG42Rzdoa05OR0lwczJUTkMxVnVxb0lqWjR4bUQyNGcvYitw?=
 =?utf-8?B?R2t3TFlVTnllcTlVZCtRdTFJaXdOa2V2NDdFME1kNUFtUHV1UC9zZm9ER3RT?=
 =?utf-8?B?RlpwS0ZiWDVhd0syWmUvazlHL3phTUY5NDlYKzNrWlQrZGVGd2ZZNEF4QVAy?=
 =?utf-8?B?RFJaRnBaOXdUU29ydk0rNkduR1BJRnM4MTJGbUNiUm5YNzhVakxPRFFqbkdJ?=
 =?utf-8?B?aVJzL3lPVVlGMTZaRGdSNFo4S0VkeTN2cXFsSDVFeE5qcXlSbVFzWENyeStu?=
 =?utf-8?B?ZXRJZ0prV01TZEdiNExwT0xMaGtacGlDOUZmZnhwUGJUY2p1eFFDeUN4RUlP?=
 =?utf-8?Q?yQaY+s3xm0OmtImk8bc/RTLQQTMgTA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 12:44:49.9438
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6edeb195-24bb-4eb9-f08c-08dd2f19134a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4463

On Mon, 06 Jan 2025 16:14:46 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.9 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.9-rc1.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.12.9-rc1-gcab9a964396d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
