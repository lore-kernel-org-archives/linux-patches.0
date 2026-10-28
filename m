Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793222774;
	b=r80G1yjxPhEIkFZoUVf1lRV1G9vf/cERS13kTqkgeP+whhjIrEWobfw6xsVz1ZXHgRaS
	 o8wxadQtb+xqkBzNTxzNJdBgp6PHhVylpxgBHhuQeBrkdLV6bfQccux0AEnyYPLNtqXbr
	 +OIulL8cD5JN5svO19y5JwhPK0sM9HJv7Zh2SEN9WyKKH9CPeWB4/5FcUGW14vlkPYsQp
	 AVsrUD7a9ARkvqOm20Bf0AX/MXHPP9ypPubWoSA0VkxFqr2DJPcHNqZFc0XFmyEZRZE+6
	 mkeAMF+TC8jaaHGl3memZKTbfd41WeJ75AS4QX9RuuJMhhqXd+yv4AnXNT/pPzzvylA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793222774;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=6gvvAaf5oqzPrIz/4nEh4l4rMyZ25yG9p051XezDf08=;
	b=s9pAHKMiKxJ2dU6BpFDa4v3CZz49tduVIE12CG914eGd4b0N/jBRfI/L2DtU8R/tzxGm
	 VYgLmj+qquxGjAccBbB5FzXXG6vKSjYOjFqEKbQw0I0Nkg5IgxFukCq81GlZWkZr86++V
	 CPTG2iCzQ/23l4OZvW0gTC3ryMIIWnYUfrnH7nOsvfA9MjWz742U+SVP09hBDkP5Jcy6L
	 tDRBBr0kWP2n5RkNo74wUldqu1HoWcviZfbcmWk1Gu9BLh8fkxobc/hAH9afAcfarXFD3
	 +tkkHMtyvOb4DB655ZhQtK9oH9PNEPLPdF44xjCPiiyqJ/RlStwYzVkM6rcSgoD+zlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZOJZVmaY;
	arc=none smtp.remote-ip=74.125.82.43
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445FC606A31E
	for <patches@lists.linux.dev>; Wed, 28 Oct 2026 21:26:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 445FC606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZOJZVmaY
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-14394530ec6so1700660c88.1
        for <patches@lists.linux.dev>; Wed, 28 Oct 2026 14:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793222773; x=1793827573; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6gvvAaf5oqzPrIz/4nEh4l4rMyZ25yG9p051XezDf08=;
        b=ZOJZVmaY5FHA8C5Xn3vKakOv7YcBE8wygipgBmFzHyz45WAekzZS8w7JwRlWksUzz+
         F7oiweujPA3FAwqh02/cu1rBazW2FsSMobdBT13UVPLvlcBwO3JN9x0vYPkNnE9F5pbO
         +NhPXkwefnH9e/qrrjzVlUoqeAXVYvEiR7FcV6LuamL+KogbRwx1RilwsaoOu/VWFzO+
         J/BhThHz35uKftlOxOSRvgetfJJ3/beRjKsNlz6Iqh+7cSztqcIy/+Uv1Ns6CgxmG6JC
         b6Fnialffk+nGMKQ1F8LDeuY7JdtpLpsSosFcJJDPzosiOwi5c+AcnnxdxJajRebL4/2
         7oQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793222773; x=1793827573;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6gvvAaf5oqzPrIz/4nEh4l4rMyZ25yG9p051XezDf08=;
        b=ek1A/PIJWKhpAKF25+eFY1zSpGA8XqE7vRKyC+8wXrWmvYq554ZeSi386VbC1o3y/L
         zugbk+W3k7TDqr4RtkBb9LKFC3I+A2UNJ4mrgOSVcVKRSfVqYoARuru5UJ40BQjwFJWY
         sJNfwxsbF4MLwvasDtKqGCeXvXay1vHLk1eVVBDNiB9qjVWbK1iJ2ZaDIvLm4hOMK2YP
         HByr5pYEkxoFnFNFfB/eP5ZBIkNuQruqvLWVQt7xiYOXyeC/LLKmNC+S17km5SyM5nTw
         xABdex+fPKvNu3JTUoQBJcjjMk+31PEbpPzG7S5K1Eo2FggMrRROzP//KtUYPYyJQLhR
         UD+w==
