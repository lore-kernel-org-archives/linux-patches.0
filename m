Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B54AEA6;
	Mon, 20 Feb 2023 06:12:00 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4PKsWb2pVbz4x7y;
	Mon, 20 Feb 2023 17:11:55 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1676873516;
	bh=uh6SduduEoSyYM4T5OZVwNhrVpEdNWp+xXBIDkGvJZA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=OXCF758WATVQ4oFKfnxEw72j5ErfVgL65I9FF7CKHO8/qyLVdQminCVXNiEzRRSnr
	 HGVA6RfJoXf3FEzYKnl/JVx7Wj6cdlukm+lNrLqPSxdf2LKDIhyUFNq+jzCxPAiT4h
	 hqfDxmPIrVgeGGPwJgi9p4uoLzB9vUBdFZ3eB9joKXTW4ylzxdwqPaZxqIc3raLmp9
	 /01VDxo1f8szK1a1BqO94hp5HIi/kGZY8lFDqG4XPzLlTifziA9HnkZ83trvFRR3FL
	 HK83+RplWAEOafBALD+gy3Zd3W6mntU392oCwoEl447RiFpYHhyvMP/iWzTNXOEF2T
	 YW7i1SBOCaL+A==
From: Michael Ellerman <mpe@ellerman.id.au>
To: Nathan Chancellor <nathan@kernel.org>
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, erhard_f@mailbox.org,
 nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 0/3] Allow CONFIG_PPC64_BIG_ENDIAN_ELF_ABI_V2 with
 ld.lld 15+
In-Reply-To: <20230118-ppc64-elfv2-llvm-v1-0-b9e2ec9da11d@kernel.org>
References: <20230118-ppc64-elfv2-llvm-v1-0-b9e2ec9da11d@kernel.org>
Date: Mon, 20 Feb 2023 17:11:54 +1100
Message-ID: <87wn4cyifp.fsf@mpe.ellerman.id.au>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Nathan Chancellor <nathan@kernel.org> writes:
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
> This has seen our basic set of powerpc configurations with clang-15,
> clang-16, and clang-17 but I will never be opposed to more testing :)
>
> The first two patches fix a couple of issues I noticed while build
> testing and the final patch actually allows the option to be selected.

Thanks for this.

I thought about applying this last week but decided not to. I'll plan to
pick it up for 6.4.

cheers
