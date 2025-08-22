Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D56322DA1F;
	Fri, 22 Aug 2025 07:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755846364; cv=none; b=plylZLp/IGVh7d3SNHNLCjkMBeqn4KU3BVsXC8RxZ+db7+ZVUginhXJOFoprw+3MTMpq1AU3ZrdcLuorDpXRMRPsepH6RHctA1zFz6sWDHS2lwa4S7dKVKqFjjd5tzBiFpPHlLR/JOPAeL+LdCawmEwvDdewZfMSD+JLuatHU84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755846364; c=relaxed/simple;
	bh=1zauvedElwCQUXBUOPPqOSpWlZSJJOKXlW2tRIrt99Y=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=eLGiXnUlQVqfpymxdj+VZbXfGfrKXlgmy9tfB6Ft/vZyv0msjaEoyNGTdHLPtum9M2T4mCElxAIUPfDJD1mZ96lNGXjMD3XFW3Ia5kD3XjCdLv4AJXpiLjPmh94lAdH2nRD0FjK9mZPtcoLJUI2yJwkeGmWyQ5gfvVFmgk7beq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=WFiZvrYr; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=TQa2Lw8I; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="WFiZvrYr";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="TQa2Lw8I"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 8A902EC0958;
	Fri, 22 Aug 2025 03:06:00 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Fri, 22 Aug 2025 03:06:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1755846360;
	 x=1755932760; bh=oMJSNEUSKKDn7Dffolj3gAHZX6/fUfm0lTvkTxBDCHk=; b=
	WFiZvrYrZDGDgFIeP2gDUyu1lZ0OTNIxL8He8RvJV1mCiJo6JsRO20F6M+5rSPsd
	OcL55vkPHIuRBOUQG4UYlKizEuIMWt2FbRqPrXcNyPT6zy9vOoySHKIowQOjD4gz
	xMHI0qkt85bpIrZ9FLikJbwtrCxb0ZjWepQb2+yrC4K1vbpHo2nD1sETbiRtaSN+
	2Dx5v01Zc5yYPMJIB85Pqy/MEQNaItgCPDF2Kw34Vmo8C6F6EGwsWmtfbdWHvD8M
	SFeMH/uwoRXC/JjOGfcQowVWR+N/q+6aUROulrW+n1Qk0U9/RR9FC8ZrVchUJiB4
	h9dL7832YWYw9v1LPTEXiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1755846360; x=
	1755932760; bh=oMJSNEUSKKDn7Dffolj3gAHZX6/fUfm0lTvkTxBDCHk=; b=T
	Qa2Lw8IsH7CgksQbCfiAXgGJ6Q6WDsnBSrBgBJYLQ2AQHlyPP9M+IgR/NU5sHCu9
	YtcugPu5usZTlGrlgCfndU3Ql6KhqUgD6whCr0WTZ4BBQQv42coIavErY4qGgEsG
	/f67tn3p5AuN+JNPwrJjr0ecyEjrIf+H9RLSwJ716DBTTWzvghuKGbhEl0aptY9W
	nT//CQfw0vxd/I+wGVqOvYqGAkCeE06Q6hRrMEm9gl46pB1KaLernRuHQPZHcjLc
	rVwhAgBF/vjjYSYMCW4SOU+mjGwU2aagKuPhnVwX28P4UtRUo0AkPsrKt03ivyaB
	XiGNvEQQOMcT3bzK+Y2XQ==
X-ME-Sender: <xms:2BaoaOLaWKSmrt1w6Rz5mEIUTSxDRXFsnfmLjr6i_Fb3FjJfW78b6g>
    <xme:2BaoaGJaytqaykyXZ6D4GOTJfBtxh6-botUl-TMU-QvSND3v8xxXIzpLnrbh7Yjqx
    98N_B1JKkHPHGizqIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduieefudduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepuddupdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopehlihhnuhigsegrrhhmlhhinhhugidrohhrghdruhhkpdhrtghpth
    htohepnhhitghkrdguvghsrghulhhnihgvrhhsodhlkhhmlhesghhmrghilhdrtghomhdp
    rhgtphhtthhopehjuhhsthhinhhsthhithhtsehgohhoghhlvgdrtghomhdprhgtphhtth
    hopehmohhrsghosehgohhoghhlvgdrtghomhdprhgtphhtthhopegrrhgusgeskhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepkhgvvghssehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehnrghthhgrnheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrghr
    mhdqkhgvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoh
    eplhhlvhhmsehlihhsthhsrdhlihhnuhigrdguvghv
