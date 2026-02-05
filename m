Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD1120C00A
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 17:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770311764; cv=none; b=lYO3tEZcZfykSZQe/Z37FH0cBhXEzx/Dpt1bFK0FXdzUEumXjZzARPqheVJx1Cj0nMvaoOdlG0tl56D06tbJmJG5b02d1ydGI3jubGnXoDgi/7qn5OzY4jCfJnVJL8KJLY5Odq97lCEq2bNw0bYguMF4cRtKJUKkihzcveof4wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770311764; c=relaxed/simple;
	bh=Y9chVdlRm5dlGX9ll/yHkLGxWhe/sOAvh3c5XBl0KKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oz81r7ByxfjGUwe6wM6bIlc2D9/dh6WXhCxjshhxez8J9bQjfVhlkLm3Cn7nwDfWw+zBJWn2tMAnOniXPoMlbV4zZLoW0Oqma0ctSiIb9yWYQCctXFOr2G7ZOaD4VBCBuBl0P2BqqIjVJF0ldpnk0EN4Gn+yHFYdimSYH5911sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=mLJWx4yn; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="mLJWx4yn"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4362507f0feso455488f8f.0
        for <patches@lists.linux.dev>; Thu, 05 Feb 2026 09:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1770311763; x=1770916563; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VuTdoeIFEQQxdGJ/pGJTNfdx1P6qKodRDn3ipSVF6S0=;
        b=mLJWx4ynxYT5kEtYGNokiFq8qw6v5+1KFI2NNNRBkxJzCCeMtm6A9/rdALDEsJGddH
         znZ4fCP1i3ER4EOEGUWRJnJJD9LXwgZdxqn91AxQ/tZxKYseg8/YhuBprpNbWsYl6tx+
         pkUgDvFHp9RVD399Y4I4jm67TjbfB9Ry2i9X48JVSVbzwL/fPSr+Qj7jgpSJri4paAxf
         7d19yfhVtcoOrSaNhTzYoyE9qZX8en8Ya49P9wP5q0QIZUBfJuja1gHb1NpaVliFUko7
         2dOGjOfEJDI+/4oPvTlZOWGHsfnNUPxrNYI+kjgHs6qr/e8Bskd+AJr017mTX44o3beY
         N7PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770311763; x=1770916563;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VuTdoeIFEQQxdGJ/pGJTNfdx1P6qKodRDn3ipSVF6S0=;
        b=NkxzoDhfYy8RC1xHLVU8Dc+8mxZLaSdEtgDr2a47IfcELcDtfeu/jO3iFVZOHaGBSx
         ablxMNCrWHz1v57bLLAjpYNIqwiP9ypaMQriWRXg37QiJ1GcAjHLAbqygj9tdXViuVKq
         78uNntjsIEg7ZtOX4Xf74a++NxsenJAxTAVZMyO8lkzIrULHW4cbieHZOkwKiBogmOYl
         UHr9p18TQ5rq+pZwIMpO8kGNI7NkkWgQu8/gMXUzK/D4daC5V2MvOeSJuEAU6wguM8pR
         LgId/8CRv77sGBto4fviIaumY1rmnrwMi2EUvd2KVTYA8PwHsPenndkZJ1yRXdbGDtIr
         5dVA==
X-Gm-Message-State: AOJu0YxiB6kPeA1ucAbnlShN5t2+Ogj7Vhk1f+Bt10/sD4vfx6GUafcg
	3MzRK8PJcQI/LXCvqJYigraXfxmyb47Ws8pBD7wW452OmaJfHDnXnJU=
X-Gm-Gg: AZuq6aK92HsVO8x/iJKhB64TadEBluPy0nZsr/F5BqmJTgYXHKmuY+09XWasa8V/WbP
	2Ev06Clj6kKShuq5nqwLThP44z/yGmA8FYRQxjLAI1FLjDl4MOj4wg9G6qscJQrkn2cZ34X0Uhd
	i/vcbjYd9nwpQPv08wEsgWsiUhJ2pRoFhMW9QuHyKW2mQ0CJDbzbFHr8AbnpYdCkrkSYPeww84A
	AAEQNuKO1t/LWesc+ORfntrx/CBuUiT8ZuidQU+do5KCHx2I9i7/tpWImN5yvhSBfQr6ObStHOV
	fd7qnDhOeFUGf6wkLOWJBQIBPtU2Gq9wSQ5B/srWB6OejiviJzAdCJQ1UpT1PThx/VrI5s8Wssu
	o0Enp9JLub75TlC6YqwZ3TcgO7qR/KeD54uCoxuiMMJj08wToizvyez1DQbf6bWL4t2AahLMWt6
	63n9Tj+lsWnOveQ8lUhbITWk9eYeiAmSo7eJVpAqK3SA8N0BVdeIeabi19nEoGasKfaRFAGCmkH
	w==
X-Received: by 2002:a05:6000:4211:b0:432:c05b:d8c7 with SMTP id ffacd0b85a97d-4361805955amr10788309f8f.49.1770311762606;
        Thu, 05 Feb 2026 09:16:02 -0800 (PST)
Received: from [192.168.1.3] (p5b2b46dc.dip0.t-ipconnect.de. [91.43.70.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43617e38ec5sm16378551f8f.14.2026.02.05.09.16.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 09:16:02 -0800 (PST)
Message-ID: <08291da9-90cd-4303-9250-905f5c7afbd0@googlemail.com>
Date: Thu, 5 Feb 2026 18:16:01 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/276] 6.1.162-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260205143450.492803005@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260205143450.492803005@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 05.02.2026 um 15:44 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.162 release.
> There are 276 patches in this series, all will be posted as a response
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
