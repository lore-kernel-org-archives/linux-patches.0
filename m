Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010063.outbound.protection.outlook.com [52.101.56.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8579015D1;
	Wed, 24 Sep 2025 21:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758750142; cv=fail; b=RFRaAwDCg/s4HgQ93bo4HXDko4V4xZQtGFATNutN0GcEuDLrEwnjt+D/Ucn2ghOZccZ7l5eFm5YodnUbYoffUfBalUahPhwE9aN4c5EV+QkYK/XwEXzMDp6+Oh9T8Be73GzPbL8WxtdTTCX3W8KEwKCc1gpr9g2o9dkwErGi0ks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758750142; c=relaxed/simple;
	bh=RJVHG4edTXyJL1PKSzHboykdz370vUrJ0VqHmVNbaI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tOlzm3QsexvqNOmYFTCgj2wV7xkpCoTg0K32qjKjR7SBBUNK/0N0fEZP0569jgC0pImptio7wybW3L0X8yqWxfCiKjO6avKwRQbg6HFhS4t5B9AiklnsvR97M4WbmnKnhAJAjpnqu/VDU3qhdqAiVxT3vWsPC7TWSjGVnKy5V+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DRFLLEm2; arc=fail smtp.client-ip=52.101.56.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DRFLLEm2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yEjwrHUaCgDomwY5HF24FNcCI+oGeikamXIbRQc8X+4yDI1V/cXbts8jVQZ4NB05J7QY9WCY5znp7wUWKnAKGQMz6f+rot2UM0hAH5VN/eUwEEnJUyEcBN2xTvkZDx/be7dFlT4EJWo8R3HS3VPR9zga7APz6TXLW25oOdFqqeqzN9km62KudDLFMIfefuPDjRfjX2/ETL+WlsMw66MwzvYzUDpt0iGFHzWhzaGVVTFWh4hz0LqVYhU0m8B/XCWxTB7FQQFQq/yyd61Z0mCQrn6S5isjanQ9WRBQRMqADy/uwNXm+Fl54f62++WQ5MbXZWClv8y1cgZ8XNrsIHvtfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iQejVG3jeOCyZMcp9YSWTmMde/m2IBpJNNWukQiF19I=;
 b=r0SKCo6WCtqh2igagmiI3j07r8qtQ0OCsJfj5TkNNVosvneNxrg7t/qDZrZz1vioFjeLv+pPjTj2LQ0ESKJh5yiHyul+Q+Mq8zEEoJPCx9sTY27kGLwgqaWJ904gK4h86IuMidghIaRFPxmA91Xb4WjNkGZGKWr2+Pe4yZxu5AD3Lkd0do6kUoftnUKw+Xq9Y7kNqSh/6LkbxfNXw2pfnC24VxDVxak7qRCw2EGNKWz/PtOmXGxrO73tLXYjEDzDk0+kzxQZJTEcSghaplNeWWsQsjaFSddaSK38SDaYXwU3z8QGuRYXQTjLwWUOlnI/Jw+X5gJ+QXJ6J0Acx3RVBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQejVG3jeOCyZMcp9YSWTmMde/m2IBpJNNWukQiF19I=;
 b=DRFLLEm2EG4/Pq+6lC62Gailt3knelHI0X+Fwzj3We/7wUJ0MuJIWXVwFAyQKkmpIo6NCcGrpUcaOLrpMVKCERX6bjXs44DtQ88Zz/RyfHAxdConMnVVYvy+bAJg+bfW0BCzuT/pxQdZhVrkztewrLSKjKzZZ3myQG5dyJN7wbkoWqZt8OHVDQGg4Ap7teMnKXf2i5nAgng7ouN9reHPEZurnsDuSVN9YKy45yhDigNoOF5pWiWBSvxnmsuG2PZSi5qT4OfMesoWABdSCvqDcg2mdox5XzCJKhVJuQeGKVkZYwPmMbr8EJAP32Tmfvr8e/BmKA+odEuSSuiBxv6K9g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SA1PR12MB6894.namprd12.prod.outlook.com (2603:10b6:806:24d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Wed, 24 Sep
 2025 21:42:17 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.021; Wed, 24 Sep 2025
 21:42:17 +0000
Date: Wed, 24 Sep 2025 18:42:15 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
	jean-philippe@linaro.org, miko.lenczewski@arm.com,
	balbirs@nvidia.com, peterz@infradead.org, smostafa@google.com,
	kevin.tian@intel.com, praan@google.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH rfcv2 6/8] iommu/arm-smmu-v3: Populate smmu_domain->invs
 when attaching masters
Message-ID: <20250924214215.GR2617119@nvidia.com>
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <d3f9777e46d531273dfecb54d69725428cdef308.1757373449.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3f9777e46d531273dfecb54d69725428cdef308.1757373449.git.nicolinc@nvidia.com>
X-ClientProxiedBy: SJ0PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::26) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SA1PR12MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cfd53c1-b4d0-4dcf-a0bc-08ddfbb33b50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2/L/tRC7UgWbx6xDtdeLpfgqCprjObBnG9s3X+WRoIo9q+d+CAJlEWzhLQPj?=
 =?us-ascii?Q?6AmFTuHRuHZnBKojtWdIVJIfKJ+EYJLV400ByQ81BXpcRFbBgE540SxyEY94?=
 =?us-ascii?Q?aZ+uFw+YBBA86Drmh8fd9fzOw8ltzXQQaITB8QsUC8qlY1b0JCWSmkPvNtUS?=
 =?us-ascii?Q?7cO85pao7IzoDS0KINmCRd6g+T4UiD5UD/zwSDNPQpXyxXdAGkKk0UYqyUAn?=
 =?us-ascii?Q?KPaIsvx1+OdK+n02v7qpx+VvE/WwnLgQ1CjGTlizMFE3l5LSQfJu86GhsdmE?=
 =?us-ascii?Q?hjRaPau1crG9kdAGxmUsPHIrs6W5Gkk9ZV3IGn/7kc/kZuo/JvaAdwp8YXqe?=
 =?us-ascii?Q?VDE3j7o9qYasXW9eO7JotG8KQsmrnGohun4hGQW7FrZW4WUDQ956WAtY7tW6?=
 =?us-ascii?Q?t58cPpmE5tABlPbJwutNWf3zEJHBjgqPgqzSwLO5Bo8UV2nl7iAOnpBIV708?=
 =?us-ascii?Q?XthSsX3aG5MX+ULR46jhHmDutKeqBxN7jA1OBG+JCYMOVKvImy7J32H7zXyw?=
 =?us-ascii?Q?EjbKw7CtHrKEtS8qMy7FugmzPkBkj8RN2t+hz15ltJvLRafLIS4H2y154ep/?=
 =?us-ascii?Q?hfA+a9lgA28vC0xnWaM09d4Vw8Iiy8WePc9zrcqL8dGxQbN59uuIqkZ5ovUc?=
 =?us-ascii?Q?Vv4MrpUs4OxOORszmIiCa5cztLm2ZvPQafTl5GKoS7nWsy/lUiVgxayNLmaV?=
 =?us-ascii?Q?hVxIOxGAJ9gy2jV1rliLg6SxmdgDmHTgJFHNoYPOT8XAh7JOGKwspmh19WDf?=
 =?us-ascii?Q?Ok4yNdo6UjHaweecW1EH6aRn0bgOMbyJlgs8MGd6dEjTd6sX4Oyh4/BjahbC?=
 =?us-ascii?Q?bGJJhFMcOGce6vzg3W7WOUSAd03teWgp1qTwFVOpkJBDqHKDYYaxAheztA1u?=
 =?us-ascii?Q?jMD0y1XxstGjCfjdd7oJEXgxt8giNNpa1CDOnobZ1ap7sGtY4ZxAeVZmPqei?=
 =?us-ascii?Q?XvgAMZz8DKzCJuWBDf+/g/yXRAvDabbVbPlNlOdSZb4m/UeoiYv9DAu3mdXq?=
 =?us-ascii?Q?0a4eBok1MEOuA6z4CJ+0YvwVtDNC0CYKIb7IPBsiteGS9BzO5ne5C6IFrPKE?=
 =?us-ascii?Q?QMmSk00/ueGq0WsAxZGOm96aEEp5Uk67t/XpXC/FY48q9HlLXelAlASmRKbr?=
 =?us-ascii?Q?4gzDi+SdAlBpOCGM2kTCwoA4jE91T79w+yB32EPzc2z0Oy5nvzEJXOKua5VS?=
 =?us-ascii?Q?nWORrFuRJMrsOmzhGEyI9TyuOVutAAoV6xt0Xzxx1cbbNqyfCoIH06bQmRJm?=
 =?us-ascii?Q?ppLDi87KZPSHZZSmabxPWWygJurrrUscmhjo67s04NX4z1IEFJXDD/C+D6V1?=
 =?us-ascii?Q?yEiFzVuYPHYQOC/ekZ607OtKkK5hU8QSMyzDS3bHLbv0PfuyGuiCe37sIUTx?=
 =?us-ascii?Q?qR+Ym1L8pHjzeqvZFHCUIv3c8hPqLeqOBcnqafJedS2YWRVnIyu9UGcXZIcD?=
 =?us-ascii?Q?wXRHoQTHnFk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9Tnko+P9cKyGo85JxnQte+HcXirw70Y0SRPxlUOAjFRTiRygPZRQQ5wj95Ou?=
 =?us-ascii?Q?FCtFItAIYrUOcfCJ/NBoGxF5+R5K4VakKBHJKuTg/7ZXjUTHrMUX+2nCIVhA?=
 =?us-ascii?Q?L8cOdXtKTcCqCwy313MMNRGzEn+RdRPzcbU82KvtyVN5c3YxXt3LvjK/6cL6?=
 =?us-ascii?Q?6mOoxJPeceULpRO5Cf932ueSxAmZj/D9WOsQNkdGwJ5fqKqFqmZx9k49lvnw?=
 =?us-ascii?Q?hbswjBbgL0gkVZFFI+2Im9sGUvJb5vWDIj7vpHjCQPCg3EkhXA7SYXNvRvPy?=
 =?us-ascii?Q?mptqOutPXb7eCJswwqOvvk/Ywrex+B29QKqrygXnSZ8XXmyD5I8BE1NPI0lj?=
 =?us-ascii?Q?4lbOK0hwS6w3TTwB8i5oeO8RxTpVn6Y3f6b26wLk6fMaWwj6AUFJFAcD/LCN?=
 =?us-ascii?Q?bb/4WyRNuk5rdCHDo1VzZdeGREFVT/fuQ0Pk/9RkLqIYD2wdmXzodOynsvqr?=
 =?us-ascii?Q?8jeEXHe6q+LrUkgeAoZaXBuTPWdGTE5CuO+GkXPoaWEVLG7M1TYta09QQMfV?=
 =?us-ascii?Q?OV2etfPSDceUzYeTkDJtk+Au3sf+9bUnKZFYlOPqoA7kOZ2R1QByxwgCbhVl?=
 =?us-ascii?Q?SpjembfExmI/+i4NICHU0syKrx5oEUfk6d3cGWNCnNyQj2O6RPArkJBtt5xo?=
 =?us-ascii?Q?5IgRNzQ/GDrD6r7a2zoB2IrymAvjH1gAWrUkvx+MmtDl55OupEFIdQ+YjbHC?=
 =?us-ascii?Q?P103IrYPca29Yub2qSJTGS9HWRC0Gj1T7hrSqzr34+PC6ksg0iG4iSPmOWLV?=
 =?us-ascii?Q?BoperQ4oSZbr0faDwfDdi+fZyD80xD0wZdDnudV6R7gYs1sLWC07gJeaSlvR?=
 =?us-ascii?Q?5HrVFAUbQ3nJU4vtpT8M9TgrFVPt/8XqJay17I0e0gQyvNWJcOHTXamqiENB?=
 =?us-ascii?Q?mpOgES/8wit51qdQ5v6PzNgVM/l5LJRZcxDA2jRzxxhXBS6WNBgRFTT4R9SG?=
 =?us-ascii?Q?u/IutabLBVrFnQCJ0lB6L1XwdtmUSS5lWYQ/BbJTauvMCmWHTJ079sg/3wT/?=
 =?us-ascii?Q?pp/3+HuwGztcUcBknWTPc5DrxeZIP6KfFwi9yIc49FrOzesbSpXVhjGwdRlo?=
 =?us-ascii?Q?TCSA3sA+Vhq5YJfzgbF4oGCSRd0eZm8kEJsjFRleFVVdo7TGRTbUosya/i5Z?=
 =?us-ascii?Q?G4GuRh53ACW/usoGZrRbb3/wtxERLKEJcEw3YIgD4Nyn3x2mka8dH2HbBoaT?=
 =?us-ascii?Q?nsOOSA6V4Yfr32RfYWjwVeE2zu63jcuTtXdKeV+l91ydsLN3eYFADCKlkxxV?=
 =?us-ascii?Q?0tWq+TcOEx/yosKmxTACMBJ0AsHuG3NTBAztO0Cam49H32WOSfn2u/vmVgAV?=
 =?us-ascii?Q?PeSa+bkmPpVRCWUA/e5Yf95fVw7Hh48Zof3ER2mWdET/VsLuNn0CTkB5cbL7?=
 =?us-ascii?Q?LNZ0Nm9+5fBRbmGus1Euw5mr1ezrwn1bQIzBQ4RXd1rfIUYi8S0INRyRd8mG?=
 =?us-ascii?Q?oUzzp25Xqu9ndAfNDpTpU2c1Ah4TtIe9Bb2Fci3xuHkZOUa66L59OBFo2oKB?=
 =?us-ascii?Q?P6KJfOMUWow9hljFEpzRWoUinjmZnxEEJM0dFByUJF1iM6NX3/ryyzDc52f3?=
 =?us-ascii?Q?IM53oD9f/4/j+i0mhRxYcKIhBJTklvUkG2+MEru+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cfd53c1-b4d0-4dcf-a0bc-08ddfbb33b50
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 21:42:17.1089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xNI0MIPwLoLbMJjq+nnUm+S3FFTKtCwr0JohNk3s3SmxzOS50/3oqWdRVkwXczUu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6894

