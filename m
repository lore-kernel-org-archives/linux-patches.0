Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794486702;
	b=1buqcAj9Uy8wv2+LKbalTA6cyd9Q2iHu5MCPZT+FhMTx5MgE75KC04urIxIXv4M6L50V
	 Q7gCm7y7ex+ErFg8wJpkdhrFRO5KkKB3L+hPCv6MwGf+KnQn+R/mUKeURirTgyzaEH9FO
	 WP+co2loD3nveGHBP2pm+YaM6OF3/bbm+5tbSHDqTCDUSWS6wSCuCUeB4C2hv8vA3/qPw
	 YZmvd9Qh2wX5LcbXzVCxmgauw9unSskiLPO5iCXHh/r/Hupi9Fa/js1QaOYty+AeDYn1z
	 TWpOXjXfXk4N2/E1Yrdm2JjDXQVaq2kCdL837pkq3jMvHSShYb9V+ZYZf2vICpWeFCA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794486702;
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
	bh=fPAO9xX2EiafOjtqlrunrRFhNVdp//UD/8WLBd8aBeY=;
	b=bDMdT7ckvqWaMQFDBHryh0z0DMoGLPBYNUuDWsFUeyRLT8lg8LlFLGQhweC7DyRmRcqV
	 cTmqW7vtRrtR6LNTyR4eIQW3NieVuDFM4bt7maJ3hKPM7XuEoS3Udyk3P1LVEMbg6Blzn
	 mCjCXaOfV0dmfjNlYwdyahr+/ySeEUdhtrkyymFvKu2RTslm+YiIwVNpCGFd1SOl44oce
	 CNv3EUJhjW2CA7oxkykyIdqfMPkGuFHfX6mbYXKrZOntcUYMJepTi745fsFQ9NM7BtFw+
	 x/GZO9wFF8ZVZt+QO3t3TrQh16bB5Zf08srzs4F5Io5zma8V1foNzRBvrYZyyeKTlcg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=OVzttnZg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.14
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011014.outbound.protection.outlook.com [40.93.194.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02EC606A321;
	Thu, 12 Nov 2026 12:31:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B02EC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=OVzttnZg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MlOWADkA2X+CjdAr/5gcWDG3a9oVMYJqazBwjYIpOVxfBs7k8CWHx4jlKZoTAQJ/402GnDT9azStVHSMg6tWL9TDfx59JlZBAoi1VkNpC+wUmgSKHVrHty0TxYuqtl1/yRuVyFLB/Mo7xQiYAuJKDAfVNY7hFf8vBAEEJ9i0HbJDzTqTdnNWK6TVxzb0oKL3XA78mbfYiEl4we/d6WdOl5HEcfE/znivYn6be976GLCFyHfkoaxJRv2evnxde3bSu3EAnf/Lc68A9Nea/gik2XAnjpm5fk/0006esOtlfsETU4VqP14XbASgQSJNS6uRJrbM4NU0sDeBZMoJzWzfAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fPAO9xX2EiafOjtqlrunrRFhNVdp//UD/8WLBd8aBeY=;
 b=n8TX1rMrUD7KTEJxM//hfvEME60R2/Jrybw/Ci31HIgJQPuJTCaRxV88kQEnxBWpbBQotaBeOkUswqfGn7pV2PHB+dMHtEAKFveWRgmEPCAfp2fVOOrIyQifBIWJEkcSLc4vHEhe1CheX/8Bm/CHF7oXW7p1D2y70W41uwaZOwn3/bYIB17R7Ywa3bkyA5XpfoPE48hEvNR9sEhc5im6Ur2H2eCNLUjqZsXNgVG+m5wOFnSSi6vm8m5SpBJmhqRGXIa1/zfX6BQPZm/pJf0tQM/+ZqkB4mrfhsM1XLqRILWvPkYYwz2GoHNHV2HYvEwlSwcX8SGj4PW8PW2mc1orIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPAO9xX2EiafOjtqlrunrRFhNVdp//UD/8WLBd8aBeY=;
 b=OVzttnZgNyRDhXMVW+375a8QWhR4h1ihsjZ5l/MIHZvIH00OXauq5ZrmcPkO/VLp+nurr6fCaqszep6SuJGvWcgiNr5lGyu+vwwlFQmv5wpgWNarltE02ZzTWp+yVtHy9YpUG9NPFkqgIC7WDXPlgI+IWOgPsRlcuzE9tz2CM/O1d/s8ra9MUZqVd+jqh5GFRZMV2YI6t7WSa41WCX4kVv86K0fubQN0wUka73yuRP/yDAffjp8DAX1hWImeOY2oQCffal/YAezFYJf39i3DjMaN3z0valjTspUJWs6wr1bUINTJnqQeNqpOeM7M7DvqOqQssdiMAPpZS+Px0uO0xg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by CY8PR12MB7194.namprd12.prod.outlook.com
 (2603:10b6:930:5a::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 12:31:28 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0615.009; Thu, 12 Nov 2026
 12:31:28 +0000
Date: Thu, 12 Nov 2026 08:31:27 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
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
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261112123127.GK738765@nvidia.com>
References: <20261108183337.GL770409@nvidia.com>
 <2b89b830-f1e4-4304-93ee-40287a4b5b2d@intel.com>
 <20261109185315.GS770409@nvidia.com>
 <e1fe8fa5-7bcd-46e3-bfe8-368582304222@intel.com>
 <20261109234032.GT770409@nvidia.com>
 <IA3PR11MB91609724D29DA39CB0AAE25AE7722@IA3PR11MB9160.namprd11.prod.outlook.com>
 <20261110142038.GE738765@nvidia.com>
 <DS4PPFA84FA90FC31803C37BDCA2C11FCFCE7712@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261111141315.GI738765@nvidia.com>
 <73d5e5b5-2626-4107-8f0d-2203c53ddd43@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73d5e5b5-2626-4107-8f0d-2203c53ddd43@amd.com>
X-ClientProxiedBy: YT4P288CA0076.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::13) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
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
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|CY8PR12MB7194:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d3d62a2-1f61-47d0-7f1c-08df40b8dfb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|7416014|18002099003|22082099003|4143699003|261022115727099003|11063799006|5023799004|261022075727099003|261028144727099003|261021135927099003|56012099006|261021121427099003|261021123027099003|261022105027099003|261026140227099003|261102123227099003|261026121527099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	A1V9cEqXNlgbXagyKNWt1vWL8I8Hd97N1uP8gF999hHiS6h1TEifZU5W+Fu1Saf8Ib4pH3vV8sFaylP/IXDLEaznf33hTCihdFFBw8gjm8SJCmmsZ8hSccxDZ9BOyzxo035o0bkKBFLh8n9yJiDEb+F1UjoVp9J79YanPDcXT8yf9oMwRGcoQRtkyzZjJNTgWpOoQyaDetI5CsoqtAuJUXflmYlvxgywCokvuSqxb/PmZaH9t1vr2q8gI5jthGxmQC5ayX0i3i+a6OyqbUFJ/r8kNrTYnRr/O/Hj/RvCKFXu0taXyiWrXfnKZMsd4IOa09+5JKr4s1CISvTCmV+qT5EsvDUow+Vtpx7B6IU+Bce8UuzWrstSnZWPGgwfIMvlv2Odhs+8bd1i29Jvp6F/4N8VFs4q2K0LITtR45YzLGwPxW/LyR/65KEhO1eOulhoWhN6AJ3qunQPZn8CerUaGPaelO89PorAPwpi/83tARhQwAcgD9lHVgGvvfH22/uqOKnyNPTQcB+M0TZyaY6lnxPG8MxTp2c3odsQRAYlnUlW1meAA0vCTtNDgIcVoso/ZGPoI3eKgUP322L5aqjusDPs9iCGfYWIo4T5W/euj7w0AdAyvSNCsley50mQbwT+fMVZ+Lru/kzaDhWTxz/jF08TDMT8TxxEiOuIBrrhtDo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(7416014)(18002099003)(22082099003)(4143699003)(261022115727099003)(11063799006)(5023799004)(261022075727099003)(261028144727099003)(261021135927099003)(56012099006)(261021121427099003)(261021123027099003)(261022105027099003)(261026140227099003)(261102123227099003)(261026121527099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eCuFrr24g4Q9J/KjftjsqpJmk5DnVGY8dE3ZBD9VN5v6r82Q/+1aN0L/zbP+?=
 =?us-ascii?Q?yD2JOrgxBSbxlXzxllasN6r4U3+mZJ+PnPdEmg6WjoCH013MSODpGWOY/h31?=
 =?us-ascii?Q?61TKINgW318+V0tB1oEdbGDG9K2gXMQai1IZAz+zY0r5lbOADAS7QAQ/uEzU?=
 =?us-ascii?Q?tFc3PKUhrffbFb4o/MGUFeE3D9VmolD2RtAwCjfPyb59tD0sFesj+2MjyKVQ?=
 =?us-ascii?Q?d7BWLRLUp9LIchW/h+6Nm1dPPlqOItMeGgkaJ8sPBjp63R4mZM+rs6P5907E?=
 =?us-ascii?Q?B6Cd5+Vrd9e4Xf4lQs1lcFNak2IYnBdMxySQXFXw3DRBXzdJDl2aOab2ipYa?=
 =?us-ascii?Q?PdZ8qiA2usEZHGcdBdv/tRe2rdGo/nEanVr/o7GOPcDggoDYjXARzG8aZkx+?=
 =?us-ascii?Q?ZU6/BnqRU2JaIAk6uyfF6VGLGV4xfDgZIfY4Iuv3fZpq5OBvx2zHojw37U5Z?=
 =?us-ascii?Q?d6g6Z2lmwO0ReIzGUr/QUljlLStF1B0A57S+U0eTV5xrJUeGRr+gLtK2FArt?=
 =?us-ascii?Q?j/whz4Gd0AZ4+SEY6z1rZK51cjiBgrILyeuC95gYrRg5d29sCFooea6acHOz?=
 =?us-ascii?Q?zb6uk7lpwDdxShdpoZkPK0Qq7Jr6fFX0c3lgQU0Z8THmDQGgiabahu0AOtoZ?=
 =?us-ascii?Q?CP+055J5WaG4/24kaIrulqITgqnSllivCX423xk1S790w2hUtW7P7ZproeZt?=
 =?us-ascii?Q?3O5BJfJ52ysqWfZ1zRevpBBvzi+0BNEoJFjTv8FLQFxncfuLwsjegBill98J?=
 =?us-ascii?Q?WfB1UF5b0OIXvZX6XZtASUk1GOAlMqQL5V/Tb4y9r/Cgs5gJJTcV4hdf9QjV?=
 =?us-ascii?Q?FmRmTxVGePKtzfRxI2LWqXUH8njgkvhKoZv+i55ElgFxxsXLaDzzTy+04I5X?=
 =?us-ascii?Q?8GJ9M9vVO90RRGCf1RF9lgOOLJlyzfS7xEthumomCKjWvp5WHv3R9UX9tcVC?=
 =?us-ascii?Q?iTPAOBjsbndn8gludkZKsdpDRx+gkMIkTP+WE7OLGoyVobK/Y4TuOuIMu+Pu?=
 =?us-ascii?Q?PrTernskqO/JVETIQgn+leBb6SOacDqHnmBO7kzViSVtzSYYWIBC5Wl4Veyt?=
 =?us-ascii?Q?Zu3dBSNeNg3iAsO+qCoQNgWOXia60VRL51GwkYNdYjE4avG0Ca/OYDptUT3n?=
 =?us-ascii?Q?z1W9NBN+UfM5J5wYy80bfUtzuCGHRmhlsZfkBWRnsLehxaDwv4kKBdtbH6el?=
 =?us-ascii?Q?aIul7d1uQdJXRn5ZvUYW0ZGf6fXNoIbSxeBZBRZxxDuFS+R5BSh7+5aIXnDY?=
 =?us-ascii?Q?8h6XWZgzeRw49EmFs32ztYi14GnXfKvJIbpbq5quSQvw7hYxy+TkFuq+Jbh8?=
 =?us-ascii?Q?7bJYFKkhLQX5Hu4tS0ZK8ObRB4fPfm9h4+um7mIuFW33eTzSzsP0JWW5xaR4?=
 =?us-ascii?Q?IcuhjoJaZG9k1BFsRkWTYsCjlwwbADc6rIu0ov3TH6+n7XUkvIod19Q7Onjh?=
 =?us-ascii?Q?WdhfzyCgET1omLRwVKYWW1kJvX7e5u81fqObpyOSrrSca3wVN7SGTtn/CSLO?=
 =?us-ascii?Q?p16dA6QMdctHhqW6Y6JzR5YgVpYoEEDsdjR7CC24zHWVFS3/12lVRFgEcMym?=
 =?us-ascii?Q?Dc/ge0Vms1xfIjKUA1BKEohFyVD3HFL0CLsaN9od3vUYRUMDExVekv7tufG9?=
 =?us-ascii?Q?WlcsN/ceUndCxnWW8tlpa0yGwgvpKTR///X04lJvAP2PynkNGBXVIbSTf6e+?=
 =?us-ascii?Q?KcA/0dMDLCJuiHr0HBF8nil3hjF55Jw2LJV+iAIWN6RcI57n?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d3d62a2-1f61-47d0-7f1c-08df40b8dfb9
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 12:31:28.2550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zXK/mvMZQd6CNGetIs9ZcKuo4c7QwoU7jB/Ej8rtOoGH0F9j1+NpmLjIu6bgcHI1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7194

On Thu, Nov 12, 2026 at 12:48:42PM +1100, Alexey Kardashevskiy wrote:

> >  It revokes hypervisor access to MMIO registers.
> 
> TDISP's RUN does but CONFIG_LOCKED does not so MMIO and DMA work as
> before, until RUN.

I mean the device needs to secure itself, whatever that means for the
device. Obviously the hypervisor cannot be tampering with it while we
are trying to accept it. So the device might choose to fail all MMIO
while LOCKED or something like that.

LOCKED and RUN both clearly mean the device is under guest control and
the device needs to respond to this by protecting itself from the
hypervisor.

Again, my reference threat is the hypervisor programs the device to do
DMA after 1 second and then tricks the guest into doing DMA
ENABLE. This must be prevented by the guest and device co-operating.

For a concrete example, imagine a RDMA NIC. The hypervisor boots it up
and establishes a remote QP with RDMA access to all memory. Passes it
to the guest and the guest does DMA ENABLE. Hypervisor suspends the
guest immediately after and rewrites all its memory via the network.

Devices MUST have protections against these kinds of attacks built
into their LOCKED/RUN state transitions and verification, somehow. No
spec says how to do this.

Pretty much any device that does DMA can be tricked into doing
something like this :(

> > Exactly how LOCKED works is device specific, but from a security POV
> > the device must implement LOCKED in a way that excludes a malicious
> > hypervisor from undetectably tampering with the device.
> 
> The device fw updates (if permitted) during LOCKED/RUN won't be
> detected by the VM but it is not tampering as we trust the device to
> not accept a bad fw?

Yes. If you allow live update then you have take the position that any
acceptable measurement is going to evolve into other acceptable
measurements behind your back.

> > Broadly there are three device implementation options:
> > 1) A TDISP device MMIO is simply entirely inoperable by hypervisor and
> >     only works under locked. Trivial
> > 2) Entry to LOCKED cleans the device so it is quieted down enough to
> >     be safe
> 
> We run the attestation without a bound driver now so the device is
> quiet but so far PCIe TDISP did not require this.

There are many things the specs don't *require* but have to be done in
a certain way to get security. Enabling dma and binding a driver
before taking a measurement is obviously security wrong.

> > 3) Measurements record if the hypervisor did anything with the device
> >     before it was LOCKED.

> > Yes, but this is something else entirely. We told the device it is
> > LOCKED so it activates all its defenses against hypervisor
> > tampering. We take a clean measurement to prove the hypervisor hasn't
> > left anything behind in the run time state.
> 
> But measurements do not include the run time state (the TDI report
> does), where is this coming from?

Who says this? The measurements are defined by the device, they will
contain what the device needs to prove it hasn't been tampered with.

If the device chooses #3 then they must report some runtime state.

You both seem to have the wrong idea what is in the measurement
reports in real devices. It is not just a hash of the running
firmware..

> > Now we trust the device
> > itself to only alow measurment changes that meet its own security
> > model and the hypervisor cannot interfere. (bugs excluded)
> 
> Opposed to what, accepting any fw if not LOCKED? :)

locked should have nothing to do about firmwre update. locked is about
taking a clean measurement and preventing hypervisor tapering.

> > Updating the digest means that the guest nonce ends up being captured
> > by the hypervisor and presented to the next VM as the 'initial'
> > connection measurement. This does not seem like a good choice to me.
> 
> Does anyone actually _present_ nonce to the guest, not just forward
> the guest-generated nonce?

Yeah, ARM has this option and Intel made a worse version..

Jason
