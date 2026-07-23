Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6415F45D18E
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 18:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784831657; cv=none; b=aFE0HwnR9bL7H6Rb6A68Oa4UYRn4uQ8w+Ctpvf8xRQMvUPiSskEpjooWaxVX0rX63IL/BhgKvpNuZMFNwDuud6B9hnQlBfZ6c39ookljIWho71d4IEGUDAl+R2gPwtJ0MuvO3ToWaSqVHjADq08koXzNmYE1smkFobT/bctOLQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784831657; c=relaxed/simple;
	bh=6BYvR1xlmastehOVUnSWesvLDMiljL+lh/30A+8Qi0o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SYDXExSiUP/r2FBBGhnqxKA4PHRbSxxu7qQHfLjHhN31PtlEjACh8T5Br2lrmq7Gt0peLd0yGts0SwT3C2x1HLShpnvzOZNWPxdOO1FWO2jCPo9yjdZSZXLH42fdKGYZm8T1alPWH0MqSKzN5sxIJSPsgMYvJxkN9VpOQOYXDB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=dXJLi95E; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="dXJLi95E"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4798bea72f9so654995f8f.1
        for <patches@lists.linux.dev>; Thu, 23 Jul 2026 11:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1784831651; x=1785436451; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EofdiDH+aqgzOU51jG+bu/UGsM0Cml3C5C1OY1sI1T8=;
        b=dXJLi95EZtRs6nrtNAGU8wrUDNA7tcFnusXfcP6fEJ9ccnC8qIHHkcUNgwwFD+dprK
         LCbYvJCcSVag9X5hOb0c37ynEww+/yV7WAgk8kyHbgHy1A1MfD63qF7kMsE686Y2oz4z
         ATPwLfEry966pkYKokEy0oaipIbzXjO1o/pJkGamBZ6hewv2jFZfxwqvyV5r1d045HKv
         W7kC6/sJ3KAIH9juumZ74SCYeCXrxdaQvdZ6y8P9s8U8BmVkn00wwlg9QZ0ZdpNeDJ4i
         zKRwKq4rDhunqRcTZn14RcQPhsDg+l4oB5g4jkcX+XZFcoaMTFKiL9SrgoNmTkDZZCox
         UtoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784831651; x=1785436451;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EofdiDH+aqgzOU51jG+bu/UGsM0Cml3C5C1OY1sI1T8=;
        b=iMydVOXBAF9qToF9ss5dVkkQU5TDip0PIZ/aPvz7dN+1x3ROdhesnuQItio4pnooWB
         T6z/70SLJ3Hx2WcpGbHjw3JHDMsDFqjbXlLFafZa7zkp7Bm2+Ex4W89kXDCz2kQPIFEr
         JBZbDkkOwpRdjiDDIqoHnc1ebBEqMfi8JDJI3Tko53paLuDVCoEbk1B/NzciPfvcAN7u
         fZNp9g39QqiGAI5N7I4OLFbDDDEOx3F1IZaKI9GfOA/GDuK9AZe++mMKVFbGjHELg0cS
         jKM+DFIJiXJyeS391r9L3pm2UUwuYjdwmoL8FPlq6ScaqyW3+oIGGesQmoLVE/yjuuMu
         6agw==
X-Gm-Message-State: AOJu0YwGvCtSstaRSJRENkcbOGeVN64T5AkDcdor81rdj3GrKen53Mh5
	yC/46YpWT5anZ1nUP9CbfGnZT4GgatpUuAW7AKLm+X7EEZouRMIIGaY=
X-Gm-Gg: AR+sD12xebPh0ecgTWwC3nOJl8092+FsICZC+4zO3mB/s9pwwLX8GUwG7Gjs3OG7oS9
	1daiwifTAfZOIDdCB/PaWwbZSgD31keNB4kNTHNHzbCVNE22YnFc6XVTB6MVjw6HbznYmIMQFJY
	sdJZLb34ye0ENt1oHkTc3aEaowheusbGzdmfQdXSVs/LKc4o/SMzNxRkDyRBErAlC9j3iPbtX2d
	GDIva/3qKHVoHt8FQkgkDxF6P0AwtGLJthgvM52gbu6QnpY+9X7kRox5kJNEy3lw8YBppWViRP6
	ixVa8sqatPjVEbVBWcd1f/hips3QggR+divM4BPxP9CoFyU2XlBi2qfbFTyj20zXd8pWKXwlUGf
	Fj2eIsCHMIcg1v9fu8toPupdghpVXI0lF3D2zhKJFoOKvycKQYzay1ZIHmCSN0QY74ZH4cXybrC
	A7m5ndHs4yaoToN+7BvJpI78/hTp3om/+MY20+HFBdUcAxAPe4i3VF0qA=
X-Received: by 2002:a05:6000:603:b0:47f:81c6:5a38 with SMTP id ffacd0b85a97d-47f8da66b09mr5694327f8f.18.1784831650544;
        Thu, 23 Jul 2026 11:34:10 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acb97.dip0.t-ipconnect.de. [91.42.203.151])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a6d7sm19103319f8f.2.2026.07.23.11.34.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 11:34:10 -0700 (PDT)
Message-ID: <daab158d-ba4b-4e66-ac65-00ebcc3969ed@googlemail.com>
Date: Thu, 23 Jul 2026 20:34:09 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.1 0000/2079] 7.1.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260722142947.085426486@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260722142947.085426486@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.07.2026 um 16:32 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.1.5 release.
> There are 2079 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or 
regressions found.

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
