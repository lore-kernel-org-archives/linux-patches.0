Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720DF2957AD
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 15:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755100124; cv=fail; b=oMUBFrMHGUnnsHaSDZTV8DkYJXG52nmS0+SoWWyHwJ7Ct89jYTbjZtA7hxHo6NLnj1cA7Jh0QKcYaMgdO75li+9MY5Y6Rvoc2n5YzvldqAW2g2F3rbgPxtTMqWehAGrWRfMVduUTA1xO1YSZI2kmZRnb+4tbBBNJnrSHeYrynRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755100124; c=relaxed/simple;
	bh=hCVuosrtx8x43xUJVDOzYFZq3/ZYjgqhDokx5zbyL5U=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Bs4AqRqnX8vqw5tMZQqT1j4ArOBUjS4k6KZE7fhAsDZMvRBjzmzmFeFal7zE/2T5QOMJgJDlTIaOHYOXQUY/T5kj4f0064oxSZC5U43M95k2JQVIgxWWQTZ4fJgsuEigswBHAIe2weSNbb/QBNHFI50ttc/Cg/caU+A/Aw/2ca0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X3clSMtT; arc=fail smtp.client-ip=40.107.93.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X3clSMtT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IZAghTIz8ta4Hjjm0nKMtUnDsABOVSDqYdFcYeVweF/gyw09Fg2ai7GgrGLiPJu7pZIMY6KtMt5BVnPvZl/1KEgT0nK0hs3oEkyFykzgaDEXuzbHSa7uGWnLO5di1eWJPx0ai1Ev1nl/MD1Ly4Tcz8w/H9dCT4+VFCqFll1w0rA0QcFlSavCFH+2eJclhT6jIi/guYgyxUaJFESCE3IXrJTnFVeaVebziuW3wuXVhOa4dzE3OeQrBxmf2XCSbwFNFS4zXmHuK5lieAZanJdkkWfm+fnqFE/UVndsv8XLPDmGMuQGqiEgpLmU30WSy+qVEZPVY0W/wq3XUf6AqMaxiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=63ch7jDo0354YH03Xt96ywCQm0JMz2kzZY0+a02UFS0=;
 b=cTgQ4nEz483ftZwj/m3Xi3sba3nxh0tDPlR5EfkbcP8XI/Z9U/CFEEJ7GynJ+NJH9+pcwQ939FP+a1ie/0t9FtxTU0cVseXWgUvoR+5sAJ12fkZOpvn6m/t+vOZjx1yVH2kwCdLEkus/bJEHhxsOrCBlV3kzpRWRmh8cYn23/5kwkmvtjjlTTvu97GzIthvoswQ1+8USFkE8+kMF40rwNxLbjlkbHoRYyM6Fpi+w4O0uhImbwVfUfsovPEBXnDGmJIRFQgWq1UhFgqWAiTlP2Wr8ORkHoWG4SeerGeR7vpq/YpWGMnNVk9yBna2AqEPmJm+5dmkkNoQhbCV0xDu5uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63ch7jDo0354YH03Xt96ywCQm0JMz2kzZY0+a02UFS0=;
 b=X3clSMtTlP5eyqXk39g2ajeuBlWr06/S59M9OAH/leLnUIHFBQCc9x5mCtgmX10Co8vhcwA/2x2IdOfoL7T9gK0VDOrxuY4N1u8e12J5zWBFfwQV7R7HQI+rPXs1XPPMSwcTABcKzM5/aegE8jnzm9yUXK/9Z2CrNUZiR9cx/hb/UMI3JUQ9+XDGIVIT/STszd5nMGwnA8oNlKIcSetQ1t3i794dVsqN+epb5OFN9GEYOxEgdbpnQooEMdRt3/ytw5wA8V+oqeU0uDkOKyeRrkEIfx6lvJOi5b6glrc02/jN/uib7qCi2SvqXp2zJsCvul593kPaX6L0kqdpOoj8Nw==
