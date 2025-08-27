Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716182D1F40;
	Wed, 27 Aug 2025 20:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756324812; cv=fail; b=XSxgHRBhBTuRy6+4Yp4FCc4CVEP7mU6oWOLK7g1XsMXfvtGXDDC4MSKlH90Uy0iM8YvKXNwpnc+vauj76HhL48q923ibgy36b70Tm04+39MedQINILF8liQwsnFG5JQEKRmPc5gbCt6uxWsi0ziyJEcKlemGK2AgeJtpK2WOtpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756324812; c=relaxed/simple;
	bh=pKJ2d27yW9MjnZuSItJt6Ax8YJuQRfWQRK3orIqaoS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H2e4l2KleuYt0gEw4qPWitk0nKNKvtUb1t0wD677ajuK0ifWQ0B7C/RK+e9lZVrxvxxcfyGgAKmKZ7I6oYBwIXXh7YzXVywK2ZPocbcvEf6fGYRyvG6hs7tVrYa6myiv98Mt1qXBOW7BYdZjwVT7pEXX08pdoqcnAiYJHXOPZyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WVpNwguX; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WVpNwguX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yUMSTVsb0IOmInjNvFVmqsM13QS9fZDs+/MrQEiEEXdTc025R1sSoUZ4FNiQ/G2HF+Z+tx1Vi3lXZbFGLV0CWziany7EzjYaqPveSRPQz1R16G8tkBft1gzkV2jmojqUNzyj4kRbtJ1zlW6UMszNTaZLLcoLlvxM8hPYzeJIPuF3ux1DF5VgAttZf+GWBxwuVr8Ffu+1rUJTec6ZNJiaI0J/kaOhmCfjOk/cufs5eHXyvQ1+Ge0/R3JtFU7Ryd6REK0EHTUC2igCKDc4z5sHxlFdQkAlOBZj1lurCpVapjOEiDOORREGWHbsnMHUn+WAeg+HLpkbid5XHGM+Ef13zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TzNwIa7gpj5ICksPmOkJwZop0idGEfBpg8YtS1SRRkY=;
 b=snBfWCrEYMc6HMqPPyRKJ+c0BmumqdB2Ni2EM8832GitWLVWtgCAcTwZIW5Vbocz5cbcMQyHYb+r/qKJ2U6UfSxHchDhkV0Pmn7TTmS21bXScRvXO05jJwamggTbSna9Nhdtipjcz5HQnDBVRbiWM2k+rIl2NW1lTH4rGU2pEoRlTDTcRxNKEu5fygpxj2IEljVu6IgSy1lvnQ62sCzuGbCza/Ki5p+ljumY9vOoIawB/sLPp8coEnVZvkJCc7ouUOtZAePCrR3rwFrQV6glsI/kmE/aQXtpTT4bLk/YnYhip7J/VfS3E/8cU2BcsjFRooda6z3iv6ROLI9PfLZUkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzNwIa7gpj5ICksPmOkJwZop0idGEfBpg8YtS1SRRkY=;
 b=WVpNwguXuRGhRCA6z+37ZdubE1jWaf11lGFcjNbQ3PtnUOn9MVc0WDZE296cbfPRdsgLXpV6JrHqXTYC5WgTrFBAxGti3ecH9Wi0gyKY1JJoxawgoRZSjy5dDlGq+rrkpONB6mybzx0Mw6jx7po/L4525l8nrpwoClLueRV0r62M/GcOUGyQpIWaCLIwzZnXAuYVqTMw9Qgh+4g2ZUfq+OIYes8ix/hVDgDPA0Nz66mr8LCqEMcj6I4DUJSAUIRNZXK31cIKXHVxuiWv9DB/NMHMcwrYADXn0NzEj5rpBy5L2WKAYg8LO3cXS0atF2TeXX+WLw9ma9xM5nwiQdV30A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB8503.namprd12.prod.outlook.com (2603:10b6:8:15a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 20:00:05 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 20:00:05 +0000
Date: Wed, 27 Aug 2025 17:00:02 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
	jean-philippe@linaro.org, miko.lenczewski@arm.com,
	balbirs@nvidia.com, peterz@infradead.org, smostafa@google.com,
	kevin.tian@intel.com, praan@google.com, zhangzekun11@huawei.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH rfcv1 4/8] iommu/arm-smmu-v3: Introduce a per-domain
 arm_smmu_invs array
