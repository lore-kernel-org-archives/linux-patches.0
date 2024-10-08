Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295B813D50B;
	Tue,  8 Oct 2024 05:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728364472; cv=none; b=aCvUCzcKwPJGb5/sAxKnucJ08zdEhPmFdPgv+6bh58VlSds5XWyyOymzLTSdLfRCEVs8gbX3Z9fHkW8gj1wT+YynCil7NmVHgd0phJA/aSFZXKS6CgBk/FaEORBlHRmTWCINYRRqLiQDMm937zHxHflxIYP8bR38NVfzqAyL+6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728364472; c=relaxed/simple;
	bh=iR/kMQsPRx/kSr1hFqGArh1VtXjZ/tF8/CXJi5WIofg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p6JTXkwJqcFpJJTx1piKq+K8ea3ohU+VKg0sON642NpSSW5wHJfX69iQcmkgsDTo3DKHArhA8fWILoasGp/YxdvhaqHLD1XzpE97zl66v4RvkDpN4dZRb/HFdfnoV2ad4+AWWDqyLFnkuc4HBxiRR1GWxMYG46SPSmfh95U/dis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4XN42D0lxzz9sRk;
	Tue,  8 Oct 2024 07:14:28 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kvPadbdqqlVy; Tue,  8 Oct 2024 07:14:28 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4XN42C6ZJnz9rvV;
	Tue,  8 Oct 2024 07:14:27 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id CAA848B766;
	Tue,  8 Oct 2024 07:14:27 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id 29qNJNqcmicP; Tue,  8 Oct 2024 07:14:27 +0200 (CEST)
Received: from [192.168.233.14] (PO18990.IDSI0.si.c-s.fr [192.168.233.14])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 397B88B763;
	Tue,  8 Oct 2024 07:14:27 +0200 (CEST)
Message-ID: <a57f21db-911c-4331-af7b-c02c0ea8b1e6@csgroup.eu>
Date: Tue, 8 Oct 2024 07:14:26 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] powerpc: Include -m32 / -m64 for stack protector
 Kconfig test
To: Nathan Chancellor <nathan@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>, Naveen N Rao <naveen@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling
 <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Keith Packard <keithp@keithp.com>, linuxppc-dev@lists.ozlabs.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
References: <20241007-powerpc-fix-stackprotector-test-clang-v1-0-08c15b2694e4@kernel.org>
 <20241007-powerpc-fix-stackprotector-test-clang-v1-3-08c15b2694e4@kernel.org>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <20241007-powerpc-fix-stackprotector-test-clang-v1-3-08c15b2694e4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 08/10/2024 à 06:22, Nathan Chancellor a écrit :
> Kbuild uses the powerpc64le-linux-gnu target for clang, which causes the
> Kconfig check for 32-bit powerpc stack protector support to fail because
> nothing flips the target to 32-bit:
> 
>    $ clang --target=powerpc64le-linux-gnu \
>            -mstack-protector-guard=tls
>            -mstack-protector-guard-reg=r2 \
>            -mstack-protector-guard-offset=0 \
>            -x c -c -o /dev/null /dev/null
>    clang: error: invalid value 'r2' in 'mstack-protector-guard-reg=', expected one of: r13

Why is there any restriction at all on which register can be used ? I 
can't see such restriction in GCC documentation : 
https://gcc.gnu.org/onlinedocs/gcc/RS_002f6000-and-PowerPC-Options.html



> 
> Use the Kconfig macro '$(m32-flag)', which expands to '-m32' when
> supported, in the stack protector support cc-option call to properly
> switch the target to a 32-bit one, which matches what happens in Kbuild.
> While the 64-bit macro does not strictly need it, add the equivalent
> 64-bit option for symmetry.
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   arch/powerpc/Kconfig | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index eb98050b8c016bb23887a9d669d29e69d933c9c8..6aaca48955a34b2a38af1415bfa36f74f35c3f3e 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -275,8 +275,8 @@ config PPC
>   	select HAVE_RSEQ
>   	select HAVE_SETUP_PER_CPU_AREA		if PPC64
>   	select HAVE_SOFTIRQ_ON_OWN_STACK
> -	select HAVE_STACKPROTECTOR		if PPC32 && $(cc-option,-mstack-protector-guard=tls -mstack-protector-guard-reg=r2 -mstack-protector-guard-offset=0)
> -	select HAVE_STACKPROTECTOR		if PPC64 && $(cc-option,-mstack-protector-guard=tls -mstack-protector-guard-reg=r13 -mstack-protector-guard-offset=0)
> +	select HAVE_STACKPROTECTOR		if PPC32 && $(cc-option,$(m32-flag) -mstack-protector-guard=tls -mstack-protector-guard-reg=r2 -mstack-protector-guard-offset=0)
> +	select HAVE_STACKPROTECTOR		if PPC64 && $(cc-option,$(m64-flag) -mstack-protector-guard=tls -mstack-protector-guard-reg=r13 -mstack-protector-guard-offset=0)

You modify the exact same line than Patch 1, if this patch is really 
required it should be squashed into patch 1 I think.

>   	select HAVE_STATIC_CALL			if PPC32
>   	select HAVE_SYSCALL_TRACEPOINTS
>   	select HAVE_VIRT_CPU_ACCOUNTING
> 
