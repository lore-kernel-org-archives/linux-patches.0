Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC853002D8
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 16:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761929977; cv=none; b=K0LZTVi6xDqpRZLDWrq1u0THJgTaPQ7FX4/T3PV99CpM+kWgV418YPkwjK5cy+zAzfe6/4q2TnEecRfCdqMJyDBajBQ2VAJ5ttMu/8Ae3hHOv9ojjU4PMThgEM1ynxd/kw3v0sLYZMqstu3LraW4zbliNINPS7u0ycDxfJwwhCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761929977; c=relaxed/simple;
	bh=XI5am4bqxEKpCCxr6YrL1WsbvZOn6blYwPCQvxM3vME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BKYuJP4bo8np5N9sNAITlV7/DwrAwN3ltBra3Zhf9kF5DCoNCQIYul/g4MQuRGCNjkOeid3TAv4kWWhqF9Ay9NlgeKLx6qUZlW/wc3Bo6k7hkcwCGuB68dvA/pG/ZYXnv7/qWPp2zkat73LtGcBK52Wucn89iHEuuCeflogfS5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=RPuZsZ5N; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="RPuZsZ5N"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afcb7ae6ed0so537888366b.3
        for <patches@lists.linux.dev>; Fri, 31 Oct 2025 09:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1761929974; x=1762534774; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=32M06fDmvpSLGWpWm1+m+xurNqSGXRw6Z8ERXRqrdTk=;
        b=RPuZsZ5NmeY4wpiaoXFzya2RGJlxCzYWnhXUPE1lULH4OiKE9nFm3iLiTT5ORxC1Ug
         sq594Xl02NZPY02O9MaowKRzCOzbpQyRvx60CX2pLG2C44KrSgqZaRb40E5w1k6TWNC+
         zEd4UmGDM3p5A7r4FMFWIER3h8xjI96eYmZyP2KdvPRG/rS79WleA+Wv4ghK77QVjWVI
         L/pMYACioxpWsC3XeO2aU5XnFVQPgVZmfWrBEmf8X1FLhWadDYTKibeNVOV8r5g6ykH+
         k6YTmiPbw3MPmdNO2Z3z17EGdunaVZJAlgEB8VJvqFnnvijnA7T0pmzVf4w3OH/x4/1+
         lcrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761929974; x=1762534774;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=32M06fDmvpSLGWpWm1+m+xurNqSGXRw6Z8ERXRqrdTk=;
        b=leomusNsWCIYJnjIO97pUS4f+dNMq7xAwxZ3NiA+we526zblkGCeqmdZijtsaB9MNu
         o60h+uYvUuoyWj5aMhvpaKKtvLtJG+UFBfS12OAxAgelpW01/1F4U354DlCmnw3B+4Fv
         wgWUKOzKbov52nFk+5kMhP0XiWDkOSOiQI9Xu+1W39AyFm05EhorouoWT+Xlj6OVUZx7
         yoScsAcU4aFaeKafpN28nVxY/5GFlVGMt8HiA2uYVyoB7zm4nX8/k1yN/QKcwk+I3Tl5
         vYuHcgWJNwbIfBtKVjvYhC4jTzeAAV++eWFqH4DNl58sCgMenoarvYFi2FpnIhDfdINe
         DICg==
X-Gm-Message-State: AOJu0Yz1/3LFx67WJAfA+v31880CBPGAfFrp+Q7GmOan5uFkXc/ys+AK
	uw5IvrAe2njGtDs0jQNjuWT6rT+5HTb13AjZjd3u5GDJFQII6UBB31Xja9QD
X-Gm-Gg: ASbGncvfZaRTlckw8gfKwaMfpaXsoNTz+POANlWaeVvsoOlgIwuXREATcWWM3dJ+hDh
	ajM2AtzGvC4HJrxEkRNorQKce+7437lY60RlZBlbDkoUwjfA81r461K5X9FiXwNVV1NvpQ682rI
	WG40RxLS43LzbGtmBu8snRYMC9HcXIpjh02DwzalX1mFrXRBQpG2uIFpTF7zCPabevxy1Eq5lim
	/nBk/dyogPzqHZv6ZXY01M+jtSU7LpRv35ghAHVZ+f4rzwUi5W6lsf2nxgUuLOPoPM/agsq9I8h
	n88JVdvO97KjmF9NAYeCg9HNooWCdlFTJkUaCA6BXoyi8ai2BzYHOu3YyvqRF+gVyIb+LAiZGcc
	iR/bmlPYCvGP3/g+bzyYGvob9UnPAfDGLUPgziGD6AaRuFwF9JNqXsOuX2gHtg2M5pX732T5QHS
	zXv0mVuK2Jsj+3KfN+4dc3Ye2jAsgvVoJDCfe6M07SpX1dmcD2XM/0Qg==
X-Google-Smtp-Source: AGHT+IH5ejgtCc6m1hWIm0s3g5GB4B2IveCV86RV0S8OrlIVBxKrpwlcb7RP0l7Qo7hx09ed6gvYOQ==
X-Received: by 2002:a17:907:96a7:b0:b3c:a161:6843 with SMTP id a640c23a62f3a-b70701067eemr413992466b.4.1761929973967;
        Fri, 31 Oct 2025 09:59:33 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac3bb.dip0.t-ipconnect.de. [91.42.195.187])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b70779762bcsm226476666b.15.2025.10.31.09.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Oct 2025 09:59:33 -0700 (PDT)
Message-ID: <afb00dbe-7d8f-4fc6-a735-6ece2c12dcd1@googlemail.com>
Date: Fri, 31 Oct 2025 17:59:33 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.17 00/35] 6.17.7-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251031140043.564670400@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 31.10.2025 um 15:01 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.17.7 release.
> There are 35 patches in this series, all will be posted as a response
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
