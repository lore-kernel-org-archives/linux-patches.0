Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795103362;
	b=RvFsu0SDdw3Ux8dA88TJOSzUEfOaHxDPYcHKjmEI9GhbbFiPEyj5ZS5g1QD+0Eq+h07Z
	 V5us/b0hOqJOCJ24bY/slosOKkkkH9wBhmzgWgWopJOU3UvtIP9YAxS4sjCVWTzgeIUhA
	 4nH2QLpF7/pA3QEIi7IVbAGK98DxRkn7mYf1uDhlwuCSW53hZ5AOJ6qQy/E1I6+oOH9gK
	 /2oIhWLQX0sioxTCtEuIkpFSsGAZL5WMeJqAfSrTkqg690nUvY8xon0lavQxM3Ss6Yvnj
	 BRgohNpGhBpnAFLn5btUmxRHOF9/gIFm4ShSNPh8C3zN53ifpAhH30Vcj8UOf71eyVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795103362;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Hk2c+8OJP384F/Pb0yBXsyfMijwUYkaY/vzOTmpbXDc=;
	b=Z7nDFAYXNFIOXECA6nYGUj+aCkR2NTnkwAVk+DnQYkVxYppwFxEDEMF+tQl6lDZuy9FK
	 eKTcMqBhI59lNDMukCedbyPkMW1U8rwo9Oc2sFdBgflQM3KpgHEkSL5brX3fMHpk/EH1P
	 rnDbGGbaxt/3d9dC4Vbm6+i5qdPXZ68MX+OM9jlBpIXEPQBbRs4gTQk4wcrR3HLC47T8x
	 NMS17PvADIV1J3tUyGhu7gVT6UaPQ4b+OfAIFHh9nXC4oXwgkXFNpSTRTDAWdxPHwnuEF
	 P7/mb4Xj2XOVNHIgcUw+VLCII3eNhLPMQ3ihaBJjrdxImBsp1EqgFW0/iRIOAByE12A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=h6wNwfrL;
	arc=none smtp.remote-ip=209.85.161.48
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F5F606A325
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 15:49:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45F5F606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=h6wNwfrL
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-717080a2d50so2063022eaf.0
        for <patches@lists.linux.dev>; Thu, 19 Nov 2026 07:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1795103360; x=1795708160; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hk2c+8OJP384F/Pb0yBXsyfMijwUYkaY/vzOTmpbXDc=;
        b=h6wNwfrLC1NUSTV4hhOwz4ruf7YWp7FymFIDBxnsnrtwvhSSbmC+sHvK+jgId5x5Vv
         ip3tH1316aCO2ndWFCdblkQcD1FNudUytFyTP6NNum7RFbrBEgUr63Rmv2Qcj6dpIpBH
         z9wwDXswiLtPsprHjQVh7QcS5yymhgA2eMAzw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795103360; x=1795708160;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hk2c+8OJP384F/Pb0yBXsyfMijwUYkaY/vzOTmpbXDc=;
        b=TtgBQQiBtlcM7voVpHp18h+9zrgvPg7V63Dj7u35cZArF8rhBtdhgn4VvI5bzl8OJV
         LVoro0QvZt2O8Xp6OIAyXYE1dxd02nzjoBqkv+Os1Lxq/25BHjkHlFbe6YIvZj1RBHJO
         bUFjiwYT0ELRu6TTXUFhQsFPpS3amMGSG9GrDs6o4BGhYT6hqzXxmxpVS+MSKaHg2V65
         2xbxggOth4Hcf8pzg4sSfceHWninA5PdzY+dye6VnczbylRC7Y10xMUw2Affl8ChE0rN
         yYmFKq0S8kn9rp90rAHZkxmyv2U2G56QSuFAEe41bvICJuVfs+WnCnh1mAguegUCTiR6
         pfLw==
X-Gm-Message-State: APuU4Z8Urt8wxP8Z/GwVPP61HThEBNHahJ2yJ2IMxSp1U8/sTDwNSim+
	VMzuKNcHxMmMz8JkhVYrlUQtX2u5Fs1a6zhVneTLMlz2eJRVFt9qnJS7jCDa6C4eiKE=
X-Gm-Gg: AYBFou27aDCA7HBJAtgafdsCXZMeDP9nsVbxNI1jqgAwpkNXfURQCpcPq9yLd7bb7aU
	ysH6CklQkdmqRzlA7ISRBB3lkSSRUjJrjAfC4S4E+hXbfwMFeGLpS4OZW3yHXhYRUx+44h4EV/l
	6oBfQ2IP6F1w9cg3FtpJgFeWUI0LD5sSAjPE664FXc9F8rvGcXHyJRuxl7fSwd/5P0mvgc2LOqf
	NJdMT4eqpX7l6P2ccxfQEln9gyOYMs+UberTrDV/lcP7XSaC5eg/TFq6WUwSxCNdJEzDZXvH4/l
	rFRS8ruohBiFx7ZzRCN215jOVLvaDg4tIw8gnZ2M0z66pia2Qk6Op7jFgFFmrrecBgEaCxZT0+W
	MmH9Ab64fVZouPXphjyqbwq0PsfrfQrIBIW+m1UjYGt3J+pTzufiM1Ye7dLSPcwMrcIbcnqnV9W
	yhvaIE9XA8UrigYuOYyl/TAzNCCO3iw5/hZDooYaTUQTMLaJGO9VYash79o6EEFgNw2HiWFmug6
	iu192IYt/37j7wasvVd6EVB8tzJ2V6WxlGXerzmq1xJ87++aIWUcxQk9o06eJsOLal0tetqDL5Y
	lBkx3nNKv5ST31zysGRV6Iw/4o5e7CNvhhOlKgAL2hf0JEHKHT/zmOBbuE0=
X-Received: by 2002:a05:6808:c3d2:b0:53b:87e5:8c9a with SMTP id 5614622812f47-57a09c0fa5dmr312083b6e.17.1795103360052;
        Thu, 19 Nov 2026 07:49:20 -0800 (PST)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-5777a8a5b65sm4386296b6e.8.2026.11.19.07.49.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 07:49:19 -0800 (PST)
Message-ID: <2fc421df-33b5-4a8f-9de6-4504ac4d73ff@linuxfoundation.org>
Date: Thu, 19 Nov 2026 08:49:16 -0700
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
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 07:17, Greg Kroah-Hartman wrote:
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
> 
Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
