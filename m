Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE0421D3CD
	for <patches@lists.linux.dev>; Tue, 30 Dec 2025 14:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767105603; cv=none; b=DJBY6mqaGgCnJO3BsfZzcRDRKc3CZwY1h2WgaQ99slEGXMgCzgKKZzjBKQU4PpVOHfKeT83pkV99Xa7GzThoNmUa3FfNqFwLAVij/amY86LzHJJ7DxFbnHU70BXL+iJy77bxjI/9QHnlQzh9XYUD60luwdXmF9K0LVSaHt1QkRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767105603; c=relaxed/simple;
	bh=s0rN/mzkBAPcsmVjyKPNIB5LMIJZ073UG2Q0zmQovXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H3Yq4qiF/cZ0wwJgZ6EN2/59cL0LRjnJi9Lbu8J4sarl/5PcfoY05oGCbL0aTfeNUpqlWY2RFSd+FWVGgiYPmk1eYyGDAsVLIjRiQHus0TuzhLq9To3qRlE5g8hT5IHwXRci1Hck9yFJrj5iqXho9u8bX6Q4vvBb17VX5W0iwDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=QY7rlrg0; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="QY7rlrg0"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso95383735e9.3
        for <patches@lists.linux.dev>; Tue, 30 Dec 2025 06:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1767105599; x=1767710399; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QBHQ6iT252IFB9IbPjXdUzgUocgqNSFN6oDTMtuDLng=;
        b=QY7rlrg0Urj/QIIEEePqflZib1m9r8mRk/DceibLfJFssdb5AbxbnfmJ7isevETPjL
         jHhGmdZVQFpuA1rgo/TEd+86m/auDncPX3cT5ayQaA0R2FLBnB+7Jh2T6C6A/8xgUZpi
         s+kQjRLkHmW+NqMclnlzbNh+1MXI57PLQVspHG1lWXtUjx36ycJv5+TetiBg716YI1Xz
         oaEzynzeOojHe1dWCGRz2wBJi5+coeGhmTOtgi5OpBNj1QEW4RCU5q0CmOiNCnPjIlgT
         155uC11z3JGj1Q4dIlOTBL9M1tyh07+EpWXTU/MntcQLvNdy+iq8x554WbfxysK4vnZ8
         UHxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767105599; x=1767710399;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QBHQ6iT252IFB9IbPjXdUzgUocgqNSFN6oDTMtuDLng=;
        b=gP6n1aGLplCSIRZuRrfraMRdEMagTSea9i6mNyzpb6cESWD5Doa5VGPc2h7YJnhsLF
         zJwZf2w3jKAGHPZge1eNTjcXMg+AGpu36+fW4UaRN5nS84hZjhcPaHVhD4oCJh1x34ds
         UweqBgxsYBMTGoplJikzxDZ29IfBP+OLF/9shYh6DKj9wgWvpOv1caCpCYTC8vOH/ogg
         Il0yxSNL5+y+FB7UgwcqHIwHLMoTOMD9O1trC7xs7fG5VOVx4tJtEhBWIULipwx+/zqv
         j58yGis70mqb2P1+nmQD3jHD/aqvC8OeAA5clxB3l7wQgCOMG0Ew0vURc7mBHjEQ7cy1
         eL4Q==
X-Gm-Message-State: AOJu0YxK+EaEBrg7UHfp+ibg25D5Sz7Xkq+mBBlvA9iAhY7KlbMe17Fv
	Wx3HLj5SgjbSPGrNIN8MAi5vFjuzr8y0QWUqYsWP/JRBzXuhCj5sXis=
X-Gm-Gg: AY/fxX7UNXcYrqBRt3ouvj02RusmPU9lVB+cUSiUCGFBQ/2oh1lWtjzLyv66VxVLnc6
	1y+2rtkOm8GIOuv/gDH2LlAyF06B9bIeNPmE3iqPJeX10FKdbIkl2xnKS5LrKHB6Xe9YYTIyOB3
	ltigOZyoKE1wrqTn5l9OzyPawEZPdFwG5lAN/B3JSA0o/bbrhbXE0brPJnFDAL5nV5aomfaCJjl
	EdMr1ClYGwDdwKcjzd2rRzO5WPBYhMVyuUsdJkzJp+ZoF6cbXzLBrGrOycaRcdDW5uE6YQwU57r
	IgezoTyUZpdpTJIU55Q8dQuX/s4L/Jb6OSFDyM6EJLwKleHrxuC1Og/yMlDVm/BtBJjRg3DZ30u
	/TIho4t9hyQRf5uPIBWIKNvvr0cV5MlOasWeRmshZYFeQI7Cn9ge+sA14IJCS2LgrHqH+WKR2+c
	UdSOibCf2JApkTkrD4u8wlcWKxNg321kNcjMCRPURqAPZjP9p0HLR2OR3Ejne9rsTq
X-Google-Smtp-Source: AGHT+IH1o2gMOevdGKqUazqbPOJHWmg4LI47qP8OVKndiDKp4tRzX6T9r4aK8tE8IPSU9rjjDBQERw==
X-Received: by 2002:a05:600c:348a:b0:477:95a0:fe95 with SMTP id 5b1f17b1804b1-47d195ab61fmr413121975e9.24.1767105598732;
        Tue, 30 Dec 2025 06:39:58 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac5d3.dip0.t-ipconnect.de. [91.42.197.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d193cbc0bsm613401235e9.11.2025.12.30.06.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Dec 2025 06:39:58 -0800 (PST)
Message-ID: <5577900f-31af-4a36-946a-fc6a29e8be84@googlemail.com>
Date: Tue, 30 Dec 2025 15:39:57 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/430] 6.18.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251229160724.139406961@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Greg,

Am 29.12.2025 um 17:06 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.3 release.
> There are 430 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Happy holiday and a good new year 2026!


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
