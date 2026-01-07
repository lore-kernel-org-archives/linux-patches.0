Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2922A76025
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 23:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767828751; cv=none; b=jD83gXmXqMXIV9UzzJ9jOeDY92RYUi7ZuRbSqes9fCKzQ1tAGAs4VJr1ku4YDYZxwaacBYyC/+R3Tx6IharaZx9dzuvPHpCynxHXz5dWpANB9A1+CtPsHu5boP6WvcBC+CTgKF6t4Zzd4/inQ8xMVr0BcbFP/jnw7QFgE5bpLnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767828751; c=relaxed/simple;
	bh=uEbRyNx4dbnk3va4dkb6nQGKaRtW5j4AqrcIBxjnGe0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=spWs56Mgy5CDhW7ARI8mmXdT0IHx9wNkgGSwRFWN+9vzbXXZaPoMH/qFA4LCESaOiNAKEnbTGnKwxx/PzdvhGF5uT5JmItVPm/bSfhRBkY1f4HiN2sRrUpDdzdaFeDCJlGLleuq0wyUWw6IM0BZgFJRxg+IflJF135yvhjKT5RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=AHvb29m+; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="AHvb29m+"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8c07bc2ad13so178664785a.2
        for <patches@lists.linux.dev>; Wed, 07 Jan 2026 15:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1767828749; x=1768433549; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rXU7HG4DiGW9EYR6wyIKez8sdkatjxPlrKyEoeiugvI=;
        b=AHvb29m+clrJ0y1OFCLy9X7KoISkc8OSbe3oN52OwlkTK+2D1CKLCLZCptlZjUHXDu
         8IB5dV00u5WzIk/njOHypCqKQuBlpydvbpr+TbdVhKScyLfj4g4MJ3iglxGzIhBM+MKJ
         7y+6ltSeIjJ9Yz/jn199hkQ1HfQodYY6mamDlN/48Pkp67rxgGKEZ0xkmR+f6DYDazW3
         ehRIywm95K19LJH/l1P8Ex+AcDTq5db8n348qrDb/rMNUPFH++DEwT0PFXe+V8UFygTq
         4DNwiVRqNBXkJ9oJIqF9X8Ed4ADAo4pvudX0fDhbKW+2vw0cRMgZuIF+jkoU4ivG+BVj
         OAqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767828749; x=1768433549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rXU7HG4DiGW9EYR6wyIKez8sdkatjxPlrKyEoeiugvI=;
        b=KWDFUU2FYLnq6v4yaOBEQzdtW6ac/i1VxlGDy858GXpvlyKBziZmRAm6flP2caHp+9
         662UM+JDZ18sw5+U6ApaQYLaZ2IYQ2u6asb9kkEx4HmupNskKsuV+Mkz/pftssU9WNGO
         d7G0IvJ1CRMHIwIFnVmGDUQrHEG8AhVVuDxf11FD331UXf0VmQ8U1LyHp1pMgl8kdWK6
         2HcL9V0nUsveBX1IllZ4Q121/bAfTPZUMm5bPXvj97YkmXC4ftSJ5Rrfq0s+rTVYsLMU
         Sgqgc67Pp9Z+XBsVhSUhTXR/wXTFga1gf7gMPQcg9ZwC9WMRV8kvSeK+phjcmBWHeidJ
         C4Fg==
X-Forwarded-Encrypted: i=1; AJvYcCWuSuG3c+bgfVYfVsabFAWHAJo6B4rNutCdK7uMViprT30yebVszgTtQDx9Tvdvpj4MBcYua8WN@lists.linux.dev
X-Gm-Message-State: AOJu0YwoZkQK6mOJy3O9t0Sw458NLkyGp2dEGeKAFMQeOwxxkoOC2909
	j3UWeKIVDkJyXXyDUTOJUqfcsDN+2kYyUPAq1orldBb9ZwTJMJPttnBClEBCrET4Iuo6B1ClErR
	H9MLjASXuiRRAcWfcS6LJITcmYJmDrPq+1izMXzJHdw==
X-Gm-Gg: AY/fxX7ubjV/xDQsR/yUmscSEAYz4rsdoJqQ7mhYeO8FUqulVAZ+VkJsEgpb/jr7jYN
	mAUR0FAf/4sH9XUtIBQYyQ/hqaEnMwaFkAgezsp7+ax9LN+4pZbvVvTS9u0tx5vc9NgQgSqmuMT
	PVWRBdxmdzz1tD0vhnQsLDR3JvjV1EdiK+lGkQOLg9SxyQTTQvZP6/UtxHsvqSqPA0Z98jEFCbX
	uRs746DQwh7SgkIaMTeF4pYSeZksq3Un4DgutiLMU3tMEQyWkl+Ed8Coe51fDTGl+kI6yNL
X-Google-Smtp-Source: AGHT+IH1LByqW7ZLrFp7glgjZt3g2J6ITYVw4T9fJNyN01hTZ7xZ2tadzEjfLG1sesulQCTiO3En4id7s6uBsJYgxU0=
X-Received: by 2002:a05:622a:1b8c:b0:4ec:f6d5:ee46 with SMTP id
 d75a77b69052e-4ffb4af497fmr48506811cf.78.1767828748846; Wed, 07 Jan 2026
 15:32:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260106170547.832845344@linuxfoundation.org>
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Wed, 7 Jan 2026 18:32:17 -0500
X-Gm-Features: AQt7F2rjHXXS4VwdsUEM_LyelKMet1mu2lb_KbzqRAyBq5WcDAPhpkZeVFckzz8
Message-ID: <CAOBMUviKjNiTkgvipUTVwzwnKO2-1RoAc+uxM+uwyRSceeQHHA@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/312] 6.18.4-rc1 review
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

On Tue, Jan 6, 2026 at 1:41=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.4 release.
> There are 312 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Jan 2026 17:04:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.4-rc1.gz
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
