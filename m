Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010051.outbound.protection.outlook.com [52.101.193.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90702239E75;
	Wed,  1 Oct 2025 17:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759339030; cv=fail; b=VdlC0r2BM0aNxLvrOYGrZ3Q1309oM5z5MP3XEBcqqXFIubVciDMC1//Z0B+3/c4p6bMh+8EBzeWdR2JpeZ0mI3p9+qNy9lCCa3bp5yZMswjqNVDoFlxKB1TnV4RcSRZ1Yqe/o6/fiLN/XjBGHF5rEXE/kdj2arHEkFMJmt6iQlQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759339030; c=relaxed/simple;
	bh=5V0Up3vYfk1Kb3x2MLJelGmRaieWuWv/WyjZAJBgtbk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VlQ+GmGWKjvfVOIohpGLoO9WnqybcuDgKx0Rg/15I5JXh7Wm1Bz8EN+PflFfWwiS4JV0xtxnT7rKjc3ztP+vGHdt2E3nejhxhEbju5TA1qkA/RJcRZRQSlAvg8IPJbO5VkimptCwv+Lfur8vJMnFV9SYrFME1ILC5+/AoG/dOnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fZPas+m4; arc=fail smtp.client-ip=52.101.193.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fZPas+m4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HriXHPq1fe0k7URZj5Fe/FVXkgRuN7J9p1K0EjfisNH/2lxbwcImSBemqrcFToEU8+k8+THIdSO2VKn1qrQbrPVOxQzoJKL3DWtq06Os5ath7ZW3j1Dh6Emj8rxyUXX6TwdqHhgwfayQGnFEqOuDWhIJS1leFijNEBJ7YxCE2d1V6R5PziWdUzc2WsxJIgL4AQduoBhnZ9V+Kk42xsQ5HOS2/2d5kgnmysGpmyk5Or+5xiL3YqhKm75y8xAhTXtCbM0+DJhSlDk9eKEr43AFYTRSfkzUcINMs6uiv9LS6MIxnjabnvwIqZbKB4M5wgFO7FhoC9FxlBYlkPXPSmD7Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bkUIeEw2K1DcaImCpCtRE9AepJnlixKkMkmpyScYn+c=;
 b=mI7s35mXvDoRb7FzVGBR4Xe9vHaI2EqUOmbhyL10d43ob39foIclxMy09G4DqP1jZwv/+IlOpnhU7IZhYJ7LDAieMowpc1QSjnMF3cVQMF5vhloNoZ6Ka4fPgcghUn9cTE9xV1ObjRoPnuW92+aqCMf+aVUmlpkiqup4+p3rN7J8FpbG6f9CJqIzZXB3oUbaJ1qQ+2C/gnKawKMJS6FCbyNdaxZFqaEztPefwp1jaHmFFYmUXzKg+C/oMgEPQLlnxRagtkAuiJpby/CwC1uDOrkxCC6dLw0KoWoTAYA32SwKZwpWRmILXQKXk9B5fvRb+yJRXrYT/2EhB8YfiJt1jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bkUIeEw2K1DcaImCpCtRE9AepJnlixKkMkmpyScYn+c=;
 b=fZPas+m4bg8jiqyACIjL+L1OS/ns8nKZdWcK7fRtAtwpM4lI7gOHy+zLefFd7pkVkyRpopH4veekXejGeoCINsCarrrnE/HliwCSzhqqQYuOn+CENj8R6Y0P0DlVJT7B43z4tIcKrtMJ4BJW8LfGyohpfSj+VQ0ELBQSZ1yLceYSqplBOYQt6xEec3KXlWCjzaAJKIMIE8P/VKss094KqvQXJIDCQjQnlR3cdYbjEvbWn0/KzI01QUrIM9MhzSRrtyns06v6ljUIm+kLRPfLpyVfZkv6PunX6HM6W2Q+JjpHlPRBPQ35ibk0cuv6PC5tgLFGNOXNGtDDOw9TUsVPdg==
Received: from BL6PEPF00013DFC.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:21) by MW3PR12MB4393.namprd12.prod.outlook.com
 (2603:10b6:303:2c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 17:17:02 +0000
Received: from BL02EPF00021F6E.namprd02.prod.outlook.com
 (2a01:111:f403:f901::8) by BL6PEPF00013DFC.outlook.office365.com
 (2603:1036:903:4::4) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.14 via Frontend Transport; Wed,
 1 Oct 2025 17:17:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF00021F6E.mail.protection.outlook.com (10.167.249.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.15 via Frontend Transport; Wed, 1 Oct 2025 17:17:00 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.34; Wed, 1 Oct
 2025 10:16:39 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 1 Oct
 2025 10:16:39 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 1 Oct 2025 10:16:38 -0700
Date: Wed, 1 Oct 2025 10:16:37 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jean-philippe@linaro.org>, <miko.lenczewski@arm.com>, <balbirs@nvidia.com>,
	<peterz@infradead.org>, <smostafa@google.com>, <kevin.tian@intel.com>,
	<praan@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH rfcv2 6/8] iommu/arm-smmu-v3: Populate smmu_domain->invs
 when attaching masters
Message-ID: <aN1h9UKA+MmapzX1@Asurada-Nvidia>
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <d3f9777e46d531273dfecb54d69725428cdef308.1757373449.git.nicolinc@nvidia.com>
 <20250924214215.GR2617119@nvidia.com>
 <aNrxjkUEEUzKU+za@Asurada-Nvidia>
 <20250930121200.GG2942991@nvidia.com>
 <aNw7UVaktL6/05b8@Asurada-Nvidia>
 <20251001162516.GE3024065@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251001162516.GE3024065@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6E:EE_|MW3PR12MB4393:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a5b0c72-2af6-4cc5-8d38-08de010e5566
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ntzKJLo/JDDADWd0Dp1GxvViJ4FhA/R2ry/9be71APvAXRZWZMentf51jNjQ?=
 =?us-ascii?Q?IH/E0nLG3357jago/GNG5YEE4K34JxqPHv5duMPSpdD2/crA4vnUTmt1GxP9?=
 =?us-ascii?Q?IaFhh7KLEi+ypuE52XOQJeI5k1dQx8IhcklJs3a6hyH2TQe9U+Ij3MYS1jOk?=
 =?us-ascii?Q?HVlJHU6RD5UDwZxVwQswOxpGn09Maq7qV3vfxhlsLZzdpZZ4cE06m8vUBEKY?=
 =?us-ascii?Q?tAYyLoQWZZtmQbdbyZAsYyifDov074K2fMo0dSSXJqtrD2bkmWHVGUp527kJ?=
 =?us-ascii?Q?xA/NAfGlCc1us1Y7TnkdUnnQAW5/Wqj+tUnrCfqqvcTL+Qwi53lUeWfQ2r3Q?=
 =?us-ascii?Q?HFp6I6S0M2+HOkb9e7WxUou6BQ8xynBNI+g+FERAP3SMrbxzsjZGkCKF1aEl?=
 =?us-ascii?Q?tXsO+71hk4VpF5MChyQvdvpuSQXrS+H8OhnE4tyvThy199PgIM2ImAW1yF8+?=
 =?us-ascii?Q?okSv9mqyFn4BHirneo1HJI7ufCkLQUGa4NAUHBrkhkVHq24M0e7Fn+c8q1pB?=
 =?us-ascii?Q?bjPsFAKvd8F9LVDaEZ0p9n7AfGW2WADTHA3fSw84adBGpyNzSN7534kDj+lA?=
 =?us-ascii?Q?EufeWhNKovdvCcCEA4v6DDVpayO28XU0Re96sClRkiCfKDL7SaefXPVozo1J?=
 =?us-ascii?Q?3lSF6Gj+MMAPDVRJWAfdLxN1CwlXgBsFzPYWKcKxbnPRlboLWwIlv7wdsqoX?=
 =?us-ascii?Q?ti9VkZJVm9zbJSA6bYkRAJ+0lMcqEIhYfPJ6CzDEMtMDuVSL0BB6knjUrSrE?=
 =?us-ascii?Q?20IaIw8EvWItV+bpeLdyTA5uSR1eMHtbFv26yeQ22eGyEYVoTZ6HywerEcU5?=
 =?us-ascii?Q?XbmP1V4Y0gD6VV+OaIuQN6HKZ+qhudpf+EAUlUwzsRkfz62ICrXHJJq/eDks?=
 =?us-ascii?Q?55Uae64isQ2dkAcd2kVYJarqDtJg/B1KgZJfoNgYZ7DL0y0XJ3XJa4wnpQX7?=
 =?us-ascii?Q?MY5UWkh1n5TqndkECPhCjgzA/DsH17NWf2VpPYlOGRdNtDibwC6GJS6IvbdU?=
 =?us-ascii?Q?9HctrTJdPmOSYXXdIoohX0apZZjpGCu8Dco62VWysPl6Ys71583HfYfJisw4?=
 =?us-ascii?Q?yaOIwmbDsDbVmOuKFCfuYFl7LQDi+FKBuNvymvCl3U24y5VDtJ99kC5/KaDN?=
 =?us-ascii?Q?zn29BR1UlBtdXi3IKAmZOiZjbWGyCXK4XPPwC5oix1hig4yVPjiEknmyWVe7?=
 =?us-ascii?Q?SajoPGkBoh6OB+XRK8W/BN9BLbh84n+V9p5RMorJoJtYl+nsUMsYiYBdCT4T?=
 =?us-ascii?Q?fzezMARg1v96nBica7WbSQXozLOw8ZU2c7AhxD+kF8LGYEcpO3KyX80Vojsx?=
 =?us-ascii?Q?Tfl24BBxUvToC3dkWAzZol1qwosNAuydJ0HvBso9pvjQvYVT/73QC5FW8SJz?=
 =?us-ascii?Q?CCCiujuQ59BhimC2V2y5JwGdZIYyCm7ot7xS2BXRBkdD9w79cs9Qa9Fg65zl?=
 =?us-ascii?Q?Fk+4J75DJ6FKigAsBpBInMFNRpaNPbvQNkwJCFrSO64pjWUiRp46icDCpmQ0?=
 =?us-ascii?Q?nLZQkQkDolPBxJttVXb6DGQZe+CyAMf4EWqidqS4dMg8A5FM/TeBdDKld6At?=
 =?us-ascii?Q?Q7Vqv0nTd3z6k2L+i08=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 17:17:00.5317
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a5b0c72-2af6-4cc5-8d38-08de010e5566
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4393

On Wed, Oct 01, 2025 at 01:25:16PM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 30, 2025 at 01:19:29PM -0700, Nicolin Chen wrote:
> > I see a cleaner way of handling this is to update invs->num_invs
> > inside arm_smmu_invs_unref():
> > ----------------------------------------------------------------
> > @@ -1209,6 +1216,13 @@ size_t arm_smmu_invs_unref(struct arm_smmu_invs *invs,
> >                         j++;
> >                 }
> >         }
> > +
> > +       /* The lock is required to fence concurrent ATS operations. */
> > +       write_lock_irqsave(&invs->rwlock, flags);
> > +       /* Trim the size by removing tailing trash entries */
> > +       WRITE_ONCE(invs->num_invs, num_invs);
> > +       write_unlock_irqrestore(&invs->rwlock, flags);
> 
> That seems Ok
> 
> It means the arm_smmu_invs_unref() becomes the fence that guarentees
> the ATS is stopped for anything marked as trash.
> 
> Then the next steps can just be normal RCU and don't need rwlocking.

Yea. The "old" flag could be dropped too:

        while (true) {
                invs = rcu_dereference(smmu_domain->invs);

                /*
                 * Avoid locking unless ATS is being used. No ATS invalidate can
                 * be going on after a domain is detached.
                 */
                locked = false;
-               if (invs->has_ats || READ_ONCE(invs->old)) {
+               if (invs->has_ats) {
                        read_lock(&invs->rwlock);
-                       if (invs->old) {
-                               read_unlock(&invs->rwlock);
-                               continue;
-                       }
                        locked = true;
                }
                break;
        }

Thanks
Nicolin
