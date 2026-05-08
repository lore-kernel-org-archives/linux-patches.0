Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013000.outbound.protection.outlook.com [40.93.201.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510DA3254B3;
	Fri,  8 May 2026 17:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778261866; cv=fail; b=YtLfQAaDw6F2ufUicTkvZTS08+g55xY+/49s5GJwUvX+78Si1LqoAAfvnkeFBIqxw8nleDvtnPjPvvTwOmAJxh18VmWoV3/goG+28eVNf7hKPjlGqeg7uyDGWmrzNvWAeEf+SQTyoxtO1oqfFlbzNjkjo5hMGp4eoQZiNnrzeBI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778261866; c=relaxed/simple;
	bh=f7J1ALt2ekWlM0z3aKreVSv/LKaIPJGgUX0iX6y3XK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kqg3iJJKqTvbKh2ONL0+SCaCSpoyLO/0cIWOUPzYTulhG/rmaiTJ6IEl4dixTnT0aDsQptpAI1vMNRZJ/gP3AnIoMi+lzfiooOPf1B7JPMfnKWloJ9dgK7v4USqE6nyiK7ueo8U1ttLxHZBjZbLDmGBICDAk/afAx9oT35SxVso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=A9uuobhP; arc=fail smtp.client-ip=40.93.201.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="A9uuobhP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sW56COGgIQyEoiX291OryDXohWhMWWiUSELzPOF2IWVdq82XMYr2vjg2mKbpEFKdZD1E7IVWs+iaYG3fEccj9+Ovk7DPzZk78ho/bM+nlWu3yTvPpRULtkCYeHsmFhEEI5dtJfwi6sVwI7vFp0wohQpRcra3n5jPrTy/U5FqPl6U+8Sk+w55+A590nnENg7t4XfGEI96xpHIx6BGi06aa3GF1LSRS8hjfe0boE/O843zh+lsWVCmU+7lszjrF1Vjnx5W4czkVb7BQtILlTROCWMyf5r+NxAJ+PGdakl+6WmbQJEfmjMzYD7RVtBBr4rDoDMyoNpSYcp8SCwMPxAHsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7vVtvJN65jzXaakphSoo/Ji8+WWz3GNy21ZBOF8LR9Y=;
 b=rhN6SziyRUYIbjekh2+Mni55YQuYoGQbh1LGpJEORKntBTHeEIdxUWrqzhouDCn8dNg7Q+7jOOX0R9THR/cB3bz/1fengV+M/cijpwQr/lfSk3om8P8+okCU1gMzSPaAygZHHQapqytVHHgatrQz+mSppzM2+zng164m+uOJzZZc4J4XMlu4QBPuQegXkkwYri8ll4E26iAWMUKPXeqZzfL2P3KWgoePHzvgNmZL5mWSWDFY/CMYWO5sPHJ9Wpvlox2YBXMhmhkofJEcqGpz+xitQ/2nSBFFRsglabuCmIz/vYQTfB1YHA+1p9ia070mste56fwv0+QHjsqi3bSeSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vVtvJN65jzXaakphSoo/Ji8+WWz3GNy21ZBOF8LR9Y=;
 b=A9uuobhPAqKeZuXV39seXS37sFa2hKy1V4ckHbZHf7DdS25TwKRc4dPZi7w28opYHA68s86uul1siXkpeN0z0aenuo0fV4BgiLmfoD7cTwWVC3ywKX2y/gI7S6OrrNxF7B0hPAiHQgKQPqj1CTBl1i7raHuYRLzD1c9b9ZJ4njlA3JbnTXnwqFrgQoP3Qq+hO66aOrWGeroJ+LJE0vn9VcBL9jzDwCaAU/Uyg17azNJOROiLVJTUJoidH/pAtoiZcU4kC0xdUsQs6F00dEfqdXDUZILpHoACVuvzYlzUVqm5colGx2NplKMW4S/CrQwk4UigzS30Y25InbhLwjAcsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB8078.namprd12.prod.outlook.com (2603:10b6:208:3f1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.16; Fri, 8 May
 2026 17:37:38 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.017; Fri, 8 May 2026
 17:37:38 +0000
Date: Fri, 8 May 2026 14:37:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 6/9] iommu/arm-smmu-v3: Directly encode simple commands
Message-ID: <20260508173736.GH9254@nvidia.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <6-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <af3KDBt8vhClSKEF@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af3KDBt8vhClSKEF@google.com>
X-ClientProxiedBy: MN2PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:208:23a::32) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA1PR12MB8078:EE_
X-MS-Office365-Filtering-Correlation-Id: bfd83e7a-ffa3-4dd3-4122-08dead287f2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	WDDcWUBv3UQnYdLgNzo6yOU1sCEf+YjOFGbcnUmqj9nun2dV8t3rHpCJSZE+II+263zpIfnjRJhCNPsehtKwOaS/jgN2sxzhkyie46e+kxrZoW5ZSwXeeooYxx2bFVLIonz3JP8IcWAHPP6x1sHl67OO9ad2+uXqcEGXA//slvFsjGfPSbfFOtrPEo+K71jxWrqGMRHT3zcm0760RtRrYK2fDmW8Wm26Ddl9u2nQLROHkAbFLWqEWQhnGTYWkL2Qx69XcjY5khPYn/xU4c59L8naaajp+5UDJscw234akjLluJD0lXcowIfkLCajUjlwhT8M+9hdmL0IP5lVQWROQJ6y8VzNLwKrjhxOD97e1HV8Anpw34qVL6Z73fOwBXGABzo27OsTbuZP8wm6nzWpv8YtJmFmspvB7Zr6i/4JPdoMfTAve4XNbk+KeNsnebzJCV3vUJGtw+1lIKUjIlVCD61H+dWpQ03PQaN7dXheG2Etmx2lo2hBiXd6dE56143qCtZVK1H0C6b/lNP/y3kAgjaPVaze3e48eEXpCZ5mBW6d6lqUUNEPW7YbdBr/E+KT9qDSwHDEKyksBg2Ed6IrWVssXkceDQLPK7VN6ssp1BsGPmaTZwmVcpIugmsT4zRrj93CZ5SfbKJnlr9iZzKAmV8OGP59qLcBcb7WZln+qjZONRbilb8+tdvQUhticCL3
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6+EymM48qMoi6AK6AuHPx1AC7VGhv9/XEcVd+GbOG3RhQFqkljVhuJzpYjRG?=
 =?us-ascii?Q?y9sYW+uHhsTORVnl6/Psz4Rn/YbJa3+FdR63hI/Ivrji3yzGrsqqJiVGTSDM?=
 =?us-ascii?Q?C8G8QITb8QT8zqS2SCvMaAY7Ubv0icGWtBxcihlqRQqElZ3kw+Vnf2Aj6ZpX?=
 =?us-ascii?Q?u5m3jYLgwsGeunwdkmVOLHNyK/bcQTtjRrRlXADFklH8N4FDkMpzzi4WZahl?=
 =?us-ascii?Q?fAXsBrjO3CFbu0Uij/pqywNFOXGTxEGzY+CyaasIvdKUSTwBaE56YM9y464P?=
 =?us-ascii?Q?ORogoO5OZWaqhRoLHFLsY/QMSL7UUF8dcihuSEpQpyz/csczv1Sust10cJTt?=
 =?us-ascii?Q?TpcYjU2JyqTNwnkWMnU4uYHrvldWiPbrPb6WSt44m9w+W35xIiPw5X/y5FyX?=
 =?us-ascii?Q?qhGfpWtqLrMPhBBSvT9D9yFoZhqzE7iK4giSIsVVkZirsT0DWCsi6k239Xoy?=
 =?us-ascii?Q?hP2udlnAti/HzBN3T6rA5tExD8vj9Il0V99utNfYwwTyv7rllLjRwengaDHQ?=
 =?us-ascii?Q?OZ2IGXsjuvKSdS9myMGniXz7HgD6sCK5F7PMY9FnPwBw2RbwdeKtpleAKaCn?=
 =?us-ascii?Q?dVlAKpVmS83XVA30GlB1SgxDpIPaWV/4LWo90RoOgfSr1hnnGb4zjsUhLDg0?=
 =?us-ascii?Q?3Phb4ODg5dmI8M3daZqliz+TghAIA51X2ML9TX+rSCbyo8eC6CTa2K3UqJ7z?=
 =?us-ascii?Q?FivJxeAY1SabDxPkgCi7puWs2ZqbXJRYB7lFnvQUA+X0mFuswCd+VxfTyD2y?=
 =?us-ascii?Q?rCI5JjowBsTvGMDFFbHguhEIb6vy7LRUDW01nOa5jwQ9OR4ZJrNAnnZnW8q6?=
 =?us-ascii?Q?RxIBgPLwQBdwhmTEq0gn8UT28n0ZLUv43XmjlvggCycV6vOs8xkZVsUuHppd?=
 =?us-ascii?Q?4IjdA4ps2MCDkXOsgxBFB8ZdFDoNaya8fkuwnwnzUz71EpBrsQ4u4hMHuWV8?=
 =?us-ascii?Q?XD077AbNEXtFpARYnIBzQ9c8EhwJ++73zNkO4ne3xkI0IC0/NqrfUnkfPGRd?=
 =?us-ascii?Q?w28ayEAR+HNM182kLXXTnriF2bDi/YclGr13rjubwkLYnhK2LrGelb3IMmTt?=
 =?us-ascii?Q?NubjOpouV5kDnGwXlDFEkZWDo/3HYldEK3h3Ua1cLEehBrShvX1H+Rb58a/6?=
 =?us-ascii?Q?etW6rgSWvqmr0mVYMyNskqs15/PPyMXaxmnLc38EamfW5tghDs8GHn1rr16y?=
 =?us-ascii?Q?PIKrHa+FGt4oqrTHbkNtqLc/EwTFP0qcMCCIIeB2Bmpgsf1zBvedaVI8TYEG?=
 =?us-ascii?Q?D/CM3rTSgw+iFEhZ/qy0riqrIBqIbVWr6CudhjIZ6x7fd6uQkXNU2TK2oF+4?=
 =?us-ascii?Q?S/WbZhQz5dhJb40c19rv0uxGoZjA+rQSke65miCAbitLhzlpxomcCzZclBr8?=
 =?us-ascii?Q?/Q0iw3BZWYRdp4NLoUbAY0f4Rx9ZOW5wDkPHOlvs22BvKGJCE6OaLacH5Alh?=
 =?us-ascii?Q?WIQqv/utQTx/DNIV3uGkiounPIqpocS/+sjSURs5F1W8vZ59XDnVc8iY6nh1?=
 =?us-ascii?Q?FQbvsK8zFB+uX57qxSbWQ+yyp6w4NzVl3JsdVT9w5Am3I4EhqozvKhdNEDsy?=
 =?us-ascii?Q?M/T2zLhiakoCyoKVb6/5U0WVzNDtLPPHccggXwnN13iOEnfZy4rVOgOn8meL?=
 =?us-ascii?Q?eNyLGQQEpjed37CL6p4FElAQT+FSy/algk9jzBxC/rDS/ZXnBjqDkx1pGCBE?=
 =?us-ascii?Q?H9Xmu3qWZgseKnObtD0GUfjAI+npLY652PwzDWQr4O4gnyIK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd83e7a-ffa3-4dd3-4122-08dead287f2f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 17:37:38.2643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gf0Sb29qr3eRaKRvHprksCXS4hk/M06TzsqGhDgF9JUnKk2xwhKPCAre/WDxQYA0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8078

