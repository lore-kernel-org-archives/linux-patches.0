Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3ED51A750
	for <patches@lists.linux.dev>; Tue, 13 Oct 2026 19:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791919185; cv=none; b=XBRn8mk9qHVwxanRlcLHqB0jWLY0Z50mocBThOX2PcK2MQc7FvEvbALPTiYss6UaV/tgdS71LdqkLn1C5Zmp38PN/xBG1V7mf3hDkYvD/i2Yh0yBcsjspkVW/14AFQkNk60ICz8nalff9ypczaITP/HYHSTims0XsVbc6f+9pTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791919185; c=relaxed/simple;
	bh=Q0xoJoHTPOGkBU/ykGam9+aTXGu8sCVurjmTpYiGjKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UaGk57yc88e5EKqK4xdINQaZ9h4dDhpqAZ5GiPUWSpnpIWdK4ucHiN+1F84RDObv2nWfDU5plo3rzEGm4w4YzqG/FV1bcQ+P2DIvQwAAUH2nDp3pmoWljI2mRcUvCABZ7zv3jiJN+U6UKYvNkB4E0jL1nu3L+GwjHtGEoYnMX6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d+nvoNBa; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d+nvoNBa"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93ef1a2948dso180985585a.3
        for <patches@lists.linux.dev>; Tue, 13 Oct 2026 12:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791919183; x=1792523983; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pfgvs3MJEbW2BwnwAhjd9SKbBYEufXUXojUMotaCz9A=;
        b=d+nvoNBaF0wcitHyXu796hJ+FuqkZemUPc6g5oTovLDSiFryZuSyS792xu/nLWYA0m
         4iFvzoZDrLgPeN967Gh4GpyH8jsj9Vu+txd0j9qPUV/QF0RNLLN+ZGjt5YNbU7UZ/1Ah
         1OzVdr5htmOJl5R8IHdHlGPX7YMVVZvtZfj0XOF9DZ2kbuzeEPQ5u1pdRSlBeTL+SywH
         4oB/ZSyjORTfKq15XdW3ZtDTQfsA6YOwlYJLrC4+w3c1hVSySQSwziL5d/G6l+Si/Qbs
         KyretrPtjt9d/2JyriVRYLXmltlTwDM3hb5LLgHHZhkSqBaxeowbIr5OJoh6jP+lGd8w
         ICUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791919183; x=1792523983;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pfgvs3MJEbW2BwnwAhjd9SKbBYEufXUXojUMotaCz9A=;
        b=yrZwzt5QMxcQDRYGT/gSWp1f+QdSrymoddwJRPkpXfsNgviVCxgW9M1m0dSOoXd3Zf
         Jqz/rPbqjirfnJpLRr3VKjUHiKV8ODftfm+CnK9Lxc1ykkdNgk5G/e0hvaqxH7Fzzb9O
         BGVoYAB30VEDNIqMLFl6cCgZ2S0Wumunmyl6Pl71y6ZAURbLnCrjYKa2eC+6BNM7WL2K
         c5GoZ3Wl6ZcicSUu3O5o9MExenWA3QkNOGDgEmvnNgslQ3ufcEqLUoM0qTPb9KufBKpt
         Gu2dEO42v5tyLaFE1Vmk6k2/uq3Xx9GUiQ8rrbyohxZKVL3qmgKhAEFqBPtoHZeEPCxe
         Ao7A==
X-Forwarded-Encrypted: i=1; AKwUvBwoWL/7+86xTSBfFrr3ILehKjnWGyu6xBNam6SZoBQY08NFbUVdLXOBCGyWGpUOTTZjZJwvF2+s@lists.linux.dev
X-Gm-Message-State: AFq9FYJCQsUznWV5bIpRCDHXmoz587cO2jo5sGFH9rHyq632X9mPV2MO
	fatC2RPFCm4mRhNSnrxlYwYYdoYL7ZDjMKZjponL9BOrNBR4Wywqn5YP
