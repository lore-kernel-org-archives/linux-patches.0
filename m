Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2067.outbound.protection.outlook.com [40.107.102.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00773B185;
	Wed, 20 Mar 2024 13:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710940162; cv=fail; b=N2YlX0WGomSnH6u6bp8LxSuVAWxXSGp2a/k6KdvxgjgDnSQQcGRvQrbCS7l3T/rmjoPJtIcig21sudK71/njMjdOs1HirXPhGTVdBW98ZAsQD22iJYcvyNJlWzIjxQAm1F7oR0911qPzvE9nP6eASn1EMYbJcaiJKKllsp/yl+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710940162; c=relaxed/simple;
	bh=Gau3IJa6fd+SHlYAl019eMg0RoIfKevmCxu10sclWqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=s2LoqjGzp8bHpHfp/Mv+lwDpJC0WZh464fETMqTg1l9K9D9ufkL5aTaTmRDa/RqJsYQXFxQTts9uuoe7eRiGTL9z+Y1xka0heXhXciCYetesrQ7gfBdv1lxvr0Bed8l4IRuQ/knEz7ECbIjB2pFb1QdQE9MdJwYyRIuZAjoIUc0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fvj6IEsz; arc=fail smtp.client-ip=40.107.102.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fvj6IEsz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DL7ktiXepUsm3yjrrcymal+RVIch4XDJwyNQA45FewN/S4tz3i+ENoFjjn9Q8fhXmmImsU2hhYC9J/qwz3LpN5X6gY7eUI8yafHHqmkrMFYCKotTraNrd51tOEzDUsmhQtf/tWtXTP/cKe/snDfmMSxQrouSu+RuS/zPdFfX5/SJPOFChZgbUGJDYh1C32wDd0VAdjBWv9I3dtICUBKqEGGLXxiVcP/0H+5xxS7MmNwrTpburlnDYxr75e5yZtM3MFKzHOtJoAIixBXeDJ8h+kfwQkk8OPcluVYhQ2nJQXAWm5Cf6r75/dsYq9ObdTAlYomT6ZlFoGK9qPfjj0Jk9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A+3DYDifNJPvibpMqvBjcQ6uJNsUUVijr8ezo+9Ner4=;
 b=D5jwLdb8TkALs+X91Qz4rMeU1/YbzIIF00l/RzlmuHZKnemF+gr7yPcMDdBvXLFSHPl/Wp5CHQvPL1zyMpNHqfqqpgUDjy5+ttd28cQLBvw2+9wLfa3t00BkD+mDYXyzhQnoDsu2abhTcHGoCusSnrlvWATtTBUob1h3m3vd2paECrK58ZD0Md7jZYufX1q1wzz2cvOe9/yqyrU7cnjP9BG9ZdKMWsvvjAxQ8cxXgDpxvR+t46Fl8GCnSmLMFJcn57lU8+7iLSypvnmbaD7Ip33vyG65HXQEKsNb27l6Eh962sbfaFMGTcgrhLjLRBKivXSbUb0jU3ZNZKhry+y2KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A+3DYDifNJPvibpMqvBjcQ6uJNsUUVijr8ezo+9Ner4=;
 b=fvj6IEszh1+7qJipVk3oRnTHc4FLwrte/DUMsYNvQ28bqB/4Wh3LNllyaKFLkf2+Ljp8b8LOur0e2Rszy4uGN9bo+4Ufljt2cMJd6wx11jMP0tPI0/+2SytVdXpJhVjHm/bqISbndsgAmx6d7FKIC7jpmWhxFUNe5BEQN0E5GftrXzkrIDx54af7GeajRfVmshvvnKYbn19ZaRxvflnPGiC4pcGY9onPOrR80oGH2qVAgCzz++zqmTWx9JcMFIkayyN5HV1TP7aoKirXM92mzRM+01mJWl6WQkVih6UM1dFdv+nUeUpwEM2q4VLT7u2TP8MoShOs5LBXp1LXpziL3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by LV3PR12MB9119.namprd12.prod.outlook.com (2603:10b6:408:1a2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Wed, 20 Mar
 2024 13:09:17 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7386.030; Wed, 20 Mar 2024
 13:09:17 +0000
Date: Wed, 20 Mar 2024 10:09:16 -0300
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
Subject: Re: [PATCH v5 10/27] iommu/arm-smmu-v3: Move the CD generation for
 SVA into a function
Message-ID: <20240320130916.GE1044235@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <10-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZfUr8aCCbdnEd3+E@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfUr8aCCbdnEd3+E@nvidia.com>
X-ClientProxiedBy: DM6PR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:5:335::26) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|LV3PR12MB9119:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b22e802-9bd1-4cc0-dcf2-08dc48def285
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	oGoZ3p0gu6VTVJGkzNSNoGX+igoWOl8+I00LEN34VjUntJ1k8PufV8JCOuKmZDRh+6BSWQI+FnomgBPb/Q/frxCE762eYj0kqMis6VuOGe7C5CiuW42xIMXCdmpLkdDNA9LnnvcZZ3gCPK0vozMK8RzQ9qflwma03yB15YJC5S/E+CN2Cv1Bxol2V8ZtrsdlqTbYtl42KRNofLfMOX+k4TBQWAb8wCAIKTPi48xSmqefvF0wi50Jy+slLUEK95qX3LnqM14yg7pXGlOZCZ3YueV607cszozUIlKiTEjW+/sBBr5TWK6NguoEbH1CMJCFfgTqnfIHhX/Hz48LqRRxH21yoWpbFd/vI2P1EcA4Dw9DoVkTrDiZ5qyAfKrKhmGqRc13r94yCKEuFtPuFH7nS+38pjIA2xrE/3fLBdqVOAxCz/zoquUn4XoS3CZ+T9bypjD/HTs4teqT0BoAWJduKpIWRlMd7ijRC9SlSIjbKXSz6VmonJjmLxxOU+7JCZbZPWYqzLvyD9wwBos9GKfrt55NNztwoijMjHUswM/WDNfMaFtikNX9p8143q+h+gKEGBmD+zzKsHixmapIkdBzmxA2gkZhFS9J8h3cu4gHgYjCJS5xe614xW5O6y2QPcOgVfoPS216hoGvMTUWCAp+w/N0Y4tGhyRwgctVsdrQd3U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h8xvPBcPFGyn3NLnIqhlYS+edpDLl+izM8Mi9xzhjBIbGl0SiHmq3sZjbIWq?=
 =?us-ascii?Q?JMsfAwuI0PiBT9xhRSeM3KFoDSwcjI4I2o5t+aPgfovWtAkSUO3TC4tk9793?=
 =?us-ascii?Q?GtUBtppVY6zEJeIZJRJVrKnYGLPiaEA9IQ42yf3TT6PSHRMbpZ22eFujAv84?=
 =?us-ascii?Q?SVWu3vW//aAnlONMm/ykJ5b7eviBN8zQ+ksXlio3b7JCEC4XWiWhblGJQWav?=
 =?us-ascii?Q?3aO9VJpXArMXcl9xACwQD1yf3jrVbB/NXRfZYAzyNx4bfW7LjqOg4NYhleJO?=
 =?us-ascii?Q?zm0nlEUzYr9Ltwfz9yaDTmI1il9D/XSf2Tp22P4Uwv58OTp40B5CmqvJC+14?=
 =?us-ascii?Q?4Sc1S1ut48xtuMtYLTgbq0y7SYJ/W19kzuBjgF9IlsLKjZFggbhbiHS7G0+N?=
 =?us-ascii?Q?zP8tVnxJ/tgoRFPMVIWM6TpsmNKHfr7U70N0B5tI1fEYq7m5lb1ooFUqmyBP?=
 =?us-ascii?Q?fTxQb5MQ4+UZzCIrGu9DsJzo2e5pyYb5FYpEMkU6j0qMzb97S5vYiuF2M53T?=
 =?us-ascii?Q?/n8Tm9GICzT2MGyBzG870wxP5CmXl6DRymNMsj6IdVJESx/m4vgxkXuxTfO8?=
 =?us-ascii?Q?M9RPUMRNgPEcGAIZbqKHwSnrg6KDcmYQ1dzhHqy00pVUuIGo1ZsPVwAfcrqb?=
 =?us-ascii?Q?0zBzlt960z3THf7JWarml5I92/WaDgyTLBlPn55jgz9DXiE6i7IznQcgY2fU?=
 =?us-ascii?Q?N0q47oYRINFvvm/3EclARIm5TPYif7DSCmE8KXsXVOu3MbfpuNEwogTR/H2/?=
 =?us-ascii?Q?qx38iLLtK/4FuZ9MjZlOtpa1rOrwkxX87pei2LFfE88L581YqVSIEVpdIrEJ?=
 =?us-ascii?Q?KATQLavHZBIzth6s/IGC8MMH2JYicNSaAWqT8TlbaluGVo5aiiN7TMtfPt5U?=
 =?us-ascii?Q?NEiyFtTcMYIwd80XuQ0Rh6CC6o/uO2AKSIQQz1mc/5SV9nNFBw7ghXC7I7e3?=
 =?us-ascii?Q?TCSJU+jm00/tTFMLVpNnYKWjjqpCCz1+Bt/FeEvUiuOwN2mOelra4T1zuBgZ?=
 =?us-ascii?Q?nz3RpunnYswe3caJzNT43Wix+8lE7STBMwrkxajyx2Qi6F9ZPJ1gXwcWDrOA?=
 =?us-ascii?Q?RG9aI3qgVADoqPyZvz+I2VqjS8Zl1hoLMuU7wqmgPQ9Ypt/1AQnJIYX4FZUJ?=
 =?us-ascii?Q?8q6qctKb8M74ApTwMmbs5N+tnXFvdr6xFpUTFN1v7Y+tlQ7vdExM1z6SPPwz?=
 =?us-ascii?Q?vEMtEBTMDQJa8mZT7gmdghGwi51GDoyYvrx8UwTOqlSpLllsPQqV0pCoDhzI?=
 =?us-ascii?Q?bsZ+WBiipHxdI8uAiDe5MVrFBkv1a9mF7k1HhAva7pAoUvweElMHxeBMZDDd?=
 =?us-ascii?Q?39tClonRI2yX0h8C6McLjIIH4Rm8Ucto0PVDhnCeVeJj2pC3ywtH5PbWHNBX?=
 =?us-ascii?Q?pFRVcvcKiMYzYDU92R1Q7/l+7etdZrhsfFAgw+Tn2P5FJk3FWgJBOb+fkuOK?=
 =?us-ascii?Q?Y8BEwqEnhlx/rOqj7loSKmVQmkOannWyORXRk+32bUFdMmWgYxUmaCQ8aZT+?=
 =?us-ascii?Q?PD/wr548xY8FO8XMMzOfJbNgZxFDkFQYlq2I5WXRsLVzHI6aCoyoErv7gqzz?=
 =?us-ascii?Q?4jQ3ntghrRDkTD2o9/eDVFVyBbPhFVwKpCyc7OSJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b22e802-9bd1-4cc0-dcf2-08dc48def285
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 13:09:16.9803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WJ4bUc0chcp3LtlXJrulfW4dt9H23PfImwQcA+iSO8TsFoMB8hNFpgrOGlr2OGPj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9119

On Fri, Mar 15, 2024 at 10:19:45PM -0700, Nicolin Chen wrote:
> On Mon, Mar 04, 2024 at 07:43:58PM -0400, Jason Gunthorpe wrote:
> > @@ -1070,8 +1062,7 @@ static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
> >  		 * Each bit indicates that a used bit in a qword needs to be
> >  		 * changed after unused_update is applied.
> >  		 */
> > -		if ((unused_update[i] & target_used[i]) !=
> > -		    (target[i] & target_used[i]))
> > +		if ((unused_update[i] & target_used[i]) != target[i])
> >  			used_qword_diff |= 1 << i;
> 
> Would you mind elaborating why we drop this "& target_used[i]"
> against the target[i] on the right?

It is undoning the temporary code a few patches before did and
bringing it back to the way it was in part 1.

It is ugly, the programmer requires that the target be properly
constructed but the way I migrated the CD code over doesn't guarentee
proper construction until we reach this patch because it edits the
current CD..

So there is this inbetween step where the programming code has to fix
an improperly constructed thing.

I didn't try too hard to simplify this, let me look again.

Jason
