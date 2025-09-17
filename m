Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AE2284686
	for <patches@lists.linux.dev>; Wed, 17 Sep 2025 23:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758153215; cv=none; b=fx9ux1SlI1eBFLlefM7Z61Np7XWv1OCEhpyDMh28xzo1eXrdd2/+Bc2FNmrQNMbK4YilKR89Tui6BVhRdp1kx1DU47Az+Be42XIbOe3AmEn6MYUMd+o+6OCfiBIZVjINwbQyH+pIO0S5yCrnZcGROwtsgPPKeE0mBNO51/cJUZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758153215; c=relaxed/simple;
	bh=zHXhaxfq8txSsNL6FuywZq3TbSULGj8UT+faA8DSrqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fAFsx5D1GQamWAQyKm364YMszYaTGyxVfIU6teZhrvG6udOOJL7BRO6Mev/Uu1/zB/Hz26051I82hgjotqbawC5qOqgJUWewkYI8HzLfc4ltr0i3pGUVGd9p19ud6Tr/ix6+r/Jbcy4wI/L1zjYr7OfNZvzNSHxgtS1yju74AYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=U4XjoJR6; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="U4XjoJR6"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45f29e5e89bso2919065e9.2
        for <patches@lists.linux.dev>; Wed, 17 Sep 2025 16:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1758153212; x=1758758012; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fH3dCOcwPC522SUE8y5HpvFj5uDFCkjUJfHRR81NqUI=;
        b=U4XjoJR6HGKJt+GR5fT2sXFQptrp/v6vbSc6CDD41hrNE10Y7kxbcYa+hW51l2Nlxr
         JXq0kd0cnvSSNgBzxx9p+ri4eYxn0tKgVk0Rfzbr5Joc6ivYCF9iDo0FBLXpGiLtMOZ2
         jYSuXra1wjj85IlvWoq+04GThOuWC1FrzuS0JXNvJ0yE/QnErEs4GoGjrd+cl+qNSydz
         oy7Oj+dZIEBEVnT/U8CoY5UrEqKvTrYG2Ln9BCQbxA+cFMwNh4s3A5Ju1yMoy3hskbqj
         3raVAo2Z7zeL/iWhHtPOZb35gZmoXXTqaZVZ/aHUw14coJCK7+LgIbJHnsUuNg//ulzY
         V9/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758153212; x=1758758012;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fH3dCOcwPC522SUE8y5HpvFj5uDFCkjUJfHRR81NqUI=;
        b=SZcQYBClzY9UmWuztSBvJiblvpqZzATiEMxu7HCKY7kybKy5PHdFn2F6OrMnTaDvzp
         h8ikqvvX6ZxXQa9I/L+cZ7Y9acPLjk2Rb2bPn8i8FhzfT3v7pynkuXBEYCSL1V8/9EjX
         tcIeDGvkB/hrDAA9REGM7AD2fl3FCz6Q5VqUlpLoNmTZdwJ2GKZlCMhmCCoT3Sdw7Lf3
         eLZY6e2f4C6RDuYDq6+zHrJk+muWLr4v+8nKze984QbYJjRCL9WZrp1UGLPDUkchCsPr
         ecgiiKrm2ShblsjaOdpuHoQT6y2ZPEbc0o6j1OIJpykfu1DgpRshYIpMlyr6kiibfTIF
         +aTA==
X-Gm-Message-State: AOJu0YzDod8orZfvpkWNy9fphbcUlhT2jmLX7QXlcK4LDmbW5E/qOztm
	T9AFerObhwZP2sHu3iTAUNOPQB4g/YRgFexollm6Pda7ck/Rn0fAv0c=
X-Gm-Gg: ASbGncuYWxcfLZb78TgF8R8DeuO5Z1xgRYUE3pj/DpCO5r0wHoAIr7KKC8jghOahWo5
	HGzBoFMrk778kbAyhTTAaPMwUQcVbIKZlFozZ3W7dN7PE4+odfjRtLjEibhzuUXpROw8xxZvY5x
	ubB4hesed63JkwjIta4Pay6RwSGGlwbTDThrk4RxdsJRKSd3aGl9TQ5zEm2hzIeu4mOHKLFwbzs
	a+12Zw51+qOfiyiZ5S/XeTkUhfZpJx4PCxae5xD+xq4tPr3NffOStUR80HP8RgaWvl92GmE2JyV
	COk1dO5aID8S9S9nyTisRopiShiOYi/KDpqyx0JhrC96fHwcZSjJCISakWY8+Kw5vt1K3itCqYp
	uIJaxsSTd0VubyzRlDfrBqWFvxK2QulQhH21Z4zpCDEDZtioq1oBF+wipLa8BKJmJ2g6CHwznf1
	zJdRjvmepyweFq+eLtqw==
X-Google-Smtp-Source: AGHT+IGHl+QODOErTNJaVKR/wtb9/LJeotK+VcYJyj3xSaimjfMW6asZkiXk10lZ2ZIxdq/EFGb6JA==
X-Received: by 2002:a05:600c:3511:b0:458:a7b5:9f6c with SMTP id 5b1f17b1804b1-46202bf80d5mr37445935e9.11.1758153211721;
        Wed, 17 Sep 2025 16:53:31 -0700 (PDT)
Received: from [192.168.1.3] (p5b2aca14.dip0.t-ipconnect.de. [91.42.202.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4613e849a41sm55028755e9.20.2025.09.17.16.53.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 16:53:31 -0700 (PDT)
Message-ID: <e5ec3508-6c54-4f52-80f9-1fc4b04755e0@googlemail.com>
Date: Thu, 18 Sep 2025 01:53:30 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/78] 6.1.153-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250917123329.576087662@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.09.2025 um 14:34 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.153 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
