Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D80D286D40
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 14:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770302016; cv=pass; b=RorOWajCI/uymCV1w3TccXT8Owd5rEq6cU7QT08mqk5osMELBqOfZmznqPq2eE6WKys6O1pBGBcIPJmUINuFIdjSCU3pxp2w/ni4QaIyrttQ5tyzpQcSNhEGJNzJbW6zsC1o1f5tEeiTS+OoOP/taTlsqqKR8amX1CzUR05oNzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770302016; c=relaxed/simple;
	bh=4CksDTiJp5h3n6rmfV5Klh4tq+VvmLa08A0es/ESLFY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h9MocxA1jN+/2Jfcqqav6tgL6yKIMntXhGqedo8n0biFKFebC0th/sWtiBUkOj525bmC7JxQdrfghT/3piuPb9FNoNt1RjjKv+dBi59XDIdcE/V65EA5rf9t/0M+BymEezcGpQUSUodIN5ee1vnNPHksRjQxpYTfOQfSlQJUDeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=Jm91dsEx; arc=pass smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="Jm91dsEx"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8c52c67f64cso74112585a.0
        for <patches@lists.linux.dev>; Thu, 05 Feb 2026 06:33:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770302015; cv=none;
        d=google.com; s=arc-20240605;
        b=XCwPJ78f+yGH5WYklDdWSUEft1OLc75F5HeOvV4bF2ApY13cbqUMwYNaQ020h2xW27
         gOKBaOEQ1Uf7nZMo7XUWerafYoqfVnQHhH7NnPc+h0NKUx+kAkC/jVqePCR/d6u1uKF7
         K94Tf9ovE5Ii0YwMXdoxBJkEbWYbSLQy1RVclt+r3+BFJNm+qK2K+IBU6/bWhZE4VKjo
         sOI9w28tRFrhzYuyex+RjGT9j69TlPm8RvH3lRxRbLOV+PDZSMXXXtpV71LXtRNhO7QN
         O4NtBbusGVEC2MusKJIO+vyJVx1nfJ01MKouHLR0YOxl28SdPzMqGF3HknxhO79ssFsg
         F3ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W0lj6ybgFHfhqqBIa8eKQ8hru5DIEVLBuCsOgZF3M1s=;
        fh=z8CxoV2GE6enAmq8Y/T4Gc+T2/5AbTFCgHvc1kQjBWg=;
        b=YGHZN4nNl2riZBwGdDZDyJAd3nV2GKkTXDE/QkO/fDpSISfaadJi+7yPR+4Z/yHmMz
         9padjDLXF3hE/aGwP4pVmM6fsLFi2VEjjDRQx9APUIL45NENK30tKnT0gtYQ/P1kdSuX
         cKjWk53+Ufy6LD5LPygWSYOUNt3vfG64pZlbMbenXfm/aViG4DaLs1wROaU8bbO1k/CK
         zRsCPuZk9vaq8kS1tRJJgoF/Q0gZ64tZFIBItPwOu/Xh/1ABFhlBUMnFPPg33uah9MP1
         eFr6i9k2vxjCamD1KaHV7qKwDAiZ1upLUyfsM5Fra73ofvN8BWBD3UbxZB1m8j06X6kz
         N0bA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1770302015; x=1770906815; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W0lj6ybgFHfhqqBIa8eKQ8hru5DIEVLBuCsOgZF3M1s=;
        b=Jm91dsExjjDLFyTDGN7tJFrTFIOZCzIhi8InmeCpO2CLXZoiwmloGSVDKkDXeUExaf
         5zJFdO/r5prxzAXqZkN5AGFh3Exax+DQ8+9Uqi3Nv2Sd8+GDLcs4bGOuFdo7siG3P04C
         pHOhSw3z+5Zq/Ie82UeB9gjjbrg5cx+IOUH4yhR3Xc7c+HDUffrF/JOGxzxQFmiIqoS+
         x3QV1wUO96Gxf3xOW5LPT68sn/fbRndsfzPB3JXAsKxE6Dw9Re/nM5Jqsb8WmHee5Urg
         JSYUpPcsXhF1FjyG4teo5gjlRwJtwtIrgsbuKTYrUOUU8l5HfyJCjRC/mtt5MCNFYIrN
         6p8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770302015; x=1770906815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W0lj6ybgFHfhqqBIa8eKQ8hru5DIEVLBuCsOgZF3M1s=;
        b=kd/OLzmtpBzkQjR5XPx1O+9FJULDs54d8XQ81/cvi6ovoHbGSsMQG6DDs/9JbVLhQ9
         mNK2ks0T3KukHkCbkMAMqWR4PdxDPHrr5QMB4R9chPxgr0/xoCu/SBLYbGlBq13jCWV0
         vWj8vCBibTXGh5ZbGvyEVPOGmSuVKs4sT9ddxJQrWGzqA7cktMDesMdpQTH3UKIr6sJM
         2dNysghY7dYkO2RFZiu7klkzd/wN3hdMRWi5HnxM6nhrmIoarEws2m7QquQSRaFB2QgQ
         azb3dgMEjRwi2NWxmOG9Nyppl7XgHOid86sjcZszZ6+9djaML8HC32F5mKl7igPb0ugS
         +M0g==
X-Forwarded-Encrypted: i=1; AJvYcCVTaZJ0zXGW0cx1JST0oKcKAoPvXXTt+TbAZDZbYATM+r62ce10PiQfGjWa0covB/gLMkicnKyb@lists.linux.dev
X-Gm-Message-State: AOJu0YygXGjIGxIroQFQzZY89K5a1GFBlFUxVD0Q4olYfXRgo/3/VfuA
	CZtLS+7Bs+VRSg3QlKYa2WwX7aLMo/c651Tut7znGLapJdjiT0DB+uwp/Uix9jstUpbltoOD5ui
	KXqT8HoUoYQsfFqM/qBMXY+cDhjbHt6U+xBUI11BjaA==
X-Gm-Gg: AZuq6aKntpBk9ZmPKYd6KmJ5mD+byoO4QM9gHVl8orisyUVB5SLrwfhjhfpPYoTNzaP
	wDZraPlV7IFsHlM1VLhZNJB2mqiRorhjDFXPO9fxPg6xGJeLPnRZtM10lT5xPKy9m1ezg3wpgU4
	x8BE9ePypsiQ3UsRZg/2tm2yrftIKw3CCM+hjm+w8k4FSVgEnlvEFci0k4LniHUM92RtRqjpcKt
	4dsIAqanoB0ctvOlmvI9wH4viu/IZkuTnokf4vp96tBkH06i8Y14heoj2fqAQywp3r6Sd8/
X-Received: by 2002:a05:620a:4110:b0:8b2:ec1e:fe24 with SMTP id
 af79cd13be357-8ca2f9b6ed0mr842841185a.42.1770302014920; Thu, 05 Feb 2026
 06:33:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260204143851.857060534@linuxfoundation.org>
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Thu, 5 Feb 2026 09:33:23 -0500
X-Gm-Features: AZwV_QjHw6unK5JJYkPoUZ6CepgrdEHtoGcfeD6qXg6V6OP6AqzI_lxU1VmDnGY
Message-ID: <CAOBMUvid=z5o+6wBWYKkOQRfHz3vqgZFRos=375DVUfZZOAHqw@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/122] 6.18.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 4, 2026 at 11:00=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.9 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>


Builds successfully.  Boots and works on qemu and Intel Core i7-10810U

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
