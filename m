Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69655181D1B;
	Tue, 14 May 2024 23:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715727780; cv=fail; b=TKgj+1/nME7SAIHFF9QBLHwhfkN9YJ788wfH6NA+Mw5rUBHHQrzor/UYR0UNU0W1o0yWXlS0DfGSkbYhjcllNqzED2ONCV7CKy1FZVQNHJ4MTYAG7jtFCRx7mJbc1bb1HHqjk9Rjut/N259p+BQMFJk0zynG7FZUjoQyPRq6Mdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715727780; c=relaxed/simple;
	bh=TFGX4iLB/b1sic0R2WL2TN/Gt7nRmiWSTZmw8YHMzA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fIdX/18hnJSu9XhuJDL9qSFQlX4+RecPyvPvgmJrLVRYhOe/M1hB4oQfCPhQkmJhZKA75bpHeoQ83Eqhta8cIr1N5vlZfRBgQWJn7xRpBJjUn1aZDAPNnFomhEtG8bqlkKXeHO0411XDv74M2hXX21dXXNc/EHJ6uwQDqRiZX40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EtbrC9ra; arc=fail smtp.client-ip=40.107.220.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EtbrC9ra"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LagwJq6wQFdhO8Bpt4tVrbIpTulkQBQG8Qle+q0hLLLWexdNBFsOmQlCoHcDZEr8zYfptfCYokBA0dLdvBZcsWkLXQimEw8DKDqWoroeljzvz2AAq2P4TPFn8TOhrCe2z5kapMvo2OAlaN/3zG7gkucbdgMCaBnnEnAq0PHvvWibZR+BPn1FoE+k/qpIZK4vb9bRuJ/VRpGLlkagblGqsPTHLMJpr+h518dNL3IJ/QKo64MmBocWofaMcWhA+YX//lsHbzlxwTJ9WT3Z3l8yaAjXCd0k5psBfAvugjvRjOtvsSKnPT2j+UvvuKHXUHhOt7ZmhNpdjF4XhfW27/WRhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XNzisoZjDk4AgvAPbKkBl8B9EVPn2TR87OJTJ11Gd3w=;
 b=FQ4ok2dweNovNiZYlxQz5dASMyiiBLJss999JBCkY/4m38H18JTUsXYOzttMFAbkyD7p4v5zPWY7KZh07caSOfgeFQ5L8IOYtMT0OIpt0WaLGAP+lUA3zlSzX11TG9WYjDrurrvuZZYXgAdubMTzsbrX/Uc4tPTAlZqqPNz8ZVol9HtMSYnywxer5c4d2pBCe0oi9yixFjW0ibkDFyvt6Mwq4Xd/R8VFB2gaQZRKXOns3LnuKYB+uxCXWsWVvFL0XAKWnBvDGV77F6q4XQd7/y8hmSWA3m7VTPo2QBD8lyQP+52pgpIB3M6FzTCpq3WfJGEib2z81RdEL2HioRC3mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNzisoZjDk4AgvAPbKkBl8B9EVPn2TR87OJTJ11Gd3w=;
 b=EtbrC9ramW2OpsHUqP49rgrTCr142VQvNYQKKGv27cyhIlBScxBom2R1qpnv7TObwrU0ubTKF59e3uGcoTUo6aLhoz9KbIkUCPIu10WmlDOv5kOvpBm9A71xcOniE/ANdWSch7A7raUpYT02ywMCWHJDZKdgWyOB3RiZImdu6Iph99DpZHtNfi64A94egIixWHVO78e4PPFhVwDLbgt4im2IqSqd8eTxple9L2rj3KgTd7g/bR2Yc+4+YhR2Cauc28Y57YL313LjJxo1gfwb4ER2gLvqWlrpdlwT9ruofHX+qbsZAd97C4uNLUxL4nUycqnzSiJZwB5zQeHAGlWqZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW3PR12MB4380.namprd12.prod.outlook.com (2603:10b6:303:5a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 23:02:56 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 23:02:54 +0000
Date: Tue, 14 May 2024 20:02:53 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 11/14] iommu/arm-smmu-v3: Allow IDENTITY/BLOCKED to be
 set while PASID is used
Message-ID: <ZkPtnTfup2snod+/@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <11-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <ZkG9INGfwNcnubyI@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkG9INGfwNcnubyI@nvidia.com>
X-ClientProxiedBy: BYAPR02CA0040.namprd02.prod.outlook.com
 (2603:10b6:a03:54::17) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW3PR12MB4380:EE_
