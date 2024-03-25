Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E497F15697B;
	Mon, 25 Mar 2024 14:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711376721; cv=fail; b=SqP/F5a01o1UltdMDURRr/8SFMB2xQLhn5XvKcdAGnqUFotLNFXZoEane/nI4fujCePivhJ9f8FHorryb+lUkuT7/mIzFzh3BMh56Uf2gxjqD/mkOBztYLDC+sIerwkPGyJpIqg+4D4DXlLOW8IyCLkd15egk9D8y+/koTSh5JI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711376721; c=relaxed/simple;
	bh=62MmCLy+pS7ItLl4fr61GAyy+cqS0hUx+cikWQ8QUcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jg9FG1AikLPXZRyd2JaUHR4oT5jPsYqUqvk6nU5QzN2crCgKBSANigHpKAe5bYm06N7lVY22io0qOCnj74+GrpGQHfMLmxvhiaVN+j5taB5TyW9rF0sFpZAcqm6Kn4OBJRgh3KV6jfZYthSkZxt6dYtSyXZzECMIsvWPxagLFjQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pU1YN7eN; arc=fail smtp.client-ip=40.107.93.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pU1YN7eN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ix7zBFLpPzyxX0tdQRcLPYSq9LpSizR9M0bq221TpP14apgN5v3YL+EtiUqvEJApXW+ev44S9m9B2m3vHQaDl0+HRrDw7difx2P8kniBEb9V+Qnz8dsgRcKtGlTFUYDJgpBJK37fNbAPrlWXyE6sQB6eJombdOfERUsLihm2v5unlbpwYSEAYN/HHiYGK5HfiPVXTQroNV4fkZKzpICw+rYA4vZzRbxxOr+1SEcz5uBD/nhKFtMzOXhJyEpBVwhmKPyI3I9iOGyZI00Y3+oZRNkMXTdWW6KKZXPlJ0sXAU221wADM9OYvGJp2h9o9uWzQnZknf9VrZwc9JXl41OwFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=akpvSg53+SqPyyLyjMPRIaGD3sN72cWz2wF78f2HmAg=;
 b=IeAFkCbtODfVkjoOy7N4Fm2mgsoMSZCqIcDQpbQzJ67u9tNvB/0Cyp6Qvszr7CE5LjyBGAWRDxXjsJ+/kfradYVnrLBCN24ZAVOJv3WN19B4GUdhGY2JCFtTvQGx0DrmtrbmWYEbSVUbRefRKFWJtayYq/STvR6NxPziQtodLxUob6oDULEldK+x+uKfkpvW9J1DaDyFPbKR32XliIyH/bmPTrCKhylIXtc0PVbERP93WqS7Ig8LSKX6Op9yQzz/Ohd0MEuGruUqRINBzKXbqAqvrsS+J4o0v/2UVGOUI8Gk+4qwy8FhZDsEGFehDNDId2zPdu+pPSH7AGRpoZF+RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akpvSg53+SqPyyLyjMPRIaGD3sN72cWz2wF78f2HmAg=;
 b=pU1YN7eNlxZ1OpLD0tKgQhYOLC9G74uyg0KPn8pX4znN511DZPTNFfdIDprff8QzQB1Tnvay7TzdQbQZFxTx4qJ/UiEj5/oqinnjI7ozV8CyyEZX9w2mOy3BlGmo5tFjeTf9TpINaKuTnLo3K1cN+cpJiM1RFRf9GjJaBSNY7CGVGRXAI09bPcHQOD3raRPPPmGJzDQvDlXFHDnpvNF96G+BbRTcM7oe5c9tAVtxUntcl+aV3osnZ04cw5P301GE9xbJY5ly86X9C5EXlMZyRHgNuLc+KNPj/4d6P+9evoUJ40nqeO7nfGYp1ll3UmMWvRGHgM4qVn0PvjHtaIzQ8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB5927.namprd12.prod.outlook.com (2603:10b6:510:1da::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 14:25:16 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 14:25:16 +0000
Date: Mon, 25 Mar 2024 11:25:14 -0300
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
Subject: Re: [PATCH v5 05/27] iommu/arm-smmu-v3: Make CD programming use
 arm_smmu_write_entry()
Message-ID: <20240325142514.GD110546@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <5-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zf7S109OKJlRVXiR@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zf7S109OKJlRVXiR@google.com>
X-ClientProxiedBy: MN2PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:208:c0::24) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB5927:EE_
X-MS-Office365-Filtering-Correlation-Id: d66afadc-8baa-4822-4ce8-08dc4cd763fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RlzjKu9g7JQ4N09iGBA9PUeecsk4mNZUzmpXuz3LHwB06IPFTLu+JTlVs+Do8D9+ljH7q9KHKudUdLtnEUJNEpvo1vKfktSaoemEJwT+K7PATU41yXUZnbYA1797MVuhoPqZ3WNieV+hsq3yIGt8cvUJWK8e77ndoFAnnTWzotOeZ4p2bfpUhDRxX0LcugKkzVVUifRl/zMFPmsq48XsqZ00RrTK7eHJrmRNgzUkSIj4TfkkLBDsT0Kdvd30EJWn+7+7SiRStZYxcr0vRCeGeNBTOio02bHadYrYg7kOxuwAKlpELoccaB5Ccr6CbiKOPoltNY3NHoqLveq8Pn2tgFAaeO5sStgKju3XElN6fRITMIriMUk7CIJnm/n+GV/vggCz0+DTcZ9dnpQAoT7y/oR/qOKbrq6UZ8N08NUyNUXSuCGwXI4nAgU2tD4yI47vN7/cnny7T4Qy0Gt5/pfN79bhD8Agbjqifb9uF35oaZ80bQwUDZVGmvnwHJDa/UYqn0wiWkxy+lzEEv4odyEA+nlOnvj5W9/xIxAOfRwIyDhat+6Ne/NeMzOGtLOsabg2ITwIRRc64FclzKzmMjn5vN+XSn7QM6MoKm8dii9ca9naLeAxGa5GXfbWEzH0qoVg4NLWlcYfqoNQSFI7KX/lTG3qICVeRgN5A6WWqiTBc8Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?raVtUtDyFgna0kTIdv2rGUOg86SVWYJM/X+EQdWJtFXYvI5EVjW/UIT7uxok?=
 =?us-ascii?Q?l6p+iodBYCR9Sdvm02szyD/cLcUi/9AFoarKfqV/YDo/p3hlQysBLW8+eK0H?=
 =?us-ascii?Q?bNbHYGb5d26Fhnl5lDwVze8+CEQA9/8tN5fHWaCn2dRv+G/Yv0mhCX2jmX3M?=
 =?us-ascii?Q?ToXAt75VzgNAsg6y9xlEVPVpZ5GQd0F6D1bPhf/WYa5o5Bsi2VTbYK4YkDlX?=
 =?us-ascii?Q?l3bWKxpKivvXLhViJgZ7a59DHz8vwhlYpUBU5ZwHubNmEUXjJHE+dSQC4C8O?=
 =?us-ascii?Q?njwKBN1LKZu6w5hPZeV6lufpNhwbOv1Dt+R/4xhlMD9qYWqoTqeT1jNfnMrr?=
 =?us-ascii?Q?paR8kWq7FW+vYWqL4/z+GT+qn33/7sPt2MstYJtxR3en2kK/6Sy6HoKJV8cw?=
 =?us-ascii?Q?WCZPOb+c0jhS9Y470vcfx2GG6ksHDhMFriow2qpgiv7wJh/G4x0l/J3aJ0AU?=
 =?us-ascii?Q?Sl3wIuuGWGKeM+Rwx3ZIlndfgeB5IWHQ0miEPf3Iq2qLAn7A3xQGbL2leB6a?=
 =?us-ascii?Q?U6F8G9NVO/nAA6I5hL5ne56SBOk3YDdVZa5Wp9Ey1fz1YYNvL81RwSAwA2rO?=
 =?us-ascii?Q?9UbyEG07bQeFgJA4MsAGQ8+8lj+wc1sirlmzCfmBDuBs0EqhcOuXZi3Yh778?=
 =?us-ascii?Q?CPYsNW8iDNit2SXIjaRvD2XqYizEWSkxrgkw/clPO6l4IlSMKyTUfYMuNfjj?=
 =?us-ascii?Q?8vxGhkhInMz/6ZdW0v51sJEjcNVjTS4Pj5z9e+ndJ6PCaEToAcXh374m1CM5?=
 =?us-ascii?Q?Y7kpte/a74LDdkIJY/ynvOZLhTPmMxrSwolM31i5u0YiKnkQGYup7GY9c8Ck?=
 =?us-ascii?Q?L1Gho80Z9TW2lHhTcoHpBHMwy7NGz+0XBnQq6hIwOZDyZUw9scBurmWYRmKy?=
 =?us-ascii?Q?DYFJLfn9D+QIokOgMwLvWpC30++AxHe9XWZuMrISdk+wzY7nOyjVKDEjyCzT?=
 =?us-ascii?Q?XxwEw6pNAjXf4ANPDU7Gk/MOmV5GLS2Ed0gAagtqJ6Bb8tjW7j3nvO7Qp96p?=
 =?us-ascii?Q?ww4uoYponp9mL53+iIV75am+k3us6fn4jZx2yTdQk4nRkMnRqc9N+Ic76mmz?=
 =?us-ascii?Q?1YDhFOmP0faHuA5SkaVRQqZAsTbczvSA4UHBpliLEnE6BAVM0V118UwUah0B?=
 =?us-ascii?Q?hEisAcbFOy4IY6myjYGmHqnAfWHOwIjf7bn92+ntyWk5zr51SpbmBzBf/gV6?=
 =?us-ascii?Q?/deeKPdDwxQi0iQqkcP0wr93xqRePi8un8xDcgHSE+oXt6uGmg7BpHHM58vi?=
 =?us-ascii?Q?Df1zM2JUaM1gtXZ2zBbQ+dPh3MGrpYOm3ZoqfKRfCqyRHRHz97a0ETROPWT/?=
 =?us-ascii?Q?133ZBmYDwQpgsHmifFVqZKtjAPEJgPq3o6iT2s8drj2u4hsRAKrvCV7ct3zD?=
 =?us-ascii?Q?1TMwREZ9XZuBndR5CjM9RGbODypJzdEuYG8XCrqKxygLLHeyztC2oTIIqVYd?=
 =?us-ascii?Q?fD07DN9MiEAlOcGB+cvRDvXI/LbTA8+4UbznaM6wfq9GUFmrQ9JxqXELVIyh?=
 =?us-ascii?Q?quo8KdXS1R1AwDF1S6bySIPlVArjqZXUPPOTAZZdPGUVwBqRKaix1fYuODzc?=
 =?us-ascii?Q?c1our2YZ48v0WYaQGI/FDGEa86cVQlqMSAM8nV0c?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d66afadc-8baa-4822-4ce8-08dc4cd763fe
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 14:25:16.0259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xD3SnT9h0merxAFAUOXY+g2BqbujsqY77iyPsj4sN1+z2tT+8urCI60lPA9dlIRe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5927

