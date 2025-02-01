Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D951E519
	for <patches@lists.linux.dev>; Sat,  1 Feb 2025 12:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738414384; cv=none; b=uFdze5f/8C5aFLzlkbKagoxDhPAmMKqcs/BDqzc7TAM7icfiGUe33kl7LP3RWhnI8wpn3ZN3+KFNeLQUbfoNzowelVn0tSdjKgHgnWMYdPT0SyWnA7YOrtoLRLndfMH36Fk8bylJDvi2MZ+4jBkspCyjYjsblWibhk3UkDPcmMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738414384; c=relaxed/simple;
	bh=B0TIGEWdZpaL3Lol4tNzKJ12SBSCVyy6C3L/uyc1s+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HICEsZg/PavcBYGu7qJkUAtdTSBwrgQA//qm5FPwLpMk32qvhrwMcitGQQ44I4PqFXnMVHhM0w/I7OQRvzpaMdKuMBkmygDOVnC4p+1QV9CLZAVHelvNLDDhwcAqm4zcJW7LCm7v3AzaTGqz9om2YUDEUvzeO3kLm/qY1tR7+5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=GpMPf6we; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="GpMPf6we"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-385de59c1a0so1541664f8f.2
        for <patches@lists.linux.dev>; Sat, 01 Feb 2025 04:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1738414381; x=1739019181; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xGsxzwmsm4FqEEWuqRJ4yrtu6EGS8XgJezR8MjxJnBo=;
        b=GpMPf6wenayMgpFIitmOWSbX/H2/K/a8z0IKzwVFbxzcBm5j6EpVcLjVOXFYawzsco
         mIMEmvsQPgwvG3hdq7HjmwfDNAclfXyi2AvEnNha6G+rimSujISFEMcYvv2lCkkc6aW/
         Su8yt+0kguCg8BZdA9WYxa0CqCoaozzYfkSRw7v4mdhqWTqab+2P8rQyGp7brYdLOMD5
         f2aAwCCTFff1NNt1QKlStwY8RZ1LiJgUZq7TQrJkxffE65Y9fdDGJURSIn7Wdo6rZvHW
         IkDkUEfohok5MaTqpAs3hJkRo6U4kSwY2+IQRcMyW2gdwJ5XEHsdS9dEfRpf3AdJd4tB
         C8Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738414381; x=1739019181;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xGsxzwmsm4FqEEWuqRJ4yrtu6EGS8XgJezR8MjxJnBo=;
        b=EN7lla4X9xVBcGjTCMItnXUOh6BAVKUSNdLSVRrLuVOzhCtGpWD3tGtnCTjSMcovBv
         xuou/r9klbx4drCK8eJTe936wOw1fbTxXEqYAESfdMFqT1t+cdZR0h8qvI7ty56lEN3Z
         XvzaHjfyQYhpi4zD+ubATRMhzshUtb7Xp9Hn8gMmdIEAN88u3OCSFoxO9/Qf3x7K6x++
         m9/XPnH4niQmCUJCA+xKV4DcXb+omtGJjWc0maEaIzc/wrkyUTcKTe8FhfjqfKkMZsb1
         n0AHp75Ppbo4PIwkqR5bcQPiU/Iy48/uKl5PmQ+owW2Gdp+px/6sqr5xItF0UIol23/7
         +wRQ==
X-Gm-Message-State: AOJu0YwR/h2Oj0OW2QgTN2q3yOtqckPCtgaV8w/ncbi6oiIQ2Mppui6J
	LFnGNqJYylW4K4Y0VOcPhnNXyBVRY4H+u8DQcFZEpGuC3OXa/gI=
X-Gm-Gg: ASbGncu6lH3wzIE8otGaD8yPcXAoLtoCngwG4B4pGT4kJg4zxd9tFGSad6Ij2zTsm55
	cKs495SYRLuIYgoxCcvNISJzTcDUP4p2dvX1+mT/tnfcYQH2qrRlQ/T2uxSeAn68OzXYirL4DEZ
	YHtrSwx0/4BBRtgLRm6yjQwOQZ36hJU1rOtDuQIE/YeRS+qyQroMq//2IFurElvtMt1xCgEXyKj
	PW9HRA+YeSIR/i++aIN3ApA038Vp6iT+Y3KyzCSd7VTZgDztDGr/pC/ewyNl0xSuu7Buz1VdZ04
	iDbsd6pjS4XLK5CoXRlmc7C+L6/Ih2HTpDN7AnlOsuxs6tY3/tYKJUENHSTccRnyH55T
X-Google-Smtp-Source: AGHT+IGCEfyjj5b9m0JsQ34ThpMuBHu2HSDT2p4ga66c/LCQW36I9RZZqckINSMYQRGkgTGzxtY3Hg==
X-Received: by 2002:a5d:584a:0:b0:385:f72a:a3b0 with SMTP id ffacd0b85a97d-38c5209664emr12028127f8f.55.1738414380613;
        Sat, 01 Feb 2025 04:53:00 -0800 (PST)
Received: from [192.168.1.3] (p5b0573ac.dip0.t-ipconnect.de. [91.5.115.172])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c5c0ecc80sm7385784f8f.16.2025.02.01.04.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 04:52:59 -0800 (PST)
Message-ID: <b1fa39ca-be06-4f64-8595-75b6626442d3@googlemail.com>
Date: Sat, 1 Feb 2025 13:52:58 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/43] 6.6.75-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250130133458.903274626@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.01.2025 um 14:59 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.75 release.
> There are 43 patches in this series, all will be posted as a response
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
