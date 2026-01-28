Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013044.outbound.protection.outlook.com [40.93.201.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E723590A3;
	Wed, 28 Jan 2026 13:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769607193; cv=fail; b=HRME84WhxkLpwYdbeO+JkjTR8r0NCnxMB12vo+EW2u7YIex51SKOg8t99cIpHFCAzSymQVNzrq1CgXk0W7zKv0uIC4EnLL+fderiU7uIwvGjMvq8vd/09rSvHXGL6w6PZ+XC70bKRLG/f0xHfdT5B+35aE+087oOW5b0sCQdOaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769607193; c=relaxed/simple;
	bh=4zL7hwOkoG5k3qvN2gtPjedKGZicqfxROY7dlsT3O8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KT9J5jKawZ7ErBomrjVYOgwenrZon32pIUACJWuvwvzpdos9fpW5e1CIAohK8+Odm3nTjB1ubPZ/dBXh9c2W+mPuFvuIHHh0BNGGXzGBGT2bnAI7DS2VmHe+gsfpj8G3pg9VfxIz3jR9ARpTbqdY+qoCw81cOv3ndzbGsPDGXmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qKfc3iRw; arc=fail smtp.client-ip=40.93.201.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qKfc3iRw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=doZ85lF6LwVvINxaJrF/nmXBjOrb6x+NUt3+RRN73cqIF2qdVjxRyW8INLlRVhunKQByAFDh59KP1pFLMSkxf4RkFEAbLWMiDAw3cw/BwlnY/izxVJ11xukp+lXw6XdrmmAjID08c0HmI+FabiiaFCPMmvzF42ngXXlE7+nMJhAUe/q1VClarDNlUo1fZuhsRPOoQTRm+dAfvezJcdRaVIPQQ5xOxWn7PVnHS0f48fcszR5X+3RkpRJMy5VLgRwMRPZWCgXaaDlloRDWTSv7cWV92xJiXF+027K3y0YpkURE0xblZ+g6RF3NjrEPn9lNvc00INvATu4u3hC2Ww//ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5p8br2m8GZ+vPCSSJpxM6S0RMhByROiyDRrLLe0nRMk=;
 b=R5StvXWxWGiNOIBueSoqsrzyXxW8+c9qKele+gBB0WAZcAx99OwuPHEsCWVom7e98HZIyK/AX00W5c4qL5tIOOHUg1UMkVT81ddmu89ShYexxunUprHYUNQh1eD4oiRFbRBG49RLo7oStV4UkpEgyY2WHUFn/2Ib0fBzrawtQpzug79xQk2pFtEQe25QjwHfMuIHhJO5YLFhVVwU+QO39FtkFK+deRJutw13aLhGLwPE4ancJLOj0edBSUswXhl3M2lm5mRfFZ/GMGyIX4mwfZTUMnQSHpA8/9T7aj3wVH2Lgh5aWMt1xxJGZHImb7/lR9iy7aOcnfkUGyHzhIrFHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5p8br2m8GZ+vPCSSJpxM6S0RMhByROiyDRrLLe0nRMk=;
 b=qKfc3iRwR0UrVZpGF05OsnRFln6jmzKzGP+PCk+TKMI7Nk4lZJecfLtCZ8dbhupkHj5G3ZGyXw/yBGijH6inYUkgqxIOUcRD/P9HGVfd0mUCGL2x/+zwFdOnE95tvYdeFW/TM5wDoml9lyksZvHAq2EJNpzvH2j8p4KHnfvoBUFYEIOROlAMt4vZ8ybhDw63ZYdJvWS9pVUqNE9Q/XitKP7uybf8eAN8kfkDTxsFz8N2HhCbSAt9xWVuRiWFc4f4nB6C95BL2MIhRoC+eO3VgEoa7Z8c244z5PG6ubTQXRJ7vDkib4iL4UkJF5kA/09zBTiewnCxDl+4f6tNbSZl1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY3PR12MB9607.namprd12.prod.outlook.com (2603:10b6:930:103::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 13:32:59 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.015; Wed, 28 Jan 2026
 13:32:59 +0000
Date: Wed, 28 Jan 2026 09:32:58 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>, Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Justin Stitt <justinstitt@google.com>, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev, Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	James Gowans <jgowans@amazon.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH v8 07/15] iommupt: Add map_pages op
Message-ID: <20260128133258.GY1134360@nvidia.com>
References: <20260119173734.GL1134360@nvidia.com>
 <e8cb2549-6a17-47ce-8e9f-96c576890262@amd.com>
 <20260121170931.GG1134360@nvidia.com>
 <5a3dfc0a-eca4-4de1-96cd-b4034f0b8e06@amd.com>
 <20260122141240.GM1134360@nvidia.com>
 <0295a5bb-2567-48f8-9806-0467907143d5@amd.com>
 <20260123141413.GY1134360@nvidia.com>
 <ddeb2bc8-5088-4d16-bea3-91d58a4403e8@amd.com>
 <20260127142512.GD1134360@nvidia.com>
 <cd7a2d11-bf65-4445-8eec-df9ba7950128@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd7a2d11-bf65-4445-8eec-df9ba7950128@amd.com>
X-ClientProxiedBy: MN0PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:208:52f::31) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY3PR12MB9607:EE_
X-MS-Office365-Filtering-Correlation-Id: 63646bfd-83f4-4fb4-d8fc-08de5e71c0ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oKS2VsLXWlnfVWxQwp8meNf4Y7EWsZXJ/9dP4ifCLgfi9bae/8vAAabBeIQa?=
 =?us-ascii?Q?rCQK8gJ2R14zQUBqRauXn52VGZEi9Qq0q9wX9YpabZisF2YTVYQvezV2ze7B?=
 =?us-ascii?Q?3dsClmRAshQqF3vuJAVd6cV70TVgmgiqPFsUaUtU3+RD57m6+QW0waLaroy8?=
 =?us-ascii?Q?UmQgUzVUH88ToO8Y5eZFZlYq/XbNSgcJ8rf69iuIe5cafAX+ilGkTlHxxOhA?=
 =?us-ascii?Q?8+1LwGdb8iOiX8cSgtG9GaSy8sXDrL+5+X6BcCAiItY1HR6tOW5PqpTt8Y3K?=
 =?us-ascii?Q?i2M//yE7qIhY7hsFK8QKT4FerIIJzEFjGiNYTBK6Zsn1IFgAPvuK+w+ywa9e?=
 =?us-ascii?Q?CkB5/sG7pmIevR1gxvpB7iHxY5udWjWEF8HeqlGejYX25whWT0boiqPIwGHi?=
 =?us-ascii?Q?C9G/eON0OGjMQ962yyWJiCGR+/shn+bBsQ5KuaeoWVK9PUysZm0MiYvxxn5r?=
 =?us-ascii?Q?z5Xn7GkNNqO2cxCUKF8YnAmUGlKmmqd2ZeTPHx++RqlPllm1lkJPM5O2LfPO?=
 =?us-ascii?Q?4cHKehxzjD9KiNUZBPe+05Io3dvmqVEu1926ygrWabvVIL6cmzSkA1Hf92m1?=
 =?us-ascii?Q?DgefCWhHHtNQmA5V+CdbclEcIVMJMuemvDhX80ksCcjM9T+Uey+cVjoK0uD8?=
 =?us-ascii?Q?DdXawsFywR5xQl549nKoUJOBsfTGWhVaXsLxpcLU3QOX0v/fqycVeno98BHe?=
 =?us-ascii?Q?X1H3j3oq52LZp9GoBa+qZ3GrLTvw7NsD7QLMX+yHzNTRtH6M46vJQeTN9mTF?=
 =?us-ascii?Q?Q7gshNNv0FFuU+ZMUaOKHGCIbFqYnrVA3mjSbzssfEGE3dGm/SovQoKzQX0h?=
 =?us-ascii?Q?LEVBe+Lj/QjzjLsuZyMWABkCCCblOJ44IXYTl+3DPXBxDfMwI/jz8ZqUKkAk?=
 =?us-ascii?Q?vdwxgcQoATdTtiEqyr+8LCyct1B0yTW1Fc2X3j378e4CjlN2o35651Ms95dU?=
 =?us-ascii?Q?QqARb+W971DFqxOjdyeq+lbjUdJFss7TUtJx2QmJ04izrCJuzwY3W7HF21Zd?=
 =?us-ascii?Q?uvFD1qOrpaG3s5KSPlnp4Uk0sFpCWcm388M9b/CRZMycu9sLWR1xHR1GqhSW?=
 =?us-ascii?Q?yLeKG+7UYKMG3ZSUV7ajT+IEEAmWMvAZh00iEj/Cu19ezLguSDE0bNnDBlvd?=
 =?us-ascii?Q?UwJctSco7x77AFhIrQK/StgchontRkIgsUBd4cJGNT7HUSWNTWpAdo/hsnlk?=
 =?us-ascii?Q?wtXZQxW4FZkXqIObapFnq3JV975AL1MLGY3fUrWZpyPsUFGuo4It3/dK0W3p?=
 =?us-ascii?Q?ZHRUQ9VSa1r6+KV6bo8mS3p7/VuXjZsGY+mrpgEmNxx2D2fk5eTvB0BQz4p9?=
 =?us-ascii?Q?m6B3Ec+jkwm6qG31DW8H4rXkzPM1tUTmtaVwM5Xar4gRdbx6oyr9JQ+giC6w?=
 =?us-ascii?Q?NRoO1dpqwaYZZ6YHgGx8btHUrFdOBYTTReiArXWoPfRTC/N0K+9m9mmkx1rU?=
 =?us-ascii?Q?hsxVflIgNM08VV0wVrwyZ8OZMpxjH72UGoxTjGMeRnz7C8AZtlAr2Nivhjyq?=
 =?us-ascii?Q?fZiyZuPwioJjMpiyMux63YQRDWSdLl2Ezzy6828QUA4Ixyzi5Az/TOAkpufu?=
 =?us-ascii?Q?I1nxHpL7yMyg0ox1sXo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1H0H9fBS3Yt4xBN89J6v5XOVIVaRphfd2giRV1fNvml14+Ly+4kxlvMt6fDE?=
 =?us-ascii?Q?dmp5ShoXVNMi+GNSNpwP5Bh2Y2TpP3QW1Yc2QeM1vjAg2gkYJSCedJbUxU7m?=
 =?us-ascii?Q?VIvKaMkncyzz6Y6UTSo8Rz/LgiGYlYselz1mzRhGOf5DHNI13ZXmTkcBtpJP?=
 =?us-ascii?Q?rDFiG+WKwrJvDyeiupOk9Cw0Dvt78rCaVoAis5Ur2/PqXFxyz9ynVEi44XfT?=
 =?us-ascii?Q?VjltbHHN55CEgnvHhxjTnyJcvOQCbdAIx7gipxv4PrSMez3TORwWiAmdLskL?=
 =?us-ascii?Q?cO+kWt5CQ8+GeamUdJYfUfV/3AGixIm4XwCqhmLlftgfcXsxu0AnYBEQ8ny5?=
 =?us-ascii?Q?vfpgoU97an7Yk5uqt2v+Q1YtOWG8Ucvp8vd63fhsdYmJjQ6/VUreq9TXgNIl?=
 =?us-ascii?Q?qSXObiCR6Esks2/u2CE5FIhO5uioYLAx8QdxxfvbvwDy1mcuXfzZ71ninWwa?=
 =?us-ascii?Q?6Dm7RDT4n+ypQLNIS2mNgEg9qd/F21PSdZCHR1HFCHr2ba5hUULONfMUXLX4?=
 =?us-ascii?Q?QpoP33MGX4ShAK3YSPDhSE0BFQVc4PyWJ8xPawMqbn2e7XIDT7w5Xz3Yeiiy?=
 =?us-ascii?Q?+fr4O6h5OsNRYe42okW9IdXqsWXQ9rbWosFP+PBZH9sqQDxIt36gnyU4LWKC?=
 =?us-ascii?Q?qdxKo2Fw64TolTkBEPTuQtggHa6J0gaM4w7EAuMGmf3V+x8s42/qxQo9/SOd?=
 =?us-ascii?Q?GoIVXq0VzAMMNeqxdDNXG0Uye2OOduAa+oNTf+IY5oAoBEp4PMgQ92qBPW6h?=
 =?us-ascii?Q?ZrA0Ab2nhG5vED9Qj39U4Bz8c7KU/4jms9ccn3lzToqC1Y+E4YPA9cuE0zQ+?=
 =?us-ascii?Q?XqD+K6Ee7TFe91tDOU4WC3+BKD0hfj9GjcgwdE59A139Yj9LqiYyLj/bxNB6?=
 =?us-ascii?Q?aU3wCQOAiJUMdLKrx8ggby6j7GC313vo6oazuQ1Y403+KRgNSHo1hveB/41e?=
 =?us-ascii?Q?nWGEYJalTwfaUAIgEFOrNOlPsGedLv8qfBS7Od3A9b7v0j6XLMxMCIQLzFeM?=
 =?us-ascii?Q?+aHe0IOCuCKB8n5O8P6JTvSy/TWq6SY3LD8oRvejd9XGPhxK92jN3to4hS4Y?=
 =?us-ascii?Q?NYhRs7HgGxJ4WU4OGpER4Jz9THNj5WieoRuK1YZidIp2XqRzWXJR1w2cjv77?=
 =?us-ascii?Q?71GhH5GnEPKFP12QqSb9yzq70N3wUdOwyrf1rrJZHJ92uuOV5NdeUbHvSGbf?=
 =?us-ascii?Q?4ZsmsJSRpf7g3Tg+3t/oXbSwwVMTZprvhqYancWO52zmhxLr3oK9JH2SCKiB?=
 =?us-ascii?Q?H3v6kFibopzVDOj+0BzpQrImSf/GvuVkMsvR2VQNtvxJ/+7byYg5ARr4ugSY?=
 =?us-ascii?Q?CFBd5hDoBzna7dhPkpSPiO7UhmvKTJIrqpL5h/Ti/SkdcCu4tr0StOWmkfGi?=
 =?us-ascii?Q?l3mcJveXnTWwBbz4mN7DwqZ+I1Pz6Pa9CWijiy7ZENyLJlaCi4kepSWA49wP?=
 =?us-ascii?Q?YNTLHNbjnwr8tIAOaUVvi7cgQ/XNifB+dHCeQRNoHiE4cKxrgkI6CD1BfBKi?=
 =?us-ascii?Q?3HxzVAq49mwIg4Cs+peU8fDWPXrcnrYgSzOWPq36Xnc0SbvRDrskYczAjfB0?=
 =?us-ascii?Q?4gyhbZp3rZt7JSw0eOn/Ahg1LLz/Ci5COIhfDOz/RoFDCF7AR8HkLaedYFWx?=
 =?us-ascii?Q?scm8WJjXauPQR11lNn2zwLM+tUIkhU97RdM7BueUtBYQGreWvqB6JuJIZNtS?=
 =?us-ascii?Q?HKBEdfb+Eo0d+JPMw0bHeIRB3sILfh9aynabNE9vS0DcbBm0j20ZFP9RTc4k?=
 =?us-ascii?Q?Jq9QOILaFA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63646bfd-83f4-4fb4-d8fc-08de5e71c0ab
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 13:32:59.1567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iz1clCHEPMWIGrHwJSd9hrsj8gaM4oItsyrrABe6ds0kEQXq9VWK4nx0TNoindh+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9607