On Sat, Mar 23, 2024 at 01:02:15PM +0000, Mostafa Saleh wrote:
> Hi Jason,
> 
> On Mon, Mar 04, 2024 at 07:43:53PM -0400, Jason Gunthorpe wrote:
> > CD table entries and STE's have the same essential programming sequence,
> > just with different types and sizes.
> > 
> > Have arm_smmu_write_ctx_desc() generate a target CD and call
> > arm_smmu_write_entry() to do the programming. Due to the way the
> > target CD is generated by modifying the existing CD this alone is not
> > enough for the CD callers to be freed of the ordering requirements.
> > 
> > The following patches will make the rest of the CD flow mirror the STE
> > flow with precise CD contents generated in all cases.
> > 
> > Currently the logic can't ensure that the CD always conforms to the used
> > requirements until all the CD generation is moved to the new method. Add a
> > temporary no_used_check to disable the assertions.
> > 
> 
> I am still going through the patches, but is it possible to
> reorder/squash to avoid that, so it is easier to review?

After Nicolin's remark I changed this one use a temporary helper to 0
the unused bits then we delete the helper instead of touching the
machinery itself. It is much clearer.

We can't avoid this with patch ordering because the progression is to
move CD generation out of arm_smmu_write_ctx_desc() type-by-type then
delete it. In the mean time we need to use the new write logic in all
cases because I'm not sure the old/new schemes have compatible
assumptions for the existing arm_smmu_write_ctx_desc() to be safe.

Thanks,
Jason
