Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010069.outbound.protection.outlook.com [52.101.56.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3513935F8B9
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 12:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770987399; cv=fail; b=O6Pwo6H67nwMsQlG7xqBFu5SIeOzKLTLTQazYfngi6VjztFSfExDOhKeTDHf+0BBS6uHp5HGq1FMHRC59PlmHWEc8eRw97rUMCDzUuDLbhUPsu3RNtzygYR8y8xGCzoV6sBA/6qTy3nakcAhQbIhJudt37b2YHIa3OnEmOtd2n8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770987399; c=relaxed/simple;
	bh=A3s3g09O84BtLMOoACp3VmzbAGj/yfoWpVtj6R6qBJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Zk+mBDSQF57mUDx0DgLf/suvmkbMRKV/t7IWv668Pnjgs0zApvGRc7hhqWDAmE+nJxV9gef3kAbwinue+DcriOdwyMfZktZ5rNt3mWFy3OocYstDnFsb/tbCpU9jkOHmONo+1nZ6h5uUN9pGsZdOHtdOwPmwOizmjQazpamj1GM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Rza8jW12; arc=fail smtp.client-ip=52.101.56.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Rza8jW12"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UvEvw7T/L77YmwPykLsLjNoRhwKJ8TTclo9NiAgJwCrmwGm6wYUFDpf+NZyEQLvW1ffxpzsarSW7+K7AnHrQJguFYKhwmjd0CksWiMpHLKxJLdKtgx/jKW9RPu4/d1+GCC/eVE04VjzJvh+gPEyQ10jpkz31funp3SSh2KJsIq10u88FiO7eb4erVTPnZr2zUYpM3F0IMG7koSlnpWMPYpMAGNlqe+/Fggg3TLOsCn0hYsQvOboY5FKDsLa4GYUgQloedeI9v6xrEZlTcWTO11722jm6n2IVtqxe71OuQVvQLoM+rHqUOWX/kAzPZMF3U7xZ4+MYBpkq2pLtj3wW7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OPJSCjozEh1l4/PVhy+d9on6xqGwYGGRSUpfABNEO2E=;
 b=YieP+2306zxbnNRji4mJJDJaPG4OlbsB21XaHvknXW/XXYYfpIxbOWlDKqUOTwQMDnhsZQjeD0HM/oMlKvBpVA0aIVnckR59646Gr6Hc7teNlTdGJV9Jy7aUwu8u/8v1ePwIeI3DuAwrPlaWepWXuk+kcmOeESAs3OghqBk25KwBdO8TDkqncTIeQMOsAJnfUAXuLryPLIC6kjuxa4tZWmf8juV9APnorspH9gx7BCBRy1iIPxmTq6NT5Vi2eMFu9Tzman6aNf6SvCsgzUJWb4Sv88P5PgYI7wZCEBxNhXT8YelIqiEjqfTLZCUL5jczpVqUVZojigVuC/wd3dojtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPJSCjozEh1l4/PVhy+d9on6xqGwYGGRSUpfABNEO2E=;
 b=Rza8jW12G7nb760x9QiPSMRsQL8N4bJZ0A7PQU7T6UpYYBLJleELYT0DI6fgGVrEeCFUHOcS5gS/kMeJfziS7JgqsgH0xvALVr4lJsVnXmy9PFHB1bi66kzdfB3DLiYPMvpFaQSLpLQ77K35h/MSQYOHyfmFUiK5EI87wGFBMLsfRN0fyzOd9Iqe/GVJ6Xzww5adQY8LqH+RkIkA7LuDfdZV9NmY/ZEkN+bI7cJJoqmpYEBM8r/64CDjGYj2K955PH6m0TyCt+7CiFJnoIuOP3piPUtqMF5yBGK1a2p7e96+dLt5T5KygQAVorOA8ibc1MqObTMYBtHD09wloE90Jg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH0PR12MB7011.namprd12.prod.outlook.com (2603:10b6:510:21c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Fri, 13 Feb
 2026 12:56:34 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9611.013; Fri, 13 Feb 2026
 12:56:33 +0000
Date: Fri, 13 Feb 2026 08:56:32 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	linux-rdma@vger.kernel.org,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH 04/10] RDMA: Add ib_is_udata_in_empty()
Message-ID: <20260213125632.GE1218606@nvidia.com>
References: <0-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
 <4-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
 <20260213102240.GK12887@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213102240.GK12887@unreal>
X-ClientProxiedBy: BL0PR02CA0070.namprd02.prod.outlook.com
 (2603:10b6:207:3d::47) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH0PR12MB7011:EE_
X-MS-Office365-Filtering-Correlation-Id: f0f8842b-ae7a-4fc2-1996-08de6aff506b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?s/h3KLlZk5NaXMfZYSOp8YC0aKs8oopgaPR01f5LUvB++MoD0x89fc4Z+tYL?=
 =?us-ascii?Q?+6PO/agNDFI/AK5oa/f4MNtNsKtDYEEbRvEtgPetbhUX/pVGl7wkKhwIZUyh?=
 =?us-ascii?Q?YFDhmQSvXK3zmViYFimbkb21aGIw2XMfTrEGJNtJXlORRdbRUbCQrPDe49VF?=
 =?us-ascii?Q?FL/GXf0v/N0SfM6xzi5eFt9ZjDIXV06RMcVe3qENNE1PISDLehQcsK79YgfF?=
 =?us-ascii?Q?/RkcVsp6rzDUZWIQ4HaWju/JEnJGKeRk+9bXkzGjXZeLAqE9f4BfHFM8B3dR?=
 =?us-ascii?Q?otzJ9NvRl+c6mdqNcRaFFyNTmtAg6dNExKm7ijINOB/rjF3I65tMi528Lj1r?=
 =?us-ascii?Q?+v2OvUnCt6k8DbPSYfYsWNMsRv2JHxAFdPtd4cOVcTH8X+LlADXQSFMc8zAC?=
 =?us-ascii?Q?raZ6hH3/cjIy8uka2io4+rQmrsnP+3glkkb9vJWiEm0Bo1vr7uKg4R6Mn1eo?=
 =?us-ascii?Q?7Ntikh3lAmQtzOMmFZkWqAsM7In8saCJ6tX/ZEX7l0fKzKVtMKBORRuL8lYX?=
 =?us-ascii?Q?i1iBFHMxJM27mkhAvOBy1qKCSGH9j2FewZ/3kwRektbAqRqVoWyjDisof3DS?=
 =?us-ascii?Q?VQeS9xrlElim/THKJp0Ozds6rwiIOlOr/7swhSBpDdDrpPBSXa/3wSTn6rdG?=
 =?us-ascii?Q?yQczIPA7Onfp8eqzjhOEkqDMwowKVfGK77uKcEY5q/8QePN3JkwQeImnS2hG?=
 =?us-ascii?Q?q6forGorShxbk/MnkrN/H4GPLR0dxM9aV0ueHbe1kSqc0PdQ9+F85BWj3j8e?=
 =?us-ascii?Q?LXRUg7M1zbI2Q66MXUGKqGaTq447UbBt1Wu1iS/e27O4+i33Q5kvB/tt9FNm?=
 =?us-ascii?Q?98Cuwdcc1qF1zPEXmrU8exXnXwry6ewCogFmBKUwdgDy3PlGNr88AHmVCeOn?=
 =?us-ascii?Q?y74uXXODlx03nlY+6iN8MeT5hdHNed5OprwAdFXhNnSNO/DVRPIjRIn96bEo?=
 =?us-ascii?Q?lCbcmnM/r/erB8qBQVyfULwgGM3gpxa0l8zgAl9XrfkkdYlGkogcN3ls8BJ4?=
 =?us-ascii?Q?cxouOxy2aknfAZ/638p+mjZIdFdy3//LpBCxncLdEc4Tg0QC3vs8Kt+ao6dM?=
 =?us-ascii?Q?So1JO81MkhSHT2Y6lIPmmiWHSOcBTPtvxUyXkY/USh9E/ilk2+XZMMixsnOc?=
 =?us-ascii?Q?rJaeJgBOnAy2NB8EdaNi1lh0sIqOml77fa5p9rddvzSd8iTDVyT9MztViWEd?=
 =?us-ascii?Q?gTOOajcfk87NvF5JjSamemDtgGmFZIk4azvyTD1nLP68YNJx8UqkJ7Tnljar?=
 =?us-ascii?Q?oKkcwqT1b0Y8shoOt9Q3dn7FPI9g5u8+KZMFBhe3KEVRaYTM5oWYVaa2xZXj?=
 =?us-ascii?Q?mtZ6LqRcXdMqJuuBo/xr98JOkAlNe9T5dIiW8QaNf05lQ0kZJU2HNwQSY3Sj?=
 =?us-ascii?Q?dRPwvRZUCc0IJYl7Ofw8bFAj04AK7xUEY25jKlcgmDWhcSfU96Ke7NiERf1S?=
 =?us-ascii?Q?TwMPrtFkeP2Czzftok2YFdwfulOu1ZODOo1Xd5MuWPi+7CZqHI0spOoDnnuo?=
 =?us-ascii?Q?9LznSLytR903xRG+X9NzaKAwmHv5ygWlb5gJvEDqPRwTR7Mw2BDLblnQIXZX?=
 =?us-ascii?Q?EjeSBmi+VqQJd+KsIIc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e1idLN/tiYIUKHgvXYD8GdyFXPG3wRvbJACIKaLCNowgoNZOC0X6/CxMN4at?=
 =?us-ascii?Q?XYjEqGUQQmspqnH+enZMDXCz3tD0D3z+3IITfVIk4I4PY4+nF6aE2Ozmt79+?=
 =?us-ascii?Q?RTAAu67Ii9lkkB4sxF3Iwc8eL4WKV8pS6JhH9VfZE+3rkZK39tC1QVMtKvLn?=
 =?us-ascii?Q?fxB2+krzD2UhqevgqJQZb/Ved0uDEQ10xGZRV3n9MTUGheBbOZlf7IF/qKun?=
 =?us-ascii?Q?feausiFpsGMXB2zI/WsQtkxjrHPa36+kBISR/EoagQYCc/M5+S6P1WbrD0FK?=
 =?us-ascii?Q?yXbboadENETbixw8y6nJdn3uZ8isPluSiv93j4NuHQsFzWm/YmtbPDyv/SLQ?=
 =?us-ascii?Q?IXSko67T//Gh1xU5N1zM+ZeXiqWMbqcjrp3xe4BzzvmRdaBBR1Yyn/5n5L9P?=
 =?us-ascii?Q?KyQ067FyBObBR5BO67JjZWRrBEItX2F1MfH8eVNH/lXoh8AgIZtf7XnRaQNt?=
 =?us-ascii?Q?qfextYJqYQFC+mCW4cAS9Hc2zdJBMRF5tfPh0Bz3N27bpp5D+EtMO8qr/i11?=
 =?us-ascii?Q?cWsMa3aTq6oUDrXsih8OCxXNAOz+/SVqBuIxPvelzZBCXzn85cIbs10HF1Xd?=
 =?us-ascii?Q?E/J+iQFUwOBma4wyeBb/MbnpvoUmgp6orP7+QKOWR4QN8b5gocIDPrLfZvxV?=
 =?us-ascii?Q?eL2SmaV5ehWl4S8CjMWADGIvQ3VFN+t5sO2WPjIe8omJshxPAzXbqNaWxCTU?=
 =?us-ascii?Q?KsPwDM5ruLdRvt/in29phS0dGwgSm/dgaudQ29Zu5euS8nXajh1jJ8+iBHvC?=
 =?us-ascii?Q?83QEuko+IvHT0/agjDK/y+w3B47vNUgWslBQ+N7cKwGYfKuDK0Eo9cIDpHlG?=
 =?us-ascii?Q?5vREXuquTJCd7k9bCvTDbikvEv46RE+/GOtCOo0zTSJS/B1XGsomX7qdxj44?=
 =?us-ascii?Q?AfRSyNeBgnWIlUujC1EseY6J8yhIrCQ2MI3qEiWkwCouqFNkQYFTys44g7T4?=
 =?us-ascii?Q?yrWKrfxLCFRufCsdgBfi753y+fj/YpfK4DtiYkrT1dXlJ9exBoF7CEraIXKl?=
 =?us-ascii?Q?OK0EKVFF3NxQG0hGzMO6wGjkatFgUNpp1BXC7MRLUCVnXrLOiu4OacQzZUHU?=
 =?us-ascii?Q?el+FJIBmalgAwRr80EzBInTpA0jn91b9p9GEweMFskZep+Nquc356gNoCA7G?=
 =?us-ascii?Q?JNpvRAAIhMI97bmYiN+poiyNY2oKtacRDUHD/px+WgYAqor3nulwNzH/+Way?=
 =?us-ascii?Q?yV91XukTZVBDIWYGDwlngLKK3+f4Mffgpzs5G7bDMI4BeFwiBUiJUuyZudyE?=
 =?us-ascii?Q?4AwoLzYdnOGVEloY/4QVBANpaJJKWbVeWi94HaGLqGbcKG1LBwXJXL10bU4M?=
 =?us-ascii?Q?Jb7LvruHmMRZ+1/DE9bOzsudPV9jp2OAerStlxJxBzLY7ODW90pHk8DEQfpi?=
 =?us-ascii?Q?qBrHn6n4PpEz5wDHPVkXN6fdun1+abr+hm5K/SLKI+UaHej8jGd9YkZjsK9+?=
 =?us-ascii?Q?80X7pqPs769OODQtk7XNJPeh5G2eWGhdZ/2A6zt5AcpR7l6gtRtZJyPHfjEw?=
 =?us-ascii?Q?FdzyA6DhodEuXKvwqahFVQG2MFY5SigQzD3IYeo3m/QPKkSj1CVStzpCtnNQ?=
 =?us-ascii?Q?s7jbXPznuVYLfvu6nLRZqFVrmiw9zNCTxsm0nDQaJpGGs4+qOt54GRlX+E+U?=
 =?us-ascii?Q?B+16u/xg3IdSGScVj2e5+u1uQ10yPVy37h6XF2TiLF3x4YXRssFUp8N16L1L?=
 =?us-ascii?Q?bgBrs4GjlhVNRVbQpOCv2445PRYIL7QCywv/jxRdfLj0FzaCuQhhub5GhsNY?=
 =?us-ascii?Q?LkXPcQMxxA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0f8842b-ae7a-4fc2-1996-08de6aff506b
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 12:56:33.3315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6KyXFy5y3k6XYn19hSFs7UPXBmFnzv9N26fQK92J+hRVuvF8G8KIZ6vahwZQ2gjq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7011

On Fri, Feb 13, 2026 at 12:22:40PM +0200, Leon Romanovsky wrote:
> On Thu, Feb 05, 2026 at 09:45:38PM -0400, Jason Gunthorpe wrote:
> > If the driver doesn't yet support any request driver data it should check
> > that it is all zeroed. This is a common pattern, add a helper to do this.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  include/rdma/ib_verbs.h | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > index c0dd82a77e7a13..973d9ec6875e63 100644
> > --- a/include/rdma/ib_verbs.h
> > +++ b/include/rdma/ib_verbs.h
> > @@ -3119,6 +3119,20 @@ static inline bool ib_is_udata_cleared(struct ib_udata *udata,
> >  	return ib_is_buffer_cleared(udata->inbuf + offset, len);
> >  }
> >  
> > +/**
> > + * ib_is_udata_in_empty - Check if the udata is empty
> > + * @udata: The system calls ib_udata struct
> > + *
> > + * This should be used if the driver does not currently define a driver data
> > + * struct.
> > + */
> > +static inline bool ib_is_udata_in_empty(struct ib_udata *udata)
> > +{
> > +	if (udata && udata->inlen != 0)
> > +		return ib_is_buffer_cleared(udata->inbuf, udata->inlen);
> 
> The number of existing callers of ib_is_buffer_cleared() and very
> similar ib_is_udata_cleared() check caused me to think that udata->inlen
> != 0 needs to be checked in ib_is_buffer_cleared().

There is probably something that could be slightly improved here, but
I'm going to leave it for another day.

It should also be using check_zeroed_user() not what it has there..

After my next series there are only two remaining callers of
ib_is_buffer_cleared() and two of ib_is_udata_cleared().

Jason
