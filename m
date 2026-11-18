Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029398;
	b=TxODqk2cLqo3Il/UrC2KVdMx07hPL65LA9fQdo2J8yjDkkHStbvIUY7LNLqRfsgJFAa9
	 sdkjW3PnF5iAs2lt0XgHInYFV/rE1hqJQbYOwgRoB8A8Gj13XX5d3Q2qDETMfP1bd0YPa
	 cMvjm2VL/IXKR7xU+DzVLZyo2mjBVikN9aIh0ia7lDf8swWN0ICoNWUuec+d2VY5i2Ap1
	 OCNm9T5KPiG0xW3B7boJcT470sVI2zRchmZKrBvc5V/EsO6onr+lT4hA4r2IwODoe+W/Q
	 J9iV+5rkYIiq1Qt9sbCQMBTZIDDDJw2LTi0DoTBlX03mg+pesZp8xHyLw3zLVpo6zZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029398;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=58b5SUFBCY4/MY2JUfmGH8gHdBS79YyzhPLRjlW4m0U=;
	b=hgZ+CtW2ObTiCnN2KJRUfCmP1qwahegQF5q4V/7fQmaFzqpX5OmgtMIWIY2TAtLeLoDQ
	 sAoZNxvd1IzcUjj8BsSr4pEPaCTVmsBIa+LUMEAVanCdAyxAvzTei3EJdNz6qVyigBCDa
	 isrb/y9q8jQUMcSd4EBXCoTTuGFY1g8UgBr+VfQ9OdSrfMe9njwtoZuvLf/1kQR9NhRkS
	 CTHEGqVwE3O1EXjicohHMWgeg6wdBpXyuz/MzqoASlYlJ1ww+RKWOJtaNdsmsWmD82+9j
	 Vy33C6/+0Ligpza5uZYVPPCqA2G00DTo/ANcpMR7NevmR34UP+jMW6FEpiqo5WyYTpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=We8d0i3r;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947A2606A320
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 19:16:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 947A2606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=We8d0i3r
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8b5c3288e6cso837726b3a.3
        for <patches@lists.linux.dev>; Wed, 18 Nov 2026 11:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795029397; x=1795634197; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=58b5SUFBCY4/MY2JUfmGH8gHdBS79YyzhPLRjlW4m0U=;
        b=We8d0i3rQbpbdFpwpD2PVcRXnGNlJVF7fiBvpRGCRqAi2biV//g9Lxm7jNbi05hQ9S
         Wi9QflTROUD3vWN6LF2d3R+ep3oHIp7cu7oRj56tDn8lH8Y3gV5S+yNUi4LopS121yTN
         hfPksqUpPRLP4n7MocSbkt+I2LCpnXn/JOpj5R7zx/DmIrhVTBJwa1zsPimeGJItJ2Fr
         q7sva0D1NEPq5+H+7gVKQ+UF6ll7qN893of2uK94uD7t6omN+nEG02sWYHGOVTjXQykr
         XBUi8xeMsnUK/UpZ91Cb1Kw8VOHmCp08Hz5Kb0rWBCTs2Uy+UsrGpB6/B/A2p67DHnr8
         /zZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795029397; x=1795634197;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=58b5SUFBCY4/MY2JUfmGH8gHdBS79YyzhPLRjlW4m0U=;
        b=uSdo7vl8ukKUnWpWYmRo+N3x2b0NKQTd3kJf1sUy5lWjSInbesQRjdTx1saNB+5S5U
         KdymxM9lMEfq63/jdbdy0ru65oI+XzMdfpbGZLwHBg0NqOYVZJw7kllt1G1PniP+Zozz
         ZXx51Wjch7yIH4pPKPMJBz5+30n0lBBXxFGoILwFU2YjuSUZjB1ju1hGPzAqW5jvWMeM
         Q4Pm5maHdDaxgFaNcUgiGrW9Xys6Jgf2hfyWbEGaR9Vb3Mkwu/dtOvj2E40TAj31NI3m
         dUGsNUZvjSvEVoLZp7yocPCgXVcSHTfVEw4xuy3d95oTKzQL7uPXh5Taf0gHfsDrXkrz
         c+CA==
