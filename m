Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E5C8F6D
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 16:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721235487; cv=none; b=CMYoQrEL0V2ZWhI2razF6ncMsXPcIAZRzYzmPrw8j1mHwd5u3ywqVh1CTa6HML8FFIFlpNxxBnUXHysMgF/oc/tSvGCTGRXyjogEe2laSAIUPNv7NFHEVxEfDTFMZsvfxd0Nl6uSECANHkuValGMaQbUU++7Ruz0rJ28LJwxzH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721235487; c=relaxed/simple;
	bh=wj5L7vEg8raWB4kya6dpvBDuV4WIo/wvnhvYLz9sXZ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K2ziuWJMG66+bhBMLSgSIUus2dGljbH5s9FRqJ9YZRaw5W1GUHjbdE+weHBb3nF3Qmbr0Tbme8qypGYqCpGlvyfYlSSobnY6WJbvpd4dVQ5dG51iXrTqCFvaKs5y8+s2p+RD3S4dqnry9zOMH07FMxjulyd6puWmYLrO493/Zos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=POUXRYAU; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="POUXRYAU"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-4f30012ebe8so530814e0c.2
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 09:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721235485; x=1721840285; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9zx4ikMct7TQBtb7G5Qz3bBwEzbNm2mRb2UdvLZK4wE=;
        b=POUXRYAUb+vGRMPOjTrpb8hHoa91ClspVGIBikxFxcmSf/VOLEZFa92a/pFWxTT+VJ
         EIzDGDBHeMVxJ/yX7IrvrtP/tRvc/pTLn0I8RuOba5MkNLJWJixsCL+4sftwJ4l1shwG
         ahJ55wgAj5hNZtnjgg4a2rYNJLNQzAXQW1RRchQsUt2lNj6Qu/JFe/2M28guvv72S4r0
         SYkeR2zonIQ9BVrxL93AYFQKTNVijviJy6WKQ52f7c4fbJ0GR5aBhsxwBbbCXpZ9ofD5
         Pjyk9rpeDXgoCFtyFI7TbCHCYTeeQZFbH5GghI9N9Gsdrfr3i2MLhOpIA+mnmQ4+Bl80
         niDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721235485; x=1721840285;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9zx4ikMct7TQBtb7G5Qz3bBwEzbNm2mRb2UdvLZK4wE=;
        b=SysRb7svJ1ovPMof3//6knXQVeKVWu1/y6X5lLRd/eFaoCWgAMJkoyGy0EXd9g5WkO
         eEKlLvNBI1TazHLrqA7bcjoWXPTf1tGGIgnTUdIeM+YfWjayWBFfztghUj3x9xi+vRDD
         jjocl6/BqpiLyiIalw4cZhLVc2N9JMY9e2bFQzw6ApchGJSzNTYBjrJl5dKDyBP2fjsD
         v7jkoEUJKf7yYBqQbqB0gOEl0Oy8PbUTUrTcTIH1K6ZYGz4hLuGNF9B7M4SO+LmWA5EY
         QHbNCVh+SOVlAkKYHUozNc/bUTlmV09ROMYyGdFdpDqXR7Q+ywG/GabRO4AB70OWfGPr
         sefg==
X-Forwarded-Encrypted: i=1; AJvYcCUdZthqAL10HMcL7l4Ak6B/PN2iPWmaMkFIp/5knu9CA5kFDNipqYWAWQTKCKNm+M78Kox69y7wQ0f3LkMZp4RhMLeHx7C3yg==
X-Gm-Message-State: AOJu0YySw1xtwgcZn8eh4IaUGOiX+4ex3D6UtsJd1T3PIAeJ1RA4k0Ws
	fbONreqo4Z56tiIVbvms2muKZTh0b3mj9IsSI+4iVF6oK5LEadgJKNmWcvEHSGtjNKitTYwGRRz
	rrFG6vh417jk2TlyzTHe8mWFQyVE=
X-Google-Smtp-Source: AGHT+IE27HJaUmz9pDPNvRfvXyzRAD6RTrQO6vYcolvCZjt/pJdDQFz0naoLXnmwn/iRhqPv7nAXdgx5zYZZ1zJhKsw=
X-Received: by 2002:a05:6122:3bcd:b0:4d3:cff6:79f0 with SMTP id
 71dfb90a1353d-4f4df687dbcmr3157507e0c.4.1721235485093; Wed, 17 Jul 2024
 09:58:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240716152746.516194097@linuxfoundation.org>
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 17 Jul 2024 09:57:54 -0700
Message-ID: <CAOMdWS+aAOeQqTceZwkpM2zCDGZAWvq6KnVCWKdguzQEJLmAsw@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/96] 6.1.100-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

>
> This is the start of the stable review cycle for the 6.1.100 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.100-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
