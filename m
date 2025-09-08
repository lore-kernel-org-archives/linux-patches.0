Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF44221F24;
	Mon,  8 Sep 2025 18:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757355636; cv=fail; b=S04v5+EPcF7sRGvXEZ8KfUp/oyqzuANJV3J0eZO76z8O3G9H+m54+WvcGH+Mif2pbiPqS2keDmxqUIG9rWwr6rloTBntbSipiSkoF0kBkaW79zTFMfzso5gPCEv4du+sg40Tb+qKLBnCO4yl4fUtnp/T+vn4nifYbkUYpqeEETE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757355636; c=relaxed/simple;
	bh=SshYiGXoT1BOeA3Z4F86nkRs5yveTAUHE2w+j4xx6Y0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=axW7GZwXSyykLFFD4ABRIuMOHLSLdjsznKNSqB3JolP3+Tj6j8GbnXPNP9Or30DsVTON1Im9+V41awmM3x83tzZPHHkdo9mpJ7ii6ooCx0IrLy0Z4UfK6Owd+WwQcVuFsvfirs8M7cNGRhns/KsTaQ+NM4LLwaxSSYqu/MiD6yg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dYIviKrr; arc=fail smtp.client-ip=40.107.223.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dYIviKrr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e3QhMrLci8/QDP4Je9qa7uk5p9lbP1vbAhoxsNfPRghSEqWCjJjvzUYXaTVXIhxDziXUx/C2yLGZ2asoBw/HWBswowtZOJGAQ/KwGVGnHag67THakhQ/eaZ0lRJA2io4CxfxrqBjUk33NOXog+YS+Wo0POQq/L273qr+7mBwPUcEP+00k9dVo588kF6uV8CB/dH5xoUS1WiVZeDcoU46ReB6DVsnaI2j0JbaBCWmm8h3LKbbqm94FEUHUkrosMboOviYvHz1Cn8FqzA61jS1IDtluGcMMdSepG/9qe/cpe5GF77GFoK0D2TKwmkQu0i4D2NL54ToYFtcW2UKp+zEWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dGhIMXrxXUZbqCTzrfXXsA9Gb+8o8bWSQ8JxykHGfP8=;
 b=sGbI69o5n5t0ii9xf4BX3ndGl4g6Z9d0h6lDkPvgTi4vdoXqm/q/P2fN4HZTTnK1QjL/bZDtVHwGcJQa3ScpA4Imlrv8sl2R364rf1WWimvcNfUhlVnMUpwxRqWRKhy6rsFMHvfeaEfvREGQroCCFYQ2E2Y8SO5jtONJ3t/FAoEqyPgz36cDQQfa7FMd7a898X6yqG+58G9w4c1oOiTst2O45FJuvv1wzHR49jWbzzaWy3neUrC4ZlfwbcHft99vMHhTFey/9ce2UlS0R28cttOpneiky801talbaccCsJUjSNBaVIWXyCwj5sb/UI96Uc2LyxW6s57UK8CQFFIlpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGhIMXrxXUZbqCTzrfXXsA9Gb+8o8bWSQ8JxykHGfP8=;
 b=dYIviKrr19u5sUO571tbC1Q2ZaHvDjJgC+wPe1LkV7LafL+EVQpvJNlXJeqvoPYFahG8NYTtsKK6qEuRnlDeePcT7jvxCKyGxvTYqMSDstk9xVY0jmzPJd5AUtZqgP2do4y032ndOIrdIqqahJ/KxU0rCMviTrX5DNsaXJuGwMlgc89/0EDvO8vOkpQX8RTkTamIr2E4+PfoXUk2jF7TswzQLVtxYGFFbaYCqpfHdB3UxwZC5LMMQLKr5g2ck/U+WFFfPsrGH5Kw3iX/t9f4Xc6x380fnuvjmeNs62LIVNyXvU3MpuAgz1ybo0HnbPmM0r3dAbV6BJ+1S3tXVBp64w==
