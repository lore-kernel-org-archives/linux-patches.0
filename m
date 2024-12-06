Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37461862;
	Fri,  6 Dec 2024 00:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733444631; cv=fail; b=BMm4i586AZRky88HGx0d0/u19gCbYdeByAA4PbK6rIs3H2e1FKQMmoB7CWrD7CNkTvc3SLquFmwf4zH1hdTJsTlXlyNOBVArdePg7gaye42fMqYTixcnucTbisVqYHeBFYkmKuBNHiyZc5bqON3tIrdyuWetGppzf86CTpD3sSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733444631; c=relaxed/simple;
	bh=lSf3DUZEv5mHfnj97Z7C0DBRe4+tBYASSONYxELWDZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rRLy+WaIDJUS1pIQs40MGLQWmsI+/m66tjyEOLh4Ebt7PmaAhVuBFRxaSVSnAABW08xwvi/UpqT52p3KkQpEoP21wwEnxGnSRTJL0kjBcR+hotDwvGuhoyIZh2KP3/cpFrhavgf9AtDpUsRKJPx0yaht4zpr6tu1EKr0mMibqwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hcZBGmAL; arc=fail smtp.client-ip=40.107.243.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hcZBGmAL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jlgh9kGcPBycA7C2H0Pk5drHagtXZ+j5EDxq8kUFTDY7gAV0hqwDcgCbVkyVPoQGQdbj7YV/rNLk6dGg+MnUa8o0TV3oS1zUbgKnBaCFYY016h+zeppdfVJp05NuC3jV0VDHcpBM80BvT+UqQi/xDVLWdQjsT0YMibslDYl7ti6rTehVnRPKHXG1aaGea5UuxHBYRxq1qeTmak0X+GA52nS9CwnsvLn/b7ap4ZLcWSXJ7dHFneWM3nrixGj3LHX6NpKciIB5Vi+HU2QbMW0NFuVv0tZ6Or9J89DxMbTr26DJ7Eh/YlheTd+7WzLNnFDRL2OH0jpOTaiEJ5dO3yW/PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qSGBYfAZ1LuKZlsjR/6w0mA35VMLALLgVtdvx+2EDQ0=;
 b=N20UBqzPJW0oW6FU0j1tZO2NHbCCCSLLlOp9Y/VKS9fWG3s0uZPAdAS3KQTRJtJ/zP0pGk7vctAN7VTk9N1geBxmz+2wwSzJNtb93itpA/MCLX1sQKIYqKZd0wDcnuJsvS5Skvg/ljQne9YGvBoCoD5EYE1VVOgPy6aCyOZ+a3Lf3mASpBWg32EAx3cGa3AiZzRGsRrXU3DNMSJGnU0Di0p15MPSggJ1pPhcMy7wosNJHOo5S7/cbQ0sE35w0Mk5mlYY7jYa0qYigqZUAivUav8btWN934jduXHPJPA4W7ddmv64jJInsoAcoz73/+MDvuDn9xVhfBMCc2ONlPH44Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSGBYfAZ1LuKZlsjR/6w0mA35VMLALLgVtdvx+2EDQ0=;
 b=hcZBGmALPyUo7YtYitOsHCi7Ewr0Aq9knIQnKp9zTFn0qgNddT8aCBb5ehBFbpHdonZA87igX1af6G1e91Ocahjh5wqDQO43Vu8voeIyJso2XJEaRdf/Q1GM6b3WW0Wn0Ldr9PKBgTe1hDDmWNenC/UeSFJ/CPbcgxz5oCOcqn48yZYRx7t5c9mSRZqEbzvbYLqlS9Np5+hWplM47HqhU6RFEcwvfKwS4MUDpQnfQ6lRevzH6r+bjaXT9OWRe+5YDEvOZy+tb4rNwxDLwIcAteaZeIFEkLRw/bGNwViY7Hm54G+Lt115y3babH234PUk4DVhXJhW/Z5pivSH/jQoHA==
