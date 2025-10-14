Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012004.outbound.protection.outlook.com [40.93.195.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16ED314B7D
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 13:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760447390; cv=fail; b=V5hw45zKeY0+BuMbEAv4BGsVRTQFFNFhEQaYWTC2lCSAfdBHH9SK8hpAkpQxVtrlo0swudhogAlAn4qznMy3bSNDOWoZk5IA7k+VVzXIdqynVgYLd3UXesrhqGJX8ha+ii3denylEk+3dM0JNy8NY9L1MaxxIfF+jL+ZMjoQlXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760447390; c=relaxed/simple;
	bh=ktxYK9YZ8ZXm6HuihNlkGPtDxcP7rNbxjDwaDWzWgjg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ekFDyfe+PbZ4ttzqP5OQpdo5UTHK6dSxcIWnZBMLXiY86WgDyTrI8s5qer5R5skp2q2VqvGv+9tAwAQqMGFCmpAWrPhSFZFHpVisT0sqy/VeoaQCWjU6Jdy3CNWTF2ld1C755uuymL9/GRjXx2DRQNViZ2itor23QZlmTOl3ml0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FHoYdPTX; arc=fail smtp.client-ip=40.93.195.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FHoYdPTX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tC4NQuVqqjqvmV5k429GYz/1qhgOw5xP6iKm5J3LxvR8Am08BriXlNrTc9Y/ervqaSewnQqXt0TiGqO6A7GusLkMgelIkYMvb2GmLkHvu4CqKG6GLPR5Flenk97gP3+mqfJLOwpUCiB5Wsb0IX9rLDoQ6GbtPu9cCv0KNr5EVt0UM70RlJwp/+GJPUgDtN483pUkSObKgsCMTN6egzXFbw0g3Q/jNCvm4cuACxv2UGGSnLVAmvhZy4juFIa8uy1BFacoAP0fkJw+DoYadhDASjSkGikYqa99zEENUad+6AQ5a13TZ9+j0KP4q1W1OtQY3D0oXf3w6RR6cvau1uH0GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iz9Ebc9hY0RxNSw4CjQ17WWljALZMgg2iYOZvTba+aM=;
 b=il5XMwcKUn99VvqgMZEi60/Zt10G5J3+mnaqnXvZnRhADob1bpD6oMKgvMBem0sxl8vnyTXFHPsHExqsLsotCVAcpXBk6wIUeBza8zwKEJ0rkHOlPTo0C1VBXyfe48XputQN+yItFRqcPIcNOaXbr7ko8EbywMXxHydHGwQOk+KQldD9PUZF+d4YtFdXx0wXkCPssQGTKn/9A6SowiP9tCoW4yZCDlxhwJlHmgepV8GXWqt9mbdGOBZZ8Y7t1jmo11NM7VBXOryUUR3XQqKJd8VIj0eLX6rFV7GQbVIr8i4GXnM1xvY9ihSOpQxNKCKPzRBwm3zFyDHvRhjOLJeSBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iz9Ebc9hY0RxNSw4CjQ17WWljALZMgg2iYOZvTba+aM=;
 b=FHoYdPTXb9HASkPk+DqxCbMrCYrUKgMSVUtBXzYvPt272DAdT4AeEGIGNbr/DwSqkQbuywu+yg6lYJh7GUop4XtNedLWDgX7IjmUzUmKCyYQmJ0ir78ATOgr7e1Tq62YT9nNRDO9GnoIfvq4Y3UJTJ+HaA8/UQt4l+QONbdBsOrkRbO6W9VFoirgptEwEWR3KpJyWyjCQbexIbeit422BMA6p7Gc4Mc4p5N5rxlnmGizf+rGU3mHB6bzlZ1r6Puo3hs/oooVcJ6YG++sYIiUkceqGBIcFjpcDYeEtDEj+kKoirjGwxsxj3SZSu1Np7NIu5NjDOfKGzriezAgIIzV+A==
Received: from SJ0PR03CA0208.namprd03.prod.outlook.com (2603:10b6:a03:2ef::33)
 by DS0PR12MB9422.namprd12.prod.outlook.com (2603:10b6:8:1bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 14 Oct
 2025 13:09:43 +0000
Received: from SJ1PEPF00001CDC.namprd05.prod.outlook.com
 (2603:10b6:a03:2ef:cafe::b) by SJ0PR03CA0208.outlook.office365.com
 (2603:10b6:a03:2ef::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.10 via Frontend Transport; Tue,
 14 Oct 2025 13:09:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00001CDC.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Tue, 14 Oct 2025 13:09:42 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 14 Oct
 2025 06:09:26 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 14 Oct
 2025 06:09:25 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 14 Oct 2025 06:09:25 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 000/196] 6.1.156-rc1 review
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <4ad822af-297a-4de0-b676-6963760a8384@rnnvmail201.nvidia.com>
Date: Tue, 14 Oct 2025 06:09:25 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDC:EE_|DS0PR12MB9422:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ff67f58-0288-4f92-d729-08de0b22f0df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?LzFPTlowWC9ldlloSEQxSS8vRVVTWkUxeFVhMVR1ZURhalRuaVpXR0svSkFJ?=
 =?utf-8?B?c2RXM2xqVGVUNitTZkl4eWlSS21oUTZjMlJ4RmtHMko3b04xbGNDcUtyOTJt?=
 =?utf-8?B?ekthRWJzdnpyVnIwc1hCVzErODRNeEJ4dENlZFA4cG5sRDFPSk93UGtqNlVP?=
 =?utf-8?B?QTJva3ZzN09QaVRlTXVERFhleE4vVm1DOVd5OFk0c1FXQXR2b2dTT2MwalN6?=
 =?utf-8?B?SW9aZVp0aGc1RFp3RUpVQ05zbkJHSUZYeU9EalNFeWNCOG01ZWlhZXU5Nmcv?=
 =?utf-8?B?RUltQ3pqTGpBRU1UTlZkSXM5RmphU1g0NHd2ZDFxek5wMjFTVk8vczY3azYv?=
 =?utf-8?B?bmlOdEdjNzlzVWNLS21uNEM5Z0lvRkxZaEh3RVI2TzVIK3I2bm4vR0Q2WVh5?=
 =?utf-8?B?bTlSUjMyUnVwT09IY2RKM2lqS3IxMkFIR3liajVXbkN5bmgwMnFSZTVkWlNk?=
 =?utf-8?B?TDA5cTZKVzBNTU1RVXoxc25kQmlFL1p4RzVDWENYdFFBRVlQUnRyZFM5Mkxr?=
 =?utf-8?B?M0MxVTZPQkNWSElLUEY1S2dLUmpZTENwRlpodUlSUmhxdzQ3K1dqTGxXNUxE?=
 =?utf-8?B?T2dFQ1c3Z2xLQTN4MnZKRlBuVjFKUzJVTDlhbjlpKzNRSWNpTkJRRTBZVWlR?=
 =?utf-8?B?dyt3YjVQU3FFZkFKU0pFTVRKV1JFNGNEMkg5VWs2VXRSVktJUDBJL3pnYzlj?=
 =?utf-8?B?NG1PdFBzVkhWMUkvbS9LRXpJckQ0RmlJclVNdm94QzNrWkZ4ckYyYTU2SkdO?=
 =?utf-8?B?NEFNeGxqamc5eEJPZ3ZOazdVMVhmZ3YxQTkydWVYZE5EdzllMUtueTRkNnNC?=
 =?utf-8?B?R2dycTNpblZ6S3RGZU1QcUlzSytvTm9Kb1dZVE5TVFpJTFgxK0o1Umdqc2gv?=
 =?utf-8?B?UFY4bVg1cjdpOWRScmc4RTVWMUVJYTQwNzhZeS9MZVFjazN5RlhURlFWa1Mv?=
 =?utf-8?B?citwTFFVR1ZxOVp3bnNEMGpkUHFEODdFQ0tva2ljVjRQaGI5SWVUeVo0cEoz?=
 =?utf-8?B?YmdTK3hrOGNQQVFvSU5lSEM3K01WOE81dkFnUVRKWlMrejlxaHJaNDRRRTdT?=
 =?utf-8?B?K1Q3bGRUUmFyb1VzTUpHcTZ0cU1WTmdYbzR5dnpkVUNjVmFNdS9RTjA5Y0NY?=
 =?utf-8?B?SFRzVVRlbGhXaUk3YXZaRm4vd21lZGdySGJGVXhSelZKVmNFbURmY2pXRWhp?=
 =?utf-8?B?OTZlU0lqODV1eURGMVFNdnM2UldHL2pPenhSeW5OSEc5NHMzblYvSnlQdW14?=
 =?utf-8?B?RW5RVFlYYzZFRDNJYVcyb2hseGtVUDZBRFcrZFZKL1J4WWhyajExNWdpd2dl?=
 =?utf-8?B?N0lJNm1CNnFCK21qSnZXZHgzd24xVTdpZ21SREdzRVZRdFJzUGExaGRRMjFx?=
 =?utf-8?B?S0RoZmI5Ly9wSTFRNVlHKzBLOEt0MWc1dkdtZlQ1YkdCbjNaZFRkS29kU2lE?=
 =?utf-8?B?MjUyQjM0VE5JYWo3dmtBSU5ic0J3VFR2aEtydU4rU2JTUWNGZWM1bi8xYmlM?=
 =?utf-8?B?TFlRMzlxVDYwcnNMVkI0ZUVnZWlnZXp0eVlMbjVnUFE4MGZqVEk2bkhsakdT?=
 =?utf-8?B?SEZGUWhuaXdKSjM1cFJ3L0NLOU9yajZkN1NxM0JQQlJRQllMcnBsQjhJNXN2?=
 =?utf-8?B?SldHSDBIeFhIcU5HdXoxbFh1K3BzSnlBc0VMOEoxTk81SlVCVUdudldXeFJh?=
 =?utf-8?B?ak9NRDRRMlZJSFB6OWpVbnczN3RDRFV4bHBwMUZSMlBBazNJZURVbHlyU3lU?=
 =?utf-8?B?bkI1UW5pK2xhY1dWdHlOVFplNW85VFFxcDJkVlZ3YWN4dC9QNW5ZVUhjNis3?=
 =?utf-8?B?TmcvQ3QvdlZybWRiRkg1TUZyb1lacFRFNFUvMEVaQU5Vd0RxUktHM2ZKa0Y5?=
 =?utf-8?B?S3NML0RjLzd4MTBNYUtkRnZVSGRDY2hQcDRJeW1Fcm5BSzJBdERpU09qVk4x?=
 =?utf-8?B?QW9tM1hLWEd1NldSa2pIRHJDNm5tQmFFemVNVG9UeTZQbG1yOUY2S3hUTDBD?=
 =?utf-8?B?bWp3c2NkY3lrKy9PSk96V3hOU2M1am11V0VKSHpzVk81T25sbVQyNnlpMTdl?=
 =?utf-8?B?R0FnNGlYUXBmVmZnSVJUd2drdzhSbG1PWDJ3NmY1ZnllRkVydVp3VWdPdndO?=
 =?utf-8?Q?D8ZQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 13:09:42.9279
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ff67f58-0288-4f92-d729-08de0b22f0df
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9422

On Mon, 13 Oct 2025 16:42:53 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.156 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.156-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    119 tests:	118 pass, 1 fail

Linux version:	6.1.156-rc1-gb9f52894e35f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py


Jon
