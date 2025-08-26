Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B43F31B139
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 12:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756209981; cv=none; b=sx+hiLaIfGawAi1CCccpZFlVXDeFcN+jupENyq2oKklD7k1EYJj0xsEruLz/p8+fUtzI4uQauYc52nnmgUiVRPDc5veis5cHDf/oBRupcUXuO7hGN6HmAdPSxxTTAD0399VZ2h6yZMYOZvt8ZPjeSWl6SiVP3g8ruc5SvQRsUxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756209981; c=relaxed/simple;
	bh=bSRRUAqhvp44h3dVi1WARRkNFMByO0ADl300jk30jNI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BmelSoIy6DW055vVp1QZ2cT4B6SHnVbxRGBP3oKdU63E7za7AAvi4YiYd3FbDdUwH+VHHuDoOF/Fk3r5mkgtYwUJlLC6dtW3NLlrI4wPckxpr6ok9KZYQsnsk3awlgZ6Zt9Ve8vQKUbUHqFM2KvJq2V40l+M5PR1j4LIMU4m8h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nJlGIfTa; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nJlGIfTa"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-afcb7a3b3a9so816274766b.2
        for <patches@lists.linux.dev>; Tue, 26 Aug 2025 05:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756209975; x=1756814775; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lxFjkTB2P79PoUaLxLAUp+gv0c2aOYdZxNYZuNh3BDw=;
        b=nJlGIfTaKJpGQU28Bfgj9HhacG6pMH0e00Yw43rzB7ugyrKA9s9Nm586hjB3FeuE1s
         PMClWfCZ+J8nzU2sWHaaKHjMsCvKuUM5CtAhJlIk9Eq0mrYodhZH/ejhZUdh+zXZu32Q
         fNfnk/dzCx6oaq7BeRxbugvVtZzyY9oSPWuuxeriLb1rpGFhIOxAfSnMb5qwA+7DZG1l
         5d6K2pTY47mknGoA//ABLAS7/ry7eINBojUG0h/1ruardy1YdFMIzdcReMvPg0x/8Zus
         BlQIEBGBs9LzRwBxnFNOjcxC/kNZTpW4fr07eEw3KMtx5tKKuZqfKZAAqkqIJrPXx2se
         IHOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756209975; x=1756814775;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lxFjkTB2P79PoUaLxLAUp+gv0c2aOYdZxNYZuNh3BDw=;
        b=Y6fTOWOBB8aGmFK2WEuE9Ooc84exf6nJM2tPJyGxAW0GbaiqLihSToTTM4qAso90F6
         GXWnhtxRXbdA2TLntCeIVsewiMpLUzvLBpcVU+W5PSMjgPrdO7t06ArVoRSAAl+1aDwp
         mNsQ4usf5huIQ6EOOUC1DRhFJ6Nrut8koR881SkHAulrDYo5XIL/lKGHJGTS+rtznBQf
         GejTcj70XQemfX5ms20EIjRIZ1hAxCA2Eo/LAZJ1QRZCwQzgqHXKC3mPM+kW74hbliUV
         SLbzM0U2I6aSw5jEEdncxqi5ft/zGvyNiKeE1t+aH5gUqJgi7I8IPZS13l3J5ucfka/Z
         A+CA==
X-Forwarded-Encrypted: i=1; AJvYcCUWraqfOKR0ctcxg6HVQBLBOgCAWxRS6uoccF9w6L3sHpryqMMn+01ssfHi/NwaDhgdHCdqyENK@lists.linux.dev
X-Gm-Message-State: AOJu0YzflvfDTD4tKEZ/rwBosPtwNwdTboL92L/+RdguM7IrLq0/rBL8
	/NEg40gADXLhdRDs0o0A2Zn6uXW9zswtqt1gTXdDySN/vKqOha2z++b5Va+U3uNy1BgSiz46ybV
	6BOcYXVm2qPfR11Ptj4NZXwo/biyFJMB5In1bVBiTCA==
