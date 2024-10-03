Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5072A1A704D
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 16:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727974072; cv=none; b=q6NO12QEZoJpy7kxqgy6gfDA6tKL/hQ8WZYvEiNpxJL3nO4nKQKWvBCQNR6GalkKQETcMVufNRwRexJXHyp9dql0Gvq42D9ho3YVNNW4KU2JDDab7c8APV4awYvZZrI0pD5woA7dAD2mrSnL8pV3s/sLsqXe2hxO2JnXqY+mWe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727974072; c=relaxed/simple;
	bh=M8f6aS+IByeVtnTPSzuINb48pU+igaxfoJQ9Tcvwxn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uZAUX9MNdlCnQsO4wyjs3W+2tM5W/9yFOqYrHLVzcqNe6YYo8nGL+qez5pUkho9DadtXnTelIsTJPtQSPZrooqq8pyE+vp8OTicKiBRA4to0W0M+skeu+3sgScCTO3L9QJQw5XGyNXkfc1DgA9LdVCfnKR2k7KsDbC2bIvpjpfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Ajtkpbzp; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Ajtkpbzp"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-37cc5fb1e45so973338f8f.2
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 09:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1727974070; x=1728578870; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LTMcH4K9v+DoRwb+OflDxoZfRqr/SiTrH+qJdlHOBAI=;
        b=AjtkpbzpsS53Ggv4n5kJ/iYCUJIyPvFo6+VC74aT/+e8VUL9dvZgzxyS2IUXPYu+js
         oot/EXMpimLygi8Ox74boJUDCZOrx+yjSD7L+LXtxevnFuuOu46LpgmDIcJkHKmvJRBt
         0w10JDzaL86wKuP/Xr8fCXy0D4nNHBtG0NZf5Gum5VIfjuOHoyLpIBW3n/nYfpYmOu0C
         nkfyt+nCpbDJGnkzrwKmo2O4yfl/5SrVipstWHinmJ91E6Bj1KqvIRSXy9wYDWeLnyEm
         QmuYMkGfsIyayB+QjPbNEtONhUoS+mSJuJaRsgPi0NOpU78aWuL4DNaioNc6SDH0B0ZM
         oorw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727974070; x=1728578870;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LTMcH4K9v+DoRwb+OflDxoZfRqr/SiTrH+qJdlHOBAI=;
        b=bzoA+vOLqGLtKO26KqmKUmKd7h9UcTgdDP6GtTV4zyu1VQ2E7W74OQ2beJhVv/hMY9
         Dh59Cm+ZoR8FLMve1lA6bnSBwr3NMNrE/WsK6S8HfiqcuR+Jy+41r7jP3fleZunMa/f8
         GLrxP31ozJpMO8UT3GTLXTSBoIygcJBKkHnP9qyHjO6VIWTlwmbeXhrts7B1/yfvWNfu
         omMgoJXFYS7rLEyq+KYcdwi06V79CDyVULN6nVQ8ZQzHSJZy9qz8AsdMlw95Ns/xl5GW
         paGRXjK4M0ES48OV06aSfMglWk3RyJg6H5R4CwjvxZ3DDeRAkZhrdT72rKIChLjGEGIn
         W74A==
X-Gm-Message-State: AOJu0YyE37FRdRbwEQBJ31NshexWARPf2S3tYpKWm4e/Lrn40AjLrhuh
	oZFZIOBkSh+FSPWU6uaM8wp+MQVAfItbsyPulu4m18HYr6D7pSU=
X-Google-Smtp-Source: AGHT+IGUM8IIlGHJt3TQo8HYw+JN1qzS1zuRiNI3etW98uwknaVKmuQrYw+rNbZnlbOEODJAC0AFow==
X-Received: by 2002:a5d:5850:0:b0:37c:c5fc:5802 with SMTP id ffacd0b85a97d-37d0e7b9b24mr8467f8f.36.1727974069340;
        Thu, 03 Oct 2024 09:47:49 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4899.dip0.t-ipconnect.de. [91.43.72.153])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f7a01fc92sm49035985e9.36.2024.10.03.09.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2024 09:47:48 -0700 (PDT)
Message-ID: <3b058daa-718e-418c-b34a-54e014988461@googlemail.com>
Date: Thu, 3 Oct 2024 18:47:47 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/533] 6.6.54-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241003103209.857606770@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241003103209.857606770@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.10.2024 um 12:33 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.54 release.
> There are 533 patches in this series, all will be posted as a response
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
