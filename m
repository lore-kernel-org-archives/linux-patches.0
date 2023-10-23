Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0580219F4
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 19:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q4BF5Sd4"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5ab2cb900fcso1990328a12.0
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 12:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698087890; x=1698692690; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HbRGnRWCjj5q11jzItIqda+J9VwY61MfSnIjemYMdv0=;
        b=Q4BF5Sd4exExfQuMA7jvfhggvx/mJ8qevUtBiMdQxT7Yz0zAaANG4wKtybGz6eTk2L
         xbQrC7JDA9bFu58m9nQNs0x9Pi4uIuacf3Av9pq+BK6xWVTnwAUVyBNCluI29LSlej2m
         B3jZ+8jCSq5rvH/x9QbsEArVoUGRWFo+kW3Lp4c4eiDea/4hhuPYXVC/ckuJ7tb+Cr99
         8GAH07E6IRjIELV9tOI1y03oyZKFRQAUKOlPlcqQf5wrZBNm8W7ECj+NTh50xvaVaeN5
         QAVLEfn/2PosUvclhatWs/PE6dFz7FSZV5o7E8y0ZnzmFUMZe6JtX72LrWJKr2C3Tcb0
         SvAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698087890; x=1698692690;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HbRGnRWCjj5q11jzItIqda+J9VwY61MfSnIjemYMdv0=;
        b=tBFQOtbSJJBKVmrAc9qc2VRK4oRwMjYz9kMw8TWMpK6dfAHjoleA4M/2qaDIDK6x0Q
         6FqiSSDGuCQxYJs+Mcgw24HzA0kYmVL+iIBVcL5r/qxGO1vHkYTBy9hBfxlLpT9+eh2f
         QjvWwquvp1PBBr0vutIHXhk37qaJHXNBlxp7x+l6Yj36o8Krh+XxsdEz81i6bpHtoLxn
         lIrRv+GcjfAmkPezRgxl2q9MCAC9rE7Fr5ptZVdZPqEXNV5y0C+J4EAlxnNt5AHI6z93
         otDWIe+KZ9HCMd+fpEBYy5C1nscnPzP7wvv8lp1m3C8atgMoidlDYKE8iaQlDygjmz5e
         Cv5Q==
X-Gm-Message-State: AOJu0Yw0TfEzeQdVxmi+wQ4p9O/lWA4F5aYLvN+MtH++w0wSCDdc3b5Z
	xjk1IyKNa6QRF4NDG4NduhPPxUbpNJmi7HTU9vA=
X-Google-Smtp-Source: AGHT+IGUAY/IV1/LXk0yKKkgmz5lmn63NdZsI/R97mHZSHKUVQfE1j6ES5iNiR0S1JI5ivUJyH82Kehy7jLJPKVlcEM=
X-Received: by 2002:a17:90a:4f:b0:27c:facc:e3eb with SMTP id
 15-20020a17090a004f00b0027cfacce3ebmr7890593pjb.31.1698087889889; Mon, 23 Oct
 2023 12:04:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231023104820.849461819@linuxfoundation.org>
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Mon, 23 Oct 2023 12:04:38 -0700
Message-ID: <CAJq+SaDcwDtnLL0AHaBjXqXtPHo2RF9xVp2HptmSot67PV+Zkw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/137] 5.15.137-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.137 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.137-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

I see the following warnings too:

arch/x86/kernel/head_64.o: warning: objtool: .text+0x5: unreachable instruction
arch/x86/kernel/smp.o: warning: objtool: sysvec_reboot()+0x43:
unreachable instruction

Besides that, I have compiled and boot tested the kernel on both x86 and arm64
test machines and found no regression.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
