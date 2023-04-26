Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454A31FA7
	for <patches@lists.linux.dev>; Wed, 26 Apr 2023 12:16:05 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Q5yMT2GHGz4xMy;
	Wed, 26 Apr 2023 22:08:53 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: mpe@ellerman.id.au, Nathan Chancellor <nathan@kernel.org>
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, masahiroy@kernel.org, linuxppc-dev@lists.ozlabs.org, patches@lists.linux.dev, kernel test robot <lkp@intel.com>
In-Reply-To: <20230406-wundef-thread_shift_booke-v1-1-8deffa4d84f9@kernel.org>
References: <20230406-wundef-thread_shift_booke-v1-1-8deffa4d84f9@kernel.org>
Subject: Re: [PATCH] powerpc/32: Include thread_info.h in head_booke.h
Message-Id: <168251050520.3973805.11314426233471106968.b4-ty@ellerman.id.au>
Date: Wed, 26 Apr 2023 22:01:45 +1000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Thu, 06 Apr 2023 10:51:30 -0700, Nathan Chancellor wrote:
> When building with W=1 after commit 80b6093b55e3 ("kbuild: add -Wundef
> to KBUILD_CPPFLAGS for W=1 builds"), the following warning occurs.
> 
>   In file included from arch/powerpc/kvm/bookehv_interrupts.S:26:
>   arch/powerpc/kvm/../kernel/head_booke.h:20:6: warning: "THREAD_SHIFT" is not defined, evaluates to 0 [-Wundef]
>      20 | #if (THREAD_SHIFT < 15)
>         |      ^~~~~~~~~~~~
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/32: Include thread_info.h in head_booke.h
      https://git.kernel.org/powerpc/c/8002725b9e3369ce8616d32dc2e7a57870475142

cheers
