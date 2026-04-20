Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE013A1E6C
	for <patches@lists.linux.dev>; Mon, 20 Apr 2026 22:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776724099; cv=none; b=giKhYvEzw/m0xvVY3yOxACipKnNrBjqvSdtgA98BX/x/bq7nnBgyFnltOVOwvCe4Rp3ZI5T1z2lKSU5Ev9/OkFrN3/4bZAGAMvjaGio5qoK5FjD0q+Nst+XFO124aOoTFFh1OOFWXADb5Le0X0xv8udHCustYa2rc8xHpx7+QTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776724099; c=relaxed/simple;
	bh=Y4YMuNNoa9Uygdftkc3JH9QZ7Ollj+02oDbV94H/Bm8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pThMxasux7iZCyRMPmdXhMi1TnVwLFcuezVJprJMJ1jpgqXSyXMZijogpEkO7aFsT4BUtvRUDNVnug8tkpqw2yKQluiGLR3DAdYeaQXb36sVsbkN21yqt6cGZ1TQgP0eaYPGc1yS96B7SEqRDhOfKlt9DsToiGtnE5FfXOKRr0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=GQM1zJQA; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="GQM1zJQA"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4852b81c73aso30486785e9.3
        for <patches@lists.linux.dev>; Mon, 20 Apr 2026 15:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1776724097; x=1777328897; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HZmV+HcxuyG4/pRdYh0mLaOwEFFthOCszYDR45QrDAc=;
        b=GQM1zJQAw3nmMznYAiVIFAmjqMiYRIMyIZu3qMwLxAIKo/jEhK95F5eBDFVfVwUCvn
         Nva6kn+m2+tnRcDPK6agWdHNiVknefdZ32qf/d4x4ZxSoToOcgQ6f5gxRHACenupviDp
         0j6dErTuaEf16Bk0cnBYbM9UK1+kFzKezyCP1MMuV6ITupqfv4INWme+mFZu2qDC2h90
         mRhV6uI5wmyoAtEnlY4LKE5/hYrKuapkHCi2yWvBdV0NPzT++HTj/yFpp6kuUvByEQZG
         lHIXz5/gQHG5YyVckq1kCVumGUqnV9YWJWlmanMTP2HlnULXe1sdp5wnF+LgdN2FDXb7
         u80g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776724097; x=1777328897;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HZmV+HcxuyG4/pRdYh0mLaOwEFFthOCszYDR45QrDAc=;
        b=f00HuJG+A5pKHZUVZpeqcA+TwgdUgEoTwtO90+xkhdZ56lyc4CHg6jcdnBl7vBFwaJ
         LYqMoD5rUNGUHErGBBtMOfGerwpG1WGYqUGUKbWYdf2zyASF3YuW9IX4TFdVOJCFi7+s
         yHppOiHfURoClBh3H3AjTPqyOGNF1whD/jYrBv5LkmfRKIShcZClpzNXjwE9pPd7sQhm
         E6lOEf0NR9VYbn3E4QXixuObJxuElCIBXkd/zISLGJavXXSl/xpjvJcm71dy0W2iaMz5
         PxJCRuGiS7nZjCVyqqbFTwV1oSN/cQXXNZ0Kj6Kl4QPJI1clXR1TO4fg5Jn11yJukm0Z
         YGHg==
X-Gm-Message-State: AOJu0Ywv16UwD+602nZtEb9V8Bi+NyE0J5Xi1j7nhxeQVRcIUoNSutZz
	vT7TVhdUwrKVHBx/m6T+2g6tp4AXo43mMxBKMIoF7tzOjFKXOVNwVkU=
X-Gm-Gg: AeBDietV8siESpZpcitoyThxLksZap91cn6k7zr4959BOijaZvBV/gfv2o7QCt4ywE4
	usaNxHCX67/srJ2bwP3a5Dz/lOUSjFZRzaE2T7NnpuT0OxrRdS6T0Nx9k5dbIifW6wD2vQwdq3G
	Mhxd4JdEGjyhE62n2ZZG4VbWXvpUgHygKIlMrYznLqH0qTyOoNEZNlCcTNxSrW7fo913z7QJzsm
	Q9U3UP/aUJalVtW0ULaPXV++EWXqLPePS+Nfystd28TkmtBl5mV6JLaTBGO/5ZwaDp+CVgK8Jwv
	RIxuEO36Vu8mML4qrO9SAqHxqWeh7gPDQi/FDcvfQi/cYXRsQDV2nkxBkL4MULtvgXeORpF5igi
	QEfU8azLpKcV9e4ZTsgc5r6m7rdCtcqtKoNSMd5+96dlpmQjlkz4kB6wqJMHQYHYL6XUFDzDM3E
	JrvscmryUO6Ujhxyy7QPw2O8KvfHvN+dEeur39BQVn+PSvbvHTyPnhUyRRUgiSnnfNLFiCBkuwy
	qDDe1Hke9u9lOlY2hZpxzgy
X-Received: by 2002:a05:600c:3110:b0:485:3abe:ab86 with SMTP id 5b1f17b1804b1-488fb739ce4mr221465225e9.4.1776724096512;
        Mon, 20 Apr 2026 15:28:16 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b42df.dip0.t-ipconnect.de. [91.43.66.223])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb7ac6aasm100393485e9.25.2026.04.20.15.28.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2026 15:28:16 -0700 (PDT)
Message-ID: <a752c292-2662-45e4-a669-0c5bd46b5b53@googlemail.com>
Date: Tue, 21 Apr 2026 00:28:15 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.0 00/76] 7.0.1-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260420153910.810034134@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.04.2026 um 17:41 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.0.1 release.
> There are 76 patches in this series, all will be posted as a response
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
