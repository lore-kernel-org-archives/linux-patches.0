Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E71803;
	Mon, 17 Oct 2022 00:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90075C433D6;
	Mon, 17 Oct 2022 00:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1665967265;
	bh=FUOUlzt5BRDqsXFWN6sPJsKiLvmj3iudLIpob+Peo9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qHaTopcfle+C0cDQbHIVhD1HZXN96LdC2zMl/WExOPuLpGQhgAaUz1xxNaVoimx+L
	 sDiqv+gNM/fNkBu6CYltMt640zCVmeXR0mil75LQOdwIlGPOlIrTyZLa3LQzJ37im1
	 JVlTyDLENjVmpAc49NdqZBGMUVYV319B9hwgsn+KEuPuESJgBUkk0mbGXrOeIHlOhu
	 dAIrG+vsiN9VTSjEl+EUZ0By53/0+D26AzpvL/1m7XpHJ+zGmWdE0PCnZ7QEwq+X3i
	 EHw2etxSN5Ebg6dDngLrccbHn8pKXdcI6/SqUOXErclb6bTqk4lOtCTSsMaOwGtdc5
	 P6DJ+YasqLPkg==
Date: Sun, 16 Oct 2022 17:41:02 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>,
	Conor Dooley <conor@kernel.org>, linux-kbuild@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, llvm@lists.linux.dev
Subject: Re: [PATCH v2] lib/Kconfig.debug: Add check for non-constant
 .{s,u}leb128 support to DWARF5
Message-ID: <Y0yknpUJn5K2uhw1@dev-arch.thelio-3990X>
References: <20221014204210.383380-1-nathan@kernel.org>
 <20221016172815.f5a5f1f86af7ff1937a2e273@linux-foundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221016172815.f5a5f1f86af7ff1937a2e273@linux-foundation.org>

Hi Andrew,

On Sun, Oct 16, 2022 at 05:28:15PM -0700, Andrew Morton wrote:
> On Fri, 14 Oct 2022 13:42:11 -0700 Nathan Chancellor <nathan@kernel.org> wrote:
> 
> > When building with a RISC-V kernel with DWARF5 debug info using clang
> > and the GNU assembler, several instances of the following error appear:
> > 
> >   /tmp/vgettimeofday-48aa35.s:2963: Error: non-constant .uleb128 is not supported
> 
> hm, which kernels want this?
> 
> I could merge it for 6.1, which seems suitable.  If we want it
> backported into earlier kernels then a Fixes: would be nice, to prevent
> it from being ported back further than necessary.

Masahiro took this for 6.1 via the kbuild tree, it is now in mainline as
commit 0a6de78cff60 ("lib/Kconfig.debug: Add check for non-constant
.{s,u}leb128 support to DWARF5"). It does need to go to stable but it
needs a few prerequisite changes to cover all cases and I did not want
to try and describe those dependencies in the patch itself. I should be
able to handle the backports manually tomorrow.

Cheers,
Nathan
