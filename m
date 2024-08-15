Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0316CDCC
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 19:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723751179; cv=none; b=n0q0wbRSxuFpk/wVC1+e8jmzwjJrqxOUSP06zHCM4vld5WC8a75/dUONQn3v266NkO2dVFm+OO8AgG3WGdSV9Azopqn7gJXCdByZWErepHsUZrN9RUGHHjj8iZIxrdaw88j6w166tRhKNBQ9Z0N+OlOeOmZG59/jJEgbsNbyuU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723751179; c=relaxed/simple;
	bh=YPNI8wuJj99Ae93OIxrv9+QMXIyi1RAagu1JFTzcgAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=puPoHpscNLWUpwp2UvYojmOL9HTQ0xuGfjq3Gl9OvWS0gSum3tP1gzp8UvOmKzo4ZPvA5TA+RcWIc0DxYf60wmSiaF6wU2dA8PHFxQQPwfCpVVpZ0gvuOEbLepLFuGFwlvbyPgfuP44c3XU414JUM+hQhPAXSaEHy7X6SjsT7B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=XZPZ/N/d; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="XZPZ/N/d"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a7a9a369055so154192966b.3
        for <patches@lists.linux.dev>; Thu, 15 Aug 2024 12:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1723751176; x=1724355976; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Sy8P9QrulK+P7ooXh2LZEV47KGLvNUnsvqBeKPH/wzY=;
        b=XZPZ/N/dsXs3hENxVIGYmnx76AdtjEv3hlfSdPr5Y6Sely+YOrvQYkIiF9AqTBLLYj
         wcqMhpc8w360avF73Vynwyh3x4WbKVKYF+2if2nswVcMWayyByJbIymHOc127R0mm6fM
         rwaCoyz21J20HHwg2qY2krixD9XE9O9D1Ik76P2+SamFYyVfNcJ50ddudrfw1EDazKLx
         xahBKgA7ch2Uf9bhP8Ct+D+0h3+AjF14Cs1+hhh/d4CZZHLBR256DFbotf0363mvN1F6
         O0hN+iq9zH1AVI/bl7XybWgobzp/sI0KToK94NXVc5vrqr1BIO75Ctjou0mxztsq8Yo3
         QdVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723751176; x=1724355976;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sy8P9QrulK+P7ooXh2LZEV47KGLvNUnsvqBeKPH/wzY=;
        b=mmTvNXMYoQbur76EHU+AAbTbPVR8k9YV0LvW4jH7W251OjYI/ppBGFkYhtcCu00Zhg
         XAp3UQ5YuiyA4BreQ2uFHBqS9P4Ps8mlNZQc/V7E6O8LzWcAObL3mm2ww7f2psjeRv4d
         ViIBC020ZhTGdI7yax+1rV8nijLzlv+PmHEG63dN8WHRc+dz7hcMHiLthIQoe8cbBh3p
         iKM1MtWYqHsx+QrqLJjgQZPYmgtQzCfeCC3WPhhOTUeFdmJ4L3x+Fz3uEeMoJ69tOeEN
         9ZbBwH7odznA0nA9VOHvUG3geMhvFaF/fRjceMFXO+7tpdzd7TFvwbf6HArWE5yIhGQr
         rQRQ==
X-Gm-Message-State: AOJu0Yx+ezSvuuPAuOkNs2tkcXZY30eMtTpKgANMZ8qpyP1iMc0nxjqo
	duHCliKh2kQFW7r/nbodQ1hfDxwtGDkXMxN7Xee7iuaABZOSht8=
X-Google-Smtp-Source: AGHT+IGh1+VMHRtt1C1g7Yp/ESqrgWggqhxY5saOKf4US1qEQm/fBr4sbt64hEYHCcEGCxgAYPPlvw==
X-Received: by 2002:a17:907:e21d:b0:a7a:a06b:eecd with SMTP id a640c23a62f3a-a83928a9edbmr46609066b.5.1723751175412;
        Thu, 15 Aug 2024 12:46:15 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b41e6.dip0.t-ipconnect.de. [91.43.65.230])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838d0232sm145152466b.83.2024.08.15.12.46.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 12:46:14 -0700 (PDT)
Message-ID: <94abbf9d-b859-423f-aa69-cb422c2e25cc@googlemail.com>
Date: Thu, 15 Aug 2024 21:46:13 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/67] 6.6.47-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240815131838.311442229@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.08.2024 um 15:25 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.47 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
