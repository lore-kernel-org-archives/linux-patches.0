Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CEF1EA84;
	Tue, 10 Jun 2025 13:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749562196; cv=fail; b=bLQ0dFatFrDPCKJhA83JvD4aPq04vpHEL2AocOU8rl3OUwnWgFBAvYIOpYBXKDDKnisyWbCDIMqs8+XYr4sBRjDedDZQxNOcfZtPccqMkc/9auPWcVuXhbhMHTnSaoLb7nGJhF74J2qGIoM8xRV9tj7BV4ZQtbYxXwrEiLjsQpw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749562196; c=relaxed/simple;
	bh=8nOMTp/b5APfe5cpBJWiaGiBFITCUrGJTbnfu7gK0F4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lB7+Y4tAvMewjwK4cFwJmXGYlriT1DTYNJH0PbPE6336HiPJaiO7egt395R0c4et6VaBnVQHkEv6QM0ahsAul+ZBe0MmSRuTZn+OSVvvyRlVYkk0AQJ9D/fCJtur/W75i50+qO4f4/NHTtTj01BcxXMZCWeraxKhy8LMcRsXvlc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eRG3Dr27; arc=fail smtp.client-ip=40.107.223.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eRG3Dr27"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G7vCQvZnvMLwkXvcgGfw7cVCnWkiUw8TZpHWaNzPFyiWs+N/YlgmAS0Wap8i07Gj3gwgtsOY/lspmdERJVmX/nqHCGMRl51ewhsnDqTvHEAIZetHieX1aSB3HFH9ApzGACROwJtjwq60Uk72SGo5Xt09YpjRt15paugrtHk9eq/1dPNq3upxRkOqzW9jRXrZ1cBVsjQ6VMXeSQ8kBLkX+B1uFgZLzajX4ZKpCViRv3x0wZwyaS6UeZFdf4l/g8mC8w6w+zyXWMmBp2n6Q0gHYpy/G2JsS0yD+RD8qTRQqC+TrjMPWU8mT2A+Caks3UqL+PvxiqUIZ/qv4qLp1oc0tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mvAI7DAXeSZH4hJ1PcXVADAff50g2Qm4+MDL7/xJE0w=;
 b=AK0+GrI7iOJmIaIbou19eDEBa/bbzXcVrxvfCT1iu5/r9SxDvUvaMuE0pTPzSQvcybqFOXjqu051rtypatLobVDCQw9nPEMaGOkpoq27ddxRWmiM9NEL2JW17/629lApKe21mRFAOSassqCsN9NII17aLIrvjqcnkWHYFQa3czeSxhMA+CZK0vfua2shdbDLmFbbTgATaFiV3YtPWEwnql8tZPTcQoV0iCgw62SRSGYBdoUN9N2y/VOT+YkKofzfiuifvfLFh5ll54ccB5mWMKPx7Vm2Lmnw24KM1izrVWax8HIco+o/8yHPddGBldRDhCVxdEgDM/hsJGXxZdj0kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvAI7DAXeSZH4hJ1PcXVADAff50g2Qm4+MDL7/xJE0w=;
 b=eRG3Dr27LUlp65c7PvGY8ZFfAIGQi03SWLuEzsfzq+ZCyUB1+iV9shHHXCCMDdfXcTDVBaKbhEz4q353slMhOJdo34BSWZq1VaaJ3fmgghYiBRThFCC7GrhlhHudjcxTce1+F8uqAgVABjLeiitZP8IhhS6DPEXsYF5frO1FnIhw4FBWmf0Wl3zlLWzoZlXrnuiPtq+1ohX3u+KMLzARKJZfP+5VBor/bP8jYUx9IolqsQ2HB0A8zWRbDiOpTQ6eCpMUPey39JAHnvv0ZgEvKmd4i3qsg9iyl0nlhvugwFt8UT8obL/ifaLrLcTzOSC31bOsPlFIE+2TF+OCXUmffg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB9251.namprd12.prod.outlook.com (2603:10b6:610:1bd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Tue, 10 Jun
 2025 13:29:52 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Tue, 10 Jun 2025
 13:29:52 +0000
Date: Tue, 10 Jun 2025 10:29:50 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Wang, Wei W" <wei.w.wang@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH 2/7] iommu/vtd: Fold domain_exit() into
 intel_iommu_domain_free()
Message-ID: <20250610132950.GG543171@nvidia.com>
References: <0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
 <2-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
 <DS0PR11MB6373213CD5DC96455DA5AD5DDC6AA@DS0PR11MB6373.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB6373213CD5DC96455DA5AD5DDC6AA@DS0PR11MB6373.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT1PR01CA0079.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::18) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB9251:EE_
