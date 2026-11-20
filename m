Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795182953;
	b=q2LZd1ahOl882OPR4ZQ5z013L7CFJ9hXe9u4+8mI2uJC8UQuPDD2+rzEXfmOM0TCveLW
	 VWETwxMMkFgB5sS8qwg6L0jwurx2rotM9dbk5NPEQtICw5mwZ2CuvvKwaqR3L+dYHcWsa
	 Wo52NJg9voZ8KVp5wF5Ofa/iZdCrW9x44aMq3UuBKcNW4r9ZF8GPrRPOEigBKhD+Tb1ka
	 7VMEsCwVnkbbTlu9QE/4R+34aJz1DHik++SpP1unQmSZ/HyCh+g621JGKG/SR7Mp26nA1
	 GS9Oez1usL5bbZ4qwTHsoX4H14hhZjdw8tIq0LGzayEHtwueD+KiBKwSRWtqVBc7ilg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795182953;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=AsecD0ZCWD2gSVPfCapoGd7CHhxH2QsFKqTE0/BZIKU=;
	b=AFsEyRE+xE3svhKpO+LHwlLPKyO9Gqw+205VotB2tFATMTyaKkXqK2grlWtV4rHQnjHR
	 caZOv8mjBX6VXQgL0/aXJaj4oPHzPtvvcl6EnOVeoEsVk+py3SzFNsqMo6mWggaxJwRRM
	 tNeOzc4ZBsClhOw7ss20K1XCLt1L3GLy/F5rSb47a/q336RUMrSCUTg+ILtQNjYQayRvQ
	 FiQA4IyToLhyTW+fwcIbKON59nKerc6e6T82aFOnOAOmOECGQQOdZKJMLduYVZNVPaU1U
	 Js2bz91DcjWBt6nKxvpM757caMp49aqCcdKoPu5CuEOc0wHfCFfYoxdUwXBNwCEZJXQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Ab8Dgn77;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.58
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013058.outbound.protection.outlook.com [40.107.201.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAD4606A325;
	Fri, 20 Nov 2026 13:55:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAAD4606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Ab8Dgn77
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qBN30ED4mgmYbzg1ptaprZssIUOO1dTsikedjS0/hkaucQpcIw7niw7qL8glqXnTXSIdWn4DWhO93++SBqQ0wZmh65e6A0AZGxjOlIe4KbeG09Fwj7AHHTJNZ/F4kfCKLDYIEN8luEceRo9V4qitQm53Er9ksjeg7pS3vG7GTCj5RVS3+xb5+FypIEVXRYXLmbmFnwxgjmvR1Dm7dNfWXRTgf14JDuikRPiYAABPCEYePbZKbjVTZDY7G7AEcJgb7KmGQ0K+DrZaGUgBvF32AjiJkYFtIt0Be+Kxs/oq4Hy8x4gGwUQAQy1EnuNmVDHouxNZpcVPx8CzSdM/s20u7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AsecD0ZCWD2gSVPfCapoGd7CHhxH2QsFKqTE0/BZIKU=;
 b=M61IxRxM9Xeea/b9+c5GQHjgEvEUoL8pdwM+HsUfkA8CcIsopbarHbRkovtDJBRqe96Y0tA/bBXx1kNWLqK3jWmOF9IVD4PToahrgU3kWK7kNtkte3MyTPwd8Pn0GbK6bkuS7WB6L0yy5eJMyLxh1+O4LqLCYR/3N81Q11qm7aWivhpX10Nuj0A554S+qM/x0GOZ1/Dq9gw6p9IOF2E3vZw6bggrzODwz4K0ponhfpPoJ2s+dayUPP7+E94qEH1H2PtfcemH9+TUlZCXBBKZSjD9ajza+t8C+xdG8+PIz8P4Gy1N9GpRbDzITj7K1oLftzm8KR5xJwROVurup6T4ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AsecD0ZCWD2gSVPfCapoGd7CHhxH2QsFKqTE0/BZIKU=;
 b=Ab8Dgn77CoOV1vqdrgtfPdm57kSiC4IQgcs9xGqcpJTg+rjAMAmLR+N4BvugRAbHwTBossExCXBkhDRuZn14nU9tQm5Rp4BPvR3x/DXCfroDSSvcXykbiw3X2Y/eJ4CZGXLFSz2Vi502qcFjGtBBREdqfHSS9ue7lHttcsXno1Bj6qSFu6x2xtTGHiAMYB3pR6vxPNhHykcoXofj8pexWyVNAZK0SUmXCUm5WPyoRQVESCUKD83F2jJ6qPBI4pJo8hTBJhBneLYjgvrjFORf4m30fP45DnwJsZV8zrMls2dxfwMMg+k6X7KePdbGm6SwP58gaMfNjr0N00vvoQ59nw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS1PR12MB999188.namprd12.prod.outlook.com
 (2603:10b6:8:495::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 13:55:48 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 13:55:47 +0000
Date: Fri, 20 Nov 2026 09:55:46 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Alistair <alistair23@gmail.com>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261120135546.GV2245175@nvidia.com>
References: <20261106193018.GK770409@nvidia.com>
 <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
 <DS4PPFA84FA90FC465DE2D4A57521CEB991E77C2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261116143319.GA2245175@nvidia.com>
 <DS4PPFA84FA90FC9031C253514720694AFBE77B2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261117142027.GI2245175@nvidia.com>
 <DS4PPFA84FA90FCA6CFA44F36D6B9DE24F9E77A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261118133834.GO2245175@nvidia.com>
 <DS4PPFA84FA90FC5CBC7769BB1213B1724FE7782@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS4PPFA84FA90FC5CBC7769BB1213B1724FE7782@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1P223CA0038.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:5b6::7) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS1PR12MB999188:EE_
X-MS-Office365-Filtering-Correlation-Id: 204a85ac-5e64-4f2d-42a8-08df470dfaaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|4143699003|11063799006|261009223027099003|261021123027099003|10067099003|261021121427099003|261102123227099003|56012099006|261022105027099003|261028144727099003|261026140227099003|261026121527099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	g4GGNtEEJ9aXA1HkLibH8nKseMJ+mlBgd0uqKOk7hI/rpbwDKx3/hsjxSqROJ+a9TkfChu4a1gxp7zWtKj6MWAP5qH7mLVBdPs1I7KLkY71TEU1Wm5aBx4YLfQKWYRHBzT4fCGPHYltWPXUpIewfnNp3x0LtETCyuqV90YQhHoAeSULWCqqd5DU2N0f33ykWfqqin+xMT4KYphNgbI25hiefDTj4MjZ87m1htRPvkIZ6OgYQH5+Y9dM6zZvFgxsMPT4v0VGNFJ2KxwLT6lb9w7SLpOhKqRES/IHI2FsY3KhugMehoP1nYxjbLYhKaXH6gnk23AW6tj7vh6lXeZioqbgmnAEJLDsw166b7VgLnFQORS/kz3HSZRSaz+Oh/lLklCrZz7tzCGnxe5x6RTe8QX6uK5IQStHMTU2OeWW7r4bL7/o1Z+Bq2N96TotqBmxQag9j9JT9lo8N0ii+d8xAffML7I24GdYys6hewQClNlnTapvIOC1GVCx21sFeyOe9IrCqTVBKQbn/xFUVRstmNuKl6CDA9qo2txO5btkCKHgW+PDnqr97LRS+9szqkilw8yvctqcLxYVKOvoeSW1hgTqC7XRneWuRpmuh2vBI+z8tkczb2gsIyLib8JlewDStC0T/4jn8SpnfCCWajydgsAuioJVeG0QhxRAdyDhugCo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(4143699003)(11063799006)(261009223027099003)(261021123027099003)(10067099003)(261021121427099003)(261102123227099003)(56012099006)(261022105027099003)(261028144727099003)(261026140227099003)(261026121527099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+qeRCLb4CCl5urqAwmfdITC7+Jvv04/eoy7N+vm7MeIZJn14LzhYspE8jAbN?=
 =?us-ascii?Q?a2afTNN4f3iuLE1mCDauMmjQh4xoYe0LfEPjW0iIXN4anjwhxsM9iKi/iBf5?=
 =?us-ascii?Q?cImzIuYNUPn8Nj5nxKecc4SgQlyuW0pssD9+pXTnyuS5sD4W6WCTxYtAZoa4?=
 =?us-ascii?Q?jnlzzeMUEA+cuvq3VOdlvGs3lGYPSl9veJGcKSor/HuObORoXyrs2yJVKYHc?=
 =?us-ascii?Q?tRDhwU9N9DceDH6MvFQnjmainkFGXVF44nSyhhx23UjfstZjA8mGL/OSdTCZ?=
 =?us-ascii?Q?mmTdGp39HprsZ+fs9yYBriNMvbhUQ4odX8UOofCTh7yYKOfMWIOtlveltAPj?=
 =?us-ascii?Q?KrkTWOc3H8GAq0OofjKk8EfEmEytPZxtnPcrPosxfCp/u0mLzaCL21zPmDCx?=
 =?us-ascii?Q?5e+IB9vx0SvTzdebQT+4L+DoFDLMfCqnywNYyULT+ATdy1iFxRrAgAca4yzO?=
 =?us-ascii?Q?jKZFAQMmiDaRG8aSTgoU/nSiRFwvxswwU89TxFtJIVHHcMnGumxpOqB1egru?=
 =?us-ascii?Q?7VlT3PXqGO5B6T0y6B8fHSfMT1+alhi61BBzvSJogyrLXP6yoroBW34Db1xp?=
 =?us-ascii?Q?DVOm1tVqjPWIa98afE8Ntx/Ua0RWaho/Gq6w/TT5UqspSqmAuPBHEA+Pk78X?=
 =?us-ascii?Q?a9yh4v5GTiQ0oyskV7kg49XLTTPklMZDLNFhnTHOSRN8VlCZ7SDkil1EYywS?=
 =?us-ascii?Q?QQBYA4AnTueL0tEBMJeeC+Y4LKexpSfI3Qa/U7aX6GpjQMZuO0k3G6IW4WDG?=
 =?us-ascii?Q?K4KPmlDXa4Uz+7G/GF50vWcYRL5gMXx1pUx3HP1ucaRZifgdBa5GiDwqbEQ6?=
 =?us-ascii?Q?GfeusfaIrQL6OCrhQ8rb5dUCViXMCXpyIwjbx97NUpxoSeuVTsAFqLaEHL1K?=
 =?us-ascii?Q?uo+VgXOzS+5O7Nxt4/izp9md+ljLOWKQrqikuFkuR0a76qqviwHarJdcnqlV?=
 =?us-ascii?Q?UTM8XfHBrn/6aXCVNRHfzNmwttbxKpPBB9G9Z+IL3NVYk3UNYzGmVwOfu4wS?=
 =?us-ascii?Q?gd7d7sfjT59rM9G6IWVqbX/NKh1aKdCLZhuqk49F7VWdSrkDXC27ONamZgny?=
 =?us-ascii?Q?CwOH7072JXf4mwqX5+31PbHkqTBmHZ7UAp5s0OUNOokjRr4d37G7wmQkEp6j?=
 =?us-ascii?Q?xSyeDFtt63EbYCnF070FAQJqKhIaefkcIe5CneUucSQbf0oPj6Qz9prVeRX8?=
 =?us-ascii?Q?16IxylYgTy4nHf4T7MrJ9GtNc19U2FDn9I6y8gnpy0n0FALaOZgXZwuYeg0x?=
 =?us-ascii?Q?WSu8HKB29MulznQinCPmaj6RhnNbP87tOdsy2A4ggTA9SZNf6fYU+JJzdfjI?=
 =?us-ascii?Q?vA2lUBWWP+HCujvU5siFCkm0z961l5SwbIN+6dyUi5SGqb8TH2W1F5cyIMnk?=
 =?us-ascii?Q?UNKmUNTs83EV5j885mMqd0l10BPaD08yntP1KejTk3khjf3U4DYzJR+HTBLk?=
 =?us-ascii?Q?rq7zqoN7Xex9+vJFM+ma3wp6hDhbpIhjeGPfBA12fYV4MBF+fT7zgGqhhzkn?=
 =?us-ascii?Q?EAs7FlDO1YosOq/an4y+gOT9SkQqq+XfzFBXmmYx1xvLG4hShzfQ0N4Zc6k5?=
 =?us-ascii?Q?33SM8hhfI9wUVCz7cOJL6EQMoJMIDrzIZBN49M0fr+ZviyByjyD1xFx8PVpO?=
 =?us-ascii?Q?iudV+jrJnewS8vEuZHhMlHXSkrSO3jC5K37VuV4mo3KjCHkWE928lb2zRAFf?=
 =?us-ascii?Q?1loYre6UsaclEXifCyZe+kGSbE28XPOgE1r6v6yENP9JVwtZ/i5RT52vsibB?=
 =?us-ascii?Q?xZr2kyh9SQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 204a85ac-5e64-4f2d-42a8-08df470dfaaa
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 13:55:47.7502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XI5yVs9NaRRJf5n8CDBgs5ekX+Bcm5sN5W5R5Rh7QomADyh3mOBP766hdqlpBRTS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR12MB999188

On Fri, Nov 20, 2026 at 01:01:28PM +0000, Reshetova, Elena wrote:
> 
> > > > > And this is where in our original SPDM_DEVICE_ATTESTATION_INFO_T
> > > > > struct VCA should have lived instead of being a separate structure with
> > digest.
> > > > > Would that be acceptable?
> > > >
> > > > I'm not sure what you are proposing?
> > > >
> > > > My concern is you have this digest over a struct that isn't a protocol
> > > > struct, so we have to make a special API to pass your special struct.
> > > >
> > > > Unless we can get rid of that I don't know if I care what you put in
> > > > the struct, but the kernel will have to break it up and your driver
> > > > will be more complicated than it needed to be.
> > >
> > > I am trying to see how break this struct the best. And the only open
> > > question I have so far is where to plug VCA (rest is clear).
> > 
> > ARM has it nearly right, VCA is captured in plain text as the session
> > transcript. This TSM directed capture primitive is what you need for
> > 1.3 because we want to capture GET_DIGESTS and then pause.
> 
> Small question here: why does the host need to capture
> GET_DIGESTS given that we trust TSM to verify the transcript and
> integrity of provided cert chains to the host? 

We need the slot mask in the OS to present to the uAPI so we can know
what slots are valid to fetch certificates for. DIGESTS is the message
that has it. This all has to be done before telling the TSM what the
slot is, before key exchange.

Yes you can make this more convoluted by having more TSM API surface
for the TSM to report things already in plaintext messages, but that
does not seem good from a TCB perspective, plus it means every TSM
would have various bits of unique code to do these entirely standard
things.

> > > What is the usecase for this given we have above 3 items?
> > 
> > The one you mentioned, single evidence collection. If the device is in
> > "TSM Controlled nonce" mode then the host can make a single
> > collection and present it to the guest over and over again.
> 
> So, you mean here like "initial device attestation evidence at the
> SPDM connect establishment time"? 

I don't want the TSM to have any opinion when the evidence is
collected. The OS/user will decide when this happens. If OS wants it
to be 'initial' then it can ask for it them.

> If yes, then I think TSM controlled nonce is misleading, i.e. it is
> not about nonce, it is about the time when evidence was collected.
> And do you plan to support this model in Linux?

It starts with the nonce, if we want to mess with the collection time
the first issue is the guest cannot supply a nonce. We can't trust the
host to provide a nonce, so it must come from the TSM.

If the TSM provides a nonce then there is a host based command to get
a new TSM nonce and perform an evidence collection. Obviously we need
to offer a way to freshen the evidence if the user so desires.

The userspace should control when the VDEV's digests visible to the
guest get updated. The host decides when this happens, but it must not
do it asynchronously from the guest's perspective otherwise there are
unsolvable races.

Yes, the feature seems to be about controlling the time of evidence
collection, but the actual mechanism is giving the TSM control over
the nonce.

I still don't know if that is what that user wants, hopefully we will
have more clarity soon.

Jason
