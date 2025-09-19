Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010015.outbound.protection.outlook.com [40.93.198.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC162248A0;
	Fri, 19 Sep 2025 13:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758289333; cv=fail; b=YTNc1EPIIymNgaQbBA1ID8yHFfRk1l3Mbki7O7wIAHApt/tCwxaX2IULARwh6zxj0dw3xqrgOB/E1P7LF600Kfoys8G54Xy90bwVK4+PdWkrq7ddksjXUmvQakbi7gnOW/mLgsTsq0hTxUdULBJVfkN//O5ohGJJia8Zr6SH8Z8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758289333; c=relaxed/simple;
	bh=YNGfsejzj1eslVJdQ3ppd+yEPQrMvZhYCwM4jvrB9nA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GQlgx0hGxsvjzsrlTaz1ktFN2sLtF9+mM71wlwecl42X2RUrNp8RKisKAK/IsEkgLvkhaMclMeIfwTKpcOcUZBCOotPRXPLJxsmFax7e5n5l7Jcw4dbH3GLuKWcM5DKhLRmnZR6bZ+sjJle31mW1CekkQfBwGYBA7uuB5Tj9ikc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N1wPmq9h; arc=fail smtp.client-ip=40.93.198.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N1wPmq9h"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZUuJmVH8Re3EdPG38rjhMKx2UT+CoMLgrdBtwbH1Yq4lShohrYjRZnOajlK2injEYLKBEjoyM3iH6F0xD/RWf3ZSfz1IY9d6Vp4qxpvYUbl3ArHKdtW1xhruKr6Pk46piyhca7X6r2i1K5hRQ8tpz1ns89yKFKMEWlqpPfG/fRchM0v8LKRnWMZPV3zfUsyYd7SDOyxXomSdNyhiRMFc0Dz8NGQWlIsYZwNI+dF2o2LyjKvTX4EIEUvPkaXu5pNJztZVDNVvrNL1L9JSP00tgn2S07dVVFSy/px4dl6DK+d+9jbRHEkrjnLMLpgPzSJu54oI0xtGEOnG02kz6dqWjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0K9/BQgdPwP2hyQX1l2/L+osOevOP1gQ6Fxj6zuenn0=;
 b=EfH2Do8ZdugD2+9fa4NKYqKVxG1aN30dLA6ovSRIdXzD6q6zaG7I/EpMLQpWCEDV1lwryFFXTd+RPZOJRcjtQYlzbFmrlcSrtz+409HTwkDVwxKMtmXNlEcnE6iIyoutZyWnhq368Iw0TzI1njwFNEtavhPIis2xDjh37UNLr0b0BgCHlDF0Vy25oIA3QbnVS2ljUx1C39zNzoRfG0RRLv1P8CdF7DcHFw/rsxRpb9pHckqL21xxBOu1zaSe9+FniybD8sk6ZSv3EYWbA7xFQl2Aw6BE/MSHv8s2Tdv9e5RYYXA91NHQZE9Pvu9CVp3X5MX0PiVFj1cUNy9Ql+yY+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0K9/BQgdPwP2hyQX1l2/L+osOevOP1gQ6Fxj6zuenn0=;
 b=N1wPmq9hgG5vRSdk+kSn0oY0j2FSM4LX09/t3idQNv+U1OmCPIWOaIHSMfcc3BJj1aKZKWm2KfBYVLTB4tXma7uDFqfOmV1rAh3b1G+844ac9GVr3qS6e39riqsNWOTPJPa5OAO8EUyr0uMHPSs1IgYKtd3XthJjRE8RW7B5BDeaQoW6d4+RgG9NieTDCftgYvEhzx6ozREB7nBvovWANXTC+QPiYe3/ymPfE5V3AyyUa6sdP6SRUtauqBmF7HorDtz6mc6c3gvHvsFm5qdEzl70b0/SdhqB+oDUT8rvpycKjRoSrzV5tgvnpSvVfoK/lDcvc4JD819G4DxBMcLyhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by BN7PPF62A0C9A68.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d2) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Fri, 19 Sep
 2025 13:42:04 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.012; Fri, 19 Sep 2025
 13:42:04 +0000
Date: Fri, 19 Sep 2025 10:42:02 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>, Kevin Tian <kevin.tian@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>
Subject: Re: [PATCH] iommufd: Fix refcounting race during mmap
Message-ID: <20250919134202.GA2215352@nvidia.com>
References: <0-v1-e6faace50971+3cc-iommufd_mmap_fix_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-e6faace50971+3cc-iommufd_mmap_fix_jgg@nvidia.com>
X-ClientProxiedBy: DM6PR07CA0123.namprd07.prod.outlook.com
 (2603:10b6:5:330::24) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|BN7PPF62A0C9A68:EE_
