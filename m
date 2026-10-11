Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7A244781B
	for <patches@lists.linux.dev>; Sun, 11 Oct 2026 14:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791727923; cv=pass; b=kzzelz2TWARZJmyN3Lpt81qM+KSESmcjVH7GqXhbqbg7KmgveySCawfREiIXvlfzjzrMBeg/MhhVhvHmNLGtNFT3d+mPVIQf2Bo04xbVH6tSgweDews5+FoSEJcqxX7TlToAIHsmokps8j00LfP8/JlOzbfdhplipMYdxobzMIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791727923; c=relaxed/simple;
	bh=wdRnVqUf1ZGud0eChWIXjEZO/K7UTTIev25EskoBKgw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SklOun0BPnN3a8p7Pt28Dc2RSDQCseQf8blCLYyKGLPHO8m9KljjSNrdPPqdfX5bJnEBm8XsSvt680u7FDzf1vBJZCDsvMMz6RQT7OWldHxRd62bk5azmzPU43jY+T6XWn9+g3sBpTz244yXkhIQlsS0MJGxhSr1cEYZfpE9yZk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rxp68SFJ; arc=pass smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rxp68SFJ"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-3584f70a5aaso114306eec.1
        for <patches@lists.linux.dev>; Sun, 11 Oct 2026 07:12:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791727921; cv=none;
        d=google.com; s=arc-20260327;
        b=IetPnwH34vEFKhpd51bXF2C+N3w8qBBtjwdbnlFy0tmrA6NbE9y8bNxjn+8S/YpmWs
         DKl3lDecQx50T0XZ2i9q92RXMCx0AQlVaLDZM7zuIwoVOGVHy75naOcn5XsKCTjwHl8s
         56PWhfpcmlaKV60nr6rp7ybvgvAv4z7ITZEnMEsDasia90RaJWJnaZIgibg/H1zP/iyt
         HLZzZNEjYBG+eey6IhSGbXrcAE6sjxuyCHSN3JICBDIR5pIMT3/C2o3EE7wMD0e2ttbf
         HU49JriCxkmEj3TOnA/qNOlZVx7vMfY/+SfUF3HK4XnETxc9FlcfUw3YdX1wHgJoEsBs
         8f4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L2A8o9vYIEEGemnCCmWv7AJBvyLztV29qJFJ0TTixwU=;
        fh=ntvq0EiOJMnNGyrmMf/6uH46hRdTFzlqHT4Scemqa8U=;
        b=Lz56P5dsZ33G2S3A4AggmqIPxsCGtW6B/+CL3vAbrWJJtxmIsUOfJz4JQz8ivygttS
         fSea3he5WIHd+nzLl62n3uZa9fygbpeA1CvWBrj0gevGfPEdfMNDYYriEgIJWr/xPZuv
         pS6+4d7Hfw2Hgxk4d2h+x7FoukfEZ+AKmOTsZ20vTyvMAGPQ2IgauT0/+kanKsGWUuVq
         As+tylQ4va3JusSjFAHOJpuTPLoT71Mz63OX35kPTx+oNdfcVsaqnXW4FjYtyqxYLjCs
         in+V5QkxletgnDBeUNQXc7h2Dfc1HYqxt0zJLjtseHs883U3XMmtETGeATKvzMD6OGj9
         hdCw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791727921; x=1792332721; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L2A8o9vYIEEGemnCCmWv7AJBvyLztV29qJFJ0TTixwU=;
        b=rxp68SFJVetvEUc6gOz0RlwjK14d8jiHzuegyQRPFTadXm/RybOQZcxGkAJtP32946
         92a369XcESDlbrm3GVO75W3123cnIyhZuQdSFTO7s56Ib20RakHJBoVcogj8eHEnyEcQ
         0mOblcGiBfH1iMctqRKoUA0LHzJh5z5HuJR9K9ai9wja7Z7swzPEV3DmZ7TaF4zEe9wu
         Gv/G4ntN482p1EleopOhKFoYHE0sKoLnKKVetVXcWc5cHHOy5OSGwuC64BGMGC7cpVMf
         QNjzBcYFI4inzvRbAQdWj7u6E+m7SgybDp161lpMnTCBeDpHJKCksA/gv31ZX9cJ5t1B
         ouSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791727921; x=1792332721;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L2A8o9vYIEEGemnCCmWv7AJBvyLztV29qJFJ0TTixwU=;
        b=gHVwcRSB0IgcFEXK5FjKy3hyc4hcIElc9I/vJ3n4sB9neYExEuSXk/+aVCQkMj9F94
         RV7XWdHYttX+JWETuu6+5SoAIkqE5AZKKxkWFEHx/d832lX2J4+qgOTHYKXDx6z6yWxk
         S6t5JJhG7v1Ghy0w7Rz5ww4OZyjrxx4H3xw6OtVcxhlSpjWBs1XAhjo0yARdrlScYk4M
         A+rY2vs4o7MM4VILccphjN1ARMacpeuWOylUtHP1c4vAtNi4CaLebfqBy+8h04RdA2LI
         3jbpNuOSIw0FNg7GH1mSXzlsWS9Dgf8WaUReHsuZibPt01Z4mmbYspJE0IKQDZnClGiO
         uQGg==