Received: from SN4PR0501CA0116.namprd05.prod.outlook.com
 (2603:10b6:803:42::33) by DM4PR12MB5889.namprd12.prod.outlook.com
 (2603:10b6:8:65::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 18:20:23 +0000
Received: from SA2PEPF000015C8.namprd03.prod.outlook.com
 (2603:10b6:803:42:cafe::67) by SN4PR0501CA0116.outlook.office365.com
 (2603:10b6:803:42::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13 via Frontend Transport; Mon,
 8 Sep 2025 18:20:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C8.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 18:20:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 11:19:46 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 11:19:45 -0700
Received: from nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 8 Sep 2025 11:19:42 -0700
Date: Mon, 8 Sep 2025 11:19:40 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jean-philippe@linaro.org>, <miko.lenczewski@arm.com>, <balbirs@nvidia.com>,
	<peterz@infradead.org>, <smostafa@google.com>, <kevin.tian@intel.com>,
	<praan@google.com>, <zhangzekun11@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH rfcv1 7/8] iommu/arm-smmu-v3: Add arm_smmu_invs based
 arm_smmu_domain_inv_range()
Message-ID: <aL8ePHvQ25LUU81J@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
 <8c4c5aec144f65cfd1fcef2eafb395876dac97ec.1755131672.git.nicolinc@nvidia.com>
 <20250827184923.GC2206304@nvidia.com>
 <aLvs8WrxEHpykCT/@nvidia.com>
 <20250908153911.GC789684@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250908153911.GC789684@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C8:EE_|DM4PR12MB5889:EE_
X-MS-Office365-Filtering-Correlation-Id: 0faa90e1-8910-46bb-0bf9-08ddef04603f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/ibXEekYgiSGEYCQFkPaft1Z7NkpuG4hGBcR1gYDx4CuUl55UoQE2CM6ThUL?=
 =?us-ascii?Q?uHiu5Ti2CjnhebE2S5FkRAQOWv+o9w4KEqNRngAtlotFqnkZXkcdOfDdQRiF?=
 =?us-ascii?Q?cSDb9E5SEKL1C6hcpwTt9fqkjO++unQ7mk+4hB6ms4PJHGpYJgJhqszG7qZG?=
 =?us-ascii?Q?b/BN18lWCwj+7bheN6ntGNgaC2/aDW7DSoWcsBY1NcskYBCySZe0TtMV1GjY?=
 =?us-ascii?Q?9EkbLoOGiKrjPctUkBUOkegXJHahW3aJPTuugcz/vR5FLdxlHg+JyP4n3oj1?=
 =?us-ascii?Q?FOu80HvO3WQb2WlnP8HEQoYqSkUDbb/cji4zlwNh5o8GQDQr2+cjBZ/v1mKY?=
 =?us-ascii?Q?1nbk2e/u/lcPm5/QEJZ5+7ndkFclo6iLxzSICMHqJO+JSX4yqH+l56TblRbb?=
 =?us-ascii?Q?AR0HQQ3SV/+eS+3eLf9+xNLtdE64FgEga3vU3RpDsC9dBykg7qZf+WiAmueR?=
 =?us-ascii?Q?dMM3RaeyQ/aF5SU6kRex42yusmddBHbu2BdRjBv/dHz0kMFhEnID0jK2Y7lH?=
 =?us-ascii?Q?LyzfBMrYs8VPnWmV0k6LUdPUFTcw0DYPMO1pGwisIdp4ydmiRwVOJwPJiRoB?=
 =?us-ascii?Q?+ayTpGTHW7p/2q5fAUZynKDfGiUshe2rs3ahGnLzlVE95/qcFGlMT3CtGzn+?=
 =?us-ascii?Q?I05qBtBQP0A91HVrh8tfjPSnwCy2D/cu9ToQnI6QR5gotYXta2q+UrenRLyS?=
 =?us-ascii?Q?yjBzmHJrMpQ9foHG/iUGWDzMJhXuhoCTZ1zz94Ui7RsuK7FDWZpcwv+pXVzt?=
 =?us-ascii?Q?ZoLQcgICpzG3DEqarYYPCSPq4WelREENTSxCTskDboURH3gmgYILAOLxyOja?=
 =?us-ascii?Q?Y/A470nYQeCj5Dy/VxGXq9R1MDeltCj2eAzMI8kgIokhCpTI8BSYs7p3/coO?=
 =?us-ascii?Q?niSgh3hVZnMMmxlsRIy/4014/kJf0Rfk8VJWpGQIR2xT0sKiJvktl39s0jKt?=
 =?us-ascii?Q?ZmPQeNTb8hM5Nm54/CIeRwvLStDA+NK8LMRbuJvuSbNtQBXxi4ylVNCAAzQB?=
 =?us-ascii?Q?EYxFmf9Kh6xWGTz4a2WH1+sMVNdhP8sjzYxdpg441FHnixuQv29g3W5EvWQ5?=
 =?us-ascii?Q?0pmGB8aX8g63S7GWOwpL8bdSMvTdMwdUgsHesUttg6wOQjsGowr3QrcBj9qA?=
 =?us-ascii?Q?DuuOK9STJc1usVaTPICUMxHD9iFY//tt6yaYuLb/IvQ41SIWT41lzZP4asmf?=
 =?us-ascii?Q?cC3IZs4boakS0Dh8BwRXjQc03lEce25xZxGTW4CSUtm+UgvP1Betq2vflxyv?=
 =?us-ascii?Q?2HRxMF3kxHWIEctWGtt00TdROa9vg44ijFO6LFl4MMijIjzTlAm40++exP7v?=
 =?us-ascii?Q?B9XOzXhAHZhvuzhFKHIHB0dbGkINZmr9xdF6zcxBlpZgTLAw9yBVoCx3mhD5?=
 =?us-ascii?Q?vCoHmq/48cj4XmJVCxOSdnnI+xLwnK8oGFWXBtVrCDQC/9RgRgcHYoC8vKQB?=
 =?us-ascii?Q?stnIBaMY49tnnDbdLeZZV6tPh85F1/TL+tCXLpDZhTtxwkZGmFW8vDRa0wUi?=
 =?us-ascii?Q?AK9T8AxXpErKci/o3ntiU5Zx2XXGYSDQGjnfkFUhFM8mHeIf6JFbPtJfnV+Y?=
 =?us-ascii?Q?Ykwv1Bl5tt3UGS4n6zo=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014)(3613699012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 18:20:22.7986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0faa90e1-8910-46bb-0bf9-08ddef04603f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5889

On Mon, Sep 08, 2025 at 12:39:11PM -0300, Jason Gunthorpe wrote:
> On Sat, Sep 06, 2025 at 01:12:33AM -0700, Nicolin Chen wrote:
> 
> > I know that performance-wise, this piece will be a quick respin,
> > as the attach side releases the lock very fast. It still looks
> > a bit complicated. And practically, it would respin even if the
> > attachment removes a non-PCI device, right?
> 
> If you are paying the cost of taking the lock then it should become
> fully locked and consistent.

Well, the point is that the reader doesn't know if an ATS entry
is getting removed, and it can only speculate by looking at the
full list.

So, would it be better to just always take the read lock, while
applying the ATS condition to the writer side:

[Reader]
+	/* A concurrent attachment has changed the array. Do a respin */
+	if (unlikely(!read_trylock(&invs->rwlock)))
+		goto again;
+	if (unlikely(!invs->old)) {
+		read_unlock(&invs->rwlock);
+		goto again;
+	}
...
+	read_unlock(&invs->rwlock);

[Writer]
+	bool ats_disabled = master->ats_enabled && !state->ats_enabled;
...
+	if (ats_disabled)
+		write_lock_irqsave(&old_invs->rwlock, flags);
+	WRITE_ONCE(old_invs->old, true);
+	if (ats_disabled)
+		write_unlock_irqrestore(&old_invs->rwlock, flags);

?

Thanks
Nicolin
