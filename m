Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C0E16A92E;
	Wed, 18 Dec 2024 08:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734511036; cv=none; b=P1Q5Jwz3yGGY2m1gMzJtK04zozK9PuFRO1Lct5BmvjufNJGO9eGFQ+LIrs5M2NvhG3BjY1mG8VR0e/g0FFQKfnA73IGDZxsvwHcnp+EPBr3mFE1jBKOVjfIJ2A8O0OWmuhrn0JiJq4KqSWs6edKljux0hGup5jkhSDtp/31y2Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734511036; c=relaxed/simple;
	bh=wPKUFldiuNqBjG0a/xOpQu9J75D96Hlp5eFVsjWyL2I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GoOMhX2F23Itqopj8wZtO25QUSgzi7rQBN7YT7B9npBOpenfQbC/o2xWtWfhX0R2KqommmJ8BUthidFPtW7h3MrgIghzU75x8MRsgpK5GaP/RleKU/c4lL+CKbiU+Y2dDcQa7vWboGTxQOrrQPSMtEGoznxvdWgWuD0lI+7Oxlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ALlvMlZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ALlvMlZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DD5C4CECE;
	Wed, 18 Dec 2024 08:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734511035;
	bh=wPKUFldiuNqBjG0a/xOpQu9J75D96Hlp5eFVsjWyL2I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ALlvMlZK326BgI07QkmV9tdYg0zBEZ63n08FX+ZjBSkH6lE6Az2NWW5uT8MrjFvs2
	 D5HIaeBD38raBvxcHlby9nAS1DsVwgBn7Cb7DELZLzH6rcCxhaCxl7XrD6eV0XUWkY
	 nmeD1OzPHSaY6wfA8c0we7bd1KFsxmeXhMjrdzsNxlTUNzYTofIl8CZXlDV2xVtBVz
	 rT1y/t8HRkAuBUirYV/GrZdNN1V83UKk163oAXQv7ompcNAeu4MYjcl8vO6BNJnVJb
	 nFm9fcHzyaB9D2q8r4IdbfeH6EZPu8bMMLBqIyXHi23cubudbSUvcD+Q/X8+BjLlzg
	 jd4XDRJRKwMiA==
Message-ID: <bf593d44-c59e-4158-b2c6-112372ab45d1@kernel.org>
Date: Wed, 18 Dec 2024 09:37:12 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 168/172] x86/static-call: provide a way to do very
 early static-call updates
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Andrew Cooper <andrew.cooper3@citrix.com>,
 Juergen Gross <jgross@suse.com>, Peter Zijlstra <peterz@infradead.org>,
 Josh Poimboeuf <jpoimboe@redhat.com>
References: <20241217170546.209657098@linuxfoundation.org>
 <20241217170553.299136607@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20241217170553.299136607@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17. 12. 24, 18:08, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Juergen Gross <jgross@suse.com>
> 
> commit 0ef8047b737d7480a5d4c46d956e97c190f13050 upstream.
> 
> Add static_call_update_early() for updating static-call targets in
> very early boot.
> 
> This will be needed for support of Xen guest type specific hypercall
> functions.
> 
> This is part of XSA-466 / CVE-2024-53241.
> 
> Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Co-developed-by: Peter Zijlstra <peterz@infradead.org>
> Co-developed-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   arch/x86/include/asm/static_call.h |   15 +++++++++++++++
>   arch/x86/include/asm/sync_core.h   |    6 +++---
>   arch/x86/kernel/static_call.c      |    9 +++++++++
>   include/linux/compiler.h           |   37 ++++++++++++++++++++++++++-----------
>   include/linux/static_call.h        |    1 +
>   kernel/static_call_inline.c        |    2 +-
>   6 files changed, 55 insertions(+), 15 deletions(-)
> 
> --- a/arch/x86/include/asm/static_call.h
> +++ b/arch/x86/include/asm/static_call.h
> @@ -65,4 +65,19 @@
>   
>   extern bool __static_call_fixup(void *tramp, u8 op, void *dest);
>   
> +extern void __static_call_update_early(void *tramp, void *func);
> +
> +#define static_call_update_early(name, _func)				\
> +({									\
> +	typeof(&STATIC_CALL_TRAMP(name)) __F = (_func);			\
> +	if (static_call_initialized) {					\
> +		__static_call_update(&STATIC_CALL_KEY(name),		\
> +				     STATIC_CALL_TRAMP_ADDR(name), __F);\
> +	} else {							\
> +		WRITE_ONCE(STATIC_CALL_KEY(name).func, _func);		\
> +		__static_call_update_early(STATIC_CALL_TRAMP_ADDR(name),\
> +					   __F);			\
> +	}								\
> +})
...
> --- a/kernel/static_call_inline.c
> +++ b/kernel/static_call_inline.c
> @@ -15,7 +15,7 @@ extern struct static_call_site __start_s
>   extern struct static_call_tramp_key __start_static_call_tramp_key[],
>   				    __stop_static_call_tramp_key[];
>   
> -static int static_call_initialized;
> +int static_call_initialized;

This breaks the build on i386:
> ld: arch/x86/xen/enlighten.o: in function `__xen_hypercall_setfunc':
> enlighten.c:(.noinstr.text+0x2a): undefined reference to `static_call_initialized'
> ld: enlighten.c:(.noinstr.text+0x62): undefined reference to `static_call_initialized'
> ld: arch/x86/kernel/static_call.o: in function `__static_call_update_early':
> static_call.c:(.noinstr.text+0x15): undefined reference to `static_call_initialized'

kernel/static_call_inline.c containing this `static_call_initialized` is 
not built there as:
HAVE_STATIC_CALL_INLINE=n
  -> HAVE_OBJTOOL=n
     -> X86_64=n

This is broken in upstream too.

thanks,
-- 
js
suse labs