X-Gm-Message-State: AFq9FYLN0VVq+AnHbo5wNw2ZVUY3wIw18Eni234LRgmX9VILeqgDBbMl
	owDsvLUI57j5Wzn036QrlhyCCDnm0aj1CJjRcxEExFfbWn9ffYSihryu
X-Gm-Gg: AYBFou0cXfOVsv47E0SxITgEqZUGvWbDk2vLVmH6IGctuuTzqVo9hD6pjuS3KH/RfUC
	nXBhK5MBG8QNJS9+de4QeC3UOrrNMTMQrpalWEz5m1g/Gz7XhfAhvlpdWpU0AfcPoxCWVY/Kbd7
	r6BJKlai1/36x/d7ohOiG7CMbfkx4iwDmh8iy1XvU79Ew1Aki/8TXqJGfWSVc3RbnIabY9eVIQR
	oIwkKjzjmE72u0yDMvgXYx7QYlNiSYRxLLwD8K3Fq26RGbEdS/aOSlV7uWJ04B+3fPlpQdSOj9u
	PtCnliUpwhjGFsra8JClWzsgYwtuw28J79LXrUJGmzDYzqEzQ0QKGBcQTY3zAcMpxllRQge+fXx
	c16AR2pRMJbgVjL+cN+hqjE5ZMDhXjsq+IAKcOQx8yzNYzSdUS5yCijsrtcJg4zM9UPlPjoq4Fi
	I0Pct9HCpSiF7UdxfZnzjISr4xiyMR1Mb4TfMuCa7qk7LL/aFtnRaWYsFH8UgybNOl6RHWAodU8
	zVCSDmE8dK5VHcXlkiZygDkfBmUzrRgFzxObQdCZF5dvzxNRngIKURCfDedqs5uDvhF7GBCUwtA
	ECPoJGPZvvyFfSYka0kW7emqjvfgFurEI1JPnS0e980RmoR+uccrfccw
X-Received: by 2002:a05:701b:42d1:10b0:1a2:6b9f:f7e1 with SMTP id a92af1059eb24-1a6ced8ff72mr4944038c88.14.1793222772917;
        Wed, 28 Oct 2026 14:26:12 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75d76814bsm8109314c88.10.2026.10.28.14.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 14:26:12 -0700 (PDT)
Message-ID: <d989cca6-f049-4c87-bacf-8a6a4832dfbd@gmail.com>
Date: Wed, 28 Oct 2026 14:26:10 -0700
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
Subject: Re: [PATCH 6.1 0000/1887] 6.1.191-rc1 review
From: Florian Fainelli <f.fainelli@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261028170459.200466217@linuxfoundation.org>
 <f09f94df-c5e7-45d5-86a6-50be145f6655@gmail.com>
