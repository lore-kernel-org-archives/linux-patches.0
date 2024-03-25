Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBB3129E77;
	Mon, 25 Mar 2024 14:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711375899; cv=fail; b=hr1o2XWg55SXPTW5JGg4pYSKWXsMRwe7OnER4oUxD3Dit7MDKT7CBUbwsSoydNXrMZm4YY6CFNYIa86ET2lnEsYIyoxY/WL1vHlhdLJHiukv0pyf/1m+vVWCFsNrjCGMbAFBB//MzVhdNAQAfpCRdSuvwcnCCd0YgZS5UOrfhDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711375899; c=relaxed/simple;
	bh=biVgfJl4B04691XEWULCh5QtdyeGke1YZ5E6o3kfDSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rpkj53a5sn2DaNULqJPOFTVjY+sNOgD+2h8Y2ZSxUZja9EWzHBRIf4IoPGjnujEOE3w7GryKiQMGWFGNYdbm8ekVsMaf1R8hFaUhgMCvy7w/MyE69bvhWB4660XdT86cEIL4ZNX+RVsfq56VTlz7UwjDhs4vXQ9pU1Cu6smI3c4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ANiC6y+a; arc=fail smtp.client-ip=40.107.243.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ANiC6y+a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2vQF0uJBhr8rAEav2o7Q1jf+y9KVa/nQVBnrLAkRB+9Knn0xHHYo4rdJqK7GB0VKugzBe5vFi7ABlvwwX8TaQAa4/kATeiAC+NDNHb7R768GDeEMj9zO4pmuzv0W73YGfsAT98NZHJzq19AbuJUgxfss1wZ9yg0PeKTd3egGgy6E/q0LNmW5jAry0r9WEGN5egNQcJt8wi+56c4zmVlV24bx4caOdXK0DnntQVxUXMgT8jJ5Ka9bz+iWHh4h0mj1ubZPGV6wUOKaP8x82EoOXwquY9y6Ed5P/YhLOGIEEBpNpr7WwtEogJdMs3rS/XDhKzIEI5MIpZ1fZaoimgDKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XLH1MYFzCpFtY1aE34Omq+0KpcMjErLwH9sx0rPJaBk=;
 b=YI367D/KS1MKRPfcWeFWo6t5n7S3nPcxzG36Rx70tvyNHpzqzvR+q+MWD/cE82CmA80Tcbq0iNVzP3IKR/lmExoFLc0WmXA1PAT5FCRn7grnhpd2jzZQn5XjElVvjvLaA+gC1edHIZ7+UDC7AHUAbvkEDZu4UgdXnohdAQrALFl+zF9uaof6itRht2iRo1ENTczOii//eB8nfslgZ8eAUODlvnko9/iil2ezDFtJzCQba1P/KgsU/CSc4atf2bPhu+DmLGQaR5Sr+J66Y4aNCEzlVJpqg/cqrrck1MI6iA7yb9aj5dKkh9IRddd9jrl6uB13G0Pi2hhHfvvdlfe4zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLH1MYFzCpFtY1aE34Omq+0KpcMjErLwH9sx0rPJaBk=;
 b=ANiC6y+a/mPKgpXA9xYIYirpcV6SWQT1hOX5UtJM1Dgh19Y2LYAcQnRzWFb6JNICcJFIzarR8G1WUPd5+Df7E6Mur7okmvaPjzCnvBsepdoHmH6GbfBnBtCMC39EXZFum3xe2i0XQQCOTCWc5PayUUCGonX7fI3gq16JCnwgx6vfRl1X8+o1gUrKSXpBqbuIasSRSnGbJ39PJ7I+/KyU+OxmDRuljPV8O3N5GnCy3/IOz8fVxi7TmgNPVnxQcYLqZ33MrGSJdzBxxuSC2JZjYBE1HDCNxg4TACFJwphhFSIoe+DTOte1QszKq+9tn0ZXddRKRuMB05LUJTIHV/8dpQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SJ1PR12MB6340.namprd12.prod.outlook.com (2603:10b6:a03:453::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 14:11:33 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 14:11:33 +0000
Date: Mon, 25 Mar 2024 11:11:32 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 04/27] iommu/arm-smmu-v3: Add an ops indirection to
 the STE code