On Wed, Jan 28, 2026 at 12:42:08PM +1100, Alexey Kardashevskiy wrote:
> > > Nah, it is quite easy to force 2MB on swiotlb (just do it once and
> > > forget) but currently any guest page can be converted to shared and
> > > DMA-mapped and this skips swiotlb.
> > 
> > Upstream Linux doesn't support that, only SWIOTLB or special DMA
> > coherent memory can be DMA mapped in CC systems. You can't take a
> > random page, make it shared and then DMA map it.
> 
> Well, my test device driver calls dma_alloc_coherent() which does that - alloc + convert 4K.

Yes, and there is no reason that can't come from the same allocator as
SWIOTLB and use 2M aligned blocks.

> > What happens if you don't have a VIOMMU, have a single translation
> > stage and only use the S1 (AMDv2) page table in the hypervisor? Then
> > does the HW fix it? Or does it only fix it with two stages enabled?
> 
> The HW translates a DMA handle to a host pfn, and then RMP checks if
> that [pfn..pfn+size] is assigned to the correct ASID and the page
> size matches and the gfn matches.
> 
> RMP does not check S1 translations inside the guest, only S2. RMP is
> not fixing page sizes or anything, it says yes/no to the access.

Your explanation doesn't make alot of sense.

If we have a vIOMMU and the guest has a 4K IOPTE in S1 then it goes

 S1[4k] -> S2[2M] -- [4k] --> RMP[2M] ==> OK 4k IOTLB entry

