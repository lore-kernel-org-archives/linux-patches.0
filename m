Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792432198;
	b=Bwt4SNzRkfOK13eyr86C5nLPUgYtIEKggPArj3EXX2xiHa2DloIjZigFS4e3f2hekoJg
	 5xYhy141GdMaSpWESDH1bOiP6jvjy/jaahJkXtF3EuNSOUhU1y8AlN7x8aFRImDeaaPA5
	 XZul/1P1UDtTa33oPiBdZE9XT3zCaTCuwU+/W0EACZy/xDBUEQ2yg1Zs1c0oN8BBhU/tS
	 d687ySsEuP0dLMIO6CRR73m+jiCzb3pnCrWhamFDp9MbMOx6L5Au2/1avJl0P2IeJ5IIR
	 iqxW1HoHcoH3mry9ZXJ4wEhDXENZraT0Wor2bWXiGv0bCPKcLjuMIM6vxqK9ZBm6+ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792432198;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=639/CBjTq+N5Owb6RBW7UK/oNchKs9KrTos6BTqd4Y0=;
	b=ZsC5j8+l+7iutQi59ZXvCuCYRS9F7DU5Bpmf0fAXL9oLJUyXnv3bbQV83FrJFHKi1PMz
	 fV2bZlLxEpg+dk3BQ4kt8hy6dHaNFSUFd9tE5yKlk59WHguARjmYvpx1sCUTAqSfa29Oz
	 TthkKgyVzq1mGegeEpXvGkc8JeoZjCvlH+iNNGI0qJCJLRXJJeYe0WGNQV8x/lmxKZBSN
	 LW9gikwWp8OKZBuOvjDktJSHuAF3qICx3j9njUo7+1EJ4nBvPxT7e2QH9U11iiy3qZNLa
	 Eadc20D6vMesl2hDV45ByFZAViKcoSwzy2NygYh2uo7IGSZe7E7clGdALD/BoqUAZ3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dnfyU1E3;
	arc=none smtp.remote-ip=209.85.222.176
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5168F606A31A
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 17:49:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5168F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dnfyU1E3
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93e64d52949so236235585a.1
        for <patches@lists.linux.dev>; Mon, 19 Oct 2026 10:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792432197; x=1793036997; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=639/CBjTq+N5Owb6RBW7UK/oNchKs9KrTos6BTqd4Y0=;
        b=dnfyU1E3Nm3ZyynIDYe2LIXyq0TkWV9tM2gE/z8DwfUsJOvlRUagtHTuZUXFZVGX8d
         XLjFFhHlMaQiE8NArosmZf8M0AxP13ZVwr384h2huJQdrXezPfAf7GB+FDUfxn1lpMe8
         s5rCGf9ECs6o2FF651ceHjESkswPOJna+TQji0xkWT5PKm4sYsS/hnvc2RWn6HXITVto
         oSSTyAjv9KrlrmwrKpNVY8q+BBEGdaiWDZ83RmSK5I7haqfDdSVfzwcR8dNqjtlpaiov
         UvlCRLgkIkILv6Shor2NkPtrDrFzZWIdqUc1gH82G3uj4ORM5MNf+ttvJAqe8i8GlJiy
         /Okw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792432197; x=1793036997;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=639/CBjTq+N5Owb6RBW7UK/oNchKs9KrTos6BTqd4Y0=;
        b=U2fWPG1Vv55Vvid/TvwiQb4Gx3E5EKYDEuU5G0tLrV02QWYp2nXAn/EgLszqMDZqCa
         WFrYJhLPd9jbjQrDVZKT+HNOA88F2fmRek9tpExNigWH6U/D/JF8wzOwiqtgSM6k5Usu
         9go4HlTJRvb471yt5cllzgINwOLzEnMTUC/ziaA4dGE651MuoE5phN0hQSNbFCRR2uYD
         MIhfaXnV4HYRaXJoAwYfQ64ol7qzf8yNZnvQTJxlNGJ32Bic/48zkM1Q/zaiEa6ZL4TY
         Tnj7eHLkVp8rcIbHitCovSU2rNw4aIfoF7NFbgQCiAf8OIpFjCvjh9s8tmcroqZ4iWpi
         mPuQ==
X-Gm-Message-State: AFq9FYJnDtxMuKn5GOPqn3ZZ8WDJo9BaJiGAhhuqIVnrSGzM/3l1j+Mg
	koXKxX0V4lfdc0yfK0JYYtDzxwmYrS1ozdQlmOz0KSIfQGjnmhdjAGvw
X-Gm-Gg: AYBFou0UUIISNlZB1I6nGFOkrlmsx6PRz5EqP2PwYeRiebESOwYzfk2d4tHpnbUCt1W
	xUBNGpfqVYybyauNmH2Ob2MgOS4zz7IHJghY/W5Vb+exOvJMu//MJeCdFsjdG3KziTFmjcE3eXY
	n3rWAy84meG6J/4TOd1gjFGSz341RdYwy9QDmnxLNY1HVBuMqMMIThrCZwj0dD1Wpb+oz+XLmDM
	2bkNR4C4aMsJqFNzshyU0uN8iLfAmv+88bbdbW3iKHHp8952dH1M48X5ZD6IMp1K9ERNGbxCHUK
	tyBmRWbGlasCNKVNUBnp5s30N5dWFlwG+gAL4QrG6T9SH+NXqa/rFhHVCG8wHfA0AtJDJLS9FFi
	KMd2fEkhgdWgTJ5O70SRIGQMX3RUtnzR1Un66qqgtxr1UuBcgARcLsVd6Zr7UhNO+LKTkS4DxQT
	4IgK2CrXFPRSJbw+XbaNuoGBvhB3xiF/6SBJaGSHF4vJe/62zwYnO5pSU7X4cMbIt5h1HENMt4K
	xWWJDrIA3l52KALXVG5OfWI
X-Received: by 2002:a05:620a:410a:b0:93e:c12c:f127 with SMTP id af79cd13be357-93f29db24f9mr1288869885a.83.1792432196991;
        Mon, 19 Oct 2026 10:49:56 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f4af465c2sm17387785a.4.2026.10.19.10.49.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 10:49:55 -0700 (PDT)
Message-ID: <41fd012e-e699-4165-8224-e0f65f4a4a8d@gmail.com>
Date: Mon, 19 Oct 2026 10:49:38 -0700
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
Subject: Re: [PATCH 6.12 000/869] 6.12.114-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261017160036.979869304@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/26 08:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.114 release.
> There are 869 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 19 Oct 2026 15:59:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.114-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build for ARM/ARM64/BMIPS_GENERIC with:

util/event.c: In function 'machine__resolve':
util/event.c:775:32: warning: implicit declaration of function 
'perf_env__get_cpu_topology'; did you mean 
'perf_env__read_cpu_topology_map'? [-Wimplicit-function-declaration]
   775 |                         topo = perf_env__get_cpu_topology(env, 
(struct perf_cpu){ al->cpu });
       |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~
       |                                perf_env__read_cpu_topology_map
util/event.c:775:30: warning: assignment to 'struct cpu_topology_map *' 
from 'int' makes pointer from integer without a cast [-Wint-conversion]
   775 |                         topo = perf_env__get_cpu_topology(env, 
(struct perf_cpu){ al->cpu });
       |                              ^

-- 
Florian
