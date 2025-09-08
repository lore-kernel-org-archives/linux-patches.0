Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DED1F4192
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 03:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757301998; cv=none; b=lQdU5ZEaP14hOV4Owb8mYb5VdfBUA8vu6dCbbUJm+aDhKhMDQkh+9hBujBXg/cs02BJkaJg7gbupucJCG5UECrCq7RpMeKKm3vnIEbceRcsdfT7BSMisPS3fCl306khayY9AKdY/Q2la4Rrbld3z9XlCogi0zXfdSc47VAUnyxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757301998; c=relaxed/simple;
	bh=ByjzLQXiYPNXKjji1s2Sn9MG9KZE6Tan2hisqLYhZPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u+kpqw/jt3wv5PW7QaBLFNBLNT6QHqAmkbxNGPyHf3kqYCu8I9el8KC/Qs1JK3Mm1QY/f55mOlBJyoUYuVysFqZr1+V42dxZmg0Y/lIQm7O82WXpMJwFPi2H+0C2in/VPHG9WX6igfoy7bimw12RDUhSgea77FOSBT+8/hH2z1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=UH20sx/Q; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="UH20sx/Q"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45de5f4a06aso4154135e9.3
        for <patches@lists.linux.dev>; Sun, 07 Sep 2025 20:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1757301995; x=1757906795; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vq9kDo5Q0wIIZAFC//gNl8BJGYIetExuqEtz7zXz4Uo=;
        b=UH20sx/QK9HudPR7MMRZektnj7ZfCamBtLvjyJJqRVDWCeTPxo8KmESGkShc166dV/
         3+yBYMaVBJWhrhnwTH8/IQgAuGDTfekPZvPlSifGFhpvsBxwBz3rwUV4ZBhnNHy/nEEv
         qFn0Zg9lvFyL2Ran3z6qmdeLHBgG2/M4ULD5cvtLyAkERQ8jQendeqkIO+jfhyN1drCa
         2jurF7WQ45BAmDly5u37c6Gapyg6nWj9FAUdHWVlgBDxcGqMgp/nWguQHKpnvQiVY8vv
         KrRx4TMxrDvMXT1/OQKf2spT+mZuGIAnkf2w/6R7EKwk7InBslj/ohjjIfvgV43wlHaK
         dRaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757301995; x=1757906795;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vq9kDo5Q0wIIZAFC//gNl8BJGYIetExuqEtz7zXz4Uo=;
        b=ouX2VRsETavSKzg8J52AHhFPcVegEtuDuAb4Z1NDoLXwVZFQPRGqtlAFC32Ta6KTqd
         zS7Z1IHAtwd2Plj7jUr18bk1KstKABpCRNGigaHihy7ucJTLuf58YXlq8RxMLTceVLFK
         a1HC+JMtpHWU1D2uGlsp02RKw7fQMMtD1vvntRbmTwn9X14k6FhXDtyq+30OsSTVtsEc
         zLipXCRKC7qPWjDxfQ+30bV3XBqSLUYiYS7lvWLbazxQSzPfhDjQNwN0irrApvQ6+x8D
         t60Z+tuUAwnn+yodMbVNKjLGmqXGvDKB/ZJZlzgOqKkX0vXMQk03JK3GSLqRCjnUeSC0
         28mA==
X-Gm-Message-State: AOJu0YzsX3pPiOC9Y7vB5xvdUxPsaATlzZDVMqRQ5Yp8JV9C/fv1JI9I
	YWNmOVJ6SVKW5Ee/rR3jhwTZS2k1oN+uLPcUUoS2yvoBsHaRFb923Ps=
X-Gm-Gg: ASbGncs4isQCj/eGbS7EaBB8j6TyaZkyqcf5agHQy6bTTy0Xu1teGhO6K1WhF3Q+Crr
	K8zDc5CIg1DgQxjXqfU/7jZh70vYa7ujVKMTSXYMS6Q5YvfDTnq5QXmWKC2sunuLxeDe9UssygB
	WTH4C7ymtjM57Mn6spMXmNhBWik5vS7XJIrPeQ4oOY824/ZU92WWW8kci+R5pVV3BMoc7hv+iE2
	wDZQZW6E6Il+D8u3suxhLgT7N5cUkiTbQh02wYBpdGWvBX1Fca3jpZGcLrlrpiILQ+CokEhDGR5
	ErnO4OEoVUrhDa3FnaWw+e+5rBHVUgva5hQ/MXk1cffTPUf7Zx33w2ZCLVOuk3tF9tZuyd9061u
	ovIwilNDmeexx2/t4BxCY+we+Jmhi46lyvbSN5YwbpExgpn75LBOFgoAqzcb1I5KYp6PAqhdwEl
	4=
X-Google-Smtp-Source: AGHT+IFXIlAzm9Ac9sCoOgyvXFAwKtI8c3a0y9eO/X1DM92geFk4PKCSd6v7ZtQssJzwKpmOujdhRQ==
X-Received: by 2002:a05:600c:1d26:b0:459:e466:1bec with SMTP id 5b1f17b1804b1-45dddea5fc3mr42424155e9.2.1757301994591;
        Sun, 07 Sep 2025 20:26:34 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac262.dip0.t-ipconnect.de. [91.42.194.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e70d463163sm6550989f8f.22.2025.09.07.20.26.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Sep 2025 20:26:34 -0700 (PDT)
Message-ID: <b5dd3856-6b39-4599-8720-99554f69b40f@googlemail.com>
Date: Mon, 8 Sep 2025 05:26:33 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/104] 6.1.151-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250907195607.664912704@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.09.2025 um 21:57 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.151 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

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