While if we have no vIOMMU, the same effective scenario:

 S2[4k] ------- [4k] -------> RMP[2M] ==> FAIL

It makes no sense at all. Why build something like that?

It is not a "firewall" it is a huge software obstacle.

Maybe your answer is the entity that is building the RMP also has to
build a matching S2 IOTLB as one unit and we somehow just plumb the
page table pointer and invalidations into the IOMMU driver.

Such a messy design.

> > > > iommufd won't deal with memory maps for IO, the secure world will
> > > > handle that through KVM.
> > > 
> > > Is QEMU going to skip on IOMMU mapping entirely? So when the device
> > > is transitioned from untrusted (when everything mapped via VFIO or
> > > IOMMU) to trusted - QEMU will unmap everything and then the guest
> > > will map everything but this time via KVM and bypassing QEMU
> > > entirely? Thanks,
> > 
> > On ARM there are different S2s for the IOMMU, one for T=1 and one for
> > T=0 traffic. The T=1 is fully controlled by the secure world is equal
> > to the CPU S2. The T=0 one is fully controlled by qemu and acts like a
> > normal system. The T=0 can only access guest shared memory.
> 
> Does the T=0 table still have all the guest memory mapped (with the
> expectation that what is not allowed - won't be accessed using that
> table)? Thanks,

I'm not sure what the plan is, I think ARM can do both ways - map all
guest physical and rely on the GPT to prevent access or dynamically
map only shared pages.

Jason
