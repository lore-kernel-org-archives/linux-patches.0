Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF2E18D65E;
	Wed, 12 Feb 2025 14:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739371552; cv=fail; b=kVF2ChKPO0Slj9B5EKZ29mmm01Gr7J6jEWNoxropfkjwKuf+wgz3oiNvDVJuW0+bU6QFbOM2a9dsRKWpL4CWApaUpt+bDbpRSIIFnutbjl7DD1kcU9R/Q/bjFDNIqx3yEDEB5/1l7POntdZbsE65uuP3IG/5LK3ijQXZ9i/V0zk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739371552; c=relaxed/simple;
	bh=q+waZ1k2Fq6XDHy1ors+TU/VvIjunws7XWSY4E4EsBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cbooreyMlQyjvcgcinPftgLSVaf6h7dLzII6ZMQnTr2e4915Qw21DEJF6qaPU9Rc9j6mBj7sMEmetTcArYv6aq+DHCwM/0piNN6vy+D27OzjuKDVgIdu/F5tHB0KR+iBws7M61Fm3lzSRzf02yEdiXldz1/8hg0Xcv+eVpAKPsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aGKKmykB; arc=fail smtp.client-ip=40.107.223.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aGKKmykB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AkUpYRVX2jBU2LWPzNiaaadlfIUWR821n/X00nSMyPkfXnCjaIOComzBEcYwAB7DFc6/1E/ncowD4XCE1PbTUssNPQ+pF4WSkuDkUlekHaUzTyJRJQyPMYQe0DvEkKZIIfpMXg1/EvXoJs6KsJnxlUagY0RoIgRohwUHmwv5y9IMp/vC4K3QlBKDfjvwEGrTs272gHn+RCxTw82KuhVS0lMBrvxDYq5ojKZwJa9rsjx6iytsQ0eKyv9BbXejeyE7LXUb0YpbPQgV6k5Q8AkuYoHeFIouY5UG1Xs09II0oNIyHe4ouNQhYdds20Fxk2n8GL92n5vlI8EShj0sKtTSfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JSFsDFkrXh51rhLxa8ZXCYJ+gpgROG70Ukr1hsx1jDA=;
 b=tLx+kC2YO1YK9qWH7X5nNWrAPWpmWWQFSZg9OE//tGn5BPZApMQ3Ga5OO39PKcBvgUWd2zJJTkL0vp55fvIf07rqoMqecJMQN3pLYvFRcLEdLXFTXne/6r/hOzA9n39bya1go50EnYlceXGS23uJv6yR3N6AVRhcv+YQ2sIbBVyv1QlGeZjY/k8vln6DIjIaSdTt5nFpT2OIfxG8rpvFiyivrkdTAcChaosP0n+acH62dBc09LGHHs2ehOKDe4ct5K4kgLQTBFx1QdCl9Y7D6vvq6VbcNRsecvAqSoIhCxPuVLPGzzsP7MMI8WdFmTu+WhlW1SsIQvwuxni2TjNxjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSFsDFkrXh51rhLxa8ZXCYJ+gpgROG70Ukr1hsx1jDA=;
 b=aGKKmykBeUucdHmsW2W/QSjrfkL11O/6ArpG6+qkpEbSwb9XwHFBpotX31augyU3MPbqPKyZzBefRoZGp3mz3kiKWTcoTGHVMne8V8/jvGsAcX7hSdRG9DPALKbdRyb9Ku2EUETfmMNAteNHUozn56UbuFrRa07AhXFFjfkhpEquX6dyRcUx2VTtHRiZVeisrV32ZTIi0ZaFPlxU+OXjj2y55Qf42NQ00ZBcPQ6zyLxE+K4yjOgA8pyBevbj3F0GyQWCPXBJVQYQsABTDaac5PXTiXRapc4iDxAHIQOEDQ7rw8XY6Kq6f84X7jFrCi11hTlcniOrPkdDeRMwjHDqaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by CH3PR12MB8281.namprd12.prod.outlook.com (2603:10b6:610:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Wed, 12 Feb
 2025 14:45:44 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%2]) with mapi id 15.20.8422.015; Wed, 12 Feb 2025
 14:45:44 +0000
