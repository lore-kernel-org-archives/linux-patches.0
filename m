Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012000.outbound.protection.outlook.com [40.93.195.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE5C51D501;
	Thu, 17 Sep 2026 13:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650984; cv=fail; b=ENUJlhy6lxPAl9I6juRcyDznqDE9AT8sn8vAoeXnoAQ/3CUUtmPxVq0ofNj4MnzGRz6ttRSbazgQK1AwSTF90fS+fjxO8H/CcG/wFdPK7AUf28GMm7sM1JKgu9+qQ3Jd11H6bCJYCnzgZl7ez5ZbkFprFzd+qhFoZcIi7yyQ/B8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650984; c=relaxed/simple;
	bh=ZeXwZU3vS4Ri/AbgpmFPR2qXzEKXFlSN7BnI2T6qe+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m9w8qg82ff++IySS3iTYIOF2QImu7tskBTNOEb7kjC/X5vRHh+BRUXudCrB30kmlLO9nM3bYo11pQFhWjCJz1GQG9+ZhhBCBpiLawyCyuR51YSiwN8PtYa81/Y+8YO6L1Ksh3sUKHL5Vt63een5n93TenIFXJukaWEx1cY4Gwx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Acn6p1jT; arc=fail smtp.client-ip=40.93.195.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Acn6p1jT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZwsYVRpU0B01FnyX2QLqz6qhv9FXupxVw7BPxvL7oJXpuKmtK4+e1N1EIxUC1gVSKqsaYTPMC9fv34XoCH8sAku+7o42GWuU4/Wc/DZWUZUjaUIpIeEzCW3TMPlkmt4u/6nlI3n08+aE3/iiZIDS/C2zWhi1HgEo573zvsrhHEJlIH0C3UEWFKemECzlNfLsJouDyZCTmriMyVl7w5kG4gwaZCPw0Tr+VFWaDv58GQAA6oiI++TzNRcaXiIo/zbjjiVgx7ZMjmO7VD4KsviDF0WeNPjii4gyW9DpdyBur3r4v7go4uhPYiDhWrPWon9vXMldMota7QLdfAxAHfnohw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kpOhOHCfc9bKTFxzUY7VXIYrr8mcBV9v4Ztu5hq+GKM=;
 b=Gvs2AtFdnGZpSD+p1TV1CX520NbLixlSxl1526xT0QRSplU5+NchuJIAjlzo1E1z1u8tObrVbPS6S66KnUECB9rd039oPR2KWuWGxARe7fou5Kil5vZlVvKoD9AMV4QAyTH8laRobxWAuQBHNf9OMvvFXqscL016ZzjlnHUHKpByVTZ5j3Fp86WHzRxodjFuFqbLyqiBnyFB01BfjBKPmv58BiWMf+eM2XGuJ65ESwTdQkffU9o3KzUDAxqsrIvsV+qoqk2Y+SM6qHT46wc+4ep6oKyngBITqpUM+ib4iUZHx+yvScTPPkwOEWEz+7W0d60vwhL1WkyGGkTiwhSatg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpOhOHCfc9bKTFxzUY7VXIYrr8mcBV9v4Ztu5hq+GKM=;
 b=Acn6p1jTL5uv8VK4wQWdDN3CIUmyEk2gpqw5JaaZX5pJBwiLojtdWGhCZlQPfuxYrWewLruD0IiHn7/ZFt7rb3HwPdbvhyW5hqXYq4OuzcefDhekyGvSxw3l6LSVtJlCe/gP9mQJ3xs75xhzweV8wC36myg3hHHWNZRXtb7d3SIAsWanXRCUUwTyn5mgZmdMxtbngxfEd8MmsdjgyXFpA//gPuSLhtQ1SU1Q9j+BIP3AaEnShYDOk3mq6g5Ej8WfaXLA6d5xA0BpyznEOYXZ8BjKX5eWXEMaUHaVl0DNqQnahzmkIIXcmVSkgO5jyKXlix/4jS6Mk62avfJjxV2EBQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS5PPF266051432.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::648) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Thu, 17 Sep
 2026 13:16:02 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 13:16:02 +0000
Date: Thu, 17 Sep 2026 10:16:01 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v6 1/9] iommu/arm-smmu-v3: Handle ARM erratum for CONT
 under invalidation with SVA
Message-ID: <20260917131601.GY3968357@nvidia.com>
References: <0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
 <1-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
 <aquxuBnh6pdxu4-8@J2N7QTR9R3>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aquxuBnh6pdxu4-8@J2N7QTR9R3>
