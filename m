Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010042.outbound.protection.outlook.com [52.101.193.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D86386554
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 07:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776153254; cv=fail; b=t43UpBu+4WmSH8AevsoQLZu7nv4jukU6Dzhvl4F/Hwfoyeq3Omp5DzDPrvC191jQIgU0qzwMrWhfHg28D0dyB541VHLOqNzN0f+sQ7TF7Cuwqh8bKPXL9IcbvzXYsyRrBJIBOAE4eFAZfPYKZqBuZZR84MhW2/7fpYYIkEVRbh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776153254; c=relaxed/simple;
	bh=u4J2T3rLeAIDOw/0Ugqdf42QOnSg0jwQpH7BtlxTMlA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=LqUDNiI5cEBV/x2/x8L5vPAV3VqCSMEwuykZoxTqOJLjyoFHgQ1uahXFvqKGxqXhEqvCDgTnQUSaUj8sBcJtvKDJC9tFilp6MqP90VzGm9nxCHg9S0AwENTPdiRL7NBcZ1TztwDMgvDcLALDKRoTlsc0euumDOpxxEPMYamQjWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cW2SYDq2; arc=fail smtp.client-ip=52.101.193.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cW2SYDq2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YDTb1GiMtLjuE/U6vsVzWeKemKmTlWfAdBoVdMgXnMWLlGF/6zC5P957D4xgBvADMQbLqI93/UkkQLJl+b0t9Gm2BYIxSsxcSRtra2NzDjwWXz2GmQXch5lOQwRjMXSr0D+ZvrrRGZeVnj7F6YtKOV7fOBueUPucfwBylZBTaiQ4Goizgqycscw2gmw4fZDQ+rkyZ6yW7VmRY8yiHAWI0DOBJpa2GLaESLrYF3OoksPvbxceWDZo+Kg8YvkBY09D4ib7Mb8utFXuJwR1igOJ3uFsdq+1GSRFZDzIcm4GiA6GDg3Ap/AZnMrYh3mKEJif3sxfDkpmrwDa3HmBsreAgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s8fLaLGUEOPsAFzTjOeogn52DI9uoQMFZd7lJ9N/E4o=;
 b=fg5R0VeRiATOdugtNSIozUST1BmL77boRz098lI0B4EWf7+f0jX7C3LNIb9qygg/hFQ9JBFo8XyM18bpahNJhZUEvHNgjDPPVQg+fyo0bZp2GQO4OyOh2efLi+Txe1gbN4a212Nx16HUU7I2lkTyY+Tby/lJMuCg+KWhJ14uLddAW+txNKsrfR2GI66LXpk9VzQ54zyxWM7t51Hwz+OqEJkAvjVLBvFglhipxLckaGGrlefuEHteFeOGeOCwysJ7B0oWD9hFCIzlYuoMT4yvcBv6Z7SrVkJJbanRYrxyr5HgcU7R7r8CzDu5++w5fo1qBnL6IWlcWA7FIWMK4Ad2lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s8fLaLGUEOPsAFzTjOeogn52DI9uoQMFZd7lJ9N/E4o=;
 b=cW2SYDq2B8DrwB+g/7hOSWbshxFCL4y5fYxCdnrK071mGzo41Y6WyJ4UGrN2EvjwEYBqocrxpDO3SflE+D3UeAPVS/40c8zKCTJXQ1dBJmuA4PDBeCdhgTMIgsUvEmRJ/4eTxDrhpHXqe0bGUOKpEJkxkKfXUcymWKSq16xLcowXUx6fqp8bEVB/UDzfPlbLE+nhrwPYh3L4UlVbdAGzxDnu+3qCR1+owIm6mojbXtjAkeJ3FeNYSF6eOvo3IkwOCjZtcpR5JPpqmO9k+/eNCYCqq/83vANQft2etXrWD2XAL7S2WPiszJuFTgE9Sej8hziCU+s3NQU5Hv7Ymh7lAQ==
Received: from BY5PR16CA0022.namprd16.prod.outlook.com (2603:10b6:a03:1a0::35)
 by BN7PPFFC4F04B28.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6ea) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 14 Apr
 2026 07:54:02 +0000
