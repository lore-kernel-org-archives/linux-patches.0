Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2920120318
	for <patches@lists.linux.dev>; Sat,  1 Feb 2025 12:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738412361; cv=none; b=OCc1ltbQKJdFIRBd3Q6BAoN9zAruXPTxZvoiUOZVvawJeAfBfKKwPK/Ae+7ZwFkssY+pFUP0B/aZdWdlQXafTccxrG5O6tgvMdtjoY2Jjow8Q549CyDAV+rWMJIJEpTfpH53a3qOnA5aHo5aJI1hjoIAfqe8Ku8v0MezGMQjMRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738412361; c=relaxed/simple;
	bh=Wb8pMmRQqy3Suk62MAYpZ+z15qKy2esVQmc5jfi94oQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zml1LtFtoDD2/gXpLSZnBNch8ZNWYUftWjD3p7ih+xge2tHDjKnQVxLZLG+fSOFsB+l9tNOSvrtPzBpeiOtK9mq/9gtxftkL9sP1+UCxaZVHz48/66kOboueJj19cmTL6bp+rOC3+YfA/iOsoHaxPUZ6acFb+g6CxTiLDNB3Y3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=eg7i3N8H; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="eg7i3N8H"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-435f8f29f8aso21432735e9.2
        for <patches@lists.linux.dev>; Sat, 01 Feb 2025 04:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1738412358; x=1739017158; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GYuh5DtsmGWHaTrLME5ClByDosbMcK1IaSFMaCKacRY=;
        b=eg7i3N8HMRgnZykJXIxyiDVnKZEuu0sEwpGy+ZYKAE3O0uqBeBBRO52xsXrYIUvIpY
         caW+bfWVbtKnksH/rC27cr57u07Rlpk7YadWgnSyqvS8tFJR9458Chsdk8x9DJTdqKLw
         JltHJQYQIoMAC/XV57Ce2OhDqUjAzHretZC99ITy9Ag0kF3Z7HAmg2/EIcmZMOMIywF4
         rwvBMm9pnBwU9GeLuk357eq3fC4+VU3WFn+0X2CzF1xUj0YKyLp5PNPAWtcHGZs4eN52
         sKd9FSxoXtSJHTfTLitig155hndi2wzpJZGcFRxu4iGexXI+zWZcMnt8p9lxcgIVD95m
         AokA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738412358; x=1739017158;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GYuh5DtsmGWHaTrLME5ClByDosbMcK1IaSFMaCKacRY=;
        b=v8ZB0rxoJBrV/xDUEUVlRvbhZtbUcbkexUgc68t5+3LM8lGisdvkS194z+YSDQDqNh
         RMrih9mLSfjuv8EX1xRe4X2+fVyurIpnIHetsXGeKKktI9LxXedRndtOlyhiCt7zRCzR
         GUscWcEDD4L06M0O+Q/pMICOZrMz1HhywfDxyCeB2v516/cEeBweYiwGq648UMBzJaFS
         ZTw0Yfx8wWT33OWHfueAUB7xATmdLfBJSM+8i4h1/1Bu99jyk7H5zxUTTWpZT8eoLfOi
         oJDBviqIximuzka0LSn0fA7hLlN4efpKZRKlV/E5WbagE1+ew+g91S+eHtIl88d3FXvR
         qFHA==
X-Gm-Message-State: AOJu0YyFXoJl6bGJiONOcxIg0BPt+sqoFoUSkmE3DY+lOug8yaoVryp+
	9qUHatVxqR1OHII4P73UhV0PPF1cX4HAmGpwzL0zKUhs5QllpTk=
X-Gm-Gg: ASbGnctNmy/ZaHjNYSuFw16cssnCqRwt3bAq5PM45ytfzbN5YaxZevhHl5cmE7x6H8o
	jBeBDuXLTaELDRzlaOHBBooNZ+QRBQAD67st0FoUZUhH2F6CHWrV3L7ytLXUA/4q0UaKrosqiC/
	AQMU+Oc7+uSLQiI0sQhaRhA5PndTsol+sWxywFNPFfQA1lHDWTbcHozocYSz3vFpdqUQsuZIH4g
	r5ZDExexN7FreO0ErNyVPUrR4E30C2cPsVFjK70vW2qonU6L7SRUEzkbaEH4AB3Ae1Nnp6RWIaq
	hMIxKljTVKDgqTloCmortdAG+u/Ek4aR8UdrzRF7YoEqaiOFAjsdULrh9n8hNdW8Er1c
X-Google-Smtp-Source: AGHT+IGIJyZqDzi2Uuhe2Zq000WfiFpxr+97ES3vVgwpkpirHdfzxp2zoWICnZtajDV0P4RGwWdDYg==
X-Received: by 2002:a05:6000:4008:b0:386:459e:655d with SMTP id ffacd0b85a97d-38c51952173mr11817346f8f.20.1738412358116;
        Sat, 01 Feb 2025 04:19:18 -0800 (PST)
Received: from [192.168.1.3] (p5b0573ac.dip0.t-ipconnect.de. [91.5.115.172])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c5c1016a1sm7198078f8f.21.2025.02.01.04.19.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 04:19:17 -0800 (PST)
Message-ID: <c843c84a-c158-4984-a8a6-fa7e20ec3307@googlemail.com>
Date: Sat, 1 Feb 2025 13:19:16 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/49] 6.1.128-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250130140133.825446496@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.01.2025 um 15:01 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.128 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
