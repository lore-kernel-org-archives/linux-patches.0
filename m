Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D4335A388
	for <patches@lists.linux.dev>; Wed, 11 Mar 2026 20:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773262607; cv=none; b=FDxGuCJhSlmA30qtUuYt0pnjvoPi+FUYR+3RllsYVSeQe3FqUo3CyDLepPr1iZgOxku8GuFzzH3WowgYthFNQrVO0LSLpZVaK3BQc8Jp1xrYzZs6hNsMihF4pTuRR0lc6i6oPjhqPxwPWmvCBqFgxI9vl5McuuiVOGFzFuAeD88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773262607; c=relaxed/simple;
	bh=VmuFJsywnZ2FvwgxzQpHowTo/1hBL/VAqvQAEhTpf8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RidO8y3+erG4qCox3J/sqdT0HpdMyZ3zWypM29NvzFpVbj67+gxM7UpoQEEDrI7kWxlCjN26nSAsvPKMlrf6kFW31H9izTzo7yqhn4QjvNRXH0CPYAYfI9iLvXyctW3bb8CAI8qYyq0rYMf9NTyIxHR71FwMOYCvjoFN3JNTrI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eP4WA94B; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eP4WA94B"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d73dd9cb9bso262889a34.1
        for <patches@lists.linux.dev>; Wed, 11 Mar 2026 13:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1773262605; x=1773867405; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r6zraRIPOTU1vMM8Wp9rZ0NqOWIy40gGpO1AhV7AqD0=;
        b=eP4WA94BxNd5RkxhzPYf6nc5WSznbHF+wHziTcb6EExX3vs+yn1k8APTXaF8YrFfsw
         dXZ9xAiVigphlH4mI8AGZZGnSHSKMl80tjYh6BXBtrOL7X+xwNAsxwDp3p81qnAt9iau
         hjQooJ0j0M39xG0P9G+FD+qNoQLY/4Lx557dw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773262605; x=1773867405;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r6zraRIPOTU1vMM8Wp9rZ0NqOWIy40gGpO1AhV7AqD0=;
        b=oEmZOO4lCQsdz1llHQNqhiFEDuO01pOjTRMxGsaBw0B9X50oIYv0A5MxgtAKjtznho
         7uzVe5B6VblLLzsUuNQnNJT6b9NsQKvqBCTQbgSGJIv47Xogb8Q1Ei37rwu+RstC6QmY
         xQox381+IPLmpikW6lxtej3NJ2opb5uoYVnFar8vwceU0f2xk2lARVs+kqHYId0yyFho
         YgeKdQjz7Z5dYfKZk9TOyDdjRfXNsf6ihPIkdUIkLj8UnPxnEsdkioMg3rHPsBrzaYIw
         xznSUQdlYuQ8G/nh/5Y5VSxLHcoBkPg+4b84fgzcLri2eLFaHRkQGRcjg+6IWGUwHT6N
         MbTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWcd5YOVN8LYGhM1m8AJ/jAaGKOz15dbdG4MYMp71TMQC2O6aZMmG66l9v3rTkZUl+29+AwoYj@lists.linux.dev
X-Gm-Message-State: AOJu0YxbAz2CYG7eLalzC0+x7ymTauMqItImCKnQXhrcENlDwiZUKXRB
	s5af0+ybL42ujYmBgk/lwTjag3sKz8mak3KFVbuXwltyc5beJaTG1xpbc0PDezdmLrU=
X-Gm-Gg: ATEYQzx2KunkRq+2KOYZrf8SeZrgMqyxyBBUX8INVxQQCNGmijf3Ww20I2wY3p6IEzM
	EOK6SdlBGqIQGAof9kfBTycPlFXWwsOBu+FnzRIvrysMP2qlcXS4quVcAGUttZNfquVtIBpiLU8
	qRLDqNvYLZR/3hjVMnAEi36cYZMTH2en8+jZ27xH+4MK8BNedDP6fx6tWA31GkJ4DGElOAxerdf
	KUktMOD3BvgxfLM3GRurRrxu5MLPIgtiRJ9dAGEqqIgDzHdOeo4IaPf+S0HtFfwWfgtOns2MyW1
	dzy5VztJphhjZVLhOTnyMDtBu+33dhZWrzxj8Q2IFevORoLGvse/HdIHw+2FjNxnXHx3aWWx06S
	RTfOeoaBweEg13hRN8cYTjceEMhpTuJAytDZilt9Fh2DYWdEgiAuFPZqo2/GcbgUUbJykrqzmrS
	64Z1fgqWnzw17gYvlJ/oi5iez56lb6I84EVvY=
X-Received: by 2002:a05:6830:2682:b0:7bc:6cc3:a624 with SMTP id 46e09a7af769-7d76a7a5df9mr2517914a34.32.1773262605586;
        Wed, 11 Mar 2026 13:56:45 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76aee1ad9sm2663993a34.29.2026.03.11.13.56.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 13:56:45 -0700 (PDT)
Message-ID: <e4df551d-0667-40b1-9d47-48b1979773b2@linuxfoundation.org>
Date: Wed, 11 Mar 2026 14:56:43 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/314] 6.18.17-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <cover.1773141554.git.sashal@kernel.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/26 05:19, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.18.17 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu Mar 12 11:19:16 AM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/rawdiff/?id=linux-6.18.y&id2=v6.18.16
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
