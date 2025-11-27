Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E1F31B83B
	for <patches@lists.linux.dev>; Thu, 27 Nov 2025 21:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764279885; cv=none; b=S+sIX7q0GIrA6B6oH+8dvKcOIknNNLvPd5KcGeZqzz0ztN7MvkSOqlWR/gt+g7UXPXh5u0oYyVqwqGAiu7ecok7CE1AcD65LsrQ43lrwsE+m8ZeJoKmn1RfY6YS0hF8D6pO3FwGjImM2y4iRxQzkUuoZvyTAduyAV7jO8rm8oqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764279885; c=relaxed/simple;
	bh=kYqUyk8HCuKIoNyqva/RjocXWD2CbFLtw8L7BkLoWBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PicYaLqSDvsNxSUWf28NJVXXjAJpLQ+oIC8kc/Pt0sgpahNeOgfwUiPphe8qqBcHfluS9MI1tio/UO8ZsbZC1CFyTQuTlyMRVZ+iIR99ifxUM4xIsD9X0c2QfWqSQAWX8tmotSkomMAlPOvsYaPjaIp+dndN8ZcSkWTYpJ8EyKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ALR5JlIn; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ALR5JlIn"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-477563e28a3so8885425e9.1
        for <patches@lists.linux.dev>; Thu, 27 Nov 2025 13:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1764279882; x=1764884682; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X3vMxogTvz5764QssziL6YxPWQCVFIuzqxor/ZKDnR0=;
        b=ALR5JlIn9cD8tn2yvVAIO7PISPbdW7DRzf6AWS0iKBhKOXwG9nWcr5apf97udYhmMU
         OjXrTpw2qrf3H/8qU//zJEhj8s3ni2S6ncGOFakQ36LTsXl6wtFeEjF1078UMYzYEwgW
         ABotldSa03VOsk/M3P7lk1nS1uYjGRlNS/NJJOy9LEvpeJpr5feCRP8sWFjBShO+CHei
         2sVt75VgJLzrjmdZ8wpHH5Y44nUKg50IilM/u2pV1/7VWFRBRyToqymXYA4za9sm7MU/
         z8Ja+WMYetNmnDVp9BzlFnwvlzMz7bzRBlXcLASsoRGFtaRKeR7p6/sPQ1e5apj/Fnt/
         O3Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764279882; x=1764884682;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X3vMxogTvz5764QssziL6YxPWQCVFIuzqxor/ZKDnR0=;
        b=e4Mon/5ECqlKgyjWqm/lesurovZsI+5LrGxYS2Pb2EaTrBSC7S7TkCgv39SEuHHOWu
         3dwTTR0QcFIkyDgdyuQfZxK+OBuFz4FY1iwftgg1vYm84B3FxcLvFOPAUNOynJ0+lE2n
         T/u7raRB8Dhz647Xe03L1F54rIJ5ywpJD6EKqtkSB5Qg2yRsZu8Jsj3DB1PBBNflDeRj
         wGmcoLlPb2d5i2DD60q4G4srQMSlcCuGTa7OIqxf4/i7268KM0OVRnQ4/GgoRZSzqNTL
         ZwvLKxhf0Q+MmFHvOpdJQpbLyQXk88+SPI8lkDxtsh5vn+G82cgDBGE9pKIGMEDcJl0x
         Lr0A==
X-Gm-Message-State: AOJu0YxxVFU9sfVpxkPl0RPqEwec6W2sOOCXGovfbW3VoZiv5fGdw7Wv
	ZdBh8cvevoBExNR2BhEwVbejlPoCgfkIIoR9DkFVAvWtC1jqGv6fNrE=
X-Gm-Gg: ASbGncu3bSA78jcTqwvLV+V2pXd231X2v65WHnheRoUOXGsslWs9sXHXGJHmDOVuNlL
	c6+Fb9LNsCGQ0xyUT3siFqlRhjrOuDzAA0du02327SZuLFImu73YYewYVB+2/be126aQWBLOHXk
	oApfVuOywKuGjKZRhFzDlhHIQEHkdpgEfdsehxynI8llC+Wyiu/yVhlY2KQDTDIwQfSxZfeU1UI
	s7nIp0YEwfebVbwahA0MqgtQoxZOXzgg/7quUZtIah8TnysQGC3QTwUSN0x6PNlgJh/97VTFLBk
	rWhvBlDJDp8rLUSwDyuc8O2bH0IdjJ93V0bYIXDoYrrt0z44lx3OHijXAb609MZGhFs/7VNxlEo
	wxXOucwWgj+fme0dBZSQyGc1q4WwbZ2g3JgpCNfnZby7uRffCxlsf2XFsfhlnHFQrCH4QfbJ5mM
	MstALIrE/dW04w7rUjoAIaSVv6/IoDFv5hlOyd0h1YEbf1sU9QmjCaHnqUF1AFSdQ=
X-Google-Smtp-Source: AGHT+IESv4h68YmFtRIIfRfpstRuuWLD9RkeIBwvQ4RpD8DKrcbS4Olp/eGP7hkYslFJjLJtIU79mw==
X-Received: by 2002:a05:600c:3044:b0:477:5639:ff66 with SMTP id 5b1f17b1804b1-477b9ef4949mr192214545e9.13.1764279881955;
        Thu, 27 Nov 2025 13:44:41 -0800 (PST)
Received: from [192.168.1.3] (p5b057472.dip0.t-ipconnect.de. [91.5.116.114])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479052def4bsm73779255e9.13.2025.11.27.13.44.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 13:44:41 -0800 (PST)
Message-ID: <9d2d34dd-1147-40ae-8859-9ef2cd4b7dcd@googlemail.com>
Date: Thu, 27 Nov 2025 22:44:41 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.17 000/176] 6.17.10-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251127150348.216197881@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251127150348.216197881@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.11.2025 um 16:04 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.17.10 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Nov 2025 15:03:13 +0000.
> Anything received after that time might be too late.

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
