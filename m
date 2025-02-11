Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A1D1E570A;
	Tue, 11 Feb 2025 18:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739298104; cv=fail; b=GHAgecEgwtFS6RXczLt3VMXRzUSiC0Pg0bEkTvD3S04hD4g1VMMjwAS63JF498Dq43ggF6Fl83v09OGyLAzyMjEl1+bKWKHHvFkY8p9Y4QFkK2YoWnDufkLNybgmVlP6Kty264LKTxLTewBRVIs230XDuFisG3iHpdQ1OLimMRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739298104; c=relaxed/simple;
	bh=cJipYxyH30Evibt7zPFzHQT4VpP19X6oBqyHyP4vh1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HcJI62nZtn4w0rqFsGqiOWj6AUxnkFBf3qGRbh03ZwYUvc6ePAb+ob6rBA2NI+tNFbXPbFK3o9/S98PoIahDqHbvPde/7ss4w5J7jZN7/TosSs7lZWq0HI0th4F9oqK3spYmnyvM3NGQ6wwzArC8W4IekEPZDb17lWIa0TYTf3I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Keyryklj; arc=fail smtp.client-ip=40.107.237.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Keyryklj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xb4t3qvWLnh+hyD0QoyVIdSJx5Az7OKnd0+ziAP8lnXa4MglQAN3SpQLuB+mVMFZLme+IGd0JAt87BngTwvYCLuEfnsZ6YdoexunKG5AeW0fB4zq+LHgJlAGlJ9nOJ7Z25Nv0UM6uF6qvwrpdDb91RbVznaaYMY+796snevWrfmTxo/vr7zYoAWEGQbsRE/1a4Z1sHqx2pCPqyY2zfkrMk4v+39llqziwZ38tl34l8MBRcEKIKncI7kwURMoPPCroTjE/SS6Hts2mmuMPs81vO3UNlun/cyEv+i/FzBbZ2M2EpNm/NH4ECCCkXzfOleYNXoIAqDJSfU00mtrC1RXJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pokj7au0Nyocu++aPN6Y03NU8FNneyL02u2ra5i8Olw=;
 b=AO/mdpDCv48I77uIBlE2wckDZk6L99/rkjvPpoWjd47/pISmGRddOwjXgQjvi6IeH1/Pqd9Wxp20q+NyFmiXcgB99E+wlKEyAEf8G5yrr04AaVoE4HsKiBc3+RQUl4hvw3koOEswdPjwjCCEe3No9SseGGKRYqjErrT5CFLVgpxTDRboVNl8ph9zWt+vlMk41ir95Ny42Tv7HPLQ8tFWXYjiUQCP9zBwYMIILVgCgC/v7+rnIWI3i5mPmcXm5C2jBynpMLjPd4YROSAThquZGFYmbdkn1OEHH4NEK1I4OvCqlaaShfAWXCHzDQ3ehElvjWKjHJlNpMfEUMnHJGZsXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pokj7au0Nyocu++aPN6Y03NU8FNneyL02u2ra5i8Olw=;
 b=KeyrykljASjlqrTW5IBTlcc4GCHOuD7O/hEhD+vRFZ8PK/CgD7RhJaFV/oHBLo4dY7ZPCHEaaxWRQHHLWRVTARXnQ9J2wujnJCTYE2vG2YSVzNhnBHIEXqYElsV9S4RErxbjABfJxLLu37Fnt9fZWet3RMO5g7f323dbpnoXKYZ0aa/gF3+C3eY6zKEu49ie8DrcajP58BodiW3vxIlsO0xj0zZKxMqBgZpRv1bBOUTcCRWnSf4UPNDo2EqBsnIsmIbIpRSAF/ZY0LRA+5XreYkFEazBzPNa2KVuLDvJbTjQUS5Z8V3fbdr0da5BFXKsbZQpw6xUOZI8FqMJ0BJkuA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB6921.namprd12.prod.outlook.com (2603:10b6:303:208::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Tue, 11 Feb
 2025 18:21:38 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8422.015; Tue, 11 Feb 2025
 18:21:38 +0000
Date: Tue, 11 Feb 2025 14:21:37 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: kevin.tian@intel.com, eric.auger@redhat.com, baolu.lu@linux.intel.com,
	yi.l.liu@intel.com, patches@lists.linux.dev, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] iommufd: Allocate attach_handle for any HWPT
Message-ID: <20250211182137.GM3754072@nvidia.com>
References: <cover.1738645017.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1738645017.git.nicolinc@nvidia.com>
X-ClientProxiedBy: BN0PR04CA0194.namprd04.prod.outlook.com
 (2603:10b6:408:e9::19) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB6921:EE_
