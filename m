Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859B12D59F7
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 17:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763744762; cv=none; b=WIvvHHzygloGqJ6AAHt5IkTX84H0NIUGDZs0/ghRKhVqadHb6ynHipYZ5dNkn/8Fw/KBd6OPipReoRSq3obLW0kwGLBFEcsKuD5BhuB1J8JcPj2j1SPmigqC7It0f8PzLt4iPtLgz4S9aTr4cSl506bB3aXRbWpAl+KzoTtZ9RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763744762; c=relaxed/simple;
	bh=g0mfsY0BmjhW4/dF/KhvEKYszrj7C7YT3gH+KjbQ+8M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dJWX4ghT0WA27Rtkip6L5/pkppEyGyiH0OLAhSmzXVUmTTs1Sf/kZaR3M9GBBWL2J9ZgYdGRSE7szt45lOBgb3+2pqT4hhR/scZNdU7H26Nais4EJxpeTvAjEqGpTPTotY6SHHWAzs8tvE3dQl5qrai717sj0XJDjZe65obW198=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=XM2q+UUA; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="XM2q+UUA"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8823e39c581so32515606d6.3
        for <patches@lists.linux.dev>; Fri, 21 Nov 2025 09:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1763744746; x=1764349546; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wij9Xntwahn42XWWuPVoXt9ccQi9c/pGIOq4xQ7R7ns=;
        b=XM2q+UUA38CZ6Q3Y0J6tgWnFGuGN3Qr5UwevVqxdBDP5CZcp4dWpcZaLN2P34kybRK
         /9L0zw6Zc+xT5JLrKIZLcuSaQBIW+2NBDIx/1ytWnNmZLpDh5nfqm7wKe+zcjhtdkvZj
         OViHaBp6rg+WXGbKq0trLQ0LynInB1WX0KE7OLnq76/+G+K5fG9Do0LPj9V0HaYaNKdv
         grj+uTWti9Bri0UpnbDZPO2dm7yAZ2Wz2/HUd8ADbeA3L+pIOgVTNF4P4O6wTmlbrYOv
         4/x6qVT3CyIYFrRKDNVQ93LrimFsEya3ruktqyju6Uuq3KSDsQfI1P5f1tmhYPtNHWUP
         cu8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763744746; x=1764349546;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wij9Xntwahn42XWWuPVoXt9ccQi9c/pGIOq4xQ7R7ns=;
        b=gBqFB72hX5ajyfD4W/lGl4ByqJ9ESG1YfHUKJ9FiIRS1q4I+GQzLgCLHhgkHcTZ8EQ
         ACgzPBA3LMKT6rWTejh2XdIuoFAsT40XEu2L6as+OsGABBTfSaMoiNdcTbg88PuurmWj
         ut0aRtY+UJ6q22kj1ca8HouD4JyOBQG0yxgu7e3p8t2HZNJFqfsnPKmCDGDzOIzHqAs+
         slkEM53jWLDUZ7FKlGJ7qieGGdFcvwm7RxfCAcKeB62vxl6we0ET3vtodoVXOgSgI99g
         FKegkKVa54Us5XFmysMvgfPGZLtq2p/2b0JbI/1IN6T6NOnL77xeZKgt/rOHG65Qnqn6
         X9yQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRWzs47aAcdSuEJECeibhx0k/p4201XpoxN95/CdLBGXDY8kPAN9cyxAgTaQGvf0Ns+Xd7Mye7@lists.linux.dev
X-Gm-Message-State: AOJu0YwVAxWKMkGup/WC4IzWbcgtHPcTF+M1OhemFNDXyCKgefIMdF22
	A183QCmSGogO9VtSG6g12gyQTP4rDjU+88whjAhPdfuV/sY4HLLc3W3YMUCWOD/x8k6Bn/jJvKY
	bBQ0h7asZZBN3Aks63kVA8eAPIcDbFGXqoJDR9w0fqg==
X-Gm-Gg: ASbGncvCcM8Lxnu9g6dEH10BDqdinsDBfvxN7rmhsFO+T3V5hdv6hegy1vyl9W0OE9l
	WDbL09juxliiSr8XaxbRHEwYKCiizWEmmwcvG3Cl8stm8ohvDIpPhVQ3sfwCb7mi6/LwRqfNOv1
	WZJ32pNNFoCoYlXO/neMnHswAmjQ0o1ehxfkqy7aKMxmAZW2n6yGfo2ocopO7qA2iKX4JyVswSA
	L0UrEbHJzDGGvkUcHSmglH+aj6KVqCgrHv55s3YEzihaOeu/TMVYgH9zFVWvoTxrrHU4jtYJ9iy
	WYxx72OVnXAXfkLtmy5Ki24GEEunFg==
X-Google-Smtp-Source: AGHT+IFyBPJMF8miaqm3J9SeysyAeoBZfngbCeF1gqSOLxlti0idn6DI6f+6z9hfXCs7YYDitoNDIPf15wDpSdSL1ow=
X-Received: by 2002:a05:620a:45a7:b0:89f:8bb8:c103 with SMTP id
 af79cd13be357-8b33d478a7amr355225385a.49.1763744745585; Fri, 21 Nov 2025
 09:05:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121130143.857798067@linuxfoundation.org>
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Fri, 21 Nov 2025 12:05:34 -0500
X-Gm-Features: AWmQ_bn3hUma6F2fPIPPqFRfcMUsz1CIgpb4y0PU7vh2cBVNCFWZg4gJ3dFTi64
Message-ID: <CAOBMUvj7h2K5n44e=pRZraE5gSw=Ndej4nCf5sPONqnaFStB6g@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/185] 6.12.59-rc1 review
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

On Fri, Nov 21, 2025 at 8:32=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.59 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 23 Nov 2025 13:01:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.59-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