X-Gm-Message-State: APuU4Z+geFfqd6DBlGauAPm213yczW5SOGDVzD0fgbTcixaaa3vw7xXq
	Xexf6xYcXS5FP5selVnATBtFvzbA/m8y7J7FEsG6S9v+ejuTtQF2qZ2B
X-Gm-Gg: AYBFou3PxFFNAo52SU/xGaDbs7FIOe8EsA+hZBIoQtGzBiE7fr+C5BOJFiXPmrIJbm7
	AEOyrhvEkFMaQG/jtzqT417kr67+SE32O3Q7gxIsICfG3YC4UQdjObk7hcbvpy4xv9t15+hgCdJ
	9gAMxyOUEZhoXTxRagh2rgroaxuVfoICY1C2Y7Cd9cOCHMmlll3CtvjQlr7HghhEeGkUQt8bPHH
	gXq0sl5rogc1w21COUVTlWsdN0BtXVNKpRwJJgEd6I3sbKjbgzAh8Uh2ju4SYW/ClvQhDwSxcL/
	nJPDBNxVF5Xl3MgBUbJSABm6qIT7ABFk93bj/qZRFosYS0nXrVrckX81zJaShXO2VhHbWaro+Sv
	Vf0g2oA/JLs2NBP1ycy6Aq2zfDS+STHzCOqJzMdpRj4GISJjN7buqsnqOSoxk36lvlPDpmq6aHn
	CqbO980waLO61I9LWh41KgY5axoSSCuYXbOrNmsPSwd4CqaYtGnVBo6HoWFhhWhAuJ9RU1xsrsW
	LbV5+gmSN+H5XyYWtVGCmMRN7XEPQBWJ17V63+xnRfi1qhoEba6XSwTP48ftUn3HKdv07Rv1pP8
	pTAX6/wWY1RCQ1u9GpFliEN1ta5Th88+tnUTR8KJwaW78FRy32YwiPAD
X-Received: by 2002:a05:6a21:b8c:b0:3fb:1091:bfdc with SMTP id adf61e73a8af0-3fe97bf78a2mr3539072637.37.1795029396924;
        Wed, 18 Nov 2026 11:16:36 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde534854b1sm453228a12.12.2026.11.18.11.16.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 11:16:36 -0800 (PST)
Message-ID: <65c24a95-1087-4f30-9f9c-9e8636da211c@gmail.com>
Date: Wed, 18 Nov 2026 11:16:34 -0800
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
Subject: Re: [PATCH 5.15 0000/2214] 5.15.226-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261118150009.797899913@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 06:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.226 release.
> There are 2214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.226-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build with:

/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o: 
in function `test_truncated_branch_stack':
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/tests/sample-parsing.c:358: 
undefined reference to `__evsel__parse_sample'
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/tests/sample-parsing.c:360: 
undefined reference to `perf_sample__exit'
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/tests/sample-parsing.c:361: 
undefined reference to `evsel__put'
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o: 
in function `test_truncated_swapped_raw':
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/tests/sample-parsing.c:406: 
undefined reference to `__evsel__parse_sample'
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/tests/sample-parsing.c:408: 
undefined reference to `perf_sample__exit'
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/tests/sample-parsing.c:409: 
undefined reference to `evsel__put'
collect2: error: ld returned 1 exit status
make[4]: *** [Makefile.perf:670: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf] 
Error 1
make[3]: *** [Makefile.perf:238: sub-make] Error 2
make[2]: *** [Makefile:70: all] Error 2
make[1]: *** [package/pkg-generic.mk:286: 
/local/users/fainelli/buildroot/output/arm/build/linux-tools/.stamp_built] 
Error 2
make: *** [Makefile:29: _all] Error 2

which is coming from fb1a8ab598b3 ("perf evsel: Validate branch stack 
before byte swapping") and 2bdbf51d3627 ("perf evsel: Validate RAW 
sample before byte swapping")
-- 
Florian
