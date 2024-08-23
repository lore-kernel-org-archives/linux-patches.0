Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DD661FFC;
	Fri, 23 Aug 2024 12:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724415279; cv=fail; b=BUAC7dA/wlmuYMHpHoV5N6QJI22KbHilG7NAW6iYwD8HjVQpxOWD6U0YPw6kTMD5YMvv9IenOnPpkARmWwPZbfd+zD8toljlT/ClAjsFwIb8WtMOJa9qqldHNYoET/gvGBl2U2Wa94Q0GI5YiFQ0RxoyUISjzVGkdhteqS5GF1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724415279; c=relaxed/simple;
	bh=EWiKMBEtQKkpiCFrkaSrEKGpSv9tGNRrgYAOn1QX3X8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=n+qUcgCMUgbks75OaC6FUROFcIm2kp7+gM/gdB8O9IHnCbLB2aKmqk9+5Qig9BQQObMhVUnIY02IHede4Rk5hBYN3xtfZeGslraZx/mW9kJWTcbjbMvU3hJY/9JNk8PzK7WzM/1gUqb7mPaK2NB91VnkabVxq0UJ+Ws3g6Y7VQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pS2SXtXN; arc=fail smtp.client-ip=40.107.244.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pS2SXtXN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jKMgz+fKG1w6pjO3AvCoHmjaBKq6lZZfJiy6HE229Vljvk8DAg2vD/nY7u4SOV1btbSchY7Pg1+ZDVpRK7qhOa7A3ztzS/UqwvrhoM01K+2vaycdRa2f2zMrg0hBp2eKXdFfBspcK6njMEvCPUlN/L+7C7JCQ/U7yuFf0iqd1NmIJeyQ8AIveAIQ2V9FTNWcYelPlBeldShY4qrHOpPUPU0Fmz/mCTO/SNmXm5B+2PlLHt6r4YWRtmwABD+vkQo1uLfc4GzVPiqdaRBCoNg+qD+MnO79Hr9cuwdTJ824x+YiWeqBMTHB6gJonHrd4kdo7CsaDy1CUP29KsYt6OEmIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F8sWw+SCxRLZtFuHRhYfu/v+69CmTf8frPOdS9i62Sc=;
 b=S8l/Yc1adbBMODkBpyAnuVstu5FJlTu0pWJjMew/9sDWo1Xxn6h88Wg0aWNdWQ5oGkUpsbAQDaFG5KhViNQP9pqTB3tkdnBeEJpcNDFbmdwPqQHZcuVqZKUWQQWR4Tc/mv/X5gMxvq/I/VUnIHsu/TRQWA92YVC3eUd4BLhfy1yF8cD9ULzhYdX+PWBtMBKXYHR09sjt45WTB2H/YqEjOdmCzCyX1yfSwOn4UMeVwIsVtm1+cQ7tbLJkVNXjudbLmpdV8xMWwLN3r7m6MZEde7PT3Je3NjkUKDs6dHSTONAPULV48z48p8VoOWNdVYOVAgnlQAS0osgR654mqHYebA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8sWw+SCxRLZtFuHRhYfu/v+69CmTf8frPOdS9i62Sc=;
 b=pS2SXtXNhJLkQpH4AQDIf8Ls0lzWVMVzlFqGzkVN1qBasFlYFpzwC4u1AM9yQ72C2xpHllnM0uy8C103klGrSbxLMyxxAVke2xbKX7BBXzUq50GlJmGBPsdf5tg0EP7yuCkk57t9KnUuqrh5Q5ftCaZ0mdAj1NETiaiNy8kesiydvUXUxTAiOlU1goqhDm3Nlny0htpiLalIIBiFvemFBNpU4f+4UzSLy7SzTG5X9aLGErdkjVkxbqaOOqUVLIC3fNJi0K1CF5kb5g6poK84RQhgkuR35DTSwHRGXEz0/B1ch/uRoSeKZW3wFCYFgnWuiGIlPvWfp4wNII6jPmt2ow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CY8PR12MB8068.namprd12.prod.outlook.com (2603:10b6:930:75::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Fri, 23 Aug
 2024 12:14:34 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.014; Fri, 23 Aug 2024
 12:14:33 +0000
Date: Fri, 23 Aug 2024 09:14:32 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Joerg Roedel <jroedel@suse.de>, patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH 01/14] iommu/amd: Move allocation of the top table into
 v1_alloc_pgtable
