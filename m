Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2043.outbound.protection.outlook.com [40.107.100.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB0B158DD4;
	Fri, 13 Jun 2025 13:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749821785; cv=fail; b=CGO+nIshuYs52W5pMdQeIHL39wEwiK0/jdLse0BhZkXjmhgN20It5oX6jKfBH3h/Qi6sYMBKnw6duzp+sCLmxpVVN12LG0JD0rK9hFP3yYupcJDvizPMdG6tJDBQLo3gEsJuhi5vi0RFxxgdAIxI01ic6kE8nbP9sKJ1SaVYkLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749821785; c=relaxed/simple;
	bh=0AZRYR4epyoN1DBWB6I64J1WiwwG0/9SqHtuZ036eDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ScQnaDjxk5mLpasFVDSsQbrhT9UnfKPPXzmiwaBFfcmuHMMBcXWEsAH91bBXNd20WF7rt1VzGliNhiPWfALlv5kQAEUPR0zCg7XcMo9YUhMl64+p8OfRJJEzpG/6pU+MCOIRDEw4zoY5i+NMrl/hqGLHBmqy6kj/4NK6xS2FC2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VLqM/lUZ; arc=fail smtp.client-ip=40.107.100.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VLqM/lUZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OKwk7TgVxk87UOKvKfPky8x0TO6uAvsWmZqLoZTdxc7BILBxVLUyOoroF/SPMhFkFRIDr8TvKH7ujDoku9BeslH20aan4Xw1V3Wiw3ZWfDGlK5Eik2pH4WVPUugjql1cuvkxHhEreZSh5w49hwkwiKjlAkrfHxP1mhTllZIbu58sclAdmwmPp58p3J7MW/cZuAgPERSmUf3+lIwOSUe0JO/6WX+a1wN0ommm1lGfl/r8cYGZidcTWaUBk9ECZQ6U8zrXk4bTGr3icEVUTqVjD+dWG/v4ea7ahiHPZjtCKoW83lipd8oOggW17yiEfFH2Gdsl36fg/nG1FbiMUpO3Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YykVoMPcKNlY9oe+l5RQh74TTEH4qndbwYvjOj4vqI=;
 b=jjdRyczAg4mRcDQaDHSTorCAy5SVZ3LDvQOYa4612ipO/g2E/ZApcCMBldyqNHKPWvDsTk5zeVC0IvuRYT1AMT3jjpWKtWe2FVpslHpWgMre6o+pYjUsmrCl736pjDXDGwaigsOT5WT0TlZ1/NWsSt0hWoI623RdwjaB8Pdl+gqSXdm5KKcplIBW+2kNJaSaJnzCN/tBFlvu6nb0yB2Iq0sK4oIoBss2kfNIy/oUEKo+LNrLxcxSCnDSL0Cx40Ak9mepnfJ1UXTgV9wujbbLbdXFAFd1gke9/Ic08QMDwWFqx//YdXXeaizsT+kGuRJUxGCEGNnrT3XvimxtcGoPog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YykVoMPcKNlY9oe+l5RQh74TTEH4qndbwYvjOj4vqI=;
 b=VLqM/lUZLqltzik4fst0Q1VkqBS8abDe/OtSacURH1+FbyZwA1QGMdupAtntSysMuK9TbhJlppcMziDfYNnZ2mZwfR4NDBLwKYe4dB2RWtpEvUP1vAzkfJdXY5NUHG/OktseCfDgTEzwQhbGpl1NXWFZN+Hm/QmQw2BA0IM8r3BLLECEwDXN8JAiqkBGq9uvj1TIGDZZgRtvLLfS3X/zI19/ks3aGOPuuvM4oijlP9lOf/q7qZikg+FlrFHDkAr15C/9e5E2MgxyAf/1UEERQ/m96n78wVCSKb2QGDnfRW6xTRHPr9V/y0ap0m/kKTt0AXDGN/vdSbCeimOgDeow0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB6701.namprd12.prod.outlook.com (2603:10b6:806:251::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Fri, 13 Jun
 2025 13:36:19 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Fri, 13 Jun 2025
 13:36:19 +0000
Date: Fri, 13 Jun 2025 10:36:17 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: kevin.tian@intel.com, will@kernel.org, robin.murphy@arm.com,
	joro@8bytes.org, ddutile@redhat.com, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com, praan@google.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v1 03/12] iommufd: Use enum iommu_viommu_type for type in
 struct iommufd_viommu
Message-ID: <20250613133617.GB1174925@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <6172ca53f6acfbbdefc2cc14b436d484ef62c250.1749488870.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6172ca53f6acfbbdefc2cc14b436d484ef62c250.1749488870.git.nicolinc@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0202.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB6701:EE_
X-MS-Office365-Filtering-Correlation-Id: e918620d-43e6-4342-d381-08ddaa7f470a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9+rJN6/YNW3wTi5C5uCwxOsK9A2/2lAr0T1/E4LTVzdaXKdZyYn7a2bgvwiN?=
 =?us-ascii?Q?swKXPG6k7rfmWscCX5HbGyghaoXDaJsxJlMmnSPcbMvSQRAEI7YOLthrqYJH?=
 =?us-ascii?Q?uBNrGIEibK3G95CMOeQOhEPEY1CX6VmVHbi9pXL0sbL7Uskyj6fqp3LwnwkO?=
 =?us-ascii?Q?qtTP2TcFZe5QUijUf1D3heQ0ovPqavF7rapsxp8a0eb4e7Kzl4k8f9Zb+3+K?=
 =?us-ascii?Q?ZJW7fCU+u4cNm5AxrV5EP8+Kdt5QZqAaKBG+Z+kmKopKXqETEFy717qrR2fF?=
 =?us-ascii?Q?YvffPduCqeFe7juwIoUu9RA4eocLqUGGXmuv19W9s/xxG0tFM+OkEAN3fUEl?=
 =?us-ascii?Q?Ga9m9LW2ECN+j3vdiExToPCw6hKKb725AZA1k5ClvzJyqyfb24sVAC04uQNK?=
 =?us-ascii?Q?x4ivyNnxwPTBp5RXhdwgPn+B2LccuYQBhOoyZmpyJiR+SE95J0jwh//FqXuV?=
 =?us-ascii?Q?uIo/jYBD27zCSGDuaYEdzbPYA9yWHX0V8tsiKOHytNct3PBVm0cKaW5LUr0f?=
 =?us-ascii?Q?lWvtJRtp+pA35ck5q9CL9gDt9bgog278mO3ZCKZdlgAOx58VFZUgyshVAMZl?=
 =?us-ascii?Q?8LvlBVp/PY6+eK0JQR/SRTKcMCjrQWgJ8EUbe+FaXSh2RZwLNwWDVoZLA53X?=
 =?us-ascii?Q?mbOO7gTeVZIopq9E/tKsxAEIFnDPpWfHXuT3AYl8z2xETVKulYNMLsomKQVL?=
 =?us-ascii?Q?Obsz6oM3vOPRRePeFyDm1PCzTR9ZRzpqizp1X4YZaiWTr9uJ9YmJHutzbdXd?=
 =?us-ascii?Q?tCZoKG4Wo5B7/zF3m2lgPE3niR9sOtLDQ9/lWnJdEt7C4Yccp6I9x3Kgq9wo?=
 =?us-ascii?Q?d+fh18YCv2K8slH2g7WwGht0SRPyZ3tz/E6jrZVbdcI4Xcob7g3wjFUVO/hL?=
 =?us-ascii?Q?T9fw/tziz47sAYMIN/DWfRAcsjJGI4xFip8QtJeg3b0FXdHGPtajzVGo+5en?=
 =?us-ascii?Q?LEodMiMO6Q1jACL7XpgWVKSwNQLHkfBHQu/B9KD4eF5Ghab6nsroZZx1Ng6f?=
 =?us-ascii?Q?pe6rgmgbCsgQPytX+y1ZNR7ZxC+H8eN9LpHMvo4Kl6+Xe/+vCetFgYeyeS+u?=
 =?us-ascii?Q?fMKIk0Af154pmcTdhvhpiDiKVVWMjVeFDzb6F8CHFOWthtXU6OHWJjwELjTO?=
 =?us-ascii?Q?51P0pZAapR6KmpTLOaKcKdAf5Rq/COklEuiu88o+k2r8ujMArba2yypSROnt?=
 =?us-ascii?Q?nJHX3gGPPyfFJzXIwGq6NbqA++rkPiEY+O3MlY3+lMcuUPD4/QR5io8WIFqC?=
 =?us-ascii?Q?4wAILWGgHR7SlzU5gCTzYfvhNRIe65uH72V50u7g9wBPF5GnxsNZEQbsxyWf?=
 =?us-ascii?Q?xTlzkVrV8tjjqTH6f6nn2bt16tbgZCPNySccSACvsnD6YZrnlgmwyjjxqNKB?=
 =?us-ascii?Q?qsATSIq2Ui8i5t+yxKlF5TTS0NGNBwL3Yu3WQV8t7EBxoH5tEfq+SoADl+t2?=
 =?us-ascii?Q?dVORJwRwaQo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZTKHEvGbMUdngLhvgcBQS7mEzWlah2TJoz1uyrRQhLKpBDxaXSR2MG6bLug8?=
 =?us-ascii?Q?qc1I5Ja15mnzGFvoo6XxCOnDYVEEYCXAlUzdjKtEJ1zZehnUWbY7DlEif1qk?=
 =?us-ascii?Q?s2TBjj1IRZnfRwK4qb1t+h2l+6QObBftuUeH0paIyA0s7e9BvZNruWG4F5nZ?=
 =?us-ascii?Q?zVOpgcbyywqVzSCpXz43XlrLWInikOQsNf6tO9StI4mI+jzNLiOy7DbX9JBI?=
 =?us-ascii?Q?MvtvSSKCDhb36j5vHMHkk2+gwhRCT4ZW7jjLZz1fLuZzyroollqddF4eYIwz?=
 =?us-ascii?Q?hZVpOAxkOGJ2Kj1K/HtW9nfpVyn+JrvzS1cA2Kr2z1NzHoglihGXjUmK2X97?=
 =?us-ascii?Q?NaYLstnAyRU0nm25arv6d+93dyRQ3M9IOL8vN57Le2h7r8NiMm3CrtlbtSLw?=
 =?us-ascii?Q?vUTJWJ9wzmNQVsyqgWYOQquyDfgZn6Ug5MvXu3q3bfUGUp5K7u3s2jGtx9+g?=
 =?us-ascii?Q?y8oyxKk1oEAXgM3QDIgJjRrnmRdilhGrmdL7HTuSYkaNjPPjEqD8gYWuJOrb?=
 =?us-ascii?Q?xKvuNd5cOi/GGsRUC+uEgS1O81qYBNBSzhOTG2JqWDmN26KFna9usQWVkFJI?=
 =?us-ascii?Q?VgbiUfeB82Eq81Y5hBdrVjRfxJts0gunTD9mnh+s4R/HuzwsDDEzqoFcMF7a?=
 =?us-ascii?Q?qUodTd/CPikjYWM0PeX5WhHmCcwwrfpMbR0Lp7HkDJOkGAZCbo8ZbOaHzZbo?=
 =?us-ascii?Q?BMSTVmwVYCA5nIJQRt6SpVPmLvlOOY3+Gjo+5nbOF9nJTzAFcQrjIHmqzM9o?=
 =?us-ascii?Q?A2LoTd5L8G8hX/c4HdX1H2c8jxrLk0/z+wP2JFT3yMiQ1f/0g2bcSiaC1jux?=
 =?us-ascii?Q?6L3+LfD+1xeRAlb9Oa8Eb4N+spHEh7l0F5YvGPFWcuZ0RI8o6fxTdubltYid?=
 =?us-ascii?Q?z2LctUt//bgqEOY6Xmnfm3LLVMjzTDSzKguqruSm56ITk3zbQeptfz800jC9?=
 =?us-ascii?Q?JymiGZ2jyH1nL+GSTp0LOY4ESmFP1lzUSrWg3Z97P78uk8qGecuwZiM7icnN?=
 =?us-ascii?Q?74BiTkiXpI6x9KHzISyJFUiN0VMhAStiCjPjE/TfqbCWz3N6yArXASXQQlpG?=
 =?us-ascii?Q?naFz9OaPW4+6QAmBDTewEVNbc3sgXU7HKOrdiXLYszwAEMyi7q5pSrLT+IuK?=
 =?us-ascii?Q?seuwnqZPwM/DrbkzAl1H2Ab6AQiFYQ0z5ZFz5+NgpQr3wjRaQKdBEEyfWtt8?=
 =?us-ascii?Q?IZ6Xc90SOtHau7fPY9MsNjBj4CFj/rc5JyIaSoUo5io19DyuFs3IodSc7sQi?=
 =?us-ascii?Q?dQWl70HWYj0jT+y7ADNh0RNWcj5/LSdZsQmT3uumaYLM4SqpnBVOo0y/l3Sg?=
 =?us-ascii?Q?vuj5lim+9iCqRu7ERVEDCfr1NqaVr3GHDVRYQ6aBvcn+EPMV1uzRqe03LJN9?=
 =?us-ascii?Q?qtzn/aEHioycEBKaHnEJzka1y+ldlld9L8PJnkPD5TQw6C0G0g8Vm1Fll5Qw?=
 =?us-ascii?Q?2GRqdoRYVS/ttzDgCJ148teB+FCHNtCxMQvk5zu6ybCF78ieM48DpE5oUjIU?=
 =?us-ascii?Q?8gBNhZNQ6QFjDUbJ1eNd78myRzv8o6oaA1SVF7ZgcQyOesWleqxkVtrNasJy?=
 =?us-ascii?Q?c8WoqFkQiRHS/vA0Js+WANcbkt6Abz1pOAf+nHO8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e918620d-43e6-4342-d381-08ddaa7f470a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 13:36:18.9780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WhR8FBUstFNNZ4Jly91pz1hGeY2zF4ZJJUdy3Vrxt3U40OmzW3HmLxeuJqbATV76
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6701

On Mon, Jun 09, 2025 at 10:13:26AM -0700, Nicolin Chen wrote:
> Replace unsigned init, to make it clear. No functional changes.
> 
> The viommu_alloc iommu op will be deprecated, so don't change that.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  include/linux/iommufd.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