Message-ID: <20250827200002.GD2206304@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
 <fbec39124b18c231d19a9b2b05551b131ac14237.1755131672.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbec39124b18c231d19a9b2b05551b131ac14237.1755131672.git.nicolinc@nvidia.com>
X-ClientProxiedBy: BY5PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:a03:180::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB8503:EE_
X-MS-Office365-Filtering-Correlation-Id: f13331af-14c4-4756-d3c1-08dde5a450ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?znxOawn0KroKXJstA9k6r2ebH1V0TVOiBxDLxv3Vznkn4zGmlbGihbO04ic4?=
 =?us-ascii?Q?B2Wqz25YpSRgPFiObuxWA9tJRLMfXlFUvZA9Cbd5VZCKJegaymkOkQbX37Y6?=
 =?us-ascii?Q?piMtm10Ac8VZXxfbCXn3e1MZfFQcwrcXlenkK51JTbt1HpdtNh+n4Cc/LIN/?=
 =?us-ascii?Q?nQgYFFFMakypCPk7Bx2yjdsS981SKmuWE83TlerBY688Gp0bX1SwwrFEnLxX?=
 =?us-ascii?Q?I+ca7g2Z3ljXH9nbvfSSdwBt+72m+TQOjbOdxr7GaXWvAQLZzer5N8L8DIQB?=
 =?us-ascii?Q?SVv+6iYgJG3KrHJMjB5eAd2Yaa2VL5/FAPm0peiLWy43ODRhNjTIiQRx28pZ?=
 =?us-ascii?Q?MsIbUB7huuDNg/aIv8QyrnOiv8Q50TYu413UT7b6KCp4DkZvFvmVEdLSmWZt?=
 =?us-ascii?Q?1gYdTwEQkKHa1pcRBp+bAtG8TNvM22BcK1IfH3D/Uq/MWK60gcZODJansaHJ?=
 =?us-ascii?Q?lUP8rEh4WVzDQ0vIU9iNY4+MrGmxjGf5f99THwbcHyMGvK16ya5poz2yHAqQ?=
 =?us-ascii?Q?Zqa14QH3Aor0bQzSE7dUPMz/dh/7fjolPNHChJHub0J/Xu4EOA5BkTAFco7B?=
 =?us-ascii?Q?aPEhZiEEjNWQSvYnTA6o/079zLew5fbYUEXEHxQgdAnbJUAxWGuCLLkfaBnF?=
 =?us-ascii?Q?kxJykak8aiK3lWm0MvDk2YgzM5HkChjzSYIVt5AhsGn1pg+TfDdlDky1YePW?=
 =?us-ascii?Q?iKNrpCkI4+2DFViOadVypwLqEb2rVq5DUnt6qYGNTCJGuwHUPEn3G52QOCAv?=
 =?us-ascii?Q?mFWIVgTkMJW5wSBPKXIXLTgTTTAIYCJ4Rp9soevfL+dwqwCFPHsQh2eb8HQ3?=
 =?us-ascii?Q?s6OzhUxFwCB2nj73Tn8UCbDfLC/Qy+Va87pHM9rI5NjCzRIPMe54ep0dD3I8?=
 =?us-ascii?Q?FOtI03xqBtgD8LdnAc3rJXdb8Abh7wiTSkepPfdw+DSXzSwSQ+0sbP5h8LbC?=
 =?us-ascii?Q?XGM19eL07/2wyrdLqQY+YHzO27CjfbZEgwn2EaO7QqXlA10PlQcPXoB5elsP?=
 =?us-ascii?Q?sEwuI94zih4A+lrK5GI1EE3fjqgvdE/blGx51kxT1vE9zITd8i5u2WmsZj8L?=
 =?us-ascii?Q?/KhInT4tbukfykN0WY1JD5xV4zAsCYY/b2D+4fqt8DumIbTO+QmnIXnKt9pl?=
 =?us-ascii?Q?spW+JniTiK+Mb/SHW2jWhQ/e/EvQ4jpW4R9ielm+VTk+ZKam6IhSiKCmVa1U?=
 =?us-ascii?Q?ODGgEaS4JjlbpJJmdOeY3VvBCvOFLnu6HlnFuGhMNE6hvein3qA05IUNQIIS?=
 =?us-ascii?Q?7g3tqekOsPtZOTfGTiPWzKjauvNsdDp+RerwY92Zv9OlGmBToshhO3D/OtTD?=
 =?us-ascii?Q?W08N5Uc4gid7zRHNyoOV8zHr4FBYSGHK+IMz5F8PNtgeAlkrCga6qW6zZYqv?=
 =?us-ascii?Q?GVZoa52lY36FC+0TyCPM3J84Vo/KzRViLW0HMAokC9scFscruQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1WWObZOiBWZsIvRpGn4aA3wc8SFXZveRem8KFCd0a/HljLtCXTWmyK5Q8A2g?=
 =?us-ascii?Q?TAyZJmlhAukikFF2QNmJjvOWzaSstJzVkSdu/wWdN3C8M0sNCG12gDQHYexc?=
 =?us-ascii?Q?le8Hpfn1cF0bP8QE61+4pJpFSotXSCIK12agsEYQWR1xc2qksU/OjBOLZzG2?=
 =?us-ascii?Q?8hL3/lC5tADCobNahBmxlLqVPaBcaGERgeh/ZsFRj6c9328X/MpyE7lQodXQ?=
 =?us-ascii?Q?kodowM/zCgocK3TllF4c/cA3SR4CH4NL78df3OWv5MR2WKzlvLL22ETMM7GC?=
 =?us-ascii?Q?6hLRTsUZYM/1mIElqcy5DwJ4FWDmo9j7quiTf9doYwogp0aty6uOcUGwS8ni?=
 =?us-ascii?Q?KzM8ULoJmKsAa5w66he8v6iRgaWRwJ67zgOykcactNzmJVro9XVjjhfZAy+0?=
 =?us-ascii?Q?jh8q7hzQXs4Ha0IzKdT6ZFNPEwftiXHyoCKrpY06pRwOUEM0rxha2qnnt289?=
 =?us-ascii?Q?CBODFLc+1P3gCtcTSxqS7T9XgLcritQzIJnWYEFjjaTIV6nYen/XOvLJXVPt?=
 =?us-ascii?Q?y2xVrYLFsZBpk6ZmPCyTf+1PWXxCb/H5HeAo8PUR3rUmkP9V7pq+NIvB268O?=
 =?us-ascii?Q?e5U6ZRf1IkIhyZwy/2HVQktzlxcCuEdfKmAbtM4EOVWz0cOyXe2gIQixvXp9?=
 =?us-ascii?Q?TJUqOIHcrGGPKxwxGd/T/nptckhbeCO/BmsZnomA1zmKrW6mgl4CZB2oFt6W?=
 =?us-ascii?Q?Rhpa4eqfp+RYjHJsqnn4HLtezp7sKqIq8wg2zxaIVbMAXL23q0fWYljb/Tam?=
 =?us-ascii?Q?Tcb+9zVuDab+G8zOrF063h6431/kGD6v+mh1Ru64xsqH5EGRTFl5dIjxXKr/?=
 =?us-ascii?Q?oJ6GZ3TTqb/yk1cBvB6sOi3JbKAMoUcUhVIZIrngLqVYxpeVMiENlLPY0dO0?=
 =?us-ascii?Q?mKTBzFjeZdYiJ8knLUT6r4zfIy0oxI5KyRdt3BsI8qn1XAicTPJzniabfqpZ?=
 =?us-ascii?Q?IQmjQemO2b0cAzzZ7JLol5Pxd1wfu4N0qPS151Vl5fCgGSOxSJnlYlO3idjs?=
 =?us-ascii?Q?+KPYxjj+lXhBLmS73icEvpiK1nyyz490ybB1GVNRqc8ZuPBxgfeq5a0zcNj/?=
 =?us-ascii?Q?UCI7CqWBrgwxR3T8Hkoev3UHvYPRdacDm4YqPptGk1ybI7sYx6xeHQMcqEqE?=
 =?us-ascii?Q?EM3Pxye6OzQZgS7tZQfi/nl6mcGeQ3955uZiVyM+fs0zZgQJabncEIKAFD9J?=
 =?us-ascii?Q?SkUHKjRIf1QGsh+dGQEPlfGXXYa5u9vAPCS/U0RNQVwDeWFnfb4VY9nEkl23?=
 =?us-ascii?Q?6SO421WlOIX5lIaLEUgePCSn4+6NIB/ahkElFP9qvRepS8SNcgt9rRNsBbiK?=
 =?us-ascii?Q?nljWg1Dm/mCXUgTLugw6MpK+jxcjYPOVEUQv3Um4smor6/S73RDeORXq98c8?=
 =?us-ascii?Q?ERt/n2WeusuVP4KxBOykcW8JLkLYTvZJs29IlDq/82kaWkgrVvXZMzZIBcOZ?=
 =?us-ascii?Q?IneNQrOdy75+eqthAXfxLmdsGJ8ArL63KMYcQVE0LMr1HeYtyg4cpSQRJqhk?=
 =?us-ascii?Q?a9VuZ/dPiWmzrtp+/7gdnD1A1oEQN2sZBnbqGSrdAaZjLTJhmtRMLDdsPthC?=
 =?us-ascii?Q?/jwLdeo/woWhQJq1EBLXlB0yOVa/o6M67BKvnsoE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f13331af-14c4-4756-d3c1-08dde5a450ef
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 20:00:05.4040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ap3El40LAI7bYvFM4l+n4dZbFWNZ3pambipp07iGoIM01lu4SYpJNP5zma+iCbCj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8503

