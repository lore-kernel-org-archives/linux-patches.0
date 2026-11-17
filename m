Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.67
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794878327;
	b=1gtHzGAM+yWe5hYZ6aOxNrmtaSQihoZMLr8QVpv2oUOlv6a+URPGWa19OMFKjW9q7TMe
	 2sNDThkwoEgwtKoEIcLZ+9BJUMhEvhzsEoORYp1eBHgoH4NzqM5ZALpFZ/JnBfbj6zfU0
	 MgEklXN23L/vNA2eYxOgsUy1xD0K+Yh/P5QjYWVrR8CAU4LfGiAf2Yp03hZndNoB5VzeO
	 P0ma/EXD2Qez+NlOtpghXhNxUs9qJVFq7k6j2dSFdyuSGQHGROmkHDCiKi5Ht1ZfrrXBu
	 OrfFQN77welVnTC2XeqUtx6tP/mJu9zL/+vGs84WWQYgY5idRYs60ot479GXw3P50+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794878327;
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
	bh=gbczNrw1Qxnh71rCmYRXJS3YYFCROZTFA/hK0/XDoWs=;
	b=4mIGfQKweTkZhUwPz6osOqaG1WaCUS6M0eEEcsEyEEK1BcT1mYXktXojkiWehRlh9LB3
	 6Yx3rIQwYy+0rflJK3qQVMz3wtsGdx6yk+LDcNKNDKD/FcVBqQirXksu1IyWZ/yf+NSsw
	 gid9O1E0pNYOISKMJ5eX3BZ5KYrc5D7Odz+OTQc+2TwgroRI23FytflcMQbi4wtUpgIsm
	 0V9eaU321koLIfaK10RR9eEHeCyLfuYfqUfmLrp0T6r34z9nKqncfF+vbSWoR2qcKWR/c
	 zfj5Hr9SeUr4aeqdCzWyXAQPEqaBclGjPiJBgMR5W2c2wEkkOE2Xfwv9uv3CU7uenUA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=U4UWIPbl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.67
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012067.outbound.protection.outlook.com [52.101.48.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71EA606A31C;
	Tue, 17 Nov 2026 01:18:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C71EA606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=U4UWIPbl
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pTAEf6odJRjaAhO6zZGy+kDir27pUBWetrFN6nq1Slj5tEGKUhOyjXspDo4+HCa+QXkc5I8NI6Gszu+CAXE7nurs6yOf2aymUY1tx/GTGKKroUhhV+u74EbRBo644N2zrurKTJvfX4YxGHkLUByw0TRT1DPpQ4r6GTeb+Dlny8B51eAxqUh1k4KyDD0zs10ecv7HjtBig3Dw4+vduBuKtEpGF6D2QGDujzSfvmOwTNwoU//T3BxFAtmlU3gygGmNZ0fYuyNcOnVZ9Tv7/2IAbCXM0HhIvQ9xLS2t2yqTT37vq301lbvSSObLd0kr12vd80bbAjNNTLBUZHGzNzjCmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gbczNrw1Qxnh71rCmYRXJS3YYFCROZTFA/hK0/XDoWs=;
 b=zS0Pk+vVLXHicuKgyMs3jN+TOftNrjPbf023Snubo3PfYN/7en+K0xifmEDoRel3VQATiJbieIcNv7wtpOKhtA23PtxTNdYnZE1EVj9UIbSlN2nwtq1YJf0+inTZ6ICK5FdNNdbr/Xd0yJf59R1j+SGuaU+iQQizPR0xjC0ZS5z2pb4+7NbYc9DbieqGnC8PkrOT5IgihMhkkQYOSA7lHpnvgPLu6+OQGffE9XjzrrtQ7gusEuYcanNiVqs4cHyijM2WKKiTWVrhGjwL804Z+WEIeBmwgxePftGPZ3aW99mljCHuPTClCM4rskD/QPlqASD7GnMn8GFSWPxfNhyPYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbczNrw1Qxnh71rCmYRXJS3YYFCROZTFA/hK0/XDoWs=;
 b=U4UWIPblsgP4XHxK0A0rvXHyRkVlpJy9fUY02U2K7owcRGOwAbSBO471neD848miaX7b3rWh8M6MD0xYFWKXUa8M1LQJrH7/sVCW6QeO6+eWwb2FwrZBhTq66mWX+Hsgk1dLtvECeLlHN8+px8jemkvmnjOqAR4HmoDh5RconNU0sWt3JKFA90T6IHwiLkIlZv77qt4fOM4o57KMhcc4QM+53IxzF133nYbUSPkDCjpEzDXX1iPTV2YU+0DxatZlrmuM7EHqWSgom281Gox8a8mqjrjD2p4wsF3pqpYQ0ItQgoZCf9mWaeTjlmb2xz/+uMEyVfcsSjRBD3DrSlpjVA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by MW6PR12MB8757.namprd12.prod.outlook.com
 (2603:10b6:303:239::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Tue, 17 Nov
 2026 01:18:39 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 01:18:39 +0000
Date: Mon, 16 Nov 2026 21:18:37 -0400
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
Message-ID: <20261117011837.GG2245175@nvidia.com>
References: <20261109185315.GS770409@nvidia.com>
 <e1fe8fa5-7bcd-46e3-bfe8-368582304222@intel.com>
 <20261109234032.GT770409@nvidia.com>
 <IA3PR11MB91609724D29DA39CB0AAE25AE7722@IA3PR11MB9160.namprd11.prod.outlook.com>
 <20261110142038.GE738765@nvidia.com>
 <DS4PPFA84FA90FC31803C37BDCA2C11FCFCE7712@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261111141315.GI738765@nvidia.com>
 <73d5e5b5-2626-4107-8f0d-2203c53ddd43@amd.com>
 <20261112123127.GK738765@nvidia.com>
 <b0efaf47-5a94-4922-98b7-2000ae9a405f@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0efaf47-5a94-4922-98b7-2000ae9a405f@amd.com>
X-ClientProxiedBy: BL1PR13CA0363.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::8) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|MW6PR12MB8757:EE_
X-MS-Office365-Filtering-Correlation-Id: 46b817e4-2a2a-4032-f8fd-08df4448b5d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|4143699003|261021121427099003|261022105027099003|261028144727099003|261021123027099003|11063799006|261022115727099003|261026140227099003|261102123227099003|56012099006|261021135927099003|22082099003|18002099003|261026121527099003|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Zu3maTY2E7o4PhYa2VnhhMNXsxiH1ITuMpDNyMOXh953StsVmyFpCSZxyhNZBzz1h75vs7CnwedUdlE+FQW2bj3Dz3+ISAlSTjy5biycuBUFgpWIXIZMOd0+fgBZifymaLl4c0dlaEPheWp3bFmMfhxcK4KTXKAa1PKOzlZRjWkN6H3kB+G8aeZ7Z6FV/SOcrJnJlCa/ZWvxITaLhFu4v7TDlZPoD9C26ccGL2N4Xfc6nqvQ2bAmq3Nn71YV8ea4h8Kzsgl/kwvMwrgFtjLk83uiapQbKfyX1zf0z3YWxoA3DI2Mu3ood8Xt8pGvWX5ZmF04Qm7yWCqxgozU3Kspa6zxNV9uwOpFSNPoVJC+7KBNSwn21n65GOrmieZ5MgfPP2RK5f4A9FuWKdcue0WWbFGmGNSsN2pE6Kj+IeeKdE1+yZ9HmNnUGM8DlQfQhhyGCPft1CEDIGQ/crjLyq8TJWJ6ke9rgphDIdfsJVLVo6vt5jYrH3d6ZGT1XAiZcW7RsVJ8UJMOQqmI3CGs5eWnAOnzlcHxLsRZHWdb/Ion7D9ydx6uMYrB52N6OdNIm3iKyjtxtJBjcV/oJuGiNnHIyNJnJIOX0sYNAM8ytGvag9t8CQDfGbqL1o3KJIhTkDhv47474P7ZS0JHpAi1ueJmb0PF3GdOsoVrbEcA4vzs6/Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(4143699003)(261021121427099003)(261022105027099003)(261028144727099003)(261021123027099003)(11063799006)(261022115727099003)(261026140227099003)(261102123227099003)(56012099006)(261021135927099003)(22082099003)(18002099003)(261026121527099003)(10067099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6ZyAUk/xKbe38iA8lfzrhXW6HOb5LRjiq8DTmRGRh/AIn0fwgqCdAyM0zN/H?=
 =?us-ascii?Q?gC/PnIvby4zeordmW4I3jahf8NbLZe6ppHurH2Td+PbUjTX+eedVQjJjYSlV?=
 =?us-ascii?Q?wAEoQ84+Z3jO2bggZOOnkFenohv/IfjvcGSwc7A1kSSSZwOvL/iLtyjc3uUK?=
 =?us-ascii?Q?CEDaZ0qHyga8Me0tkjTqftKoqz55Q5QEOf2yaR0g7oy7IgtTdKZd9Bcpn/9x?=
 =?us-ascii?Q?KmaERCZsHNeGIi/uDOSq/9tso8tKt4o9gZXDXIn27uU4lk9D6LHUkMtLyrus?=
 =?us-ascii?Q?lEOYCafzsl+rKCUjx0YjgpNygdc9DVyotcJLPlydEO+8DYaXIJD/igLX/UZ/?=
 =?us-ascii?Q?k3qJbF8fjjFy17jh8PRjblmKoCLLdFOSjWMm7jCnKwTrBXyMmfl0aQneLIH7?=
 =?us-ascii?Q?CqEG8ZaKgs19wLzMB9idwA83Du7b3k3pwEwcCtIrOTvcbk9Au0WrJ9cySfyo?=
 =?us-ascii?Q?/toVwJjtCzhiTa168fK9NdbAE6jQSisf956WrFWwDGmQ3F0c+7HjkULYFf2R?=
 =?us-ascii?Q?GvejOkUelb7Ue/acLkH8F4ngViY5qdIglLhfqnLAADiF+ykqVaoAqDu6hrDO?=
 =?us-ascii?Q?GGVvKWJVMkTyewHbXzl92G9woVzKyWwvJlQCS69jQktEoqKwn2GTyrX4DIN9?=
 =?us-ascii?Q?LO66v895rU2jkgu/lJQZWV4XFVX9NH8cJiZ4zkFnMRud746AFfsN6lfO3vqj?=
 =?us-ascii?Q?zlLx1RnIeQOXyJaUAl17PCosMwkV76U0N1YQzS4U1tUmyfjNHVsxiaVVkWXn?=
 =?us-ascii?Q?7Atd7xN4C63h8nkOcp/xlL4UqWpLr5O6kuujCao91Lc1Bwfw6uAevd6MHTcH?=
 =?us-ascii?Q?vPRYHRw9THZrk+gGAaKxFmiT99e77lKo5w5yUSxInM+hd4eQVI6rMmesuAqZ?=
 =?us-ascii?Q?wRLUEQKIVb6NQ62mD8hNq0q6/khvgx+r8S0JtIZT/1bVmbUi+XboSkZgGst1?=
 =?us-ascii?Q?Frujt0daR0CacsI7x/K6QNqO1sTTKXAVOlzIwXCGZlrNWfOARw4faDXdbaH9?=
 =?us-ascii?Q?MDfDoIjp8c1EjFH6o7HJmOST2Bh5Dy5JVe1IhQ9tj5fInOp9yOk/rt2PUvLq?=
 =?us-ascii?Q?GbiPpOlkT7lMbPXjLxylYtSA5S1A6qw2WOOGFZzpfk8uNoCpm5STaaxtX3hR?=
 =?us-ascii?Q?JJoKuJlohbBwqHINx5sB1Evcy42GnLdvFtJ9B5Mvut2VIq2+0McUrfKoQ01B?=
 =?us-ascii?Q?nLA0/wFzZIrbgGpu7IUjABMxQKiORCKHZJNH4+pm7rVh30GEE9gN4wMvFzwQ?=
 =?us-ascii?Q?9Mk40Lrxc6TWQyoMwYF5oMq7pyAvDJgBmxHrQ7sEjLdWWlRwG9h/N0NmC5jH?=
 =?us-ascii?Q?wbsnGBDuecT8U4VPjogcJFCDnjYP9OoWY69oE/ZjWRa/RayATEUj9h2OC14j?=
 =?us-ascii?Q?67YS8Oon1fyUPsSUo1fhr6Q7utcK+jbnI9l6s6oCIhugcxeZKPccM18fyd6V?=
 =?us-ascii?Q?Y3TqhA+OAuQH4UgY1OHFCsfQJeI95z8uvFS41UogSsirrmEVEasZTWUbA9PP?=
 =?us-ascii?Q?cTtjs/lSUnMVoLihniLe8Qlanr1Ox3XpfrJGTwhToef3gzwCNjb1b5vpbsZs?=
 =?us-ascii?Q?6iw+b19kPvM11cgOedWvquSrwIGS13kixAI3GLq3cwuTqe2MZe4CLmHe+0UA?=
 =?us-ascii?Q?gVb3R0rUZ0kDEKuE1AykZDe/+bb8wTpz+h3Hv72E6zXsJ9yLi2YFWhtD6C36?=
 =?us-ascii?Q?q+7jgl41daro0kisNnZ7xkZ0Ro0Jwh8pMd8z8L6B1a33coymTf0qUgylTBQp?=
 =?us-ascii?Q?YGmvVeCx9Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b817e4-2a2a-4032-f8fd-08df4448b5d7
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 01:18:39.0975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sPwGdw0IanjPa00zqDyj3aTpqRkJhl4G326AsKXfpk7Xe7wJE20LwHWzQYfBYNli
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8757

On Tue, Nov 17, 2026 at 11:48:26AM +1100, Alexey Kardashevskiy wrote:
> > Again, my reference threat is the hypervisor programs the device to do
> > DMA after 1 second and then tricks the guest into doing DMA
> > ENABLE. This must be prevented by the guest and device co-operating.>
> > For a concrete example, imagine a RDMA NIC. The hypervisor boots it up
> > and establishes a remote QP with RDMA access to all memory. Passes it
> > to the guest and the guest does DMA ENABLE. Hypervisor suspends the
> > guest immediately after and rewrites all its memory via the network.
> 
> Then the HV is in the guest's TCB, no?

No, it has access to an unlocked PCI device. That should never make
the HV part of the guest TCB. Creating that barrier is entire point of
TDISP.

> I do not know anything about RDMA NICs but there must be some access
> control. How is this different than giving the host an SSH key to
> the guest's root account, for example?

It is completely different. The entire point of TDISP is to take a PCI
device in the system and then allow the guest to accept it into its
TCB.

My point is: when the guest accepts the device it cannot be "Dirty"
with state and commands loaded into it by the untrusted hypervisor!

> > Devices MUST have protections against these kinds of attacks built
> > into their LOCKED/RUN state transitions and verification, somehow. No
> > spec says how to do this.>
> > Pretty much any device that does DMA can be tricked into doing
> > something like this :(
>
> So we basically want guarantees that bus master is off when
> transitioning to RUN, is that right?

No. We need guarentees that the device is *clean* before we do DMA
ENABLE.

Clean means something like "just reset"

IIRC we can't change bus master while in RUN anyhow, that is not how
any of this is expected to work.

We expect the device to respond to RUN and LOCK and do one of the
options I gave.

> A TDI measurements could include the VF config space but we do not
> have TDI measurements... Huh.
> 
> Sorry but it sounds like the device driver is the one which has deep
> enough knowledge of the device and, upon transitioning to RUN, can
> tell the device to stop/reset (via encrypted MMIO) while keeping DMA
> blocked.

Too late, DMA has already been activated, that breaks our model to try
to activate DMA somehow after the driver starts. Plus many devices
cannot reset themselves just from mmio..

The device knows what it is doing, the device has to respond to TDISP
in an appropriate way to give this guarantee, or it is security broken.

> > > We run the attestation without a bound driver now so the device is
> > > quiet but so far PCIe TDISP did not require this.
> > 
> > There are many things the specs don't *require* but have to be done in
> > a certain way to get security. Enabling dma and binding a driver
> > before taking a measurement is obviously security wrong.
> 
> Well, I meant that the driver can start with encrypted MMIO (or not
> encrypted) and untrusted DMA (SWIOTLB or vIOMMU with only shared
> mappings) and then, after the attestation, switch to trusted DMA
> (and remap everything).

That's not our goal in Linux. We want unmodified drivers to work with
TDISP devices in RUN.

> Say, it is a the only NIC in the guest and the VM wants to run it as
> trusted but the attestation server is outside. Reloading the driver
> is just easier.

A flow where the VM self-attests is really weird, and I don't think it
can really be made secure in cases when the NIC is involved. We want
to log the attestation (Eg to a PCR) and then the online verification
can check if the lohged measurement is acceptable or not. Since the
log is tamper proof we have a record of exactly what was accepted
before it could have compromised the VM.

> Right now my guests request measurements with a guest userspace
> provided nonce and the PSP talks to the device to get them.

This is basically right.

Jason