On Mon, Sep 08, 2025 at 04:27:00PM -0700, Nicolin Chen wrote:
> Update the invs array with the invalidations required by each domain type
> during attachment operations.
> 
> Only an SVA domain or a paging domain will have an invs array:
>  a. SVA domain will add an INV_TYPE_S1_ASID per SMMU and an INV_TYPE_ATS
>     per SID
> 
>  b. Non-nesting-parent paging domain with no ATS-enabled master will add
>     a single INV_TYPE_S1_ASID or INV_TYPE_S2_VMID per SMMU
> 
>  c. Non-nesting-parent paging domain with ATS-enabled master(s) will do
>     (b) and add an INV_TYPE_ATS per SID
> 
>  d. Nesting-parent paging domain will add an INV_TYPE_S2_VMID followed by
>     an INV_TYPE_S2_VMID_S1_CLEAR per vSMMU. For an ATS-enabled master, it
>     will add an INV_TYPE_ATS_FULL per SID

Just some minor forward looking clarification - this behavior should
be triggered when a nest-parent is attached through the viommu using
a nesting domain with a vSTE.

A nesting-parent that is just normally attached should act like a
normal S2 since it does not and can not have a two stage S1 on top of
it.

We can't quite get there yet until the next series of changing how the
VMID allocation works.

