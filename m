Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158CE39FCD7
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 22:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788213858; cv=none; b=NMnHCobqiPFPMW+vCWF9zEsddOwzq+C1JE79j7dUw1kQp0SbL7kfYJ68wgeb0Zxfgp6FQ4tK+e4PXMzAe74Go4HU537OcdyvvGS0xrQJWB8pooM3/xTHA45Kgr0mENvZPeHd9GDEXBEyspk5s9/vlpA9vh0aZqMoj0IfLxswnbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788213858; c=relaxed/simple;
	bh=q3/IZd+/JxIUPjQPoy9G/4IfyxeAweQqyqRpHrTqC6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZBoAqgfmaWv4CrJBRp0VjGzbu+O6E3xVKr2aw11t3SghI6TVXSV48jdeWfif7DIbTLQ5rt5dnjtZ9giz0VzBEvu3iAQlk/dwxJTcdM7BLxFY+jaSGOGdUDPAKfABdQfNIfIDuulGpKs1DveW5jhH4KjeptJVdLDQSJNFNebN4ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=niMLhGmn; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="niMLhGmn"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-498028b3d5eso46413155e9.1
        for <patches@lists.linux.dev>; Mon, 31 Aug 2026 15:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1788213855; x=1788818655; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mooxD0aCQesBxEXQA4gtk4sJ8/K9RVjHZXiEh/ZaNBs=;
        b=niMLhGmnlWeUGws0GeJta8VBYPOgyDwdOpq4OXLHMLuSAvKdLasMxG/H+Ih0tPa1kx
         7ppbxBi+q/2KXmSJpwZK4pAFzQUHA8ExV+LqJRf4vScrT03Njk+mnlFhH6uFXGNzsZSK
         AduNvhZ52pCL05HwHZK4a6w39IbBOnQhE9NSVZdl/0tA+sP34HerTwJbrxrGInhBauO8
         5nJcxK8biC+8tvXv9vkzhL+8MX3IKdbHUiaKqBocRCBEEMG2vWgxLlUqZhJCaECH2Fjf
         8fx6+++s96bgrWMIc+wowQMctt8gQ9+s330VD/OqPI6IRPy80yBIVIlGBlRPIfX56dne
         xtxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788213855; x=1788818655;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mooxD0aCQesBxEXQA4gtk4sJ8/K9RVjHZXiEh/ZaNBs=;
        b=KbqixczMLvEcalFKRs2nqxCtal2L1y7DgiQm13/z/FdzwABy0BnWNNw0uUhxmxHm6B
         4NnSqn0vN8SK0X+xRkfrLfHYYUCw7oTAIjlcg5RY997emw5TVWKrea1Mzo3RgiVUBz/f
         LFQ11uC60xVMkCUoOZ0qEeB7RulWftxcV357Q13QhabxrC2Crx1IzlseX6OcgZQ7Ad2n
         wlRTHZ5QsH1mVdijJnqiknY3qaIyXT/5qrpLIb1qKy3fTsldGybRHfs50u/3UuG0mmgx
         RtA+NZ0uaHCr+qroiuDTKuSdyg2g3uA4UWcRy+CgS0kmX9PasrfkdYjm412BYB1ReAkG
         87VQ==
X-Gm-Message-State: AFuF++krQ66xTwSxwZnkkfhuJf1ccwr46KlgC3IIf6VHLAYHhg0nt2eT
	ijLQtg2rNXzXXqtZNHz9WOWub71x0s1dSGLhbFvOTcGJwqyiohiASII=
X-Gm-Gg: AR+sD12z1VYwmkei3AYbpJIAnnm2s+wgjHKnBcYCq9vlpvrcqbNlCl/hKY6SxMs3zFE
	ABTvzlpzJr/RtePwlgnZZ/hr3DDfdmNhodHlb68wxgIGmFHjFVrYFPULzFLq79yW5QMdR1ppzhm
	8WtMHqGP5sncNP32UMQKg3Ft3tDt22PC4f8m/TGQfbA5+ortOMhEgyNYgco3qZlxtanCo630BCP
	wpbWilvwzte6j3nZbrn5MoGQ7ajC/WPJdNwJOPSOzjM2l1/DB318ZvEAYFww0bDXzo/Xj2PJYOp
	kBO2ThwXhlNNO8bNzH73dF1kGkBFqWPOz9L7l7cBzTU/WhEqcgvw6NyiatpA8pJLt0acVKtSr8O
	uu/O3AzEX2JL5VIri7I6Tk7qUqVnxNWMZO9pzB9nZ55QvtPBg4sFuzWBX3fDPPwmXjlvw0rhy8c
	EHN0yQEy+a6DeguJH2jHndPm6s4OfMASWoOh0PvDTmxJVUHKt0Cc9axuJK3JZRlHsPCpqQQ74ZM
	Gg2fJ31EBv5iY+jBRqoosqq3Torrk2FmhRfJoY784+zQraYtw==
X-Received: by 2002:a05:600c:6207:b0:49c:d28f:2cd6 with SMTP id 5b1f17b1804b1-49cd28f2e19mr272370085e9.12.1788213854790;
        Mon, 31 Aug 2026 15:04:14 -0700 (PDT)
Received: from [192.168.1.3] (p5b057bfe.dip0.t-ipconnect.de. [91.5.123.254])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cdce08862sm21966125e9.1.2026.08.31.15.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 15:04:14 -0700 (PDT)
Message-ID: <8bbc48ab-d0bc-4deb-9018-d8c22abfcb85@googlemail.com>
Date: Tue, 1 Sep 2026 00:04:13 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 00/99] 6.12.108-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133359.740409777@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 31.08.2026 um 15:33 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.108 release.
> There are 99 patches in this series, all will be posted as a response
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
