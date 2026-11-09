Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794254678;
	b=TAsl4q+iAAaL0wRKT1DbDAjKT9WGrrSbGg+2atwVUfbtZYx35rFnQZl65vQzUiR5LUll
	 zdAxhPQKzcbJ1nt1Y/OjG2knuQTgAJvH/dORhtLdv6ATxHYSaV66qXB35h2wOh5nTN9OC
	 +w3cKEodXWs2RpltGRcqZGlNFDQtI3adlRo3MdQhPhh/2ekYkhvUqWtlFAA9lovbWZfHZ
	 7uCtgAK7cLwWsvZScLXLE1wFcqpYs4E6L44zCzar6613ieYXua7xyGB9wwg6znrv+ps6X
	 82WiFEPGY4tC6qH20bHz7LLzJ2FAZpoYDjOCHKq7RywfoONO8Y4Iq8OmbIKaLrP7odw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794254678;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=xd+uOmFlCTqBx35VwbGKRTAdMuAG82Z60bA1tWcaoFU=;
	b=oF/0hcolNLALkZsrxL2Hj1vvg5Pp/vMow/y1diSZ8Y1yWKHgtK79QrXq4YJ4HS6t6Bw1
	 7YRUObAylwIfHB+xc/5uV8zW90E60U5QNBCOtLDrn0MjBUQ82kwh+G1SB8Bcpe4jaV3ku
	 EySlxFIU9FmIiQD3zf2m6rP6GcaybQu+Ww4JG0HI4ly6cwdAX44lxAAz6261wBWKEo5cu
	 JKRamALP7Nx35IoxY6/hrb4viylFTgVcaSTUPAgIZcRbubwQMB8Ikc7lBqdCI8FHLTxg+
	 WrRpFKyqu/kn4ymgVNEOUE4EG5zWjzIvsIiybOD95kB6yx41fbYvDNe6ElIHfnKfYBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=SoVjYlje;
	arc=none smtp.remote-ip=209.85.160.41
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F7860A2605
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 20:04:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3F7860A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=SoVjYlje
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-4911df1e196so657491fac.1
        for <patches@lists.linux.dev>; Mon, 09 Nov 2026 12:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1794254675; x=1794859475; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xd+uOmFlCTqBx35VwbGKRTAdMuAG82Z60bA1tWcaoFU=;
        b=SoVjYljer3uNX4FKQ9cMxLT4qmxYezd8WBgxc+BfebA7xM2R2Y1HW0r02Z1x4Pia0j
         S1K23lNiyiHGtt5yLDPx1zQzSXZaVDQc8oEiTDr8+ZGK1D98i+MWWoLsk+gGLdrXgMel
         WqvcJugzI9gM+76duR65wVwbno2OkO69J9oV4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794254675; x=1794859475;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xd+uOmFlCTqBx35VwbGKRTAdMuAG82Z60bA1tWcaoFU=;
        b=pDPWhTzqklrxNWni9gX0nLThymkmGvgaTFlWQQCAjUJTnYx4NMX92bWKNDHDCiErPq
         I4Lia99yInof8tierc/veu9x4M6Kx6fFOWG7MEfLECJAEiol9/GWtSkfOhOCdIpdE7Ct
         lTYvjDetb7lv8IqMbcHLUp1gwgB6V4YmUWyMFZt0cTE6Mj1+hR1BgR1AUZ4nbaPgRnnv
         OQy8ItCSShsLkWha5xt9Pd6OY56GrL/+Mf19+XtmGNPb/E/YR2mYuBN20zJGBjjVxpxi
         7IpR3FQad9SxjNcQxnXOoCrFniwLScfVZ10tXh8MeFF7z/o9Zb6hwzl1nn2Usmuf0sNX
         m/Tg==
X-Gm-Message-State: APuU4Z9LjhQvztDHFJWmxX7no5dTNkUJ7/s99T/fB16pR5QgnXS7sweU
	4nzo6P1jFBYR9pHZt0g5ceeAvYjlUnrTQs/ewT1oV4Ju7FC6kOyGBodggGPi1ty76Ig=
X-Gm-Gg: AYBFou1MoSIzHyae90QKwmonXZ0YvDBGx17DrkdGo9W5ApytFg66potPIJKyBbp0dgq
	cTx/SuLvj4aUHg7EIeLEAuqE9a3rs3Qh/bZ7ZUplQWMsgmepN1KwxL0gEmosyx6hIyvcTVjvjO5
	o13gXtVxGNlha/IOYNAdZqbnh6IVOsG/MdhKhg94YPkKPFszdCd4fJjBy2Rj/GVfk7Wj/Lnqbhg
	RdOigk3RqsnlXudI2rB027ckN5P0j22FMx2BUm/mxpSolwZ3xTCslzgGF5T+MCEIF0f21Sx7fq4
	CHYLUhPbLBXbOxbb+VBvxPE71vZvUg0ffQi6lcAPwgfImQOAgQVlzj/QztFQkJrY4KjvwNYqZVc
	o9golqISA13U4V+m6oNaROH27wtPnMYYJkp6Chqbo8rYngvFP1uw1beNBZnngNECKFU7mPD+efe
	MnG1hQOENPtaeYrPQiWRqL/EpORtLCYiaEblOLhU2XK89uscFWxGni7TIVXwIjt/kVXn8wN9hjC
	Lpg16k0KxTNaBGBIyTB/avVBwosBQ2kE1z4TlQTXSC3bdkn5SQwndPu3g75HRkO6ciuEvi4AA+h
	8h2NyeZxh3ycpKFK/bIwGpeCWk+9lJm988gz
X-Received: by 2002:a05:6870:b4a5:b0:494:a2cf:8dce with SMTP id 586e51a60fabf-4ae222eb9f3mr174206fac.4.1794254675391;
        Mon, 09 Nov 2026 12:04:35 -0800 (PST)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4ae22d1d541sm114412fac.2.2026.11.09.12.04.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 12:04:34 -0800 (PST)
Message-ID: <5dc4a979-d814-44de-bb4c-8cb8141a6f0b@linuxfoundation.org>
Date: Mon, 9 Nov 2026 13:04:31 -0700
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
Subject: Re: [PATCH 6.18 000/869] 6.18.63-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/7/26 06:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.63 release.
> There are 869 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.63-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