Date: Wed, 12 Feb 2025 10:45:42 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: iommu@lists.linux.dev, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>, virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev, Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>, Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 2/5] iommu: Add domain_alloc_identity()
Message-ID: <20250212144542.GC3844591@nvidia.com>
References: <2-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <f0164c18-9ded-4c41-a8c5-c225a978973d@arm.com>
 <20250212140316.GA3844591@nvidia.com>
 <021d006e-1fe3-4f58-8e79-b5e316de347f@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <021d006e-1fe3-4f58-8e79-b5e316de347f@arm.com>
X-ClientProxiedBy: BN0PR02CA0053.namprd02.prod.outlook.com
 (2603:10b6:408:e5::28) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|CH3PR12MB8281:EE_
X-MS-Office365-Filtering-Correlation-Id: f30a569f-ea1a-43a5-fb5d-08dd4b73edf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DToDuPi6AdndaX+E2hL5p7ra/aX0i3cqjxIxXuXXdAMpNFS+MRGePAinIJx/?=
 =?us-ascii?Q?olURQQ+I3JchEsVtY137FYcy8dGuPxl74qPVqAhR1gdEGfD2IszqaOxAW+95?=
 =?us-ascii?Q?pW6Wyqdu9K6mbq/ghSpsDqBu2Asr35/X6bxWcpy+XSKCW/lvptrYWr5IAmct?=
 =?us-ascii?Q?kXvwtEinfGeI1+sNbBxRuzR92AapJjQtEOvODbP6AaCiCGoAJMnnfzBYO0eY?=
 =?us-ascii?Q?8xr7I3HOsrrMrDDb1WoIy4Kl1huhqUcf+hrD10AqeQ2IEfEYRFm8nZiJwe6E?=
 =?us-ascii?Q?gbJ8wpkIUXlJ6ejwhDfpGyQF2HmsTrCwjRHeUmvnJhBl5tSEkQpIskMPgOyx?=
 =?us-ascii?Q?2Xyj+IgHbbzKk+QuYgHlsG8ahZbjtL6Yv/J+2frqhgTGNtK2mI6cvZfGysYU?=
 =?us-ascii?Q?ytOQqR6nIELQ1q9tG+j4araFdhUhR1AxK2AJeqJgE2So8uknXv/JNygL/gL6?=
 =?us-ascii?Q?NwnLoUgop6Htjyi0nTyVD9FDE2vTDCgybblhmdkf/NMA0QLa85HLjWqar4KY?=
 =?us-ascii?Q?8EirEx+5VYdC6XTnR5tN5yICS4qlcDzCObdYz6B7rJbipKmmSCMVJmYLyQ+W?=
 =?us-ascii?Q?jg7Gh2ifi8DK5jOihl3oxfEE0nhKTdbX09Uvf6oqaqRQQ35FxGyj0UPJkG+e?=
 =?us-ascii?Q?yiA2Yhtqw2xxnvyLFY9A6YqgoNF0yK4KFH6ueQIxX5Ct7VqummVNmZWJcrHo?=
 =?us-ascii?Q?YOOjdj5mUK9cwZ3hunjK6nM06c+ZPAwO6MIhOCOU03Qhq+IweX0eRzVuuo+m?=
 =?us-ascii?Q?+0o2xRgMGx7wfrABJBpwh0BZmKcOkl5UA1Fvv2T43nK/5U8ccmMfkKFQVHM+?=
 =?us-ascii?Q?IqkFSLw5xg6HLlV1Gqr3rcOz5hWqURgQyaH+xwHWPojfMWE/u7REh2n7nL9L?=
 =?us-ascii?Q?klOBzf9W36p1gDEvtYwQRzQoaDNJTfWyAQYBgZ6h1U3q7UaaWlIr1xavjyRy?=
 =?us-ascii?Q?vPMmwFKk6piHnKrnK3RTDRthSuRqK//xMsMATJVnsiBD9CiWkiCb09m2a9yW?=
 =?us-ascii?Q?MmskzI+2HnPUnhQc33HsLkTNz952dn/dLD4xanmh39FNp0t/p2biuWE+v71D?=
 =?us-ascii?Q?HA7b7krO9lyDt9y3SrYBTpBHsshs0Czn3qQLetUYLxxEIm/OZ1sgJJ7u3Bro?=
 =?us-ascii?Q?wVpAy/97aMV3W0wJ4Yi1f7LiXnni9JPK7scwtVKRHinqBlfQHJfri7uF0zdI?=
 =?us-ascii?Q?G6WW1kT/tVfHklr9dJfLNc9pQpV6V5elv03R//SM9tNqEJt6e7nv+rLBk1eP?=
 =?us-ascii?Q?E3L4Qgxps+i2JRmcXhLbPAyFtLvIG8DyeFui0XrD6pCKqiakvPq0OuHh+na1?=
 =?us-ascii?Q?CyXN8sQ7hcl0JIiLRQ6CeZxINky1lQ1a/VQh8Wc9j9d02yMbJTVLeWviH1mt?=
 =?us-ascii?Q?EOvKhFS5vtnhAn3XhKq2ajwL7G2B?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?APweLErR6G6mKedqUeWUvsYl/batNt0oBaIZ5I6dmguvVBgFk7W53Gu9haoA?=
 =?us-ascii?Q?Pi6j+68YRLdbmVIhM6oMQr8BbNmhr3TbRaN7B5OhRci7QS/bvysm0CwQy8u8?=
 =?us-ascii?Q?MKgTGpWINiOUMfdCka1lXY/K9n9EWo2SLy262h0PB/gomO0sFrl8L4MzoBF4?=
 =?us-ascii?Q?zF5DFLmk8EVqXozXUhLkNd9K9BT79nM0+9qrIByobCICDrJZPwsLmPADV77k?=
 =?us-ascii?Q?bARnlZmom16N3u5RtZGA3QYwXHP7hvjED481sQGwq5HeeEn38LPsMk/dgzEM?=
 =?us-ascii?Q?DjBtk/NWx2viZlySN4EneUopvpdsgGl35uU3ENKZRu1VOIe06ZMxQvBxGYFM?=
 =?us-ascii?Q?GXX3jattoVjiZqPY2ANSUn27sdKxfVzgP+ZRGHeXm9m00MqOtOHEgrd94l8l?=
 =?us-ascii?Q?71ts2Fo4knhhZrl7KginbjIc+a2jrcMfLWnZkaMg44TtJkRKVkmgCaQ+8Ll7?=
 =?us-ascii?Q?toCVS6LnlSnIxlBGZg2TJj3lisOLvIZb4oGWIELo2tJvGc/V/sQFPCt+3fcY?=
 =?us-ascii?Q?ZqFBJg98Nn5bvXaYnTuq/tYZF1fLLztE/moJNPEY4s/p9y2J1BM02G40eFEv?=
 =?us-ascii?Q?d1ZWGyaFhkTMFOGte9ucJUZLqWsSv9KtVGdlm3iN05SinfzqVPIsg81u8c2K?=
 =?us-ascii?Q?YCNIEOQSJKcEPhQdv/7DWLGYXSjJmFTsXkUVbf0YMY1QSajnsywHyH/nGYCD?=
 =?us-ascii?Q?EuvhkANSgk1cftEb9c47TFVMOjHqt+65/Nk9ucPoxtuk+cItuGZD0R5Ujkss?=
 =?us-ascii?Q?u0Y7p+hkmA+L23aeCmET3rANIxmGkdR6bJ5rk+SbeYzI/Z8SIk/BcJaQPYtz?=
 =?us-ascii?Q?DUcU9C5HhIFFeRRuGNdUBDCY1SD2tObgUIoYOV5NSTrnu1ssMweE0IGNzjBu?=
 =?us-ascii?Q?OcRa+W09sR5ka/xrKLqpwD9v8+RLiUpK87t/wH8EoWT6s9mZxIiM/D0NIEGs?=
 =?us-ascii?Q?i5mp96s2Bog99uZN23WqD5c6X2jfCXQbo+zbsTS+F092MWoPkZZh8XN7jTIV?=
 =?us-ascii?Q?Gs5DmkfXTkq4WLWc7J1A803hJAP3Uj9EgNugZJLFa5UIVf9aqB6Bteib7J37?=
 =?us-ascii?Q?d3rCAFAvjBbCiSNVC9w1inD6pMpg83YRZHHj8cAVxzYmE/QL3WFeDYpQG2dS?=
 =?us-ascii?Q?J64N5ESLDDjHUYihEx4Uog1aYm7ODD4FkrRBcGyu6HzABEXTSrh7jRBx8hrb?=
 =?us-ascii?Q?YvVW0xQUInsuGz3ebMjS9Fl7vldxM4qDT04nzsDrbcfZQ8jkyoYhqHIbBLMo?=
 =?us-ascii?Q?ej7/sbwuTRc/VvSZuLj1lvarwvmiarJg/cwON7IThWDxC5j2p+DzqAW5n+Q7?=
 =?us-ascii?Q?AjlOLP1p4pr6lSTcgIOi2YNjTdmd1b6Lb1cXE+T4S5povscAM4oYEkkP/A33?=
 =?us-ascii?Q?YBcyLsdVMP3CRKOYaZ1JF44zoXnPILWCfHUIzUIkkFd2zXJ92oo/tHCc3fq7?=
 =?us-ascii?Q?P7QpE9tb4VLZyWZxzzirdFQEZsgUu2LUwZITjIrhlrP8qVGEpOb1z2gvB0Tc?=
 =?us-ascii?Q?DFFpp79PZGqqgxgYoUNtlM+vQRY6Gca8q8yQPuXBYCDODO0lF5slRwFl7PQc?=
 =?us-ascii?Q?dmh+aBhHGoDuZP8evpQ7PcrzR+0mVujr3YmRqRQX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f30a569f-ea1a-43a5-fb5d-08dd4b73edf6
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2025 14:45:44.3280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +b1aszhTS62xXVk2j+i1krR/Vx0wm79ZgqWl6z5dJ5amehcwwS0wfRnZDsjU4U5O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8281

