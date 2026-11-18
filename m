Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030688;
	b=BPc2moOFeT5y5ZTNH3Yy+tcNL0ey/wLmA9wLjBhewZBay3w3B9QFP2JQJtJEY+LNsGnP
	 5LVM8Q3Yr68qQRI/EFvXs6NLMsbfsLzD9dlzGLyWe0VpfmO7nz3iNJ6F2zeKWIj+Ufdkn
	 6caUmQPVzk/yAQmI99dF1Gs/taVrgYsgzBvKOU5GlhoDNH36mAJc1eOGTRvFrsK+VdZrM
	 Szr1ltw+cXBVt0Gs55tb+Pio4RrZSeJRIhWvue99sE29tDihuDC/mmwNmqA5/h5Kc/T9f
	 GnLKQYpIXoz/FVWUIqRMdIPNk93U2f0cLvAmqatFB5iYpvRl3qlXh/qT8fQaF/wo3gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030688;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=c66EFlOJVYnnxUqxIZvQrJ/FVmfJ5lBMhar3bfkOCRs=;
	b=hIBbBI8OZ2bGrW0telLN0CLvHiYJzTDI686gq4MwnmrEaCBFkDHKF27vqJxO8ej/+gm8
	 tP15L4x5Nj4rIt/1MYfeTTv34B89kHkTlUsSYX7qlmx/N9l3+usVBHE0l+GC1d6hrl9hE
	 ZRo8B9sLxp0EbKBzAPyRU+Bi/hg4XDy6M77WuHPhcbk+Vf1XtIcf4m2koA5ML3dmmnaA9
	 DmhFnOaninyrmV/cfxiaSjJKDQZ3QM7d+mVcPjt0DBVILuV1My5GF75inYXHRFSk5tk1X
	 wG+OwahpIHuTlPJXGFG8mvVtyBQbrWZyRsMe0XHfzFgSh6uQ41Rhl1q9nf+Vc98GOJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sdjxnvHi;
	arc=none smtp.remote-ip=74.125.82.52
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43462606A320
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 19:38:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43462606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sdjxnvHi
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1a3c08d6928so2029720c88.0
        for <patches@lists.linux.dev>; Wed, 18 Nov 2026 11:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795030686; x=1795635486; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c66EFlOJVYnnxUqxIZvQrJ/FVmfJ5lBMhar3bfkOCRs=;
        b=sdjxnvHi5KEEQTq9XIlPUYnlzaUD4irv4Kxf5vxwfzwAKgn7JSmsflL2d8Et2CS5Wn
         J04N64g+ZLLP2NeE5cH4eJNNFR4rHSkwG1btJ6pEYUCBctX27sWG7UHmllx7w0D1oZIv
         razni9Py7f94Jre/oJ9xvyxML7SjY6O5k3MZaa3Z5/MUb0oTV0JhRRqAGiDgdD7xAmfq
         2F7AQltPX9OmMYVqI5HiBDJ7w9jdlMfpU4p/qnQBTqvv9Otzs2g1DcxjxUzbdS/KtWjR
         AsbfPi2DMy5endbgvP06iXRNrXeRh2pPkyhC2x9UfIP4tyxUxf2X0uytkHNhHbq3JGaQ
         00PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795030686; x=1795635486;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c66EFlOJVYnnxUqxIZvQrJ/FVmfJ5lBMhar3bfkOCRs=;
        b=aKUIMg2Kl5XxRC5MVQmHYwzTzVupeXk9QMcjtsbIbEO1wlZfn109Qfj3VUut6/pnMC
         Fzpdwrk8n//sSmXIvNiouUMJami+VJmrKMqMVxX4rszTi0Uq4tlV8gELeo6OdShhfGsr
         AJJgSFX5n+C44NDBNkO/SGzowqLhZTP9Q57in45BokF4enukBMpLfcCSUnAgvP0ddEUY
         xi2sgbG0TU1JTMrQgiTjMRhe1AieVcwdr7TZfufBStfBM0EwxadLxqt2F4Pnn8GRkNbm
         c7N1xSbfFW67+yhSVh7SnGv30lt1EMDm9PzMBYyYV28XgdzAAzPIusZZBo1nLK1A4CPU
         Z/nQ==
