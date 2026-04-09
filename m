Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881622AD25
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 18:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775757653; cv=none; b=Sx7RPvGrm23ql5Qvzy/AbVDta05yUys4382SwceV7XY586mEEMNuiBly+G1qQc5loOmQjFyUjCG+a3bQIxs/0m8Q2TcuE0oBwKcqwZb4+1TEqOSc+UJCit/ESjCaganVJdPpEnkGSo8AhYV7utB29DVEMcl9m9X+prYJpmxsrDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775757653; c=relaxed/simple;
	bh=tLzuZ5f+4AF2L3/trodKxUni6co4Z6wzcj7FwL4YsCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rk6rrykMJuoUj4LuIAv0sxFEGYnOAZtqZCcZ+U2oI6T5qbTWvJDbA5PfoBhJqQnYIFg/A5fO/R4yFSVPeYiDmT/FmcsNPA2Txo5q12KLGTmjPGSSOvs/Jg1vYqbCpfICAS5LRf+BeJk1bpKZTwW1q1LzYwDLendWR3eVSLKyarc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BkxtzNC4; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkxtzNC4"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-4704fb0d5b8so778381b6e.0
        for <patches@lists.linux.dev>; Thu, 09 Apr 2026 11:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1775757651; x=1776362451; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rbEBQGcCqoeU9ugfJ6Hl1O8LrF3MTW9Tl2J0oWaCucY=;
        b=BkxtzNC48fwfd2i+P9aFd5b2KYElesEzwqryXAl9+cMbCuyEfKu6PYSuZ9PGka1+cq
         +UtLlpC8rR/VyPtLtSyx/j61dlmBd1RVCzjY09NjwOuKn+4+PtHc6+yUZoVjy13JU+4u
         CebCd1aP1vGUZIqzqnQteslvQ9wOqZpeUlo/Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775757651; x=1776362451;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rbEBQGcCqoeU9ugfJ6Hl1O8LrF3MTW9Tl2J0oWaCucY=;
        b=PGI4skZ4DTSwdA6p7aruVQnVfmU8WaewaLJRvuYdhVpWqZEo1q9aFB14dZr3S5h8Cj
         NPWKS0miJbcsUsYCXRWI3qM1GurNJ5rxHerVJ2WpUGgDUwREg9w1RoUSLUih3gBMMn33
         B2CilwcBacIfyEIogUl/eFeiVG2IB911ibDp6iZt4NuZgZrqbzPcaA36WaWphVKORwEV
         Ux9X51VMZ9vgYrVaGO4FQpgPxAe1lahFr8yDI/AlqtHUbcxYLGnmOic+AUSqJtIU/W4Q
         hrY1VJFfhysnt/fweEYtIg+S/bkyo7D/hZfC8sZQ2IuAspSI6NmXSq2Kn6aHgGlrZs9R
         688w==
X-Gm-Message-State: AOJu0YwFNJ3hCEsw7GkzrErw3ZYLp78prn5ySYtgfgFyXhYC6htkIFHH
	gyC+yp3CU7YHipIWplVsbhgL+bcEjdTrtjpKsIbe3/AxrQbpNKbZNCsFLQnnpwLLXdY=
X-Gm-Gg: AeBDievUkpXvhZI0tfIHPdZlbz1kYK7AlWomoWoUv643WT61l5JmoKLZBUrUUuVbXo6
	PMhMl/Xq64ZRSddlPcLWHilpMvRk1V+w5/DOCN53BvrtAe7JFou/QHEW/dqxrrnzyoXTk6IRhpj
	XdPSxISRYV0ww1RIJWlHqhdrqHJbdCQiv8dKNTGtgqMGRLihYldP4dvYVX8tExAiNhD04fomO9t
	VOIgQbQDDDqURhKeGH+o16wy5QBfahrq/7gJb4c+vqq6VCcHtpdhvSEhk0vch7NZeWTiK7yNFim
	zYsx4P8Gq694br9DiRiEDKLGuXaAfm9A++C1fkvis2sLHovIBlXW6J8JcAwUjeAItSczxA/svRj
	hpNahpvttghGVRbLdOpyc+NZXaE5y7ioWWTiTe+sQPG9B4Fh6qHeCv7ielZ9OtQAbEKFihT6Lph
	qVnJxMnGfG7acXeazHMAjJkOqZM2w/G31iJAQ=
X-Received: by 2002:a05:6808:c1a9:b0:453:58dc:c006 with SMTP id 5614622812f47-4772a863c6dmr1962631b6e.3.1775757651321;
        Thu, 09 Apr 2026 11:00:51 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-478a3a72f6bsm50044b6e.17.2026.04.09.11.00.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 11:00:50 -0700 (PDT)
Message-ID: <91e440e7-620a-4166-8453-a8195b8c4913@linuxfoundation.org>
Date: Thu, 9 Apr 2026 12:00:49 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/160] 6.6.134-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/26 12:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.134 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.134-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
