Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8182C326C
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 19:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593510; cv=none; b=Co4kewXH5ZOTvXWPezI/7Nwqpqx416xGClOUhoIvpvCwxMV2Z27LgzZdW/sr4Ea0bvShGHhjNZVGkMAeMvmrncDs4cgZ+U8JYHY6FncqTWdtoJhM2AUGweLNqbmXyTBdGwk02KHeozSpD7IlK9JEVaKv3jgmQytqyGG+p2IAvTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593510; c=relaxed/simple;
	bh=Wfw586FZsQVYuyKx2zTL0/KlV8MshdPbK8gyqOvNcfM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nlutPiXYHHxiO/4lH29w5h+0jCNRc04e/jkMcsAMYNUIZJjYKFIxL3x91v5G5OXxpkQjL2lz4yMR+ylsHMcaULzLRQOL4ePBpUv1/YyvDIRs6WwFvNcP87GCJiekUeJjMkSwhe+KxCeDwZkT1Q/8VWyCOXblSWThRipTdJjj7H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DiDaicFX; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DiDaicFX"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7a26ea3bf76so6751970b3a.2
        for <patches@lists.linux.dev>; Mon, 27 Oct 2025 12:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761593508; x=1762198308; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aQIEre2ri1pN3eJbczeUY9nkqkn0UVxrRDPMJROpfpI=;
        b=DiDaicFX15TmtdqUkKv6A1IMNt0TO5Ow7ckkGunM89VgOiP4+GftGbmn3dbdAvaMmI
         2qIYoO2KA7w8mdA/nteHTTobVgVIh6Hk/2uspYbyTm8g/74GplaqpqH27U9ej2mblRhp
         AakoaGCNP5LS4p5T7ZrmjIyfFZa3igOvjoyTzVLLY9BxdL+dfR8hao9qznFN0FHb+Vs7
         FpYn4JgKjFxFxfxIJedeUULASMA+HoDgvP9SuUxvcFW5nZL7isz+FZf5cD04BrKNGujU
         XwRZxdkVXZlSJIp9aZ6Qzny0Rflo/3Xv1nCSKlLYtUyi3OuTiGc0e/cneVLZI+cOQUb7
         FkbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761593508; x=1762198308;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aQIEre2ri1pN3eJbczeUY9nkqkn0UVxrRDPMJROpfpI=;
        b=m6Bkbe7q1HeoEFfYuMmqi5Si48JnGgZOe2/ZjaaqcuuP9gydMq/763DAc6MctZUJlm
         Y5eOnwcZLWi0lr0reFhJUGrLMNh2JOCnXksPksd8QpyeiCCOMllA0pXJy2F9wQzcAtrj
         DfBHI+aGTuqvHAdRaSWp4v7qp50y1viSz5eI2zIJ1IuQEImMtFwHOpKxdODiFBSGiKGo
         kwRJxP5RL45moU4IX5LcVOMkEtfU6iPCh6RcqELZ6o0JvAUG7440iXJc+zEMxS+mpmmk
         m/9DBkqB5acCy0ow3+7sjtwTIF1Sfp3ZeqfYOo9Fa31jhZgZChZczQukuwbQXQPw/oIu
         ZB6A==
X-Gm-Message-State: AOJu0YzJtvUt8suGRkD2A0R5CvDc0PQYARKzR+KimdX5ODRyPre/cV0V
	Q2naON/6Km+C+W3UR90K2epQS53dLnROhyzYguqxlcieZK9ptm67rW9k
X-Gm-Gg: ASbGnctM7U6nFnBETwlJNbc/ubDTpAfcCAYOMnWSWJZPyvY5X97qEpgXNmgisF9zNvs
	izNnijpnuwiLG4yJ5PzfnskkOIB/jBwuUO8YP122S2iOIFqeXL25p4tnOesQKG0CNNgaSQ9DbKU
	6isT4q3XVOm/Ll0yMgzHNpozF+05Hb5XhtXWUP/CyJOpuxS+fW+FZpI+igBmy6tSfjTq7icVHHS
	1ZEUdhqEv59xWJlDAMCJsKYB18gObUJ6g5NrwsASIa7QHBtIJDjegv3uy1zEMHQTDb6G979uu3r
	Ajz8BaxVOkOHUaaBtqtEtT/kIu6ns/JMzCeXF1AHpzJ80RI0BVqOjFyVbu9oLX0poWiN7FHQ2z3
	R4qB91/GPmTzRRLBGWkJ6lwHXqjyV15OPkJX8DSJGuag5jvVrkziQ4u/bDCB5N9YHCPqpM6NQiQ
	i4yr9yTPT8Hp4LaBoTx6wXtbl99MTxgiF9HYOPQA==
X-Google-Smtp-Source: AGHT+IEkosWML/wG8WDCCZZJB7OEe7Pbs33Ch34uBEMhw66C9EPkEPTbWzwlAuneyQFI3gppfP9HKQ==
X-Received: by 2002:a05:6a20:914f:b0:334:a72c:806e with SMTP id adf61e73a8af0-344d441f72fmr848282637.43.1761593507941;
        Mon, 27 Oct 2025 12:31:47 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b712f0c0b1asm8203659a12.32.2025.10.27.12.31.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 12:31:47 -0700 (PDT)
Message-ID: <eb241eee-2b51-410a-b13b-9511202a68f7@gmail.com>
Date: Mon, 27 Oct 2025 12:31:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/224] 5.4.301-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251027183508.963233542@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/25 11:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.301 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.301-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>

There is a new warning showing up with 
b27e16c9e625465fe9ea9955bd8ab095498de9e3 ("tcp: fix 
tcp_tso_should_defer() vs large RTT") , but since 5.4 does not have the 
full minmax backports this is expected:

In file included from ./include/linux/list.h:9,
                  from ./include/net/tcp.h:19,
                  from net/ipv4/tcp_output.c:40:
net/ipv4/tcp_output.c: In function 'tcp_tso_should_defer':
./include/linux/kernel.h:843:43: warning: comparison of distinct pointer 
types lacks a cast
   843 |                 (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
       |                                           ^~
./include/linux/kernel.h:857:18: note: in expansion of macro '__typecheck'
   857 |                 (__typecheck(x, y) && __no_side_effects(x, y))
       |                  ^~~~~~~~~~~
./include/linux/kernel.h:867:31: note: in expansion of macro '__safe_cmp'
   867 |         __builtin_choose_expr(__safe_cmp(x, y), \
       |                               ^~~~~~~~~~
./include/linux/kernel.h:876:25: note: in expansion of macro '__careful_cmp'
   876 | #define min(x, y)       __careful_cmp(x, y, <)
       |                         ^~~~~~~~~~~~~
net/ipv4/tcp_output.c:2028:21: note: in expansion of macro 'min'
  2028 |         threshold = min(srtt_in_ns >> 1, NSEC_PER_MSEC);
       |                     ^~~

I don't think this should hold off the release though.
-- 
Florian