X-MS-Office365-Filtering-Correlation-Id: 190f435e-0ef2-4c54-924c-08ddf7825198
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DnbN1VeKd9YgmrvVeHDZyphAOITz5OAMGsL/ZiGqKgubdNL/eMJ0qjiLwn8j?=
 =?us-ascii?Q?32TE11p//39L/LmlqQZex9LclRGSypCtEfBegwx6FVzMxwwpgkDG+Ugh7nR6?=
 =?us-ascii?Q?vCJm3W1C9shWho6ryoyklNN1F63gSP0iYvCHM3Ik8Ut/twlPmy47UB1udkPB?=
 =?us-ascii?Q?RYEh7hbMWRuLzVLvNoPS06w1NkXcd3ExIvq5Bq1bTwiNKujoqp4mGVD4m7WX?=
 =?us-ascii?Q?eqUViQ5UdGpckdfJZPfBFmMexHw+j8cP+2fuInplmI/ast5uEZ2lUsCjVm7W?=
 =?us-ascii?Q?3VoQC9L0o3SLfGKuQTZAcIYo+TgRnO5fZJV5ceZVVw227yqLCvd9MkYxu84X?=
 =?us-ascii?Q?ie+vsHWBxLbCIDV6Ap5Uy0KVZhLxwcmcpDCukV8LZTGYcMNr0nMc//nfKVfh?=
 =?us-ascii?Q?NUkqaCYTD+JmhHjACIMDO6IhyAV8neTMOv1pqpQpIKZhR1sg0zhYmxd4w03g?=
 =?us-ascii?Q?s/8gX4zcHFOQok8gJHSyW2+Tt54HMGMxo087EcCLRp6Vs9wPYVN7pZrNc9GF?=
 =?us-ascii?Q?UUB6WizNp/g3y9qwEv8SQQIA+G+YMEtS2Uxpq/uaXLea0Znwb4wzTELktvlP?=
 =?us-ascii?Q?T/jGWaYABH9XOAQmaIZ8dLN+YT//lpo1cy17Vbw7A20t/q+dhlU/vfJvEFmY?=
 =?us-ascii?Q?AMrKuq8cTaLHljVl1pw65Z2jzaeNSAds11IdbW9g1+fXWAg0ycUKp1zu8VYA?=
 =?us-ascii?Q?0qZYPwosuWlRWvv3sUZAQhhXnQz8r+nw4MD14UM4SuwkkgqTws3b507qA+r9?=
 =?us-ascii?Q?7BNr8k4B5zaZNqaEd1yJlIO0QMzeB4793/m6o1MUZqOGi5LAagsksiTA/KYD?=
 =?us-ascii?Q?+KhVA7foQKESvS4NUjQw7mL1Mmne4LWozD+klGaIaDyAL2dtQc+sVROfmKDZ?=
 =?us-ascii?Q?kfNHgBUPHZvpboD/LyTRvEeftBr34S4qu7OaG1U5l9FFY90ikc+VIMlW+IfT?=
 =?us-ascii?Q?OEH7vfK+qfef0PtB9EigmxoMwly9+YpKl7ZTP8IYp+WRlJ/aGZwqBAt11/bk?=
 =?us-ascii?Q?76Ih3Z35jhYPrgiLvQwXEav37edQkMn2OECWJn8sYToWTx027wX7tc6khasu?=
 =?us-ascii?Q?Qb/CryP9RRZDjYqi693kyq1jfFyfKeD6+1DIiwUUZf0eu226aUAERB0frWgN?=
 =?us-ascii?Q?dw3LBRN3qfcfDFJKrA59u4MWFQaQ2R3OOOMnw6VKBAcvdX9KRLkIs3bDSkju?=
 =?us-ascii?Q?NWrU3pkgtk2gMJQdPkXPVeBI0RPh2rxFBX5cQ8qXcQej2pMPInLvlRHgOIFX?=
 =?us-ascii?Q?I5kNZWu1iKxncSXKDzGuwBlEPcAWx+iFzt0avPDgT8R6uZBNrF75Zz7KPDon?=
 =?us-ascii?Q?+HS6aEBKeMAh+vmjIskEowlf3qDbuoUC4U5nVlVFtxWo2xfsAC71k+GqQXO9?=
 =?us-ascii?Q?Vqt5oAPODtW0VL0NYZjQ1KCiuTnlod98+8QKJMp8bRPQOZaLqHesDMIRx4wP?=
 =?us-ascii?Q?185tUlAt3cM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6H9iVXsvc6puY+Aywfdd5ypHbIk87k35efzAy/fDc3gHxBtojCV8RzFnsZtI?=
 =?us-ascii?Q?d2qR9ugzmGG3SvAbxOlyEMttahKwdF+tPiFt+g24fZnfHEdVcmXg9ankZ7Pz?=
 =?us-ascii?Q?ZqaYm1WitON0xIgYkEUfY5keRwghjeyDKntnZx0YFAk32vPImShZeWPfryEm?=
 =?us-ascii?Q?FgsFu6k4/tkLog2ECPQ/nMUIegcgxm2t5LYCyoOZ8PaXmIQ+FBlfXFkdbMCK?=
 =?us-ascii?Q?OOzNs9golV6vqGLXr8GyRXvsv3UBJnZH7eK0GpFyYay5WAG17VWOHu30tEOo?=
 =?us-ascii?Q?HR5Uum+nWoS0AykZQc8AbCrO/q7BTd50RWzzJ6twR2Iwn4JQYUC0tS7JWq73?=
 =?us-ascii?Q?BGve6QuZRJOqS79W/Wvz1rJs2c8OMC/aqHxJPetzn8aM8wqgp6V22pfbBIfg?=
 =?us-ascii?Q?MvJnaHEvNdm6ToxeoWcCeWCoG1PaGcls8AkYTyRgLIXXz1SGxc37FdgGhy8r?=
 =?us-ascii?Q?Bo4Am0jsRfYlf8OG2Iqcod1wZHuvFgwDezQTrpdvnRansZjRMOgrhLzlFQ4U?=
 =?us-ascii?Q?RAjWAFQl/B9uMgQkV/vOr0DXJ7ptrMFWz/3dc/zTWqftRW4rDI7/UOfZdYFb?=
 =?us-ascii?Q?ogDwBIkSohiSq3H6kfgFMyhjDt9mJo+pyokOjCAHGETDwpWIUhcOraXioOSy?=
 =?us-ascii?Q?fmacxLI7vtCKV4+A3IIs8eDZqNSeUqSxuBd0ZteXtajlVcKovvGFXdGNS0dK?=
 =?us-ascii?Q?nFt5drOVo70IoquObJedugstke4V2GkfLzDELN444/ifQrXLdM4i8v4Fpigw?=
 =?us-ascii?Q?KRqZQGCl/9P8u9rTlAlQ93TE6vDTSNuPOEH+VqmJGm5AazgwA8+JkYJkW3tx?=
 =?us-ascii?Q?ZMc17Z7z957r9RrN2lj3jljmK4iaRh+/CJUILP3r8PLyoqyTHAoLJPwsGDdX?=
 =?us-ascii?Q?LQ5pr3uzC+plZVxMwbKKmx3A69F5WF4NzcG8udBjipmXK53VgznUimshyZw+?=
 =?us-ascii?Q?DaVma62zpJjaN95bNF2/NsSluHYIb5vcCiqZs/W0ZQSGZh14qVIUxM/L8n0j?=
 =?us-ascii?Q?8VbjNvkkG37MBQdmOptb5+VF3jr3r2iy7/QEa36zEjsvA9ISU/eO4SxwuXwm?=
 =?us-ascii?Q?cw3fWSOfzgvia0HGUhBKa8ElpRbnTcLBeuRpEdQC5HPZ4BTgsreUQmTAsTum?=
 =?us-ascii?Q?/e/Xl/FJhOjgaSzbvfEVF/dsIrCFi/NnaKNfIK/JRNK/nRxV6Bj02m+hrT4D?=
 =?us-ascii?Q?S9bHWMRxt9vBYTVNe+mKctZmDQb2iti13Y/ydYJhp0/m6wFK7rH2UWyhZQSe?=
 =?us-ascii?Q?a/QnmeR6NreJ1oCEhjztlYw2HQ2xiOKEpldyQ7T4ApeJvL1hMXgBhVVyMFzJ?=
 =?us-ascii?Q?qq6SkS1ACitMqQshV1juQPdxUpqS1MncoiyT+ark2fXTspYlwA38xtiNF8zE?=
 =?us-ascii?Q?JJB/bJtB/YYB2gPkMh9VcnJv/o+8UmTWD6GfRid7P0Ps0Sig0BHhPq1jUrlj?=
 =?us-ascii?Q?uI3kfjEMLRDCmsDMo3YQFCbympMkrVhYQCtD1mhfP+DOAQh+dCNdQEKtFY8Q?=
 =?us-ascii?Q?GV2VJzljHwZhiIQsaGzLJ2HTRCKRCfbIeecZvU19DO88K5e8a7RwvWRJwlVf?=
 =?us-ascii?Q?7yPveaBrSUlVRHS0mmCu1giKzfN0UpAtVW9gTtmb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 190f435e-0ef2-4c54-924c-08ddf7825198
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 13:42:04.4823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ox4q5JQbzkJYQ6ByHkrUFyvqQ6cL1SPnmiybA4ZgyqWZ5usx0NRmdN/3i1UFbmEu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF62A0C9A68

On Tue, Sep 16, 2025 at 01:10:07PM -0300, Jason Gunthorpe wrote:
> The owner object of the imap can be destroyed while the imap remains in
> the mtree. So access to the imap pointer without holding locks is racy
> with destruction.
> 
> The imap is safe to access outside the lock once a users refcount is
> obtained, the owner object cannot start destruction until users is 0.
> 
> Thus the users refcount should not be obtained at the end of
> iommufd_fops_mmap() but instead inside the mtree lock held around the
> mtree_load(). Move the refcount there and use refcount_inc_not_zero() as
> we can have a 0 refcount inside the mtree during destruction races.
> 
> Cc: stable@vger.kernel.org
> Fixes: 56e9a0d8e53f ("iommufd: Add mmap interface")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommufd/main.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)

Applied to for-rc

Jason
