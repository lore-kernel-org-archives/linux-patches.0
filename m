Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B9E23C8AC
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 10:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741776743; cv=none; b=OiPMEz0eTDLPG+o1MYViwc1s7LsYHWsRcJNwEmplLcxFGJGovNzZFMropAOWkgQ32by4XvrXKgODrBoOLos31U0sX3KcMLWmLef6gVnpddUDshkOfPnkQOFAIM0eakdBSD0N9Z+eCSNGoy6O4jNF3t9gDXAk8csqrbB7MF/9VBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741776743; c=relaxed/simple;
	bh=gjbUH7kAKKc/+1hKX36//HYzvvD9fqa3xfDCPoqEeBo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WbZxxoJCPUTW/54bjpFA2WZfUYUY5uJQ9E/NreQNTc83zYkl1INGbUT3USA7niZ/sIc4dwpEVsV7eP2rYrd5QE8mu28mgBg8L7wlknbga8tNaNmLPBihrbpZGjFcK+O6AZUo2YqC0pvwfWURKMWZDleb3W57ud4JBvF/A6n0pUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=dwuBmCRF; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="dwuBmCRF"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2ff80290e44so11140381a91.0
        for <patches@lists.linux.dev>; Wed, 12 Mar 2025 03:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1741776741; x=1742381541; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O3+PiV+uBaafq4RBHeVzsDnDBDg3GEz+NalwGRbaU3I=;
        b=dwuBmCRFBmrj1vJJq6IbfZOQFAQY/7Fjm/bok2xpcPmevstaYGsxShEblL/5y8idWT
         YE/VMhkp8WBH6CwVYV/2IK7HGr4z3OPC79X3zedD7zjFNmN3MTUybQ9uC9R9DXd8tU8s
         /F+NU9ZuMUFFLI4yvMuDFj7wXmB++6b6PhKKbzfFRyU/fHas1wL/xEW5IQ5YtCgZpuxy
         NMc0S3iB6htMwUgHlXjh9INlJqeQLGcLQxq/grWktqo3bnvIWBEvy7L7GAGCJ2S0V1m5
         A4U3BH4nEmsfjE97OvS3qHvvtVVR+YZCk0SCKwACBLz+Gy0fL6xqYHmaAj1urVYRIJUu
         GBJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741776741; x=1742381541;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O3+PiV+uBaafq4RBHeVzsDnDBDg3GEz+NalwGRbaU3I=;
        b=lYJ9FymbfTrP/onl1Qhdfw7cFAuBkqInUBlRM4xs+3P3S2/j75JBwCC2jZE1q6oiOe
         vZtgym2JJSzd+EtTPL0szrqM/PQKueOucETmqXQAfK5egRzVBsLsGlEQs5BsVmkEhxgM
         sc0WxduAi5WBRLZF+qqMV8mhG4IdrQFU7OXT+BwUfgonM+WYQU3ZI1CIo2hJIdXIq2jF
         gnMnDNKZZDZeIvvuivtdEeFoodvSOurCe8YTS0zCraTYiHHXuZ648ZaQ9vwuX9sgTvW2
         QYieE5flU9ub5mTb8aAmqg6feZh573sXi9cNtB+tAf7GfTDS2XmyqxrXZy3okMFEZ3RS
         /1NQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdLYdvSy6AtuSk3K8FFutMEEI7kjl0qOKfyBzHIyY3ezNOtpD75CgLmod1I4X8yotnuxgOkW4a@lists.linux.dev
X-Gm-Message-State: AOJu0YxcmXVWiQS2e+6d3g4Mhgl3FK1iPryqAop6WBPXgLkC3MTdPyrv
	EmVh8y8VfsadpPgoc05Jz2xSEeIMdpNLYaeNvfotth5b04m/CvNjLgEMdCAdQ1gYS/gKLJm2qHj
	RimQJRTvi83cZsl8ffFU4Gm5Yz5KSbniLDk+MAw==
X-Gm-Gg: ASbGnct2JQ5nJJVGFA1rT2nivw9bB/wNmsts/M/uBYlWh70d7kZWb9Rkpwzd2RI+M3t
	e0y/bVkVz2b2Jn+a3zyjMp0ANieFQHepi57U6ViZvrbZbSanQxoG59JMJ7pyoEMxPwZR1Jr1rtF
	oV7Q/mbc9CcYuJy1UecimbFvqXZg==
X-Google-Smtp-Source: AGHT+IGXx8ieZdctema6C598fuszKIgN/8+VSXT227UVWm6XgcSn9URsXMi9AG+8LL43/vYhgBTSwNHH8ZLeDEUYwIQ=
X-Received: by 2002:a17:90b:3f04:b0:2ff:53ad:a0ec with SMTP id
 98e67ed59e1d1-2ff7ceaa31dmr28985099a91.21.1741776741223; Wed, 12 Mar 2025
 03:52:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250311144241.070217339@linuxfoundation.org>
In-Reply-To: <20250311144241.070217339@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 12 Mar 2025 19:52:05 +0900
X-Gm-Features: AQ5f1Jp4vzwvaXW8Cwgt2_Y6jV8MGhoF-jpghBXlm-wtunoGhrfsN0XP-137aQc
Message-ID: <CAKL4bV6jjxYR=x5=r-bed5Hck5ZmOAKTdM-PxL9-JTG03WndTg@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/197] 6.13.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Mar 11, 2025 at 11:48=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 13 Mar 2025 14:41:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.7-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.13.7-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.13.7-rc2rv-gfca1356f3f51
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250207, GNU ld (GNU
Binutils) 2.44) #1 SMP PREEMPT_DYNAMIC Wed Mar 12 19:21:39 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
