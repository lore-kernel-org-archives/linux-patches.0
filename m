Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880907C;
	Tue, 24 May 2022 11:24:34 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4L6s7r1sC7z4yTC;
	Tue, 24 May 2022 21:15:52 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: Nathan Chancellor <nathan@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>
Cc: llvm@lists.linux.dev, Alexey Kardashevskiy <aik@ozlabs.ru>, patches@lists.linux.dev, Tom Rix <trix@redhat.com>, Paul Mackerras <paulus@samba.org>, Christophe Leroy <christophe.leroy@csgroup.eu>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Nick Desaulniers <ndesaulniers@google.com>, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20220511185001.3269404-1-nathan@kernel.org>
References: <20220511185001.3269404-1-nathan@kernel.org>
Subject: Re: [PATCH v2 0/2] Link the PowerPC vDSO with ld.lld
Message-Id: <165339051787.1718562.10503050450628067652.b4-ty@ellerman.id.au>
Date: Tue, 24 May 2022 21:08:37 +1000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 11 May 2022 11:49:59 -0700, Nathan Chancellor wrote:
> This series is an alternative to the one proposed by Nick before the
> PowerPC vDSO unification in commit fd1feade75fb ("powerpc/vdso: Merge
> vdso64 and vdso32 into a single directory"):
> 
> https://lore.kernel.org/20200901222523.1941988-1-ndesaulniers@google.com/
> 
> Normally, we try to make compiling and linking two separate stages so
> that they can be done by $(CC) and $(LD) respectively, which is more in
> line with what the user expects, versus using the compiler as a linker
> driver and relying on the implicit default linker value. However, as
> shown in the above thread, getting this right for the PowerPC vDSO is a
> little tricky due to the linker emulation values.
> 
> [...]

Applied to powerpc/next.

[1/2] powerpc/vdso: Remove unused ENTRY in linker scripts
      https://git.kernel.org/powerpc/c/e247172854a57d1a7213bb835ecb4a40ce9bb2b9
[2/2] powerpc/vdso: Link with ld.lld when requested
      https://git.kernel.org/powerpc/c/4406b12214f6592909b63dabdea86d69f1b5ba2e

cheers
