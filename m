Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011034.outbound.protection.outlook.com [52.101.52.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F713DDDA2
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 09:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774343102; cv=fail; b=q7b/RM4WzX67EIs0ol6jvQzUuKqu8W2NCzxsx1odKK0DfO+WN8q/qcIkGAIdJ6/lmz+DFavYlsCKrWObgqTNFnxOt1nm1baXQcvXw1axGJs8WerodO9OVo0dL6szuoSuHR5UCz1teZ8CITdAU7c+5d/9rhDhtWgKxLmKpyFFJ5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774343102; c=relaxed/simple;
	bh=GoKsTBfmpq8a+feYhNH7Kwlv6bMIzpNwm9wNuyFws/8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=La9nYUBRLMlbtNFW60h6jWqihYZ2Nn/id5OQ2WD/8vikk6QkXasrsxqL804p5JHgJC44xWu8X9Uzm2bb98tpKfAmtJW7rqz2fE8TxRDcLWiv6H88cmCSjKKCFjEHLgMtX/G+YO8EG1ckCHkKWtCeC43j4+tedY5wXPnA+segP5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p+w5qJEa; arc=fail smtp.client-ip=52.101.52.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p+w5qJEa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xbJsIUW5ifKnTXqIsnqgBDsu2UdEI+VXKeDhtgcKmlFucKGBy2YviLfgRfWRkzJWt7ZbPNFLKyrQjCdlsnYat+Qw4RE5KchQA4/gHf+r8VPL74IIgNONEAz43GYe8J5JZ7lIkUDX7bfE1hUEqQsL4QcQQwZRXQvVVnudNrdivn8SwP6EWbfoznsgtoy1xsXz5nVyQmb5fHhGSrYnVxxwe19DtYGgun7u1+Sr9gE2fPLacvpR4+MZy5jB8Zx8oF9ZBiIApIyqK66F/ClXWdyOxPbZ6WFbEpNfk5JhF+Qvrlm23WfqnfsxZNAWO3Rd9du2Aytg75cPt/D3/31x5XpWUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oprgeQ2/16Edaxu6O3qRazHOoXmdhv+iY6LWIFjT7Tw=;
 b=I8bgLFcoNmNR/ohAgor2bXRgp2VaJ2HF5/P1lPLPk8yYjtGeb7hX7SWvSYJm+0KTnMxLPIAkfwWSyieByxku4f7HoxHcaoED9u8SyVVBpY0Q7+pxvhFVS0yvTpCzeb18LEbseAdPQs+WbpGLyokPfXf4suyBftowPzscvzKP3QSXsDv4ltqfvpxPfaL2CNqfS6WFF4WrCxBAaCakJEDaVRpJkvb7qHhAMtSglJhUV/C33Oo8JcPFqTkOfla1ZacxXxxj1FAcZ2ktqvQ18EyOsP+oOyJgHfvGh0JeF6/yD0FuvEDdxGOk4zTzmno1qi6FV3oSLZC2or8utW2cL/p7oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oprgeQ2/16Edaxu6O3qRazHOoXmdhv+iY6LWIFjT7Tw=;
 b=p+w5qJEalXNP+/VqB6OupEPvPzZjS9ANR7B3FZHvQ9VjA1hV1JXUCPuLCKCy7Y41XsPnSQfAO00D37FTGN501T3ZdAahzBSIxRdGR5JsiNRyvqmaPjUagdv3L/NOXgjbUZYZi6g9iDWUmU0zatz9fpfemqrhmYN05lNd6HT3uuVaAQL/4qdWb7iUiL1qXMXdzbHA2rYps+KB35JkiT3t+ll3pLL2+/SMSboImo68AyTOUVtwwpmM3+J8SlWkKCYwYZfoX6YcBfQX93TusqpscyRx+2//Ql31/zYuYZkIGRs33En2wNyvwm4gOK63T7HhmuKV6lV7Ie1cRhhu6G9s9Q==
Received: from DM6PR03CA0078.namprd03.prod.outlook.com (2603:10b6:5:333::11)
 by SA3PR12MB9106.namprd12.prod.outlook.com (2603:10b6:806:37e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Tue, 24 Mar
 2026 09:04:52 +0000
Received: from DS2PEPF000061C3.namprd02.prod.outlook.com
 (2603:10b6:5:333:cafe::59) by DM6PR03CA0078.outlook.office365.com
 (2603:10b6:5:333::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend
 Transport; Tue, 24 Mar 2026 09:04:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS2PEPF000061C3.mail.protection.outlook.com (10.167.23.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Tue, 24 Mar 2026 09:04:52 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 24 Mar
 2026 02:04:51 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 24 Mar 2026 02:04:51 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 24 Mar 2026 02:04:39 -0700
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
Subject: Re: [PATCH 6.19 000/220] 6.19.10-rc1 review
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <65e08ffe-a53c-4bbd-9b55-33a2c204ceba@drhqmail202.nvidia.com>
Date: Tue, 24 Mar 2026 02:04:39 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C3:EE_|SA3PR12MB9106:EE_
X-MS-Office365-Filtering-Correlation-Id: 94e0d342-4f85-4fde-88d0-08de89846911
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|376014|7416014|13003099007|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	TGxL/kTlUkDFhraO5C92NKTWEV9WMGLGzMp3r5HmOedPrYbfE5ds1ahvYFr84NnPoun5y6btuY77Dn/TRAzQ9FMSvehlkN2UROC5JGYcRt6gcIsjIeNX8H/Lp9OGpElkv8/HEMzkOrdcqd/UpG9E3+sLJ50gY3GIa9UJOHwC27L3AyxlfJP8mwW7e4rXjf9mxdJqj11u03VOUoFN0QB06JL5h3zXaH+CTbqlTtklG0YDaGGa0vP0l/ykOXXZzbtVM76Hum3q1gwdQse0Ib1kyk6cj06oH8MtNMcXwFui6mrxguHc5piJzKv45lN08VnrJW5BZq7MBZ7LeO3udPgVwKjaC3qtLVDjoe9Krmxx8stfLP5hUcsyItBQcprlLuqN8rj3eAN99XCexB6OiL6seVdRRT9RGQpBUiIP0BqA1IWkUCYn280EvJi6tcZGJLUDlZ70s+yQS5I6RsbiUF5UGx2mbNaeu/tgD8lm/wnPpumw6zOcMGTtzNnW02e/kzgMrkzxyF3L67pP/R6pCNmNRX29kU1JeDM9QvvOzeI5dvi2jxsTUjIVLIcTdYvaP4fslpvimQ6K3eFqYliSCGygLy0SJLTIiE3lBfqtca2iH9bPCYWBsjRZtJlKPvyjVxg5xnuvl5BIg3xBn/0uBxNiI1fJp2zO4ACuAbl4TuMf2DPQ0wvirTBzh8hKuym6bHgq0bXrzsY8PuDF0ET+NzHzehM3qOwKQu/KCzzSRo56X156ubuGnoHl3pzkTiKBWXWfu7hWYAb58Qs7a5jvGJC0EA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(376014)(7416014)(13003099007)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cUo70JFFEtIoxDA0z9FWyQfHSQDCluYQhsTv/Daxvq1TCvUnBa27sWJDWZzJvIB5eZ4gsnLfkNx0wgjaWYmrAVk5m0NqUDGaReFu1ybsnmUw1wxLTfSxH9MJ7qQILw0HfJE98mcmqHRPyJ1pTSJLbaWYuKNB7PPqKawGqKe5NC4aFGyiNJ6eWwIFEfn+HWdwn2oprajqJ38V6b55Sm/pHFasmkogk43fRlKmq/5KR5sz7fimLMzKL1IoT99y7YD0qQKWKNMvvkp1Tr22jqrLVcSchvBWzuI/I1kd+GrLKCfHucQXd/2hQ/oMRWlgnYD3PGWVTgCtAO0ks5nNyD4Im57oCvgwu1IczE7YYX0hbQO9i5qvIsHPb+iOxZMl/mmzE7EdO4QS82TIX1mnhSEb1j+xKgs9ZKz8vKgXt9ZalhnCFkQddUJMJTLPigfkGiJO
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 09:04:52.3391
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94e0d342-4f85-4fde-88d0-08de89846911
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9106

On Mon, 23 Mar 2026 14:42:57 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.10 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.19:
    11 builds:	11 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.19.10-rc1-g5cf3b8242cca
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000,
                tegra234-p3768-0000+p3767-0005, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
