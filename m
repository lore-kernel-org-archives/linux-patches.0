Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF5F16CD2D
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 11:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724846041; cv=none; b=EvSLXILZdlSVqmhSKCKLFy+P6vRLRddmgP7qNMJBmnKFPpbdS3E6IMBHVxx5sUXvcqNkp81wQ+TH3DtnMCR7oYFBoncaqKGUtCrd0LIP9GRSJQ1etY6u2601nClD1MnLd29JXOO+AuJW0wUYi7iZd5OGKxZgzFGhIgBHE0LC0N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724846041; c=relaxed/simple;
	bh=O5gRyO2dJwvVCjf4Lq+k0i1gW54cEy1YRZ2SK+gyhV4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iGI1ptCfrafj35iLdlq1Rp1WiuQm7zIg3UjEKbB7i2Zf9wIT97dFu/hcvxNv/68hpcYg5VvYqkprSeZ9Kim6Mgf/8s8J/AMFX6MtYDFGJ9bHd4BsE2cn001Zg4r8V2V6Goh2S6ppiTz96tvGAYZtlFbobLwYg/Ljb5nou3eBu6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=zbcVlb7F; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="zbcVlb7F"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-429da8b5feaso72992155e9.2
        for <patches@lists.linux.dev>; Wed, 28 Aug 2024 04:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1724846038; x=1725450838; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nDiNvFz6rdknbMnlsxqJINMU+j1qzEyGSwhUAud0ULQ=;
        b=zbcVlb7FMWX3Fc5sA6dMQE+YslVIM8lssRYjI2ppK4XKJ98xsPi+a1mq0HPvBjLxRn
         RBgKzSInSSbG7AEarx20FH4pOweetXuNg1LtpoqO7/D5mvpIYLXcj1ETZ+vPPJqJBBiW
         SUHL0NC+OuGF7oSgdtUq1OoS1Fn3GSvO2X3DF2JV397f207x15saXIUCbsxt29tc7ICz
         oOXmo5j/K4SnPcI2Vu90SkXg+YV0S6Hxcyamenl2ZU5tjG+8oW3x4HNSMPSoMPFGiz4b
         u6S56WG3a1f2wELrD9hekSuraABWClmLhddeZWTuW2k6Kb31hJQifdvZ4NgXfEtU8O3h
         c2pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724846038; x=1725450838;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nDiNvFz6rdknbMnlsxqJINMU+j1qzEyGSwhUAud0ULQ=;
        b=DO82BGp2NfrR5w0CUTMCEAyHmCaW4rV/fj1uA5UYDNCn9kNMe9EYxBCgB8mvIGT9uT
         Aae0LtkM0kmlQpklbJmwzJGSNjbjjy9us9qYFMccEXxahu4HdbDxXyWKhgRzC2eoRIT+
         dvHRzdtmqQog+YXyCUgNwyFxgec+L4v9geB6z4tqKtEKffhlNfjwSzXOLaN5r/ANZWAi
         5+Rgovz8p6g2NJOJsBRcZH7xWBKmXWrRRd0azyDx/2R7zwECm8s9NtBZ4AGiAw2JmbI+
         mZ1oHLPxGfZ4satZgXnsMD7boxERS0N/5GXW87STvuuK8cQJJm/ofNxbL8eUoAL5RYNR
         9eKA==
X-Forwarded-Encrypted: i=1; AJvYcCXOihCrI4fWRZR9JFiEF+cudklDLkg9CWYuapjpBzotTSspxgpJkIqCiNIoo/gTGxzNpY0JbeWt@lists.linux.dev
X-Gm-Message-State: AOJu0Yxgeh+lA3FdJmw+pRnbtmeelK39LRdTsCNVf13X4mhaX/kIRQuo
	/sRnF+w+qETse+HXzupcAX072Pi8C5bXt35sqk+qSawcVQ1TDmJoqIkWwm9paFwUrN89QIrZplq
	4FbhkcgsDtCTW7slxvxy+W7HkapbDjyTXvsNSYQ==
X-Google-Smtp-Source: AGHT+IFMWJPVBATysLtHqzNH0xeMJFF+wNbScXEeMxIJsqKta5Qy2aj8q2fOfZRtrVc3Zz9FY/1UkXj5heT2s2GHOug=
X-Received: by 2002:adf:ed11:0:b0:36b:3395:5363 with SMTP id
 ffacd0b85a97d-3731185600amr12989156f8f.16.1724846037761; Wed, 28 Aug 2024
 04:53:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240827143843.399359062@linuxfoundation.org>
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 28 Aug 2024 20:53:46 +0900
Message-ID: <CAKL4bV6Jhp4pjBbkCe7m5639CmFMv98SF0aVg4SkksheTTOpXA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/341] 6.6.48-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Aug 27, 2024 at 11:42=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.48 release.
> There are 341 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.48-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.48-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.48-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240805, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Wed Aug 28 20:10:31 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
