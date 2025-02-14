Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB24347CC
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 01:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739498149; cv=none; b=X+OjJMzdJsysKW1elr/iU1Z1kMYO1fEXlgR2/ecbtymPfTwTESJZQc5dLxLut0/t+odJvpyu3L67r2K1YVDJorbRdrHuJV5z0pKHK8JYjXmcLcXhtaZV6T/YZjuMKjeZHtWVaUr9Rfhtn4N1IKngRNIRQGJ1E48z45WJasyYxr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739498149; c=relaxed/simple;
	bh=VcjAQ3B4mQjDUypYSd6nbGJXNoRWezJBNsnpycoJKa8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rk/yK5D567Uv+Ax5dFmpRswDO3HpzBdWDEDxK/T97lWXem4c9U9JdWbJ3ciTW7sE1nbXOFsS812Cc7hgvRGuXGlrUtyQ7XdtEd6DzZl2z779gqnWb6BW2/TB0oBmWyrSCU27BrsQYZGhfgYRKHz0sBeeq28fZXrjva3Da3e2lhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=LFx6KDog; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="LFx6KDog"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4362bae4d7dso9764185e9.1
        for <patches@lists.linux.dev>; Thu, 13 Feb 2025 17:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1739498146; x=1740102946; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eEKId/k+euMe1WkATnBM1ya6ihDrHX3GOG9+SISZlPA=;
        b=LFx6KDog35x59qxvoNP1IYAJ9inj5YebwazL2e8xIllRQ4v5E2dNAOvJsmZXHT/3rQ
         iBM9LRfHhvc57wVkdwuuab03P0fRJ7qn7ukynFj3oOQfUyT5vea8tXHBxwyrs8JhBzF8
         Y139J24ZV3FfTZ+CrZzhMfnJBEEYIzEPJgC7XR668+kl14YpjzczE4SEeyb2yZ8tV3f5
         bt/kVCsNHaZ+cwQnyfDdaaKtNBTMmDBizw45e/jRjA7bhZBJoRSBtvV+kezwZBBRyjrz
         eKFeBXhaRX0BJm/V0oh7O/gFkIo5JD2vAxMR149LRMsEgsPnWEXRmOWXRLRh8gxdpYot
         9Wpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739498146; x=1740102946;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eEKId/k+euMe1WkATnBM1ya6ihDrHX3GOG9+SISZlPA=;
        b=L5xFZSHHfNEr7DQd1XrMjTLTusVOVnaikaTKk6XXINO691mR0SzIt9umXPQHyAGuJQ
         RUIXEsmHGANtrGD5WXhwCUMgiLOGRCrjGpK4q/ab4Sx62+YYcwITvj5I0sTTSYpmJfiL
         4ulQ9C0NlcczaLy1RSMtcq7MDm3/uzc7Y9xKpwZuk0xt54fuQFmCjak+23ZmTrjqyvEO
         dEa3zJExoBcl5aXc03hc4iZmXGRMVJdG1da3ElrX1+130+QLNocHTQsYxXAU5XseXnrp
         H9JroZpW/di8TBIjFr05z08LyQxFuCIRx6fC+xFYzusCgIWKnnyFpRRXnQ9cUwkhxCCi
         Gh+w==
X-Gm-Message-State: AOJu0YxmM6/0FNyiFixqNQtW7karbRDYcrdwkcBQyxftSrbhrq0OOO1c
	YH38Pza578+Lfx7c7jPucxJYu855/oEA4MPcUOyTOEMRv5hO6aM=
X-Gm-Gg: ASbGnct1r8Szp2PMPOm1SeMrv3eMcsRJlThyLm9fqgER6/1KJmXmi/TzRrEdUoZi+tV
	eOghYd/nkGME1Q2Q0OzzjSdHj+mkBy9nRYv0mMnc+7rQx5XrAtIQQ1zq3SZTJNAqDkxWhZCqfQB
	xXSo1GgDh/vz1wb+pf01al+J+9chkGmRSae+8Rnner1MfZwvBxK7c/DUkYeKbi7wGhY2SpAFxTt
	iZYoX8+POXuHLYHn14oJcnQi3ajqepzc/U0isVujalV8arPHd++G4CH/j+BkoTPjNj/if0wS2Q3
	rFV63zTj2rqW0hPHrEQfY2FkWn74FDVTdkg3TFvHLdkUEWeABe84rFTHtNXS8fiPuhfW
X-Google-Smtp-Source: AGHT+IGAFqLoCM9XcT7iiED4OM3G31gTMLs6si60SuowTMy1yKm8m0Y8Y1g9lSJEe43V1rJv7W6nQA==
X-Received: by 2002:a05:600c:35c9:b0:439:65c3:3310 with SMTP id 5b1f17b1804b1-43965c3365emr30595945e9.28.1739498145653;
        Thu, 13 Feb 2025 17:55:45 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4779.dip0.t-ipconnect.de. [91.43.71.121])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a06cf2fsm62498165e9.19.2025.02.13.17.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 17:55:43 -0800 (PST)
Message-ID: <66f89945-dd39-466b-a6cb-5f67b2f0940c@googlemail.com>
Date: Fri, 14 Feb 2025 02:55:42 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/422] 6.12.14-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250213142436.408121546@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.02.2025 um 15:22 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 422 patches in this series, all will be posted as a response
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