X-ME-Proxy: <xmx:2BaoaHX-rBzOi4fEzVlO_r-b6O12-Gd2BQqvF1-u7ZKpmJW09pV8dQ>
    <xmx:2BaoaKCDunUP6cGWqSpPLXrcfnSk3O0vFgdrz12DZPYi43gJO068kg>
    <xmx:2BaoaK5JlhyQr4SR8w-x-xYIUQddJ3ChifOGxZJbBcQ7IGhZ58B-0g>
    <xmx:2BaoaJ3Uh3_j5Rrj0JYci63M16Tb-5bboRUvoOh-cNjk9AA9Q7BWKQ>
    <xmx:2BaoaESHR9avTufRWoOnB7jyYuS4O_fJriKScgy4arR5vT0HhzH2TWW6>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 0E72B700065; Fri, 22 Aug 2025 03:06:00 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: AlhDZOV2HdTF
Date: Fri, 22 Aug 2025 09:05:38 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Nathan Chancellor" <nathan@kernel.org>, linux-kernel@vger.kernel.org
Cc: "Kees Cook" <kees@kernel.org>,
 "Nick Desaulniers" <nick.desaulniers+lkml@gmail.com>,
 "Bill Wendling" <morbo@google.com>, "Justin Stitt" <justinstitt@google.com>,
 llvm@lists.linux.dev, patches@lists.linux.dev,
 "Russell King" <linux@armlinux.org.uk>, "Ard Biesheuvel" <ardb@kernel.org>,
 linux-arm-kernel@lists.infradead.org
Message-Id: <35178205-7cff-4b4b-abdd-b4cfb9e69dc2@app.fastmail.com>
In-Reply-To: <20250821-bump-min-llvm-ver-15-v2-3-635f3294e5f0@kernel.org>
References: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
 <20250821-bump-min-llvm-ver-15-v2-3-635f3294e5f0@kernel.org>
Subject: Re: [PATCH v2 03/12] ARM: Clean up definition of ARM_HAS_GROUP_RELOCS
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Aug 21, 2025, at 23:15, Nathan Chancellor wrote:
> Now that the minimum supported version of LLVM for building the kernel
> has been bumped to 15.0.0, the first depends line of
> ARM_HAS_GROUP_RELOCS is always true, so it can be safely removed.
> Combine the !COMPILE_TEST dependency into the 'def_bool' line and update
> the comment as well.
>
> Reviewed-by: Kees Cook <kees@kernel.org>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

>.
> 
>  config ARM_HAS_GROUP_RELOCS
> -	def_bool y
> -	depends on !LD_IS_LLD || LLD_VERSION >= 140000
> -	depends on !COMPILE_TEST
> +	def_bool !COMPILE_TEST
>  	help
>  	  Whether or not to use R_ARM_ALU_PC_Gn or R_ARM_LDR_PC_Gn group
> -	  relocations, which have been around for a long time, but were not
> -	  supported in LLD until version 14. The combined range is -/+ 256 MiB,
> -	  which is usually sufficient, but not for allyesconfig, so we disable
> -	  this feature when doing compile testing.

The change is obviously correct by itself, but can we revisit the
question of whether the COMPILE_TEST check is still needed?

Trying it out, I single link issue using llvm-21:

ld.lld-21: error: vmlinux.a(arch/arm/kernel/entry-armv.o):(function __bad_stack: .text+0x110): relocation R_ARM_LDR_PC_G2 out of range: 10168 is not in [0, 4095]; references 'overflow_stack_ptr'
>>> defined in vmlinux.a(arch/arm/kernel/traps.o)

which is from this line

arch/arm/kernel/entry-armv.S:   ldr_this_cpu_armv6 ip, overflow_stack_ptr

with the macro expanding to

        .macro          ldr_this_cpu_armv6, rd:req, sym:req
        this_cpu_offset \rd
        .globl          \sym 
        .reloc          .L0_\@, R_ARM_ALU_PC_G0_NC, \sym
        .reloc          .L1_\@, R_ARM_ALU_PC_G1_NC, \sym
        .reloc          .L2_\@, R_ARM_LDR_PC_G2, \sym
        add             \rd, \rd, pc
.L0_\@: sub             \rd, \rd, #4
.L1_\@: sub             \rd, \rd, #0
.L2_\@: ldr             \rd, [\rd, #4]
        .endm

Would it be possible to either change the macro or to move
the overflow_stack_ptr closer in order to completely eliminate
the CONFIG_ARM_HAS_GROUP_RELOCS symbol and have VMAP_STACK
enabled for all CONFIG_MMU builds?

Are there any other build testing issues with ARM_HAS_GROUP_RELOCS
besides the one I saw here?

      Arnd
