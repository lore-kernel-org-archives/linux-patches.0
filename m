Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F413546D0
	for <patches@lists.linux.dev>; Wed, 20 May 2026 21:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779311541; cv=none; b=SWsqwA+/50iWk9PYQ5ddpa1pekJnyKiHWrDjmbLDICxyuOutF7S3HokmT7bNm6/eBQVvNdX/MMctByZZCddz9gMpNJQ4/iw3SY5KnZpNSlPhXiFcCLBcEQUCCz6jzRSrgY7iEWl6mmAt7SfkvQGgjwgXnJen3iAncEJ6LaVhMfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779311541; c=relaxed/simple;
	bh=kEDNMiQgY6MI079QkoJSX6k0r05opPiu8etWh76s5k0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pYyzOu+2kGcspX9PV+x7wx0aSqF71dTvTWyOFypKa+5XUjjaaTAbo9hagFmeubxZysZWL913HYlMVPQ6m3LCcnY6NcWSk721C0sXbHxxKFHEzCRzoknavnkLWgRrcy7mtA9Cewdkzz36j0VbGXmhzK0DAIdVZ3guATehnyQn/dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=mpTYUm5E; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=da/ngVPt; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="mpTYUm5E";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="da/ngVPt"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id C008B1D0007F;
	Wed, 20 May 2026 17:12:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Wed, 20 May 2026 17:12:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1779311537;
	 x=1779397937; bh=+g+lL+U36Qr4BDxd87KODJtgq0o+prLW5jMcZVYy0UQ=; b=
	mpTYUm5Eeg/hyFwjmm3oKz5Irewvk7UbyTp38/OjgjgWpXt0Gfgzl9m8P5PM0gQa
	uZTGuVaN7Uf9u0tzh5GlpvChY056FsMXSwA0qcja+dx5sUUgqxDOs9iia4OAC8E4
	YGrc+C3d/ZisNqwHNQihjRMFJERyJRc3sInDaWCr9S6W5FsYKF5keDlD5yBRhC1x
	pb0hQ0CdD7cOYQa64J+qv44geiS1G2ogYSsPkNPrkp7qTV56braPLtwP6lsvp0fj
	C+g6JzPvWiESviU6Ozbaw/22mXulTU2eT+pZfPTBFcaI32VBDmLIFEfGGAIGKGEY
	zn9rreZ1mC2OgFuZSgqg6A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779311537; x=
	1779397937; bh=+g+lL+U36Qr4BDxd87KODJtgq0o+prLW5jMcZVYy0UQ=; b=d
	a/ngVPtIQeQf1vFdSoV71FGu0iw8aauD7UV+xlq6vyFUNHz//ol31NyB/kxQyet0
	5Xi3dJfpql/RsyCaAegDFqrPvGRI/qH5tGYNK52w4MuKV3ff/h3wbqsToWJ1LW2Q
	ezEEHUP513w2IWGNNQ7a7gjym8WF6JEcX1UruY8iNJpowpTHVNXH3tIO9wc5wC5+
	a7Pzbu1TF6trAz5mePZeEow1UjHoozQSPAPG4FDhbifPtEJJsyrKUeLfYQc4Fzyc
	8awnyHPAlutWo5aBUPx40MvZNU87TVuV2tXG4nE+IPuyEYbwyWNXLBy9WnXtLX4F
	IoLQs/SWAC5wQVf0Qs+hg==
X-ME-Sender: <xms:sSMOanwpb9A7P2hmYbCvtZavwOW2J__qaYPtDa0rdKO3ccAeKHyxmQ>
    <xme:sSMOavvHi3ZsP3-Qd6D9TjcwSw6SKNmq56ZBpPl7irQDLk-QV8xxTCyJ0jazgoNy_
    5npKNIWuL4Mvpv2ECX4Mwji7ZqE_6JAVRzNVD2wO5WPctD6XN6KTg>
