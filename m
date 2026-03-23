Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BD33E2753
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 20:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774298303; cv=none; b=Ob/gwV9yqVV9ok+7eppdG7RWc/uatuR351K4ipSTdpV4wAWOgmG1qWRo7O7MjM/tO/Y2OorD/B03S+Zg5eEbSzROhvR/yd6gtZ40lLsNR/0zY2sPxQc4EhNSrcg+07+9ceB9dItQdIaYoYZM15XLP5joxz2N4rmltjuUNfLRyEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774298303; c=relaxed/simple;
	bh=bmp/yOgzmdlRU6okEZtkVNgZl7QYHRiAPp8uQ7GZZAc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MAJ5ISyKkN2fmxeCBOmfosSMQg0BATfzrVv8Vm3xpGhLq+daHjDADILnb5JlxmhpPCBIKTl6zjy7bioDyeT1IT/5iDmlrGE5QjBKyZjKLXRFlKDCJ4FTiNZi2NcIm6nj1PxHXX0Q9AVvoYYXW0LwWHPGnj/JHlpA7AzelugbTqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O1YCbUl8; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O1YCbUl8"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50b268fba9aso4754521cf.3
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 13:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774298297; x=1774903097; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8s7Or+WfsmbZ1yFXmrGEyc1Xjx9iH+BN4idldBQ5KMg=;
        b=O1YCbUl8lOk305AC2xOtseZG6VKu8Ghp4yQkPRadegyF+0UDP7nOGRDnY0u4YpuWnV
         5kiB22QvGK+wBMsYxK7I++MqyXgrhzY/Oerz9ssCWh8JOdLufyF0/pERLY7/HboM4AH5
         LrOfsQZm0SU+uZ5g0cH3NbIi3ldPrvI4eMeu4CeYdgyrx5LZAW3SKIp0ueE19aN0PRn5
         /iCejCyVnRD7aEv54poZH8eWMwuGYyllz3LSXiwQtvCYlZsUxki6K+Ss3VFH8IilhBRf
         4rpnTYMqQLIEKZWWEx4inoHHyF2yLy437adgfVbn+NZyaivdjYTroCLkf4/Ce1C1LXOQ
         HHYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774298297; x=1774903097;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8s7Or+WfsmbZ1yFXmrGEyc1Xjx9iH+BN4idldBQ5KMg=;
        b=VdCiwzJIiNqcZ0StGkuDufLbQwTq1nwjFsljaOhlTwGH4BZYtkAZJGn80ssatL8KXP
         7sKz6eg8JS5t6L/ZeCPDTC/8z4+hmua0Lkujrk/RLyRA+n4RiR9ZQSNX54ggFrZprogb
         lu2HTSulqn7Qn7at7jRd4Ek9qWM52UlTtEpD6KtiaQWa4kOyKc6gPwdao19MZAt5vNYI
         iq5pIVl8hg81WKbZYZqvHbotMRzFUo4HrJVQHJ0vmMZjViamFGxqH2YIYMIQAGL3grY5
         GH1kKAeCETvStGv165ZQFysSda2cyJPov0xcff6sPnmVcrtXRL3xsfOBaAcoOfpPJXzw
         G/eQ==
X-Gm-Message-State: AOJu0Yy3VkqVVRzwLUwL3eVQbNDBXqdblpa7KvY0vk+5USRZ4Je8nqOs
	OnPyQPs6aiWdcVP+464swDREGJkgBVq3/5wtwbWcIfxgccPeHji6Aw4i
X-Gm-Gg: ATEYQzy9arPBV3L8vqtFHp+/pQZb8Ij0gW0gUN9fbnmir+UHRnxRzQ4aII34ivA8aro
	fPtScmZyc7fieCPvWYwnpHkCzSsawjg7yAE0RAZnhw3ZmZr06efMtH1nLxvdgdlhVo6HIlzb7UD
	SryamjxlSqdtcxvE9yzJbbGDRmPtLQ4zCyM+evaSNuwWW4A94dfg3Xgw+mhnv4FOviwItPkNR4Q
	xFhFT4oUkKSSgf01A7JIfch8TiAJHJCscRfFEeWpV014cj+pOCohKnSZ4LBK7/jobKiOiiB6evU
	JgpHLGxL9DrsP8sAZZFBpRa4TU7szkzNv4sp+Uv194CLMXpUrxrawQe2hf4UvXMAz4EkEgVcXAs
	gbQWCl4GEXRo4AMTzQY5Znrgo7cOxxGRqMJ5r9RwytO60IjkiY2yHmCu/5NbZmpb266P5mGcEbn
	Yg4e6F8ca2UO2u9IvC1i3eZfWY6L7WXyyu2dcQRHSBD8z9pRDvdA==
X-Received: by 2002:a05:622a:9d8:10b0:50b:29a6:8696 with SMTP id d75a77b69052e-50b373a1b75mr153981631cf.7.1774298297316;
        Mon, 23 Mar 2026 13:38:17 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b36d0671csm94143701cf.10.2026.03.23.13.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 13:38:16 -0700 (PDT)
Message-ID: <4cacde08-9d71-4f74-98c7-cf269ed91504@gmail.com>
Date: Mon, 23 Mar 2026 13:38:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/460] 6.12.78-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260323134526.647552166@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/26 06:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.78 release.
> There are 460 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.78-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