Message-ID: <20240325141132.GA110546@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <4-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zf3KgGj4Tfc8ytgi@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zf3KgGj4Tfc8ytgi@google.com>
X-ClientProxiedBy: BL1PR13CA0168.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::23) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SJ1PR12MB6340:EE_
X-MS-Office365-Filtering-Correlation-Id: fdfff8c0-0667-4af6-d266-08dc4cd5798d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XEtVfoaTQNEVXF1EYGiO0Q8rdj6frkqLJFDPqj/2PMxBTCa40eAjYSKOuKUpUJIKav7BIoawCg0B+y/BPC01Cy8ssuCkzA3ilCh0mzaK739/HcVNkjW8GA+prWLs6ZfHZNM9Z0RxFCLrh71OKQAY1Magq4bKemQgipt076Buwh0071eWCVw2QlH2rBcibdw8tAtKbPhfoBiigfP1ntCnCtS6G0XDRfCC9JkIPlzsdUaYZalw0ZlbHpZGza5LOHQJjtdfYzfGrqonTitQprCJnYQp35mLOeLSaybLdwFPVehJg5q+G24gVOB0L4wJewAUlm943X5GvclVbmbnELUU7sPOsEJjzNUph6zxM2WWFK4TlWSJTErgLA3juJZkJ4lYSmJnUWGvmyR8/I09+2P94JpVbwLrB/VYdkp4lafq0POeZggDpgjdbGD9bMZ/vZ1DArFf19k5nlj884pYy9emALvFTDreMOCUr1y0D+NTVA8mgi7NNEWXGgYldHeHhWokphF/I6ofR1NqYztv6RYT+gU8lCbkTvGnN1TVF5nZX1qcR1TckIcdRe8LzxBNr3seF37G7KLUjaCDk9O4uUXEZq6VsHFI23l3SLwP6ouqvdDe6JGSzhgJ+oHel2IXOMlvSvNIktCMBkkMJgLM58eP9lFJyTfeLmWa36HwLay5H00=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZjdEZUNkWFFBd3Z3WGlRWmZaQ01rU1ErMlUwdUZuVUhjZTYzb0QvR0tWMWZn?=
 =?utf-8?B?OCt5eTR4MzBYZGZLNi9xU1dXeDNNU2w2MTNlV0p1ekk5V2tIK1hXbm9kU3ZZ?=
 =?utf-8?B?bVEzOERJdjcrbk5hTHliemZ0NUdOQ2RFdHhIY3BPTUR3a09FL3laV3J1VnI5?=
 =?utf-8?B?QzRubi9Fd0prS0dRUUd0TERFYThxNXVrNmlkekpKaGpkdHJ3b1FjMU4rOXA2?=
 =?utf-8?B?TGRVVklZdW5NQnk1VTAvcThMMzNsbTBBb2V5NVJJRk9FQUJWelNoTW1iWEU2?=
 =?utf-8?B?QlFSOHZmeVRKa2pwUW1jcTNJMzhxUXI1d0N4SHBEb0lWWW5JWTVmeFhvZ1BS?=
 =?utf-8?B?MUk1TWh3OFZxejI2bDVzZFp5YXNtS2luTEt1QXAvQi9PR1piZEJYY3pFbVF4?=
 =?utf-8?B?cVAyZVFRSWo0Z2RaZmljNzFKaERHVXR1SmR1T0grRUVsUU1saGljTjFnbmR3?=
 =?utf-8?B?QjFlRGhFQkZ4Q2VJUmdabVQ3bVlxRnFnY2RhRGlEQ1B4cUlqUmlEaCtJeTVp?=
 =?utf-8?B?WFkxTkJpZ0hBZ2JxTnRmU0lENS8zYlZjdm1NaUJUUGlGbVY5MGE1R2R6Mjlv?=
 =?utf-8?B?amJLVytBd3RybEVRZU12Qll2dE1pUERxTDkxRHFrRFZSZGhvZ2EzYkJZRnZr?=
 =?utf-8?B?UkxZVjlNRUFXNHhteXhPS0Y5YTBkMmFON0JCOU16NFFIbzJRbHFEQUtqanI2?=
 =?utf-8?B?dzlIa1NFYVU2MVJiOUdSNHM3SStnYURjcVdjbEZXS0kxYVJzdmt4a3h2ZStI?=
 =?utf-8?B?ZVM0RG96cy90Vkl6Um9yWlZLTDdjMWhXSXRSVThJTG0wU1pGN3FkVkxEU0N2?=
 =?utf-8?B?aTZlb2Z4cTZGSXI5YW5mVHdGOEhiV09yZVF4K3JONWNGaURMQ2daMEJHS3Jl?=
 =?utf-8?B?S0IydERQVVhBMWo0L3oxSUxFWjhSRGJMb1l3WjlqcDF4ZnZkRzlLY1ZIZjQ2?=
 =?utf-8?B?WTliWnpuZEpZUmpkNytBTUtYekc4cnVaUGtFZHowTWJhbDdzSTVYMFVDcXRH?=
 =?utf-8?B?c0E0TWVYZFhZOUp4LzU0NGdOcWYrMjAwbXJ4c1l2STNDdUQxM0J3NUd4Snpa?=
 =?utf-8?B?M0oxdmwwS05xdHY1Q2laUGpGbCtzLzJQeDJIdmZ3SUhhOU5ZeTBPZGIxTlZX?=
 =?utf-8?B?ZDFLcmRXWXhHd1FIamplUDY1YkJ5SjBpYlRLOUNRZlhtb3ZZU0o5MFlHY0dH?=
 =?utf-8?B?SDlaT1BCL3IxekJwZ21JQ2Vuc2Ztd0ZWNEljeGczSjVWVnM2SUM3cUZXOHBJ?=
 =?utf-8?B?bnpHcXZRbkRtLzJjVmRZNGMxQVFKTk1CRzdZZUJMNEExTDlIVzVFR3FmQ0Uv?=
 =?utf-8?B?K2xpMEhteXIwTnAvTXFsMG5PTWFyd0s0alVZbmJzdHpHU2EzN1UvNEY0WEJB?=
 =?utf-8?B?WTZhWGxHRVpaWkZ2R3paMDFGY2EvSGFEVGxUL2ZnYllRejZqc0krZVdVNzBi?=
 =?utf-8?B?Y3dzblVnaFVxRjE4VEtldkZlUmZVTkllT1U2MExkRCtLckJyWm9kU0k4Y2Jk?=
 =?utf-8?B?Nk1DaCtCeitLd0k5YTBOdmRoKzZvYmQvTStNOVg0OTY1eHBLMzZ2RlUxcUtM?=
 =?utf-8?B?VUpJd2xiaEVBUEFnanFjb1M2R3NOV05IZ3h1aFJrTFprUWc1dDNKZWkrT2Qw?=
 =?utf-8?B?UUU1dzNoSU5GRFlOTzRqa2tDNWRlUm1FNGF1RUlPTDNmbEgxT0E3MG50VVJH?=
 =?utf-8?B?cFJiMFU5eldPc0UzTENOMEhMcmluQm90azBtN3ZSNGtEQ0pHYkJ6OUNONVdu?=
 =?utf-8?B?bndDNy9pQ2w4czZkaGQ4TXQ4QURTK3JWUFp2UzNYZzNzdGJUSXZESEt5S2J0?=
 =?utf-8?B?eEF2aXU0SnV6alVGcFBoVk9wUFZ5TFdrS092SnpVOEJqRndNSldpZHlhZVNO?=
 =?utf-8?B?bDZxaW1Oc1ZrNys4bFBPeTlqTUs4VUNhcmVkZ1hyUVdoak9tZWk0OStPZ2gw?=
 =?utf-8?B?WEpSMXYwWUdBWVcvN3lsNndEN0piNFBuRnVxZVZBZDFYNFFGemx3WVF2UHIv?=
 =?utf-8?B?RXJQckcyb0dudjJEcU9JdDlWbTZXNEF5UW9OSXJwMDBuc05Xb0JsSm1UeXlD?=
 =?utf-8?B?ektWZ1JwY29UZ3ZNQ3cxSUhGUW15NVd6bG5xVUZ3dVZZSUswT3d3am1aM3ll?=
 =?utf-8?Q?+VUjirkwWIf0uyWDHl0AxGvPm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdfff8c0-0667-4af6-d266-08dc4cd5798d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 14:11:33.2083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G6pzijwqlqAVZOv6B+kW1+0ISbwR9Ya87V9ECc+OooP61iK0AUZfxXWoZtx1nsna
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6340

