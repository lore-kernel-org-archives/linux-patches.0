Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2048.outbound.protection.outlook.com [40.107.101.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E58A209F55;
	Wed, 12 Feb 2025 23:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739403060; cv=fail; b=XQc+D0/GvcEy2LwzSlZl17sggCx+fQQ9SfB6nKzQM3mR9eUwVXZiV4SZQA6b2wkO0+Y9V1kT2e+kYdvxK2yYmbopOmhhFppaMION8X9cPp2eH7kao1kuxOe69nAJhEVxftj3o5m7zd8RShfrJTtaZbrdar05VI7E3DCAj/kn/Kg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739403060; c=relaxed/simple;
	bh=2tplbflL2przCGBbAGZMYGvgnGeMLPPHMGMU3JICa1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=J5w8ghWmBBgN5F80HPFPzaMEUL0Adh9bCeNvnjUneS0dyVj6PBurCnGiDzC0jtgM9qG3AAbo3XsnMwHSs8kMr6d+9Wqky8lVDTvPhUsEpA6wuxn5kOarEDwPf0EN8XM01yigp6IPtm16jf+leFaT72LCtxOqyOjEM4CyWz4XqG4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b/z4H7VO; arc=fail smtp.client-ip=40.107.101.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b/z4H7VO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J7SalfDmDaFttdR9qTZoBmolsUWIt1HkYo7iifbj7Rk5Um8krvt4FXSpwGjMSoT7q5ORULB9FSb2Vmrwbj6l28HXC9V4Ib9f9CYit6ZeDo5vxVtNjMickgQSBA0WxE3lwjyQMSs1Igj6k1zlSzTLrhujVOvyDoO6+e1vcfw24NKbh7MO4FsHn64htwlFlhhB1ZJyo6uwA2Fl/iv6q/JqqNL40+ypXDBoStY9KDjlXm7cwZY6+dFVPil3lt4rZhaLbyzDU+09YhF/7jCPIWSka8AmqUfhDJH3e667epB6Rt5HEqK0PeIRS49rxfYmdfhqzM8UcnPgpdzBHnSpx57KfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2tplbflL2przCGBbAGZMYGvgnGeMLPPHMGMU3JICa1A=;
 b=R5ivndQ2GpWo9Xw6ls7OhkWyTeZmrgEIhtm95fooPZQH6LIkdtyJjWi7yYX/MKmTuIEXlpk5oQHLkJeinZ+HlIABDbyzW0+t+XR/eJ3DUtB96qMORchpVsFKni9fuy+T1HvUXweMVjIfQDgwITPMxu0MyfuMGi6/lKTBpiBTbCaJacfsnYnzGf4LaUgk4tlqzt7CnV+ibKqq4l+4g4pRWeVNcbrWRXc4eSoCUuNtjr/O/NL9cC9Oa/n8ikYu//kCOP1xHYRZ6utVL4Ohmqterl/XG/tAoBwiqSQFb2XIlWMwsYpbaM7cIpH5eOryF0Oa2DgxBrRLWyIYxfzxnG9xaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2tplbflL2przCGBbAGZMYGvgnGeMLPPHMGMU3JICa1A=;
 b=b/z4H7VOIHL4+pg/mCq2eUnRAW8nmrZEeK5SXTVNsA3AnqYf0RDd9Psj7JSrihtBQ/xr3bhcmn8dUgCOgIANd+6X4nwBuKw7mY5MA2H3ZVLoOmzdGuRml+KYXEeu1rKjHzG2r+hE0cPvtPua8fh33wyVvW/xASH/yYl0pPkgXpuYwWV90L6+1rf2sMoDQNFd34fEmiyIN9V0Ev04xVkmDvdti9yXPE0wfC6lunuKwS9D+SO8AHEm6HcGrBmgmsrudTogdrKN5OdpYaw6vXJE5lVFs5S93cHAJqSPwADj1UldzqbI5zsun/N0UwSwWvKPDR2mEfkCFIwxyo6QMO26cg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA3PR12MB8762.namprd12.prod.outlook.com (2603:10b6:806:31f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Wed, 12 Feb
 2025 23:30:55 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Wed, 12 Feb 2025
 23:30:55 +0000
Date: Wed, 12 Feb 2025 19:30:53 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: iommu@lists.linux.dev, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev
Subject: Re: [PATCH 3/5] iommu/virtio: Move to domain_alloc_paging()
Message-ID: <20250212233053.GV3754072@nvidia.com>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <3-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <20250212112235.714b0a14@DESKTOP-0403QTC.>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212112235.714b0a14@DESKTOP-0403QTC.>
X-ClientProxiedBy: BN8PR15CA0045.namprd15.prod.outlook.com
 (2603:10b6:408:80::22) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA3PR12MB8762:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ae43bef-f481-4acf-317e-08dd4bbd4bbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kTHE+PImLNZ7T710SAHwtQ3xmHHXR/D3L9Hmdx1e+SRP0xR2cI1L4rz4dkME?=
 =?us-ascii?Q?PUzB2kEX2ojhbjHU/b9TgYnKUKzsy0bwXwocowupX969SrcUe3Ei7eibFqWx?=
 =?us-ascii?Q?Ip4Wsld4yE4mQEA0fxnZMLbGMcTAbSV/TDCEOidIaKfzxQQrHXFGKGvvhPF4?=
 =?us-ascii?Q?ny34aUPFyeotqWnuuCxcbD+ge4ZH7pDCuNNuvyet3Y/hsaSH48zcEJuOEeAT?=
 =?us-ascii?Q?PmaqtoJdWUAv2OG/2uFuurrctfQFflBSwtA6Vk1xqK+12VKl9fakiGXJdk24?=
 =?us-ascii?Q?UWGiwmVha3KoCsf/KpLig73pIhbWXaISWaQ6V7Qj2Wb7JZOxnshnXEW0uwig?=
 =?us-ascii?Q?VxXOXfBmJuhAdg7vqZcl06/RDwG1wnaYkhc+2vhh3QM1gZEZ5XL3Q7DMpt1k?=
 =?us-ascii?Q?GNBSCKbCGrEC5vijrpl9gFeg/oam+iBmGSo0DLNKoWFYvCoQveC/lCqNnMBD?=
 =?us-ascii?Q?amH5hC00iH+zYBDTXeO0YsbNdyNam5iD1Eel3wu8RTF3SSc9t4hzMRjwnq3b?=
 =?us-ascii?Q?5uh3NtxbdyGNt4nY1sLAG9oa9QXmQHa/3lDuh6X1PLmzTnwuH1aU3l8er+dn?=
 =?us-ascii?Q?Fd48CY6dN6nuQ94rv9Kwr+t+f8EvrclMozXB4sHljvFuZBfeNzP9tQ4l2W+B?=
 =?us-ascii?Q?dvOQfdMf+0iyYZlMEliWQU3OshQ+/+JodUZsTM89249mlRER7ENbMZCDRojw?=
 =?us-ascii?Q?9Tev9prt3WO9EVPfIrRYF3z6+TUKI3vht0/56Ti6aIW1LR8txs2l0WiGghR+?=
 =?us-ascii?Q?k8R7JIq6KWBM8q3ed5z2pkQTfOhLKIADUEL4SCEjwkwSd24fmp3D7CR0MuFR?=
 =?us-ascii?Q?gKZ/tcdohyhBJocyirL8k1ukjZmQ6M8516/lvbkVeTgtYMSppXJhoIdeXuUn?=
 =?us-ascii?Q?81gl8t8gAQAqU5Vg/3GqxLTAPGswmU9pWFP80Lg8R/3t+GDK3X7v1xHB+xGR?=
 =?us-ascii?Q?xRGHTv5Boj70cqU2/SsWajdkAxTN/XCrU/7Uu8nRahZwkJk2Ko0kN9e6flEJ?=
 =?us-ascii?Q?aadabNTl7k/XIEwWFPYW6XLb0NmFXBy85EQy00Eny2KiU+jZ5XZvtOY/srvy?=
 =?us-ascii?Q?N7DMyv6aw1rmA60JzECNxH+fcv06L30ksfELz2sUBmQEgliR/wLBL1ZceL/A?=
 =?us-ascii?Q?QP7cBbMiNNuIL28K1AbzLKavGbeiDOAsabqIBfb2NEuhXbgFu8sDBg6doH9j?=
 =?us-ascii?Q?m6LAjKXSFjWylmm+jqKyoDV/cg2zIYyeO5gRYbQPvICNZvH1MP9Hewe3KwrZ?=
 =?us-ascii?Q?NXTBZuhFQRvNfelw2K3z/62oz0oMhDq1NbF2aCHFo2RxSNK6MfNf1PFNocGa?=
 =?us-ascii?Q?cSzf+Gw6aO4TX2LFQ9zF6HHfRi90KrAJDoImnrq9Nu+Di0XXWYFNpxwS1qn7?=
 =?us-ascii?Q?+uGoNV5gmPCT03cgquFNR7If1s66?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DXN6QgAgNhDVGjrZD/TedTkTi8dxKbOuEA8fmrv7XFEQXO81OiCziscnE6Nt?=
 =?us-ascii?Q?h1TMBL+WgSRZxO6WEnRTCs41aCvxG1XC8tqml4GPBeGUWwp4DiLFZ6ZBwFsF?=
 =?us-ascii?Q?ayRsAA0E95qj1/lYcsTBzSoPQCB0g4DMjnVLWnJMJeyEvzNJpfJAdqiS0LHS?=
 =?us-ascii?Q?d9JA4A2Mn1d8OUurj+B8Mig946rR7pTz2k9Z8jkcKvyL6oJaAYInEHUr/rIO?=
 =?us-ascii?Q?k8BxQ3IAEhRv7T5QLeFbXLPb3MqsahmqHvveB4/kslhHGOxGM9uZ0TszSFVF?=
 =?us-ascii?Q?LpAo2SIHZ2bpT9UqBRbGY0YYz/AAb+MW2+n91pEy/VhEMgkKxdDk6LhRdALG?=
 =?us-ascii?Q?FWaupB5X2wnwhJUudwvLc+a5j1tZfO4QJueNoP8XD79tfuOVSMNCoKDAsQgc?=
 =?us-ascii?Q?pDF/rsXaRRiwssCxpvUZj2FrwiG8wE6UXZmxNvEtexqARbDrs2SfDdh1jNRL?=
 =?us-ascii?Q?URDCjwG5smnSbPrkxMTtgy3gR5uSXYV//0eIK7ss4+SotOON7gk26b7fvC5p?=
 =?us-ascii?Q?BXpZA1S7H0mqSIqX4p8xPB1YLO8vfQWOBf7dCVizeZfArqP4OuYpDS4Tv3t2?=
 =?us-ascii?Q?ks6DaArVgaRFBafwXM055IDuStKY4A/ZXKADg7+53/DCepOu0PqrKpF/hdnh?=
 =?us-ascii?Q?4f9PSRYcAy2eoInPMJ9trXxBUxUsztiYE9zqj5FRrX+U9q2W30afGMv5jcx9?=
 =?us-ascii?Q?fJEgeq60dUEpbmw+b+Vh1gENezfFL+gvhkJsgE+aOJc+p2ExTqvYmHGBm7fa?=
 =?us-ascii?Q?oDRfDExqcGWhcCVkDtve/7Th7pvOLVpFWXn5hgjghaIGSSnCCUWabMOz9Q8N?=
 =?us-ascii?Q?WrFdDSZ0JDzT2094wiiOU2hdCS+VYocsNb2H7fKKzEipstTj9P2wWuwgOIzB?=
 =?us-ascii?Q?bcSe7cqzb/zbKE2EfCkXatXAeOI+JO94lMhmJ/ZlP1tM34KSy8qamFloac4W?=
 =?us-ascii?Q?Nj/swpefc5LICpJjAadqN0JvjrFm5dB9wEIyIH98ISL8WDnY0OMWA7M+NkWh?=
 =?us-ascii?Q?J2nkIwoPZz4c5q4CZFjQo/2EVJC5odUv/73ixAwfbfEQHHyTJaEmaJIhvJ+f?=
 =?us-ascii?Q?AKpO4zhS6MQZh9By7n10Fd0KPpYRD7yiMrR1/klOuOWgZJzGbU7j5VN9TPyU?=
 =?us-ascii?Q?IWKfhQtFBucsjHpmJTESWdoYLSORzDdmKgOOL3gFUKr5J6DL76UXVaQTuWMD?=
 =?us-ascii?Q?9LSMoRli66ypE/yEMkNTS8sIVuTwfEIcJz2Wr3yfm1DsxaXcxr6hlNavmXYC?=
 =?us-ascii?Q?yZDHMNkneLuLuSw/DURQTWXOIZevyiiLKvpAX7+gquVSt20G+cK90/UCSlf9?=
 =?us-ascii?Q?6CbnUnE2W2fN3ZLavCiTqGMxTJsMnmfMOuVYv896NSOW220dBjJJNYBcOati?=
 =?us-ascii?Q?cCIc/1BU/1vjWv5RRbYIVQS6KaeT9p3kMr/xg3SzWSj6jYtSVKTifkQFhphI?=
 =?us-ascii?Q?Z7bMwFydy5Qsca3HeUTc/I8CS1GzYxxIsADex3a8RnmlrTKd/AZjCHd+crmJ?=
 =?us-ascii?Q?kq2+v/WXZFj7n9QJcbgrJgS1xutdr8OFuEYA7xdWMRLguygvsm3v2UVnHUXF?=
 =?us-ascii?Q?UGrq2WEkYGEKFy8PLEA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ae43bef-f481-4acf-317e-08dd4bbd4bbc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2025 23:30:55.0150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aSSG/2Kuubn1mySrwrI8W7v0sqHwI7xqGF4JrwBOPXWobxGFhIY8R0cOsHwJmllR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8762

On Wed, Feb 12, 2025 at 11:22:35AM -0800, Jacob Pan wrote:

> Do you foresee the implementation can leverage your generic iommu_pt
> work? i.e. for building guest IO page tables. It will add a new flavor
> (page table based in addition to map/unmap) to
> viommu_domain_alloc_paging() i think.

Yes I do, I think it should be no problem and it will bring the
missing x86 formats that are currently not available in iopgtbl
wrappers.

I'm working toward getting a cut back AMD only series ready to post,
the other series on the iommu-pages should be the last preperation
work.

Certainly I would be happy to help you get it implemented if that is
your interest.

Thanks,
Jason