> The per-domain invalidation is not needed, until the domain is attached to
> a master, i.e. a possible translation request. Giving this clears a way to
> allowing the domain to be attached to many SMMUs, and avoids any pointless
> invalidation overheads during a teardown if there are no STE/CDs referring
> to the domain. This also means, when the last device is detached, the old
> domain must flush its ASID or VMID because any iommu_unmap() call after it
> wouldn't initiate any invalidation given an empty domain invs array.

Grammar/phrasing in this paragraph

> Introduce some arm_smmu_invs helper functions for building scratch arrays,
> preparing and installing old/new domain's invalidation arrays.
> 
> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  22 ++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 312 +++++++++++++++++++-
>  2 files changed, 332 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 246c6d84de3ab..e4e0e066108cc 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -678,6 +678,8 @@ struct arm_smmu_inv {
>  /**
>   * struct arm_smmu_invs - Per-domain invalidation array
>   * @num_invs: number of invalidations in the flexible array
> + * @old: flag to synchronize with reader
> + * @rwlock: optional rwlock to fench ATS operations
>   * @rcu: rcu head for kfree_rcu()
>   * @inv: flexible invalidation array
>   *
> @@ -703,6 +705,8 @@ struct arm_smmu_inv {
>   */
>  struct arm_smmu_invs {
>  	size_t num_invs;
> +	rwlock_t rwlock;
> +	u8 old;
>  	struct rcu_head rcu;
>  	struct arm_smmu_inv inv[];
>  };
> @@ -714,6 +718,7 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
>  	new_invs = kzalloc(struct_size(new_invs, inv, num_invs), GFP_KERNEL);
>  	if (!new_invs)
>  		return ERR_PTR(-ENOMEM);
> +	rwlock_init(&new_invs->rwlock);
>  	new_invs->num_invs = num_invs;
>  	return new_invs;
>  }

