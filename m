Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3326726CE21
	for <patches@lists.linux.dev>; Sat,  5 Jul 2025 03:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751684715; cv=none; b=Sk6T3XdF2qDn46H9fNXJGQ76Vn97+MbDyLWXhOirzE3rOJesw5S8aRUzbSPx2Tm04anKG6hdYSZx0xoNrGH2JP/qOipZngLRJtJl90IFMR/it1ZwEfkNhrV17ODcc8rb0QGPhBz7zUCMGWVu79kIpHBrVB3n6F4pC+7ZPDb5U24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751684715; c=relaxed/simple;
	bh=Vlx2GvFm40wboNWyllqdf8cY0wBZ7D+Hm+a57/azXbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZK+uOSDK3LBx00HWX47vLA96GHkRXZwEoTsrqRuMj8kZb2/kfl/SO7M6iS6EkVvrTs1PR3Lslv36v5Rhfw1oZTL4XA9q121m7ek9xZHjlVp8xoTphqy2z8ZL4hBYBhzdGpyPLjATWlYY6YItTn2zb6/H15mbIlybZIxiPs4L3IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=TOa82hem; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="TOa82hem"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4535fbe0299so7614945e9.3
        for <patches@lists.linux.dev>; Fri, 04 Jul 2025 20:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1751684712; x=1752289512; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vqDgb6K91dMFZj8xNFjdBXiilDAaERulOXneKfNxeww=;
        b=TOa82hemAKNkGFdsLW5gEm0RY151M9EaM9NC0Xfv4phrYzCGh//hgtrS5xDwqIzMCr
         a7+YD3iQs9tO/HML2nVcOIUlWkRHUDgKjDG4MjpJLk2YG6LHSEqvB+VKN/BTr6IvYmWl
         hMSU4PXuqvitfdxum1DrylW+cziimW+MRaPEGIMwVWYBhqbzzkFAZpHE6KJEUN2hqSWr
         dWba/SxtyscSYYh6zry5r0Xd9GILiTwFMsZv9Qvauc7ulyfldGz2i3Anjdb1O0F7JYw0
         cPNrJkZnRQVpO4rpEwp4WmCV3Q8X4FbdqKpbs01NITAWqxb31IzbO6D5VLxyoHwb8+jY
         lJkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751684712; x=1752289512;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vqDgb6K91dMFZj8xNFjdBXiilDAaERulOXneKfNxeww=;
        b=EoKL2/23/szc1w6hdl7MilMBsrz1S11DYmFGZuNpbUQ9tBG2PvHa6dPw8rHEAo3YxI
         Ie5M2DkeRwJbfehVADSRHEV4kdB2T39nB0B+XMr9isBqfrLWvwNaDf7nKBRjRlIEwsaW
         T/z9WVDqWe6L93HWZmBDy/S7iap6CaixPybC3oEvylC7K79d/ZvtJ5mXhNG2XJP3YoZw
         fobODpj3NeVViPtBaJXjvBw6xtvGlQoDJdC0cIU0+niJgzlZDd4BNSEnaZGZSgvKLgtE
         k85lUoYhhlfNjkPti6OyDAaQSoVmak7jvgx81wi3CnJx+ToaWrgDwlrscithEbHPgW25
         iMLQ==
X-Gm-Message-State: AOJu0YzcZ0bMGy/m6/a0tiduLB+dyWghvJ94/xoAc00iJyi9FD65rcA8
	8SMzEpCsqjL64IA7WdJBs3HdHr3EqxTUpyk2E+80qB4UMEyEnGruyNk=
X-Gm-Gg: ASbGncuoj/NbZutUUyJJ6VuVpLGgYIMK6yaavul60Off9Mdci+e0oEWbTHLBFi2ky7n
	lI6sHIiKdiZfhdUMe4ro8j+oRCIqfPF7JjBvHp+WFIRZjJoRG35VK0+z+qRgfVtgbjrDMnNRkzc
	Q+Fu7SiP/AJ0r7UiTS2sVdOAY/ly75F1xntYYpvLmbaf5H/sbQWc77GHMsZHG9XpQZfWDkceg1e
	zlgTB8Ge/pQwKI+yWBPugvK90NkHB6mqV/vG2iXiJQyX/L/U2/DQdafWUHe7YOMAOUlHtHuuOX/
	efDUzv8qVgh8lSyqirtGT8SiSkIpwoyCzBdvEErR0hP9nDMeatY2CFdaAmkJ9l84fM93npeuEU5
	6JvEM57En070wpdUKFxfVwoQNTaL3rqf+qdanlbw=
X-Google-Smtp-Source: AGHT+IFQud81K4EZdzm02dUULvNS2awoAwpf6hPFkMhnS2aLLE0I4C3SRdmCGLLVYb8WkdHV/QxdyA==
X-Received: by 2002:a05:600c:3b01:b0:442:dc6f:2f11 with SMTP id 5b1f17b1804b1-454b3169103mr42806675e9.25.1751684712260;
        Fri, 04 Jul 2025 20:05:12 -0700 (PDT)
Received: from [192.168.1.3] (p5b0570c7.dip0.t-ipconnect.de. [91.5.112.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b47225a6fasm3828039f8f.81.2025.07.04.20.05.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jul 2025 20:05:11 -0700 (PDT)
Message-ID: <62e3fd86-f640-4d67-950c-791674cea5e2@googlemail.com>
Date: Sat, 5 Jul 2025 05:05:10 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/218] 6.12.36-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250703143955.956569535@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.07.2025 um 16:39 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.36 release.
> There are 218 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