X-Gm-Gg: AYBFou0OLfBQblAFpJUZJXPgq7P5I9cyKKQeFEoe+aGTbbQwKl5h6khtnfyNH2ODMAb
	uSCiFyltEF7g/QSwRKcyTgf4mmE2m3X/frS9j4PGyeY8RFzVEN/BNNlucEkPbvn8EP/UsyjND/J
	bD129nHGBD6VJ+bcu9hQYKalWRlUe/gd5ae6D7ODM0hOkZrQAxCbf6TXMIzywO7l27K9Xi6OrOO
	YbL0P2nvzlOOIjJkp3uBq+nDtak7aB4T9FanL8/ssUCy2N5NxHeCmBHTVizn8+Tb9eucnTJ7w7h
	Jwls8sf6FNW+tEcRgYd+DT5U7C3E0hSyeLYDEk1lrENeiMyQI+kRzBWHBtZhApCtsWBz4q7/rOL
	ZutNwTquBwfgmH7CiVJZaIQJkwaJcmkVIXbJL7LoWNZMuZ3wZGBhxzctPmFPVG12L2aCsXmRCVc
	gDN/Wu+WeTYAa/7u0MTHmBfiHp6Jvqv3iv35OEDBOydHGwFM2Z914cQm6SXskso9cfBnb6w+o4P
	pC70QZHKNu9ogtQblmD+zPx
X-Received: by 2002:a05:620a:6606:b0:93e:bcbf:4ad with SMTP id af79cd13be357-93ebd24d7acmr2270223785a.33.1791919183457;
        Tue, 13 Oct 2026 12:19:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef5009b87sm305039785a.11.2026.10.13.12.19.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 12:19:42 -0700 (PDT)
Message-ID: <0b797c37-afae-479b-b84e-68bcd8369f4d@gmail.com>
Date: Tue, 13 Oct 2026 12:19:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/621] 6.18.57-rc1 review
To: Pavel Machek <pavel@nabladev.com>,
 Brett A C Sheffield <bacs@librecast.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261013112920.855194808@linuxfoundation.org>
 <as4kGIjqjrKzu0O0@auntie.librecast.net> <as4ubep0jWRi-b2G@duo.ucw.cz>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <as4ubep0jWRi-b2G@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/26 06:13, Pavel Machek wrote:
> On Tue 2026-10-13 12:29:12, Brett A C Sheffield wrote:
>> On 2026-10-13 13:29, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.18.57 release.
>>> There are 621 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu, 15 Oct 2026 11:28:22 +0000.
>>> Anything received after that time might be too late.
>>
>> Build failing on amd64:
>>
>> /usr/x86_64-pc-linux-gnu/binutils-bin/2.47/ld: vmlinux.o: in function `gss_krb5_get_mic_v2':
>> (.text+0xfc2762): undefined reference to `crypto_krb5_get_mic'
>> /usr/x86_64-pc-linux-gnu/binutils-bin/2.47/ld: vmlinux.o: in function `gss_krb5_verify_mic_v2':
>> (.text+0xfc293a): undefined reference to `crypto_krb5_verify_mic'
>> /usr/x86_64-pc-linux-gnu/binutils-bin/2.47/ld: vmlinux.o: in function `gss_krb5_aead_encrypt':
>> (.text+0xfc47a1): undefined reference to `crypto_krb5_encrypt'
>> /usr/x86_64-pc-linux-gnu/binutils-bin/2.47/ld: vmlinux.o: in function `gss_krb5_aead_decrypt':
>> (.text+0xfc48f8): undefined reference to `crypto_krb5_decrypt'
>> make[2]: *** [scripts/Makefile.vmlinux:72: vmlinux.unstripped] Error 1
>> make[1]: *** [/usr/src/linux-stable-rc/Makefile:1272: vmlinux] Error 2
>> make: *** [Makefile:248: __sub-make] Error 2
>>
> 
> We see same problem here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/17139116508

And here as well.
-- 
Florian