Received: from IA1PR12MB7496.namprd12.prod.outlook.com (2603:10b6:208:418::10)
 by IA1PR12MB6332.namprd12.prod.outlook.com (2603:10b6:208:3e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.23; Fri, 6 Dec
 2024 00:23:46 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB7496.namprd12.prod.outlook.com (2603:10b6:208:418::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Fri, 6 Dec
 2024 00:23:44 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Fri, 6 Dec 2024
 00:23:43 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH 1/7] iommu/amd: Remove unused amd_iommu_domain_update()
Date: Thu,  5 Dec 2024 20:23:36 -0400
Message-ID: <1-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0948.namprd03.prod.outlook.com
 (2603:10b6:408:108::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH3PR12MB8659:EE_|IA1PR12MB7496:EE_|IA1PR12MB6332:EE_
X-MS-Office365-Filtering-Correlation-Id: f8250ea6-0ff9-4403-bc60-08dd158c3dfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?indX4PP76flV3/sSyZVS3qzqMFOvYBalAnZiTST1W17t1E3ugVvymZJYojho?=
 =?us-ascii?Q?Y15ms1/7a++soUkZkQthMJJu03WSeGvfZPQdzN9/IkICWlSf/Bn3zNVCieu+?=
 =?us-ascii?Q?waQ50qvK8PqdU2a7J2cAXQUeg6/segbcSkQ+TlniIgtIpVQRwPvFmC+ADMkc?=
 =?us-ascii?Q?1n5tzuSkmlcsbs+ABODqXPuzXQHOpIW773CqG0VlmdriYETa/FCifdkBcbAV?=
 =?us-ascii?Q?6VoRcpLLuXy4L4uYw6Dq+U/poiNAcHAwrY7Uh9sMjFKKc64D8CuTIueD8MBA?=
 =?us-ascii?Q?+5YJ7D7//Y41hazI9R4Fb+G43cKgow+KSuHMVKP8zl6UpUdPt6kOA+3d1lTb?=
 =?us-ascii?Q?I3EPKhLDtnHyC5e0xa1L+W28QVWrJiOZkd+j4Y/nzIv8qyz6B02DHH003aKC?=
 =?us-ascii?Q?nSJwceBkgSKb+pk4YY2EiNNB0c+BZIIR43+SffWSr9njhHzkZaZPOmIspKJj?=
 =?us-ascii?Q?K8Bg6uzTifn2w0q+1rQP8KiUFBDvFMDd9n845J8UA+SGEJVBdXy6hlea8FAJ?=
 =?us-ascii?Q?IIdS2K6oVOk5SlgJmGVOYfICZAA3g8DjwZqYY73Jr/Fhpvj7U2bua6dt+ifW?=
 =?us-ascii?Q?GFlaJDfYoxbdVEyHSuJNOMNgERcL8J+Dj6BX9Lyphe1Q3e/Bb17yaNt/llgN?=
 =?us-ascii?Q?IXYvIhGTHkUrZ3ZHWs9quLyC7SGbt/4qYgDbUS7O/T3ZTqI7e5tLqIOJxEhP?=
 =?us-ascii?Q?/tD/vy5ieLeSwa94lQTU4M03UD5yRd3JrUruA82YIYD8bdOuxcCicSLkDp/f?=
 =?us-ascii?Q?rwjsX2sMD9y3SNIAvO8yAiYCxKmfiQsWEUzws04thfxLnhGICDT4afT7zGKS?=
 =?us-ascii?Q?H7oDL/x2xGYNcZIq7cINjoIEzfU6bF2HUEkIqz62bCWUJ0ps2+IFmTASzIRi?=
 =?us-ascii?Q?C2kYU3sykKPs8Uyop56jwfJutc7t9gDQfUXDUllXt21crO+rWdbhaQJICeL7?=
 =?us-ascii?Q?V0dskWb4SOW84QSvzdioGhODp11a65Q7i5CVFdOEFVgLLkZZaZcXp1DInP6I?=
 =?us-ascii?Q?yqOOwDwyqYIcVnSWChiGcjnH22yqVO0TaU3LosP7hC9fOJnsjPJcK1EZhqQv?=
 =?us-ascii?Q?dWxuTvWr/LJ3DZD2fpPmJEmOfpbfgxAhiDnoFjvpzyrZ+8623tfIP2Ve2ajY?=
 =?us-ascii?Q?v+yY3PFOvb5We1zVPkvh3BBerGfhIxxAr+iqjYHFpQj/caNQwOLCwALyYWl4?=
 =?us-ascii?Q?/PAbwVXzawlSYdWZ6ExUfZJp+FMBXVV+xMBqQzWaWP3tz8iErkkb48I8/V9Z?=
 =?us-ascii?Q?bN4e22mpPNOwOmmX5+1xRB97oCEZ8x31HGMvEB+sDmNlBhQJ08hwnQF6bmW9?=
 =?us-ascii?Q?sSb8xvfT3F55LgrrJm660WUMVWL0F9ju74mPXiUaA/XJbw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB7496.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LLSXX+BF8hNeRgjT2MVx2ZcDj7+DdpVxvaOQWIg5sgWEt938vVPkYCOeMCkN?=
 =?us-ascii?Q?/N912DvN7BaqrcvTglNS7Gt/Y1zh6PVM+a4leH3o2vTzgVXAo2ZjbIpg+dU7?=
 =?us-ascii?Q?LF6gdBZC0fZDgr2DEzXz9wM4IEg3nrXW7l4Ol09SBNfokMXRnvBx34E4fqbA?=
 =?us-ascii?Q?53i+LNlcCCJgC8Jj8+0AfkwGzK8b/EL1vki5+xkOuUogNHwpq2AKGrQp3OGc?=
 =?us-ascii?Q?rA0fzZShnLxAooUPCoB0NMIfoejyJIBqsBeiqpdVoU4Gt6AASn/FmbhEQiOG?=
 =?us-ascii?Q?Y+vQ9qrzljJoFpCx9j41CXbIlgdoxvB2FQzVw+osLO/c5vRmEs1jhWBNETKG?=
 =?us-ascii?Q?nuqkfFNdrotGZFzH5i6RSj92tc1YFi6a+hnNoSfym5yUXNE+IXWCVch0QTud?=
 =?us-ascii?Q?wHNABQw/8TBFyxLxVmBF97VA181su6ormivfnvzwAm0P2XpbMa5GnkpcqGAV?=
 =?us-ascii?Q?5qh9NwR4YEvk9CC9l+g3ZZ5lSvHzwja7SLc0B4yHGupwRZHWUjRM42pjnwDo?=
 =?us-ascii?Q?SOfHQWykMY6NtDnAPnBIffmP88y57znDeG/DWets9RZbof+FWLH1U1x+AR0r?=
 =?us-ascii?Q?kaJtGYMrnv65GrlKOZE2AfQKGr3kxeA8FHpCW/vccAxelJL/Z58t4FbMvgrG?=
 =?us-ascii?Q?m60G9QB+e6FFmovAVaJmjqjYhOuP64Ip83rTgbqR3+mKzwerpm5WFYTgtDuU?=
 =?us-ascii?Q?jBcMGFlHsdE0iX9N/kqn/TbpSNmjS/n1yddrcQf+oVSYneAjS6beM/px1+41?=
 =?us-ascii?Q?BITDjcejGKYwDUsuZ70j8FPhraOFHdD1Vu6TZwnN5vdYqPRdUCjjwzMsZLrB?=
 =?us-ascii?Q?qsOJupOsegx/XQVp4mPWHQ0u9Etv5qeUaAXVZn90K/CT8tDvXBvR7j9gBlth?=
 =?us-ascii?Q?HbGK3bhsyxOGW5Ssm626YCH0dSqJITlsmWqgAwLljDt16eJpN0dw7vqQIezs?=
 =?us-ascii?Q?JpRliSSN/rOi/PqCgEzsHNC1lZfZ2kzxrBKQcwK7rrmdpezvFZ271tiPfswi?=
 =?us-ascii?Q?tP1bomv6bDHaI2S1Cvsh45xPLx6ZSzHA+AOiTTwxXO0g6zjMKT9+Ey781O8F?=
 =?us-ascii?Q?zxFQpRuRgOfUE23mN4u6/ltofbsAHcxf0p55Pj9AlHdOEvfZN4vOzQXbOdIN?=
 =?us-ascii?Q?Xg970vlN1vi3idNy5NWCMeypbpSZaj0TOMNbG7i1fj7kVuPgM5HPVx1htstv?=
 =?us-ascii?Q?LNGc1PsOJM6FMczMh9D3yrikCLHlbibSzOSWhOFQ/SgJFB0bC9qe2jhybAnh?=
 =?us-ascii?Q?qKDMfUYNL7mhWQIQH/4nTaKDUNLjbPm1eE3S4ycTLN2XU7s6Nj0bLtgE2w+K?=
 =?us-ascii?Q?P+gWsVLWBEkn9jtOb9+GOsgjDjjGjZKRsy/GfdjVEjXhuJ46Dt7Zo2Fu8Xow?=
 =?us-ascii?Q?HjOFG1Hc+7hb1OQORPGZUIZU2zYq2Do5Xp1a5hhb2rzJpT+ybXLWsip9KSDV?=
 =?us-ascii?Q?3b7pUWiZLSjRzKSQF8uKM847+9Flty4zdQBP897m4HeAQLNmrClNqNUXQce9?=
 =?us-ascii?Q?vYoP1zvX3Xm/K4gDnwUlBVC6kCjUMhAlg2t6USLHzxbpeFgBnP/MqTalrfd+?=
 =?us-ascii?Q?GD0yWC2ZpQdTz1Ahw+rIwQCGqqkM8pFSRKpc+Myk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8250ea6-0ff9-4403-bc60-08dd158c3dfb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 00:23:43.7507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hZNBHkENe6w8Yz9NI08h/RXcxJjTtl8AX1Ji0LAP6UWpqXWgmB4DrQrf4r5d7nXG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6332

From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>

All the callers have been removed by the below commit, remove the
implementation and prototypes.

Fixes: 322d889ae7d3 ("iommu/amd: Remove amd_iommu_domain_update() from page table freeing")
Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu.h | 1 -
 drivers/iommu/amd/iommu.c     | 9 ---------
 2 files changed, 10 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 1bef5d55b2f9dd..c38e02510cf737 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -89,7 +89,6 @@ int amd_iommu_complete_ppr(struct device *dev, u32 pasid, int status, int tag);
  */
 void amd_iommu_flush_all_caches(struct amd_iommu *iommu);
 void amd_iommu_update_and_flush_device_table(struct protection_domain *domain);
-void amd_iommu_domain_update(struct protection_domain *domain);
 void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 				  u64 address, size_t size);
 void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 16f40b8000d798..7e7246c49006ad 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1603,15 +1603,6 @@ void amd_iommu_update_and_flush_device_table(struct protection_domain *domain)
 	domain_flush_complete(domain);
 }
 
-void amd_iommu_domain_update(struct protection_domain *domain)
-{
-	/* Update device table */
-	amd_iommu_update_and_flush_device_table(domain);
-
-	/* Flush domain TLB(s) and wait for completion */
-	amd_iommu_domain_flush_all(domain);
-}
-
 int amd_iommu_complete_ppr(struct device *dev, u32 pasid, int status, int tag)
 {
 	struct iommu_dev_data *dev_data;
-- 
2.43.0

