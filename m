Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFE635C1BB
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 13:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767966951; cv=none; b=Cs3mu3EJdtR13jiwsU5hGowO+kEoLXP9QkY8vZ8Y0S8uMf+VPbaVXpR4SfwnECtv0vGSAI6KdCb5+CVXQYzS4d1+5yfunjg0iIKJIJLJGX/xAuaMF9/7kJWHOjeD/cJuzI34MyL/O5YJ8dh8fdeKsFQ7MH0gGO8tvhRTWRm5cNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767966951; c=relaxed/simple;
	bh=2Yo3C5ERmMfDM4ZSWlEcKdZbPH4vlI6N2Ud2n/PFc6g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fTieYp3zbtOMkP1gBUbag/7cGeAzPyMYt0cSR6UgoUnFUd7sdnDqUeJfFRLPrVwPnlLGlfGE9R+tkWH36567/v4B9/jejIBUlFCXmNTQOrRJLIrMILpIl6BD9H4r6fYvg36ZZkpPmSjHWSKHBAaSFDyCOSuI3hGLJEBjd6vSKT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=XPySvqtS; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="XPySvqtS"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6505cbe47d8so6856660a12.1
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 05:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1767966947; x=1768571747; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PpFrTZ0+VBSyjied1Kan5BDiMM1vNNW7nvgXJ0c0ilc=;
        b=XPySvqtSaCWu4WwmEjGekqErsSqlllwyPEMm6+AMNlMrENRZNFcBUYDmiRBQoEVKE8
         veP0E6XuUBLVfkWrx9QyxsJKF8cSgxA7duwufd/Oi9gzhFzIAJJZAfUGCGZELYQibPUe
         BaT4+xRlGxgZ5fLiCFhzy6iNlhdf6PQB314yi0thmXVxx3exrRTpKBRhVg2pZ7Q7SktS
         U/XDcaYYMDagB3vFPAGd4snnNa7H4MY/zCo4VImt6iwL7DvS6SIVOonXQEYC5sq0yaU5
         egk9fiuuX0uKbv94CchhpfNvnp/008Id3GRxs0oGv+/gg/jMvuw67GqWMaPr0/zENPyK
         vS8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767966947; x=1768571747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PpFrTZ0+VBSyjied1Kan5BDiMM1vNNW7nvgXJ0c0ilc=;
        b=FwO+QUwkyEFNqNKGZS/zJUow+1QeWS7nDh9BIDv4PQCfLQ3TuXMdRVbGq8CJekuZFS
         h6pxTmnwB9JuzhW62lkQ64wzmKElGDHDpZ3NoVD/piKIIJ3HZpWgcKh4i7XQ33dM2s9d
         PDR5ZF3+/Sz1t6fP9msP53cjbqJYOjVOLn9gTGNUx4uudF+G7YNr+mhM0ygfJy5fuU5F
         spHKzr7X+S8Dr5od4FfsAt93T7IrBigpu56syaYvCyXHE0uKFiEKjMoqqgoEaAfJQfra
         Chsim5/8r89xAWIpZA3N9eWmJ2oj/jyMoBAFvCxrLuhm/XFCRZgGgfjfOCf8QVCgu2GD
         Q2Jw==
X-Forwarded-Encrypted: i=1; AJvYcCWv53NVaQ9Ws/muNo4r8TYeRuXpKo/eP/mMXMKDNl0CiUAXzV715bAjM7A0adMV/ms5/E8BsSa+@lists.linux.dev
X-Gm-Message-State: AOJu0YyqdotLbLjd+wQTU20erFmTiAJvIQ3hjp8QM19bIu80nPGN/Gfg
	qbV5McgUiLEVHu0Vps5EydRPUL3jScGP6ZZcs2fZuk+TYX1jiK5GyEFVmlKHqjpWitJwhbe1OP8
	mUeWk6nibP9MKX7ZzOGgqUJrWYu98kpHpbXaY0ehrktLcpET11GdEaDtroZOZUllZJn2lBnfoiS
	1+5XGH4F1UQ/3tZobKy+4Zcc3r7ZBL
X-Gm-Gg: AY/fxX59qtcHBX2iltVwPqdKhuovChRuE59aPWDBhQ+fFKsZswN94K9wZzDpEJh5O99
	ccYX3/99W/9YG9TEW57ivyb/8wnKyFbFsVF0IHfr9+07s7lz/1hSX5xg6oSBBIin33yqx+DC7xb
	c0nlLSyOz4547kv4T7jPesQPrTRVm9i2phYfHUrsV8HCg40i1LDn4LyQEA4bUb6I4XujpOTUPMZ
	owH7ZheiL4LhHqmUW96dlBzbmLNCgZxt91rdwmxOK2vnO2eV7bhNAcvGr85Z9veL7SWhCi7PIUR
	fiHXfE1bwa0BrQKo40Lk64MOMPfu
X-Google-Smtp-Source: AGHT+IHAv4n9Z5meAss2Wg84D8PKp50SiiL5mtVKvS2pIvI3+Rn21z7q+hkwG9BUVjX7iLyv4GEHwejLyq1Sh98UR78=
X-Received: by 2002:a05:6402:34d5:b0:64d:57a8:1ff3 with SMTP id
 4fb4d7f45d1cf-65097dcdcfdmr9011967a12.4.1767966946654; Fri, 09 Jan 2026
 05:55:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260109111950.344681501@linuxfoundation.org>
In-Reply-To: <20260109111950.344681501@linuxfoundation.org>
From: Slade Watkins <sr@sladewatkins.com>
Date: Fri, 9 Jan 2026 08:55:35 -0500
X-Gm-Features: AQt7F2obc11Ixda_pyW8d42vhGcxIIDXRy4rNoe8mp-6Sgs8-JHlVw4m3X8UdQY
Message-ID: <CAMC4fzJQ1kVczNs7XhZSVRRY0iX82UQD1VrbmX6bFOmAvsFxsQ@mail.gmail.com>
Subject: Re: [PATCH 6.18 0/5] 6.18.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-SW-RGPM-AntispamServ: glowwhale.rogueportmedia.com
X-SW-RGPM-AntispamVer: Reporting (SpamAssassin 4.0.1-sladew)

On Fri, Jan 9, 2026 at 6:45=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.5 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.

6.18.5-rc1 built and run on my x86_64 test system (AMD Ryzen 9 9900X,
System76 thelio-mira-r4-n3). No errors or regressions.

Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade
