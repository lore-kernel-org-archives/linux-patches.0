Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030562;
	b=IIpVuUMJ6WQVQpp1giYDs4Ilq7/NCoNZk5eOiVD0/IwCCk9GZ/44rhMmV3w3kJMF2wUF
	 Wj5Yqok37pwy0RQcbwKEHZP18Ysq6OxX6cRLw1Y4wde13sUQwBAaKXyYSNnKgjDNmqzXK
	 aiFEwQHo9hdtORmUEoiCaD0pZ1KR3Lu9G0LODD6h7UKVFJ4gMSNQxnOjbLJuJETa7kJNi
	 ucuiwFkq+dt8Vl50GVD7AHudczVW94ZF7Vuu5e55f0dBvJHi3Reg74vjrxCbr+OgvKUim
	 5h/78UBVSRDvfcP9IiOWv5AsODUCf9cJtTm3uqMbwdLu6YIPS+xPEMboBQlY+eEzDyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030562;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=FaD+0SeebjIC4CSZLUfCZ0AvJts8laW/iFN7jyexdUM=;
	b=Z0XI31X+TYPWjg/lMK2qvLQBE8M+rLy2iZNAmQl1ek59Qy3TOr1TGkEXqrLripQH7PN+
	 NhOhbwa5oO0Rgwuk9pAOCkFPQ2wGF5V0fJQF8lgrvG4+OlGDjSPXwo/GC2AZyJ1UuFuS+
	 cdQYVp9ILsfjYSbPYrvjuE5iY2+2NfOv8okiU/drXhcYFZc+HUSRAqLcbX/XyoFJ/qU7s
	 Dh/Fn/9ZHjhR/xRRpVsDEoMndxYe8Ta5Xl+eS7sBTv90wrBYMFunDdz3kMu/GJSVG3IYJ
	 bESviLYRqS0D5rZ8RjdQvzLJWNQ2HiUv3gHhAjbJ2vDuB/ZFIbT3d4ohGYkEzzavn2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bpfii7Tf;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17492606D370
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 19:36:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17492606D370
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bpfii7Tf
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8c20d68c83fso122244b3a.0
        for <patches@lists.linux.dev>; Wed, 18 Nov 2026 11:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795030560; x=1795635360; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FaD+0SeebjIC4CSZLUfCZ0AvJts8laW/iFN7jyexdUM=;
        b=bpfii7TfrTTnqy6lCVv2r60cVKCPwY38QKHRXT+r3AejlC8h6trrI/P7plVipJmozx
         a3dBmwgrul+t2C0SJAJUiTwJGj0Su3v2mk8POJpiGUZjYa1p3Toa8ywmqbyahTXTT6z5
         rCmgobbyhqww+jUnxMPyRdP5GeUaYiATV/raS6toqtopWyhIRzNU3Unr6XUPpfz3QyXd
         wVJqsPOzmiq3lDWHMGc4D1twr0smrtORC1i4NZnOP8h4rh4v04XIgf+IO7qN6mbzv7Hx
         yEDvLbyAybnFvfGXmDMxvTJNAX0hrv142H9DWiZGPdK87ma6CKNWjvaSaAZ+ksIUyN9I
         kkuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795030560; x=1795635360;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FaD+0SeebjIC4CSZLUfCZ0AvJts8laW/iFN7jyexdUM=;
        b=fvKdboU6ymEgYcclb/hhzss/T6C2y000b7FVGn2GuDx+KOANpx4R1NO94HUKb2tFlT
         vTVD7cOXshKjosvW+cIDGgrPIWEwoN7lDz2NL5MP11cmFfyIxnlXrFmh+zg4DbQSQBU4
         4sJYVyGfIZ81BIsOG0jCwTS4CYUl3bPiCC9jH4Lk4M5eYjS665XwuZx1pCba8iZCMpt5
         wKnkC7IxVl21XBzKhRjDNSqu+hqjuZbw2ymwnYEbJWDLhI7PCZ225Gbb5eHxYB0qwy+S
         BNF6JYUob7fXtKH/AEspVoRd56PTf70VzHZH/YhwT6QcjkhTkTCTojM5TnFVj2U2c2PV
         Bi2Q==
