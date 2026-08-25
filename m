Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F606442B0B
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 17:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787680065; cv=none; b=SkMy9q+6wRE2LeyfdjlKzBp2qGxOhr9DuzthnneVOVzoT1v+f/9XpZyWSyV66vXXh6VtTW93bVEA+Yn79N98PhxRrtfqtqwFbPLV8Y0IGBJlCzGlXo9iO1j8bRfKY1Gz3b8fwwogiXhPSzko7TmXQo3kGmCA9+9OBd9KkilN5eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787680065; c=relaxed/simple;
	bh=zMbngc3qdiMhSfAuDNFpS1vX0WbZW8PHrPGV1cV0NHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a1JahIx8zAKj/O9iLME/DWXtS3KXrg7XC8rujN9iqWonj2GmNnlbLfCne8W1nOh5FiOGUXSDtO04wyJeLt966Fs2O3DveLn0fSaMrFi+rWSu95z1VzJIgQBcP/9W/SgoOHrSKqgLOoxt1ldxp46zAu44+VYoZQezFF8rz1AQzLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aZl2emFe; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aZl2emFe"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-39652a6e963so937031a91.0
        for <patches@lists.linux.dev>; Tue, 25 Aug 2026 10:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787680063; x=1788284863; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3nqK+uofot3qNgcx5OymPq89/mB6rANapa6yRWsX8aY=;
        b=aZl2emFeRhCxdaI5dqwFTZB0rVcTTch//SdkpRW+apqDrUQDeHdgiAtVx8/5ihW/8k
         ACH2pdToIVAIIsxpWo0UxW6O5fQAx+2VW5wfMEoJXwpdZ+koKrdnWk/p4+O2Mg+z1Qrf
         1p8CSSWTvlxzb9Q1ayG7DZEXjKxMKnSmt4pwKidBYqLEis65m6rQ3t3yohq9bnWwjZoc
         Qeg3GLGXHu+jVOOnQ/5vKdygicpwS3DJzyvtz4eA83af3T9v0in9hXb/rh8zI7XRCGHr
         090RMyAc1MHwp0+dgzU52b3Vk8joaz4q77/lacea3TUfGanJeKzQ51+cv0EOedKA+3FV
         pxXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787680063; x=1788284863;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3nqK+uofot3qNgcx5OymPq89/mB6rANapa6yRWsX8aY=;
        b=QHO4WppaL58jWlhtCVRJtLEMZnRgAARtKFBXiw06DQSKTQ2RXs8lReb5ZWnrqIsWwL
         l6bdM7V8DvWujwOdGELi7R5YGaksCuyU+r4sya+O18KMFZiW/Hc2kR7EI7KWBgag1ivh
         f+6ZnJYa3jj6UVQUhukHhKOuagC8xQMZePYRTKinJOKvfptVAs/LVhgIzuLcQukLJnFi
         1iTgORiankSJ/bE2Wz8xiNdNUuOUGMiBQ/B8CMbvn9EyLfM7yNsAczgkPHEo3bUB4f5K
         9odSydka8sOTyYLrxCJL9W0YJQmRAR5sLEjXeBN1pR9bRDuhdYHGMrfiJVl/kbE5EG1W
         cZig==
X-Gm-Message-State: AFuF++n0DYB9U0c7VwN7BkMyEa3axDjdRs0iBecDctdPS6Z90yBOvpt1
	ZK4XQJJv6S7Y2PVU03sr2OQLjTW6zzkPfSZlgFowGmw/IL0BWF/d/t/s
X-Gm-Gg: AR+sD11cmWEYpnQqdMPSstXmM/FYuYP62EEJjovsVVpO4nKpo0orGm9i3+gBwUu1sUK
	EjZiJPjt+GS0M0E09FWFkI1h6Xq8jc4XI5tcIUrsONUUp5DqOTjGyG9hdEcN7XyWgVMJqQeaqF0
	4K8xlySAWqPD5s4oK87DzABJPLlKngexQoiqn9UzpW+DfLdZYqFz7+5Yb2zD0WP10YVD2aZiNqv
	9BMXy0LNmaFtFcE/5dyJdsY4wXge34w5PEPUPYKi1c+AETpBsQFyq2gNjV+pNpXlr9Q8JVleSy2
	fXnA3b+PSLBKpult7mI2L5KuTUF/vpv8mKzNRow7zdokrQnsQ2L0ZWzvYsr+98Nof2M9HQK4CyQ
	OJSApT42FQ6Ohh5cjX/EAQwvizG1VzlvRIeKTAxeigqoZXIUqapvAZ+g42jnfnK3y44ej69sMyb
	5/XiAsdft+J4CTCWKrYvHgQFvAT42MfcUv5cVpSfYSge8iyrAX8gng3gHBElBavXyP98li12JdK
	nHKJ1/zKbAwFLI=
X-Received: by 2002:a17:90a:a890:b0:396:4ce0:6400 with SMTP id 98e67ed59e1d1-3964ce067f1mr7649214a91.2.1787680063258;
        Tue, 25 Aug 2026 10:47:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141a8eedd13sm891969c88.1.2026.08.25.10.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 10:47:42 -0700 (PDT)
Message-ID: <45629d75-7a00-44e7-ac7e-68685f33bcbb@gmail.com>
Date: Tue, 25 Aug 2026 10:47:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/57] 5.10.267-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260825132541.342390421@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 06:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.267 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.267-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