X-MS-Office365-Filtering-Correlation-Id: 1aea8806-fbf3-4bd2-47ba-08dc7469fcec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sYdOrxfiH7fY+DxfjavgC68XZCn6ltrjGLcZarseh9Z5XP2YviyRHLRsPiLi?=
 =?us-ascii?Q?QlA1JjBAyHUOcVEek1dumY+GX0sZHhNXW45+8UAg+lkOPRK5TamiBPxprfu9?=
 =?us-ascii?Q?s1LC+ErUPBuNHdllS2TuiP8lKK/DM70AKEP04dqWnBqK1DT2nbGXr5nKC5YV?=
 =?us-ascii?Q?yFJYHLoRd30m+sEPPrebPJo2Le/zWN8KBOhIp/NPXsc9jq8vIDkDDRNmIZ1g?=
 =?us-ascii?Q?TGzY4xy7WDiW4Yb1MKrSMsTGLITxcahGWx4PvbTgDoh1R8/8cTHNcV3RPQcG?=
 =?us-ascii?Q?mjwGws31hHFTJNYRPJMTulBvdIZpMx+mr4toqqmkk7M+T8R//xCw2M32tU+C?=
 =?us-ascii?Q?ktoafq5gFrThc0OxSi/jmKazbOIkayjPvYKymGveLmD/tS+zH5RY6y+/zJu5?=
 =?us-ascii?Q?sqRLA/n82l6cvLNu+wdismOo7FiyjF4aGxa7hkLZfzr25tg37pOrnbOXR0E7?=
 =?us-ascii?Q?fcb/MOVFE+HZ2PGC49tJ/+YrscxTa5VZhQtQDJ442J5n+79uvU/QgMc6TXH2?=
 =?us-ascii?Q?idr1UmG8DvBKBbe6ZMc+MMTOF2JuntnE7/V5gvv7ltiYdeyIBpz5QDUfpQJu?=
 =?us-ascii?Q?/y+fkKe57rVvqkiqHMfGvufphRhsSdrC/5yXC8svQcjvah+uSETgjJsZbjpp?=
 =?us-ascii?Q?uocfbeT+7hs5S/0fXxz1sH+8/p8rya3HK4oCOOc+8AB9DfobItgo23BGo+QB?=
 =?us-ascii?Q?gvR1ABn5fGm4PqxRgJ4InZupdTBjD4pZYJdRSEbutHEyZhLcwGj3p0WsQX8E?=
 =?us-ascii?Q?rwTkCQt5ENetuZCEkpCjKrtl0XCm0vspcVQX8pMqmFY0fDxg1pd3eLrSTE4Y?=
 =?us-ascii?Q?VzO/+7egLsGrF1PFbzezq6C7bc3Daors2BzbTYAVmzGTrDDjnE5l/+1nQGf5?=
 =?us-ascii?Q?R5XYAzQ2J0ajg9tj13QoKnOhpv5iKQ+gGcsCdhsMQC36sC9PNHgVGLJtKwYI?=
 =?us-ascii?Q?fgXkK7rB4H7lc5OS3mDtMO/4JJdmH7IwRc98rSlGn+bJdYdXFrayF36x7Mmc?=
 =?us-ascii?Q?F7YjEuLDzqHbW2a/bSbtJ1oCnN8GI2PEwGpz25oLdt5pwpMmUE36orN9jRxn?=
 =?us-ascii?Q?9GoFwzPb0/ShTZ2jVlnpdMYPlwLlPWrH6METXM4RHGO9P49BlRo4kozXqQA5?=
 =?us-ascii?Q?w4FuIOkfpj4bsyKby2sKWP5yFyL3cKN0KXN1c5B0cPgT2hCdrHK8URYNJI5M?=
 =?us-ascii?Q?iiExoKvTlokeR/3CUxTE5dVFOW4AoMTQ0o+lga/8IBibJrY/871OlXs0TLBY?=
 =?us-ascii?Q?ohQ0qjo0Cf9xz1gcmFwAzU+GQ6mIWj+XSc3nx3mQdA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CYJ+whejiuVNqi1KPuXSaTvWlrDGWG0zcVou1+fFn0KzDLQPuWNHaCwslEB4?=
 =?us-ascii?Q?FK6KZA2qXeWIUlgfJDke4kN0ELtcs44OeTpNNC450HUCQW+rVQKLFa3/2PXX?=
 =?us-ascii?Q?flMLHXp35rDYEus6t+nBrdabDaDJnl4Go0zOnp2wy18ciVee4UEoy9/N271s?=
 =?us-ascii?Q?3R3fUbZs9pVi1cqSA7yN0IjZiQLAendBp0Ki9cWG7D6hl4FAAdrdP8OPwdMd?=
 =?us-ascii?Q?QgrvhCzPSEooDctOjV2zAs6ZK+XXhH7+JYpnW90qanhuFBrnqNYpQmEalKAB?=
 =?us-ascii?Q?Qff/jGjOXe2+b4CkYtLff69LlCVcJIOu/XZ6rBNXzMKoSUnt+co7JD6hE1Vo?=
 =?us-ascii?Q?BzJ8ubWXvJ3pNmqrDVlrjbqAgJYeejAwrRMg1joEvFj/5fagSfG/oxplbJid?=
 =?us-ascii?Q?6DdJTr8+zDFooufZZUFU5yTA+t0F1JxLlgt8l1vgfZ/a38ojgilA9I3dzQBg?=
 =?us-ascii?Q?/xIMQLV6KeguIlICfAOisHWejnAjsQhjrirQTC9OqK63lLrq/0wln6zIJRVe?=
 =?us-ascii?Q?adl6uJCbQjVAT88MeJFaF9IKORDt5uBKYg1hY+GVmXbvgAwjqMCLKAYxxflc?=
 =?us-ascii?Q?ynb143huCAiG2BQVZ+VLpNe8Zrw/gDkVUQJu4N0BQN4jXV4bqlU9yLF1qikl?=
 =?us-ascii?Q?EAWx+EtwaDLAoNL4asUohOzcL3eRbRKA8vDOXqi3tROb51QQIg0I7tOv2cmh?=
 =?us-ascii?Q?1LWPnzeqXfeolos1by2kr1OiBTEU2W0I/16EQUwa7mNRknvKp7UEeJIRjE4w?=
 =?us-ascii?Q?LzTsM6iks4OC6d6xS1ruG/vpG8S494N001OU+ShUZNqZ6dj/4mBx3GNnQxX5?=
 =?us-ascii?Q?B3w0avIzV0iMV3R1QBNYGCScQeIwps09WX0Sz1f68Mw9BM2Dbhukqef9Ui5v?=
 =?us-ascii?Q?XH7E6Q4epgCUjer3KoQ8Cxttft4rgtJnp3IsCb8kYu3A5rCN5Se3jHTfcijS?=
 =?us-ascii?Q?CNqyycuurioSBufniONOpQyLYyLq+/2t9ZDhQvrbxLur5YzQtw6Gb7K/n0K+?=
 =?us-ascii?Q?onQxkM0l7mqvY49Q6DHqvJdV35KgYA+4F4kT4ByA/9GUC7XkorcxTnhUWR+w?=
 =?us-ascii?Q?SLJdm93xxuRXIpp0gse1+FGI+66RETQnIGJ7kpyjdoTl+ptNPVgL7p6ZY76f?=
 =?us-ascii?Q?H+L6o8LwPJys/TAML2gcyalu7mGb/HH3th1/YJaNo/8X0QEB2dm22swpfUA8?=
 =?us-ascii?Q?csdeSW3QqxWKK+cFC1PJ61/IYQsMzZ+EAlkXUuQURvT8q25T5nRmFAYRi04I?=
 =?us-ascii?Q?g7ZcE0eo9Eu1U86Q/mXMFJ5hM1j3Nk/yVFziez9nUhM1BAahMebsDKG0YZSb?=
 =?us-ascii?Q?FhNkwmTkMB2Ws30RYZClL045UP2Si3kivJ8OOOQLul/vg965d45LqZ5WWc13?=
 =?us-ascii?Q?SgvKQQs1NxIHUS34NcA/KycbOjXH/Hw0/1y9Qpw2DdnlDaJOxr8uRPADYzoJ?=
 =?us-ascii?Q?ruwJ7ZHbXoH7KqbDKwVbACbIAKlvv+Lbmk06awee+8Ca9WAWhbhwm1B9RwQ8?=
 =?us-ascii?Q?ou0arCsKQeSbMSrbLBoW3pwa1d5l4n5V6ibsBWV+j9kBJEj+ju3OmvbXnRM2?=
 =?us-ascii?Q?ZVMUOsknOHVp5FkcMNo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aea8806-fbf3-4bd2-47ba-08dc7469fcec
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 23:02:54.4760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VZPKyu14d81Qwhi9KcFCdpiy346zDbKQ7y2oQ5Hf8AfX9EqcZtFpu25HuPglB4Uj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4380

On Mon, May 13, 2024 at 12:11:28AM -0700, Nicolin Chen wrote:
> On Wed, May 08, 2024 at 03:57:19PM -0300, Jason Gunthorpe wrote:
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index 15378c131a5bc7..41d7a0664a445d 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -991,6 +991,14 @@ void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
> >  				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW |
> >  				    STRTAB_STE_1_EATS);
> >  		used_bits[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
> > +
> > +		/*
> > +		 * See 13.5 Summary of attribute/permission configuration fields
> > +		 * for the SHCFG behavior.
> > +		 */
> > +		if (FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
> > +		    STRTAB_STE_1_S1DSS_BYPASS)
> > +			used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
> 
> Should we check ARM_SMMU_FEAT_ATTR_TYPES_OVR here as well? 

It isn't needed, this is just checking relationships, it is up to the
make functions to set the correct bits based on things like FEAT data.

> The SHCFG is RES0 when !ARM_SMMU_FEAT_ATTR_TYPES_OVR. So, the
> used_bits[1] doesn't need to include it in this case?

In the not-supported case then the bit will always be zero from all
make functions and so this will all do nothing.

Jason
