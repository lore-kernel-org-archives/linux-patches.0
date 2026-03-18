Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010066.outbound.protection.outlook.com [52.101.193.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B80346AC6
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 19:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773863373; cv=fail; b=SiJoAY0CNknZfbVha1fbMLG512QfX1rW1VnrdB10EmfO3GKOyIeac6W/coHyXHCnq5rmHyynvFMcUvTwNtYU3/AZpGoNOjuO5vcyrRBvJXOS4f3VTvdoYoSJFLhXjZlDvfl60IQuNW/96qEbJxM6In9RmoaFSP38ydfJVWfyID4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773863373; c=relaxed/simple;
	bh=e0QOmr/qCOs5URqItalyOVwvC7/lAIWuI13Q7pkylao=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=L8ioErYuqDRnEXzu1NWYrKUAtXbjRPaD00Rr8PoP+rNCtbKNm1/Ly4rVRHFmqfANnEUWdrxRbHoI2B6bX81FRXRgIyN5JAUntGyaidMpqlhx2TyusTjkV9XpSMuKnbToVAMhHVrIRrOV99+m9pn2zkPBToqN4QiQ234SNmb70cg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=geHy86EY; arc=fail smtp.client-ip=52.101.193.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="geHy86EY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pcrp1exGhl/2Afhh0Z8jzh6Xd087GEES4kLXLPHyPHGNS64avRsX9IM9Q6AW+ioinuTwOlfwv9C3U1Db3P20ZYb/QaRJrD77miUr8CC2or+nyXmdVHGSaFmrur3nR1izCQZ/ixNfArturLpQVbCDVFecYN0BJO9mpwomkAHWpZvwF3IDsRPuRrDmTy2eZNqsCTKpxaHnwKTlcZatfzShO45dPQ986yJBpo7lZq9H80CIE590v47fHHJ1v5zvZ9H0aettxbr6LmNhixvRk2btp8vLLf8yvm7SEeBKQRSX36uL5+N89kBMSAtS9URdvFHbVLzrUoIX8euGUOqPiSYfmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FaASYr7eUcfgUK/xeUJ7vj+ag8ZdfRFejyCLKVyZ1uI=;
 b=i/KpeFJk3UusFxyBHl15TY2iV8huKD8IZQ7Rvl+xjCemkh99wQPeiSNY4LcrgknrhskVzXgKhmH596u8vQYmV5If247oZZBn8tISb0vJOQ3pqJCZ5FpmU5puHaOjdeu79H5/CQEovKhZpUR/O4UD99h2mAR0BlKHdVSuVmVcCQXNz/SWhH1+fQrjdh9GdSbmx3yfK3+C1ydQpvaIqVDheH9Q4iqSXAcF22WjChIQrnY4B8Jdrop2DgDPS3ZCM8rb2WP3Bn+kxjYLQFxofmH+qkVYMnMg8EL3bj2hrbs3D3iwrOYjLFqECsfGpVBLSCASyqG0gF1ZLJKo6ul4NtIyBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FaASYr7eUcfgUK/xeUJ7vj+ag8ZdfRFejyCLKVyZ1uI=;
 b=geHy86EYBVbBChyX4Kkh6LRj3fwgPTWW0ey0vTcWEqm7+d6W/dk8wlx4iln5rL1kYcbtBySsybeGwzXjHJV1XyDaWVdLVgSpr8/xvu6rZe7ZdL53XlqAjMVs8XUg8bGjB85pGGUTvRfzg+7tm/awYnAr1m4b69c+1L8aBBv0m7uoizoD6tge7Xl9V+pKiWBj39myOzlWIzPjOMIn7OZ0e4RCRcHiP2za4Sw1Bq5E4VMldZtGnhDOYo+duz505+gDozK0JuGts8XSlNwhlUMOLgPWX4fb9EBLXMR0ZWWioOvo3hplGKJ3gHy8mm+wHcIXwJZJI5P+Gof4V6PG5XBjFg==
Received: from BY5PR17CA0019.namprd17.prod.outlook.com (2603:10b6:a03:1b8::32)
 by DS7PR12MB5840.namprd12.prod.outlook.com (2603:10b6:8:7b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Wed, 18 Mar
 2026 19:49:22 +0000
Received: from SJ1PEPF00001CE1.namprd05.prod.outlook.com
 (2603:10b6:a03:1b8:cafe::2) by BY5PR17CA0019.outlook.office365.com
 (2603:10b6:a03:1b8::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Wed,
 18 Mar 2026 19:49:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00001CE1.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Wed, 18 Mar 2026 19:49:22 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Mar
 2026 12:49:06 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Mar
 2026 12:49:05 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 18 Mar 2026 12:49:05 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@nabladev.com>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.18 000/335] 6.18.19-rc2 review
In-Reply-To: <20260318122621.714862892@linuxfoundation.org>
References: <20260318122621.714862892@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <87fe6711-5e6c-4606-a156-548aebf9703d@rnnvmail203.nvidia.com>
Date: Wed, 18 Mar 2026 12:49:05 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE1:EE_|DS7PR12MB5840:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d38d921-fecd-4876-aeb7-08de85277386
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|7416014|376014|13003099007|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	o0gAO16wA6cOKzBP9e0eFyxZVFaqcjtVz9JOzunwUYWtN3phLKoUIZL0pavUaQRl6lg4rF/aVjprjmZ0vUqZZmiJ7tf8Zz756uCg2jF0bgwIB2PMWOqEyBajbEck488JGMZadAlfKsL5MIGBaIh3P9Z4SMO9Btktno99gym3YoWyfE2z4tGZTyiUtiAvC0n/pIwHioj/RKCmmwPlGTqGhuLnitARwsNBjuqGoP1Wu0l/1w8nsxWfmSGH2g/MQbxsvsmTsnBU/SAUpJtJB6NkAf2Vwd5spGZt0b3Z1lw0cszlYO+EoVL8KQJK6JiAt79CxILkGQDWV0foxeeVpsbe6mFw16udc3I19FM8tXtARNMfXRBEs6Ku8WmuxtIpd4h+jIKS/1HuNXQ78f17GeJprXXYN3Evxm+eHF4NiAlymkhsyZuZWbvLrsKZ+wnBgl8fX0zqHNCGubShj5jeobXjNfXJ6X+Y/+r39A+seSOUn+jIpwA4F+64hme0r9ZBiwtSWhEu45qt2coSKltCmbbS9le+LjBpMou+SrAudhF5kcEv4WbfOC+wk+66YMJiJ1z47l7JUVc70oeRG9CrKW/gFSoJNEkfWfmBRVik5KOH6sW5HjHrU4w8tX4s4r52VABL1vQ21e3MDSmwsyKRDP0WsHwk72ZSLniNIzSRDXuuGqAra++b8MZNAFOxg8/gXKHDnrwKEmBcTg2nlN6MgDDv7t3iwznS9Ffb8Ozmidj2J+nZoP7O9Zx0Piq3G4DVTOOQ8hu45Pr4bRysmoQs+Tk2yA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(7416014)(376014)(13003099007)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TVRq0K6f0rrJX9eMDhhtZaq+3UDWORUeOccdAe8KMAC6eOPrgT7oYOs061w++gYM6KIFRTgi5jlnHmmCkDdpa8AFH+ZL0u2FqOI50bBpMwuYyTrJuX/pb03bNTBPw36zlNNnaOiOD4HYNxe/LbNWHN3D+oTbkAT8XdmNhzw41+L/12BFXkkJlTi3c9/d41xc4C1UmS50YGYjOJb1ombPcVkVObWlknHm/hfSa7VzLfr4OASVWFEyhq5tdYG9oMUosi5JGOhq9wa6IuJcJuQllUkVkPqgT0n/Nr+rlTng8DePJjte+mwwzgEHSIYE7BGVxe52mIqjh3GMfcub6f/gt6CKqNII++UPIuNpGXFZtGgMhk2kxD4PYoZ9i3TL1d0Oep+vzpjriHsGzRv+fcSWyGbuyxuPa+RjOQ3XuqgovqrWpQzxSdQzeYyatpKPXzIE
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 19:49:22.1255
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d38d921-fecd-4876-aeb7-08de85277386
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5840

On Wed, 18 Mar 2026 13:27:58 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.19 release.
> There are 335 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Mar 2026 12:25:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.19-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.18:
    11 builds:	11 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.18.19-rc2-g1cc312cd0408
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000,
                tegra234-p3768-0000+p3767-0005, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