Content-Language: en-US, fr-FR
In-Reply-To: <f09f94df-c5e7-45d5-86a6-50be145f6655@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/28/26 14:12, Florian Fainelli wrote:
> On 10/28/26 09:34, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.191 release.
>> There are 1887 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 30 Oct 2026 17:02:34 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/ 
>> patch-6.1.191-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable- 
>> rc.git linux-6.1.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> The ARM 32-bit kernel fails to build with:
> 
> In file included from arch/arm/probes/uprobes/core.c:9:
> ./include/linux/highmem.h: In function 'memcpy_from_folio':
> ./include/linux/highmem.h:427:21: error: implicit declaration of 
> function 'folio_test_highmem'; did you mean 'folio_test_hugetlb'? [- 
> Werror=implicit-function-declaration]
>    427 |                 if (folio_test_highmem(folio) &&
>        |                     ^~~~~~~~~~~~~~~~~~
>        |                     folio_test_hugetlb
> cc1: some warnings being treated as errors
> host-make[6]: *** [scripts/Makefile.build:250: arch/arm/probes/uprobes/ 
> core.o] Error 1
> host-make[5]: *** [scripts/Makefile.build:503: arch/arm/probes/uprobes] 
> Error 2
> host-make[5]: *** Waiting for unfinished jobs....
>    AS      arch/arm/lib/csumpartial.o
>    CC      lib/math/lcm.o
>    CC      drivers/video/console/dummycon.o
>    CC      sound/core/control.o
> host-make[4]: *** [scripts/Makefile.build:503: arch/arm/probes] Error 2
> host-make[4]: *** Waiting for unfinished jobs...
> 
> this is due to 341d4e6294d9 ("highmem: add memcpy_to_folio() and 
> memcpy_from_folio()"). We would need to also back port 00cdf76012ab 
> ("("mm: add memcpy_from_file_folio()")

And there is this other build failure caused by 997f9c35fcad 
("Bluetooth: MGMT: fix crash in set_mesh_sync and set_mesh_complete")

net/bluetooth/mgmt.c: In function 'set_mesh_sync':
net/bluetooth/mgmt.c:2188:36: error: implicit declaration of function 
'__struct_size'; did you mean 'struct_size'? 
[-Werror=implicit-function-declaration]
  2188 |         memcpy(cp, cmd->param, min(__struct_size(cp), len));
       |                                    ^~~~~~~~~~~~~
./include/linux/minmax.h:92:27: note: in definition of macro 
'__careful_cmp_once'
    92 |         __auto_type ux = (x); __auto_type uy = (y);     \
       |                           ^
./include/linux/minmax.h:105:25: note: in expansion of macro '__careful_cmp'
   105 | #define min(x, y)       __careful_cmp(min, x, y)
       |                         ^~~~~~~~~~~~~
net/bluetooth/mgmt.c:2188:32: note: in expansion of macro 'min'
  2188 |         memcpy(cp, cmd->param, min(__struct_size(cp), len));
       |                                ^~~
In file included from <command-line>:
././include/linux/compiler_types.h:387:45: error: call to 
'__compiletime_assert_741' declared with attribute error: 
min(__struct_size(cp), len) signedness error
   387 |         _compiletime_assert(condition, msg, 
__compiletime_assert_, __COUNTER__)
       |                                             ^
././include/linux/compiler_types.h:368:25: note: in definition of macro 
'__compiletime_assert'
   368 |                         prefix ## suffix(); 
         \
       |                         ^~~~~~
././include/linux/compiler_types.h:387:9: note: in expansion of macro 
'_compiletime_assert'
   387 |         _compiletime_assert(condition, msg, 
__compiletime_assert_, __COUNTER__)
       |         ^~~~~~~~~~~~~~~~~~~
./include/linux/build_bug.h:39:37: note: in expansion of macro 
'compiletime_assert'
    39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), 
msg)
       |                                     ^~~~~~~~~~~~~~~~~~
./include/linux/minmax.h:93:9: note: in expansion of macro 
'BUILD_BUG_ON_MSG'
    93 |         BUILD_BUG_ON_MSG(!__types_ok(ux, uy),           \
       |         ^~~~~~~~~~~~~~~~
./include/linux/minmax.h:98:9: note: in expansion of macro 
'__careful_cmp_once'
    98 |         __careful_cmp_once(op, x, y, __UNIQUE_ID(x_), 
__UNIQUE_ID(y_))
       |         ^~~~~~~~~~~~~~~~~~
./include/linux/minmax.h:105:25: note: in expansion of macro '__careful_cmp'
   105 | #define min(x, y)       __careful_cmp(min, x, y)
       |                         ^~~~~~~~~~~~~
net/bluetooth/mgmt.c:2188:32: note: in expansion of macro 'min'
  2188 |         memcpy(cp, cmd->param, min(__struct_size(cp), len));
       |                                ^~~
cc1: some warnings being treated as errors


We would need to back port 26dd68d293fd but this does not apply cleanly.
-- 
Florian
