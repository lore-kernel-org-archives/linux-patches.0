Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F141DA5F;
	Tue,  8 Oct 2024 05:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728364248; cv=none; b=GKbRIZuKCloTWKlScsOjI6LwOEU0ce8b+ZAEhiR12JbXZwB/nLzRQkdygwQgPZIfLMPsWYbT2hmSZPbbE0Osf+Jsv3eUJuldLh2k1HRrk4Jeun9oZs4GpRG3WFuW28MUf6ejehe5lIQCTjGaWIIFM/nXynTduziId2BbYOcIqUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728364248; c=relaxed/simple;
	bh=RR+b9KGd61RszM0wAB15D8oGOUv5u9cw8oK7oBL7OM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rVmACAAhFRBD7yuuW8mrKyk1WFRHx6bzNhs7f3q3UI5+E5vUcC2OJoBSpL66B9xXrxLFjW6q1IwURH1PwF8A30h5kVLSoGAKM9WkUaNO2UZPlvf1n2ITo0WL44SHv8+gzBbZptYM03ODjU8ggS/Voya6PiIauwZRCxG5+8vNPuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4XN3xp2XSpz9sPd;
	Tue,  8 Oct 2024 07:10:38 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nhCO1vPA-Xzj; Tue,  8 Oct 2024 07:10:38 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4XN3xp1bkjz9rvV;
	Tue,  8 Oct 2024 07:10:38 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 261A28B766;
	Tue,  8 Oct 2024 07:10:38 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id nuU85h2Dh9gI; Tue,  8 Oct 2024 07:10:38 +0200 (CEST)
Received: from [192.168.233.14] (PO18990.IDSI0.si.c-s.fr [192.168.233.14])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 883F78B763;
	Tue,  8 Oct 2024 07:10:37 +0200 (CEST)
Message-ID: <331cc7ba-ed5e-4dd3-8175-b51bacb65186@csgroup.eu>
Date: Tue, 8 Oct 2024 07:10:36 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] powerpc: Adjust adding stack protector flags to
 KBUILD_CLAGS for clang
To: Nathan Chancellor <nathan@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>, Naveen N Rao <naveen@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling
 <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Keith Packard <keithp@keithp.com>, linuxppc-dev@lists.ozlabs.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
References: <20241007-powerpc-fix-stackprotector-test-clang-v1-0-08c15b2694e4@kernel.org>
 <20241007-powerpc-fix-stackprotector-test-clang-v1-2-08c15b2694e4@kernel.org>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <20241007-powerpc-fix-stackprotector-test-clang-v1-2-08c15b2694e4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 08/10/2024 à 06:22, Nathan Chancellor a écrit :
> After fixing the HAVE_STACKPROTECTER checks for clang's in-progress
> per-task stack protector support [1], the build fails during prepare0
> because '-mstack-protector-guard-offset' has not been added to
> KBUILD_CFLAGS yet but the other '-mstack-protector-guard' flags have.
> 
>    clang: error: '-mstack-protector-guard=tls' is used without '-mstack-protector-guard-offset', and there is no default
>    clang: error: '-mstack-protector-guard=tls' is used without '-mstack-protector-guard-offset', and there is no default
>    make[4]: *** [scripts/Makefile.build:229: scripts/mod/empty.o] Error 1
>    make[4]: *** [scripts/Makefile.build:102: scripts/mod/devicetable-offsets.s] Error 1
> 
> Mirror other architectures and add all '-mstack-protector-guard' flags
> to KBUILD_CFLAGS atomically during stack_protector_prepare, which
> resolves the issue and allows clang's implementation to fully work with
> the kernel.
> 
> Link: https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Fllvm%2Fllvm-project%2Fpull%2F110928&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7Cc099707fa5464808c49108dce750d65e%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C638639581583232977%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C0%7C%7C%7C&sdata=b%2BcqodA6k739DD%2F74EJMXUtIHAZDt1DGcyd7mzzhbd8%3D&reserved=0 [1]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Is it worth a Fixes: tag so that it gets applied on stable, or wont 
CLANG 20 be used with kernels older than 6.13 ?

> ---
>   arch/powerpc/Makefile | 15 ++++++---------
>   1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
> index bbfe4a1f06ef9db9b2f2e48e02096b1e0500a14b..8f9e387c4c7dd06d8756dca3eac808cc344a937d 100644
> --- a/arch/powerpc/Makefile
> +++ b/arch/powerpc/Makefile
> @@ -100,13 +100,6 @@ KBUILD_AFLAGS	+= -m$(BITS)
>   KBUILD_LDFLAGS	+= -m elf$(BITS)$(LDEMULATION)
>   endif
>   
> -cflags-$(CONFIG_STACKPROTECTOR)	+= -mstack-protector-guard=tls
> -ifdef CONFIG_PPC64
> -cflags-$(CONFIG_STACKPROTECTOR)	+= -mstack-protector-guard-reg=r13
> -else
> -cflags-$(CONFIG_STACKPROTECTOR)	+= -mstack-protector-guard-reg=r2
> -endif
> -
>   LDFLAGS_vmlinux-y := -Bstatic
>   LDFLAGS_vmlinux-$(CONFIG_RELOCATABLE) := -pie
>   LDFLAGS_vmlinux-$(CONFIG_RELOCATABLE) += -z notext
> @@ -402,9 +395,13 @@ prepare: stack_protector_prepare
>   PHONY += stack_protector_prepare
>   stack_protector_prepare: prepare0
>   ifdef CONFIG_PPC64
> -	$(eval KBUILD_CFLAGS += -mstack-protector-guard-offset=$(shell awk '{if ($$2 == "PACA_CANARY") print $$3;}' include/generated/asm-offsets.h))
> +	$(eval KBUILD_CFLAGS += -mstack-protector-guard=tls \
> +				-mstack-protector-guard-reg=r13 \

Can you put both above lines on a single line to avoid having too many 
lines at the end:

+	$(eval KBUILD_CFLAGS += -mstack-protector-guard=tls 
-mstack-protector-guard-reg=r13 \

> +				-mstack-protector-guard-offset=$(shell awk '{if ($$2 == "PACA_CANARY") print $$3;}' include/generated/asm-offsets.h))
>   else
> -	$(eval KBUILD_CFLAGS += -mstack-protector-guard-offset=$(shell awk '{if ($$2 == "TASK_CANARY") print $$3;}' include/generated/asm-offsets.h))
> +	$(eval KBUILD_CFLAGS += -mstack-protector-guard=tls \
> +				-mstack-protector-guard-reg=r2 \

Same

> +				-mstack-protector-guard-offset=$(shell awk '{if ($$2 == "TASK_CANARY") print $$3;}' include/generated/asm-offsets.h))
>   endif
>   endif
>   
> 
