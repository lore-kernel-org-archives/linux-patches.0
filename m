Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C322F285CBA;
	Fri, 22 Aug 2025 10:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755858037; cv=none; b=WWaYJAREyoRO/VLOzEGreYFQF66qe5kQFA15YI6n9LCm6hHZkIxk04GJ3Y++EJtEcK7wRSGxiConU8pqkyqrLYykHrB6tlhjv0WDoZ8sWHsLkQkmc9/GGRzg0QBxffSjYnzgFWZkau6FJk+e6gPn9gpVTZZ5RJq5X3Gh+np40N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755858037; c=relaxed/simple;
	bh=rzGxnwCJtieGgdp0m86s2BNd6Pc/bNxGGpfjRDdO6qM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WHiR0OVw0shtnJ/rWLzmZFzhbNSTrcxfTLiKRsrzS47dEmcOslA3XMfaVN3R5r+OVYA8GcvgxK/R39wH5mv6o+aytccdlvoKboPNIcUWXfzK9q+RXq6Hv1DxE3CMwuO2M8+oYFI02LBAFb3Sn95pWAM7VJPRyHzZMHb+Kt9nQuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c7bMB03M7z9sSq;
	Fri, 22 Aug 2025 12:01:58 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y_ks77h51LJ0; Fri, 22 Aug 2025 12:01:57 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c7bM96P6yz9sSp;
	Fri, 22 Aug 2025 12:01:57 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id C1B9A8B77E;
	Fri, 22 Aug 2025 12:01:57 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id xG2Hu46FC68E; Fri, 22 Aug 2025 12:01:57 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 29CC98B763;
	Fri, 22 Aug 2025 12:01:57 +0200 (CEST)
Message-ID: <285e1504-a25a-452d-958e-9db3963a02cb@csgroup.eu>
Date: Fri, 22 Aug 2025 12:01:57 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/12] powerpc: Drop unnecessary initializations in
 __copy_inst_from_kernel_nofault()
To: Nathan Chancellor <nathan@kernel.org>, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 llvm@lists.linux.dev, patches@lists.linux.dev,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 linuxppc-dev@lists.ozlabs.org
References: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
 <20250821-bump-min-llvm-ver-15-v2-6-635f3294e5f0@kernel.org>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <20250821-bump-min-llvm-ver-15-v2-6-635f3294e5f0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 21/08/2025 à 23:15, Nathan Chancellor a écrit :
> Now that the minimum supported version of LLVM for building the kernel
> has been bumped to 15.0.0, the zero initializations of val and suffix
> added by commit 0d76914a4c99 ("powerpc/inst: Optimise
> copy_inst_from_kernel_nofault()") to avoid a bogus case of
> -Wuninitialized can be dropped because the preprocessor condition is
> always false.
> 
> Reviewed-by: Kees Cook <kees@kernel.org>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>

> ---
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: linuxppc-dev@lists.ozlabs.org
> ---
>   arch/powerpc/include/asm/inst.h | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/inst.h b/arch/powerpc/include/asm/inst.h
> index 684d3f453282..ffa82167c860 100644
> --- a/arch/powerpc/include/asm/inst.h
> +++ b/arch/powerpc/include/asm/inst.h
> @@ -143,10 +143,6 @@ static inline int __copy_inst_from_kernel_nofault(ppc_inst_t *inst, u32 *src)
>   {
>   	unsigned int val, suffix;
>   
> -/* See https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2FClangBuiltLinux%2Flinux%2Fissues%2F1521&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C23038335822b4dbe2adc08dde0f7f50e%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C638914077769007882%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=EfgIB7nIdCB2e3KWeEvsXKG%2B8LrK%2FjpUrA4RIeMcreo%3D&reserved=0 */
> -#if defined(CONFIG_CC_IS_CLANG) && CONFIG_CLANG_VERSION < 140000
> -	val = suffix = 0;
> -#endif
>   	__get_kernel_nofault(&val, src, u32, Efault);
>   	if (IS_ENABLED(CONFIG_PPC64) && get_op(val) == OP_PREFIX) {
>   		__get_kernel_nofault(&suffix, src + 1, u32, Efault);
> 

