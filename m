Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011058.outbound.protection.outlook.com [40.93.194.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5F4503BE5;
	Mon,  7 Sep 2026 15:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788794595; cv=fail; b=HHdChhBdVydmj/vyPyDKROYRLT8rAdZc+1HGNMkkBST2Bl+viNDDvVSBjPW93bwpeh26q8rnixs/WfJs2SWhIujR2ISZ7fGJVU8nw/vdGzr/mmZN+/spoDrC0ovPtE+pC4u2nYNXjAeBA5WRBRasvB4ftYaAjI9z/oys6HF0REQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788794595; c=relaxed/simple;
	bh=avL1f48BTs3U7djXm3kicP5E3G+oXEjcBjikU1ZjYvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=puYhe/n5d+tggDeP64xtu1OxOAs/kEng/3wZ6dl5dszm5Bi/hf1aPjAJbc/o1s8Ctp5dJ9C1Y7j2WNOrWY0aSjkkRGLHQ34Bo5kIHVnedIUmRjl0XvY95uzQvB2vlCdSSPyjaosMRN4Scn/q9syzCOi1Ivj0XfQBunJ0Dj52UcA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FEkQbqFQ; arc=fail smtp.client-ip=40.93.194.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FEkQbqFQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UcBbnqkpCdAPVq629MfrU1Bq8kHkMDp23efUsscSB9Ovdcwjnn7zEU+VbafKVQLYzA9AYABdJVT79ThvrZIMkdNH09UbIKJU0C1yGHLa+raShcw0VH4hgQJcCvPQlpGpRSqym4POSLlA2KZ9ZkbzT/8WjdNTQ6yM2/b84pE38OboDqhmBbke7VZsdX5FgdEQeLdR+icdm9e9PmxNsJs2Yc3bJeBErypgVCfIWHAPDmNp7hT39IARusgaAuk7mUFkUn9I/d5aeSZvpwZic01HszD334JG4tYDq0MUHFBH701pxqGXDzel3Z8Cf/jUOrSuSY64iG5fXNdmrklECnkPkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G5p+JmnmUw6JLGXuwIdCfdQj1Ys6Q5WmrN6cT19ja/M=;
 b=LG+IrvaunZzabufzGbW8fViUehc3Ef2Aq7CTfrWRuRuMKxb+9UIfuqrRaEzo85iblmHB5KFJSSG7eAD2dvI+7xkI9qWt8bxuKLJerHt4PdZ3bW5JcSIJyw8ZnJ996xJN/VumuUEjxXXIGiNB29kdURir+HMB88eq4L7EprdbUjua0wPex8KyIJIrG/VXvyoT0uIdgF1dFVILb1j5aVWGaC1nys5ISZNveVZg6IERC43/QlyZ4styRrdTA9j9o2LQiitTE1SLl+2Nri0lfwdQNvc5ZgizanRKTijOiNjstIOKoiE1A7Vn/QjcYOSyCiUtiuHbpklJcblBC5FW8fQJvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5p+JmnmUw6JLGXuwIdCfdQj1Ys6Q5WmrN6cT19ja/M=;
 b=FEkQbqFQk6LylWzGrQ5CeywLhjxBZ7jkIyu1vxularZ8GipGzTWPtOQEP0o6dm/sJdvG/8CMl/De4KqpBiCJtO6YBtyO/YEH9lkSxvX/tBy6ny9hWE2NoyYACFZxLuZD19Z4b6beLc6kheQG+dl5h24xWBzFgugSm7kWU0x9F/0giGVNJH/kFFCL+9p+YpPqXX8Bz2Kja+3a69naHhLMY/eDwxZ4eGkC8uagVanhg8sDykojEFls+7O4nKgFAV0uf7yhPYtFPviycD0toSU92T3PwLS1FS6Gxq+KilWncyGAvKVwTBQXUA1DDxQQlZJe91GJGF4DzCDprTdpyBuiZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM4PR12MB6424.namprd12.prod.outlook.com (2603:10b6:8:be::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 15:23:06 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 15:23:06 +0000
Date: Mon, 7 Sep 2026 12:23:05 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v5 4/9] iommu/arm-smmu-v3: Optimize range invalidation
 for latency
Message-ID: <20260907152305.GA4157646@nvidia.com>
References: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <4-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <ap7JiB36YSQOaV9a@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap7JiB36YSQOaV9a@google.com>
X-ClientProxiedBy: YT4PR01CA0027.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM4PR12MB6424:EE_
X-MS-Office365-Filtering-Correlation-Id: 289a0583-b8a0-4052-c93c-08df0cf3ea90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|1800799024|376014|10067099003|22082099003|18002099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	zbZr2aBDFfW6Rye9aiMLKpILJ6CBYZAUkUYPcGWGrcMuVtpkCxt5T8uR7n2kX2gaNqKmZO17vzi86LdSFOCFCTkpGMGjUNz8FVqXhVdAyOxuB9lklMiRIPbGuUSLUx2iv+HV6Dmyiz4FHfMf47Pil8aRWoR86UbJExw69yoTLoN/7ZFHRor7Xv3HS+2m1OntE0c+WgE6sgxvrXVYUr2naFJacM/KZNUXBYaFAaLMScumkRK9JLlfjMx4yv1m/GCpcBDUdUmcXxyc0z1mtCbZCt6P7wNaEYOZ0ORQwb0FT223ziYpprXEJwyYpjTL6X/MROosgigvkp70MjE12/ULpHjzbhSovI75To5EXCvnx8HCnou/2Lf/p3dS4fZ+raiRfS2OmpSfJJMinZK+aJwOdNyBjnOftpJcTQHgrshSuzOVfRbosnL5y2DLXb0rMr/VIXd2TOX1LqNAf2JVN/FYqQRIw/hDuDzzFOo5ht19WHHwEqriHJggETUHCOKgGOeN0ki2Vl/s+Oyo//oQfVtkFKR0FjmuizkZNbyJxOaDQzqa1dNiJ/V9YaIiIs4Vo8lXvl86sJt/WIQYDN5U7Xi9PL67iLLCLS1ZjFZuMHuxyd7UBdP36WHj/Qw5WXk2kgrfaQoewXvgR5ZmH5zFnvXStF1niNifIV5Pnvb5o85sQM4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(1800799024)(376014)(10067099003)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jfURfVm2r46a71hgmidiavzQZD98KM1JYvJmbP3pds+4FAu2I3xwQaNgnxzJ?=
 =?us-ascii?Q?9XD5/e0wB71+5IVz/geS4+uXqzuz81BCyhhzhmhySh+UYH3FeO2jiLv49kxF?=
 =?us-ascii?Q?NyzfhcPuQJPlgoGNHvbj1rWDkQeGzPlajHWJNqG3HAuxbcOlU3F9hzk/WaUn?=
 =?us-ascii?Q?atsnZfGgWWxvxTjxGgMzj5D0aV0T5KqFJTrp1DL05t2xrlnCSoohVEgjFCzF?=
 =?us-ascii?Q?hBLyyoka43mmxo0Ns68rEcHNHvUVYD0ggKCmysB4021O2r8Ie2ZqbeK5NNUl?=
 =?us-ascii?Q?QN2VvWibtkeHizDB7z2kc2/KvRVAtP/29Yyu4d1Rfw8ErYljRke1kQiNqFNZ?=
 =?us-ascii?Q?XiNhuo2n6KIrSFlIZehmWADFGegADAxld7fYiNriF/zyRfCSc1On/uR9hLIb?=
 =?us-ascii?Q?i502kJKJJT8GR3dWU2PwN0t31FHP1WKtJtLzZe47fnithfVT56bHZrazDA7f?=
 =?us-ascii?Q?bR3HuN6uFi9sCgknK4CTRfa3BSiKXFd/61rG27l+kNx7Kr1OqXofDi83vWOj?=
 =?us-ascii?Q?RmzRZA05A7FiSLTifq2CnZOa3hPmrBvhcclYBvvj1hW0OaoIO8CeE5FuY6qc?=
 =?us-ascii?Q?mvCnaWFrMKyiz606CL8k3n1ly1Ls1ThT+GuW3mIEnsfPwxrtoCr0shCqwqgl?=
 =?us-ascii?Q?w4dk+VKAMxWH1UBNdqQtnZe4dajPvUm9eYPegmtJwMpi2wpbRubQgVKCdRXu?=
 =?us-ascii?Q?kuU1wN3U0cZoTm030qmufPCQEq+H9wJMfmYJj72zKz/SfkiCnO+88RLcMpXO?=
 =?us-ascii?Q?gsFxG9BhtmrS4J3t0AOP4R1ltPR4dPHVkKUXkwo28P5SSBWhzzkMEoxM6UCs?=
 =?us-ascii?Q?uixsNC2HU5gOXsWXv0fzoU+kjRrKOJfGLKvRqkUfDI250Jh84Xy1el/afN3B?=
 =?us-ascii?Q?hToJdmyOQNAReau1o2kO7wz+xS1LaNcv3ss/Uc5sBeA89tw6pjs4gKWn1IsF?=
 =?us-ascii?Q?NIUma0VuY1vInyZewqomFklDYVRUQkTgRj0AcxmQlfNRDuKtdfh5TgSK+NnC?=
 =?us-ascii?Q?z5ZrLcq5heCazEvImRQgVZsiGTCAHUVJYodcsE6lz23ArAjHEIQu68w0idfT?=
 =?us-ascii?Q?IOci4sksVlccHf8zf4B13kPjyxEniQintcNl2XH8NZplWNY2gVtnebaPlubO?=
 =?us-ascii?Q?2D2cIWDWLEhYa8e6UzZp3jMoBxCiwJ65u4cthmp9S7qkeX50uIs+QKcrVbny?=
 =?us-ascii?Q?5cZICuoVRtJ/hVsAQsw+MHRDBWfiQFgtm02uSVolhFF1aSv8hTjKQmI780Rp?=
 =?us-ascii?Q?TF+tQHH99N3br3x5bhE1iiEPsT/fI8GnoyUJjAA8uG0gUCDjMcAktZbtAQZh?=
 =?us-ascii?Q?B48lrvtwk2I9aEz0qaYdSglYP9Uyj2uxlV1KDBPUxa1cQUY9aMIALnoYhmc/?=
 =?us-ascii?Q?qW1XuN+3VbN65QNtTTPVLbedK7M2+5lcSogQbKpK1XAB6QegdFd/Vuvy+sZ2?=
 =?us-ascii?Q?ZoLE22RtzaHOtQUYU2/NRqfFbq1hp3MveKdw+r2a1OnjGNVokG2goN053PSY?=
 =?us-ascii?Q?uNmGfD2VjfiPf4aCa0MfFzDzlhLkL1Yu9zKV9eFroeqp1wRyFH3+ndNYZjOJ?=
 =?us-ascii?Q?OzHwu4KBrf251ja4LKSUsHLLRnGudiJmjKCKEb5fo8PpEVeznf+xBLOeHJ7e?=
 =?us-ascii?Q?aW1CWK5T5AP0rdLWpDcjYHoa46KRGkkigF8j63HxArzeFVDZDbjoa1EwqVVA?=
 =?us-ascii?Q?w42QtoEvD8h79vBNzMCH2pvUiU9Ez/Z11MZ+A0JjG08d5os8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 289a0583-b8a0-4052-c93c-08df0cf3ea90
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 15:23:06.3454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AksQNp8H/nC4GgyBGCfOJiIg3cOeklfXxbYMBnJ5dBm7rlB0cJLdu6WASlE8/vZB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6424

On Mon, Sep 07, 2026 at 02:26:16PM +0000, Mostafa Saleh wrote:

> > +static void arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
> > +					struct arm_smmu_cmdq_batch *cmds,
> > +					struct arm_smmu_cmd *ref_cmd,
> > +					bool leaf_only,
> > +					const struct arm_smmu_ril_range *ril,
> > +					u8 ttl, u8 tg_enc)
> > +{
> > +	struct arm_smmu_cmd cmd;
> > +	unsigned int tgsz_lg2 = tg_enc * 2 + 10;
> > +	u64 iova = ril->start_tg << tgsz_lg2;
> > +	unsigned int num = ril->num - 1;
> > +
> > +	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
> > +	if (WARN_ON(tgsz_lg2 == 14 && ttl == 1))
> > +		ttl = 0;
> > +
> > +	/* Verify address alignment for the TTL hint */
> > +	if (ttl && !arm_smmu_ttl_addr_aligned(iova, tgsz_lg2, ttl))
> > +		ttl = 0;
> 
> Is that a separate fix? Can this be a separate patch in that case.

I don't know if it is because:

> Also, in what cases can this happen? io-pgtable-arm should do the
> right thing and SVA will use ttl=0

This is more getting things setup right for iommupt in the next series
which creates every imaginable kind of gather.

> > -			/* Determine how many chunks of 2^scale size we have */
> > -			num = (num_pages >> scale) & CMDQ_TLBI_RANGE_NUM_MAX;
> > -
> > -			/* Keep the pre-DS 5-bit truncation when scale > 31 */
> > -			cmd->data[0] = orig_data0 |
> > -				FIELD_PREP(CMDQ_TLBI_0_NUM, num - 1) |
> > -				FIELD_PREP(CMDQ_TLBI_0_SCALE, scale & 0x1f);
> 
> That just deletes the DS code which was recently merged.
> I see that is added again in the last patch, but it would make more
> sense to do it in the same patch I guess.

I missed it when rebasing, I'll adjust it

Thanks,
Jason
