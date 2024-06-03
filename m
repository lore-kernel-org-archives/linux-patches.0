Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FAD522E
	for <patches@lists.linux.dev>; Mon,  3 Jun 2024 22:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717452915; cv=fail; b=NUaZysaFNKyrwksIRmMCjQjSu6blhpQQ71FrACJ9Rzue2i5pbREHMdtNJbYx7rpyiG2ZBaUDixHKqjblNVselD1/PoDFrDgNoOY9Ji4tnOrfm2EtYOEH8eFlISQi69Qe0NIkR2CuknZR/KAzNGg1AdnsmJ0lTxgsNdNLKeGm6hY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717452915; c=relaxed/simple;
	bh=ikLipPo8OuISwWlEpuCsTrvy5WVKFf9vMBbihhqwNNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ron0/a/0rzE5b+TjcQUOEtpomgir8UaUeooj6e4edYI72oKnBjdOkcLdKomGwQOk2icQoa7CuTo2tnv8/ltVCHM3Y34ZCRknxwvXA89JMTgj8sNuTvjIIVukyW6rSe4mkD6+iHcS5RZGVb+PYrK7Urm35HHTh57JHtsTWE0SrHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bK5wTDYA; arc=fail smtp.client-ip=40.107.92.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bK5wTDYA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=On4i5gcIQSq7h6/Oe8/ksIQvAAlOtSpU//pGKI3wAhZCOCcLd3jXe/z2z4Kd2j5k6yaoyWxhlj9t1HYljTXAWQFbLqCJrC95nXCg1YQvjvA8FVH9qaOQGy4yVdqyaBTU4GrM7WY4fJcuMfPNTG7FDuU2KNU+9RcQhDs32OJ+EFlK/JJC0zZSVP4UQ1DZockbYaq+E7vtWqcD4oJSbYYFZKcsN2rx3/ZqJr21NDF/M3qGKzg5cqXMaN6ZvGdxKQ/HW5jU7v/25dItiYk/9M13Z85bwaYDPsw/UB/QqXgZVHHtCz3yAVulVd0Sqre28GFMAuJMkl1yg7tUftyZr7XcKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kUA1543xqPCKVT0LjlcFJj1hgzKhQ8silgt1jhBMvCc=;
 b=W5IpQqelSCOev+ZHTkRLP3cPLLV+CgbqipnwZgb0BUrczS8J34ZN6NFK9KtXSJ/lDzQNteYB82r8CqPTPk6b+L5meBmr8j7ohT4Lb8ejIoaQDAFAS/EBEhD6KSBcCBxNR4sYUkBu/KzSonjO4TCx9yyc0sKBQHdNgD6O8ov7wChoCY/dwEUCJPilKHKE9XoUj9k5ltjGFUZBwyKcM2Gmnvap1Y+IT6IGED1I45SZ4VEMWz1DMIeuJBUX2DMW1mOiB7krAOcd4UykoNPR2N2p6qSFzNSoedaR8/azNT8nsqrIM6Zu09EkVCc8URWSBqxc1KZhi80kBZs98nQNpyg4vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUA1543xqPCKVT0LjlcFJj1hgzKhQ8silgt1jhBMvCc=;
 b=bK5wTDYApCDwxeudpH08cW0Bb3KfIzVzG7ICa2nzzH9E+6mKMjDJkK2lZUYA3LTGUWWtGrpo6FnrCQfoxndjjKmumxalkPlrWkOYZsCQxi+qPdrWwHn5rn7VSOnAMCR2gjTALRQX0CTOSb1CrRL+K+J73f/iZv4MctMlnnRvzpL/tL3nL8dfc1p9cbQe9o2OIlp28JpwWculk9rLTh4IOg0DATtVlGnoGH0OOoinVaTMTZ0n0B4G5eTXS5/6WeLDfCLDt2DLSGUvoKALDexMRNmRBk/ONXGx6Zrjjl0rozS724MYSFnHQeNh+HM7xyiU99500BDZRXSPqDAWFiqpcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB6948.namprd12.prod.outlook.com (2603:10b6:806:24f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Mon, 3 Jun
 2024 22:15:09 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 22:15:09 +0000
Date: Mon, 3 Jun 2024 19:15:07 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lukas Wunner <lukas@wunner.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] sysfs: Add stub sysfs_bin_attr_simple_read() for
 !CONFIG_SYSFS
Message-ID: <20240603221507.GC19897@nvidia.com>
References: <0-v1-44baae71b833+ab-sysfs_simple_read_jgg@nvidia.com>
 <Zl4rqswlbGM-eRY6@wunner.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zl4rqswlbGM-eRY6@wunner.de>