On Wed, Feb 12, 2025 at 02:16:54PM +0000, Robin Murphy wrote:
> On 2025-02-12 2:03 pm, Jason Gunthorpe wrote:
> > On Wed, Feb 12, 2025 at 01:56:55PM +0000, Robin Murphy wrote:
> > > On 2025-02-07 2:46 pm, Jason Gunthorpe wrote:
> > > > virtio-iommu has a mode where the IDENTITY domain is actually a paging
> > > > domain with an identity mapping covering some of the system address
> > > > space manually created.
> > > > 
> > > > To support this add a new domain_alloc_identity() op that accepts
> > > > the struct device so that virtio can allocate and fully finalize a
> > > > paging domain to return.
> > > 
> > > Oh, I'd already managed to forget this idea - this could be convenient for
> > > DART to implement per-instance identity domain support as well.
> > 
> > If we are going to broaden this someday then I suggest the core code should
> > implement it entirely buy asking the driver for a paging domain and
> > then mapping all of system memory into it. There is nothing special
> > here that needs to be in driver code.
> 
> Sorry, that was just in terms of having a domain_alloc_identity() op that's
> allowed to fail, being potentially neater than otherwise having to register
> distinct per-instance ops with and without the static
> identity_domain. 

Oh, I see, yes, that would be much better that the tricks drivers do
with the default domain too.

Jason