X-ME-Received: <xmr:sSMOaiCkmt2tqT8KsxMYdPpL_u6pxexb9m8kJmxKPxqILVoTFRc6kVC1zNk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugeehieekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepledpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtohepjhhgghesnhhvihguihgrrdgtohhmpdhrtghpthhtoh
    epkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhk
    shgvlhhfthgvshhtsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhhuh
    grhheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghlvgigrdifihhllhhirghmshho
    nhesrhgvughhrghtrdgtohhmpdhrtghpthhtohepughmrghtlhgrtghksehgohhoghhlvg
    drtghomhdprhgtphhtthhopehprghttghhvghssehlihhsthhsrdhlihhnuhigrdguvghv
    pdhrtghpthhtohepshhkhhgrnheslhhinhhugihfohhunhgurghtihhonhdrohhrghdprh
    gtphhtthhopegrlhgvgiesshhhrgiisghothdrohhrgh
X-ME-Proxy: <xmx:sSMOapGImM9r2qpqsTBXibAhzBicX-7wFHLlwInM7NkDfmwmpLkkgg>
    <xmx:sSMOaqCk9oWlBAHne7UYyM0J7TfA-bf14DZ1EsZa91UE_RQIJb2nig>
    <xmx:sSMOannZ4FWpdHOTOzbf_1Is7BcfBBmFf5kZDAxC357xH1W4KnNivA>
    <xmx:sSMOaoMmyVnicoFPH9Ko7g0YDtX4uVQmYqFLQYTlSLojAbHbRT8u6w>
    <xmx:sSMOareKvCyOULaL5IYVgOcSJOOzodfJUuaQNT3xmLdJP1sEDzdkmwb9>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 20 May 2026 17:12:16 -0400 (EDT)
Date: Wed, 20 May 2026 15:11:59 -0600
From: Alex Williamson <alex@shazbot.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, Shuah Khan
 <shuah@kernel.org>, Alex Williamson <alex.williamson@redhat.com>, David
 Matlack <dmatlack@google.com>, patches@lists.linux.dev, Shuah Khan
 <skhan@linuxfoundation.org>, alex@shazbot.org
Subject: Re: [PATCH v2] vfio: selftests: Fix out-of-tree build with make O=
Message-ID: <20260520151159.5bbda153@shazbot.org>
In-Reply-To: <0-v2-4ccc247e6aff+1d93-vfio_st_make_o_jgg@nvidia.com>
References: <0-v2-4ccc247e6aff+1d93-vfio_st_make_o_jgg@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 14 May 2026 13:04:44 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The test programs are compiled via a static pattern rule that requires
> intermediate .o files:
> 
>   $(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)
> 
> After lib.mk prefixes TEST_GEN_PROGS with $(OUTPUT), this creates
> dependencies on .o files in the output directory (e.g.
> $(OUTPUT)/vfio_dma_mapping_test.o). However, there is no rule to compile
> these .o files from the source directory .c files when OUTPUT differs
> from the source directory.
> 
> Add an explicit chain of pattern rules:
>   $(OUTPUT)/% -> $(OUTPUT)/%.o -> %.c
> 
> Following the same pattern already used in libvfio.mk for the library
> objects.
> 
> Fixes: 19faf6fd969c ("vfio: selftests: Add a helper library for VFIO selftests")
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  tools/testing/selftests/vfio/Makefile | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> v2: Fix the typo
> 
> diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
> index 40165d087a0bc4..0a4cfd1a6c7ed6 100644
> --- a/tools/testing/selftests/vfio/Makefile
> +++ b/tools/testing/selftests/vfio/Makefile
> @@ -27,10 +27,13 @@ CFLAGS += $(EXTRA_CFLAGS)
>  
>  LDFLAGS += -pthread
>  
> -$(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)
> +$(TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(LIBVFIO_O)
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBVFIO_O) $(LDLIBS) -o $@
>  
>  TEST_GEN_PROGS_O = $(patsubst %, %.o, $(TEST_GEN_PROGS))
> +$(TEST_GEN_PROGS_O): $(OUTPUT)/%.o: %.c
> +	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> +
>  TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O) $(LIBVFIO_O))
>  -include $(TEST_DEP_FILES)
>  
> 
> base-commit: b5953f774781f0b489ae1f34d49eb08fefe176a6

Applied to vfio next branch for v7.2.  Thanks,

Alex
