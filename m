Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210DD5D8EB;
	Thu,  4 Apr 2024 09:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712224145; cv=none; b=kmBpHgD4dnHl8FhWwY2QbrfweLxEpLapD0bPURFqjj7B4hUCXj4NjTP98yZ7XYJQqV6rxbR9BwAcdS08afFR2j/S44tOC2RgErmwrrqPmU0U957ItWmCYe7U3Z7J+rHc8/iKBzq0o6F82lnedth+ld48ou3vl2xNJROnUYi7/FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712224145; c=relaxed/simple;
	bh=HAbQmr0+Y1WuF+6JXCLbQAOoXs0X86upzafhj6bLEdI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=k+VhciLsq6wdXpsLPLvWOJKpAYDlPCEwmkpt5vfhQFu1ZgsEOns9UHyzxmMmkJjTpPj1IAeh0/MBD/GQbX5NmtSRHDzY5L0qePEwiIiVPoDI06XB2O4pM+S4O0tOoFKM2ME47McFTxnBezMGnMl6EJDkwXbStyShMV7OHhfVoO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=svenjoac@gmx.de header.b=PHlOJ/TL; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=svenjoac@gmx.de header.b="PHlOJ/TL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1712224131; x=1712828931; i=svenjoac@gmx.de;
	bh=ySnNjAtPzrv4c0/QT4EoJuqtDuDGaJPtjE9C6V0D9ts=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:In-Reply-To:References:
	 Date;
	b=PHlOJ/TLF9cfuLWe/iJzcfMSm8hhlwOypspkqsza4G9y39yLGZvWN47zdpRoED7x
	 dm5eHuHyFJi4G7FmSiPBrBZ7G8izxfK0xwuEpnHOuPc3Y7J/AIS3uAscm5/uIwKAh
	 19SUEN/mb72ZaPm8hIYdyb1mEfBsy7gbESdHu4JKqIgAJOfZs9xsLUfubyIWbHr2M
	 K3yaCsqlGnHmktPPPhBTXgZ6sW9ZZ1qYQ13MHThOyCCrJ0biX1KbOYQALUzHaNPdo
	 +f25KfC8CQVV/nIgQbCL+KhLs25JyxJUFfQjsnZcRjgFbL8/9r38lcEJSIw6v+ND1
	 ufG1+FL2eqBUV8kfJQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from localhost.localdomain ([79.223.40.247]) by mail.gmx.net
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MQe5k-1sCZcr06wo-00Nl9P; Thu, 04 Apr 2024 11:48:51 +0200
Received: by localhost.localdomain (Postfix, from userid 1000)
	id E955F80119; Thu, 04 Apr 2024 11:48:47 +0200 (CEST)
From: Sven Joachim <svenjoac@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,  patches@lists.linux.dev,  "Borislav Petkov
 (AMD)" <bp@alien8.de>,  Ingo Molnar <mingo@kernel.org>,
  stable@kernel.org,  Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6.8 387/399] x86/bugs: Fix the SRSO mitigation on Zen3/4
