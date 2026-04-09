Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C8A2F745D
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 06:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775715446; cv=none; b=Tyxi60Eg/2+a2UGI7iQbCWRUlkCe8FFjl9rF4dUlZopmDYcZ7eCkzPWJfNrk2NthwOy4TN4aaLhP4sFtsQ8YURdRiQnzB+lLxrTxa6B8cLXK0Mhn8AqIF1hld49+ObYsA7pAepOg2gBi+0muu+w+b5I0Hn5aw5+ZzZYX1YnWc74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775715446; c=relaxed/simple;
	bh=dQforEOF7BqSqgvvT++yGuJY5Es/NyuByAsqgve/RdQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SCv2T8dLJCJUrryQXy4mCYW03Qj2NFDtBCBhBxmNqYncBogd6DunBdxD1qIbT9dMkU/VImq8ywvxKK5e6SvONjKyjfdQJG1BlyeaRQ8Lhicuu4lUTLJgIjzBd6b+0KjN5iQxe6F75cfs8qzQNsKSZ95DSTQGcMSlr6ai3B+eTqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=frOg6ZPu; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="frOg6ZPu"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-488a29e6110so4821075e9.3
        for <patches@lists.linux.dev>; Wed, 08 Apr 2026 23:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1775715444; x=1776320244; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S2hQrVv+DhlOI7y2hd6S7WfKXBRz+eTVlysGDBhkavk=;
        b=frOg6ZPuFp4DZALZ4QJwTkrVeJ22Z3wpA6lvOGYt6MMNTYBJl7N6REEneY2/jGb+4u
         DyVOxeS+6OZNqLmEvIAcW4iN+wrxosKN2VZ+U3cjtInyydyqXuJK1QCpqK2iS50NjA87
         qIQ1tBOnb8tieJflY6yCcbotmRtHA24/Y9yR80vfLqd0siReVgyErmQXx2ENAj2jIiMg
         CRW+mHuuqexXmy/9s6SZvrvfmx9pQ9qeJGGYd3DBxp8zuj3fLSpiqfaFKiSayqLCfX+R
         rfTDK6n7QNW4qxt+NMWyjSTaSPCieiqpViD//g+mJlwSf5VV4xwt/oH3t8bcsc8zeZT9
         YajQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775715444; x=1776320244;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S2hQrVv+DhlOI7y2hd6S7WfKXBRz+eTVlysGDBhkavk=;
        b=YZjQO5GF68m7N+Dv8aUWjVAWtm4y/aDp2rauR/3Mcro7FlxHiE5AMUKqDlaDlzCpXn
         t3uEdfknm+JckpArhVTVipxCvG9ZraYZmxabiYg/oyQFCARSf6LfcqR7YX927UBMbbOf
         e0pAkC4Bw98LVRZjh/2wnqo9N/10qS6WDng/yX81yz0XyeXks9kAFMBUtLNCP/m97gYd
         zhh0L/RHc/2cslmXQK70YzTKYrzyL3uyuyDp/4vcnDyq49yijUF8s9VMvJGjSw0k0DQc
         5Y2xy7TVzWYDrS6+M9UIZ3iKEQ+lZL9bdDwAq424YekOtkmeSpTJgJdXm/LX2767ZM1h
         ADdg==
X-Gm-Message-State: AOJu0Yxpmt7OgL7jnROl9r0cgzRT9tjwknGLOsFwXukWjxAy9tShNa0A
	Hsddrk2UgBMoFzb5q160OA4p+U7dDnIgbv2YSy1ByizrU/d594ogqfI=
X-Gm-Gg: AeBDievnsX33yFK6ihNV3aFTE/1zZrfYhxFYt08SMhgGRemDKJ5G44pIdFZCb9j3Yf0
	6v7PW7Ol0N3WU0muRUGBISMsWnsUEer9Q7WxY2LFvqNh0tkAIkTj+3VZdHfQs6NDzJzzwnLd+Qs
	Bs+LCvlvt0UdD1gQOYyfO8zAA/g5FJFpWw3XhDHrrw2nMjMwmN6eMdlwDiojufQCImQj7E6KWeR
	5wicXXKPUfCWJUXnLLI69Iw1mDC82ZD4CNe3Y5O4urr/CFQNvQA3ZH/xL34gt0RlTMOqQKL5UGE
	vzgUUauZOqMsKGmredC+5eA73NTi86QOlIY7H0X9KBKp85+Qb/0Lyf6/r/mbp8vykvhAZz96M0M
	zNUYfa6mxLMB9jA1qCOgKJZdNlyxEGTWWPEsM/3i0ibwNC64LE0bo/BzdhVa7O2zBa7nVuEayQY
	T+X9n2kIzCeNZ9hQxIexs4N3ylh+eGBaRiMDIihSgkCnWyifWIWd0PST/TZEt+X9cEwO2n7xigu
	4FVp8M/+ZCw+A==
X-Received: by 2002:a05:600c:3549:b0:471:700:f281 with SMTP id 5b1f17b1804b1-488997d5e5bmr311286595e9.25.1775715443585;
        Wed, 08 Apr 2026 23:17:23 -0700 (PDT)
Received: from [192.168.1.3] (p5b057c8b.dip0.t-ipconnect.de. [91.5.124.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488cd1d171dsm23066475e9.5.2026.04.08.23.17.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 23:17:23 -0700 (PDT)
Message-ID: <da824d54-1dfe-4938-b015-7f0d3eae9c4a@googlemail.com>
Date: Thu, 9 Apr 2026 08:17:22 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/312] 6.1.168-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260408175933.715315542@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 08.04.2026 um 19:58 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.168 release.
> There are 312 patches in this series, all will be posted as a response
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
