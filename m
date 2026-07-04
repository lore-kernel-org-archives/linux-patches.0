Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC98E39BFFA
	for <patches@lists.linux.dev>; Sat,  4 Jul 2026 12:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783167909; cv=pass; b=pwmRloK7aUyG0DubaTJYXFKPwrh44HwvzBxPQs/hBgZJfelGeT9KTTUV1J9VBmO9Ve0uXrLvyAa1yMSGR9noL8jr7rscUOIn0h4tSzp9XSyWMh8brQ5rdXruagN9mM+0NUY935w3RCSeNk64lJrSSqEljBD0Y8EF1kWSzmQHB50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783167909; c=relaxed/simple;
	bh=IW0LdZboWFvM51IoGirgs2r0L0XfBs0zXkDLmAa1uVs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o4XTex99rFlxUXQuu8K7bYwyguNctcxBL/upNMLo/AoZUZer8/6S+O3dE/mjLKcHj/XpVMWG5OkTt3T2PSJBLxwjKbwK8ggnV8BemcxZdEVMjXX8HedRIEGqdfn7ppu/aHpE727QRlP6WK0btySulCGtgc9j6no1BRdU4cFcDUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U/7rozRS; arc=pass smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U/7rozRS"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cad68425a7so1662555ad.1
        for <patches@lists.linux.dev>; Sat, 04 Jul 2026 05:25:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783167907; cv=none;
        d=google.com; s=arc-20260327;
        b=a5ctef9S4kb/2a5fabUQ6JyMqe1a4atQRq5OP40x1av/wtyS7uEJFqus25puxoniSl
         v3U1YT6MWG2xc+ezdve1Zifj2ZHGLJc7sOtphCAz9BHiFejVi310BnTy4T5MBQWdGlJy
         NSANgv/jlaocDcZNHj4/jof5M17d1QsVFYKx1HfI4P3dgeyywWzUWdaaacQ/XO9wpA09
         LoP4GRr2EyKKHLT1NJd3bT4g/Yd/EIFdFzWBlz707iNIJ436qgEUzSI+59fqoac0ZR/U
         Uwn9tYVg8jmmdEX3PFHI4N+ULaU1AFUOhFiR/KQIji3waMdfvYdgoReBI8pT3P8KIm24
         CrjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IW0LdZboWFvM51IoGirgs2r0L0XfBs0zXkDLmAa1uVs=;
        fh=l7YUc39/1Fkxke7lpETcu0O3tzrYCy8xX/kXB9s89mo=;
        b=f0teg+f5yXv/vgniCFPg95IviyzibyE4beksZj2N044oTz5iSjkZbcLIfz4mY7d/+8
         1OSlNRlSt58yfstjFNebGO2ZmZ5qr7ZvPWNqRg6VR/TwbDVq6pSpj+Rm+cTeeASOu+HR
         ZB3S+VJbKmy1cADd3GYKAP4HhBt6C1fZKKOzkrp0zUnGXdNfIytyvWlsE7IT824Jy1Yg
         OhaQ6LK+FguaHW5vS3lB8wgzEKrjl7bLSi+0jC9eAmR+aMzfurOa+4eUR6Bv7s69tnLL
         SCASMq58lCbAxuxTKrB+fcYLenPnZvBoFy958xUohezROVe0BSsv0rDy4gWa2QpRLc3s
         LXuA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783167907; x=1783772707; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IW0LdZboWFvM51IoGirgs2r0L0XfBs0zXkDLmAa1uVs=;
        b=U/7rozRSz6B0Q1/dcKjZvJxEGpDIZ8u+V95aF6o7liDQ45GdBe/iZvf94Gy431xcPE
         bF32wwxW07nyD1Txhs9up9pTwXTuqlZ+u+XsB6zsfy/tbbN6bJHApRYOZQbmMFi9qNh7
         SbZbtVOmQ63I1wQxLjiw5qslMAvkmRFwp1sofCsDOFDiH46hoQhWDqNsRmHyzFG2Adi6
         RlIva646vQ7chD99HZs1Wg5SRmlwEArq3LY8dJJHnltdSZBcnD3jQJgpFgAvjCJuh2zI
         XityXeAPGfLo51I1ZOb/wUwMl1JGZxfuz1Brg6X6qH3qo5H6DxE9aCWLTQwuNzVE5G6t
         yJjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783167907; x=1783772707;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IW0LdZboWFvM51IoGirgs2r0L0XfBs0zXkDLmAa1uVs=;
        b=KulU+uqDWU0HKUQVEfvLI+LOfQWYEAxxRJwa/26gOHVUQb/HUGRNG6wFcYPIirYfXn
         JwhhukRNJYqE6Xu4sWakAnB0EEsUBYwPI3Y/Iktt/e9CK+HaK7j+1gVyLYQ1ybuKO7wX
         zIcBN7hWTRKh+gJY/l5AALPenVpIsyzey7BU+WrY4DCAQwH44uEOldOD8nu7hPaNHL6B
         rt57BhNvhjkAwWRqxLGY5/BoCO8QO/gNTLQ+aoizXUhkRRHGkQnfbFa1OjVe6xgxEsN2
         eZsOyCdCxdHSI1bLLHHZv/8aL0ngel4CND79kjnB5ZYz4c9vLVRJsAf4caN5WQO0XdTv
         LuQw==
