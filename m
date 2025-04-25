Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F06123C368
	for <patches@lists.linux.dev>; Fri, 25 Apr 2025 08:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745569081; cv=none; b=kcFLLFVuCoy785/AMMZ5zTXEINyEVBV5ow4n72Lpra3apP/Vju69u7jG1aO93vAfvZroleqdzmvpjh3uHz9ciysIR8hm/MO7LlzIsaHglmItd0VTR5UgBaTn1qsJASaWOd6E39Uf3OeLJ0edqoyZSQkL1SrLNh0JaPrRWzzzQ0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745569081; c=relaxed/simple;
	bh=ockCoErXJYNNWIE4F1OGfTdTciM14pc2rGFj8KF/fos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PZi9iDYFKvJ4LIxL1rbhYHpdH9L2JmeCBS8XXOs/NiT04bPIURNJbhyZ7lXtE/GdSmRNEsF+1rI/b390AGB6H7rKwSNWbaHXhAL0AmHdkVnk9nKKtUEOrtDBNPpnTCwxZMNlv1aSoQIkzKG0Fn34pioQMKUii5DQFIhdth89JuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tLGydSwP; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tLGydSwP"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43cf05f0c3eso12839755e9.0
        for <patches@lists.linux.dev>; Fri, 25 Apr 2025 01:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745569077; x=1746173877; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pIik2Dicc6zrNNPkgRyVhu5BjNjWoGlcqMwS0QNX8Sk=;
        b=tLGydSwPWv5V2J/ti7DUZ0vavawNZRJyhPB/cqZxzaR5x2hI3My20QJGiDMNlvvxUk
         Y8oHj7iP/4chnjpDbSjObtE0RqV5pEnol5sh2zSmUZTk6Jq5sN3nx9sjX5/gqy+8lFmr
         7oxy5WaUjDmUubbKBs51MLudGjDPq1LQHbLAVTYlaEVgoLoGPQch0x0A1u2OE0WhyKz0
         SBnvlWN7JnBvDdmlR9oGS0qwt5hjzSXhHN4QpAuxT8Js0XkxJHaP2EzDR67mEx8ZwzSD
         nOY/IsFbYCKi2aAXU1F1UXwQhQN8OIcuhIzqtRHmbtxTy0MavlJZqM09Vz7ouKMV8t95
         mhGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745569077; x=1746173877;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pIik2Dicc6zrNNPkgRyVhu5BjNjWoGlcqMwS0QNX8Sk=;
        b=ZaaSSDHHIqaNYYEgsS92eNND2cHROrhmea9CMFB2EGinzvcItpA7zWsvZarExRXyzT
         fJVmOQtE5zfYFnk2J+ReEQcZtx2cYiUwvJdUqvfX1Ipa8mEoFBVJA2JXESwt+x94XdRS
         JOIjZleEmRYFyYFeASFGsIiJNKkhfxNNAMfeTmSStVrWzPhduZCtJ7fAdaptPazjr8Ud
         CB/g1r5NU1hrDhJH+KMUHhgUYJsQwLp2yrpzS9KpToyqoNOwsoFbYk4EFNdt1cgpxjli
         mULZZcL7Sw9vRF1qrMKxQOWuv2j+3J2YYXbK1bFkWNMY0HISArzmSw17n3+ZYHzFhU4q
         JVuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhhewCR4Nrijl2ZpxBqUaaAKKXVLOTPVmzLfRTHEbUKTcKoyO0xfKL/b9oADvURDB9B1ckjq4G@lists.linux.dev
X-Gm-Message-State: AOJu0YxSKe+7vFsszY2CaHsqnMbiVT9xlY+kk0tDw9PNWSOzOlK/MEmV
	KrBYQz5d0/WYwohDmOGXwk6MfBB9SMuLoCGIeP4lzdvl+O88RmrcFg8Y8cilt4M=
X-Gm-Gg: ASbGnctSvjhSRjnlI3361LbBBJ2uW4K9X1oeFlX3fN568ICoCr2XSLoLZK9qOZRgSd7
	7Cmsly/HIz1qHkJFo55yWUbMroYoVmCYCdjk0kiiNCCL+A7JVUM9mx04Rp6/UtrYD5Yvqi/UmKI
	X2OaUM5Y2X0slkeY5pzcfEVOOpWeLktJUTFwBmiK1mmmMoAd4zwmaDdJ6IySMp15kD8JALpu3ss
	DvqwBOpyS6A909Pz0ZhvFEaimFFCO7a35MKme6yFgPH1Jjdg4KkFDAbPgBj/MwTrE070Chr384h
	KoAe4dpHPTxWrh3UIccZvMT5psThRateDKp89whlJ/rgvQ==
X-Google-Smtp-Source: AGHT+IFtIhw338SCwM97fT8DE36JSktmwAws0V+m2whiTCc2WvjhYcfxYH8N3RZVkd/V19BgPW5uag==
X-Received: by 2002:a05:600c:3d0b:b0:43c:fc04:6d48 with SMTP id 5b1f17b1804b1-440a6346aabmr12093055e9.0.1745569077572;
        Fri, 25 Apr 2025 01:17:57 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a073c8d1a5sm1671072f8f.13.2025.04.25.01.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 01:17:57 -0700 (PDT)
Date: Fri, 25 Apr 2025 11:17:53 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Arnd Bergmann <arnd@arndb.de>, Liam Girdwood <lgirdwood@gmail.com>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Marek Vasut <marex@denx.de>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH] rpmsg: qcom_smd: Fix uninitialized return variable in
 __qcom_smd_send()
Message-ID: <1cb8c180-a93e-4d5d-a17a-6452dd154801@stanley.mountain>
References: <CA+G9fYs+z4-aCriaGHnrU=5A14cQskg=TMxzQ5MKxvjq_zCX6g@mail.gmail.com>
 <aAkhvV0nSbrsef1P@stanley.mountain>
 <CA+G9fYu1GagoVWnhNFnknWf0_zk-O+5XQXDiL-XUdt8knhJYaQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu1GagoVWnhNFnknWf0_zk-O+5XQXDiL-XUdt8knhJYaQ@mail.gmail.com>

On Fri, Apr 25, 2025 at 11:36:24AM +0530, Naresh Kamboju wrote:
> On Wed, 23 Apr 2025 at 22:52, Dan Carpenter <dan.carpenter@linaro.org> wrote:
> >
> > The "ret" variable isn't initialized if we don't enter the loop.  For
> > example,  if "channel->state" is not SMD_CHANNEL_OPENED.
> >
> > Fixes: 33e3820dda88 ("rpmsg: smd: Use spinlock in tx path")
> > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> > ---
> > Naresh, could you test this patch and see if it fixes the boot
> > problems you saw?
> 
> Dan, This patch fixes the reported problem.
> 
> Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> 

Thanks Naresh,

I left off your reported by tag as well.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

regards,
dan carpenter