Message-ID: <20240823121432.GA3773488@nvidia.com>
References: <0-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
 <1-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
 <ZshVuebDjRH5qdvF@8bytes.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZshVuebDjRH5qdvF@8bytes.org>
X-ClientProxiedBy: BN9P223CA0013.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::18) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CY8PR12MB8068:EE_
X-MS-Office365-Filtering-Correlation-Id: d9a718b7-5bc6-4b81-c37a-08dcc36d25f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RGo7qV5zVsmpnS0iwbjUxhS7yujThaVkB90LaDsWyPvqpL6SjV5cVESdX1Vt?=
 =?us-ascii?Q?9cvnh0r9lwR9fOEO6iCw4hKQjD849GrPEKaXGBXk3Lff6bfbAtw4ueo9XOw4?=
 =?us-ascii?Q?FyQE0IwmdEd8hy+Ygj1tFR+5XC9H/9bPeGceMo7YnjSWDcXwFiA46W2qrCpx?=
 =?us-ascii?Q?0mkxcONvKL7yxIsybcaOLws4nPqZ0ZHos5xXOtdJScFU9Y3CEV4DA0BTtBS0?=
 =?us-ascii?Q?rbFrCImQLUbHsHJIZehIqTh/Rr9alsxDpPBRdWIwq3GrxP0w85s1Zhp3a0MB?=
 =?us-ascii?Q?e1gmqttmkpUFodfaa6YlsySHfnANQZO44UoRXuBdv1CWzB35/ltalEBy42mK?=
 =?us-ascii?Q?EibrdDNhbzipvFls4lONyYpqQBGrQHAbtidkKyKwVajXw4Hr79y1SXJk0wVe?=
 =?us-ascii?Q?t0YP4G3XABUNYgWj6ESFHUERDoSDekJqgVaQlYzottd76rYaGBTJtx7NkavK?=
 =?us-ascii?Q?Jw/TeyilzysXblzd4kNNfZU2zZRbfHvrdEsNXc/wQm8vF2NBecsx1erk54MY?=
 =?us-ascii?Q?zdBLFXZc8Xnsf3a6xvTvW5jFzHbHCRqweFxwfw11TkqF24ZFr0tHT5LHQA+P?=
 =?us-ascii?Q?zKYNT2f5uD+iQJnPsqHGHWwavinozfX3wHhj/oNJ7oV2fOplmBG1ke6B8a6u?=
 =?us-ascii?Q?9HUs8aAof1GssNtplUCIF/RsUxEo7N016nq38o2fr3yafFGbkdRjjpTjzwF4?=
 =?us-ascii?Q?d2r46MXSFUPJT967bulNyx90s64lt6iPnspGkNPmJbcoEDkig6h0vl9xdkC2?=
 =?us-ascii?Q?2lLx7ZTkdVNEKewm1TBlj7jTP11pb8VwYYRH5zRc4IW+cxZ5U150EeJCS0mw?=
 =?us-ascii?Q?OcjiAnSOfI6V1pWHf8b0YlvsYKCLEAy/cRrOPfu0U8XA5j1PcfVXwO1LF5zy?=
 =?us-ascii?Q?zHnJU7QkOlpefr8X4e5Yd8qFdSVx1r2G/KraUlemrz+fVBHYboYToZRhxKVm?=
 =?us-ascii?Q?a13MQPqJRMy9EqEYXzgVIR3crQ7g6Mgg9SbL1lB+bU7id9S01u9M2Pk32rdy?=
 =?us-ascii?Q?7Kn6GUjNicMoyQmeNMzbtZPHamGgIQW8be8xJt/w69G/7P6ZE4iygFkFQ5zV?=
 =?us-ascii?Q?t7Q2WDHFhIfIkkkisJe7DymlYaoE8DGF/8q7eLBb+AX2AJXHnQvmE0MwlfiC?=
 =?us-ascii?Q?sKrViC7R0Rsw3goXEq0PlxBIBVAWaklvtbsfg7wevbKA6O2HyPXS/BE81D8F?=
 =?us-ascii?Q?AlUxF9KTRY1t45g96g38N/aiRalr5F+qVuHt1+akwVLFqY61yhjug/pfKyJL?=
 =?us-ascii?Q?UGI6LUIyFoDJOyQB5yQDYbnSs0KX0PTGc7u2ip2mR5IXWxuGF8DzBuyIXXQB?=
 =?us-ascii?Q?WGRnbnEmqOTtozVYmBQK818oLWYpjM5eiBmaev7sr9s4XA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?H9qoYFjGLPBM1Y4fMOqTaOhb60pZBcZKF+fv7RoB1FqVhZCp0pjdRWm4Jw6m?=
 =?us-ascii?Q?luRW0934V5KXyV1oy+5LfBGNS0hvT+i4XoeVNaCKyYk60XwECGej8Y/TXW7g?=
 =?us-ascii?Q?CGME2+x/1yquhxLphKB7iTwDYSU5jQMPaN9QNZlK+EkJlHr1mRPaVYXzWncD?=
 =?us-ascii?Q?M6mV8EvP9NMRr9KUKFcfO5xrB/AJ7DR4ufM6yFvLILtuSmPiJRilZy0qBL4I?=
 =?us-ascii?Q?XbjKoI1PnXdNMwqfIbkEFjxcdWbn6EOAKxVOY+bOFdzRyg/nO72FQ4G6q4ds?=
 =?us-ascii?Q?Hotg5hPam2wA2AGl1TLSBauyiJMzPlIP3PriagtD038VUCwWSDd/nVvz6+dQ?=
 =?us-ascii?Q?ip27u9Dlp/rMDqcGkpeUJ2Gb4Qv1Jx9/lo9foRANRBbMqxuWElDXhJB902RG?=
 =?us-ascii?Q?8Czog+sR7XghxDtUJTidfVI+ppaLnzWU5IPvoxUiHJyl2+KmLe+1knX7tzt6?=
 =?us-ascii?Q?xhNQ9Bxws+78HGMZOx6/2aaVyy6Fzo0I3V37ek8QwwtwLA0U00Km7staF0MK?=
 =?us-ascii?Q?oA7nDkoGy2+H9o+wqZMxY9XYyep1u8DYKo8BGYCIJm81P8gBVPVKHbLhDpPa?=
 =?us-ascii?Q?cJhCoPGRjMZGselBIFxx+NQl4qTgT9HUkDYxojF0sJfTt7n2sn/rX6+oHWS7?=
 =?us-ascii?Q?6MyifCr7Aqki3CQvP1cSJ2uSd1qRafkOh6DWRFEqNVd0y17zmOqzkjK6uKXH?=
 =?us-ascii?Q?YfG4f08bfbvV0c3xPrCoHLY9vUSGyEVRFaOsnZ+Be3sb4e0oFmmqylR+7u1F?=
 =?us-ascii?Q?70OqlSUpZDYJLZ2khsRWH6xVifaLBOaAYBmgayYhmm8uCSPq+vleK6E6HHcK?=
 =?us-ascii?Q?M1crK+Gkw7zHqu9TX4Lp2oUsDx/ENROlVEiOubdi8x2S9HEs63IXNaMXOUoq?=
 =?us-ascii?Q?l+o8uIrIrD7h2uA5/hmKVgqAcAKwY41a5EUwS84Ids1Fc7/WNHDZFVbmmQ5v?=
 =?us-ascii?Q?O8AVgXxk+kIJUUGSEL5ANb0jDpfUN5VkAvaH2jgiQZERdyJaQQlAe6zQejEF?=
 =?us-ascii?Q?230a6TZSqbvqwaTKYaqdF55PbOMu8O3++SNZpQTAlgWh5EprQRN0imdgfDme?=
 =?us-ascii?Q?S7pfd8Cdc43fkGH2kG6Zi/ZiqKk0CGd8owfXB4Js2mT7V3mstKGVZuVkJ0YN?=
 =?us-ascii?Q?kip0l91ZbjLCm9rmWwLIcBw5jKYlpGjL07lEGt440qPVydl3Jr9emza4ft/L?=
 =?us-ascii?Q?nuXyFcx7xwOFd+gLVezg1iYAOLjEYvZPlJg5/pvaj0R8YshL1B7CS/81SIoP?=
 =?us-ascii?Q?8ur6t6D3pKKdHyXGGi62zz0M4aFN/GXJtUaJB+e7z+KRLiR27vu6Yb1pq558?=
 =?us-ascii?Q?1jx4fA8JMfEAn3u277qKLo9NcM0BHrZrwlGnRinF0MuLcdMCI2tewhDINNF4?=
 =?us-ascii?Q?mbwmBQ5vIDD36bPbd6Gh9FhxYLnN1/a1AWCqmpFHFkFglwBYGm2+zxqzBMsG?=
 =?us-ascii?Q?mlBHZy+PwdXOOrWdaB/5h4sUtVxuA8Bm09JsilEZar7qGxWFUU6LxxLtyhi+?=
 =?us-ascii?Q?iLJf80R5Ak7dWZgDHmYY1zxUOsPH+N/OJE1KGykpmvQfrMfdYjks+9Wbpv/9?=
 =?us-ascii?Q?508c/8nLShfJaiUz7vykDyLaNGNwYWBH9dnUx7OQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a718b7-5bc6-4b81-c37a-08dcc36d25f3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 12:14:33.6749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S+DP7ui/vjtM/+0vukR07W+h6KXe8c8zJWSc2gb1ZbbgAXm7XLU36PinqvjyuM4/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8068

