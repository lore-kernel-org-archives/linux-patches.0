Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D111126E709
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 10:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758621747; cv=none; b=YaFfGC0IXvHrPGwmG/V8D/+H/EkXcfFMdeZ18uoH5onpWR7wkvYtQ4T8Q3zhqWruzrWLNIfL583gkgxvf3az51/ycmKIpuHsJoCKsZ9tEp3YIgwv6J7qTvfDpU2XdtMzBCEkl7AfFocVPSYy31/qbXycCKsNiyQSLlaAOOpepfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758621747; c=relaxed/simple;
	bh=5FF8tPIDmyxIpM9wVSXDOOY0MC8zPSnYmryOXTAKfc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h+SDLig9VjZ+oG+nG7eWXwN490jA+4GXHyCxcv37OwP9TnqTycFGN94J7S1PSi6mtAb5Na19QXZWqgTSP/OeoaXY/ds8IPTHz0mZqrX2aadSC/j/d8EoghyElh06Rc28BDr/tXgJggVrbp24a43srJW0+qcQ5AlbtLBVstTyirw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Kt7WHKH5; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Kt7WHKH5"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-46b7bf21fceso24934245e9.3
        for <patches@lists.linux.dev>; Tue, 23 Sep 2025 03:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1758621744; x=1759226544; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NuxeQkFvuyAhGjszfWEO1n8yY4RqHJEB2By+oL3ZH3o=;
        b=Kt7WHKH5n9J7arqkfYCNu9DLHtku9BSB2+VKeF36fiXhxHFuFVu+tnF9Koi2Cv62kq
         y+TNmGK8JvDjI14xfRFxJUudm5ayF4+14j0ea9+ldoZyV3mYbUIUxTwJokf3hKUBJ3RH
         j67HKDIOiijXtaQcWZ9EZZZyDroXsOBVMsrH+9Jl0i/W5hRfNFytSQkYvccvezDIv8d0
         uCeWwyH1NQqreXd+l+L36R7WtTOSN2QdzywR2yAWuuluzBHKXhw2WrbjAmJdFHTByF8p
         X1Y66rJX9z9QBSFBLQxMkvfufkujDiXhmnCiy4mUUhiV3uZlBUZri7u4rmGRLMdJXmKP
         7bgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758621744; x=1759226544;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NuxeQkFvuyAhGjszfWEO1n8yY4RqHJEB2By+oL3ZH3o=;
        b=P21w12USea4F3reiykaRai2dTGEzbUGlC1XZKc/MdQpaIoxRs3Rlv7s9XeEd8P/7Hj
         3df7s3jL5jIuojH3Fn/3197JwC78EfsVEIqnTycGcDSef2nYD0LX83GwKZehmqjmIMMW
         8EfGXYhbQj25Nj63A6FpjOPCNaks/Vn3AK917NC6ewfe+t2W1HWw2k3LO8B2nZ/Wi26B
         73tScPqb+iKvOV5DyXHOEWWaAFzMnwsqvgF0KiesCkEG7+nn9RzJccUPaoPOykLr6hrs
         VL+C6N3+s73tYbqMqPsuc1pW0PtkkyIzFR2JA02M56Xz7N7akQ92vFdxpPHHqxKtOAup
         Gi1Q==
X-Gm-Message-State: AOJu0YyHFNflXBUFZvrAvh9nTJ8vKaAX1GIQf4PSNE+zWIB8QIHttRJK
	Pnk99X49ra2NrQ5dkdEJHs1dt3D67jP9xlPxXyOcpWTZ/ep2fjpjmM0=
X-Gm-Gg: ASbGncsCE+WSqGI7xVseQJStW4FwNKG4znskRlyi9/EflTY85sgFNIAfW2qBuxATNsl
	g0rdFEk/LaGz4vxEkSag6bjEaCWZJIBiAxoDk2b/MVNAapPzSVXaGt5FsYxa9Lz0Zj+ZHKYphS/
	7hIDAqOFzcch656+lUAy/Zq6/mWB3UgWooSvxdMRLKfZugBpqNLauAC7O3Gzb/DNS0+Cc7VrkTH
	Lnd0kUoZA0GxK82iHnu/fvaiYqvShuhqppalKwDlB59dM94W85YbuU5t1PbtKHORxDOrZ5S3L9u
	hhoH4ewINU3ZOFH2mpt3shX7Xpu33zs7E9vWWp8p3txGRlPPBMEhLIoak+yeIg4xpH83fi87sQQ
	yApw0GCaOpBUPoDb9sV9tmqQO+tlfFpY4SyK7zp0vaWZdRRNQxvWVMSQGylyLLqH0tp3DTTuTg6
	J6lz6+vSZsPts=
X-Google-Smtp-Source: AGHT+IHbIWkBOYmlyevzc/DOc2+b02FFIYKW4dQtg7oDiCppTekVOg8WoA5ZV55KSLWulnHDNB4qDw==
X-Received: by 2002:a05:600c:45d4:b0:45d:f897:fbe1 with SMTP id 5b1f17b1804b1-46e1dac6779mr17626225e9.32.1758621743929;
        Tue, 23 Sep 2025 03:02:23 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac1a7.dip0.t-ipconnect.de. [91.42.193.167])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-464f64ad359sm273067595e9.22.2025.09.23.03.02.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 03:02:23 -0700 (PDT)
Message-ID: <5820ed19-d753-402a-adb7-9d2026491edd@googlemail.com>
Date: Tue, 23 Sep 2025 12:02:22 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/61] 6.1.154-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250922192403.524848428@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.09.2025 um 21:28 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.154 release.
> There are 61 patches in this series, all will be posted as a response
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
