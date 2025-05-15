Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CE21E480
	for <patches@lists.linux.dev>; Thu, 15 May 2025 19:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747339057; cv=none; b=NDVw2X1tMDZqpM8hWx20veyzWihlTaFJf72iQwyFDKZCtQ2sULLuZ+nNpiH00xCc+rw0/NiyCRKtsmzNq5OTWS47yH6RJDuktuaD+ARRQE5Rr5c9KXKJPiQyjvZHAljw6xcbbgI/bLBRlVsVoViIkJUOkR1QhiFjKGOWywazxi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747339057; c=relaxed/simple;
	bh=Xxp3Hf8tEb7NVyAn0wC6H1zxrTjRWn4dy59yYUgAG7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j99074zmVcmn/ih1mdymUnNsiGyUgbPMzlSUMEqfC+m9fGOt6B9fymbbParMiVUSGBlL+ZO+1HR9jTbIvs4b0yCIaWyZ88kZUyJBIta5c1z3mOZjdmG6XuU/+rMTsfSzThpF9D8tZtB250S4wARqcPhe7B2ghs65duyDmFnAIvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=WaQEl40Y; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="WaQEl40Y"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43ea40a6e98so13103345e9.1
        for <patches@lists.linux.dev>; Thu, 15 May 2025 12:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1747339054; x=1747943854; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g+uhLvzK7rNj9LDHaREMcCcONyDPb7wemhKZZ/4dZJU=;
        b=WaQEl40Y1wpaKd6bf3nZnJsyz+XcNnNi34/eL2/Fk9UQB4L+UgVBT2fY6IJuUQz01x
         WOUJWkYXl+HpLsxrgSfFGH2RUFO02K8o2XLHvnphWHz6LRqPYlfBHzzMY9OBuDX+b6w5
         AcdWts8NAV1xT0tQ3aWSnFxOabH0AYYEOK0kbkLVqWoRyra0DJJ10eg1sRWBLR3wAMDR
         TdWnyQhfZluhaNgjnhyuDroJoPYKXJX1zbMpzV6SodJgQbOvF8ZKNdhD1vxxtbrfYi6x
         OrWTBErcRG5arr93FLn8YUSokjtFWbp6X+cmzUNNlOKs9P4yqjuPxwKR9V4lJAtmlLZ9
         fGIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747339054; x=1747943854;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g+uhLvzK7rNj9LDHaREMcCcONyDPb7wemhKZZ/4dZJU=;
        b=vfDpkV9c/xmbcFh0mgZFvXkPfzdGLsnUEXP3XjlLnT9rkteY+cVXQVfZYHxX9yoJw/
         ldbSXvZ+kaw6loJS4Oc6qXrICEFTjaGLZHa4/7hw/i5xBLoY/prsdRitOPWImV65o27i
         OUD2p31OjSnDSOSlDUkjAglnJMTDWXJ8wF7r4zp7Qd8/+EJvePO4Sa66UDyfsNL0BqY0
         h5K4g1C3Uo5vps8P9BScsEBUE96tAGyL/k/YWpk6/G/XSfpHJX0lgL7UfBz+fJaE+EvZ
         hcA9NHpJ4SbWN7Uq22dnQRgdGr6PlIxMZteR/JNzyxHN4oL98XEQf632srqznvo3Dvim
         bPMQ==
X-Gm-Message-State: AOJu0YyiwJpztTevKZ/cTbVQOP9invjbbz6Jy1QcAgz50Xru2NZxHbwA
	GfxiF9iDuyBPV5DOqV0/BRunxTXXKeWGjAkz7RELOGEdArbyxl8ZLpA=
X-Gm-Gg: ASbGnctyAjmb2EyrZzCMhOQGGN/Mmp9HjsDekrKGNSsJf+5G5OWOa3+t2z/t9cYyhJQ
	nprKZMjS5VWnzE7BdDiK9XKQx/G7LmpJiYLnSVGwmbgH/19MZpxUd24CS6HsT2AifLQ9iuCbS/M
	iAuALtM1iD1fzFXCLeZZtTrw1nFTCebcwnQvyCeb7jHP+gVE6L0mf53YT2RtpjQ0ePW4cdTkMaf
	CiqfyLrem7SeEpLOMHbnr3WvzvV72gpxGbXiVN6SDonkorLJ+czGAm19+rL7Q8Dqa8xaxfapy/S
	OZZaMYJfrJ75GlhkwGrdPVe+PxzwUYhgCvuM5tqIHHnVNNx0U+eyoaEW2n0A7Qk31OO2Kg2ZvAz
	LIAuOlFiSh5nCUVxQgIRLCH1RYQ==
X-Google-Smtp-Source: AGHT+IGAhkiHGFhNZo3b4MoNjBTYMdTrTDmz079jIw/UdBFcGOXieOxisqroo9I/bLfyHmmKI7zhxA==
X-Received: by 2002:a05:600c:384b:b0:43c:f8fc:f6a6 with SMTP id 5b1f17b1804b1-442fd6100famr8233125e9.9.1747339053808;
        Thu, 15 May 2025 12:57:33 -0700 (PDT)
Received: from [192.168.1.3] (p5b057603.dip0.t-ipconnect.de. [91.5.118.3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442f39e851bsm82758785e9.28.2025.05.15.12.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 May 2025 12:57:33 -0700 (PDT)
Message-ID: <0d48b34e-ad69-44b1-8b61-141afca3cc33@googlemail.com>
Date: Thu, 15 May 2025 21:57:32 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/96] 6.1.139-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250514125614.705014741@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250514125614.705014741@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 14.05.2025 um 15:03 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.139 release.
> There are 96 patches in this series, all will be posted as a response
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