On Fri, May 08, 2026 at 11:33:32AM +0000, Pranjal Shrivastava wrote:

> > -static int __arm_smmu_cmdq_issue_cmd(struct arm_smmu_device *smmu,
> > -				     struct arm_smmu_cmd *cmd,
> > -				     bool sync)
> > +static int arm_smmu_cmdq_issue_cmd_p(struct arm_smmu_device *smmu,
> > +				     struct arm_smmu_cmd *cmd, bool sync)
> 
> Nit: I'm not sure why we need to rename this? We can still define the 
> rest of the helpers like:

I made it have the same naming system as this:

> > +static void arm_smmu_cmdq_batch_add_cmd_p(struct arm_smmu_device *smmu,
> > +					  struct arm_smmu_cmdq_batch *cmds,
> > +					  struct arm_smmu_cmd *cmd)
> 
> Nit: Same here, why not  __arm_smmu_cmdq_batch_add_cmd? I understand
> that _p just means we'll aceept ptr.. but the name's kinda wonky.

Which becomes a fairly widly used public entry point, so I didn't want
to have the __

Though there is no external user of arm_smmu_cmdq_issue_cmd_p()

> >  static irqreturn_t arm_smmu_priq_thread(int irq, void *dev)
> > @@ -3464,7 +3405,7 @@ static void arm_smmu_inv_flush_iotlb_tag(struct arm_smmu_inv *inv)
> >  
> >  	cmd.opcode = inv->nsize_opcode;
> >  	arm_smmu_cmdq_build_cmd(&hw_cmd, &cmd);
> > -	arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, &hw_cmd);
> > +	arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, hw_cmd);
> 
> Nit: are we passing it by value here? This would be a 16-byte stack
> copy? As with the macro expansion this looks like:
> 
> {
> 	struct arm_smmu_cmd __cmd = hw_cmd; // <-- Redundant 16-byte copy
> 	arm_smmu_cmdq_issue_cmd_p(inv->smmu, &__cmd, true);
> }
> 
> Why not use arm_smmu_cmdq_issue_cmd_p(inv->smmu, &hw_cmd, true) ?
> Although, I see this is eventually cleaned up in Patch 9.

Because it is eventually cleaned up in patch 9 :) The point was not to
change this logic in this patch.

> > +static inline struct arm_smmu_cmd arm_smmu_make_cmd_cfgi_all(void)
> > +{
> > +	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_CFGI_ALL);
> > +
> > +	cmd.data[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
> 
> Maybe this is a good opportunity to define "31"? We already have a 
> similar definition for TLBI: #define CMDQ_TLBI_RANGE_NUM_MAX 31

I went with how the spec was written. The CMD_CFGI_ALL has its own section
with a direct encoding of 31 in that position, no field name.

While CMD_CFGI_STE_RANGE has the same op code and names that spot
"range" and it would be a NUM_MAX, we don't use STE_RANGE..

I'm inclined to leave it for someone who adds STE_RANGE..

Jason