X-Forwarded-Encrypted: i=1; AKwUvBwUwYt4z7yJ+lzzXzn0aQ5z+nTOoTz4wC4rSfGyT3vGpcteOYHntnHrbgEdX6n68W9vXm6RfR2j@lists.linux.dev
X-Gm-Message-State: AFq9FYKys0Ts3ZUcO4PeK6xyKW7o7UGu7sVhkDRzyjy9amJobfLQYj79
	dupwMmZxPMb/uxza4dPI1Ks6pRyKLARalyjfkdqc3zC/FaXxlcI7LSejgBr092SXf5ol4xdivO0
	e7ZXSRM9vG4DoXuK7ykTyNGsCubYx2H8=
X-Gm-Gg: AYBFou3WTStg2FNix+I28JEuPStcYyGJVlwWBrx+ERt7zOC5GK619kqA8OIkZI/qW2C
	kSTEnUWsQ43Hp/+WV9rDCmTlPtHjyJbMAoTNoOBq7/Yec0+yA3VUEl6WdtZ8M3ds7H6ZeJazXhb
	vYP1LYT737UrYNvqkDVNrLapAnKSArnrc3JEorcmaLdl+DSBR/vqYv7iWnWjVOqyxTt+Bkf5i13
	ELvqypPG+5B+CtCWssxxlDb/7hjV9pSSYPIWX31TFkrA1dZDO9XltIbAVsV2ifAUHTPGrbuRhDk
	BqS9F7YtuarC36JSuv6TX+HJEOX7BpP6vizib4K3WKo8GAT3iMoTh+0WCakXhFp5HqQjlTHzUxD
	0sE81CyIaA1aCQk4UYGr7rI9mkQa4IBI9SW7Z1CEyWgj8zbtOXpacbgHwoE6A5nyiRYfQVqU1zt
	cQ6Npop7LJY5OjJcYwJ2ED0OXtpEio+3PhPx+cvY1JqCGX6R+haFk=
X-Received: by 2002:a05:7301:4d0b:b0:33e:6714:3945 with SMTP id
 5a478bee46e88-3537e0129e3mr15526523eec.2.1791727921035; Sun, 11 Oct 2026
 07:12:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261009140946.008206689@linuxfoundation.org> <20261011111313.27648-1-ojeda@kernel.org>
 <2026101124-rethink-craftily-cb25@gregkh>
In-Reply-To: <2026101124-rethink-craftily-cb25@gregkh>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 11 Oct 2026 16:11:48 +0200
X-Gm-Features: AclHuK9vMOPoMYcJzpYtaZWxlpIrwxbTqInUNqo073P_f5dJet-f3k_x1nsh7uA
Message-ID: <CANiq72ndhLush3bugar1YGPnsein8min1k3_NucBxzFwCWe9Ug@mail.gmail.com>
Subject: Re: [PATCH 7.2 000/428] 7.2.10-rc1 review
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, achill@achill.org, akpm@linux-foundation.org, 
	broonie@kernel.org, conor@kernel.org, f.fainelli@gmail.com, 
	hargar@microsoft.com, jonathanh@nvidia.com, linux-kernel@vger.kernel.org, 
	linux@roeck-us.net, lkft-triage@lists.linaro.org, patches@kernelci.org, 
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, 
	sr@sladewatkins.com, stable@vger.kernel.org, sudipm.mukherjee@gmail.com, 
	torvalds@linux-foundation.org, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <christian@brauner.io>, 
	Carlos Llamas <cmllamas@google.com>, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 11, 2026 at 3:10=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> Seems to be broken by "rust_binder: reschedule node refcount update on
> thread exit" as removing that fixes the builds which I did.  Any
> objection to that?

Yeah, it is that one.

In case it helps, I am re-running my CI with the extra parameter
manually removed in those two calls (instead of dropping that commit),
to see if the rest builds and runs fine after that issue, and it looks
OK in all the builds that completed so far.

Cheers,
Miguel
