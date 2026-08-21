Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55F5429016
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 14:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787323830; cv=none; b=eNAcYi8cbSsRmg7mjJfkAWmbnzF4Bjq7ou+Zvyy4gNqbx1oeB0fIEkp4HqPWDq1GWx0uaQFYgL1fwaZIfmLOdMCDjkyaLd17oi9NPaw8IzPqK3y4sBJ6wIdSgb6iG9B3ZYNyOxQwkO576FEn/6T+aai3dyQCSCA4lZ7f8T/1mwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787323830; c=relaxed/simple;
	bh=V5y9o7NMk30ephKJdJV+5n9ytvSBXHDxANwEOdnD+vA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gXhmS/qLKfRbpZiOZ5SsE1g60HnNKAOhDsc1Fy6KJKrAK2wI13FmuADUpMGWJrZW2Lyf/7yiIc1KSCqSVM6BagkkcOkFYJk9PjHihfmJX41U0TiN1tMEf20/1NfUOGU+hrdk/NE7b3ekG75uuHl0nPn5d8ztdKxhWeJOiO4OyjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBu0+E/n; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBu0+E/n"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7f0167e59a3so841918a34.0
        for <patches@lists.linux.dev>; Fri, 21 Aug 2026 07:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787323826; x=1787928626; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I32wmWttHHzW4Q6gfxtgpGyjxKkIWFyf2W71REhQGbs=;
        b=SBu0+E/n43whm497H07jwNh8/gpxjkJ+HTD6fbnhAZeY+EwmSVPvxi2krp0/fszNmW
         0hYOq3puor8hqJOXeyJdbB84PYlsSszTP6VvwKFeDl6wazx6wSs9xnVNVJev9qvx+kiB
         Ei37tpgNwfk7HucRNvngT0paOyy+cbHcqBcZk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787323826; x=1787928626;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I32wmWttHHzW4Q6gfxtgpGyjxKkIWFyf2W71REhQGbs=;
        b=D2rb0EjrZ06RTlwPgciIhj3yHVqGV0IGBBbacYAQK7y5AaUsu8b9+q/rpOnu4xLRmE
         Yh0KzOwdNUXWb7keKWQG1sZuaZ6UKdjY59tsP09I9BPDbHlY3YKcKgW6c4PMi0HHj2hJ
         2q1p5NxW1xmtAOgITzh8C/FDus8geb36iYOApc8pfcBKwBMPcZ2TjWpYufsRelJ2piQ9
         NAEz7XZ7Wpwi8akmmnZVoBeZ0Ht8D9AuXvLWGmfzk4B5OcaWG8yvRYx+159plHMC/owQ
         jT+tAapt9IArh5odmYwPFvDGF8hqSnaJ9+nxQdpMRk0r7JNthDEFrXt2yp8k7h2QR7Im
         CLmw==
X-Gm-Message-State: AOJu0YwZ/DHiqZEgn/ibj9tJCmMUSoq4KhTq+Tfq2gstAwH7FQRyKHGq
	UTeVydhDkL5/j/zmr+3RUU3AEPfHTudABzIxpAnXsTdnYLSFnORsWfyWFSp9Hfjmp5w=
X-Gm-Gg: AR+sD13H6tk31QnxbkkKuvYoCzpgDTZW8ytUrRkYHCZUw9FE/VtWOzMv9SRafUL6bz3
	xns+jQBcq6iZcy2ulMAukSFWSi9bDpjmVAu6jS5m1wabmehJK2FgzojKfN3xf3zd8HS38lU6M/q
	AX035QN8hwmTet0rJYRL0u4ZshyEb9sHMH/71RJnEjYM8h4j+MM0YvAcfvtTZspLiVq0T+rpwfn
	aXTP1k9ygkXs9HmRk7anudS1t8bgiKLb2fJaSfpt9ecytxVyGqOwSSRelgfK9Ca8/+ExWYJCpf1
	u3nT7N4f4LNG8DwEcTv448z08E9r2d7owfvaEbhVMGFLaLtz9/0EGRuwf3MLBGpdf2jNA/SkohZ
	kiF50spOTy4WMUOarFqxdPiQUphB7o2z2LfOg9SRM5bt310g+4JsRMdNa50IYfPpDzXdWszgaGi
	vzPyFVjXOGrKmTW3/G1HVeZXlsZRp1hdfW3ieJCRqAhs+9WgZuT62A+r8PLPzc1d4gFNAIx117n
	SDMjuCi
X-Received: by 2002:a05:6820:a511:10b0:6b1:4250:6a43 with SMTP id 006d021491bc7-6b159411a9bmr5136915eaf.17.1787323826434;
        Fri, 21 Aug 2026 07:50:26 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b13cb557c1sm8758083eaf.2.2026.08.21.07.50.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 07:50:25 -0700 (PDT)
Message-ID: <86155abc-5a4c-4f48-b49c-54d7f005089b@linuxfoundation.org>
Date: Fri, 21 Aug 2026 08:50:22 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/228] 7.1.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 08:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.10 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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