In-Reply-To: <20240401152600.724360931@linuxfoundation.org> (Greg
	Kroah-Hartman's message of "Mon, 1 Apr 2024 17:45:53 +0200")
References: <20240401152549.131030308@linuxfoundation.org>
	<20240401152600.724360931@linuxfoundation.org>
Date: Thu, 04 Apr 2024 11:48:47 +0200
Message-ID: <87v84xjw5c.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:OCZ8j/pSnQ2OG4/Z8ZEdSDCYFzY9VaIoJEwJJAiQCCZnJVQ2Yn/
 f4uAsTlDoKOtfQJ4BS/CWBtVMCABwjfFrCjXUwHRl7j5Vfv8iwMkInQh7siM1GycgjgE+KM
 /ap7YAx/nxyjgEGpLuMCaxDOI+vkiz5Q3T5DOAf8/JBg6XeSSItwSDLz7kgld/nDdZCwAjt
 oh/6YNYIqpNBdnlKpY7Jw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:gM1jP+xtK8Q=;y5rj8nuaOfqWcMjGufmpdl0jkNg
 ytDjrVLbYn5GXPEcbuQs4o7ybaH1fCXmc3r5FftkX/hMySDpBTKDTTJSGHwAYhNYQYOSe5gR8
 EZ9dp0DvaP8nYO2Bi8xzJYG1HLL2GwSBkCUOxYa/2YQYbRF+LqL8rTyx1L3107dmhr8Fh+bzJ
 lDYiGgXDMc2Xz85PnxolhyXPKkycDFBEU2CqSfK5/V1J5seiqnFSAh6Dulzsy/rXDkoml2Nn8
 o3k3UBk7QPLT73zcDYX3pKJm8HlPH4i0RlXzTOmWgL+Z/Ex/GCguGuRYA3owzxemKWFhawKGJ
 29VgH6tfzX1H+KtHGw0/E9qV938QlpEm6VAys/p/awb/IP/W1kVGA4Yp0DsE75Slcl/KNQe7M
 GFeXXyp639t833wJfI/z7RNBoKDKLWkOyOOyQy1mFgpSUTPT0Qf5Cepi3pHgTMrhFScWV/9Xd
 PoZ2BawAltokQIQzbxy9mpJYfM36Qo9Mep7shJ0N3psNj2hjnMy9i2iPuaEKoH9+i1+okbuEM
 Syy/4GNO0ujsOJAj3ngTAWrqMrEMDz9zucmXQ7eNVSTisZQYNObSw31xGc3a2GQ/PMRgYvUbS
 ikMlFeqEfrbHMV5rUdeq+w1W3osB8HPGVCP5vAzhi5uTInigYvWoSu8tCEs4BblInhDVEK+e8
 krE+50JkoCkoFyK70AUt/6Z08lqW/7sn1CEivqK7uXE1eeu5HaQ9ILikDYECWyitbwueOJt8c
 0E7Ke4LiLW2NX5+NioqDnQI92wLmRNcPOKo+NgLNxVGJ2bSJxoYRPomc/Nd0ayMHNYKMzn54j
 1WDwHaaVd1DHoDRkx0cUw3Tjd7juE4F3LR6IVW2xB0880=
Content-Transfer-Encoding: quoted-printable

On 2024-04-01 17:45 +0200, Greg Kroah-Hartman wrote:

> 6.8-stable review patch.  If anyone has any objections, please let me kn=
ow.

Did not test the release candidate, but noticed that the build failed in
both 6.8.3 and 6.7.12.  I have not tested other kernels yet.

> ------------------
>
> From: Borislav Petkov (AMD) <bp@alien8.de>
>
> commit 4535e1a4174c4111d92c5a9a21e542d232e0fcaa upstream.
>
> The original version of the mitigation would patch in the calls to the
> untraining routines directly.  That is, the alternative() in UNTRAIN_RET
> will patch in the CALL to srso_alias_untrain_ret() directly.
>
> However, even if commit e7c25c441e9e ("x86/cpu: Cleanup the untrain
> mess") meant well in trying to clean up the situation, due to micro-
> architectural reasons, the untraining routine srso_alias_untrain_ret()
> must be the target of a CALL instruction and not of a JMP instruction as
> it is done now.
>
> Reshuffle the alternative macros to accomplish that.
>
> Fixes: e7c25c441e9e ("x86/cpu: Cleanup the untrain mess")
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Reviewed-by: Ingo Molnar <mingo@kernel.org>
> Cc: stable@kernel.org
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/x86/include/asm/asm-prototypes.h |    1 +
>  arch/x86/include/asm/nospec-branch.h  |   21 ++++++++++++++++-----
>  arch/x86/lib/retpoline.S              |   11 ++++++-----
>  3 files changed, 23 insertions(+), 10 deletions(-)
>
> --- a/arch/x86/include/asm/asm-prototypes.h
> +++ b/arch/x86/include/asm/asm-prototypes.h
> @@ -13,6 +13,7 @@
>  #include <asm/preempt.h>
>  #include <asm/asm.h>
>  #include <asm/gsseg.h>
> +#include <asm/nospec-branch.h>
>
>  #ifndef CONFIG_X86_CMPXCHG64
>  extern void cmpxchg8b_emu(void);
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -271,11 +271,20 @@
>  .Lskip_rsb_\@:
>  .endm
>
> +/*
> + * The CALL to srso_alias_untrain_ret() must be patched in directly at
> + * the spot where untraining must be done, ie., srso_alias_untrain_ret(=
)
> + * must be the target of a CALL instruction instead of indirectly
> + * jumping to a wrapper which then calls it. Therefore, this macro is
> + * called outside of __UNTRAIN_RET below, for the time being, before th=
e
> + * kernel can support nested alternatives with arbitrary nesting.
> + */
> +.macro CALL_UNTRAIN_RET
>  #if defined(CONFIG_CPU_UNRET_ENTRY) || defined(CONFIG_CPU_SRSO)
> -#define CALL_UNTRAIN_RET	"call entry_untrain_ret"
> -#else
> -#define CALL_UNTRAIN_RET	""
> +	ALTERNATIVE_2 "", "call entry_untrain_ret", X86_FEATURE_UNRET, \
> +		          "call srso_alias_untrain_ret", X86_FEATURE_SRSO_ALIAS
>  #endif
> +.endm
>
>  /*
>   * Mitigate RETBleed for AMD/Hygon Zen uarch. Requires KERNEL CR3 becau=
se the
> @@ -291,8 +300,8 @@
>  .macro __UNTRAIN_RET ibpb_feature, call_depth_insns
>  #if defined(CONFIG_RETHUNK) || defined(CONFIG_CPU_IBPB_ENTRY)
>  	VALIDATE_UNRET_END
> -	ALTERNATIVE_3 "",						\
> -		      CALL_UNTRAIN_RET, X86_FEATURE_UNRET,		\
> +	CALL_UNTRAIN_RET
> +	ALTERNATIVE_2 "",						\
>  		      "call entry_ibpb", \ibpb_feature,			\
>  		     __stringify(\call_depth_insns), X86_FEATURE_CALL_DEPTH
>  #endif
> @@ -351,6 +360,8 @@ extern void retbleed_return_thunk(void);
>  static inline void retbleed_return_thunk(void) {}
>  #endif
>
> +extern void srso_alias_untrain_ret(void);
> +
>  #ifdef CONFIG_CPU_SRSO
>  extern void srso_return_thunk(void);
>  extern void srso_alias_return_thunk(void);
> --- a/arch/x86/lib/retpoline.S
> +++ b/arch/x86/lib/retpoline.S
> @@ -163,6 +163,7 @@ SYM_CODE_START_NOALIGN(srso_alias_untrai
>  	lfence
>  	jmp srso_alias_return_thunk
>  SYM_FUNC_END(srso_alias_untrain_ret)
> +__EXPORT_THUNK(srso_alias_untrain_ret)
>  	.popsection
>
>  	.pushsection .text..__x86.rethunk_safe
> @@ -224,10 +225,12 @@ SYM_CODE_START(srso_return_thunk)
>  SYM_CODE_END(srso_return_thunk)
>
>  #define JMP_SRSO_UNTRAIN_RET "jmp srso_untrain_ret"
> -#define JMP_SRSO_ALIAS_UNTRAIN_RET "jmp srso_alias_untrain_ret"
>  #else /* !CONFIG_CPU_SRSO */
>  #define JMP_SRSO_UNTRAIN_RET "ud2"
> -#define JMP_SRSO_ALIAS_UNTRAIN_RET "ud2"
> +/* Dummy for the alternative in CALL_UNTRAIN_RET. */
> +SYM_CODE_START(srso_alias_untrain_ret)
> +	RET
> +SYM_FUNC_END(srso_alias_untrain_ret)
>  #endif /* CONFIG_CPU_SRSO */
>
>  #ifdef CONFIG_CPU_UNRET_ENTRY
> @@ -319,9 +322,7 @@ SYM_FUNC_END(retbleed_untrain_ret)
>  #if defined(CONFIG_CPU_UNRET_ENTRY) || defined(CONFIG_CPU_SRSO)
>
>  SYM_FUNC_START(entry_untrain_ret)
> -	ALTERNATIVE_2 JMP_RETBLEED_UNTRAIN_RET,				\
> -		      JMP_SRSO_UNTRAIN_RET, X86_FEATURE_SRSO,		\
> -		      JMP_SRSO_ALIAS_UNTRAIN_RET, X86_FEATURE_SRSO_ALIAS
> +	ALTERNATIVE JMP_RETBLEED_UNTRAIN_RET, JMP_SRSO_UNTRAIN_RET, X86_FEATUR=
E_SRSO
>  SYM_FUNC_END(entry_untrain_ret)
>  __EXPORT_THUNK(entry_untrain_ret)

This failed to build on my laptop where CONFIG_CPU_SRSO is not set (CPU
is too old to be vulnerable):

,----
|   OBJCOPY modules.builtin.modinfo
|   GEN     modules.builtin
|   MODPOST Module.symvers
| ERROR: modpost: "srso_alias_untrain_ret" [arch/x86/kvm/kvm-amd.ko] undef=
ined!
| make[5]: *** [scripts/Makefile.modpost:145: Module.symvers] Error 1
| make[4]: *** [Makefile:1873: modpost] Error 2
`----

Cheers,
       Sven
