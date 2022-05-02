Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCFF28E0
	for <patches@lists.linux.dev>; Mon,  2 May 2022 13:28:43 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4KsNwC0BHxz4xdK;
	Mon,  2 May 2022 23:19:06 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1651497548;
	bh=iEySDLJ6Aqsuxw7jZX+qz0oRACs5k7MznXRI7Is3+DM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=OxypIl0DwsP8OIrDUEH4RcIYF9o9ktOM49sVtUdHk0FzRzM99aNOuSHBF/+dgU35P
	 ampVokg9nrO7De2kFE1IJPrz1TJLybimd13gXV2VzwXUNHieV6NCqhNoL0C1V7REd+
	 OGUG6lguapm84tveOaJGpujYq8ffZ4x0mdQvHhxIaDgt89ejEDaExc9eSCVRv0wWut
	 XHGrjf89cMXoj3TN/twUJNl8+m0gfLHmdsH/77o3ZfyCZvp4k+mErhq18OfN9gR9yW
	 qAIoNbz9sK8yCCnIzDMTkw5RzBY0CG+CSPjSzVi4jzXQMtCOH5Ymyhp6TonhuX2rnY
	 5SWhWve5W6H6A==
From: Michael Ellerman <mpe@ellerman.id.au>
To: Randy Dunlap <rdunlap@infradead.org>, linuxppc-dev@lists.ozlabs.org
Cc: patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>, Arnd
 Bergmann <arnd@arndb.de>, Paul Mackerras <paulus@samba.org>, Benjamin
 Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] POWERPC: idle: fix return value of __setup handler
In-Reply-To: <20220313065848.2150-1-rdunlap@infradead.org>
References: <20220313065848.2150-1-rdunlap@infradead.org>
Date: Mon, 02 May 2022 23:19:06 +1000
Message-ID: <87r15c8439.fsf@mpe.ellerman.id.au>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Randy Dunlap <rdunlap@infradead.org> writes:
> __setup() handlers should return 1 to obsolete_checksetup() in
> init/main.c to indicate that the boot option has been handled.
> A return of 0 causes the boot option/value to be listed as an Unknown
> kernel parameter and added to init's (limited) argument or environment
> strings. Also, error return codes don't mean anything to
> obsolete_checksetup() -- only non-zero (usually 1) or zero.
> So return 1 from powersave_off().
>
> Fixes: 302eca184fb8 ("[POWERPC] cell: use ppc_md->power_save instead of cbe_idle_loop")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> From: Igor Zhbanov <i.zhbanov@omprussia.ru>

What happened here? Is the patch actually from Igor? If so he should be
the author, and it should include his SoB shouldn't it?

Same comment for "[PATCH] powerpc/4xx: cpm: fix return value of __setup handler".

cheers

> Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  arch/powerpc/kernel/idle.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-next-20220310.orig/arch/powerpc/kernel/idle.c
> +++ linux-next-20220310/arch/powerpc/kernel/idle.c
> @@ -37,7 +37,7 @@ static int __init powersave_off(char *ar
>  {
>  	ppc_md.power_save = NULL;
>  	cpuidle_disable = IDLE_POWERSAVE_OFF;
> -	return 0;
> +	return 1;
>  }
>  __setup("powersave=off", powersave_off);
>  