On Fri, Aug 23, 2024 at 11:26:17AM +0200, Joerg Roedel wrote:
> On Wed, Aug 21, 2024 at 02:37:07PM -0300, Jason Gunthorpe wrote:
> > All the page table memory should be allocated/free within the io_pgtable
> > struct. The v2 path is already doing this, make it consistent.
> > 
> > It is hard to see but the free of the root in protection_domain_free() is
> > a NOP on the success path because v1_free_pgtable() does
> > amd_iommu_domain_clr_pt_root().
> > 
> > The root memory is already freed because free_sub_pt() put it on the
> > freelist. The free path in protection_domain_free() is only used during
> > error unwind of protection_domain_alloc().
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/amd/io_pgtable.c |  8 ++++++--
> >  drivers/iommu/amd/iommu.c      | 21 ++-------------------
> >  2 files changed, 8 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
> > index 1074ee25064d06..05aed3cb46f1bf 100644
> > --- a/drivers/iommu/amd/io_pgtable.c
> > +++ b/drivers/iommu/amd/io_pgtable.c
> > @@ -574,20 +574,24 @@ static void v1_free_pgtable(struct io_pgtable *iop)
> >  	       pgtable->mode > PAGE_MODE_6_LEVEL);
> >  
> >  	free_sub_pt(pgtable->root, pgtable->mode, &freelist);
> > +	iommu_put_pages_list(&freelist);
> 
> You are freeing pages here before the IOMMU and device TLBs are flushed,
> no?

No see

 [PATCH 04/14] iommu/amd: Remove amd_iommu_domain_update() from page table freeing

This is on the domain free path. It is required that the domain not be
attached to anything. All the TLBs were flushed during the detatch
operations already.

Jason