X-Gm-Gg: ASbGncu9E3J8XR4y+5c4qJ3nMHZRwCQx9P6NdvdP6WeMQS6BOfbiBhxJD6GYG/ohsz4
	DkjZx5FAXpFsCh7HzfUS8ggju0Lzjg/8m2SPBAJFBrBGX6HjO1eLMoaUMX7h8by25fDCDkDn1l8
	oBtX66sKftXWJbMYWdCz4RwlLukAmJU5csbwHHQUdJUYj7Qbk7YJXmCu+kFhFYxBpuYbmTFiDPU
	AiZGT+WG6KENPyxCq7i0m89J9suQcs01ILjmPY=
X-Google-Smtp-Source: AGHT+IHCPPogA5I5xYJjZ3AF2Jj1OEbjkizkVIqqQo3oG7dsb9k66ChvqgzLqUtgok2+xdd2moMuf4gTw379MNCuFxA=
X-Received: by 2002:a17:907:3f0f:b0:ae0:b3be:f214 with SMTP id
 a640c23a62f3a-afe28ec592dmr1369727666b.9.1756209975430; Tue, 26 Aug 2025
 05:06:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250818124458.334548733@linuxfoundation.org> <CA+G9fYt5sknJ3jbebYZrqMRhbcLZKLCvTDHfg5feNnOpj-j9Wg@mail.gmail.com>
 <CA+G9fYt6SAsPo6TvfgtnDWHPHO2q7xfppGbCaW0JxpL50zqWew@mail.gmail.com>
 <CACMJSeu_DTVK=XtvaSD3Fj3aTXBJ5d-MpQMuysJYEFBNwznDqQ@mail.gmail.com> <2025081931-chump-uncurled-656b@gregkh>
In-Reply-To: <2025081931-chump-uncurled-656b@gregkh>
From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Date: Tue, 26 Aug 2025 14:06:04 +0200
X-Gm-Features: Ac12FXzW7NUCjgYWSamJwSOH-347hP9Z3Gi-swjOizdLDz6f5VXnlkQBVvbGglE
Message-ID: <CACMJSesMDcUM+bvmT76m2s05a+-T7NxGQwe72yS03zkEJ-KzCw@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/515] 6.15.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	Ben Copeland <benjamin.copeland@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Bjorn Andersson <andersson@kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, srinivas.kandagatla@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 19 Aug 2025 at 13:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Aug 19, 2025 at 01:30:46PM +0200, Bartosz Golaszewski wrote:
> > On Tue, 19 Aug 2025 at 12:02, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > >
> > > On Tue, 19 Aug 2025 at 00:18, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > > >
> > > >
> > > > Boot regression: stable-rc 6.15.11-rc1 arm64 Qualcomm Dragonboard 410c
> > > > Unable to handle kernel NULL pointer dereference
> > > > qcom_scm_shm_bridge_enable
> > >
> > > I have reverted the following patch and the regression got fixed.
> > >
> > > firmware: qcom: scm: initialize tzmem before marking SCM as available
> > >     [ Upstream commit 87be3e7a2d0030cda6314d2ec96b37991f636ccd ]
> > >
> >
> > Hi! I'm on vacation, I will look into this next week. I expect there
> > to be a fix on top of this commit.
>
> Ok, I'll go and drop this one from the queues now, thanks.
>
> greg k-h

Hi!

The issue was caused by only picking up commit 7ab36b51c6bee
("firmware: qcom: scm: request the waitqueue irq *after* initializing
SCM") into stable, while the following four must be applied instead:

23972da96e1ee ("firmware: qcom: scm: remove unused arguments from SHM
bridge routines")
dc3f4e75c54c1 ("firmware: qcom: scm: take struct device as argument in
SHM bridge enable")
87be3e7a2d003 ("firmware: qcom: scm: initialize tzmem before marking
SCM as available")
7ab36b51c6bee ("firmware: qcom: scm: request the waitqueue irq *after*
initializing SCM")

Bartosz