On Fri, Mar 22, 2024 at 06:14:24PM +0000, Mostafa Saleh wrote:
> > @@ -1027,57 +1038,55 @@ static void arm_smmu_get_ste_used(const struct arm_smmu_ste *ent,
> >   * unused_update is an intermediate value of entry that has unused bits set to
> >   * their new values.
> >   */
> > -static u8 arm_smmu_entry_qword_diff(const struct arm_smmu_ste *entry,
> > -				    const struct arm_smmu_ste *target,
> > -				    struct arm_smmu_ste *unused_update)
> > +static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
> > +				    const __le64 *entry, const __le64 *target,
> > +				    __le64 *unused_update)
> >  {
> > -	struct arm_smmu_ste target_used = {};
> > -	struct arm_smmu_ste cur_used = {};
> > +	__le64 target_used[NUM_ENTRY_QWORDS] = {};
> > +	__le64 cur_used[NUM_ENTRY_QWORDS] = {};
> This is confusing to me, the function was modified to be generic, so its has
> args are __le64 * instead of struct arm_smmu_ste *.

Right

> But NUM_ENTRY_QWORDS is defined as “(sizeof(struct arm_smmu_ste) / sizeof(u64))”
> and in the same function writer->ops->num_entry_qwords is used
> nterchangeably,

Right

> I understand that this not a constant and the compiler would complain.
> But since for any other num_entry_qwords larger than NUM_ENTRY_QWORDS it fails,
> and we know STEs and CDs both have the same size, we simplify the code and make
> it a constant everywhere.

So you say to get rid of num_entry_qwords and just use the constant?

> I see in the next patch, that this is redefined to be the max between STE and
> CD, but again, this hardware and it never changes, so my opinion is to simplify
> the code, as there is no need to generalize this part.

Yes, we need a constant.

It would look like this, it is a little bit simpler:

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a54062faccde38..d015f41900d802 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -63,9 +63,9 @@ enum arm_smmu_msi_index {
 	ARM_SMMU_MAX_MSIS,
 };
 
-#define NUM_ENTRY_QWORDS                                                \
-	(max(sizeof(struct arm_smmu_ste), sizeof(struct arm_smmu_cd)) / \
-	 sizeof(u64))
+#define NUM_ENTRY_QWORDS 8
+static_assert(sizeof(struct arm_smmu_ste) == NUM_ENTRY_QWORDS * sizeof(u64));
+static_assert(sizeof(struct arm_smmu_cd) == NUM_ENTRY_QWORDS * sizeof(u64));
 
 static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
 	[EVTQ_MSI_INDEX] = {
@@ -1045,7 +1045,7 @@ static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
 	writer->ops->get_used(entry, cur_used);
 	writer->ops->get_used(target, target_used);
 
-	for (i = 0; i != writer->ops->num_entry_qwords; i++) {
+	for (i = 0; i != NUM_ENTRY_QWORDS; i++) {
 		/*
 		 * Check that masks are up to date, the make functions are not
 		 * allowed to set a bit to 1 if the used function doesn't say it
@@ -1114,7 +1114,6 @@ static bool entry_set(struct arm_smmu_entry_writer *writer, __le64 *entry,
 void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *entry,
 			  const __le64 *target)
 {
-	unsigned int num_entry_qwords = writer->ops->num_entry_qwords;
 	__le64 unused_update[NUM_ENTRY_QWORDS];
 	u8 used_qword_diff;
 
@@ -1137,9 +1136,9 @@ void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *entry,
 		 */
 		unused_update[critical_qword_index] =
 			entry[critical_qword_index];
-		entry_set(writer, entry, unused_update, 0, num_entry_qwords);
+		entry_set(writer, entry, unused_update, 0, NUM_ENTRY_QWORDS);
 		entry_set(writer, entry, target, critical_qword_index, 1);
-		entry_set(writer, entry, target, 0, num_entry_qwords);
+		entry_set(writer, entry, target, 0, NUM_ENTRY_QWORDS);
 	} else if (used_qword_diff) {
 		/*
 		 * At least two qwords need their inuse bits to be changed. This
@@ -1148,7 +1147,7 @@ void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *entry,
 		 */
 		unused_update[0] = entry[0] & (~writer->ops->v_bit);
 		entry_set(writer, entry, unused_update, 0, 1);
-		entry_set(writer, entry, target, 1, num_entry_qwords - 1);
+		entry_set(writer, entry, target, 1, NUM_ENTRY_QWORDS - 1);
 		entry_set(writer, entry, target, 0, 1);
 	} else {
 		/*
@@ -1157,7 +1156,7 @@ void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *entry,
 		 * compute_qword_diff().
 		 */
 		WARN_ON_ONCE(
-			entry_set(writer, entry, target, 0, num_entry_qwords));
+			entry_set(writer, entry, target, 0, NUM_ENTRY_QWORDS));
 	}
 }
 
@@ -1272,7 +1271,6 @@ static const struct arm_smmu_entry_writer_ops arm_smmu_cd_writer_ops = {
 	.sync = arm_smmu_cd_writer_sync_entry,
 	.get_used = arm_smmu_get_cd_used,
 	.v_bit = cpu_to_le64(CTXDESC_CD_0_V),
-	.num_entry_qwords = sizeof(struct arm_smmu_cd) / sizeof(u64),
 };
 
 void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
@@ -1460,7 +1458,6 @@ static const struct arm_smmu_entry_writer_ops arm_smmu_ste_writer_ops = {
 	.sync = arm_smmu_ste_writer_sync_entry,
 	.get_used = arm_smmu_get_ste_used,
 	.v_bit = cpu_to_le64(STRTAB_STE_0_V),
-	.num_entry_qwords = sizeof(struct arm_smmu_ste) / sizeof(u64),
 };
 
 static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 8ba07b00bf6056..5936dc5f76786a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -779,7 +779,6 @@ struct arm_smmu_entry_writer {
 };
 
 struct arm_smmu_entry_writer_ops {
-	unsigned int num_entry_qwords;
 	__le64 v_bit;
 	void (*get_used)(const __le64 *entry, __le64 *used);
 	void (*sync)(struct arm_smmu_entry_writer *writer);