X-Forwarded-Encrypted: i=1; AHgh+RpTaqiRcCJ3BAQv/MJopVWIjGMkYXiqs2A1q+7RtbHFuDJGL/Z9uUXOa2CkS5/fvmqsWyt72ivv@lists.linux.dev
X-Gm-Message-State: AOJu0YzgGbij4rVEW44fptO5HXjZzSH5ykR9q198//a4H7zX4PYVT2aJ
	yME8zgz2DU9LBuVKWoG6D3JzlpDIwv9kGzAdzo12KfGQ65+6ZvoU4bLlpymD2kimawS1/kQse1l
	v1G9EBYuIlqYbvDrSGx3E7fPOBmuHkuQ=
X-Gm-Gg: AfdE7ckBekyaEc6lQWxqTNbymXWDQz4vDVmU8Kv5HB879NF9erq2fyNcksh7Z6Vv9aJ
	A4/KDVIcavZ5dCFYigtFw+54X6soQHblGP8bue4fZnKs4uh2kHH3DyPi9tair4fS7qzKkhS2/Gx
	4RBckR4tumhP7JY47hcoS0jvEPVmqMkZZ29frfo1XEbLSJCJ0A/nUaOTNoYDTV0O4NTchxcFLkX
	mtzZH9DcfAPZdgbmBYPmqJPH2CGZIJc5TlJ7X8S86JFD9cCw8APu1AEFChBPh45SG3EOhGNXubb
	GqUA2iDavhSqmJpkNOgQJdMecdJJC0K4CNDRmkEkyur2/Zwbk5NMHpcH3V4umW3e+HHYuANiK4O
	Znf1MWKhL1Gww
X-Received: by 2002:a17:90b:4c48:b0:381:1ffc:7d35 with SMTP id
 98e67ed59e1d1-3829f2f4787mr1810011a91.6.1783167907067; Sat, 04 Jul 2026
 05:25:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260703001546.13180-1-ojeda@kernel.org> <2026070315-stable-reply-0017@kernel.org>
In-Reply-To: <2026070315-stable-reply-0017@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 4 Jul 2026 14:24:54 +0200
X-Gm-Features: AVVi8Cfjum1GJrjh8yR6GvgU-et3kTr8XXe9nhIDMrZNGVJAZ7wZTKzqAxVKLTE
Message-ID: <CANiq72=N_n2o5jSH3G5E8B4ohn4jxAQAfznpYLQqfhUQ4BXrbA@mail.gmail.com>
Subject: Re: [PATCH 7.1 000/120] 7.1.3-rc1 review
To: Sasha Levin <sashal@kernel.org>
Cc: gregkh@linuxfoundation.org, achill@achill.org, akpm@linux-foundation.org, 
	broonie@kernel.org, conor@kernel.org, f.fainelli@gmail.com, 
	hargar@microsoft.com, jonathanh@nvidia.com, linux-kernel@vger.kernel.org, 
	linux@roeck-us.net, lkft-triage@lists.linaro.org, patches@kernelci.org, 
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, 
	sr@sladewatkins.com, stable@vger.kernel.org, sudipm.mukherjee@gmail.com, 
	torvalds@linux-foundation.org, Miguel Ojeda <ojeda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 4, 2026 at 4:05=E2=80=AFAM Sasha Levin <sashal@kernel.org> wrot=
e:
>
> Queued for 7.1.y and 6.18.y (along with its imports-style prerequisite),
> thanks!

Ah, thanks for dealing with the imports bit!

Cheers,
Miguel
