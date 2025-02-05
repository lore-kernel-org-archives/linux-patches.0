Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B478E1DD526
	for <patches@lists.linux.dev>; Wed,  5 Feb 2025 22:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738795727; cv=none; b=Ixy0gHtZCVln5gcMLjNlsORXD9HzSuk22UUAeoNLdX4O+XssLfBvwHytsWLwXL79qD2VAI8euFVle3wG3lmzCww9WidasX/afldeORQNPx+P4tBHzBNM8uoyE6VbWqzVRowq4hGBmFMSqpE312OGIM0KtgK9fDjHIsWZ+BpCdb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738795727; c=relaxed/simple;
	bh=RE+O/s0Ns8XzQSTV9EwIp/przX/hXIBK6qruLIswKdk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YQKXy5mTT3e1Niyhuyl7O+V9IylsadeO0rmIdZHe1pX4wMXqd8i2x3/RiiBnK+NDhCF295sS60jCduwEPwJsHoEzvQm00hehJU9EzjwSCv+HSt0aJ2nxMc9BM0EkJwXRuPvBTt2p/q2i9yWgNpu7FOWnxMNnUKI+TDfRl9ZYeaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Ks56LRd8; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Ks56LRd8"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-38dae9a0566so107644f8f.3
        for <patches@lists.linux.dev>; Wed, 05 Feb 2025 14:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1738795724; x=1739400524; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FUoT971StPXDa9X9MRqFUXadUeqjdkEOpabHJfRRv4o=;
        b=Ks56LRd8/K+vcWPOnUXcqO9pTQ25yHUeQ+Pv0kXhESLu5w824jWybSodASejgopqgk
         /DatdKi5K88tsFbQpo/TZNVF+ejLnYkEh4kk+xwWn78FzHEYXT5bn2rLAJQjy5leErZ3
         e5EwaLxKeHQz010apwUpWzpeGkLv90kPDsJM1uV5LFtrpMVaR/xdGWp3hmnz8jQ80aoJ
         2/exM7xIP3MvsA4HtBjJwRC175P5IK1fluz1wYDyvIs12sth1x0K9jwArZyqTFJmgr0Y
         dXmPJ8h6thP95I+s6aEAyWlT/WG0q/jXPfUfAW3bIPpEQTJ7bhINJBFY7S0acGUo1Ewr
         LWfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738795724; x=1739400524;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FUoT971StPXDa9X9MRqFUXadUeqjdkEOpabHJfRRv4o=;
        b=vyOzpmBuqyybTB/WzxYzSXe3Vregxweed5vPfixPJePKChEOXo/EzRp8tnKb6oGeqJ
         m231VoC95rakivrdwMY18j7cddQc6B8re4xK63UUQRSedtvboL/r9WNPWzOAhP0TRgX3
         s+fgWRccFaqW/OYnQcTo3/vOVpGNls3q3BcmF2+0luRso79L1ZuYlEGO94qNDSBtf6/y
         Jddn1iYl84huc5CjnNOi0WoqAVNi8ZuMj3vxQBUwEZ20MTt0CeWkBcZ4I3u+sln+9YIC
         Wk9RGFWUWpliyYIcroeby4u0wm93tA16xoWBjKwACWJReTb4RzX6i6VHeaAM64BtGVhS
         9RUA==
X-Gm-Message-State: AOJu0YwaVaVDPi2wr6SpvHJlu7znOmh+QWfTbazTI386T5Gwx60kFrGd
	Eo5zGu01MTYE9upKufSiMcZ+LR6yaOwfEbyX8T54nXBHAcQGJpA=
X-Gm-Gg: ASbGncuuVoYBqshnqth5aRmPVFOi46GOwdFq7dFgUIBek0CO/BJGZLwTv6qM4MzTPsp
	UjtucmdG/QtFeutiAzqGo9SYwxucQG6O5MWb0eMIp31bYV1t3yW6t8V5PM9b90HYonM3syFjzX5
	5fVj3SoMAmbpFPYB4PjWYDBK/pe2lVQ0olbPKT6l769G8w5t4GB6kwAESYv26bXHsiWbMXpENmY
	+bIm5xn/G0J1/oDeDj8pNNoRqf2U+ppcOyMcxga4zOhZmToitH2Sb282Zr9jhSZ3RZhnoowBsYq
	PKXmN9Foz3zX/RGzQnyiBVjzeYCIskpzAOqNZTG8HMeqdhgJdBOn9przBoMFHhXFKdB3
X-Google-Smtp-Source: AGHT+IF0au+xnGsaCJy1dVT3VMGmlxCV68Ry0i86RGuJdLPbHXNpecwjnwCEE3cb45RRkXmZeupW0g==
X-Received: by 2002:a05:6000:1a8b:b0:38c:5d42:1529 with SMTP id ffacd0b85a97d-38db491fa85mr3025509f8f.36.1738795723728;
        Wed, 05 Feb 2025 14:48:43 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4bac.dip0.t-ipconnect.de. [91.43.75.172])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dbde2f4c7sm13734f8f.92.2025.02.05.14.48.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2025 14:48:42 -0800 (PST)
Message-ID: <4ad1662d-44bc-4284-915c-183aa6736cbc@googlemail.com>
Date: Wed, 5 Feb 2025 23:48:39 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/393] 6.6.76-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250205134420.279368572@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 05.02.2025 um 14:38 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.76 release.
> There are 393 patches in this series, all will be posted as a response
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