On Wed, Aug 13, 2025 at 06:25:35PM -0700, Nicolin Chen wrote:
> +struct arm_smmu_invs *arm_smmu_invs_add(struct arm_smmu_invs *old_invs,
> +					struct arm_smmu_invs *add_invs)
> +{

It turns out it is fairly easy and cheap to sort add_invs by sorting
the ids during probe:

@@ -3983,6 +3989,14 @@ static int arm_smmu_init_sid_strtab(struct arm_smmu_device *smmu, u32 sid)
        return 0;
 }
 
+static int arm_smmu_ids_cmp(const void *_l, const void *_r)
+{
+       const typeof_member(struct iommu_fwspec, ids[0]) *l = _l;
+       const typeof_member(struct iommu_fwspec, ids[0]) *r = _r;
+
+       return cmp_int(*l, *r);
+}
+
 static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
                                  struct arm_smmu_master *master)
 {
@@ -4011,6 +4025,13 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
                return PTR_ERR(master->invs);
        }
 
+       /*
+        * Put the ids into order so that arm_smmu_build_invs() can trivially
+        * generate sorted lists.
+        */
+       sort_nonatomic(fwspec->ids, fwspec->num_ids, sizeof(fwspec->ids[0]),
+                      arm_smmu_ids_cmp, NULL);
+
        mutex_lock(&smmu->streams_mutex);
        for (i = 0; i < fwspec->num_ids; i++) {
                struct arm_smmu_stream *new_stream = &master->streams[i];

Then arm_smmu_build_invs() trivially makes sorted lists.

So if old_invs and add_invs are both sorted list we can use variations
on a merge algorithm for sorted lists which is both simpler to
understand and runs faster:

/*
 * Compare used for merging two sorted lists. Merge compare of two sorted list
 * items. If one side is past the end of the list then return the other side to
 * let it run out the iteration.
 */
static inline int arm_smmu_invs_merge_cmp(const struct arm_smmu_invs *lhs,
					  size_t lhs_idx,
					  const struct arm_smmu_invs *rhs,
					  size_t rhs_idx)
{
	if (lhs_idx != lhs->num_invs && rhs_idx != rhs->num_invs)
		return arm_smmu_invs_cmp(&lhs->inv[lhs_idx],
					 &rhs->inv[rhs_idx]);
	if (lhs_idx != lhs->num_invs)
		return -1;
	return 1;
}

struct arm_smmu_invs *arm_smmu_invs_add(struct arm_smmu_invs *invs,
					struct arm_smmu_invs *add_invs)
{
	struct arm_smmu_invs *new_invs;
	struct arm_smmu_inv *new;
	size_t to_add = 0;
	size_t to_del = 0;
	size_t i, j;

	for (i = 0, j = 0; i != invs->num_invs || j != add_invs->num_invs;) {
		int cmp = arm_smmu_invs_merge_cmp(invs, i, add_invs, j);

		if (cmp < 0) {
			/* not found in add_invs, leave alone */
			if (refcount_read(&invs->inv[i].users))
				i++;
			else
				to_del++;
		} else if (cmp == 0) {
			/* same item */
			i++;
			j++;
		} else {
			/* unique to add_invs */
			to_add++;
			j++;
		}
	}

	new_invs = arm_smmu_invs_alloc(invs->num_invs + to_add - to_del);
	if (IS_ERR(new_invs))
		return new_invs;

	new = new_invs->inv;
	for (i = 0, j = 0; i != invs->num_invs || j != add_invs->num_invs;) {
		int cmp = arm_smmu_invs_merge_cmp(invs, i, add_invs, j);

		if (cmp <= 0 && !refcount_read(&invs->inv[i].users)) {
			i++;
			continue;
		}

		if (cmp < 0) {
			*new = invs->inv[i];
			i++;
		} else if (cmp == 0) {
			*new = invs->inv[i];
			refcount_inc(&new->users);
			i++;
			j++;
		} else {
			*new = add_invs->inv[j];
			refcount_set(&new->users, 1);
			j++;
		}
		if (arm_smmu_inv_is_ats(new))
			new_invs->has_ats = true;
		new++;
	}

	WARN_ON(new != new_invs->inv + new_invs->num_invs);

	/*
	 * A sorted array allows batching invalidations together for fewer SYNCs.
	 * Also, ATS must follow the ASID/VMID invalidation SYNC.
	 */
	sort_nonatomic(new_invs->inv, new_invs->num_invs,
		       sizeof(add_invs->inv[0]), arm_smmu_invs_cmp, NULL);
	return new_invs;
}

size_t arm_smmu_invs_dec(struct arm_smmu_invs *invs,
			 struct arm_smmu_invs *dec_invs)
{
	size_t to_del = 0;
	size_t i, j;

	for (i = 0, j = 0; i != invs->num_invs || j != dec_invs->num_invs;) {
		int cmp = arm_smmu_invs_merge_cmp(invs, i, dec_invs, j);

		if (cmp < 0) {
			/* not found in dec_invs, leave alone */
			i++;
		} else if (cmp == 0) {
			/* same item */
			if (refcount_dec_and_test(&invs->inv[i].users)) {
				dec_invs->inv[j].todel = true;
				to_del++;
			}
			i++;
			j++;
		} else {
			/* item in dec_invs is not in invs? */
			WARN_ON(true);
			j++;
		}
	}
	return to_del;
}