Received: from SJ1PEPF00001CE5.namprd03.prod.outlook.com
 (2603:10b6:a03:1a0:cafe::c6) by BY5PR16CA0022.outlook.office365.com
 (2603:10b6:a03:1a0::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.48 via Frontend Transport; Tue,
 14 Apr 2026 07:54:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00001CE5.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Tue, 14 Apr 2026 07:54:01 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 14 Apr
 2026 00:53:49 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 14 Apr 2026 00:53:49 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 14 Apr 2026 00:53:49 -0700
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
Subject: Re: [PATCH 6.1 00/55] 6.1.169-rc1 review
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
References: <20260413155724.820472494@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <0884d3db-7c6c-4ec4-92ba-c5ba9b89607a@drhqmail202.nvidia.com>
Date: Tue, 14 Apr 2026 00:53:49 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE5:EE_|BN7PPFFC4F04B28:EE_
X-MS-Office365-Filtering-Correlation-Id: b1ae1c02-dea2-405d-330d-08de99fafe25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|7416014|1800799024|376014|13003099007|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	melDMuYuSjW403uF2JMfWgLauFmyA/VkD5n3EV0EpNmmv1QRerv5TeaityQFMMR8tjsuo7rrW7xUse1L5igWqRbu1qOmYWgx3hb7xtfb0w+VNgEZNbXFTnRay+Tslcda/2yBlC+ZJPbX+9b/FpYLpYFbFmaSom8lck5wv0WLXF3leU8De23vmIpJOH4NPf588Rq0ZppSPNz+GXi3hzNs/DeSVj3aeHRKhU34jK+ymefzXA89QSIGqwf28mzSg5q6I+tDOBXQnLHSunP+YJE2i6RTlHO6RFDN9+1CmzeIGGUJ1S3Vioc6puJSlYuKYe9I0fDXlkXfKdVl3YsK0M3NtPtNdUvXlYQ+XfRcBxK49UZ9aFsvxHOuIkeguFpFy2iqQnhsRMvr3wwbh0N7c4s1smL3EWUdNL10pWQGX8F+JqzVW4wJkXewKRzRXjzP6V6Ka7Fq64RMey5ompIttqcuEeVMn0BEdFTTpbpOq1IJppGB5yH0kzYWFuO6YhjSpybWY9xbgLHAJv8lVvcHiRMgqNbO/6GGXvzdNTP3tLAa7wIsc/rvqNhNS5RDh1OQSoW4HAxzzxG5SdN4TGoVudpnL4IGI8OPpADAhtNJI4IV62ZlwQIRnn8tsbRK0AvRoy/y8FopC0oMF4rdfyAGaUqEIzy+b2ooOUA7N4tFR9yA8hjx9gpvJFj+KibB8XcMxdGrntv0/BjH/2BeF51wxWlk/4LaWgubzubUe5860uJa98FQuOZPjid3t6JD3tNPFQ4GYG8NhSsNG3KXElnjWOhJpA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(7416014)(1800799024)(376014)(13003099007)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KxUwE6pFMEJ2tPOL94Qy6GflbTV/Pz4r4gGR/PnkrGKOw/zkmDp67XbTRPvBZ5GWXjWV6vL6af0MQ7VMa8khnEq47+VrFUnX7yom8w2dakXQmLtEuyrN3Yx9t4bakoLIL9s+lXDex5f0odKviBF6hkmUxGeStlYCl++D7fEeQ0nQEtQBAytcM5F7jieFBg+bSzdJE9DwjigPYt4gmwdEaC4PSyeidYSEirZ3akzwUrzQEnGF6cOs9dsceS/lnkSovHfDzWctVPcXs7B7zMwQSktl4hEpREB8gXWvwXLed0ErgaUWuaAmRF8omPL4joTi7rEmZvfGlnkzFoAY8JSUFSQGuOIMb2lKmTO07XfudegHj1MqTzjVW5cO0YFg9f+6wRsgwFIbdKGFug8iD/BqesILR9eWNL5FpMlBPlM6fy2to5vq/uuNsl/V9O82YrHi
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 07:54:01.7582
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1ae1c02-dea2-405d-330d-08de99fafe25
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFFC4F04B28

On Mon, 13 Apr 2026 18:00:34 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.169 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.169-rc1.gz
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
    28 boots:	28 pass, 0 fail
    132 tests:	132 pass, 0 fail

Linux version:	6.1.169-rc1-g6dadbe7e9a85
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
