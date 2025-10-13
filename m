Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DC322DFB8
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 16:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760373439; cv=none; b=J6gR6x6zuDXfEjatAgRq/wMEiD8ubogHbEvHgXi2DLnmQ4BGVhn2ROQPTU9iRj0W8xLBGriYV1snsZ3sPcBpbVrgFMhPvMPOkEnhB/UT8JRS5OeEsvIxqGWgdIK0j2ptQ2Gm0aNiL9D1MtFT7sg2ykiVV9y1KqEBW4yF4D7niDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760373439; c=relaxed/simple;
	bh=b2r2ZnqDhlcE3hJzionks9xsPMpBi1PVSIuwbR3WWhE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hi/KjM3XDcpucds4snck3DeubAw+ECZwMdeofXn1wOz0JD3Ok1asyBCzw0r3t/o9/3yQrKcUrvINqaq45VKG5RrfWba8i0VwTM7HkZY4KG+0OG4E8MyP7K74krMGN6axjTMOhOD+qMna/TXWUOPPY+ltgRcXkP2VpvSK4J3oGro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AZGxd6S6; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AZGxd6S6"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2681660d604so49143625ad.0
        for <patches@lists.linux.dev>; Mon, 13 Oct 2025 09:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760373437; x=1760978237; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JEa7pR/fO5GSfmUiWOWkXWJ8/pJjtXIzKlc2WrRjppw=;
        b=AZGxd6S6NvWtBq2Dsh1FTCrzMsXlkpx0LemONRA78ASi1yrUYK34SOw74UA16KRrE3
         3lEMLIMy/MarKaR78RQ8YlrfnYdQf5zDhYWO3Rzwf+gLs2nLONSQoDtM8l71H6HNaP5H
         fSS++yG85gxWa/VM9I7/mDzVt1U2TIUtAzMZbleaz9zC0WuxyhczrTX83BDFWb1O1MfU
         JhamuIiJxNuU3xfI33vcbtbUnLgrK7hDZoKfmb06hHoWSa8TVy02hEr13+ArWIxLNS1E
         LTPt/9ffcHxtwBPhQEAI13jsMdB2sRQvvBdpAhN+CrMUQFiGcV0nj9+UmEYy9LTtmItP
         wGeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760373437; x=1760978237;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JEa7pR/fO5GSfmUiWOWkXWJ8/pJjtXIzKlc2WrRjppw=;
        b=vtsdy/jt7ubgW5wf3NYDkNu3Jh9GmtvHo0dlnVbLWmJyzc0SjTIVWUmDdRheSSYJNd
         Z02ngS5Ge5L2O85XIH4Gw7lPBirB7jyRLFzRrO9rJjzntCnhla42MtpyxJ4BmYh8JJDt
         uud49qjxncdqjxarUN9WrGIgk4cgdR9IUmz7DN02pRmJ8heLaF8kLJr4H31Oz1s8WC/e
         nOjxlPv4jNAFBreOS8lGN6a+r2iF70Xycih38iQt7q8kEOXPqfEory/0fcdz8ry4RxQk
         6YpkMNBA0kw1BbtWBKgdt6V+KthqOL3/G1Jv8zZVeuf3DBVA1YNWyhcR7yOsBrTlwtzZ
         nURw==
X-Gm-Message-State: AOJu0YwkB2WpNHGVDS0L+hyo4C2ZwYI2x3qbD/MPPu162SOX6NuD/dvs
	l2nXatwFclbU7rJKxqrd9KToehkqLCIjixPAIKrdOFsQIUfwFB8jQI3m
X-Gm-Gg: ASbGnctSlxOKh0vXnF4jdSR/HL6w99KQ4ppIJGRfa1lE9XxFKjr1g5APx8BiKoGH7Me
	DnzWkQdKhd3AEDIoUXanw17L508CIDjgbW/eFXkKhYiqViiZEQeaSaJXAz119KmGUA4Gjij01uh
	g7o5WL24ZU1y0/Yx6PzgpFmAJOu3ft6TAV+wJpHmeZScB8c2LqlGwr7ynCN9EPqdvsMFbMjHZ5k
	M3Oj6PMZrGIXMuP5gkDOjRMqOTUS7vxrhk/hu9LxNoo+rrqF2WtbxUbbh1VKbkpBkbjwbEDzl0m
	GB+OwiK4BI8Y2DIpGrrlj6N1WEvXNwh1kgSfTN7HrpFOab9ygJtjI7vBzhmKuSSEXi4B5UEfMbv
	P8ytg+4G1A6voMWglMPThngQ4Mpa5gT7CxdgJKTSjRm4f+1obBv/ndqJZJD7Gy3X+CeLZpgn46m
	K9htk=
X-Google-Smtp-Source: AGHT+IH1KJHETTMsM9csfcmWcjkeu7/hQCwuY0V59wcP2JtmCwROl3hskQGQ1gm8DOn8sGQGlisYCQ==
X-Received: by 2002:a17:902:cf03:b0:273:daa6:cdf9 with SMTP id d9443c01a7336-2902723ba36mr241690505ad.22.1760373436572;
        Mon, 13 Oct 2025 09:37:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f95bd3sm139048795ad.119.2025.10.13.09.37.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 09:37:15 -0700 (PDT)
Message-ID: <0b2ca7be-22aa-47d1-959a-a6aec4c3dc5c@gmail.com>
Date: Mon, 13 Oct 2025 09:37:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/196] 6.1.156-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251013144314.549284796@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/25 07:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.156 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.156-rc1.gz
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