X-ClientProxiedBy: BL1PR13CA0156.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::11) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB6948:EE_
X-MS-Office365-Filtering-Correlation-Id: 95f2aa3a-4c2f-4446-5955-08dc841aa182
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sP3ut52uHHF7u4NDSyLe1Jr2Oq1KJ6ByEN3yeo9D0LyKxxjnrSCBL8rE+za9?=
 =?us-ascii?Q?gUbf6Z19cmGQmbA9YcTqHSDuB1wbjOcrzPvnBbttaxODqjFoXe+N9dIfu25z?=
 =?us-ascii?Q?V/LMoDoNks89CxY2kkOEkaf/ziSX8kpAbZr24ASeP/ZcMO05st+bAWc2U/rj?=
 =?us-ascii?Q?37JZ7zPq2frQZpLmkkI2gDvPkWVziKnAjsKfbXyc2p9kjHmbsP4L9/Ye+9aj?=
 =?us-ascii?Q?tJqzpczt9+ToSkcHvomqN003cJn5T8s59mBgXKRXZXo4amvJ6MsXBc/gik/d?=
 =?us-ascii?Q?PvavHvLys8Ke90pwrY+/msAnPluq6O2liegiO6/9BL2omYaODggy9Klunn+n?=
 =?us-ascii?Q?W3K5ZoXQJ47uCz82LzIWi2tJLEBtrpOST6G5C9Kqg5doQesLVliHeNDLdUyN?=
 =?us-ascii?Q?HD6Y8RLNzrtmOkg7Po6aiB4FZtoZEulbgd+cPtVgp965QAPOIrAvBp0iP3jS?=
 =?us-ascii?Q?bsVK7vQYYiKls+/nYtZJlbk15m3YWFQpDaPFqZtWnoK+uonalDNImQ6uxhNB?=
 =?us-ascii?Q?NvB/xevaGtOMmfco1D7glKNb7YyuUK2f6nR5XSKLsdrhWgeAXZJfO1cxvNqy?=
 =?us-ascii?Q?nU0JIYfugsCUCCteKfGCrmGLt0ramogq6Gk8yWGYqZdhU2oPC/PuwkvRD5DM?=
 =?us-ascii?Q?pqCJ9h06JV7Gtz1QsOjN1KbcuN3YHYX17Gd2dYqySxEK06BIlkGUR9UsD8D+?=
 =?us-ascii?Q?3lpQUr9BQcUTE2r2LJ/jhiGUDiexxJBUd6ukGGSHpJrFUCzLN3gJ/k1NaP6W?=
 =?us-ascii?Q?m0bFGa9oeSJMWnuH+u4v6IFAtb+mxA5A49GG/HfGlLNEZWxx0llxjfUOIgfh?=
 =?us-ascii?Q?/8k241aF7zaqiVDVJJLYajfvgixFWlWksGk7KJ8S2UJd37kN8CDmdo0Ipz04?=
 =?us-ascii?Q?lIGPEzPG7RyWNsWqo35SFWeWZkwBjjrGpYydznCkmkVykZGXAW0VgeqYwCAF?=
 =?us-ascii?Q?Bu9wMkzxftuF85494pmjTM+9ay2sCSI7EupGz5Se3ZvEaELFKjMPugzOaUyr?=
 =?us-ascii?Q?NDmjw/9Q0dq8C5Z7B38++uiJ9OE76jEioiSVqPdRpQpHN2qGlWaaKRXbhl6u?=
 =?us-ascii?Q?WnLbO4uWv/vaNdf+TW6tzGv96VvX+IHs5CEMYIpwXJdVw8cCXrB1oFFoJULS?=
 =?us-ascii?Q?s0Bp6NfnfdyVjiDVwHQvuRQ6KcCky6wmhTod0QotWA+rp2Tv0urnYKmiwkop?=
 =?us-ascii?Q?MoDk85HIOqBUMrE4zot71NmbTrOeDoZjtipvvqI8yKw7sFqUEj1O/Xykwb4+?=
 =?us-ascii?Q?gU+MomM2j7NSKR8kkexprAq0RK7Zzs2gHCNE09K5+u7amdCG5BYwqPZq9rQO?=
 =?us-ascii?Q?m2ZQPX/3QdKYFg5VnUy3H6I8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RvIQxTANPfn5MG19zgYZJ/LB7kzjbPyEt3LKfCSZFhv0u92HvM5Bm8JFkDSE?=
 =?us-ascii?Q?Rsic3+8r2eNlI7KrfMx7yz6B147+j2gWfWDtvQ14lJGNXntBLUDgE0KM/Gr7?=
 =?us-ascii?Q?UC7S+6rw+46QFjsYMpknhqNzKEEDreMGljaLRmnAigQkMsbCu/HjlvcalEKG?=
 =?us-ascii?Q?MJaQMEHgWSVoMAQqFeKqSTSdoPFAxEMXGS4oXcZfOZyETFHgPmlekL4Z69zw?=
 =?us-ascii?Q?4v5B3hXAHuakf0zUo4IlNyDqWvuOnF5qf3QGPvsqWLrkch1amTP2sGtYJGke?=
 =?us-ascii?Q?jebQ2n3kBkfByTkOY/uW7Y+3aPbF3tX70z+EeVsU+cGkzHiMxow2dVkOIcFD?=
 =?us-ascii?Q?MOckp1h/uNZP5yhsUzGROWDC5+FHlCVzDwDvZQ0Do/0ET0DsXWobJ6EGefaQ?=
 =?us-ascii?Q?etIsdQ6QDCtjUIzNmnmBi1AbhVb2nYr/ylPMuJmg2GCMRpJLMnlF82lK+6K8?=
 =?us-ascii?Q?dAb9w9ia9slHYYi45ZodjjBuBEVELoWiT+SKh5mbhpRzI3Ys9HHTiRNI4U9D?=
 =?us-ascii?Q?zKAWu32sUWbpr08KgzgdYdGc8i5Qo1W5va3SdDaFZBAS0wwSWrHPMCz/57bp?=
 =?us-ascii?Q?7Tdr1Hdt3NRiFqlb+98wt+SqOrVXfU6MC3XA/jwSXbvkmg3KA36Xldc7tTv0?=
 =?us-ascii?Q?U2UfxV6famxbJUdvbzLwJT28peywvvL22qZ7ZNeNR13oUtxDJ0HVAaqcqkwP?=
 =?us-ascii?Q?BLkI7tJILDgQvqScicM0t7tJFcVibQqF/toq1ypmR/YMYz/P0gcra3MlASsl?=
 =?us-ascii?Q?X5vhAwC0u4DfPfFEtCM+4X7/8ivvFN9dWarX4rXosNP3xkO1P5P47A24+kQy?=
 =?us-ascii?Q?dmKbGpqfw5gvMZE+VVHfBq4iPW2rW/n+pcuVMCaM8fucn+6d4RtGf4a07gLu?=
 =?us-ascii?Q?SrVFFV2nWJPVLbvn/2HDSxo/BsYr2F3eOhmrD9ntp5MIqN2t7FkSg2L3lkWT?=
 =?us-ascii?Q?ZC9b6U6MGc2n4Jq4LTI7jl726MeWsOmercBJJqiYpn1NrKv6kuIuNVP2kt6B?=
 =?us-ascii?Q?kAXopPyU9Ez0+vMHddZZLkSA4MjXcmSeXyXoqPZuHmb1xrsF8TkJvD7oK49U?=
 =?us-ascii?Q?/1+7kTYSmGrKmp3HG+YSZbSEzDKqBoNkfUGTYF5OFHeA2Pevy4l2eKxWzNBw?=
 =?us-ascii?Q?Dda4n+V7iKDZ8DiEVis05l07mV/o8MHdGaOCvcRwbZAlCVb0e3755wampqmB?=
 =?us-ascii?Q?I4z9Fa5qncQlEtBoLJL9Wvc/1DUBdutRxuUylZC5Wupgv6W1IjTwTIqerU+g?=
 =?us-ascii?Q?IclHcVzbVFvfZ49Sxft0p7BLWf7qe6/E6Yo0L6+a6GAaGPu5gjkiG9GYaWXr?=
 =?us-ascii?Q?Elp9Csm05XHYT95QdB1CHJ6rjisa6i0wbxKS7PnXDSCeZcG4KbDxSaIQs38S?=
 =?us-ascii?Q?RySRo7AM3ZaABImY6BlWeB9NMx1CubqbOw2Gnhvm9Y6NjqEHVCHaKVX7j/R1?=
 =?us-ascii?Q?gouNoT8VQvNgA0qZlQvtGDn28p+U/NB7UtdAR19fbE6cJqzrOasIE2BZMSHC?=
 =?us-ascii?Q?P8VtO6TWpmhDuBgahzQHa143HNf/hCSW13l/fsLnwKjeBN3LdXW65wi5Ao1a?=
 =?us-ascii?Q?WIrKJJ+ykwCMQzB47uE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95f2aa3a-4c2f-4446-5955-08dc841aa182
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 22:15:09.4496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bqVuYdHSs6vl8rv6fsJk9yhZs2KPE4zkBegXYLmSSLtjS/wN8Dmux0xjFmRfMbJp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6948

On Mon, Jun 03, 2024 at 10:46:34PM +0200, Lukas Wunner wrote:
> On Mon, Jun 03, 2024 at 02:30:45PM -0300, Jason Gunthorpe wrote:
> > Since the only declaration for sysfs_bin_attr_simple_read() is inside the
> > "#ifdef CONFIG_SYSFS". Add a stub to the #else section too.
> [...]
> > I don't see a patch for this yet, but I did find a 0-day robot complaint:
> > 
> > https://lore.kernel.org/all/202404200345.eGdn5uxW-lkp@intel.com/
> 
> I already submitted a patch on May 23, but it hasn't been applied yet:
> 
> https://lore.kernel.org/all/05f4290439a58730738a15b0c99cd8576c4aa0d9.1716461752.git.lukas@wunner.de/

Ah, it is not a good practice to put patches you want applied buried
in a thread, that is perhaps why it has been overlooked..

> (My patch returns 0, yours -EINVAL, but I don't think that matters.)

Yes, it looks like the function will never be called.

Jason
