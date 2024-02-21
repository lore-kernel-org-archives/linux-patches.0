Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2054.outbound.protection.outlook.com [40.107.100.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D064D5A6
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 12:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708516960; cv=fail; b=LAfqYCyHaXfp2e9n95qFrd9102anMBRLNu5T8bt7+i8PrPpk9CH1b620VcZxeN+WrS13JWpoOedRFPBPX3s5/SXNBT+9q9PUeSUwugqQ4/NUqfOf3FWZJDVw8kl3HOhjDWSwiuzYflV3lMlgc2+3u8k2VjUFtPkA4DxWPjIWuSg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708516960; c=relaxed/simple;
	bh=TxOIVKTm/sxdwfJoGozcs8H9hjcihi0xspUkwB/Www8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=EqlWSZVYiFO8CCdvDHEihdEAV3djPJ0tro9RxEUTud3TNPZcutuRCPXUNbNY+AxPPxVqaV3T9fFWDpuAsa8a4b34O+yiHDjQ+N9kb14SVA/RaSxCytLSUmrEgty16j3ALht+qwIaRsQl70jRMRJfJWeSaEfF8EvzeM4o1Xeu5vA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jI8gepIA; arc=fail smtp.client-ip=40.107.100.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jI8gepIA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ClbebR0qWMLdr6Z+8M/Ec84sSa07gWUlYtk8Py8fZpT14hHfS4yyx0AxJEYiJ9PAQuJmnDDWhUt1+B2krE/qCddDznhEKS9WGRAzIXAnxkUCEXSetHEsl7K2n8/AxeZIbEpS0R8a8/HY/8Cmvj1bloHf0NhG1iVN1fyqWU80/v6KVWbYsAfXme2DBs4B8pMoHWfN6Bd91ooFwK7/lXw0Srit1yQLDQXWe/Cijr1b9IT2EBXJzfkCGi1MX6yD/Zny/EpTDShdQng4CgGi82WU1kNqM0xj/qVGOgt+C1iNgk1GiXjrTRgVKnAUQSSKgExYBQQ+7LaruPzSGkvwC9sVBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cJLaZriLC/OEYBcflxgJrJpwfsrrO1dBh+0KqPJCzhg=;
 b=ihQCzh1+hHx95jHMC+0JkuU6KpDXf8ctaJ2LG21ECIvUy99Il1A7amxqK2kzE68dIUoP0CfLgHkZnPqgmkZKFc9AplpXvkyxSJeHmVLoOQYBZtlm8CqZKe2Bte33VDQFka91p3+fLqk4llmnhI91xdplpaxLSY2MSZx8sgSKnw8xRs+Ssfjnx2b2DPpNsXt2Jk6vfLKpCWBQwkKT9CbUxidRgQXy7gJtfqhLT9dc+MveQ5jXe/Hyk0ryOU+MPpC8OGSB9G2tX21jBg+n35IbvWAlbsbxN51TYxUj3Izcsw+jBcKOG8kwNd2HYOJ+JPivhH4HNCe8unc9wlrKlifzsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJLaZriLC/OEYBcflxgJrJpwfsrrO1dBh+0KqPJCzhg=;
 b=jI8gepIAU65pzY96bpDmvpC/rRIQAWkSEdKRGHeBbxBh+XYacmIj3XO0BHzvHa0XFFIsRzWoZXa+T0030K31CwSa/qV9krz4T7K/KUQ9tbQZqOgxJpZJoszTexbu/ryPOR1kagldFAoStUyKwNhJmqbcmQOkscJcmt0aYeRX7goObew7Sqg3Vbmpfwv4I0hhvTp4Mbzm62hzZCWanynKRXDbtreLjzdt73UnzEizFvk17WN+kOj4FhtF7uKnJrZLHO+poBF94WjCetxMPh+EUn+/1j9/QeVNXZeHbtpvgQBaGZdOTftdm6AynWkE1Db/VKULdTqkFeVQTqHH7ARE2g==
Received: from CYZPR12CA0008.namprd12.prod.outlook.com (2603:10b6:930:8b::9)
 by SJ0PR12MB7476.namprd12.prod.outlook.com (2603:10b6:a03:48d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.20; Wed, 21 Feb
 2024 12:02:35 +0000
Received: from CY4PEPF0000EE3F.namprd03.prod.outlook.com
 (2603:10b6:930:8b:cafe::82) by CYZPR12CA0008.outlook.office365.com
 (2603:10b6:930:8b::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.41 via Frontend
 Transport; Wed, 21 Feb 2024 12:02:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000EE3F.mail.protection.outlook.com (10.167.242.19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Wed, 21 Feb 2024 12:02:35 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 21 Feb
 2024 04:02:22 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Wed, 21 Feb
 2024 04:02:21 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Wed, 21 Feb 2024 04:02:21 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <allen.lkml@gmail.com>,
	<linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 000/331] 6.6.18-rc1 review
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f6cb0f1b-cf26-4fca-9130-e077f5606eb8@rnnvmail201.nvidia.com>
Date: Wed, 21 Feb 2024 04:02:21 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3F:EE_|SJ0PR12MB7476:EE_
X-MS-Office365-Filtering-Correlation-Id: e664c765-7fb9-4b42-04a4-08dc32d4fdc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HCBdxhyzyVbz8etL8VoRDmfwWBRFjZImvnFmdUHnNbeLivNu+6lvbu6sCW9fHMs/5jeO1TPFhczTYGiSzKR8mZR2RsZ1x+KJphFU59qBCDSfCGAdHa5JlfFmgA7+Ulo2fi9ussafYNOT9B9npWto+8WP0v8Sfdlw5tik+xNbKi1g5EMkIHibPzgElqasNbj3XD3aKthAJCFJcwgCoKV18sm/bVjgnqd0Akrfn1S4kIKRKoFgXXmJDC50SJdvt8G4wQxKxYhqKEPHMQRrfr0m9dSTJVZcxpUA2MvZ9qitZW8a4xE0TFACT6wdmD0kWqzpQ5fSn4AXMjJnBmBL2HEkpbg+uG+MQijbjmZDp/CIUhB+cM7rmV4xVRo4aaAsTA2nuzBKPYifP3bu7QvAksPvLKc/bWwFPkhqILloUfb7tb7IgNUtrisEFkpvtW9lLOFDbhL2KjBo5+f+ixtzd7/ufxlI/ZDfdj53Y0LpnVT54CAVr66jKoRUbifoykWj0ufLEkPE8bh/oSBXsNNBcfIoMzvrrUru61ZUoPwiRWu3DDlomBQ/5nc75fjKFDJ9jzj5YBsZ4N2VELnGnL0y1xOPy72TyrLd3iJ3hzJdYUKyGi1b15v0YDAsI8KJVlqDbqSChsBr9fYZ1BqypShupqHSe0NZ4zt4b559MfYiujotjdFGD4/4L1TMNfoIXeTrWJialwNDUw2Cjyuy97YhbQFi3Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(40470700004)(46966006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2024 12:02:35.0430
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e664c765-7fb9-4b42-04a4-08dc32d4fdc6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7476

On Tue, 20 Feb 2024 21:51:56 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.18 release.
> There are 331 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 Feb 2024 20:55:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.18-rc1.gz
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

Linux version:	6.6.18-rc1-g0acc3ae78792
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