X-Gm-Message-State: APuU4Z+tx17IAhwh8x2PC02mzAgpfHY3ldExMpoad36f4xkHP1HrfSzU
	mCy3ZnBhRjD7YMqhlCrYekAKN8VY6xTLzE97GNNihrZUdZTP8ardNuhh
X-Gm-Gg: AZFdTZcswNHR2Fr/Ycp2S/M2ELaKtdZbPPP/9QQDvV0N//gzgkC76I+gDtjedVuQuLA
	4+eVbABAloI7JnJ2aY6UBM5z8vnOmJbG7Vjmos+lB71dVOfWHGjujToCmegqiya9f5LFpPegoI4
	KqXEvr3fackQiD2AGHShCvMoE8f4xp+QVh8PnJ/KfeV8tjitvxBZN3XHJRdOXrvOYk3aBK3m5D+
	cjQvuhpvOgE8OeM5JNpD46vXB41okOktFDK0YkZuHOB3eogS5qOjOcDvsuVMT/yDmDGuvMxvL2a
	sN3fpOPVtqgOUjn7Y9LQwHHTjOm4X0g6gbFiDLxZGbFIL1LAvSqwcRrdF89duaYMU3eY/AgqKR8
	/t7Nf8gROkCKzJ0YhQ2pETIwk9egTXOhcbaOT4e74j14aRGEleIoolumbmHn5e8K8IsVVQlQ9oV
	rg2lPh3XXkZayC4HxHvUKmPpRw7ZHSrThitNlQKEubpbFkJmdpT9HWI7TSrKdY6jX3rg97UtNHU
	ZAptfuNFwWuB1OJfvp/1tdwstGbErknAarcDXWrO/ObeahyLmFPE21UP1mTR5g1tHDppp8FrInZ
	4YSKmAyQJGzsRlh8lKJAS1/I4sSycOxpkPkXsw/H9jRF1e9GsVyviXZJ
X-Received: by 2002:a17:902:d584:b0:2ef:fb60:ca47 with SMTP id d9443c01a7336-2f019883e9emr2883795ad.35.1795030560257;
        Wed, 18 Nov 2026 11:36:00 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff61162dcsm18553935ad.18.2026.11.18.11.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 11:35:59 -0800 (PST)
Message-ID: <abf15e9d-6317-41a1-b43a-188905ff3888@gmail.com>
Date: Wed, 18 Nov 2026 11:35:58 -0800
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
Subject: Re: [PATCH 6.1 0000/2857] 6.1.193-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261118150201.293410965@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 06:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.193 release.
> There are 2857 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.193-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build the same way the 5.15 kernel does:

/local/users/fainelli/buildroot/output/arm/host/bin/arm-linux-ld: 
warning: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/arch/perf-in.o: 
requires executable stack (because the .note.GNU-stack section is 
executable)
   LD 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/libbpf/staticobjs/libbpf-in.o
   LINK 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/libbpf/libbpf.a
   LINK 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o: 
in function `test_truncated_branch_stack':
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/tests/sample-parsing.c:397: 
undefined reference to `__evsel__parse_sample'
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/tests/sample-parsing.c:399: 
undefined reference to `perf_sample__exit'
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/tests/sample-parsing.c:400: 
undefined reference to `evsel__put'
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o: 
in function `test_truncated_swapped_raw':
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/tests/sample-parsing.c:445: 
undefined reference to `__evsel__parse_sample'
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/tests/sample-parsing.c:447: 
undefined reference to `perf_sample__exit'
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/tests/sample-parsing.c:448: 
undefined reference to `evsel__put'
collect2: error: ld returned 1 exit status
make[4]: *** [Makefile.perf:675: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf] 
Error 1
make[3]: *** [Makefile.perf:240: sub-make] Error 2
make[2]: *** [Makefile:70: all] Error 2
make[1]: *** [package/pkg-generic.mk:286: 
/local/users/fainelli/buildroot/output/arm/build/linux-tools/.stamp_built] 
Error 2
make: *** [Makefile:29: _all] Error 2
ERROR: Build failed for 6.1-rc on arm with code 2

-- 
Florian
