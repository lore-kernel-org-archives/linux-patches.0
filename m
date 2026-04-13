Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F207E3624C4
	for <patches@lists.linux.dev>; Mon, 13 Apr 2026 19:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776108788; cv=none; b=Hi554xzuxvKQvnuWfHaGEHpPzEiZtnWuZwEbEZKCPTQd1j4wGXgdxJ/0EExILl2KYdt/e6NX82kD1s8pF9Ie/bpVf1nnnjndikG9coPI6NRBTcLmO7s4ol81ySo04ja5oV0aJjBc+u4kliJi87eLjpUDFB3eVRmnqskijABT1yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776108788; c=relaxed/simple;
	bh=dw6/S+pybKNs6YM+wHbLiB5CP9qlU7fUUzKnUQM/cak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lljk7O5+ShUfcoZXEejNnBcemK6/pZbDbKH40/L2MXsdhGLYew196jg7l4YRWNHip9C8DCAYQoNdnoiM0NwuvVsSHUywAyQnfOGSvNdpY3VPqSOuBEU18MLwyGYlMYqBnk5oSrPqHGxAzuNCdaaUa8UUJdQoeBVNpGFsWPaEETk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JoaxJZDC; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JoaxJZDC"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2d8ffdc31d0so2748914eec.0
        for <patches@lists.linux.dev>; Mon, 13 Apr 2026 12:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776108786; x=1776713586; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pB1WC5VZ3UmOcbYYu69pLbuIrjUmXkdAsvSHYdPWbyo=;
        b=JoaxJZDCA0xBY8VHbjjzCOFDwhTtxgr7dlL2gEy3XWf0H9vU1yyZ0CcUJ6wBGMkkKp
         2orhjUkiFFt4oeuyDGHPNLYEpAixBATyT23K71sRlNO7dhHV+lBVeK7DeHn3Vk0lF9MN
         M5NStvj114gJsN24ayOsjphq6QuQO0bQShzLib1oyO8dbLKakW1YfLvD+PF3vUfj98ps
         /xkZxCHl7cUR4omaHtluULVFMX5f/MIiREeNmNUJkXO8tOXhJJ/ljFD6AmKegU0qixRg
         IffqnurjzXEamDV7yGks2Ea7n5FJiiVHE0oZVndotR7f1YpvbAAqHoR9ugHUJfmxb0uF
         U/3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776108786; x=1776713586;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pB1WC5VZ3UmOcbYYu69pLbuIrjUmXkdAsvSHYdPWbyo=;
        b=Xa/pl/ZgVZlAhF+BA/6WNjSiqx+V9qkaucWPAv/wh73/JM5fgQmkfGdxh1uMZtuOm4
         px6v+W5pSA9GASsglwT0AoszxS51SXw1QekQPTEuMbUbdAQsqZEOm8kbRF65TIEX0adL
         qYUmKcwXBKd/s83vFqrwTlNDUYwhJXepxMtZMcWo23783a1Y84Qn46/zF9RG/qBtg7cY
         dveozZPjNob8O+xRi4wPnVdxbsMS0Yp4XxcEXvuDKCUAcBhgADbg2kKr2/0gUzMII5Cn
         xq6JHYrAbfXvgpnFHYJhftv4wRx1qy0Mo8OJxu9pbDtj3nnhENfkwpAUewoCjdh3gB5i
         C26g==
X-Gm-Message-State: AOJu0YxzHRQD7JaMkzzHGEJYUOnbHA8KclHq+CpY477HsYMdSy82v/zw
	sS04itEx1qoTLNXPLKiQmjX+mlSTgS9MUyBeL8tx7JwftlKfG7kX7Vsr
X-Gm-Gg: AeBDieuBF3shc+1BfRnZsigSjt7BRBF5oIK9HC4IimGFrPZu/UqOFwD6iAqrmPbeLwn
	zzHuPjotLDf+Q8hSj9G00ApiRjPhVuVW+VgYvrxmnYmrjk4DxDMAqsRdYQJehjw8gA7QGcVp9im
	neTmoBR7dBgEVo7MPaGU/LhG+IdpbUvBUla0A7+8rKTmbRiOT7f2KRhQJSUF0QtTDB88jlxqrUA
	1kY0vEe33UZtCAqy1LU72Asz9rt3jnKoRhtbveBpMENToVYY2CkGY2s2Nv68/1FsQChuHR5mmzu
	UmUZqJMF9BATABRiX3iS7vCJQu0LH/IhQ9e44nH+bfHLPBYSs0PIjoc9bfayH30Nv4q2BUQ24vO
	NctIr8Jjt/SMrGIugwsCmfELF+7kPpohYVJqZKiLIrFYvzMdkNCb07I+DjQTNzsVFpXQe8k++Qs
	XihmJEDSvuFJdQgiIyWQjJUbV6kmpjGn96sI0CB+i18cT0BGZ6Dg==
X-Received: by 2002:a05:7301:4586:b0:2c5:220c:5673 with SMTP id 5a478bee46e88-2d586380bf9mr7664988eec.5.1776108786075;
        Mon, 13 Apr 2026 12:33:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d561cd2c09sm20692000eec.18.2026.04.13.12.33.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2026 12:33:05 -0700 (PDT)
Message-ID: <711b65c4-d030-4ec4-8248-99b8b979ad3e@gmail.com>
Date: Mon, 13 Apr 2026 12:33:03 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/83] 6.18.23-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260413155731.019638460@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 08:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.23 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.23-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
