Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3928298C14
	for <patches@lists.linux.dev>; Thu, 15 May 2025 12:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747312485; cv=none; b=D1NMaCuvalUtwjPU3kjtaojHcTorraGuinPuKnwl2S8B1WKt+9gzVv1n58CZ0Jpv/3nQK2ydcu8NNEh57Bz97xvMxi2YIxxRsK/K07FgPbiYvZsR8HqKZBaBc/59GTQEGlLsc2o3e2G/qRfaPXsxDExRHR3IP0foyxclsN/Uje8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747312485; c=relaxed/simple;
	bh=TuMvFeK/rCaVdJKjJAwerHfl5Z00/hhg+xzHSyAPKjY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ut8mZnkPd+10zY7IBo4iFWtQwIEfrVOG5tlS5FzJera1al63qGIhUpZeSf9SJMY8fL8uMHrpj631unpVEplZYq5BRU6d6NEPWuuNX/e0F2+oVKebZyLOpI7WCZhEOP2b/qjy2rv3Ku7C/ByO1hNy3GL9u20kYD4uzemxDxzmkFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FtOA2bEH; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FtOA2bEH"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22e6880d106so6147865ad.1
        for <patches@lists.linux.dev>; Thu, 15 May 2025 05:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747312481; x=1747917281; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8g14WITKUispC4svi3eKXIDjFz402ZwoIsie5uvpbTs=;
        b=FtOA2bEHObwhnVgQP3n35EMqVHZ2UGFDz2Wyep1KZ8hCo3un7p+a2JIrJ62yOU7J5r
         /f2F/G9cbZ9/tGNKgDxC+8dgLjXdP9dVvFc0Nm6NppF0ip7xpf6FwrdYd39USiG2wkob
         FkfwQy8HwXWy5+9jtd3z2p7OApB2fk9csBjfv36LLi1MpRLW2l0YjPnw8wLHRW5JItcX
         VSB+H2OuyUr16f2PJLnm0lcpQRWsNMk+cRtdrTmi+6VGIUk5jFkdi7Ob0wTwwnmMVchi
         Hy+yD+qLgMRgvZKwtauX+zxmRwny/fcu/XwOU0x+A407MzWkCnnDkVX8Ib4PeMDsTsr/
         3u2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747312481; x=1747917281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8g14WITKUispC4svi3eKXIDjFz402ZwoIsie5uvpbTs=;
        b=K6NJj1a04AjlmavzaJhtBiaA2hgi5DAE1Yy/QsH5QsRR5qs0nZ2k0mcw3cOz2sXvN6
         eptQg+khIa7xzXUGmxXF2pT7tYPfsHctMHSXXN79+eeOM9ROUTAGgilL/qbEml2hY1k0
         14S+EropePoFqUIG5ghi3qIKiq+GYdsrEDCT5yL62hrYTK9QYi2xPytm20amCklXBIt6
         DX8EFPVWO/uWvK4joU8Ur9XoVuJSVGX5v3ugN1+/AmTSMjfvfZtTvL5prnSiAA0oRE9a
         iHqRefPjc1jWuFcBzDzaCDYsydshiste44/NGHtPlsV7d6kBC6cNpUY3UWStUl0VI/5x
         0cpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWD4fDm5XMwvNl/5cJXfN55rYaOJbwiWbiP+jNsvTPRT97a77CrrLuHd58tTYRmqLPmmBhWHLGp@lists.linux.dev
X-Gm-Message-State: AOJu0Yze2ejs7b3SEyK1Q4eUqLHL1WfeyMMreaS41hxA+lEyj8qHelzW
	txGbkFpdqwcWwcUIdFgPvIpLfHVtbbjBvNPUWKE+yD8ELSC3GohZ5xCXAm3oLi+Xbsnc12mxF/z
	CMmSxme2DI+gA8rn4Q678/xWyVMQ=
X-Gm-Gg: ASbGncvEql0KwWe7Yxuwh3T4TLC7yOmmMf+Jd3nncfD7X7LmtOj+It17PJxNQAOpT+3
	WsUoR8tZvksI1YAmarauiLSuaRK7cRHg9e5HmkBpiwelEqtCzBYBJcDC/OIPGQgCL+iEevkadL0
	X3Zfk4Ia0+Jl1Mxg0mtaHyBVbM9rqmSQmbRR1lY9BUaDHjj9EvF+golaFqHg==
X-Google-Smtp-Source: AGHT+IHXGOzKeRRJE9zCbbAu4uWsVkFOc5cXh630pg+5rvqSiHBSlbECsaOkM/ZnkgB8uWM5JjirYQ87jqOKcJCGzEM=
X-Received: by 2002:a17:903:191:b0:215:b473:1dc9 with SMTP id
 d9443c01a7336-231b601e84fmr31085845ad.46.1747312480861; Thu, 15 May 2025
 05:34:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250512172044.326436266@linuxfoundation.org> <32c592ea-0afd-4753-a81d-73021b8e193c@heusel.eu>
In-Reply-To: <32c592ea-0afd-4753-a81d-73021b8e193c@heusel.eu>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Thu, 15 May 2025 14:34:27 +0200
X-Gm-Features: AX0GCFuQNAmSsVkTFc4Edf3mppYs7UrTKvOfYgP_G21yvSE2cDUBtmgakrnqAXw
Message-ID: <CADo9pHgq2jzeVO4PFW6ObBj2bT9FSWcJUC5fRA9kVjMVah0J0g@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc1 review
To: Christian Heusel <christian@heusel.eu>, Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	Mario Limonciello <mario.limonciello@amd.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Ray Wu <ray.wu@amd.com>, Wayne Lin <Wayne.Lin@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Same problem in rc2 just tested

Den tis 13 maj 2025 kl 07:26 skrev Christian Heusel <christian@heusel.eu>:
>
> On 25/05/12 07:37PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.14.7 release.
> > There are 197 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> > Anything received after that time might be too late.
>
> Hello everyone,
>
> I have noticed that the following commit produces a whole bunch of lines
> in my journal, which looks like an error for me:
>
> > Wayne Lin <Wayne.Lin@amd.com>
> >     drm/amd/display: Fix wrong handling for AUX_DEFER case
>
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x0=
1.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x0=
1.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x0=
1.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x0=
1.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x0=
1.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x0=
1.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x0=
1.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x0=
1.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
>
> this does not seem to be serious, i.e. the system otherwise works as
> intended but it's still noteworthy. Is there a dependency commit missing
> maybe? From the code it looks like it was meant to be this way =F0=9F=A4=
=94
>
> You can find a full journal here, with the logspammed parts in
> highlight:
> https://gist.github.com/christian-heusel/e8418bbdca097871489a31d79ed166d6=
#file-dmesg-log-L854-L981
>
> Cheers,
> Chris
