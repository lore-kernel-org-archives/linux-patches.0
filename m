Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D0A17BB5;
	Wed, 27 Mar 2024 16:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711557443; cv=fail; b=Zzo1MhzlMx/w+araW+0kzu8MZVCPX/FyqtSMFASk2DMFftm0PkAsSfWzCc7Jc91gbGzM57dCsvoHlRxArTGGy3qA0gC2zGXIK0Nx6VBLiNfkcpaiLl8DuR2fAa5/NVfY++Dt9GtdGNkvVejWfXUDAN20Q+jy6aNGTE2fiRUMiiM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711557443; c=relaxed/simple;
	bh=BLJ6gYL38ZCVAfla3OHtGOCTkzljjD66/CpblVHQOiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RYLBaoKugDJNuqUmYda/7PBTrcDb2LhOxg3s8M7iigmSi1hHj2noueNFKBJqOwdJFUnx20OPDVI+8u8HQcpIDN55hJuioIpdpkumCRSKyMLGOzA7SZruJ5sUGPo/GAm9TQf5oZ43qOOBMTFJ+8QwkVzHomR9d3CC9XlpKOMbwrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rOY+DKZN; arc=fail smtp.client-ip=40.107.244.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rOY+DKZN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICIIeVm+neTyXJY/f8U5Z0qgYO6UpQZXSZvXzoshjmkyc8DR3efmPJ0y7Oy6oR8gF2EicmRsGjZ+bWrcbtYRv/eKTTSushTI6H3qyTZQ0zUIN26DC9aXj1KpFtDdlQyArADeOK5NsRrPAOD1aRAb/Uxt+OzUItebaMZ31+vZXvlv4jzmNnSNsCaCFO6oXefaRrZSCfnkV7za796Wq6asDEKulWPo99La+NwF8H3xcXrRjfZHnOyFeVf/e2zPMFUidNiZv4ZuSqvhsmqfNU/qrYHdovsoGabXyFbqQDUwEu2MPTv4eR0uEkVG2RIoEwoIQ6iY+NS859YxAbl/Hcx3uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=elyhMAs4f7pfGHzBk7usKsHGaqF1F2Ejd3l2u5vr1Lg=;
 b=hDFAuu7agVThK2XVZER66WtSko0s7q1XRhJV94iKMRddE/UyCdJUDFqqK0nfUVAErcZnok71jRi5vbtZduL9gVBg+pY0Sqv+4OBLTZ6IEivNBGH3PtROTYYtlzu6QTUWqicHV/sW7SRzBJOYRajUOZyV/FEc3kvgDH3kbAILvnd3tLyegeXQoXYp2GXz1DR8azMZMauYIMeO2hFGAs5RfCG7sBfHaQQzib22XQ8rtO9Y/oqncunWEreacrOd5dLocinapJhpqbGGsfUGNK+RWgcw/kgr6WGQ00wn4gknATW6qS00aMrL22koFHPeXnQKYIMRJZBXnH9iqO76tPrNUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elyhMAs4f7pfGHzBk7usKsHGaqF1F2Ejd3l2u5vr1Lg=;
 b=rOY+DKZN1H/4OCJO/xkKU9iQsfG28sworiisa20QsclydvzSZGbcWA8mVFI1CxhR+IbSV6P7pIJvEfZyiRVW3IP5/PqwFoJoTJNfPG7bB7pLsqIS74CmqFRDXaTXt/hqKJYhUYfVLAI68X/nu7JTEkdaHBNGk29uVRXHZCjEM6VZda11M/EjlgBWAS1gj4l+ONS+JMXg+IbA9uf6rJ8P0jPJalroPl6Fsze6AxkvDytoytrVJRPlx/2FfAkv63gAjSyDFbVj+soqZ/EoxkfzG4TAeQYO+gfzwH4XzslWmLVVafnI0Gjg24gnNOMsLWefYoGZ1olUcGT2dRJjFnqULw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN2PR12MB4253.namprd12.prod.outlook.com (2603:10b6:208:1de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 16:37:19 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 16:37:18 +0000
Date: Wed, 27 Mar 2024 13:37:17 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev, Tony Zhu <tony.zhu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH rc] iommu: Validate the PASID in
 iommu_attach_device_pasid()
