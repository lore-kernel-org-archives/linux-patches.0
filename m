Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011001.outbound.protection.outlook.com [40.93.194.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A413644CB
	for <patches@lists.linux.dev>; Tue, 28 Apr 2026 19:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777403090; cv=fail; b=OYfYnEfwo78irvxojbtOmLg1mahogftFEAXf/Qp2kFIZIHpBwxVcdFhG4oAyrHHA0EeTpUzKv6fav9EkDQTLRYqjgZSYcrejk8kz3WO+upMY7hljFnuApTZIKe8U1HrD8PuddFjUmxCwlXOgSSLCSBiEx0HRTp7USCLnGeIb87o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777403090; c=relaxed/simple;
	bh=zIf0x2hRze70nR4gw0e6K4Ny+08TVxyNo2S29kivlOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cFVCLquh/CqLV5qqL1zVlYVyg2xoXUn/ZZXpnPKEjrBf2AKnMpuUfuttsBCMJAO6rRZohbigqWhM67e53VJ+514kyJSe3r45zTYAq5ydjWjeZ/Ddum+OccpcUlJoCdIGUcC2x47MSsHvXHw4X3DGOCLq1lqKDXklwYUpXlkDat4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UD4V8Kly; arc=fail smtp.client-ip=40.93.194.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UD4V8Kly"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D2lSkQZzxxPXmHjhG1oWMc9i5wCFvCYKZJV3njgSVpjMKrfgwAaMQTRXCpGI5m6P1NwBbaHxnpu5yDGHPx/2y4go9AEFC/9nqK+AgOEfRv5mFg71Q8127XuVL3NQUamiQWU7/03zuM9QjgQCBLCWixfBH3lhWy0cw3BhqHxyNQgINu620rdNs9ke93sCKs79HKvpG2ffTFo0IlVJqB95nTr7ZvZttDv7G1NCvkZ1WBYQQ5Dv2eIL3VVmCuD/FHLxlUoPXtCdwfHmJgq50A7QZSMmpbmhUet4lyn5m+EyyND472f2cETfFX5CHA22sI+UkuxZl0ay5nVAzQARQrnpgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/NXozzkOG/c7V/R1DJi0SOcwl6gy7uSDzemh553nd20=;
 b=y4X5mr2/9DF+Mf+guaep5G9W/VllqzEN8zY6FnBXWnh5DPPdF/48hwcLb2X6gS1WLL0SHIAh6JcPIkfDHDtG4hqERJmbWv5vd7/nSkAtv3O3jZUqgEONKil1pIdQhmUuArg9mGS8JO/78nYYd0xZNCbHZVXRpbrXIpTOzdnRnCaFs7OWjXlPX1ruF8n45f7uDuuQqe96v87zRk0AjvpoGwyuncdExU+REUf+4EQHeh6fcyFo4i2S5wvPRIzb0f+p0ns7wN80HF6W5ngq8w/Beg4bOHhB17VrkscHP4uPyOvsn4drM1O+PzU8LDJoafZ7NoV2f8Mu0IOgMuI4Sf5HPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NXozzkOG/c7V/R1DJi0SOcwl6gy7uSDzemh553nd20=;
 b=UD4V8Klyd15Uy2izdC1rLHZRJyc1wsKJfU2P14IK6eOr3rWyqqOVrF9aJwerhJ4pGnDRGPv8qv1VO2MGcI8pTVym7lXGFNZi1XVN//j3hQS3FWowXEPFIV2ABMgqdkjLCGMIabx0lNrviM06QbLvUA29CBsnggqwjBCXxmz5UURAm5RSMR0EzOBPnjWSj/1U/8n5Ku39TcqKav4QJiqy7VrTzaU0HAHZdm8iD/bninqX4r0dSzkRfO9tn9F8EueT+pXvTkfb88W949kosHthydihu73iWAC8jVXGcWGzv+Rrikqmh0drMUuie2cjXTUZuPlStTN/eqqcugwtQDRCSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH3PR12MB7500.namprd12.prod.outlook.com (2603:10b6:610:148::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.17; Tue, 28 Apr
 2026 19:04:39 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9870.013; Tue, 28 Apr 2026
 19:04:38 +0000
Date: Tue, 28 Apr 2026 16:04:37 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	patches@lists.linux.dev, Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH] vfio: selftests: Fix out-of-tree build with make O=
Message-ID: <20260428190437.GE718365@nvidia.com>
References: <0-v1-79f29139180b+8e-vfio_st_make_o_jgg@nvidia.com>
 <afD7-rg58XvqRJpD@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afD7-rg58XvqRJpD@google.com>
X-ClientProxiedBy: BN1PR12CA0022.namprd12.prod.outlook.com
 (2603:10b6:408:e1::27) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH3PR12MB7500:EE_
