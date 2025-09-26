Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C7F6299A84
	for <patches@lists.linux.dev>; Fri, 26 Sep 2025 08:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758876637; cv=none; b=iFmtAxnSQ1Jvu9cIOlvNO6xkWG+xu66X+ku6pV+7Ij8282zVy0+7lLCxqiFDRT01XY1zBC/zEvEL1nqGCr5hbMMy02oDKjsxcI76eSerSXIxZulDBSqKNEUTtSWZf1Q5sjXYKfphlL/wbDqdAIpar4aPPRAoKor8+Q7QRIZw/0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758876637; c=relaxed/simple;
	bh=D629ILsm8yIf6N6Wi+IBOv2qOHjA3e0tDSwJEBmHiYA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F8kBMz3Uj8BpI9/Mikip0fsXx0zW8LziAQQ6+OPjhN95ZCj/I0mvvql7iUBvwBwafaux/UF06k7PPcOQi30xohsQsW1yeYB7tOUN8iGF2uAApn4to4cy2Bit8Utyz90AJQlTjfoLaK2ooub/guhXYbHQSB6cndr2iZfkk2NV0S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4cY3ds3pnFz9sSK;
	Fri, 26 Sep 2025 10:29:05 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gpyn6YKZcwFS; Fri, 26 Sep 2025 10:29:05 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4cY3ds370mz9sSH;
	Fri, 26 Sep 2025 10:29:05 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 5B93D8B77A;
	Fri, 26 Sep 2025 10:29:05 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id E9phddn9wLTH; Fri, 26 Sep 2025 10:29:05 +0200 (CEST)
Received: from [192.168.202.221] (unknown [192.168.202.221])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id DCC558B779;
	Fri, 26 Sep 2025 10:29:03 +0200 (CEST)
Message-ID: <8e49e321-f6bc-4cb8-9c71-5c6229e1dc5c@csgroup.eu>
Date: Fri, 26 Sep 2025 10:29:03 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] macintosh/via-pmu-backlight: Include linux/of.h and
 uapi/linux/fb.h
To: Nathan Chancellor <nathan@kernel.org>, Lee Jones <lee@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, Daniel Thompson <danielt@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Simona Vetter <simona.vetter@ffwll.ch>, linuxppc-dev@lists.ozlabs.org,
 patches@lists.linux.dev
References: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-0-d256858d86a6@kernel.org>
 <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-2-d256858d86a6@kernel.org>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-2-d256858d86a6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 26/09/2025 à 01:46, Nathan Chancellor a écrit :
> After the recent removal of the fb.h include from backlight.h, which
> transitively included of.h, there are several errors from
> via-pmu-backlight.c (errors from bl_curve not being properly defined
> omitted):
> 
>    drivers/macintosh/via-pmu-backlight.c:22:20: error: 'FB_BACKLIGHT_LEVELS' undeclared here (not in a function)
>       22 | static u8 bl_curve[FB_BACKLIGHT_LEVELS];
>          |                    ^~~~~~~~~~~~~~~~~~~
>    drivers/macintosh/via-pmu-backlight.c: In function 'pmu_backlight_get_level_brightness':
>    drivers/macintosh/via-pmu-backlight.c:63:38: error: 'FB_BACKLIGHT_MAX' undeclared (first use in this function); did you mean 'BACKLIGHT_RAW'?
>       63 |         pmulevel = bl_curve[level] * FB_BACKLIGHT_MAX / MAX_PMU_LEVEL;
>          |                                      ^~~~~~~~~~~~~~~~
>          |                                      BACKLIGHT_RAW
>    drivers/macintosh/via-pmu-backlight.c: In function 'pmu_backlight_init':
>    drivers/macintosh/via-pmu-backlight.c:144:17: error: implicit declaration of function 'of_machine_is_compatible' [-Wimplicit-function-declaration]
>      144 |                 of_machine_is_compatible("AAPL,3400/2400") ||
>          |                 ^~~~~~~~~~~~~~~~~~~~~~~~
> 
> FB_BACKLIGHT_{LEVELS,MAX} are available from the userspace API fb.h so
> just include that avoid dragging in the full fb.h header unnecessarily.
> Include linux/of.h for of_machine_is_compatible().
> 
> Fixes: 9f218f9bb9d2 ("backlight: Do not include <linux/fb.h> in header file")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>

> ---
>   drivers/macintosh/via-pmu-backlight.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/macintosh/via-pmu-backlight.c b/drivers/macintosh/via-pmu-backlight.c
> index 26bd9ed5e664..f7b7853b3802 100644
> --- a/drivers/macintosh/via-pmu-backlight.c
> +++ b/drivers/macintosh/via-pmu-backlight.c
> @@ -11,7 +11,9 @@
>   #include <asm/ptrace.h>
>   #include <linux/adb.h>
>   #include <linux/backlight.h>
> +#include <linux/of.h>
>   #include <linux/pmu.h>
> +#include <uapi/linux/fb.h>
>   #include <asm/backlight.h>
>   
>   #define MAX_PMU_LEVEL 0xFF
> 

