Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F323C456A
	for <patches@lists.linux.dev>; Wed, 25 Mar 2026 10:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774436280; cv=none; b=jalxnA4VB3C3iKqqKqc8CPHQQGlCOR0Nd77rcDZsEUh6Go5vzv3ytompxfDT6dA1CaVpUgDtnKnsIheNKoGinGatyxgc+lu13sGILQ4SUOte5EV/B7er0Wgs1pV1Zvd660XJayn1WLyqpRaiQfsMe3LZ8PW8GE2bPDGPlsHIk0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774436280; c=relaxed/simple;
	bh=2i2zBV9L9/qV6AGrjVDSWPWPK8DLvyBNXgOJJh006E4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WbkOFwHIGYSdyclgg1uSQWMsIpbNRdrza+wpUiHWtBtAM0pNSWEVSYidxGEjXIZAyWDt+4G5pOxy80bDYHNWr2GCsUTbUYRW6mbQHwcbACbm6yEfGbOkTeo7BmaLvU3ry67C9Aa/KQNy+Ff+EFhoeK7nc5urISWBkBktDSQXLt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=S7GaIoAU; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="S7GaIoAU"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-486ff201041so43781275e9.1
        for <patches@lists.linux.dev>; Wed, 25 Mar 2026 03:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774436275; x=1775041075; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1tr+DPBLNHUTma6B3EgTqBqGFQCe6XWaXcahqS5DXuc=;
        b=S7GaIoAUiDNG+7Yj0Z0D9C1Jt7WMPI8mm8VMOd0883k6Vk2sbzT7m2RKWZQ+lPTSje
         u44wukSo3w17MKPHviuOzaRJQnzWgX/10s4qLA5IWttKuwp9WjOyd98SEsC/Nskd/Poo
         hpLDG+kko2DnvwMfgtww8TA0FrF5JYEkXHHZXmmNddM3OIgNnkrKbFEeeYA4AG6s9Rt5
         r5JtQWZbGOLg/vsoSwOt3ImyRQeoMjfWzrj4ZkL06dUcbDwGhBSRCUDLzvS+FonlNxHI
         3Gu9uK4d5OsCKZea+oV6uDMUlsbyPXpFjwLS32QDO2hvCfggsD8WUE/cT/qRqEir5MLs
         XtnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774436275; x=1775041075;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1tr+DPBLNHUTma6B3EgTqBqGFQCe6XWaXcahqS5DXuc=;
        b=Qv7bNXcrNjXrlgBwvjOjjxebRl5bmf+VZmhcPz+LzIhjfIshBBAHAZWTsFXqP/NZ9c
         XiL8FRYTIfAUmQmwISNVFcHsxccVoC4Z9V5dVEH2mwlT/LnXL8QToskg6ql/YrKyTg1w
         v6cUNt8ZViot9hKmgF76CtTij4msCOJKLKZmil6J/B+BgCMBHMJbzXF7S+40gVwTSDJn
         Zd3wrW411iLLuiRBMSS9eyZzBmBr9YLk1Pa2z4jLraCTS5nCsNfkg2ivtDvMdpEn9gbR
         wILcAHC6a5j58fMDD0vAVRISHcor/lHkLGuhG4UxBHCSo3EWL77551UWOSE0sda648F1
         4WPA==
X-Forwarded-Encrypted: i=1; AJvYcCXx4SMFYEx98z/byPoV42TSKkjFHlAKjUyenE8oFnmG7RKpnS5szAy1OF5EGhHDueicreG8QH+1@lists.linux.dev
X-Gm-Message-State: AOJu0YzAgH9L/r5uRRsODQ4qtaPGsRfKEPjYsEv8ZaYoEXtgLQ6OFuiU
	ISjLpbK9A0dmWmRTTJEOfBZtINJwkHzpRXLY2YVj1jddWETQwXoFmoopUfl66kV4Gqc=
X-Gm-Gg: ATEYQzyI5rde1ffpBznWKsU3A4tymvtwUJTJ9ujCNZoZnGBXoTad/Svs1QTRx6QVSNv
	zqMYgNu34RpDd/aUIA7pliq4hnxLLSPYxVx12ArJdSaaDtWvQ/tym7iS96OYi604xeB/5o0WeNq
	Z0pm3zIf7Vszvi2y7SQPgUeSZ5KSfK7FgLzNveGM5OWvKAeJvc4SKUQ9XiwJCE7q6GeFq60+97+
	z6TpFDCjPaqxuSjsQtsaqpLSQhaBD7kRgmMkQKryX30ayH3DK1assdyNCFn8fZ69/+EIPJGdlir
	bhFzBdHNB7ah6k18TwXmm1vHHSehOMg+e6Z7D50vA5qZSzXoyP6NDauENHOg5I8sfuuTPYNRv+X
	dFuxTtYzCF2OE6nhZZOHZ7+587gMBE7jqj2LQq2u1n6jeY1gQpI6ttAlj2pUhV7ZszcZtW7jelz
	ug/89zM2f2pQj1O/25/DkJyPj0TjEL
X-Received: by 2002:a05:600c:8886:b0:480:4a8f:2d5c with SMTP id 5b1f17b1804b1-4871606dd88mr30844415e9.29.1774436275247;
        Wed, 25 Mar 2026 03:57:55 -0700 (PDT)
Received: from u94a ([2401:e180:8d68:92ee:b67c:a5bb:13e0:f6f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08366c56bsm258439545ad.57.2026.03.25.03.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 03:57:54 -0700 (PDT)
Date: Wed, 25 Mar 2026 18:57:44 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/567] 6.6.130-rc1 review
Message-ID: <mujla3hhjkr2qm3vydifnafnnuhgjje2woh233qle64srxudm4@cabmtcmjnj2v>
References: <20260323134533.749096647@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>

On Mon, Mar 23, 2026 at 02:38:40PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.130 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/23507388452/job/68418868950

[...]
