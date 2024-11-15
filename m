Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C011D618E
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 17:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731692405; cv=none; b=FTgo/594gcZSME7dEErVVf+dG2jv7YaZfSMBOSvzRdbJcPm29kFpjcR20RKWmb+zmRxc0BlDSbJp60/TeYz43QQVIZQibSAWL1o7ASSDpy+SI33KYkZv+1g9dB0lxS80W9/wNRAeUOSRFiQbnm//sqOKI6apmgf1/VHOho2MAw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731692405; c=relaxed/simple;
	bh=p7ci1neMpIlILdwObEgt1kk2VCbDQw3dhgVddn4i4P0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y8s934WW++uNy8AE6JtM3emrv0FBptE3zjBqzEiCjIxsf7Dx/qzqWPKnQISpHEbXo+mxTQ4/ejmU2KFR8J16Z0XU5YU65p8Y8+Lw4Hjx+LsQ6wdfAnjyZViSfbvRO1rckJWzVYkUmN0plYmK1aXwzj9ST8BChX9hbLFZSJ9fnig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=N5ZiQPIN; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="N5ZiQPIN"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-37d49a7207cso1242138f8f.0
        for <patches@lists.linux.dev>; Fri, 15 Nov 2024 09:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1731692402; x=1732297202; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S4kCyeAXmUMvmTaqsw8pK2lGpYkcX3PO6zCT06T8qxI=;
        b=N5ZiQPINAO3b2H8uo7ZOkS7kOv5q4efq2dJG5/nL5UezAONxgGo+gZjIa2o88MfNld
         /KtJrKq81UwyD3xz3aqCSoIy2p2K4uC6P+p1WABXlm7iSdxohKEZKs6ujEy+G3/iXVIK
         odoz8b22kgpzjgRboeUuXakULjSR42mItZTQ/YXxwXcOUXWKeIiZxZIcEg0E8w6BDVKv
         xXTDn/m1AyUQhnRxojcdHflkg1Ebpk2g1IT20bgLNX2pDCAxqRgN1W1R4Kbg4lQvADGY
         bVuMDTyEEwuKKxiqpZoiuJ3U+eFnj2SFXHkqt0R/U13VfpMZTexb+mYiBzpu1hwfQkpA
         M/3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731692402; x=1732297202;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S4kCyeAXmUMvmTaqsw8pK2lGpYkcX3PO6zCT06T8qxI=;
        b=LRFIYFJf+y0wcEMty2c/ry/eI74kvIB4qEPgw7XCq9xJEGdByJRMSyXOqEG+MAWLNw
         Rqx1+O7oYskNy93DO1HyRxFfNNdITsdwvQxblQYH+5p66RWsX3ekfWDIckrlMmaVKYy0
         F+qox2+3n8w7Xd9Ut/rA5l7zvV39VMqaI+WwRiP4mbwphZvUpSqNmzAkhxUKzRCYlD1J
         gWR8yf09bsG7i4W7/Lff48KhF9P4U3humPT4aJ38/WC4GHoGAIpdmFeyMgEmYNXMIY3s
         3SdqXuSq6dH5nlIUcIlahlNngiiWm3JRq8iysUo3b6kbVx+g/lCmZ9E7/cpF30pAXbt+
         lIig==
X-Gm-Message-State: AOJu0Yyv7gXjoFzcdR03fh2GIGDLS9lnzaJH18h1eWa6UznO7awYhZnz
	xMjzgo99Re98fY/CcN7aP9xbX+jvoRCpiDMV8u7uAdDC6Nv53ww=
X-Google-Smtp-Source: AGHT+IE4AS7+FhYA0CzoCHJizPCmi4kWLoQILtvYYXD+QEbI9dEEwxD6J2O1Rvu2/4LDwK5TMY6G0Q==
X-Received: by 2002:a5d:6da6:0:b0:37d:5364:d738 with SMTP id ffacd0b85a97d-38225a922d1mr2451204f8f.45.1731692402296;
        Fri, 15 Nov 2024 09:40:02 -0800 (PST)
Received: from [192.168.1.3] (p5b05792c.dip0.t-ipconnect.de. [91.5.121.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-382247849b0sm2959466f8f.97.2024.11.15.09.40.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 09:40:01 -0800 (PST)
Message-ID: <588e886f-a626-4fc9-a49b-6767776a736d@googlemail.com>
Date: Fri, 15 Nov 2024 18:40:00 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.11 00/63] 6.11.9-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241115063725.892410236@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.11.2024 um 07:37 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.11.9 release.
> There are 63 patches in this series, all will be posted as a response
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
