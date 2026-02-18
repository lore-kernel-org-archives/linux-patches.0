Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CB82EAB71
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 03:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771386308; cv=none; b=U6aLuIZ2CvsdyCDlgp7AgkJAGyWP3CMg/BqPmy+HDrEZoxj3NZ5G03wnifzxqo7CTewoKB1uJhS1smF2ZalUGlD9n0gHm8chZ0K/8qZyKBEs8282TNUuxkadJ+DKZCt+xzO/fh5L4ZB7tPqzVzOIdzsSBs02+4Dq3luQH/3MWco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771386308; c=relaxed/simple;
	bh=dMA4ZOIcC9gE71pxUT3mhKMQM9zq13MqU8rVY3q0k6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CjDfnsR1TAfestS9qRVFuT49f9aJ6lMoI4QZ1qkdyNXCfXejH1plGXQa1pJxOn5VlAq7nQKpdIUwRO/dJTWS1mgMb1fLmF3EHDva3kccknhmNOaFhT/cf/xC7luRwUs65UFawGDtBuasiP+UQS6luG8HckCHbuTwg0uAd+8HiL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=LjFSMZox; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="LjFSMZox"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-483703e4b08so3333465e9.1
        for <patches@lists.linux.dev>; Tue, 17 Feb 2026 19:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1771386305; x=1771991105; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cUIuMgMYT34LDNMJkmYdB/Yzp4mCe6KCutQrOT8Nnsk=;
        b=LjFSMZoxuMfiB97I9daC2mX/ozjebUBvX3Pc3tTF/d2QeFubzzEprP6FHjHo4QfgMz
         nGeYMLFlHabKi2amPuakibYKz8RqRKmailc8OwZejnkbvsTiIm0GJFg/2yWKLiKDu9cC
         EiWL0f1y7nDMPWp0AEEFv0zk0G0LWcD0Z27kaErXqpDDaybrESLxcuMW0RFtzo7bxgIj
         jZgXYXWWsLB7txq4DqB50MXjkespjTGICjMEoLGMxHUy4uJwGyqNWgZK8jt8gAFF3/Fp
         PiQ3Y0Rc7eF6//JECzzTfw8qXBeDgNZ/GuhH7R8JMmn8Rz7Wugu2QE4IuMy/0VuI00mG
         3ZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771386305; x=1771991105;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cUIuMgMYT34LDNMJkmYdB/Yzp4mCe6KCutQrOT8Nnsk=;
        b=fd2p5IzkNY15sh7sSKZl+w/jBG/0NmxjyVwfP7xsYxiDRWNdgl87vTbC+lJkmWIBii
         q7RAXp/KvNr7FHv6wrqtWrK09StaEW8UHVNr1yCy76SniGlg9MONQxS5hUDc1kLSzT6M
         e7yKl7i+ozPH5egzXoTu0vccHf3KXm9K4mRCZXCMwXn0b/tqKKmzcqNDT90OMN98R0Fv
         8fRsaB4Lp/1vhDToIX7qYccZRXCSk09/YFtCQzDXa+AIjeG4iRBLlvRT7vCKwcH8MWTU
         VMSQpyeHURJAYnho5pq11pRSpBzMQEuqBFAQIf+7O498rgtZmOkoMNPLpiQu57GxArAA
         WmCg==
X-Gm-Message-State: AOJu0Yx3YjYUMBRR8NyyXvaxXh+ML52AxcAs3lLku9fe/b/tZ2znoYCg
	YWzg6SjnnbI0hGQJTbDy8ZKRhX9mf5gjsGqMz1tjOeZvN9ftgx41Q3c=
X-Gm-Gg: AZuq6aKhLJQf8ez9CDBjxS4UkLSgEcUfrBL1kX1byHb80hHvXkYNt9OXCzOwDKIT1HW
	+TNR6IRcqKpjlwraN9glTUrALH1gERKQVTxXp7+m1olmbXssJaeDqlcSpCwODfCx1EWzVsaEV3O
	rdLZQ63fnXX7+HYUsxvkG0E/mTqeF8hBxgTH+4C2nnNtoxPhpXURov4FQcXFVFCF1M3YNjI1aJJ
	g2kSGu0A5eG/HkXCGjB7Y9rbyekHeMkz49egIf5RkmqOZVE24tEvjMdjNn7PH9DDHxYg5jdTrBc
	t60NdsHk3vg9lRGHe1EhSxOq2+PARds+7+NizloVvE3YRidDZHKw8R7PA4Hc7Pp5VFGT1euXc0O
	cJxjnN7uJcrSb8m0eDEGy2AdB8LiE+JTUl9F/HNNrGfoDiiIi0sOFxUZN7pG7n/XphDEhTnNosO
	iX6tBCUSh3TymRoj4cLjwulACGM29tXv+83K9wmzOECX3zBFHUKmrr+8Y+5RV+LC5p5PUebQWr9
	Yo=
X-Received: by 2002:a05:600c:3e15:b0:480:1c1c:47d6 with SMTP id 5b1f17b1804b1-48398c6b10cmr8806155e9.6.1771386304960;
        Tue, 17 Feb 2026 19:45:04 -0800 (PST)
Received: from [192.168.1.3] (p5b0574ca.dip0.t-ipconnect.de. [91.5.116.202])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d5ebd1bsm616334795e9.6.2026.02.17.19.45.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 19:45:04 -0800 (PST)
Message-ID: <1d506537-48cb-4440-8042-f65f78cf597c@googlemail.com>
Date: Wed, 18 Feb 2026 04:45:04 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 00/43] 6.18.13-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260217200006.470920131@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.02.2026 um 21:31 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.13 release.
> There are 43 patches in this series, all will be posted as a response
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
