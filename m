Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0F02592;
	Wed, 22 Mar 2023 12:33:59 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4PhSR374XHz4xFc;
	Wed, 22 Mar 2023 23:27:27 +1100 (AEDT)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: mpe@ellerman.id.au, Nathan Chancellor <nathan@kernel.org>
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, erhard_f@mailbox.org, ndesaulniers@google.com, trix@redhat.com, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
In-Reply-To: <20230118-ppc64-elfv2-llvm-v1-0-b9e2ec9da11d@kernel.org>
References: <20230118-ppc64-elfv2-llvm-v1-0-b9e2ec9da11d@kernel.org>
Subject: Re: [PATCH 0/3] Allow CONFIG_PPC64_BIG_ENDIAN_ELF_ABI_V2 with ld.lld 15+
Message-Id: <167948793442.559204.2964050663889516909.b4-ty@ellerman.id.au>
Date: Wed, 22 Mar 2023 23:25:34 +1100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Wed, 15 Feb 2023 11:41:14 -0700, Nathan Chancellor wrote:
> Currently, CONFIG_PPC64_BIG_ENDIAN_ELF_ABI_V2 is not selectable with
> ld.lld because of an explicit dependency on GNU ld, due to lack of
> testing with LLVM.
> 
> Erhard was kind enough to test this option on his hardware with LLVM 15,
> which ran without any issues. This should not be too surprising, as
> ld.lld does not have support for the ELFv1 ABI, only ELFv2, so it should
> have decent support. With this series, big endian kernels can be built
> with LLVM=1.
> 
> [...]

Applied to powerpc/next.

[1/3] powerpc/boot: Only use '-mabi=elfv2' with CONFIG_PPC64_BOOT_WRAPPER
      https://git.kernel.org/powerpc/c/d1c5accacb234c3a9f1609a73b4b2eaa4ef07d1a
[2/3] powerpc: Fix use of '-mabi=elfv2' with clang
      https://git.kernel.org/powerpc/c/7c3bd8362b06cff0a4044a4975adb7d71db2dfba
[3/3] powerpc: Allow CONFIG_PPC64_BIG_ENDIAN_ELF_ABI_V2 with ld.lld 15+
      https://git.kernel.org/powerpc/c/a11334d8327b3fd7987cbfb38e956a44c722d88f

cheers