Received: from MW4PR04CA0240.namprd04.prod.outlook.com (2603:10b6:303:87::35)
 by BY5PR12MB4163.namprd12.prod.outlook.com (2603:10b6:a03:202::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.21; Wed, 13 Aug
 2025 15:48:38 +0000
Received: from SJ1PEPF00001CE7.namprd03.prod.outlook.com
 (2603:10b6:303:87:cafe::f7) by MW4PR04CA0240.outlook.office365.com
 (2603:10b6:303:87::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.15 via Frontend Transport; Wed,
 13 Aug 2025 15:48:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00001CE7.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.11 via Frontend Transport; Wed, 13 Aug 2025 15:48:38 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 08:48:18 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 08:48:17 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 13 Aug 2025 08:48:17 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.12 000/369] 6.12.42-rc1 review
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <cae211c5-27f1-44be-add1-02acacd81424@rnnvmail203.nvidia.com>
Date: Wed, 13 Aug 2025 08:48:17 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE7:EE_|BY5PR12MB4163:EE_
X-MS-Office365-Filtering-Correlation-Id: f9b7f4bc-baf5-43d4-3188-08ddda80de9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c3ZRMU1ZZHpkSEd3bHBHQjBQMjRtd3dGOTRrL0dyRy9WalBtZTR6cDJVR0tl?=
 =?utf-8?B?NTFOcGhlNG5vYVRjU2c5aE5oRStkVjFGN09JQUcvNUJCOWFjdU5uYjJHTU1m?=
 =?utf-8?B?UFR6R09uenNlOU9oVHMzVmEzMnFBMHlac1RGQUptdDJhQnM5eXB5L3o5OGRv?=
 =?utf-8?B?YTJINVZGRGZhTG5rUkwyWmlwTDRNTU5uVWRuQ1ZPVmNySXZPMTJMOUFaMEtX?=
 =?utf-8?B?M2UrNVp0dWpiUXBJeHcvUkE1dUFwUVBDY0kwY1NxOEJGTlhEaHlMYWFxRWFH?=
 =?utf-8?B?MzM2aEY5enJ3TUo3Zm56OUhhQ2Z5UUVLY3FmeUx5cnZhVzVRWEtYWlhGek9m?=
 =?utf-8?B?ZndFTktHcmJKd0hKeG4zaENKYk5QLzJ3Sm55bHhJYUFhSEdLdkk2aWlwaytY?=
 =?utf-8?B?eXVQNFlQSDBrVE81Nk13allUb0pmc0YwU0Y3bkQydkNLTXI5V3ViUldBSDM2?=
 =?utf-8?B?bXZCbXAzbTZHNEZqdW9rZ3ZkVXFzc0Q5SnZ4Y0ZXdFk2ODdoQVRaK2lRa3Fw?=
 =?utf-8?B?MndLYjNzOTZnejU4ZlJORnc4SUtTWFBjVFQ2OG9CT1RhaHlkNVdwZCt5dy9W?=
 =?utf-8?B?TndPQ3dSVmE5eGRxaWY4OUJwME0yeGcrRU5taWlxY0VGanZFNlBvUWFWYlJl?=
 =?utf-8?B?VFlKZGZ6Y2JqSzh3amRrUWY2OGpWdGM1aXdQMUhlb1NyVFpYVDVHVFRGUW9v?=
 =?utf-8?B?YTVZZE1Yd0Q1d252T04wWTFoZmVJTDljTG55OWV3QmxXTnNSYVkwOEx1WXVU?=
 =?utf-8?B?MGFKOHkrQzVIZ2pGS1hVSWZNTEgvUEFOdWZoT2w3YTRTYk5pbzJ0cmxlR0k2?=
 =?utf-8?B?UXpnQitmV2pnZGdRRDF3aEtaRFVqbHBuZE0vbFYxUURFdmw2bTlZN25mOEZU?=
 =?utf-8?B?L015em5mZERtbkwwdElVc05tQjd3em11L1RmTWlYRUVDS3k0TENjcG1pejZ2?=
 =?utf-8?B?SFA4eGNhSWhqRjgvbkFpY3NObXhKbHE1TzRzQmE2cmZrTHU3Ynk4cTdsOHJh?=
 =?utf-8?B?Ni93YklveUVOemZ4L2djbDBNTURWTnZmRW5sZzEyZUQxaGVkKytZeVRySzR6?=
 =?utf-8?B?R09scDVxc2lrMGtxQlEzQUtWYkVob3NRUWNMdEtOYmxqR1BveGlBdTUvM3JX?=
 =?utf-8?B?VEQ1R0NLalZKN2tmcC9BRXhLdGp2TUF1KzRrTmhXWWcrYStiNEhYYkNTTllL?=
 =?utf-8?B?TW1WYjBLVnJ3NkhEUVJ0TWV4K0xVdmdBUGNsT2pqdTl3dzFuN1ZuaStwS09w?=
 =?utf-8?B?S2lWdUxjdDhXZXltU3FENVpZZk1Db1J1TmJjVCtXMXFZVCs4WXo4aHlkeVBn?=
 =?utf-8?B?WStNLzNWL0RwTE5PM2ZFRWdBKzhvMW5sNlV3YzZUbExzN2R0K2JxR1cvaGtL?=
 =?utf-8?B?N0dwbzdCbTNMdEg3MldmQnl4UU9PQ3VkNWwrdFBpNWt0TVJEeWZyL3hHNXMr?=
 =?utf-8?B?VEdkUUh4dXlxTTJ6OW5mNyt4WDFISEMzU29XaUJXY3F1OGxCanUwVUJJcHpG?=
 =?utf-8?B?RkppWSthNjZzd1ZscGN4QzUrNDE3dWFndzlNdmFIbnd3MnBxKzhDNUFEank1?=
 =?utf-8?B?Q1pyZkpjb1c3dEJjVmF4T1NVbzQ1QjNOUzZvaTZvYzFuZmFJS2pNNGtBb0ww?=
 =?utf-8?B?OVh6ZEFSbXdwQ1lxSTA2WlJFZnhXQVl4ck1WMmN2R3BCcE14ZGZicHlIMFpE?=
 =?utf-8?B?TzRhOFdIcjFxaGszc2NKZFc3c0RzN3A0Uit1V3EzVDhJK240Y3BZY0dES3Fm?=
 =?utf-8?B?Vm9oL0FWR3JlU25tSDJsSEsyMUlTL1dzSTl5eWl1a0VXYVZWVEMwNGQyY3Uy?=
 =?utf-8?B?MG5LZnV0WVJCK3hGRGtWQlkxa1ptVHBTMFZoUHBrTVM0bEFoMW9wL0R3RUUv?=
 =?utf-8?B?ZmNUYmdrRjBLT08xSUJNeHdOOUF1ZlZpN1o5aksvSG5zT2JQVXVKVXU3cURV?=
 =?utf-8?B?UGU5NjZJdEtIRGNjbVNISm9aYkxhMitBV2d4bmxySW1iNlVxcUdvNWhYUmVh?=
 =?utf-8?B?ckdVbVlLSno0UFBHZ2ZnSkNNMVd2NXpnWCtQUDZweWVQLzVrdlcvVGJvYnA4?=
 =?utf-8?B?Rm1ZbkZrYkNRQlk4ZTAwd3FxcDFRcVhiM3JHdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 15:48:38.0562
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b7f4bc-baf5-43d4-3188-08ddda80de9f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4163

On Tue, 12 Aug 2025 19:24:57 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.42 release.
> There are 369 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Aug 2025 17:27:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.42-rc1.gz
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
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.12.42-rc1-g3566c7a6291d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
