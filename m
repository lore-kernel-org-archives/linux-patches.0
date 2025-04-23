Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F401FA178
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 20:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745439416; cv=none; b=hu1WDErvoJbQGCro+LBPf8JFPcwe1au6tt98o5ISTCQ7gUHcJYJlVydCpvd+FcKpjVgCFKh3N9/bQrVcgS3Nk3Mkj9pdNHrBnwko8b+VumoBz/+O90AJXy7tVDiW/WOQIFoNPv9njlBPDIF+F0Vo/d9oQAUZ1jaK1c3GPSW6QiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745439416; c=relaxed/simple;
	bh=h7T8+dLPFaxvNr5PCwSx7NoiX1XTm7peKqnR6Y+iAV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DZhMAu+ieJQTdATHzVp8FpVQ0xapAcD64VjBhltzP5WgK+LyWXwfzUnVNs1Ei4Vb05pRZv5WAE/FJbUZmvtIYun9NJ6JyxCmg14ZxvaSiB+2F9Xmw7kpe1+NV2/0wkUZmthde2TBwITogoRSKPNNVSNXxPR35wRTeXmrXngaRec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=STUNekSS; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="STUNekSS"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43cfecdd8b2so1442055e9.2
        for <patches@lists.linux.dev>; Wed, 23 Apr 2025 13:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1745439413; x=1746044213; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pk6xFqDW2cX7PSH4k7StvfF5r46ogCFacc7tpRNh320=;
        b=STUNekSS8xap6ptJlkrt7jFyEMVtu1dtuNi+ae04agDmPzJ8p8RId/Pkn8K9i2Cupy
         IgEa56njozXLLSCZaMj0t2ClfnNAG9Penc9iCGfh0N55jEMkq7NqM6YK+QrjJ4A/xZL3
         OeCN38743h1freRDnu0bjZYqvWBOfNFu6CMYnH2Xo0k+dxJ3LGHwJjd+q5ec42KEVowV
         sZT0kawP6tQRnidE7fPs+/itz850rao0wsq7HjeOkAgeX4XBLmGXFqnVUjtUAn1UQRdi
         PbZE7Uxd8YGUX+qUChNLc0EbJAIgCGcDPTmpHFAEb4gbEx3Xa7+/xqrkX0UjC4TJ9dcD
         i2JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745439413; x=1746044213;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pk6xFqDW2cX7PSH4k7StvfF5r46ogCFacc7tpRNh320=;
        b=rxBCWUxAPYOFgVETQvJyehMMvEhuPlo8TV7iucZfToh2ocAUc0aqNoLgMSz12TuXXp
         9AIttbr9W1EldLFQ+LoTNtWMXXqFzoVSsdDyOBYk0IZfyWZi0jIl6sLhUcfVQiEcxTHx
         cgdKh9WuHg4+KNKMmflX6YWL3Q7TrpAPR0N4dUF20VoVn6TWV72Jag8CySXJX5aqjCXV
         pSpljF5QdXNt5uU7ufW7flruQ0X9Rav7Uq7XZOpFU8nqSE5Pz8SVVcy5WoRyhBaaqvRL
         9+tGVPYz4kIvxZ4vQa3L0qB66ExJ5hdMnYhFlrH4r5ODkiKCziSoJjaVW4xRKFpL9ot4
         8UAw==
X-Gm-Message-State: AOJu0Yzy0bTKq0kq/U79NLslHTo/MZWbkU2W2EtNqQ9pdWXQBWLb4d7I
	c9MJjfZi6d6hNeco7zEgMtconaiUw0W9Clo4V3yjtYX+bMPoznI=
X-Gm-Gg: ASbGncvL2g0JSB3KLr84pxKc4sbAmXzg6ZRyJGC5jZU9P46p4F9joKZCVevou/4fdU7
	dYFus4D1+h88HR/Xn99q/4WPV/U2ri0cuc5cA/+MuVLEwMMuKpYodJMaARna45VcawXUq9voYRj
	ERPYKKMw6WZpGhSkLw4csR+FHPHhMFSGK7V8lcDNo59IIdyaYSspj2up4oUV8ybVaOPG/vum48O
	4IlXA0J9y4ajZAQUs5SHZjyvQXMKSUWyFR22gMIWmZUpZSzJnc+BhueBlfGfxdln66MS/EwR6sA
	4zA2u9u+RIujycpc77an8OwmQMwrV/76RMmJmM8rHsNiPulCjKG2sUSsyUI0t+0DMrd14fkCbtY
	9oS5Abj00QSPMfW/e5A==
X-Google-Smtp-Source: AGHT+IG6ygyb+JLOfPMzuWw3Oq5oLqz59HuZQFAmh9OMTxU+umN9328qIdPjwtVWAQ1dcTM7yJGv2A==
X-Received: by 2002:a05:600c:a4f:b0:43c:fcb1:528a with SMTP id 5b1f17b1804b1-4409bd04a6amr102715e9.6.1745439412610;
        Wed, 23 Apr 2025 13:16:52 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac758.dip0.t-ipconnect.de. [91.42.199.88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4408d04802fsm36964285e9.1.2025.04.23.13.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 13:16:51 -0700 (PDT)
Message-ID: <2f9db195-4d99-47ff-8384-1f2f225178c3@googlemail.com>
Date: Wed, 23 Apr 2025 22:16:50 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.14 000/241] 6.14.4-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250423142620.525425242@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.04.2025 um 16:41 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.14.4 release.
> There are 241 patches in this series, all will be posted as a response
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