X-MS-Office365-Filtering-Correlation-Id: 909ea25c-ea7d-4cf3-c43a-08dd4ac8ece0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ItaODxO0qd8tSQw00bpYE7zy0qc6Jq36QdY8zYpq11PDYYh066DRvTu1Wxu7?=
 =?us-ascii?Q?pZwEU6qyktB0o+KTMadhVucTIM/85qSpxOBaI2wcJQ3pZbW0AEEMKZspdhOR?=
 =?us-ascii?Q?Pw4geL8YirLPwtSxQX7CDgR4rxH7Z8PyBCCdc49pJB+LbfoeXlacvApC7SOu?=
 =?us-ascii?Q?CBUmKiM9gCt1ARrlVt/I8cHHv9jEKa1NawiR6nTfUMjOg1tu8H5StqXom6aS?=
 =?us-ascii?Q?EXyAMCXbGTjWssjBGuugq+nhDtgepUWK68QmCYOGmZR/67ixKYal5TYyHfy+?=
 =?us-ascii?Q?dRtrj4mTnehs2kLL66US0OPMzsJBuR4Xrlj9+PwvyNzVDInO7W9630Mau8mN?=
 =?us-ascii?Q?rAzHU7tIFJl3dnIG0CrlfTPLIP7xP+KSz+G1vrBwS1OBZwqlIXDbvVjeymxK?=
 =?us-ascii?Q?z/c/vzz1+y5R2Kur/D7XmwByzBI0m1cXfiTCBrFY1+Df/hrsTgrchFVbJja1?=
 =?us-ascii?Q?m5yVEouyX1OznUVSfAlw9GDbqwKGVNL+6xVpKNPz4YUi7gb4+ww8JJx7UHWA?=
 =?us-ascii?Q?U0jY8zJFuduLl50JIPdk/oVQjyni1Avmh5wZHgZZRA9ZM0lrEMC5/a/SQ+vQ?=
 =?us-ascii?Q?Gfxsiv7Oh199OikoRFKYnQg0uSCx+Razk9GHKIiowXQ2+DZvd19b25Wn1hvv?=
 =?us-ascii?Q?zs4zOuQ3IwgwgAyXDmfQBWwGMJf8cnUJx1tSW7bwZu+kaNyKXVXlo4JC5gGY?=
 =?us-ascii?Q?16aenW2T+GxV40MCqim89qtA2XxCrqpq4LFdy6tnkDudahKSRj5W2yy5bHVo?=
 =?us-ascii?Q?fsrO+aQP7Ceyf3/6T61iizOq5rfpsEZjFBGlDt2NFpxUh9tm9weyFrtj17uC?=
 =?us-ascii?Q?EsRdgmoKjbfUGfwLSuUo7D772juv31nfDiUqAbx2L8eI7VCtdpoNebYxZF+r?=
 =?us-ascii?Q?406M8zNDgAdtUhoa1VHlpEniBLcC6erMyspvzaQPRwgH3l68E0GSDaGUeRHg?=
 =?us-ascii?Q?9wdhNUHjIhifmEtdnkh5Ytq4yIRIzGegBQMWgV1LuLeJ6FTsW6dI0L7u4IHH?=
 =?us-ascii?Q?oyuxtCGLUcv5S85/Sevtj3c6jEGgd2mPBmldH0x2IGJJ4XMIOBycxN8GCSb/?=
 =?us-ascii?Q?v9jj8+LGk2hobZ3iQLp6/WNLchu3QeL/Gzh1C2NDuLyrkiewVAjVVJ6Z560m?=
 =?us-ascii?Q?D79lp19J5kBmFU1SxjH/9FhKYk6sM4C9rwGU55ABI13xXHggcnj6j++dBDU4?=
 =?us-ascii?Q?39gNr3+jrKr66rkK2YCMBNMMaNGNv/tfH1/+GRKYmKGDvrPvNGKVuSvX3tUc?=
 =?us-ascii?Q?oji6vsFYOMipdl3UlvLT9Sa3p8XjwoT6Kp4k9bCdmLQ6ip8We16kQFA7grcL?=
 =?us-ascii?Q?4hJhjIcdflOpiVCA4A1siIXR5aqX4vqUdW5jrje2Z6Gt9g5MjtPPeXbmCex7?=
 =?us-ascii?Q?wcw6fNYm7dPmaO+A5ezz9pP/tKw5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lu0FhY9U0Km3vvt8uLyK0Vu/m6VDxvS84QVYtzkh+qxFPW36TKUUIr3Qv3ze?=
 =?us-ascii?Q?+f695XdDtQlrFqBu+VFSrQ78DkuVS2no8+tAaSQUZMphDafHiUTR0VS5lE/U?=
 =?us-ascii?Q?WYEEhoQXcU2PwUn3mNuE8haMYE13q+6nLhbETan/zBb6Mu4AvO11rF4VmzdS?=
 =?us-ascii?Q?Trwzy4Sm1DNsAloVpI2f9wTWrlirDQNFeUZeeFKm26+x5RAA5LobeSnTOL3m?=
 =?us-ascii?Q?kKZgvE5PxlTk1f/IXIgv5FAFfNGe3qZwQS5rpT3mUldZWKfd79S0S6SRQZdC?=
 =?us-ascii?Q?7ZIaOnNcS+aL3AEmwrOmTq+EXFVxfKRy7nlJAqHcGhT7XgxQniyIGEY+3w0y?=
 =?us-ascii?Q?VKX+9Z2YjUsqPL7aK4j3RC7x6irJfqiCXSnBQ2OtraHjxHiMnnsvmA76Xb8i?=
 =?us-ascii?Q?dw0t2MF99lLH74OyXp/T6fw3N/yqHQKuDCIW87h9HP8e43+Esvr7CeWNSBMm?=
 =?us-ascii?Q?fP2RhHzYP5MoHo/6+Qf+AhvUmhMCicWPLPfnQxVuQuafsDqZdsBZYvw7hdf6?=
 =?us-ascii?Q?Ts+CmIGhAKCfiGuG+bOiBiwZ4v/MPnxKaVCPH+9r30EbEUTmJGtpTxMEvkev?=
 =?us-ascii?Q?rnt1rOvKStNhSc/83CHqk4XAkQ2kn8EYoVRZgPIFPe1O+N0O35ueHhotIAWg?=
 =?us-ascii?Q?LWV38P1H2iMy0nTkET9iJuKuGW0jsFNfGaaVSgjNXfEv3AIDwLOirsxay0A+?=
 =?us-ascii?Q?IrkSrG19xXLL5v1LI5GzVWVk8JmXa8isSvUdzGzCF/3J2hrBzj6JIZcccZJW?=
 =?us-ascii?Q?nnTj9lW73syjs6KzhT5nxkERO/UY5qWuLvSko0ED8XDkRNbZ1fNvS4dx9L5V?=
 =?us-ascii?Q?RQJULpw38tdmyXcKknNKh0xuHrFKPJRBoWJFaiYKTJHvTl6NdnWn4GPw9W/o?=
 =?us-ascii?Q?4bYQBh1EUXyhA9EVn3lU/OQHXrL6bRj4cWJhHPIrcCchjYvs+ONnvGdTeSv6?=
 =?us-ascii?Q?w/dTV4LuOnjXGibsKHH3xncnQec4E2pzR6NLXe7DaxZNBScZsAR9SBzqlM2P?=
 =?us-ascii?Q?Lodp/25uqz2Y6D5afeyvHh03k5Ms6fnXXkg4Bd4oQg5Df9ksjEO00uLyn7ME?=
 =?us-ascii?Q?QeCy4TXQQvT7pYtBUJwWRFAMfVcc82ESrLMNoOP0maJm/FxQ0yE0YEuV8XBY?=
 =?us-ascii?Q?xyMCWzaB+I+BhoM0Ye84IMoii2mEQ1lD1Vur6PjLYsPSSRnjTl3E6oICQrBR?=
 =?us-ascii?Q?L66OedvKZ8CFLTrm4CMNuElBEtbVI8sGbUOTQfgShXtpn5HW/vmGgmIpvTjd?=
 =?us-ascii?Q?vNn7t3ehOuQN5RZCJoHHj6CIl682k3RDX1sFW79cGFWpvC48+jl0SDklJ+vr?=
 =?us-ascii?Q?MB5gVX0W9F8oEtjUiYlo+87N8MAFbRU0TYrZjfndwG63ExBTccSaq/2ROx2F?=
 =?us-ascii?Q?5UnApnvWColyLGU31agshZeJZ4LOHvSBfxP4fJ1zlo6xzxloDwnSZ2fp8wE4?=
 =?us-ascii?Q?BZRSKEIoYtpZnF1czStMdd3nhp368HOh7Y4xDVgEQMlgeA7Fsd3iOgyLPIFh?=
 =?us-ascii?Q?nqewI6Z1aa1QTRCdtGY8QigfknzZbVYxjDFItfxfJ2lPx7OXRZ9gI+6sBTix?=
 =?us-ascii?Q?ip6ZWQMBlQpA9+6wFtE1nPOdoU6hoVnbaoKcPT4s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 909ea25c-ea7d-4cf3-c43a-08dd4ac8ece0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 18:21:38.6503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A/fm0+5WDOXU/yz2VhV/a888n0zQJw5cN++eYz92vHXdzmUD4Ve5srKJ4Ygdg/BT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6921

On Mon, Feb 03, 2025 at 09:00:53PM -0800, Nicolin Chen wrote:
> An attach_handle is a hwpt->fault specific thing, so the fault.c has been
> holding a set of attach/detach/replace helpers for attach_handle and iopf
> enabling/disabling.
> 
> Now, both the iommufd_msi series [1] and the attach_pasid series [2] want
> to reuse the attach_handle for non-fault cases. Rework the attach_handle,
> to prepare for either of the series. It should be merged with either that
> gets merged first.
> 
> [1] https://lore.kernel.org/linux-iommu/cover.1736550979.git.nicolinc@nvidia.com/
> [2] https://lore.kernel.org/linux-iommu/20241219132746.16193-1-yi.l.liu@intel.com/
> 
> Patches in this series are from [1] with some fixes addressing the review
> comments.

Applied, the other patches can rebase on top of this

Thanks,
Jason
