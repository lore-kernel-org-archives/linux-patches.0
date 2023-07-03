Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D03D7E3;
	Mon,  3 Jul 2023 05:30:30 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4QvZ8J4CWDz4wxp;
	Mon,  3 Jul 2023 15:23:28 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: Nathan Chancellor <nathan@kernel.org>
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, ndesaulniers@google.com, trix@redhat.com, linuxppc-dev@lists.ozlabs.org, llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
In-Reply-To: <20230427-remove-power10-args-from-boot-aflags-clang-v1-1-9107f7c943bc@kernel.org>
References: <20230427-remove-power10-args-from-boot-aflags-clang-v1-1-9107f7c943bc@kernel.org>
Subject: Re: [PATCH] powerpc/boot: Disable power10 features after BOOTAFLAGS assignment
Message-Id: <168836167604.46386.2142822866200803568.b4-ty@ellerman.id.au>
Date: Mon, 03 Jul 2023 15:21:16 +1000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Thu, 27 Apr 2023 12:34:53 -0700, Nathan Chancellor wrote:
> When building the boot wrapper assembly files with clang after
> commit 648a1783fe25 ("powerpc/boot: Fix boot wrapper code generation
> with CONFIG_POWER10_CPU"), the following warnings appear for each file
> built:
> 
>   '-prefixed' is not a recognized feature for this target (ignoring feature)
>   '-pcrel' is not a recognized feature for this target (ignoring feature)
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/boot: Disable power10 features after BOOTAFLAGS assignment
      https://git.kernel.org/powerpc/c/2b694fc96fe33a7c042e3a142d27d945c8c668b0

cheers
