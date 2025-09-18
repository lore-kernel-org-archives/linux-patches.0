Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011057.outbound.protection.outlook.com [40.107.208.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7AB214204;
	Thu, 18 Sep 2025 14:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758206673; cv=fail; b=Y/Dsi56kFaiW6AreijuMTAu1Akgxjjv9b0FvP0j3AoxG9EuAvV9hxf95PGIl09Qsvvw1dscNDWMTqD4C5zkz6hputqR2fJUlkzFndNnDkpt8Vf01KOK55Bk06HeB6Pe7kRTrRl3iRBDutiH2EAC1afkQDB1oY1EpdEOT0uUuHnw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758206673; c=relaxed/simple;
	bh=Cfp1mpxqPNCMNdeJCOG5zNLl+BYbizKUsuhlSCppiWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sr3Z5zrD1P5idblQnyGTGY5OZvhUGD8XLC6HtQCn2GsZUVuiODXai2ivsUxR/NLEIP4b6SJlYzqcXqzeA/drwqfhJELbGY63aRLu7k2I9/KdilljSJYNgPqT0XtUx0GdYsWO/o9IOt6UjDEQ1E4axAMX7giQXH+TIfVb+r/nhNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eO3zcCR+; arc=fail smtp.client-ip=40.107.208.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eO3zcCR+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lia5/gYtmH1czui2kN2gFiuTi/y2cUiwUyCaH2skk3aJEqmg3gxLgASAqnXnRlRmmpFwWgQ8Dc8lv1teIb3n0O6CJc/P0Q/vRQhNQVNfWqllSxgMhuO8vYXhnje1WwF4w8m10mnp90HVkSowh00DfgQgzeHX1EIFGrMOUbXlBJlrXjAzk++d7hPdesXLhdnG2qNWBv71yX+AsHEfqb24tW6C80iUhj1p069G+ThM+qxt20wudzXYDvPUE4GdVjaX0Qg3CAqqCDNMeG+JwYJ10TV7nVmQLnTP6kDAMURG334dCE0ieOWSqtSRT0G+ABNHJyxWdslMrysmYNqWoqTaZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Rn2LWZxPRuEiPjoXXEdcsofzflhxcdcuYa/VVBHfZk=;
 b=J4dC9LKg6Y6y5NraEVbuZLbdT4cEeP+mnNrv9mzcp2d9oxzRh88HFX4di24k6vFZLuvB8VpArnHN75Fqpkf05Ce+nH81CMXCvn1pQnuiwqJ2pVME8XF88jNcYWGGzebICI12WZCaz96EnwP5hTkYeWcNw+dNUnSVBPYHCiK69d99pnzSRxs3E5Jq+KvJg87DYHEu2U4SH26HFfgQFWzxBdqPlMM4TI5D3lr6mcTuynRZOu+6Nw8+9MLs9vo3MvyLmYwPaBKUf2B6V9CEgWrPxrwqZGwCWcpGR/SbBv53eB867VnlRtkaVK0OL95QKKtC1rrIsjITIIWxQ95tPhYAKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Rn2LWZxPRuEiPjoXXEdcsofzflhxcdcuYa/VVBHfZk=;
 b=eO3zcCR+F8GUAtcAlRCuAbyMaeVBXWzwFkOMLRe+mMtRqT9r1tBjJQINK0TTJfJqq4P7WZ4u09qdNBL27mYpMYyLBS2bXllzMKFnDMOuPz2HNbUR1jGiALJaX4V0FQcjCWntJBtHidf2RDEZyaTdxMpfoFF6Qv9W01qw1y1QoS4+aK6t28f75FF95Bb6sp2IsgW+O3p45TYR0J4DGffwWptUPVVk7r2WRmh9oc2u3E5K0f4hRUG/HzjAydzOmK54JJL9P6LXb3qTYivgU6B2BlyMr5/hF/knbKYKiWzP3+IaekGwd8kVx0ifKOAiInrvUP7Mq2aNYsxzPcq5DVCMrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 14:44:26 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 14:44:25 +0000
Date: Thu, 18 Sep 2025 11:44:24 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>
Subject: Re: [PATCH] iommufd: Fix refcounting race during mmap
Message-ID: <20250918144424.GN1391379@nvidia.com>
References: <0-v1-e6faace50971+3cc-iommufd_mmap_fix_jgg@nvidia.com>
 <aMr/JyYjV97r+vqx@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMr/JyYjV97r+vqx@Asurada-Nvidia>
X-ClientProxiedBy: YT4PR01CA0228.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::17) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: 723bb9e4-0e1a-44e1-d080-08ddf6c1dd36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zjGg5dr5aj6/ZtjJVuxGVMPbUsyqzPLFETMwpJydhcx3iLPzhzq4GCsXIyww?=
 =?us-ascii?Q?VQMQ863ZuPzoYgeh+JYc36ERtX2HpQD2cDGjgfA/LNtQzfFCnsa1riTrSsZu?=
 =?us-ascii?Q?IUnIk5ep4kgwRpwB48MZy+La8YN4/dIjvI6kRwzBvlTiXEdMhFhiI1Phz8H4?=
 =?us-ascii?Q?aaMZ2ik6FKs6zWa+EG7daDny4x1q1kUx/k8IFeX9xKpHqXgE4+rCacxWLW2K?=
 =?us-ascii?Q?7lPGlNgQ2gxQ+MVHYfOYOMypf+XgfQ+aj+DGTZRAwo9jG61+YgxiM84IPxzo?=
 =?us-ascii?Q?Rm5qak6nZ7psIBP2etotu7TndUUbyZHM393PsVI2OAWxgng1Z2s/VxutiZ+n?=
 =?us-ascii?Q?rEcHQ1OJHu2MX6zqz7wooYdyvTGqoQjQ5AuJTSRDBtMtyq5+M/7FrCGnOeAz?=
 =?us-ascii?Q?iS64RU/HBZxGmfpX/bHcLNozkw4NyQGpLM/5510pfW3mU7vNs/sot73QGDlO?=
 =?us-ascii?Q?fRD0SKq5BfmYXYMvKyb/RiRbHU0vPBpsQUS860fUcGHjM/aEx/Et4FAYhmly?=
 =?us-ascii?Q?zxPJNXv+wiDQ+JylQNK3UQf0YIiZ2nzItKHI8prkaX9Rt5hZhGN3vyRVfWCl?=
 =?us-ascii?Q?N5lrSv2d6kWg/KugavkI0NBOHkrvB44HaurIBueafkxMMM6TGJAWW/f864RE?=
 =?us-ascii?Q?S1545R5gGDn8Hm/o6tXSH43j2RbRqWnB3T/KH3bUBCzAlQe0Gf8aMKMjj2fs?=
 =?us-ascii?Q?pUTKmtabPxUnbMGSg2lEtv2/TbyDXyYsvsMyAUrJjhPMZRALg75E0q5gvX3t?=
 =?us-ascii?Q?P92sSyjkeP1rNB7ZSnPsP8Kr6OzFp5sqa7SVdLvAPq+zlpJBmgHu4TJMoD+O?=
 =?us-ascii?Q?SoBzYBkcKwzOhvXuk/pPa8Rqz/FGxXUpwY4JjUn0D7g0WINcysUzN06S+FTK?=
 =?us-ascii?Q?qKYzzEqqlrLieQWft05EHt3Nv1zm24mUf2mmS5UF2kT3cR2IAU2P1IscC4+r?=
 =?us-ascii?Q?iZavb5+F7AOsMfTsQjEyC6zLYY8nh3mWXONNYooqR0YSGemc+jQ1fPch8lRp?=
 =?us-ascii?Q?Xa/3aWnKi/9x7GOXOygGQ98KqNMiVsYZgezSV1f6eQySIu6HEdgquwqvqfGm?=
 =?us-ascii?Q?QWjUAC9jNuMPM8qpZASSDrJYM35MIRP0c9p443Vw+BxmVAQQkZ1rAseqZ9nZ?=
 =?us-ascii?Q?ZmIkbCSWYoUVC5YV2S1uVQg17afaYufWDwVaZ5oA6KhBc/nNXVG9lr6MqBRr?=
 =?us-ascii?Q?dTBQOMy+2QbuEo2VaTl2MdgItOjkrZepEMPgZjz6to50FvAwT2ysL4GiuhLQ?=
 =?us-ascii?Q?upvjOd3EJ/j2YfIcQxma6mh67d82sktzRF10SlMEMtc0Lt3Gu8UYpIm8Bs+/?=
 =?us-ascii?Q?mtFWfUUbi88ampdZuIBu3JdEkIJg2EEJ4spVQvuvBP/d5O85SRlTpPfdp0ai?=
 =?us-ascii?Q?pRIBwoCANfENYOkimbvzoXkaHD9j5eq/xEG3QF2AV8h9fR3FTXxcZqTS/13p?=
 =?us-ascii?Q?b8unhDLKZzc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tB1Yx4aUO1KIl//r4s9dmFZtiJCuLXR0smvQ1s5heKZo5t0ZbpkyRj2TncBn?=
 =?us-ascii?Q?VfmJf9VljQ01YlVcPHoNX56yBmX1QH7cxjh9tj9pQiKuDcd4TiQJ7ZKWX8QZ?=
 =?us-ascii?Q?VgYisDUJveeZast8VtIebIE3gkamjnsz4bHEOHDWYLsRnKdAq8rHLmjX42QW?=
 =?us-ascii?Q?05ZOmKzsDZiACFYVxx/8MfWyivoXd0nWccek8NLeoA3XmGL/3AL6sZwrNWh4?=
 =?us-ascii?Q?I7+PJNs2Nkow9+k45P9Elmhy80RNx0hCVmGq23YcM9K5yNV05okCUp5nlA7B?=
 =?us-ascii?Q?o+8Fv45LV9eV1tq4SIPDGSUXvCTm4X0vF9FDpUAVPumQlZS/2dDq3HhKkpFv?=
 =?us-ascii?Q?iKBImXWLR1YR4291lXdKlTLk2U6HYhNfeiNRvwqS9LsWfhbeACYLmBvGviSh?=
 =?us-ascii?Q?m1KEI6k7WVE7/7kfCzbH7dL1QdRIwAWLJkZk7W2hKK4/38ZI7aZGbpvizqCp?=
 =?us-ascii?Q?1xZbP9zDSPPflaM02mnZsq6tiaYiSsVP83TZGI+O758zkNGysLfrTrfp3eK4?=
 =?us-ascii?Q?JhARfgye/PuaSnkQpdaSgL/9y2l8L4QgmJQb4COE2BJUs2YQfFqxVCg3l2aQ?=
 =?us-ascii?Q?IWIzDK8E/SQT0oGxST4MSF/3Uzn5dOiNg4ksZ41/XGL7cZPSgR6Pms5vsAhX?=
 =?us-ascii?Q?L/jBduhdLvRQYkLho7zh0JBQZQbtS9I6mCrp8pNGuikbtECArosgqJ61P2XX?=
 =?us-ascii?Q?LnWStdiyhOWvHszn6pnJ0M+cX3wefS3zx/aPYNeSkt1Ni56+YbuEzFFhC1Po?=
 =?us-ascii?Q?9/YniJlLzYr0OlBNxzXvy7MYGLruQ/uLRChJPR6oZmGTpXW+gxQTb5FcdbLM?=
 =?us-ascii?Q?y07ZzWuXUkTzbrVljCgjVEZmfdI4Biz52+9Ne+4KICzuGgHqK9osghARAkWm?=
 =?us-ascii?Q?65DdGr6CuOElP3onzW1QonANaPCL3tABJXJqriNPyDMmE6lcCIYgi0q/NyIG?=
 =?us-ascii?Q?RKpCkDUfe7wRLFJvcnwZNOerRZhWrDj+277odHv0jOFtTW6XX5HgBpd2gxBJ?=
 =?us-ascii?Q?YZYJozIicQwu8nf1i9DCMvMw/mLzK/yTGCxFATCrY3yDOqgS5CqKeNC7vQAH?=
 =?us-ascii?Q?YYobpQv+VrikaePCPbnQcU3xT1hAu252MvlK8E4wQgp9SJMQO2wx7/tBNign?=
 =?us-ascii?Q?aYKIMBerUR8dm32ly4kGPFXh7bAy3zSswArkS7thZIqAQx6qHTzJl7gTEfyL?=
 =?us-ascii?Q?2WZvdIW2mL7a93xD2lU9b2uMBQ6p9T1iix44VGSOT7gAGrjt7Xjx7FZ1/Dm6?=
 =?us-ascii?Q?moYFDaPpp3cXJKSinU3mvwEy9VGeRx4k0800fIIW2oYK8pRv7EttoEnn6Fbw?=
 =?us-ascii?Q?b1+KUqkl+WrNu9ebbr/aWKWkHwO1pddeK8Pcv2IokLkb2LBqnLVHrTm9Z1vr?=
 =?us-ascii?Q?h/m18yHL9FWefrx+Ikg9FhNvD21MwBXeb1Y/VM6hKIkX7kBOATiPT9APOmki?=
 =?us-ascii?Q?AcbXl2SQDg52MUpbaCqq1K+sJAhccncGgntM4PaIIOZw+HZVFS2vBRIr9mNR?=
 =?us-ascii?Q?sGnTuWIfkw+Qmjb6GH+2gyQ9C2SWYdOVdcL1uhWH6scb2YK5ZF9zAsrAps3s?=
 =?us-ascii?Q?I9xzYRRfZnpFytypLtQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 723bb9e4-0e1a-44e1-d080-08ddf6c1dd36
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 14:44:25.8689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uib6gvbW53v2ZxTu3hxaohb1JnkeMY1c6u0t09SGjsi6w+mJ4oAdGzZaw8ZpnEFS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

On Wed, Sep 17, 2025 at 11:34:15AM -0700, Nicolin Chen wrote:
> > @@ -551,15 +551,22 @@ static int iommufd_fops_mmap(struct file *filp, struct vm_area_struct *vma)
> >  		return -EPERM;
> >  
> >  	/* vma->vm_pgoff carries a page-shifted start position to an immap */
> > +	mtree_lock(&ictx->mt_mmap);
> >  	immap = mtree_load(&ictx->mt_mmap, vma->vm_pgoff << PAGE_SHIFT);
> 
> Nit: should we put the comment line closer to mtree_load()?

Ok

Thanks,
Jason
