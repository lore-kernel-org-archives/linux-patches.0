Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012059.outbound.protection.outlook.com [52.101.48.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3493F2D97A0
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 09:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759309941; cv=fail; b=ejHlgN6qJHLgBDAJ3D4lfdvdmJn9UM36k0CDI54Ygew1PYPiWpflX7aL9g/WC5zIHhXzbSg/IhDdK+28fJ0GftEbk29o05wgEuBhip0MbxUOGSwKDlSf9b5miaukYcj4PCLxaf3Orr2Vv+76+48rHxJ3SPlL2RVbH9Q1dRianLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759309941; c=relaxed/simple;
	bh=N6Pw2quToeeDOik5zqwfGA7CLgS62ry0X2cW0fDQh/I=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=giPTTAbd2HyrIKabyb9NMx52jAorNahp1osOn6yN/4L/hn3zDfT5pLcaSyrX2nT/PT3Tfttl2ip59qfXJ40FaXX/vjUzjCViKT1D/QNtyc0AE4h25fuuCtpPtcTcX2xbICJ3nFMPMFVCPdj47gWxu49Y7lMS/By9l9BrdJkhUmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=U/nEaqnc; arc=fail smtp.client-ip=52.101.48.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="U/nEaqnc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e17DLMS84j8gzeg9GYF0fUmQHLyLXThkl2pdp5UgFTY3R2lWsMIuziGMweLQL3moX9VPRax/F+2w1RZYjaooJBhFxUwr6d/wQol6B/3F+4jnlxq9dsVqx+LHN8UyEdKpGGv2X4Lnz/+tv0QMys6LGhOWoR+wrdntdA+PHyIg4YT/s+v+oPAgkemLkZC+pY2mzyC5k1aSdH0Y8/InSam2wB7rUuGi+YzbkPGqVZoOw/a8jiOzzaWh30NpAK8mJ+Xf2vEmpmlhPpKVVwIZVYUtn6YBznvyXSQ5QeXRIez72WLMPmhmaFT/Ok+0npyuIFL8t1TcNh48iu3kJWpyPTAXqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgK9i5wa168ns+cZakgl1dVliD6rVmVVqbRTQUU2Ocs=;
 b=UN6qB0vXnFzu4V6skpUwDvJiEeKRMwuqC93M1/okhzEpNv3odMXQhBI3GZS8el+FnkZIQ6llvqbKMtyCC6t9rH/MkVabM3GxdbZjOjpWO4H/b2lD7eIDTK8tnxd7Zb3qLlRpkMbDeZpbHx8KODeo6N4WZO56bzMXGEvBSF3g3Y4ZkzAJyW7utbyohGrnLtGq0/x9XLR2KBzkZb1VP4hWpVrd0k6BLBpJxijpgb5iLgHFu39WBrf0et+I/EK4uxLM/kBOQH5tmZqodJz+ljnlbIrVfelJUng4kqlZnnvOZtZQnZX1oibEQOTvBj3x0b7oc5X93+VVb18wDtoonnujRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgK9i5wa168ns+cZakgl1dVliD6rVmVVqbRTQUU2Ocs=;
 b=U/nEaqncym90nJwHlSvVi42zHBjUjN5OcLmfQqKxxy7g8yN4wtgobk3gYSbPW+rmBCnpcjwEKIbkSeBuGBdqBmHMjQMLiTmf5uS+ANsVP2KsbJoumBAvns52JwSYh2uAv4loaktYn1wiM0nShkRewSW6bZ/fkOQWQHhGSZuXvm6mOSAzIlyBagIBw2o+r9ic8DpkM4V4Vafp1hUGQwyvWam9Is3L7a42SXivLExvNG+foMo+oTT8Yi/JO9Cd090W3kY3FnLsNTdU9JIZ8ayhOzbqL2Im33EZt/CItABBc+RCwJY9DTMngfwbrkq87yCnuSN5O5/i7AeyLm2SSb+DzQ==
Received: from BYAPR11CA0105.namprd11.prod.outlook.com (2603:10b6:a03:f4::46)
 by DM6PR12MB4092.namprd12.prod.outlook.com (2603:10b6:5:214::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 09:12:13 +0000
Received: from SJ1PEPF00001CE6.namprd03.prod.outlook.com
 (2603:10b6:a03:f4:cafe::ed) by BYAPR11CA0105.outlook.office365.com
 (2603:10b6:a03:f4::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.14 via Frontend Transport; Wed,
 1 Oct 2025 09:12:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00001CE6.mail.protection.outlook.com (10.167.242.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.15 via Frontend Transport; Wed, 1 Oct 2025 09:12:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.34; Wed, 1 Oct
 2025 02:12:01 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 1 Oct
 2025 02:12:00 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 1 Oct 2025 02:12:00 -0700
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
Subject: Re: [PATCH 6.6 00/91] 6.6.109-rc1 review
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <18a587fd-e695-450c-abf4-60141db89004@rnnvmail205.nvidia.com>
Date: Wed, 1 Oct 2025 02:12:00 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE6:EE_|DM6PR12MB4092:EE_
X-MS-Office365-Filtering-Correlation-Id: 1778ecc8-f7a1-4983-7eae-08de00ca9c35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eExtOUYyakFFMkdTVjZrYkVBdHhLZG5EZGRaaHZ4TThiTkNpdGc0NUhHd0ho?=
 =?utf-8?B?VFR0OEFKbzFYaWNmYXZReW5IeXlHald2bEZySHdQUE1KN2tORlNkdW1SQkxT?=
 =?utf-8?B?a21zS0VsYllpMUhuVjJKMUxLMVFyRXlaS25OTTYxQkFKVnRLY2U2d3Zpa1pi?=
 =?utf-8?B?RG5SSVFXazM3eitYRlZraFdsKzhuZkVsVVRseG1KaEE4K1FnSWJzaXVRazNV?=
 =?utf-8?B?bkFqU1J3VE1zZWhtYURoemlXVnNiZ3BpRHZyZ0xZUEo2dUJtcC9WeUErY3Y0?=
 =?utf-8?B?UDJSeTQrR09palB4NENkTG9rTGJDa09LQk9nWTV2djd4SmlxbktFTHphWHN4?=
 =?utf-8?B?UFdPNUh2N2h6TXV1aTk5RlVxQ1krSEF5OVJDMm1sZWJkTktwOTlmTS9WUHZY?=
 =?utf-8?B?allJaVlsbW9iL051aHNPSUhJcUlpY2ZULzI0MXhlRnAxUFN2cTRCdWxJWmdI?=
 =?utf-8?B?QWxla0t5ZzhseFJGcy9sS1l0L0o3MGQvd3hrS3ZZU25oa21jd25yNHBRdkpG?=
 =?utf-8?B?UWVkekw3Vi8zMFZOSTBhZmFyOWdYUWoyNnlXMWpBSkZ3U0dzNGVpSnQ1N253?=
 =?utf-8?B?TDZWeHh0cjFaN0RtTmd6SHg3WHMwU25hZkhFaVd2MmRKWlF6dUkxeHNBUXpv?=
 =?utf-8?B?bk0zVWZweW5ZdTJzT2FEWFBMTTU4QmFGUXVFN1pRdTZNaFlMcFc3azhmZWI3?=
 =?utf-8?B?VnR6ekZVQmVJcHMxemtMMS9WcitxMkZpVzJpa0F6VUdtSS8ybGZNd0R1a2dM?=
 =?utf-8?B?NzBoQS9XazdnSlFndWRMcWFwSXVnUnp6OTlFNFhENlZZcnhKaHduL2dJbDVI?=
 =?utf-8?B?SjRSL3JjNllhTXozaXZQQk50aWc4U0RnMXdhanh6bHNZMXBLR2k1dk03QU1v?=
 =?utf-8?B?S3FKQ0RBcHpLcGtGYy9yTk53MWZKWHZqL2FhU3VrR1A2NnhlVS90c1BucVUx?=
 =?utf-8?B?Q21ydFpuektFYjRLWG9OeWFVWjIxUVBRTm9oV2ZaK1RySDg1RDdyS0NGUnlP?=
 =?utf-8?B?YU5TVXVzUjlhTEsxQXNWbUU2cVZBenIyeWxOSlU0a2NGVUFwQThoK0Q0Vkl1?=
 =?utf-8?B?NG5vYlY5bm1HUTlnenNSYk0xNS90TGJLTzBYb3hySy9wSTFIejlueGRCcytN?=
 =?utf-8?B?YjlQdUlOZWQ2aitaQ2cxV2IvN0d3QnZkV1ozcEhQMFF2K0lMUjNtT01NdjhT?=
 =?utf-8?B?MFJ4SjFodVpyNUV4OHljZk5rd3liQ3BkL0lzblJDZFhmcGVWSnBoRjVSc2d0?=
 =?utf-8?B?V0ViUlpBV1UzYU9FVzFOWVJDdXZNZ3lvbVl6YklCd0xpMTNhUGU1R1h1c2d2?=
 =?utf-8?B?M2RHRDJjYzdqeGZmSm54YnpwM0NpS3Q5cUpadmsvWEJwTFVhdkU5NGtLZTFN?=
 =?utf-8?B?RlBBV24yeUNSek5LQTVzeFR5K0hhNkw0MVVDa0UzU1RlR3pEOFozYVhYZmZN?=
 =?utf-8?B?MkJJVVlOT0Qvb1poU05VUVN2K0lMM1RzdmdmK0FJQzNMTEsxYUtYNHpyU3pq?=
 =?utf-8?B?WHllK2NLVTlpVHArSDBjWml2YXN6K0JMazFGdjI1SjdXd05tOUZ6bUxxaEZE?=
 =?utf-8?B?a3lMc0tDWXhSdXVHVUIxcmZ3OHVsRHFlTFlHWnFCaXNSbFpCSnUwOHgrWXhU?=
 =?utf-8?B?NzN5OFMwNjRhSHhWWkZmRDNrR1pKYTB2MU9uQTBxVnUzWFVnM1ljS2RJaVJk?=
 =?utf-8?B?bnFqN2NYVDFYSi9uNHN3d1oyWCtFRitVYkhUa2hOMVFLeWUvY05jN3U0SEpB?=
 =?utf-8?B?MitVM0t0MHQzc0NjK1czVmVyeTZYOTRnVHVCb3J3QS9rNkdEajRuL1A1VWdx?=
 =?utf-8?B?ZVBWdm1UVjhWRGpzbCtsc0xER3djbU1ubm1HVHdGNVI5bDVRRFd4WTArRlox?=
 =?utf-8?B?QUh2YUkxWGt6TnRMemVXZGxQWjBTOHdQWU5LNXR0MjAwTzdaeUhBcmJ5U0VW?=
 =?utf-8?B?eExCeGt1U2J3Y0g0K1pnM05jZUtEYVdNTkhnTjdzMWl2ZTZmdHhpTVcwZWFj?=
 =?utf-8?B?dEQxdkl1VzN6aFNOTU1rbTdRTnJQdzF6SzF5R3dvV0ZWNWh6clhIOEE5c2sz?=
 =?utf-8?B?TkFjN0J4YUdqNVY0a0dUYXA3enZIdVZMVWNOM0RvNFYxcVBRbDl5Q2lhNXFN?=
 =?utf-8?Q?xzyI=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 09:12:13.6954
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1778ecc8-f7a1-4983-7eae-08de00ca9c35
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4092

On Tue, 30 Sep 2025 16:46:59 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.109 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.109-rc1.gz
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
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.6.109-rc1-g583cf4b0ea80
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
