Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BF72BAF9
	for <patches@lists.linux.dev>; Sat,  8 Feb 2025 02:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738980831; cv=none; b=qk86Kv6tlLUrGWyYR0mRqiEqJAy7z9ovu8F4Y7lzNf/tJqZnBjurdp8PQx9lUbn4oRBiockQE/U9U51Sf6PXPzg58rWG9p7hA+R0PlcqRv7hv0wi8lEM+oHYvvWUZKHXwn6U3m9OSfktbET1vqcUhI6e+Tkt2krtPpaQ8xRu+kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738980831; c=relaxed/simple;
	bh=yeOAfOTcWI69kvo4UfVbd63U27LvdUDiuNEX53ysFZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qKHBVTLofhl9Uf78LyCLztlwpBy2I76UbTOoPnRpHoxGdLK7LHjM6Gp+91lVFo+qA9LVvVNJqlOV6we1nTOeWrG/oyi4VKMvc81zsaD5qCUzlne47xf08OX/YTCwY+tUdmdKAJslTib8MnO2TTO3OKuU7ERK2sQmSkyR4hhrfyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=jZoFDYF/; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="jZoFDYF/"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-38dae9a0566so1316939f8f.3
        for <patches@lists.linux.dev>; Fri, 07 Feb 2025 18:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1738980828; x=1739585628; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KFjUJ7x/jFIJeuzuwLBbU1zsiQZ5FR4tRjGt0l22YrA=;
        b=jZoFDYF/ZaSimz1rdXYxb/IsZeMox51H7amTJ+RyZpEHA1at/fvmL9AQLDq8CLScG7
         Rpn6EEeOMjrCTXdMvnoWo3C3R6vz7yT2fFPxXrpi7JvON0S8PjbAolXVmKN79fYuWEP3
         xgf+0wPFAdHOhhC+7BQIMJdowpLzhfgM3x0r9VRyj9/f0CMNg8vXi5WtzlNIANAjwSi6
         LQeVcKBMbd6QMPeZOYWPzqvW2zcDnnfS/Sbx2mSZjgWogl4+FeWPY28mAy2YK0pc0r/E
         6J2Qrr+rXnfbnjlyRztqSwIKfx4TIf2RvlF6VefLz307YrPLHA0KXsPT6vAVWgLNPisF
         FNRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738980828; x=1739585628;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KFjUJ7x/jFIJeuzuwLBbU1zsiQZ5FR4tRjGt0l22YrA=;
        b=mkKUp1zcWJK3GSx0S5ikvL6DaNuhSxlVua/81ZGhccBlCgdxbiQ8ndV29rd3Pn43Mp
         n3zl08qzXGkgv3grCAMXh5EvtuH+a+GGt/TJJkmeWlOIjTzMxRXeQNNLl8fO6UGtm/My
         lwGKreIHWoaus4+L0dEZiCBlJQeNIPZLzZ7/VkmPcgpbc+0g9s5JmYb092985rCT96F7
         S9g3H167+cHi9/NWAHpfsUSML4InSllT6XWZCxbzP2WFnL9l655zl/Sy0zZLMhequ4Az
         zwUd44NLrbqGIHIhptIoBO5Sz9RPrhDrkGRfSsqx+K0UU81p5zoQqZsD2wJGifaNt+mk
         GMRA==
X-Gm-Message-State: AOJu0YwSbTV/K6SXM6ZagL5WjcdT9Y8ZvPeAIPxwSz93+vnAH2pcIZ62
	g0zd5jvurrwvdM+eovA9Uuz//En49BFkQVkciU1W8IdLOPVrpes=
X-Gm-Gg: ASbGnctZo1XLo900Zl7xGlbCwQKLWXRujNR3UsPQa5yUEOqFDanXM4uqdtVngkQ46fi
	DQtZbJQn8ybd9XlfOpiuhYs+r7YYeAbHe1vVb6QXvZBoFP9KJn1Db/9f0D2NQEbhStiSfHja/WJ
	pHXrFDSKSxIVZ7XCt/4ZeUujs1lNVS4a/YxyfLEObrRoKDxYwmgli0WoaPk1AOmRx2XzEIf3fk6
	Asa9dj+bN+bGoq2pZXnuA09l7A+/HWicJyzTQ4LYPPcleFS0SW3T485HFxR3msi5CyS8g85NU0+
	5ShK1VWBm0tYyDg4HCSa3LtSC4Qlswr9tlsbbRJIntIhDCemazdtaegChYZbopemURpe
X-Google-Smtp-Source: AGHT+IH23NV5ohzZLD3pCYDgj/pjnD4892PA/FRvcWDFkpPnQCQz/wLEIxVNaftguMLXLf/FT4bLWA==
X-Received: by 2002:a5d:64cb:0:b0:38a:8d4c:aad3 with SMTP id ffacd0b85a97d-38dc913180cmr3799850f8f.18.1738980828314;
        Fri, 07 Feb 2025 18:13:48 -0800 (PST)
Received: from [192.168.1.3] (p5b0574a7.dip0.t-ipconnect.de. [91.5.116.167])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dcdb54668sm2570722f8f.35.2025.02.07.18.13.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 18:13:46 -0800 (PST)
Message-ID: <9625dd20-d66d-493a-8e1f-5104c9664ec4@googlemail.com>
Date: Sat, 8 Feb 2025 03:13:44 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/389] 6.6.76-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250206155234.095034647@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250206155234.095034647@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 06.02.2025 um 17:06 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.76 release.
> There are 389 patches in this series, all will be posted as a response
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
