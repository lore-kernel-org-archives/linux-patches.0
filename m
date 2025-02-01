Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C7320330
	for <patches@lists.linux.dev>; Sat,  1 Feb 2025 14:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738420771; cv=none; b=Rbl7234ImHu2F4AalA1uZPX4CENYppOObCWAp9flZLveRZoUN/rNXA7RRYTdcCNwD3EgikCKGBjgxRPj3ZFBakuqnAmTwBrbUk4Ndz553ezNQeRAU5nINBxXDT1hx5pNMt9voK+GlI1E9N+tQgeyYYre+YJXsfGWx/ukfg1Vtdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738420771; c=relaxed/simple;
	bh=MEcjYjOqPa9vjrEET5puEAOgzRJHK5aUL9+E6N8/G+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V9QtLTD/Y+M31cXvz6JA8VuntaA50WO/M/DZbKgOY9dtblPABqQt8UZdIGywUA8dav6yjsgCY/sb9ic9ruP5euhA9OwBcx/3PTWE57r7ID2J9jWAn6J0p+Jt+pQNiEf1vDQHcEIn5kKhIx7iI2yM1cIq/N6LgPfyXYOPuS7NMN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=a1Sjpwbt; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="a1Sjpwbt"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43621d27adeso20447415e9.2
        for <patches@lists.linux.dev>; Sat, 01 Feb 2025 06:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1738420768; x=1739025568; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/6hnx+/tNpmWLZW9Rhhbh206Hg2Zd1A0pWkkU4yP/J0=;
        b=a1SjpwbtJBG1MVoe+7KtBGQxxjv3A4oE4SouqgPnEIA+zso3EMxWxi4TQf58TudEct
         pa2iOyC2xdrIKD34rxaqaFZhy1ATBYa/2sSiFZKRWmZYawX2f+sUE3Txe0OM81XsViwA
         raI3ZfXORGaTABTLwWqByPp/K+iFbFzFXFy7ss5JtafE8p/sgu7hGMD1iz1OMauCXEBs
         0sroSSD6KzwuoNmZsGIVze96mHD1gr8DgRKwHbO1bXQTB/rgZ4GRcfUr8B9gs6Mmfbrh
         dVacs7XJmhSseLs1zhPpgetT4hYG0LGpDhwYnbMs7HFeEA/HdrqMZTWkDCgG0gr05sfp
         3qiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738420768; x=1739025568;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/6hnx+/tNpmWLZW9Rhhbh206Hg2Zd1A0pWkkU4yP/J0=;
        b=Zmkq0zpw+TbKXSHrk11BA3VaHIMRoS2V7GF2ictOL7fnSnRK5lvD8YgjCKm1dds00y
         XIR3rYszmhgdaYWvmhLt6elEww+mBcrbBIxFxPYPgZqwGZH6y9OUKf8eHq3XG1SgOZ85
         Jn6o/+2ts2tMIv05OywkfD8W3QaiCwG36d2nTnSn8P/JnnhgL16XIBObi5PmQRWRfZWV
         vgWxCd/3/U4uooTEK/uUybwFmetsvWJbZFtoX+aaceqfXPqqR+yA2nEP+7NN19SnJbEj
         NfSAG5z771msbW6FeesHJEsgr7dYmxgeYtaCOeHLN6P0dsauHkKpvJLT3VBvxLPD5zfV
         g9rA==
X-Gm-Message-State: AOJu0Yzv7krTeXRxmvoIPHxwU2iH1opKKIfeG6ViNeTZ93ZmhtB+BKx/
	hzk1SOo912WW+WR4Dzz3/JuemNuYQ4ERShyanQxbFEjKwJP8wSk=
X-Gm-Gg: ASbGncuggzJru5+fyCDTCPvVc/jzuHNBhnb3OS0u/stWYHrGdR4j0B53Ve49/Y/Wa5f
	dVyKUvtceVzjJflwkz3Mh78FxpLUkfIMZT0TnpkweBEdmm6T1iTYCyp+xXOmclaiIatVoJMNa3o
	1v6VeqYJnrj5t0A6zsC+KsXFIZnz94SDSOTP7IWZPz2wR2vkAJ0lSMsAX7b91v9zVSOtPJn1p2N
	6sMRp8lCDM7/SUOGEx/Zm1Bwcsf0S3nOumW/Zq4TXKIZcHqDqy0n9Lug8hmT4XxH7Td2zBjIL3G
	Zl5gX5TkbTTuCHhqqa229It3ujYaOa2UbG6/ogkvT8UdcVJBGGBIg6AtKAgWqCqVWYu1
X-Google-Smtp-Source: AGHT+IGm7vkxAZkYSTFDa4NiuVf23NintTcjcAqBgVN7dN+jbTT3piuvuN1OOhgxg6aSccATYQhpPw==
X-Received: by 2002:a05:600c:46cb:b0:435:9ed3:5688 with SMTP id 5b1f17b1804b1-438dc3cfab8mr135468995e9.18.1738420767413;
        Sat, 01 Feb 2025 06:39:27 -0800 (PST)
Received: from [192.168.1.3] (p5b0573ac.dip0.t-ipconnect.de. [91.5.115.172])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438e23e6a4dsm88565935e9.21.2025.02.01.06.39.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 06:39:26 -0800 (PST)
Message-ID: <72e0568d-85ef-48cc-a33c-46e0bd35c24c@googlemail.com>
Date: Sat, 1 Feb 2025 15:39:25 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 00/25] 6.13.1-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250130133456.914329400@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.01.2025 um 14:58 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.1 release.
> There are 25 patches in this series, all will be posted as a response
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