X-ClientProxiedBy: YT3PR01CA0078.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::9) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS5PPF266051432:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c082f8a-575b-4eb0-9ca1-08df14bdd248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|10067099003|4143699003|22082099003|18002099003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	VzKh8WCCqXUzEwf60vYOz/alCT3tJ0vGJAm0xUs7NueK6pifwWHOgwC22HdV5JMCdFAUmJgNNMngFNSlza2kIZ2M2NpK28UBl3ZYmLYbKBDKglKpHGD8z9+LmM/CdOkwQlZYTLoY6v5K9H715R5z41EVZV0RD8WfJ6EhQDJCkYFKLVbifwHcgQ4lYVaqpusFpljuRdyNosnjYyXKUeAzRiKcyYvJWeoM7vnkqCkdXkH+JHtRCDiEa7r1Bsw1ZjVqFvMQO+eGAGLusiJKjtpI303jc2CDqEqfrBx2BHKpoRHAeRvWkLicrHK9hARU6ooHl4OOFsM6VresUMv9kSmSAkREJZC6VYpLv9Dl3LdIrBky+o7vL0gxCKGULOm3c6WEwTC9Nv/hHHPbR9/2V2+scm23mw2vypbx21eyhaucaHM504kxBrmStdwC9vAsdaQxvJUPecguxNJ9pLVwCyQ9Xfd/vNYV2ujVDmYY37iOzmsuvS4dQnA6fezzq4/XpcsJGqCKSKzvcwRrZLDwOE6YYmmdWJAly0r2XYbF6EBFE+zKJ8iJIdIxud6RaKAQzWx/SDGsCzho2FNebLbYb/2TCNAjHEfG3CKi9+HH0Q4dUn4duyYzmRh7rN/rxb5JIY+Dy29sqqjR+GxuKvibWozpUaspcAxhOKbLQBYV3hctV0w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(10067099003)(4143699003)(22082099003)(18002099003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VQAq+XXXbFBy1VWY4njZQCLbTw5nZht0InFyc1TNRRFGWf5lBGxegmZifKY4?=
 =?us-ascii?Q?11NGBjkYapIrxBmQDfDQG/ZkWlWDme8CB8Lkn4c9WJUxEM4OLaqZ9InhXDdX?=
 =?us-ascii?Q?hJz8ARyIkdGR8zx+9VH+/+847exwU8R7CcIqIfiLeJYMTP3u+F1Iu0uk1Ftx?=
 =?us-ascii?Q?rcaT78k1DFvyM32MhQArTAm+mcfaVbpXve6Ho1gklZ4r0ny6sWEr7oOeOoWq?=
 =?us-ascii?Q?2iE4TVh13QLU7vj4ZUo1Kxk538YPmGwtyulNUZ7pHHV03hRSC6J/iAnCJ4W5?=
 =?us-ascii?Q?IOYfhjloGe3JIt3F5Jxx4m6K3olbg9uEojiiQrXKzYMTNRIUXiV9Ns27PF23?=
 =?us-ascii?Q?M+m/MG6Jz/YD/LkKv0Raya6fyomXXXsfaMYcL4PBV/3N0u67164wLULrk3te?=
 =?us-ascii?Q?lh7Kc8NuaJnsRu5N4chyQYUA1cPJ3qcabqWh28/NUd+1H0ATEZ7n9eiBtcWf?=
 =?us-ascii?Q?0T0dyJJzeuzuifH41gU5TXpZuJ6hBBC0hq89SU3gTO+25mFbQkZ7z+ePTC6Z?=
 =?us-ascii?Q?HhRvxS9BL6r59bTaK9YIbAKgUj/fa9XUi2gZPAWlppI6UKusVF8OLADUxBXL?=
 =?us-ascii?Q?0yzhDJU87bSxqSw7FnNW9HdxLwFuzGlFRS6OJcMtmofcwX+HmqUlEs0uAgsE?=
 =?us-ascii?Q?gbGK7A54wwbZiN0Rs/+u2pqhemILY/Ruhcq7KwUcIrYSLi+bRPZ54RoPICze?=
 =?us-ascii?Q?uAXytAkHKxeilkNt57BXLzYOE7jN8Y7zANXGJRLyNWizkEZl/KtJztxE6LaZ?=
 =?us-ascii?Q?VGbWU+876mX9dWvUC/3O7kkiVPZYJipiw1NBWzvYaQMKH6/hlY9yOJkwvDO8?=
 =?us-ascii?Q?l+8J9wtMsiQjUWuLOFHH5C3Sh1PnPNBWWzFbPqeToboux4j9oeJ3Lu3PJUMR?=
 =?us-ascii?Q?seY+9kld1UmmYJbwwrNBhcS2C9188bXD6zYij+gJOFsYgTMbjJLxtMMjND1X?=
 =?us-ascii?Q?x71VdA8lWgdK/HBiXx8J+VIgYUxAaB2GDMB9kmU49l56JsUBpOqWZEPkrfXn?=
 =?us-ascii?Q?a8hHaR8PWkTS9iJ5ThbD1eSudiDCvGnPznMCKhpzd88VBFUl7n6g7sUVnA0t?=
 =?us-ascii?Q?MRY4vry8owORSKHzjP5XylRW3n1wYWR0f6GRvO3+JPVLt0K356d99DISQu/M?=
 =?us-ascii?Q?96kKBsv9HdSH871beuLoDuEJPbOUORR2fX0vxffsgb6IBFnSkjwSNDaUecjX?=
 =?us-ascii?Q?I4T/4qIJHJDLDZ0fe89+GNAz5Q5k2pNQShMIhVAP2bkNUvlQI+7cu5VVyaJZ?=
 =?us-ascii?Q?hX6KfnnTWCJ/RaN6OJuQsQPwqwVNdXbQsxEoO++rhP/jx1re1F/O29IJAxoK?=
 =?us-ascii?Q?xAIAae+TDKBJOX4aO1bna+l3jg9DTqj3sy8xLrczSX976kb4JI+7+6L4YtLy?=
 =?us-ascii?Q?cAVCdNJzyX1BNFTGFQ4zt2/FHGh0UxrDAHvViDmgzsnR588OuMCVWIE7IUi5?=
 =?us-ascii?Q?6hh5bBzZBHYaZ2FnUu391IwnD3CoceZPHBspSAMrXAp36i1s/XUNIqJzyqxj?=
 =?us-ascii?Q?NByBvdS5USEvCbaa3MqX/LqAXk7kUsZBPTJzsoFIkIKpsCR6N9b5o5iK+H0Z?=
 =?us-ascii?Q?WILsj1U31oeiAR+wJ2oEDJvyQ4Z/12N4YJZYs9XanzsE1v6A2DSHKCf12nh0?=
 =?us-ascii?Q?QomLleb9VCEzEUhWq+MLQrUkZ2N4pCy1Ojc9B3EFCAsYDv8+/jJqf7n5YLLb?=
 =?us-ascii?Q?fj9iVYYUTnV5KAIvk23UP0rzbJmpxTDOuZIDoJ4lvRIyv1tZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c082f8a-575b-4eb0-9ca1-08df14bdd248
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 13:16:02.2672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dqF8AheJJIn6/WpjXjSZffgr9ugO5RrEu7qrvhMbT8+U4FHDJkWOEcCVkcABUF2M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF266051432

On Thu, Sep 17, 2026 at 10:24:08AM +0100, Mark Rutland wrote:
> Hi Jason,
> 
> Nit on terminology below.
> 
> On Wed, Sep 16, 2026 at 09:27:42PM -0300, Jason Gunthorpe wrote:
> > The erratum (MMU-700: #3777127, S3: #3673557) deals with under
> > invalidation of a CONT PTE grouping in the SMMU. The recommended work
> > around is to use a Range Invalidate (RIL) that spans the entire CONT. The
> > only user of CONT in the kernel right now is through SVA sharing a CPU
> > page table that contains a CONT created by the mm.
> 
> As someone familiar with VMSA, I've never seen "RIL" used to describe a
> range invalidate and I think using that in the code below is confusing.
> I *think* "RIL" has come from "SMMUv3.2-RIL", which is the SMMU feature
> for Range Invalidate *and* Level hint, where "RI" is Range Invalidate,
> and "L" is Level.

Yes,

drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h:#define IDR3_RIL                    (1 << 10)

Unfortunately I've noticed a couple of places like this where the SMMU
terminology and VMSA differ a little bit. In these cases we've
historically choosen the SMMU naming in the SMMU driver to be
consistent with its spec.. I've definately seen this gets confusing
when talking to people familiar with the CPU spec and IP.

I had guessed it ment "Rang InvaLidate", but you are right:

  RIL, bit [10]
       Range-based Invalidations and Level hint support for TLBI.
       The value of this field is an IMPLEMENTATION DEFINED choice of:

The driver also calls it ARM_SMMU_FEAT_RANGE_INV, but I thought
range_inv everwhere made some very long names.

> Can we please spell that out as "range invalidate" or "range op"
> (matching the arm64 architecture code) rather than "RIL"?
 
> That'll be easier to follow, especially as nothing in the code mentions
> what "RIL" means -- that's only mentioned in this commit message.

The whole series uses ril as a shorthand for IDR3_RIL, and the spec
often does the same:

[25:20] SCALE Range invalidation scale.
		  * See below for use of this field in range invalidation.
		  * When TG == 0b00 this field is RES0.
		  * If SMMU_IDR3.RIL == 0, this field is RES0.
                         ^^^^^^^^^^^

So I'm certainly sympathetic, but I don't know we should diverge the
driver from the language in it's own spec.

Do you have a recommendation for a suitable short name? It is
meaningful work to rename everything in this series.. Will?

Thanks,
Jason