Message-ID: <20240327163717.GI946323@nvidia.com>
References: <0-v1-460705442b30+659-iommu_check_pasid_jgg@nvidia.com>
 <f613ef00-fa57-4122-9bdc-f4b32a14d480@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f613ef00-fa57-4122-9bdc-f4b32a14d480@intel.com>
X-ClientProxiedBy: BL1PR13CA0261.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::26) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN2PR12MB4253:EE_
X-MS-Office365-Filtering-Correlation-Id: bcb7fd33-99f7-4d50-d7e4-08dc4e7c2b0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Ri5LYu8v6hHi/lzV/jV/6xKFuyqAm1mtcQ/6Wj0VUFopO6ljLW3SMWW2G3nZfAwFRL3/8OyOXMlnTrspJRAxidj2EVhZF+lSIFbLMm4AKKkXkdqgv7FpA/rvKND8VLuwafQSHPUX/Wf8Cg1Df3IQf+eg2h4PB7M4pybBDOiSukalsN6FLY9UPAQo9p7RrTWOXTCIjzgmXPSCLGh06Ir+CWg4sDR/RL54Q3ROpNGnRtLD9iUW2m2kAhMyhayXxBvfr0/oum4nm0pBuRMUGnQ/56cSIv9Z5I/oVzJrMotrRznTl/3jwkEYwX6+fF8ooUyYIQHedUFpGNnFUKK8ogOzzMMDoH74j35HgwDQONVypDlcIy9e1w1oCrm2D9ANVDU5J+kY+hfX+D6lJPOVGzmNxkfFK9h8gVodeNidR7t0TqTOlhFgJKfUxQIo57DkR8Jg7NzOtAOrq+7jj/7GOCr26yzof/fjNb5mpcJlwxDXs1PIURjhTdLfyc0lQib0usn2jmrqsx1vjJwIu2yarsZFkFDW1eptdOyUNoNxecxUx3ctjxBbGr52C5kaTgp3TZrPs7xZ6RPFoQGq9VlCBgjnWDGrY7zxbXYSbO8qpGRRDbwGQVlKJqz0e//eGGfGMkfCwRwFBMGNJvkKHlln5vROrHmXQFcR74u3NqDmwFgIPvw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YkJ1bGonQtSvER+aHKsJnMkVSFQINra/NbZqncWwY3sz9++m4D0FFI2a5Vpo?=
 =?us-ascii?Q?HuFdmDb8AspMpeFiWqLzyKaozEOwmmMDNjwvM9BXzOZNndf5nxhW9nQsN/Bw?=
 =?us-ascii?Q?Xr1XKYaLEkBVqCZLjXhM7oQEeZmNMUKRTHXe53gvXtf+1HRISd9JXYv6Cfl2?=
 =?us-ascii?Q?6ZXND58gF8VWkBpoX1RJ2EHQQE1fCPLxG9OtRFgwI51ZnotR75pVbIEGRsOV?=
 =?us-ascii?Q?jdEh/6Pi3MC9Mn1EHGBi5rKTrjiXXNyQMDP05F3sl1xKFTVIGmlrISot8XjD?=
 =?us-ascii?Q?5jAgvMw+UWmtgpgIT6NzQXXTLTEcBIaweM4C2hjIn1Zu7VcDBPRmS7NAHa4D?=
 =?us-ascii?Q?6jlCF3Bgv48ymKMbsvizrV2uK9BQ3P7MJOZzpfGDhNazNVFbQFPxGYUa/BUH?=
 =?us-ascii?Q?v16/0qE2Oif+uo76CocyFbdM8c0CPMMLAH7b+aZ7bbvL/jYJwvxgimKSkg48?=
 =?us-ascii?Q?2tWHmtvfHa2CFrDZ9C0RKiacj7Ahq/wBZc26judU/Jc8stw377b0J+NTzjAx?=
 =?us-ascii?Q?bSOUylJkWMnDxnw43+jFVxFLH4L3Hun5UoAK45h6hgOaK66yYDCIG1SeWMIX?=
 =?us-ascii?Q?+3diSg1XfTIU+XmfUrfhUxuVueodT6edPOAvAFlZ5Q/cL0+feTh01sJtwY+u?=
 =?us-ascii?Q?aBob/KNunx1en2UOy4whZXj4hLM3CCLM1ZiEHiGsm70nTN9XJD1HDY4iLYQQ?=
 =?us-ascii?Q?w4JckAQX4JmIBUAnmohz1niKIpeNH1MuQ2b+k8oWtkxjLg3SJ3iVJqVMngUL?=
 =?us-ascii?Q?cDxQxduwZvAyrvun6w1Rzocq0kkRqr+CvvqKZ5WAcav9jCi5uD5BKAfYS1MZ?=
 =?us-ascii?Q?MXbc2Vylp4DgcAEIWFIe7DhFYidTx9gj6PM8xAeGR0dj6ULQLbQJ3a2sW+nu?=
 =?us-ascii?Q?a3oLTQlzu+MHWLJgFrQpx27NCzNoJmjHlccHT5sno0UIQLfc5HHEPB/cHaDJ?=
 =?us-ascii?Q?1M9OFscWS2nUz37/QiKvZ95AocCWCvmKUZ/6zXuNtfMAQMezyTc+dPE3LGSg?=
 =?us-ascii?Q?3YfSXIpzyUoBUQCz+dPtYUsDOGyVRX4bYE9dTSunNwRh7MbYszxz7+Dye7cT?=
 =?us-ascii?Q?NTI58C06+6aDW/6ZV+0YG4zpe3xXtiqHGqtCA/GqA3t08TteaYwpDJzlKEH9?=
 =?us-ascii?Q?PnptHwQbzI7dDtMFZ13M3KhLsfy8KqIuB9M8t3/IflojA9j9yp3fKBL0Wt+Q?=
 =?us-ascii?Q?SozMmSwcKMhVUNQMfRToBAWiur2sI+Py6/jmM2HLb7eIETx1BhvkgS3tWwq/?=
 =?us-ascii?Q?Z8/sUCfcyNYMzADWBj+4RRjQCKEgnItPt5zPx18WTtdkkjPgcCWoTZNZC29r?=
 =?us-ascii?Q?AW0bxvbyFXP1JS2qss4NLwLYaMk2By85Qi4g6ajMc//WzlLlYOMiFVkPKrgZ?=
 =?us-ascii?Q?hzDzrOhDwnOF41p8W7MNkZRcKM3GH51BRKr2lwRZh28XenzUehzocY3wCGrQ?=
 =?us-ascii?Q?va/1putSesess6btoSqgVCJkrQqnE2b0KXUmrp/9OhH+ZHZUGtzsnVzK9rtp?=
 =?us-ascii?Q?vC7O21A4VfXSSmoTXLHeMQOyo2IaTg1CF2K8LGSmDuIyysIK+VzIlj56JUkg?=
 =?us-ascii?Q?VWIardqucWrktg98nIK8mlwqsTPZDDFGNfYR3Wu5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb7fd33-99f7-4d50-d7e4-08dc4e7c2b0b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 16:37:18.6067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DifXlu4mZYLoNl9NmsjVAQX8BFcg8CXOeIBAn6d6cBIy2u2+JneN4ZZXRSPmrG0z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4253

On Wed, Mar 27, 2024 at 10:46:35PM +0800, Yi Liu wrote:
> On 2024/3/27 21:41, Jason Gunthorpe wrote:
> > The SVA code checks that the PASID is valid for the device when assigning
> > the PASID to the MM, but the normal PAGING related path does not check it.
> > 
> > Devices that don't support PASID or PASID values too large for the device
> > should not invoke the driver callback. The drivers should rely on the
> > core code for this enforcement.
> 
> BTW. how about the iommu_detach_device_pasid(), should it also validate
> pasid?

Ultimately detach should check the xarray is !NULL and the xarray
entry cannot be non-NULL without passing the check. That is probably
something that should happen in your series adding the domain argument
to the removal...

Jason