X-MS-Office365-Filtering-Correlation-Id: 529f0256-19ad-4bad-f46a-08dda822e138
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JfJsqDaXNLNV1ZfiGHwcOfI0tNUW8LaHz7zsvFRKMBAxEOc7OzaUYVFHnLO/?=
 =?us-ascii?Q?Uj05e6ncu01ogm1ZcHc4gKAto8htWSBKUOC7Db4Z7s+mMQ+V4xnIJQ6sjnpZ?=
 =?us-ascii?Q?1I1GLDJ/oZiqsn+QZQjh+sKUTkr1sd8y2KcoihGO0XtIFa75UZCT8bHENw3D?=
 =?us-ascii?Q?0LoZ1XdM9/GAEdQGs5we7BW5DUah9GnwOqoXi0SYZZZVVwDm6FTU65z9FAAq?=
 =?us-ascii?Q?ZUjYxdOCeHhPcV3UPdo4c7MkrTnq9L+KGqNe0iWZd/LztT6VViV5uYzRfkZV?=
 =?us-ascii?Q?J5nQafNFzpwpDowzsHdG1++MOEB7DMmyiilquN0AJsuOyW/1E4BK9A5qdKY5?=
 =?us-ascii?Q?o44kaY1M9XuUmG4mNHuXZirNWV8bLlJU4tbygfxg1VQ8h7LVkXWzyEsHgkSn?=
 =?us-ascii?Q?LKWslY6E9T81TLDnuSTbRHouEmPpO0P3UDef8rl3vN97D+CChH8gAJAWzyCJ?=
 =?us-ascii?Q?8zi26CQRHzcwhq/qCUJy5yejyYC/E152HEjiKvHpfRds7otDvFiFR+oKDcCo?=
 =?us-ascii?Q?D0HDjU9H+7XlKPYAeCzfqLSyQBF8exN15uoUbOaa9EQO1FB7JtAfe+Id2vdw?=
 =?us-ascii?Q?E100Did5Q//tJWCXZvlkrqkjiJijdUTsyM1sn6ZfFbO2mrbE4sLr0MQHz9XF?=
 =?us-ascii?Q?ynjGwjFvntjvAhi+tiEXmGob018SYc6hCAnf9q1SV4+c9A6HNKxSxzub7QWd?=
 =?us-ascii?Q?XABTT1YEl0hv0ZJ/3poijUTV2Kfj8Rv17puy+tEAr3hO/vk5s1os4nkC7Q5F?=
 =?us-ascii?Q?ziuGKAQOLG1joS8GK5KDGgVj/fH0YpfFxf0e3lIqLBzBOVdNgEme/2gOIk+C?=
 =?us-ascii?Q?6irajFTBOXtxTkq9WKyqyGH+LPkHVEuYeIcZZJi8M+jQDofP1azfy1gkeE0k?=
 =?us-ascii?Q?2S2ZET6/qC0Wvx63rQjTJCs8l2l9h2N514vDpMbh22b6zp5s6DecCRjH/rfv?=
 =?us-ascii?Q?QPiahlVEI5ixAP7yOovKnOLv0KuMojUGLVaqyxeZLBx5XbJFK0tfVZprRy7B?=
 =?us-ascii?Q?h0rXAqIpmUUhWrYzhuEMEC6FlYTP0DWK6uRt/f7ONJsg6GogQANkaSFxxC26?=
 =?us-ascii?Q?p1txxbBh6/8HVI+Tc9MXkxXqX/IhO2LrqxRyeLld3Tk1OXzzhndY6AngRgMe?=
 =?us-ascii?Q?yl0sfty78Aeu6XFm9Jn29NL+GIvp9ysqr9H3PcS+aGZGbNxBcX2m1rzO9vJb?=
 =?us-ascii?Q?a2UVf7UYgD7SZU4bWzj4D8GWrqefs23FDBlxAx8fd8HLFClmkIjBXi69BrX2?=
 =?us-ascii?Q?5FdErgYa2pX/Lwd3NaEXNBUHPpwmm6IY0iG3wRNLfcC2xh3AESeKdOUoUXqz?=
 =?us-ascii?Q?emoaSITDZyiH2AAgiveUwDWk14cWrraWAVB/XTrNplG2qV21BlUwzlIlBGOk?=
 =?us-ascii?Q?Z+mVuaUTh8QuJDJnQhuZ9QBr1NdWKnkpki5hlQVXy9chi8SQ3xQwiz24YOXv?=
 =?us-ascii?Q?G0QAvC12K8w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eXhNSvzs2MGqaLlf1+TQwYAmkWb47ZrpaWb7umED4xmEYWdr7/Sisq7WNCMs?=
 =?us-ascii?Q?Z0iHmpl055O7/HKqlv2QoXItuE6mGMh9C6QrVxAq4t0HkYMAQvA3RbYESwNJ?=
 =?us-ascii?Q?3n6fwyVMt5XeM8HEIT3/vZxnXU0B5yq/0OxUZw8DYpZPFh854HZA5pNQe3sz?=
 =?us-ascii?Q?w1s4GEqYcb/NPK1YecsjmtJThtqt0y4wcfBZ8Jf6bDz2DIqqTzjw2OkKkC04?=
 =?us-ascii?Q?WbSNFpGzD0SFRXvjY0XuDaOcz4WMDu3dH5FXnJZSO6J2o+DsNrOtrqfRoKwF?=
 =?us-ascii?Q?EU7GBSaQ8rqq4cjtZOcf2DEHs2s61BS7ry/rhPMh7qe0VRidTfwGaskANpc2?=
 =?us-ascii?Q?rLkaW6uU4wo0GNurLmy7pqQmwClq7kSo0sXptZJaMVdUdzUan66l8a3wpqPm?=
 =?us-ascii?Q?WJ0aZPkYO6ZnrX0T9DYIuI29bPbOAvq8ehpWxf3fN0mR/OmXxaU6QHMA8I98?=
 =?us-ascii?Q?vpIU0TDnQwqvXFUqRbDc4/ZlDfVhSShfv6sIMP/x7yaV1Z9dvi7pnEZ89u3j?=
 =?us-ascii?Q?lP8Wka+aAcm0aieNASpLdOAKO0vpltWHy3+vj1vfcTPO0r9LhEueiscpBAPj?=
 =?us-ascii?Q?8iXpsg7lJ8DOt62qjG4idmpYKpdi+jDRtjnM5/YUNeCwIdyHTASwitTY+LQB?=
 =?us-ascii?Q?epikzACKhD5uim9ExGglvL39M8LE0OFQqeFQqhOiy104HG3rnQc1I36tRS/5?=
 =?us-ascii?Q?nDzHdPNu04mfcECYnXZKXNo5qGQQsDwRMKg9Q1DWwWwwUojGxwjpMBm/hiw3?=
 =?us-ascii?Q?+N37gbd5A4vLqPpR06UYXJGuVdrxSf9zSBWM2Mp+nfC+mghlrSC1vyO/yNCx?=
 =?us-ascii?Q?4vfcAiVtsgPDKKNyGK+jhDVY8Y54RklFKneO7rwbZW4xCY7YnfBIMPBZDQAS?=
 =?us-ascii?Q?v/YvMudyW0KMlQFi+59nNmi7bTIfI9v1Fc/qC2cTTFme9WXTNLqnfd9CFh0l?=
 =?us-ascii?Q?GKqFuSkm0/V7Fy7RpwgtSEfqsCEOCaUDSYtsr2h+YIi3zGRoioNDeGVVr336?=
 =?us-ascii?Q?yhLNpbmqEvUYJGx4X0wS66+XBrvWWHWXsZRW3Rh7H1q6pABlgmmylrGTejcX?=
 =?us-ascii?Q?5eQdYmy/K/5xxu5fKwwpikJv3a2QXjFVMThBQV9JFetip/hCYl6VkRGO2ZZA?=
 =?us-ascii?Q?vuuVlq24Utg3/4ShlWJlG/RNSRXiy1jmDaQI19Pk6/3hCgAzd168sWXmDER3?=
 =?us-ascii?Q?qN0glN8obgKyh5hVzarpIo7azPt/sB6qjrFuWv9zhHKGurxECHmKKYb6fDU+?=
 =?us-ascii?Q?VMBa8tEC5VQKHrEUuRK7wodztZg8d1v0YNkNfGnMXM7pIbxT9RrmeXRqHMCT?=
 =?us-ascii?Q?U1GdrZvqB32lrNPmYhBk73a8Epkz4XLwAwhNOJCuZv3BFI7Qbyw3uS1kl5B6?=
 =?us-ascii?Q?MazxLbsVH0PfG95a4JQowBlJNLvAM3BHKoml23Xqw2nRlIdN1cOtPIqutYBO?=
 =?us-ascii?Q?x0lK2Kk+kyzDAuRHFYxX33z0Usc6lDmntqFVhAkpQib+3M6CqS/ORLU/dE6r?=
 =?us-ascii?Q?g2h/idKKWVAxhTGUJLcsPDpHg3JM1ZwRr4fP0LriPwoFObIWaF1PmIRy6ukv?=
 =?us-ascii?Q?xMxWmxW5reGEasWUFBuRMa+8ORxB0vRk3mdObHHx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 529f0256-19ad-4bad-f46a-08dda822e138
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 13:29:51.9381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H/0aVmEihekTB0S4HBSvwkxvzG9irJsQy91dIzmo/N3tyHQl7WpfDmTfRNFNN7l+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9251

On Tue, Jun 10, 2025 at 09:15:14AM +0000, Wang, Wei W wrote:
> >  	WARN_ON(dmar_domain->nested_parent &&
> >  		!list_empty(&dmar_domain->s1_domains));
> 
> Not sure if UFA could also occur here in the nested case, as there
> are active s1_domains nested on this domain, but this domain's
> paging is going to be freed. If so, we may need to merge the two
> warnings and return:

Yep, I did it like this:

	if (WARN_ON(dmar_domain->nested_parent &&
		!list_empty(&dmar_domain->s1_domains)))
		return;

	if (WARN_ON(!list_empty(&dmar_domain->devices)))
		return;

So if the WARN_ON hits each case gets a unique line number.

Thanks,
Jason
