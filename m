Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012006.outbound.protection.outlook.com [40.93.195.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2D9377AB3;
	Mon, 28 Sep 2026 18:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790619088; cv=fail; b=HtFAR56HTRDTDqCRts0OcX+EqSdiATz+yWV31m2nzJYCMq1lX84gE4V6pp6pq+j4wx22UH2D29wX/tVIIT4I4XNAgMuT2Dev6oQZN4yPyRKvmCdhJr69Jr0lIWTfpociSuPMgitJUOZRJQUF/5I2jhx6acWgaLjlJuZKjZvZ8rE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790619088; c=relaxed/simple;
	bh=ImjmWAVHW6MHdQU2qyqZteIz8VIc3T1+LFV+oIUe/Mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iGTZk6S097sRf8JFI0QumivUBFsViorfuuqeeLoDnu9V8hWcwOw8yOa03Kax54SHFImW4MzreavgMeBhfoLDLNnRG26n9x8Q4r4QX0tnYCD9gacYkpHuvurJW/bs6BL+xz5TEloc+9bU/PrdK1IBD2NsKAo3m6FjBQQhZdMC+gM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cu61d4/a; arc=fail smtp.client-ip=40.93.195.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cu61d4/a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OHVQ1BeGKuMJXyQKYCUk68UOqQEr9nieI4iT//QHwbF3eOP1GrxaTSeYeLSiOSdLTPmT+XrnjFUue5+EL70s5gCs4spt8qPFqg/OSqWm6JgCrPfO2XemxK16ard/Gt+Lmcqg4o5DovuKZ5rkZ7CiWziZvJ+VA2dTZK1Hk0hGk1G+gUAimVGbMNEBZCnb43B6+WLOddYq9h01zlN3cCd+whnEdR78jyhoMSIsYiMQzghcKC/SFNx6EQkjZ4h7pczvicI0Y9pE7UxGxZUrhvWyFmKTVIzRUfqCegjFyU+WPBOXiPFiAuXdXZO+u42QkeHZB+YzgUYM4v6ZrnfLpqUHLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+34UDese1VPEF+U+t28TUTT0C7e9+onU8ESsyc+3UiM=;
 b=sESdUcBvXKalhV9YSvdGIshthn0LbpWBkUkDjbEbQx6My2k6muDsSfMvD8Y59P4+h3bkCbviD3QFeKzbveZydT7ZRnM+3VZ83NagM5viXSFs7mYWZoJQx4PcvrdeYVeTmkwxDPAFC/zpY4w3O457RGpWVfe0Octvw5ktKxXsDvHwwj4OH4XTjTuWDQusMi6mWIymS1eH0WzlUI1EwGVPsSCtTf7nU6aXv1c9xUkjHKKV/iCT4m5rjCrqrTOhwVXE93ceji27DO8I+F4bPf1X1Qa7fIB7Hw06vl3RX/2KOrr1Pa7jHuHCUKtzUwol0HRk0wNlmRnmRnPgCRmaeNTz2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+34UDese1VPEF+U+t28TUTT0C7e9+onU8ESsyc+3UiM=;
 b=cu61d4/at9GOQIKLr4fIAbxRDEENe4eqFZ6Zn3e7UoOJp5AZI0dJ7IOmOzjjaRC+EZuy0IlwojN3J1ckFmVsCx+eLpV/PNNVY1oI55d8ITflDKUEDnijgY0iDWbk8/z1vuXSeM+djWeBli7Is8lzCnpFsj+3Do4BlhktSYESV5xMXHWDgBtSDsZ6a7EksjlExsPOEVlgdqnaG9Y4q4alDsbd39x7ebzvHWH98Mj06JKlSjpZH18TVI7WCEliBLG5ik6EoJTdzwIcTqoRMtNgjQ7bowMEmosIJxmrdfxF0x6L7aS7nZQpB4KaF7smPQnNp1kvKoToc+aJnM5P56B44w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by MW6PR12MB9020.namprd12.prod.outlook.com
 (2603:10b6:303:240::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Mon, 28 Sep
 2026 18:11:23 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 18:11:23 +0000
Date: Mon, 28 Sep 2026 15:11:21 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pranjal Shrivastava <praan@google.com>
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
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v7 7/9] iommu/arm-smmu-v3: Populate the tlbi at the top
 of the call chain
Message-ID: <20260928181121.GC1616761@nvidia.com>
References: <0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
 <7-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
 <arqeWXL1jhz9R9-j@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arqeWXL1jhz9R9-j@google.com>
X-ClientProxiedBy: CH2PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:610:4c::13) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|MW6PR12MB9020:EE_
X-MS-Office365-Filtering-Correlation-Id: b67ab8d9-fa1b-46cb-9f86-08df1d8be77e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|366016|376014|1800799024|18002099003|22082099003|4143699003|56012099006|10067099003|11063799006|3023799007;
X-Microsoft-Antispam-Message-Info:
	h5ijiz0OdOL40XI0Aqnopg8SBAx4MpedbuM0wOX6dcQ2MF1c+Z5OSjXgtBylu/Z6lPJFntIJE2hTVpPI9XUOlY0/Q9Zo0j/3oyoJ17XiS0+2GzpE7aLgdaH31nZRCNKIHLE+k8BW8gw/5Z7yqXQhIFH/4ru0IW1CGMBs5T58kry4tEM44hWOdoYJgMmjW7JCB56kR+PuBr1mYBfTFWIB4q3o/fgEN+oHo4vFFqMBPwIhUtsxWWcnoaQ/8V7S5S+iDfcb8LXveD+X1+c8p0H67PWJdDIVF+h+Os1ybfmIR9g7JwLgaS2W9KxjxcPvEjVSh6Jm8/0QJx1R+H0U4N4eEyETTkyZz3/KpqPb2EgUpQ6T5AVuyiHXgNNKLYKarc8dMonnxr4UVkh1rjQCUnOQleD3IdFiuoWnR9ekGC5hW5yfdEBY5cLZmTLcILdAhCQLHoPZyYsoHN3+IUkFFttcqQy6oFphmllgOoGEwdCCTqHaywi9VL/DTCTlKGockGJY433OU55UiOHN4I8FsA9q/wOdEpszGL2C9YS0RThrRODTPw1Bf2vU7RHjpkIJspk3tTyLBblEm2isYXcUwyR/ey4FVtVe/aAzyz/XiquYu4Wg8344Fs7TYOIBQ5Zgug6EPO8CMVsSmFHhCFjp99RRl2zXZuKjvAo2dIu6U7hwHgA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(366016)(376014)(1800799024)(18002099003)(22082099003)(4143699003)(56012099006)(10067099003)(11063799006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yLq+9PTtTtVoe+zGvQT+y4PI7qImaLvUqtPITCYSNnpIzIo1yrnXOhl93ATh?=
 =?us-ascii?Q?hKzOLX7x+gz7hN8ffWRzeMzCbuEhBE/XfL0z1wIa02abz5IzkfUh3zwBhfYJ?=
 =?us-ascii?Q?SjKEIXXLJtujV+XWwm6zRpK9QETuRQJYtJmmg587joPGXfyGURbDVuR6EhSS?=
 =?us-ascii?Q?aA/gL8ZTboSAiOwS0wtbIwFeM72aAv8A303Ou7s/zv9gFV7OS7gFyZyjfTnq?=
 =?us-ascii?Q?sCtrOfItuu2Bpk3Ebh6czc/tz1PDwHprx+fNXM+5TpJ8iIHRVlnL5wiYuG+z?=
 =?us-ascii?Q?f88IvqFNnas4APrEp0P7YbZ0xYk2ZkoieSzrvdk1sfbQ8U1nhvFDthDw5bd9?=
 =?us-ascii?Q?hyTmCwJ19p/+tluByl2cxzTYpzzVhIgss+5PBJzZO/CMoxasYXO6W8o9DqwU?=
 =?us-ascii?Q?QGuaODjtuKi9I8roxf1RjYWjl6Ux22OM7TFbDbIOayHoyCs/jz4vZVU5qD/o?=
 =?us-ascii?Q?wgDOipppms9V87maliBsu/+Dvd75LHX851aw5g6nQqHO2afITQGbyfjfpKJ1?=
 =?us-ascii?Q?+HKzZe56KSzDn3EnXhctk4AVfmIXX/qFzb9cRs5lLqoIhBxDNR4gZ93pZtbQ?=
 =?us-ascii?Q?Eyg5pPjquHO8eAyqmAY4be1m5BS57uF8eLX1//jiaLLhlzYbuYUybTInEOIZ?=
 =?us-ascii?Q?G0I7JgnTKvwoMeVCuz0+RvILg6n0+iJV2bG1YXu7aL3Cj+nJI7+RZVx93upr?=
 =?us-ascii?Q?MERCOzqCFPocytQYVu69AoZh1RQPDt7cCIBK2YzQgjlufpZuf9nBGeyN+1RJ?=
 =?us-ascii?Q?DzRRBEagH3dO1ABmfKCZ4YUIGDFirBTXan3Tpn6Nu8lARHiCWQNysEBgH1Kw?=
 =?us-ascii?Q?O+7L7Rag0zKLJ3U7vMBaVcajT23OCCtmk0dxW2MTvOxl4S3VMugcVofeawT7?=
 =?us-ascii?Q?QbXa8pgLhHDhZZe2+N/DVKeJWsgLq9Q5LLY2mwvrtaHuacJJwDXSt99ETvTY?=
 =?us-ascii?Q?8WkrldEddTx3z3iEr0DqjHgxvOypc2VgdfyOMDkfdCAMAZDP2dM3Z3lTZYiv?=
 =?us-ascii?Q?qldePh1KmkDZtdaL4Hbq+NNHlp2s0/iCgg65Qtf+MtzwnU6O29Z1mgp0Zyej?=
 =?us-ascii?Q?pHV2aOB59Pswt4vpRoVUd8f1hpHL7ooANtZkxTmJeu51nfx7Q0SJy2uXsTAV?=
 =?us-ascii?Q?tphg2ZqYtRxYdQLJUKdxg8RgA1xpjVCR98wHdUBMQ66h8Bc0iictgaKEr14M?=
 =?us-ascii?Q?RNMn7GnL24HIKnBniXQXD6gJ1SV64AcGH8iJSaw62k8RvVHzfsCfq2DMWO4q?=
 =?us-ascii?Q?GY2bnt/6uYM0fBKQqf7fuwkUA8UAZhWCLkNqPiYNzmhaclhoM/DGA+oHLkvt?=
 =?us-ascii?Q?7rXHSnIaPqELpoLTSFoN/+J26nErvbTc7nu+Jt3zYbV20I2FaCokIG/Z1x9U?=
 =?us-ascii?Q?9D5p2nUDgX1Jw7DBK/HO3luFN9VeVPdEOU5eV97gZdMt6Bk/EPa0YwCrIjjk?=
 =?us-ascii?Q?p3RgHfDdQEPGsDY9ciXUIfUHqmdMG93uoNHUwBz6JpN/OYfkjGklfzXAnT9k?=
 =?us-ascii?Q?9rBaDgEMWfYL6FkeXkjGFo/ttmn6ao/6+EFUYk1DHz6DIfyAcGc+x0YtDEuG?=
 =?us-ascii?Q?UA6jnPyu/XHwtwNtVkBjphzGbdXM1NS14T7oyijgoNxzw2l9DPvanHPPujl1?=
 =?us-ascii?Q?Bzga1aYB8MfJRn32Bhu09kPMlNoK82ELcZ2ORDsqUW+o0/bnR91JTGgoyVD4?=
 =?us-ascii?Q?KHSjQQGKBX28SKrS6nDtoszTuejlHcHuhWpRs+maHfZ+BFt7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b67ab8d9-fa1b-46cb-9f86-08df1d8be77e
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 18:11:23.2296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z7pWDb3v1oRg7pwP2WT/jNS67EyjeFWEaJBHLacD/0EYxjy6DWag2iDfkmRqo+7y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB9020

On Mon, Sep 28, 2026 at 05:05:29PM +0000, Pranjal Shrivastava wrote:
> > -void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
> > -			       unsigned long iova, size_t size,
> > -			       unsigned int granule, bool leaf)
> > +void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
> > +			  struct arm_smmu_domain *smmu_domain)
> 
> A caller re-using the tlbi would overflow the 2-entry range.cmds[], since
> num_cmds is never reset or checked. Should we sanity check num_cmds here?

That isn't the API protocol, once the tlbi goes into
arm_smmu_domain_tlbi() it is consumed and must not be used
again. Everything follows this. It is sort of a micro optimization as
we end up with one pointer in the callchain under here that gets all
the information.

I can add a little comment:

/*
 * Perform the invalidation with the parameters described by tlbi on everything
 * caching for smmu_domain. tlbi is an on-stack structure that contains both the
 * input description and working memory for this function it must be discarded
 * after this returns.
 */
void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
			  struct arm_smmu_domain *smmu_domain)
{

Thanks,
Jason