X-Gm-Message-State: APuU4Z8qe2ev2wCmROjyCXsg2j+zrnu5C5GcIteD6xZsOKDcUgA0wyyf
	JW9kZTPz/nJmtH06Q4pheqxnf4olqos+t4I/WJvkoy8mTqELtOwK7nnC
X-Gm-Gg: AYBFou3pQ8iT0z18uzQDRmFoHLG7a5qr1of518CJr2mrWDwxD1Tnr5Bil77FPJrVS2D
	bVXhpxLWnMmCuz4blOcXv+jyB5OnYu8ZHXF12VblKYTd/0XWEDmjAuEhKukOr+qIe96/INVfEFV
	ny13w5aDXzAjHGALdpePY4jiaiBNxHqXuBniWJuTiGUtuT7WQ5TOlwcSbkjkSnc7ae+QgCB+yex
	g9UWTTreq+Cq4fC3ityjIuiJ76hYBDgBvd4xQplNflmq1fax1hMkBoF76/io3iPA/pfivGogRWg
	/1zQR42NDkrLe82VjWNSRe8g8QAc3BV/oaDY3u0bExE/i9YATLA82ZgcTEjb9RaAaNCA/AkjIba
	74rfROvg6kKv6v1eGEvvdsPmMjIGGqkJB9SCnUiq85bmQYl8FVROk5m3swZ3OYoXqCpfeJUZqXR
	lQCecYF8MYs/vzH0eu4lPGTxeX+kzWLAyKLIQth86/A+Jk/pvHaNz7o7C73+DyBaZThewyQ+c3w
	CKKlnH+ZYdybLTbaWQVyimpT9g/aFqRK3gNwNW7A3Wl2sKbytBdQhH4wpmGbQ2e3nq9zAw8At47
	okRKTOgN+4KewzfpQB5IyQADmcqliSXzdWyzSo6VkEV6oKrS9NDAE5Fj
X-Received: by 2002:a05:7022:7f15:b0:1b2:3448:840f with SMTP id a92af1059eb24-1b543cb4093mr3136249c88.7.1795030686140;
        Wed, 18 Nov 2026 11:38:06 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b544784017sm8261719c88.4.2026.11.18.11.38.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 11:38:05 -0800 (PST)
Message-ID: <9bf135b3-455f-4463-bf6a-b80faa2e4606@gmail.com>
Date: Wed, 18 Nov 2026 11:38:03 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 0000/3318] 6.6.163-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261118150313.527275416@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 06:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.163 release.
> There are 3318 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.163-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Same perf build failure as with 5.15 and 6.1:

/local/users/fainelli/buildroot/output/arm/host/bin/arm-linux-ld: 
warning: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/arch/perf-in.o: 
requires executable stack (because the .note.GNU-stack section is 
executable)
   LINK 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o: 
in function `test_truncated_branch_stack':
sample-parsing.c:(.text+0xaa774): undefined reference to 
`__evsel__parse_sample'
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
sample-parsing.c:(.text+0xaa784): undefined reference to `perf_sample__exit'
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
sample-parsing.c:(.text+0xaa78c): undefined reference to `evsel__put'
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o: 
in function `test_truncated_swapped_raw':
sample-parsing.c:(.text+0xaa93c): undefined reference to 
`__evsel__parse_sample'
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
sample-parsing.c:(.text+0xaa94c): undefined reference to `perf_sample__exit'
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
sample-parsing.c:(.text+0xaa954): undefined reference to `evsel__put'
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o: 
in function `test__kallsyms_fixup_end':
symbols.c:(.text+0xc189c): undefined reference to `dso__symbols'
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
symbols.c:(.text+0xc18b4): undefined reference to `dso__symbols'
collect2: error: ld returned 1 exit status
make[4]: *** [Makefile.perf:697: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf] 
Error 1
make[3]: *** [Makefile.perf:267: sub-make] Error 2
make[2]: *** [Makefile:70: all] Error 2
make[1]: *** [package/pkg-generic.mk:286: 
/local/users/fainelli/buildroot/output/arm/build/linux-tools/.stamp_built] 
Error 2
make: *** [Makefile:29: _all] Error 2

-- 
Florian