X-MS-Office365-Filtering-Correlation-Id: bb5f268d-2396-4a9a-a602-08dea558ff04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	WUvO+NRAahHcn/rxbUB5yInLAT/fULQlJ25awbXpPq2UblUz9beMKWzzfVMk3SVIsfRmnGf0YRmqOlEUi2aqLW2lprn7z5bi/IYdmjUEGz/R2YjJGcq7MjZ0PYlBTu/YK3uhw56TGbZNYPX57kPj3j+jfgu1atGOi45XrcEMoU16J0tyUR4Y+fuwG00mpoZVRlcyrUAfw4nT+UvL80lC34IRHSiDKSNN/0t9HR7R/0CBDodr1pRYIGVI2Cj/5utgD5CXnsASjGvUoqEL3foHOwUszgs1PNUNhzx8FypqYsNLhvThFC5ovzPvypQHqhSr5e+OlE+EAPpDEm5B/BmYYlXikd87wbbRu1D9orVY38O/UHZ8gBj03g7TqiOQP0B/jhrddJe4uzup7GdBbNiQye9eNcVs3NA+l1o9uOvumNlsM1DBZCnTE/Ht/caFzyQJv08U8ax+uxLWBaJusbhA5Y14rJ/Iedoyk/Ea0PEqfYMpNWn+nrlg/z1aJyg2NITmV0BngHKhICX/Tv1ZsMgybDK4xFyOBKSqcy+YwwNFrXQytm1vnamauu3h9+qIBiUHIuCoQ0gIF8czRc2x2bQtlTpNyryOmE6W+a9I7/2Vp0cV1823M7mNCLJ2D5Rp/MvFHliOI41cu8YO84jwow46SMF3Dm8Z38CrJR3MDQvgh7kzSNPEqoXr5N5s0KhuQP0km+Enlokvh+i6mQUQ5B32x6qHqeGXINnOw7jxNwAA/4w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e2vlSgP8HDCLkE3F9Bw2Kuav2tcWDIkC3V1yoy7iiIb1nw5vC2zuP84lw+gH?=
 =?us-ascii?Q?Lx5hsTqZaGioqF22egDVuPjkTEsrcO2zmsT2rVC0RT8WvyjxLldhcLbhK3pM?=
 =?us-ascii?Q?jA0RK/r47ojWhze1io8FrXampZrwdDH4d14wnMahDhQSojn+OtZjpFBAN6Z5?=
 =?us-ascii?Q?BARst2plBq2804uHJVOUY876hIur4lLhMPxxcBoJ4mY0mBJVvOqhcZt6J0EU?=
 =?us-ascii?Q?YmptYZLwpnqIm6pPyHJ998d/8ZKdyAWIKjUgXEDcR1Q9l8sQREfpfkFcz/zf?=
 =?us-ascii?Q?idbHscQ45rNo7hjadBvIl4JjfCrj3QmbciBKS+N57j2KPYUpOsAFWrxSB2i+?=
 =?us-ascii?Q?/VgnCr1e5QunsC/75HZP3yde3c+27yyljFvwYzZ6BpeGx22dHMp7vZk4EZSW?=
 =?us-ascii?Q?lY9VdBnuw08ZqxyCSyWW109sHxok5WZ1ZjSmePiXk8+2ItWWtWaIPn8eyS6b?=
 =?us-ascii?Q?IpYkCg6hDaUvor9+Q70yR+S7l78Gh1tgOdm5qKTmCQDZvA2pbLbpew/mM6d5?=
 =?us-ascii?Q?kMCU2jPYwRZQ50s1BtCoPb4j13hmt39nLe8lt5vtBIj3ZP/vMW1xiMPa/4RB?=
 =?us-ascii?Q?mpzEZrfjN8aJ2I6z40BZFwPg794cPpiAN4LTiovVZ9hQnnZ+VnJjp0qEm7tK?=
 =?us-ascii?Q?4nmBEnKNCQqniUlGMNOtxinXivp+LUsXTc+XF2tOdKOVnTd0rPJRFZ1p5ZcC?=
 =?us-ascii?Q?escX1YUK4mUhJrLrhVRsVY2/DbhNu0sub524OgmHGKvhDPeRX6Ng+ZbZ7d4a?=
 =?us-ascii?Q?AvCdl1EcyJzfrS+u3wa6WNLADcclu0EwXkC480KQeqGzs0Xxezd0MFOdgrC/?=
 =?us-ascii?Q?2I+ugEgYx8sHnEWUZk1Nm0IQIR0vrn1yrQbFDmaSPmrHBHEQ28ntf1VrWBVz?=
 =?us-ascii?Q?iq4vU9KUcWGmrTxneCXIV/ROtY3nE++3Q3KUtR9z58kgkqXI7G1UcfHCS9eF?=
 =?us-ascii?Q?BPTf1xilDOVsKrSA1hCvikJrJWFX1tyIj+qXER5TytaV5Zhwq0ev9rmF3kNB?=
 =?us-ascii?Q?/t2uGCEct4/cEcPuFSAP7T+URslhi+yt7uo9rltjKGmCgP4PkfXePAzRTvS9?=
 =?us-ascii?Q?QJXyeirRlx2iyGLx5iBha/1VOvzA/0eo2DjCT/5W4e2BuyCzgZW2UjH6F29L?=
 =?us-ascii?Q?TmShfEr9oaNrHi55ol0WAahb71kfxu9wjqHJw6c4bCuUbwFMiH3bCFJcdEcP?=
 =?us-ascii?Q?oC9NHpuEqcP1uzNN0P8vz3e6Efp5PRSSd/EB4+DiCOK/s1TfDIdU2345xPNt?=
 =?us-ascii?Q?HFIWEGWEP6cF8os2BV+N1Rdd/I99sdDvGCCWu4vue6LQTlFN+ch9mCEXmPyT?=
 =?us-ascii?Q?UR2gSRcGMm7l+Y3a+blPlBvL0ffQWDkoNlXOEKS72iawTcIRm0nOkCIjJD3w?=
 =?us-ascii?Q?v96okKR8X5e4zpF29/RLv5SFuIxYQGPhi4yvdRdKB9PZ3yAVP8XKc+OlpPP8?=
 =?us-ascii?Q?CvSqNEBM2coVrFvJJtNM2pruvp3oCzeKjytHHutY4/AfGmOfyKvdC95DhApu?=
 =?us-ascii?Q?3zuSAg73pRwK7+Et1fc/1h5OW3Z1gnmnTEstLrlHmqJsSq18eLZ+64H7N+UW?=
 =?us-ascii?Q?b2V9+Wv6DefCJmNzZJJnEPZEFKMBLHspASJFT7nRDWXqJzpCZ5cCmn/UI+Ak?=
 =?us-ascii?Q?WvTWHwpc4fzMd6TH1ILIHL47kPsFlKPM4MTZKxfwJOZlcFk1gKPa8lbVuPqo?=
 =?us-ascii?Q?SO+pj1H+2C9zmlJq5XHKilii9Iaj+bVhx1p7VY++gAmlK1gV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5f268d-2396-4a9a-a602-08dea558ff04
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 19:04:38.8799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /DYSdAInv0wOI+a708+dHBUpNvVKfsfdjm2k4OwTz24cmWQiGpNUnl9txK4kGTeu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7500

