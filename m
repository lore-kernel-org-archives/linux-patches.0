Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613FD176AA1
	for <patches@lists.linux.dev>; Fri, 12 Jul 2024 17:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803981; cv=none; b=DKVXAQ+DOcNOYTznKahmzp81ubuLn4Dd/a5q22+fLK6SJw/ZGxJQT48rZ4QRnJy8PK0b9N1OrVGAqDhbBDF3ciiPR39IRUbQ0kQ8QmdiU0Y3CwCf4Hm2LFJwS+MybE12XXRXdWi/Dh11gfqLdf1hJJcMFrYwyFazF9iavZK+d4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803981; c=relaxed/simple;
	bh=g4HosscmGTGzLql1pINXl2ryFOeiOcS0JD/J8utFiG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uATsTtzTnWCHWJuB5zYdICJNGmqDy1Axjx6dotDaxAxcgZ3k7sNEpUkAaU6JE/Nq7LEU4xNMHWFAfXzDCr+8b5PNqatN6KvASOND3DG8+WP+6MB7qmkex4ZHsuM/WK/3gTvsR5Pn7TqDEomesgaU1s8gfF/rBrlsZm7M+52PGGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NgxQWoLh; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NgxQWoLh"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-70b1207bc22so1969853b3a.3
        for <patches@lists.linux.dev>; Fri, 12 Jul 2024 10:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720803978; x=1721408778; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RXBbNRNVh7Jf3s8Zs2bOIxvS1kfw/H6qMUrvf21hgkM=;
        b=NgxQWoLhNOA6FGggy/m3HELGH4L7iUXKnSV619uNrn/VhEtF9n48TE8hb/PEdlVmI/
         KXrfHluhgkjRaev9/+LQ2+AazPexoMir0X6aH5rTDasx52ZwPE30xyqwHuO86by+3H7w
         c+yFWJryDV80PZFpDcx8FchokMln6TH5kmYa2y5xnxZRz5A3BMgw4SoYoVc94YtKAerk
         decb4HYmXdOwC9gtlWaHJMy4HQcXPYgmQQFZohnwG7YREK6bTqe4+dGYf5MSF/OOk06h
         e8gotthenXstNRa3Gwd5QyX/+ghDno5fC0cQAfvabQdZZdjy8B9e9Q5EvavED2Kq7Oa9
         kU/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803978; x=1721408778;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RXBbNRNVh7Jf3s8Zs2bOIxvS1kfw/H6qMUrvf21hgkM=;
        b=a2E6G4RQerFegRSnsiDuml7snBNi78l44IA2+2B1B7hn/YRmLEXZ9A+LY53O54q/47
         zJcyzUfQwmSvySZbGKARuCaQoX2Vcl6I9Ry6ST1WYJ6AHFTiDAkz/R3qiy/eZuwIUmpp
         FxefYcuVdf+9hUqwvuwhgu+ZozlgMYGyn2QjPDbG233DRa60k7nNFem97wZfKcXb7NdD
         TPrR/Gi0J//pEMx8isbsbJ/O+O02MtZxZA0T62IbLWloEG0Hw6yVM+VEedmd4dPaGtYA
         sXaznZAsLtsFeu/M02Hm4LeryG3cdxI/1Q868ond/TUl7Edz8F/W1AL9BgCcuqC413li
         +Mig==
X-Gm-Message-State: AOJu0YxR6V+DnNZ4ZEObXCSsUE3c+6nZWnGANvKDfXEwEmM7x7zel958
	g5w5ToToMFHcGD6EaXBH2O5D0n09kmH8DBxFrsK6TJXyGCNh6yon
X-Google-Smtp-Source: AGHT+IHnbDShKr97eQTu93Ri/R0ihvF9+DxpM+vu/Mjzng4jauBBUJJj1nBUn1qCkVTWy4PIz+SS9A==
X-Received: by 2002:a05:6a00:3e21:b0:70a:f40e:f2c7 with SMTP id d2e1a72fcca58-70b435e7aa4mr14970162b3a.24.1720803977591;
        Fri, 12 Jul 2024 10:06:17 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-70b4398039csm7720181b3a.154.2024.07.12.10.06.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:06:16 -0700 (PDT)
Message-ID: <6f42557f-9c13-4c31-978d-3a7385456e02@gmail.com>
Date: Fri, 12 Jul 2024 10:05:52 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/102] 6.1.98-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240709110651.353707001@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/24 04:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.98 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.98-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

