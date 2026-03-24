Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226031531C8
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 00:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774312459; cv=none; b=WVeQet518XR1clE2wgxz7OD+ESsEngumFXEopD5L/fAGgrx7jBm01t6PnLji9bb0niIe9O2fpIRT8CLVhbhHp6FXeAYsJZNt0psRQOKspaS/w+Dccros0Y9kT9ty8NGkP7P0ZlbV0umadnYsGdRfcIYERQXeRpisEaYliVMGFXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774312459; c=relaxed/simple;
	bh=e9cmT+8yC1HLkW4WiReOSEgL9/ZpjZtKaK9tTIx4JsQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m5LVHiEfpdIlJq5jYoDPTPSu0p8GTeIPZjQh4sY5dTlLiN7yrY/5tBKJqeGLIQSjsD4j35GWVMHwDOmRevFJtBLd0t734MjdLxFgFviQW/gkoxZhmHcxzwd7j9mP7TX820touwAKlLIjeqLw4OKWiGmOWwofECsrS+8l0O1P3dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=mxW1wi6n; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="mxW1wi6n"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50b392f1846so56098701cf.3
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 17:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1774312457; x=1774917257; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RVGO6eoVEJAXwpiX89IpNWdNPL7kVxGIwYfKpBDgDJM=;
        b=mxW1wi6nvgcsTF2EVQ8yjtbZSbml6MGqZnpRLF1Jplrnz9F4msQSBeUfipzJ4vlNh5
         7Ta4BGKfZVgXMpggsPIk3jCVLqlM9KsWEGsLIa7LHu+C+dP1QZ1VQfjleVVZfomIJRlK
         2mljJyBEwPDSMCK7+/W4LqksmI5k+XFDMH1OAXFSBDolxwLKOpBfyZ14ETmgm14DXmDj
         rtdBr0IkpbXZVIURNTAUP+Dmr7wdSwDZ00/aEN5SlBMZqkQvST7kSp89hEFiz8Am4Tgj
         zd4Wx+2lvCCWZVIoU53HpgSfNcOuy+pZ6yrxyCcPpsNxpgaSun9hheK3ZXyKgzKgPwJu
         p1gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774312457; x=1774917257;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RVGO6eoVEJAXwpiX89IpNWdNPL7kVxGIwYfKpBDgDJM=;
        b=pCiB24zfv9u3XB42mye0FrWb2UOXMJeJs6hd5gIzCiz20B4bM3oaeI6d2VL+HDSRfv
         JBbFcoy8YMoYAslbFxYhKEGHr0p8OENzIFH2mOBS8e8h2P266Pvo2WBT24jM3oHUTMoS
         N7HP3brOe28s9M7cDoXxCdv79OEVLfxRMyG7LMuIgeqEk4UseF6oF/GLovOfibFB6COy
         hdoz1z37toqqnVWgjUluW40ZbwtSA3pJTq9zszAgg5GzdF3JDuiry0ROVwZev5iIDeN7
         hdmGm8IVooRtA9c/iofvJW3IDEbHz/7jHozKsMfWisaRmWPFesBRe55ELair7WPaYBxU
         6FNw==
X-Forwarded-Encrypted: i=1; AJvYcCU6ylUk8zUaOqFUJFARBDkjsJO7ObSweB83Li+6qy30zarRh1AbvhiH4n6dGynhOu86p3DSIGdW@lists.linux.dev
X-Gm-Message-State: AOJu0Ywhm02T0wxGJo2ShgAPwGb5+wEsWcTRVkeFYqKi+ii2rJQi/Ru4
	XEZfRDxfSZeuBIGxB+3SCgmcTXA+ZU3zbVN9J8pdjXSq4/nmKI6zoBW++1rxuP2CAWEpEVtMjqf
	6WFpurCfK2qH1O7Qafjy9DpPT9IHRuyNZnMFtcMGGp5Egry7WBRm4Iw==
X-Gm-Gg: ATEYQzxDLaH5Phrm53mXnLmFNApMWUiqfoXRO1jUJZCmwRd3S8HawBF8VoTvOu3a/if
	X26jgkFtPYrwR7MI/nmTM7i7rMI2bfazb+65Cc7XTDLKvhq/8ogVRE5WCVrJa2StPELx/U9APdk
	fallcvh0HDZ/B2rL0HjsmgYbmL+f6URP7XTYvZvR8lnKx1yF7UbbrTQunocIfF6MWmlexgodDpQ
	VoUM0SUE3cqTwht3J64biSQbEfVLi9IZfPNYfuyt7rYV+wCSrhU0/uUgSk1dPK91jRoozPR7KS5
	vqu7iwoNdcyCnY5Pn73tCOYiSKIHnOp83HSQESCfNVSS0XRUCJ6pzVvu2Oh6zKW6oRWa6CTw8i7
	abAHzR3A8eOoVnnRnCY0HXHAlt5f2LOpI+gPLKko40Kk+gYgLYGH+nqZBZRu1lEnAmzXV/BuMJV
	1h7kslJhcp+cFOImxXsm0JQhIHeLkt787BxEzhpU/AVa+oHyik43z6fyz7JniYuls2MzLPaAkcw
	g==
X-Received: by 2002:a05:622a:4294:b0:508:ff31:47f1 with SMTP id d75a77b69052e-50b3756f294mr208993621cf.50.1774312457107;
        Mon, 23 Mar 2026 17:34:17 -0700 (PDT)
Received: from ?IPV6:2600:2b00:7880:1d00:a5d2:a745:535f:7b72? ([2600:2b00:7880:1d00:a5d2:a745:535f:7b72])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b36d04889sm99146351cf.9.2026.03.23.17.34.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 17:34:16 -0700 (PDT)
Message-ID: <4e772b69-9c46-4da8-8760-dc7db763c7e9@sladewatkins.com>
Date: Mon, 23 Mar 2026 20:34:14 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/567] 6.6.130-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20260323134533.749096647@linuxfoundation.org>
Content-Language: en-US
From: Slade Watkins <sr@sladewatkins.com>
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rogueport-AntispamServ: glowwhale.rogueportmedia.com
X-Rogueport-AntispamVer: Reporting (SpamAssassin 4.0.2-sladew)


On 3/23/26 09:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.130 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.

6.6.130-rc1 built and run on my x86_64 test system (AMD Ryzen 9 9900X, 
System76 thelio-mira-r4-n3). No errors or regressions.

Tested-by: Slade Watkins <sr@sladewatkins.com>

Cheers,
Slade
