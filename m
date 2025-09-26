Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D5D7299A84
	for <patches@lists.linux.dev>; Fri, 26 Sep 2025 08:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758876642; cv=none; b=WliRGD+DBEn9NV5TvGSmi1anNV4Ht6te+xLS72jnSIy03vbRBGq5CjrzHOp7OTeScaxEbJIA6xxK6uh+qyvSRxATMuBDzuRLzlTkLO892LiK7zIgokwRoIpZe5vWDG+kY7hl3wexg+b6EhjcrDuIm8rNw3Fsf9U3DfyMgUg2Xzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758876642; c=relaxed/simple;
	bh=ul1NEhnbiUMO49txUNNzMISMSoxG79zIc5iWpi2jRb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fKtDmOna0h+ZgW625BYnpvHYnCLYABoYQrM9ClJXAEaEF7LJWAv7yXf2D6OUdtcj0+Dw59o27WLI8ojXEcCOLgjgrHN9JZ+sB1C31QclQt4Q5vhvx+TG3Q1a71rjqRerQMuJ/JOAn/MZn3Tk0ftu6EyF0rRsTqEjIvH7sBfNtnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4cY3d01yVxz9sS7;
	Fri, 26 Sep 2025 10:28:20 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FW7tiURCBRKs; Fri, 26 Sep 2025 10:28:20 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4cY3d01DRwz9sRy;
	Fri, 26 Sep 2025 10:28:20 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 174F98B779;
	Fri, 26 Sep 2025 10:28:20 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id FTyBMc6SdSsM; Fri, 26 Sep 2025 10:28:20 +0200 (CEST)
Received: from [192.168.202.221] (unknown [192.168.202.221])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 964128B768;
	Fri, 26 Sep 2025 10:28:18 +0200 (CEST)
Message-ID: <e9e538bd-644b-4c02-bf14-6f5d397554c1@csgroup.eu>
Date: Fri, 26 Sep 2025 10:28:17 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] powerpc/powermac: Include linux/of.h in backlight.c
To: Nathan Chancellor <nathan@kernel.org>, Lee Jones <lee@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, Daniel Thompson <danielt@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Simona Vetter <simona.vetter@ffwll.ch>, linuxppc-dev@lists.ozlabs.org,
 patches@lists.linux.dev
References: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-0-d256858d86a6@kernel.org>
 <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-1-d256858d86a6@kernel.org>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-1-d256858d86a6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 26/09/2025 à 01:46, Nathan Chancellor a écrit :
> After the recent removal of the fb.h include from backlight.h, which
> transitively included of.h, there are several errors in the powermac backlight
> driver:
> 
>    arch/powerpc/platforms/powermac/backlight.c: In function 'pmac_has_backlight_type':
>    arch/powerpc/platforms/powermac/backlight.c:59:39: error: implicit declaration of function 'of_find_node_by_name'; did you mean 'bus_find_device_by_name'? [-Wimplicit-function-declaration]
>       59 |         struct device_node* bk_node = of_find_node_by_name(NULL, "backlight");
>          |                                       ^~~~~~~~~~~~~~~~~~~~
>          |                                       bus_find_device_by_name
>    arch/powerpc/platforms/powermac/backlight.c:59:39: error: initialization of 'struct device_node *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
>    arch/powerpc/platforms/powermac/backlight.c:60:17: error: implicit declaration of function 'of_property_match_string' [-Wimplicit-function-declaration]
>       60 |         int i = of_property_match_string(bk_node, "backlight-control", type);
>          |                 ^~~~~~~~~~~~~~~~~~~~~~~~
>    arch/powerpc/platforms/powermac/backlight.c:62:9: error: implicit declaration of function 'of_node_put' [-Wimplicit-function-declaration]
>       62 |         of_node_put(bk_node);
>          |         ^~~~~~~~~~~
> 
> Explicitly include of.h to resolve the errors.
> 
> Fixes: 9f218f9bb9d2 ("backlight: Do not include <linux/fb.h> in header file")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>

> ---
>   arch/powerpc/platforms/powermac/backlight.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/powerpc/platforms/powermac/backlight.c b/arch/powerpc/platforms/powermac/backlight.c
> index 79741370c40c..9afb64723649 100644
> --- a/arch/powerpc/platforms/powermac/backlight.c
> +++ b/arch/powerpc/platforms/powermac/backlight.c
> @@ -14,6 +14,7 @@
>   #include <linux/pmu.h>
>   #include <linux/atomic.h>
>   #include <linux/export.h>
> +#include <linux/of.h>
>   #include <asm/backlight.h>
>   
>   #define OLD_BACKLIGHT_MAX 15
> 

