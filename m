Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6021AD9ED
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 16:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722444564; cv=none; b=a5+cCwdD8Gm8GT/dv3igy/FvbghG3xcar/BE1dUQq9uWU1F3EVtgKm1PR1hgUBgKkXhPXgo0dxtuckVtDR6JyySYkddUdS9I/yW8MjpGhlll9bDf3ZZrqaeDF83XFQ4ZgIrGvgTwSU0g5Hfr2V6lwDNncK8GDWYTZEwZG8AtZ3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722444564; c=relaxed/simple;
	bh=kYhuRlBIHE2C2BGNHl65saGX5jug6Fvgp8uENCU/95A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B/fw79Dglm7O7MgD4Mq2OfyxRLhFzIgF+71oDe+KfvPx9k6dsteglRBFkURTYsn+zCa9MMIbV4rk/pqx73iHa+i6ym5gjMxdk8CFA69nF+AxYGD3fTrTjQryvYlopjhcnmHCCr+Ajxx0ovgUTZg48BZeot21QcLNX15PIElxEJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ZGrQylm6; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ZGrQylm6"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-427fc97a88cso39895055e9.0
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 09:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1722444561; x=1723049361; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CqywH6oDZ0Pg2uThezn14v8tEMSUBnXkuuYXTy0OHaE=;
        b=ZGrQylm6EDdtoJCXeRs/fO8b4RzjSmXhXlaaaWsFpBN/6fK0gMaPI/DkIppS8CtMZ5
         P3jLDwYyuAwg6C0yLvdNeydkcU8NfIQkfOURiF4F6OKrl7/xHU4yhf5y6W9t7zILntOZ
         ek/E7GQHuGaxLvn5/ECbpiMoPcuMVTffJwnS87GUR0Z+apcHMlgFvQakm85eu+4xY4qo
         9xvwA4Pd/Ay45YvHAoMWRpAycrlAlIV3oO2NyWPWfKSRypTTmOlPIegIJaQzW/0R5/k4
         rwCXpeuyVJPJQTSEdSO3BnO7xr0acppfLWV3yNPYlnfXjoTy6J55hGCqIrWR/S6Fw9Wl
         FPng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722444561; x=1723049361;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CqywH6oDZ0Pg2uThezn14v8tEMSUBnXkuuYXTy0OHaE=;
        b=tDPuSdRyxFre/s+w6+tLCaxp3Rf/JrgcIWVULVENc1XL97EF9PHZGplIU6g2/SX1VD
         otVuVTPob+bcs2RrSWV6EE0Z5LjePwVI6S7Fk/H/PXnY7lzGpeDvyk/RS6seYxnZmR4m
         m+Z0PzuyUN+HLheYv5P9rPfmBKhG4EUHZOURPmFYDc2Ax8yh0gG5vNUOPcia2yA8/cqn
         Ex3u0/vu/9Sd+v2Z/mWd/YG312notj4B5k0wK+cPDkaBcEYfbS6PSJy4rdJC+rcfkov+
         KHYxvXzKjXFav4w8ZsyZN7+4P5KdIfOMbQ3rgp5y9J8mwWow5+wfI2MLloxtFoSEElyv
         OxHA==
X-Gm-Message-State: AOJu0YxpsL0XR5zFULRCEHZIpqqYa9sRjw0R5QO+nG0XooJCKSfO+biJ
	34130dDnbjlfFgM0ufzcFyLrPncdN+urjwWE8+Wc15lvHL+Ui1s=
X-Google-Smtp-Source: AGHT+IGuJWa8xAruiaapYBX7B7MdSHSVFVm+KasuIfU5vMNaKG6ayFpUc7LtLI2Bd5DFGhcv/r1RfQ==
X-Received: by 2002:a05:600c:1f92:b0:426:5f8f:51a4 with SMTP id 5b1f17b1804b1-428a9bdb7demr213775e9.12.1722444560767;
        Wed, 31 Jul 2024 09:49:20 -0700 (PDT)
Received: from [192.168.1.3] (p5b057724.dip0.t-ipconnect.de. [91.5.119.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b367e515fsm17505284f8f.45.2024.07.31.09.49.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 09:49:20 -0700 (PDT)
Message-ID: <87ae754e-44f7-47bd-9b9a-6072d23ad165@googlemail.com>
Date: Wed, 31 Jul 2024 18:49:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc3 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240731100057.990016666@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240731100057.990016666@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 31.07.2024 um 12:02 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.103 release.
> There are 440 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Now -rc3 finally builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. 
No dmesg oddities or regressions found. I'm building 6.6.44-rc1 with it at the moment...

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
