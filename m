Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EB03AB27C
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 09:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774861981; cv=none; b=Fmku91E4WPPYnnvSRvgklAJO5Za1kCxD3CcwP4A1Nx67JYEzcDpa944bCv46dd3lEpcowDvD0+inskefT68wj40K2aTsEBYpyhwJBndIAJxcYSg9U9Jqtg3MZrtTuWb2cOS5vrxYl2celOx3sIROQ/dDwc+exlUQlTDGN3EFjME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774861981; c=relaxed/simple;
	bh=BpMetpjX8k28ETSJkeggdZayufTqXV3027OvqdPiFQQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IHVdp+wyvcFJqNhOeygSLnFYXHHVMiGgnGtFgP9zc9fh3eyEjUIe3VyiD/o5Lnw510QgPDbk67FJJO6SPj+NyAW6br5cSjWmVjMNOQqMu1E/1/g5MgYDhMhN/K15N/ez0Wd1R3X/6N3z9CWiGJgy+YTUnQp5eLf1r9ifrjnolsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hq2PonYo; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hq2PonYo"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2b24fdac394so9399495ad.3
        for <patches@lists.linux.dev>; Mon, 30 Mar 2026 02:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774861980; x=1775466780; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=san1INxb0psgZ8O2/M4yukcGM/Vdw3Vd1dAlpLP5aHw=;
        b=hq2PonYofTkw9tMLqgfP2UyNn2HKuj1uxddSSbJi+MSXq4cw3sCMAh+h0r64FZGkEM
         Nkb0qA26YB6gIkJ+svT5erZlMstn90yzUbW8TYlVzP19HTKUxbLao+oKALNzs6W2QXWd
         3yPPsvuEn/3tXZjPBH/ggXLgI/crjCeOI9LUwPqoJc5pt8rvhqQ6sbwPmtoO5/2fZKm9
         gX+Hng3XxlGH1/FjXKIdp6DYQNuB3GO3KxWuYAC8XzQklU2GpgMTIhw/mMWUBh0zYtW0
         YQwgivPwpaFEEJ13zgpE32otWMO4Vo2w3DdSvlQ6OhGbvhr9dXPdCnSk6WYdmlzcyW6X
         Lcvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774861980; x=1775466780;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=san1INxb0psgZ8O2/M4yukcGM/Vdw3Vd1dAlpLP5aHw=;
        b=ITNbfXQMa52g9N/rN+oMiEzXz/+G0dQe/LVSTBGdFo7z4v1tfKm3+I46RoSd7zgigO
         wlrsabLqzxrU0LYg7qKmuGawp9a2rV+jH9RZmEJA5Tgpm7u78vUEJVdqCyr3+AyrJljd
         C/AGM+cuTa7zi5pJgk3x7k4EjCayk6ELOL4QjCpMi/7XQSkXhQUshBU3YKIh1Sx26hYW
         r8zdihNrcycM4AeeQnXi2TALWG3DGS8DheiQt8N5oFNhDA58AAFOOWQtJIFFFHpkj7gk
         Vafpt3BVNhP/4n5+7irwG/VoF+ofmD/NpEvU5vp8HGvFmbEcLF02XB3CGrDASYRd0ORw
         GwvQ==
X-Gm-Message-State: AOJu0YxYUTGKTGMRf8OoBHTIW5iLA8E1cQD43e94ofCML91el91PTXot
	JgePZZd1SEEa555aHememygu3jSkeN40MCrekZPVpvN39QTkIRlLZntp
X-Gm-Gg: ATEYQzwrAy3IrzbpALRZZPbnHtmg6/Cu7YCicXWZrTMmWaVRR0r2GTgLqtxWyrVoyzB
	ugRpbS8BYImta+KJmkIBfXDP/A1GDIAad+RQwLwU0CAjs20x0K1D41IypaqQ9Bt1XnKKkAo6AUj
	dsjXpwHkHIjmfLs5cH4c3G6j1K8SBnnOWOEvveGncPOUznpk7Bx8uwi4ocyIgPScMt2e22lXxBS
	rOaAAmAiWorCW5sur+3ILadeQyk5dhNWT+YYzXQSOzSRcdB1/6eni4GHVeUZX/E24JOGiMTz4dk
	kwcR8Udc0ZVAGQBQzr4J1M7A1kbKQns64edl/jlSXz6V40xL/U5mrpScqhqc7iKrnuZJ2rJZAOR
	wJjWhFtfNkGzT9YzeCPIoRNEYhsv8rzwQUIfUPp5PJM6iuE+GGSD+P3RENBqSLwPlOMQ76u/LVG
	nXIwlCpvnlp+eI/myiO+mKHyy+46zcx6oMPIKmyg3owrlhOg/O+cynPtRAwKW4ItDAE4wQ1smu
X-Received: by 2002:a17:902:d550:b0:2b2:4728:aa26 with SMTP id d9443c01a7336-2b24728b236mr72869965ad.35.1774861979779;
        Mon, 30 Mar 2026 02:12:59 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24277fb50sm71186175ad.56.2026.03.30.02.12.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 02:12:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <8ce43a1c-3198-42bd-826e-a7ec5276afd1@roeck-us.net>
Date: Mon, 30 Mar 2026 02:12:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260323134525.256603107@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 3/23/26 06:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.167 release.
> There are 481 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
6.1.y and 5.15.y fail to build arm:ixp4xx_defconfig.

drivers/net/ethernet/xscale/ixp4xx_eth.c:390:39: warning: 'struct kernel_hwtstamp_config' declared inside parameter list will not be visible outside of this definition or declaration
   390 |                                struct kernel_hwtstamp_config *cfg,

This is not surprising since struct kernel_hwtstamp_config does not exist in v6.1.y and v5.15.y.

The problem was introduced with commit a94d5447f6bf8 ("net: ixp4xx_eth: convert to
ndo_hwtstamp_get() and ndo_hwtstamp_set()") in v6.1.y and commit 612c622ab8efe
in v5.15.y. It can not easily be reverted due to conflicts with a subsequent
commit.

Thanks,
Guenter