On Tue, Apr 28, 2026 at 06:27:06PM +0000, David Matlack wrote:
> On 2026-04-27 08:07 PM, Jason Gunthorpe wrote:
> > The test programs are compiled via a static pattern rule that requires
> > intermediate .o files:
> > 
> >   $(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)
> > 
> > After lib.mk prefixes TEST_GEN_PROGS with $(OUTPUT), this creates
> > dependencies on .o files in the output directory (e.g.
> > $(OUTPUT)/vfio_dma_mapping_test.o). However, there is no rule to compile
> > these .o files from the source directory .c files when OUTPUT differs
> > from the source directory.
> > 
> > Add an explicit chain of pattern rules:
> >   $(OUTPUT)/% -> $(OUTPUT)/%.o -> %.c
> > 
> > Following the same pattern already used in libvfio.mk for the library
> > objects.
> > 
> > Fixes: 19faf6fd969c ("vfio: selftests: Add a helper library for VFIO selftests")
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  tools/testing/selftests/vfio/Makefile | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
> > index 40165d087a0bc4..81c3be8298fdc2 100644
> > --- a/tools/testing/selftests/vfio/Makefile
> > +++ b/tools/testing/selftests/vfio/Makefile
> > @@ -27,10 +27,13 @@ CFLAGS += $(EXTRA_CFLAGS)
> >  
> >  LDFLAGS += -pthread
> >  
> > -$(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)
> > +$(TEST_GEN_PROGS): $(OUTPUT)/%: %(OUTPUT)/%.o $(LIBVFIO_O)
> 
> Changing this line (with the fix you replied with) is not actually
> needed right? I tried the following without it and was able to build:
> 
>   $ make OUTPUT=/tmp -C tools/testing/selftests/vfio
> 
> $(TEST_GEN_PROGS) has already been prefixed with $(OUTPUT), so %
> in the original pattern already included $(OUTPUT).
> 
> Is this for readability?

Yes, it makes more sense to explicitly match the stems through the
flow than to have the implicit $(TEST_GEN_PROGS) == XXX/$(OUTPUT)

> >  	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBVFIO_O) $(LDLIBS) -o $@
> >  
> >  TEST_GEN_PROGS_O = $(patsubst %, %.o, $(TEST_GEN_PROGS))
> > +$(TEST_GEN_PROGS_O): $(OUTPUT)/%.o: %.c
> > +	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> 
> Looking at this commit made me confused how this was even working before
> and I learned that make has built-in rules to build .o files that
> assumes the .c is in the same directory. 

Yes

> I see now that we were reying
> on those built-in rules to build $(TEST_GEN_PROGS_O). It makes sense to
> have an explicit rule to handle the directory mismatch between .c and
> .o.

Hmm now that I think about it, I wonder if it used the right flags..

> This also got me thinking it might be a nice cleanup to use the
> predefined macros $(COMPILE.c) and $(LINK.c) in these rules instead of
> $(CC) $(CFLAGS) ... etc. No need to attach that to this fix though.

Yeah probably

Jason