Put these and related hunks in the patch adding arm_smmu_invs
> @@ -1183,8 +1183,11 @@ size_t arm_smmu_invs_unref(struct arm_smmu_invs *invs,
>  			i++;
>  		} else if (cmp == 0) {
>  			/* same item */
> -			if (refcount_dec_and_test(&invs->inv[i].users))
> +			if (refcount_dec_and_test(&invs->inv[i].users)) {
> +				/* Notify the caller about this deletion */
> +				refcount_set(&to_unref->inv[j].users, 1);
>  				num_dels++;

This is a bit convoluted. Instead of marking the entry and then
iterating the list again just directly call a function to do the
invalidation.

> +static inline void arm_smmu_invs_dbg(struct arm_smmu_master *master,
> +				     struct arm_smmu_domain *smmu_domain,
> +				     struct arm_smmu_invs *invs, char *name)
> +{
> +	size_t i;
> +
> +	dev_dbg(master->dev, "domain (type: %x), invs: %s, num_invs: %ld\n",
> +		smmu_domain->domain.type, name, invs->num_invs);
> +	for (i = 0; i < invs->num_invs; i++) {
> +		struct arm_smmu_inv *cur = &invs->inv[i];
> +
> +		dev_dbg(master->dev,
> +			"  entry: inv[%ld], type: %u, id: %u, users: %u\n", i,
> +			cur->type, cur->id, refcount_read(&cur->users));
> +	}
> +}

Move all the debug code to its own commit and don't send it
> +static void
> +arm_smmu_install_new_domain_invs(struct arm_smmu_attach_state *state)
> +{
> +	struct arm_smmu_inv_state *invst = &state->new_domain_invst;
> +
> +	if (!invst->invs_ptr)
> +		return;
> +
> +	rcu_assign_pointer(*invst->invs_ptr, invst->new_invs);
> +	/*
> +	 * Committed to updating the STE, using the new invalidation array, and
> +	 * acquiring any racing IOPTE updates.
> +	 */
> +	smp_mb();

We are commited to updating the STE. Make the invalidation list
visable to parallel map/unmap threads and acquire any racying IOPTE
updates.

> +	kfree_rcu(invst->old_invs, rcu);
> +}
> +
> +/*
> + * When an array entry's users count reaches zero, it means the ASID/VMID is no
> + * longer being invalidated by map/unmap and must be cleaned. The rule is that
> + * all ASIDs/VMIDs not in an invalidation array are left cleared in the IOTLB.
> + */
> +static void arm_smmu_invs_flush_iotlb_tags(struct arm_smmu_invs *invs)
> +{
> +	size_t i;
> +
> +	for (i = 0; i != invs->num_invs; i++) {

Just remove the loop and accept struct arm_smmu_inv * and call it
directly.

> +	if (!new_invs) {
> +		size_t new_num = old_invs->num_invs;
> +
> +		/*
> +		 * OOM. Couldn't make a copy. Leave the array unoptimized. But
> +		 * trim its size if some tailing entries are marked as trash.
> +		 */
> +		while (new_num != 0) {
> +			if (refcount_read(&old_invs->inv[new_num - 1].users))
> +				break;
> +			new_num--;
> +		}

Would be nicer to have arm_smmu_invs_unref return the new size so we
don't need this loop

Looks Ok to me otherwise

Jason
