Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED80C2D8DC4
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 23:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760742288; cv=none; b=MeomDYHII2fAnUA7klHjP5P7D4QSQCGlMU3X94f9WJYKdTIK0K5J7uUzi2Yu8a5ftnF01vz+AWpg4XK1Y2931mx3xE+qj7eKRx/YyBa4VJ+K1Slkklc90CsRJy6vmJ/KDD8amiDBKrQ6TvIHq5UbFgSi1GLstbOQ8pXR3zUBjFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760742288; c=relaxed/simple;
	bh=34t2guKeP6RRMMYoEjTZ6QMeXJWGLVnlKOiJfockngw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=aqMDoRbqyVbt50OvGlPZ1CqV7mBgI5MleYzxVXNaj9txNdwNhAICCSyYKKm2iTm1gm6Z56TXcbWMkyx9aTx3ltlnwgdAMNAM0us5abnoXXvv+GwWGAHwGFM7e6RWYvhKvMFcERXBSUZOJXn6xbVWQEOhD+y9xg22Kl60O6tA8ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DuXxer6t; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DuXxer6t"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8915bd01244so158744485a.1
        for <patches@lists.linux.dev>; Fri, 17 Oct 2025 16:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760742284; x=1761347084; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oYy8526wfT6JSdIqvj3HrQ0icx4SEndY8ccI3Hg2clg=;
        b=DuXxer6td/e1zoRY1zQ1uvRy2Os4DJAORdEiQMHvv5zwvEpTJSlv4VglOAx5CbvW2i
         mFXBNk+5mlMpc7XPq0FZg0tQ4HHuSrQJjtywNealFEn7G7Xee4JAHAdOkreqkMqh1843
         fUdXCHnWLwZp6qPOEkxKP9F6paNC9+5zNH0lSwEdc7bwb7+Z6r6dV4LlkE9nrcXW8icF
         fZtJ8ifOhqY5qJgKRgz1sRiwJkjFk8JWXRUjBXbrDHB2gNLWNRMYuQ7Hma8hscf7sk5I
         M2IMZZPeJLIWMkmg5bU9BlpAHfOcsCGBZjnJKLL9KCQp2lTMvDJpPT8cNWlkzOBvRkNb
         7H2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760742284; x=1761347084;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oYy8526wfT6JSdIqvj3HrQ0icx4SEndY8ccI3Hg2clg=;
        b=b/CQQmRU13jVACZn+4uxtHY0WNcHAwMB4lrT+oLKqcaic0r9hJoizDTsbC9Eydxxrm
         9+uHNOoZWM0qZiEOqf+Vxh6tWIlPSCqrWUlyLbhV9SUFROa6tzhmgECXNOU29jUBJhoK
         S573n/eKah62gF67iyXfszkA/nFj+pIExYYVgFRWCA1qQZK/cDrzDaVAOKL7Kg/DcLKA
         3K8GzaF2phDHZmchztYbv9Y+4Ml1heT3xxmDdn5LG+ZwQP6M7b76FN9MO6DFSkCF52m4
         HR7M12GQSuPxzb6Nag//OozJDyFgrcP7oc5ReCohGt8JjvSaNGBWGqZe66Q/OjR4kvRC
         XjkA==
X-Gm-Message-State: AOJu0Yx5NqNbrBPNojxQICMn8pc2/j/ve8+vpmlJETxpCrjimuyOltvk
	agB6EynHzkvgWFbTGENV4IF47n0AZ2PHdLd9vKdNy7P/Im+ZzL38+qLg
X-Gm-Gg: ASbGncvT/DjHFBvJK2dFB6XfTU22Iq2e3WOd8wEWNh1PpSeMBuavE0XwclXPV9RBOAK
	pJY8xpq/xAM444aDOvNReYdtqrgs5ki3yQQqcDVo56sX0rrJRRDCrhp7+8MiR8l0hWs00CEla54
	zy32hU+hmz702K+jtWAXY66QWlwEepShVmp6+fFCLs7xRk3hTpskWjiqj3Elel3jtSrC3Bj1GAD
	12pLIWf4UeIG7unYj4luC10vFiDBYPGXCKnadhRK/OqYpXExJEWaCBxp1q3Bg22xevmHHuoYkyq
	y/sPuqpdIBSlKJ1lh5qVULL8OkHPKmyobxNcC3ASLdR7kVt5FteL5w9bfdHXp3a8uPxhLqqgsWx
	acrxoDfD1gnNtnrbDaK6vhfuPB6AV5kVKd75D2iZ0SfkG3v0AC1a+DQr03jUsJyEGTxTIgkKqan
	l6yUgdCdOcDG9iKp+QqRXXDtK+oqk=
X-Google-Smtp-Source: AGHT+IGu5TpaguVbSh7DB4qrTllZFZhmQoXm1v7312k72abIPidk51MwdQlGrQgSmL1IeFVKXdneeg==
X-Received: by 2002:ac8:574d:0:b0:4c7:9b85:f6d4 with SMTP id d75a77b69052e-4e89d262ec3mr79164521cf.22.1760742284484;
        Fri, 17 Oct 2025 16:04:44 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87cf52209cesm6626376d6.23.2025.10.17.16.04.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 16:04:43 -0700 (PDT)
Message-ID: <acbbf30b-44cd-4f31-a979-dc576585c65b@gmail.com>
Date: Fri, 17 Oct 2025 16:04:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/276] 5.15.195-rc1 review
From: Florian Fainelli <f.fainelli@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Ali Saidi <alisaidi@amazon.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251017145142.382145055@linuxfoundation.org>
 <c1b098d5-3499-4e24-aff9-6e5a293b4b1b@gmail.com>
Content-Language: en-US, fr-FR
In-Reply-To: <c1b098d5-3499-4e24-aff9-6e5a293b4b1b@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

+Ali,

On 10/17/25 15:57, Florian Fainelli wrote:
> On 10/17/25 07:51, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.195 release.
>> There are 276 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
>> patch-5.15.195-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable- 
>> rc.git linux-5.15.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> perf fails to build on ARM, ARM64 and MIPS with:
> 
> In file included from util/arm-spe.c:37:
> /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/ 
> include/../../arch/arm64/include/asm/cputype.h:198:10: fatal error: asm/ 
> sysreg.h: No such file or directory
>    198 | #include <asm/sysreg.h>
>        |          ^~~~~~~~~~~~~~
> compilation terminated.
> 
> I was not able to run a bisection but will attempt to do that later 
> during the weekend.

That is due to commit 07b49160816a936be7c1e0af869097223e75d547
Author: Ali Saidi <alisaidi@amazon.com>
Date:   Thu Aug 11 14:24:39 2022 +0800

     perf arm-spe: Use SPE data source for neoverse cores

and this hunk specifically:

diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index 569e1b8ad0ab..7b16898af4e7 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -34,6 +34,7 @@
  #include "arm-spe-decoder/arm-spe-decoder.h"
  #include "arm-spe-decoder/arm-spe-pkt-decoder.h"

+#include "../../arch/arm64/include/asm/cputype.h"
  #define MAX_TIMESTAMP (~0ULL)

There is a dependency on this upstream commit:

commit 1314376d495f2d79cc58753ff3034ccc503c43c9
Author: Ali Saidi <alisaidi@amazon.com>
Date:   Thu Mar 24 18:33:20 2022 +0000

     tools arm64: Import cputype.h


for tools/arch/arm64/include/asm/cputype.h to be present.
-- 
Florian
