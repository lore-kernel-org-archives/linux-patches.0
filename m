Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FD42C21C4
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 00:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774312278; cv=none; b=U/rJFeNK8jMoVf7/6PCp6uFGtjSKjBpNoOkaRI+P81KXu8mF1sSQTwVSS71dhWLcGBTjBltCLgsSrGO0JpiFaOm82qhKFW6Mmt478KAcFpsYSnApifyR9EsURUhUl2JD5gJO1pY7FaO/1brDaCFs4z04bfiI3d/KJ5gEbiAq7DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774312278; c=relaxed/simple;
	bh=wwQLVG4nvC6FHNwJr9P6Q+Xe4txLKqLxx8xKzuJUngo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lr77FiipOpK88LWwrcQmT0EIM/V8jFd/rA5p5TgK4zCe1iFFDVI43bIsSS6uZ4dW7VgDoZqCIlqsm4ec09ZNrrIBpBfHSQWqsSgI8VFkuB5t6LQhxaYuKjqieIMFneMwo9AW8yNIa7qkiKl2ngqHMvewQO/qXqC/xqSSZQq7z9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=HBh+1auA; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="HBh+1auA"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-89a6ac6f389so7725126d6.3
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 17:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1774312275; x=1774917075; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4Zbz4JdRsqTk2Sz0npweFJlvHhK/vxWGjvrdbhc1wjU=;
        b=HBh+1auAmkBY2cwQkpmckZX6oKPPKCQ1e/HpXO477fEqhkMQsJyd12afTgJHhWo3P6
         H8z/ythxAX4uxWpl8OejU/BeRJRNQWRBx+mRxRuIZK5/xSJZsArNVXlc8lEMqDG96qfg
         bhYg+/skOln8DRMhPR8X94WlBs3HPsshOZf+O5BNjKZxfuIVlHQ8MYDIQslbLwMuPnKI
         B0OKHS86WZejP7Xcbj5qhPP1eZ0aZMSVkXlRZ3ajlD5WtrCYZKJOZ3PLTfF6BkxmJTh6
         2ViVLxTKt1/5zXf+VV+kZ8Y+s4MGXSXAwwjHL9F+DsDmSjnsR8IDidT9LxQmsoFikU0z
         rSPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774312275; x=1774917075;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Zbz4JdRsqTk2Sz0npweFJlvHhK/vxWGjvrdbhc1wjU=;
        b=LWXHTL51AsOFGOrZeQSes6yALqE1VyRGYKKR2tuWYXXryjDf078HT9ysryDj6SBDna
         Kbk/nSaZ49Sv5nVSkFZb/ys6N3YHq9os8viXCEkUSCD0f7UG5oq5SN80jsfwcj31OM+S
         e7SaICa7O6TxQ9PqNAX8nOrfuR2Ol+ibd3H5OssXrgPAzECQrkm8xgtsDHZzNxC5yV6n
         nElUqjaY8Jsoz+F7LOj8eWMl8fSnuis+b7TSnaSVXcL3D/m6MwSrsDyjLNIQaKxesk2l
         KHZLJzKJ9Jh9A3jS+b2w8YQT+gf7favyHJyH3bvCwK9kKGMCG2RmZbnHXIMITDyQ5PIV
         zoKw==
X-Forwarded-Encrypted: i=1; AJvYcCUm1fa4imfL5cxRHFJdHupfQ69mI9uH443DhiHg7YwzUDnS3vF77FsRalX4w2+3sBr4si0y2bON@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/ic3daalImGulLM/Spn3H8hFCcD15oTXvgSpdAe8juYc6WOoc
	tu33LdkQHkfwSCKe39lGz6zMhPHU7Dbth2eeBccsVVKHcBS2NmhM57vYQrkq9s1kfDU7E9ooWoK
	2ZN0gKuP7dn7/8YR8Ql/z6ivTLorfWsbQ9g3G+fqxsiS7TfW/2ryMRw==
X-Gm-Gg: ATEYQzwUGTuuCd25uE7EACaaexumwcRROgEpYoJtkFIB9pcKWN0JK7WS4JSfhgKyGoQ
	NhTRxGPD0cm953bvGx/iMYUsQ40hNxYvqEgjPkeqUHUHfS12KQAjQlg4EdR1J2F2uLpfozelsZe
	5p33+vW6+9nFrIWO6JXcuirpNGBWF/L0LONqDuWwOq3Vq67mQKe+HhMVvYEbJ0avTOctKkbAbiF
	qwDy7tyrNDMZ430CgAro3ESVB/OQE6GYaLJ9qsOw/fWRlbguh0wDyypVv3Au+zlEMj6vO4Sf19y
	vdrVaFLlZNjLLqJbGMn6JiTMJh/A7z8BejIe8AZqvzzzM955bk2jzemIjpomcTuJh/k7I9KEAYO
	dKA2JQMccvI/KB5NEPbXZqWsGv7eRCUt3K0p41wVNil1MLPm0mOG82hIe2fNssvZdcsDsf4lNE+
	Yg64gmP6d6U736haoim/33YEddL8dJzigOxgnV15Ia4HWWT+IEczl1Q94K0gNazFIfw3mYLcsgD
	g==
X-Received: by 2002:a0c:f08b:0:b0:89c:a2ad:33a0 with SMTP id 6a1803df08f44-89ca2ad3b29mr89259386d6.45.1774312275171;
        Mon, 23 Mar 2026 17:31:15 -0700 (PDT)
Received: from ?IPV6:2600:2b00:7880:1d00:a5d2:a745:535f:7b72? ([2600:2b00:7880:1d00:a5d2:a745:535f:7b72])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c85335464sm100134796d6.31.2026.03.23.17.31.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 17:31:14 -0700 (PDT)
Message-ID: <c18f06ac-02e3-4377-b013-3867c31b5895@sladewatkins.com>
Date: Mon, 23 Mar 2026 20:31:13 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20260323134525.256603107@linuxfoundation.org>
Content-Language: en-US
From: Slade Watkins <sr@sladewatkins.com>
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rogueport-AntispamServ: glowwhale.rogueportmedia.com
X-Rogueport-AntispamVer: Reporting (SpamAssassin 4.0.2-sladew)


On 3/23/26 09:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.167 release.
> There are 481 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.

6.1.167-rc1 built and run on my x86_64 test system (AMD Ryzen 9 9900X, 
System76 thelio-mira-r4-n3). No errors or regressions.

Tested-by: Slade Watkins <sr@sladewatkins.com>

Cheers,
Slade
