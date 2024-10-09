Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E258A18E343
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 11:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728473751; cv=none; b=PMOAXiMd0bac+QPTk2JwJOtjGzuX9BggMtm9MqLZMMoPm2qd6+M4/A3F6Hb/0vhbBH6SAxeGTUkTPKlrcyMd1IDOkm8OTSOZA1SpvTN3OxAuixLR61oKXMnwJLUAdJtk6oRZX0JWxsC9ZWG4ldBmEm574hgmZFDJxaT11Ep1gHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728473751; c=relaxed/simple;
	bh=iYh8icxS+03RcbNsz4+AeuY5qGQrXSCvfXvPNeyDKC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AU8OVuYf+tZNj4f/bbueoBGrHlFcoB9AQGhwv7EG+S2l6B+T+CXdPxXZ7PtoV7VaPhGA0lJ0DOJDej1bkbmjitnmvgF6hBmXBRigXdTPtbLLx/owHt34t2tB8AQArCqprEFhlUWVyAWjxjd7MxI2jz+mUZG9CZB4bCh5YQjnqfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LJPW/RDm; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LJPW/RDm"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6cbc9e988eeso418956d6.3
        for <patches@lists.linux.dev>; Wed, 09 Oct 2024 04:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728473748; x=1729078548; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FurzM10u95VKmaZwS7ymh0VKZoWWm9NbSC/cRDUlyeU=;
        b=LJPW/RDmDAoWjjFGpnWkkJRpgk4vK/1UaOq59vYKqPqASWYMJzB+OsDmWNd19V3Znf
         roHBtwgQ2KEBRZFyk2hTbGrQYJfTanjzLS8vuuIl2rfXKMHqtW8Rk6wL/blV87tMIi6F
         /LKVTael7KJaAZsFuumziwjUP+Z1E3LaczScfXUqSQg4yTmQhM3gtED33W8lrT4KvZM/
         V9r/Pnhlfwa+tt8DnXFgqHkkPzyL+dP5s8HBe3SUTLljw1oEkQ3ztPT3tVhHfDJX1o4E
         I+2w4KWg5o83NWwCAPqgAqBS13OUospqSknjjwOmpmMgfh4JsYaM8k8VtB0ilVvBYwNO
         ZJMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728473748; x=1729078548;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FurzM10u95VKmaZwS7ymh0VKZoWWm9NbSC/cRDUlyeU=;
        b=I/IAYE1X0odHsl5+Admz5ydmIGTy8EfUowiykR4BHDDHwp1tv/rw8n5IUbB/JlSjhU
         cHHCAQ4TpFRLlk89iFWM9/ak/xlPQ526GyVagZl9b+eE34GoZMEFzgJLxWVPdGARBJUQ
         dxw1LVUdLRxjoPFzV3PWMSfuLEPxuNLFiF/3V2PrJc78lUAOcM3wfkHNJda9xIBG3PRe
         aPmNbmczfeR6QP41iDn49g/dgOrqvEwhc446Z1TbEHVjcnBML6VIykTLK0B/73y3Tg91
         sYdICTgkkjymJE+ZRqv8oKrh77+aPCVrTuLaWEVwUSiaL1UDgHlg1EMejbqBNDFZEEIR
         shMg==
X-Forwarded-Encrypted: i=1; AJvYcCUPYF2QjFmPQ3TEZB7eLtuvP9SyhEMOs88iP2WisEbMYp3Tw/dfrb26nGGF+Gap1VvGfTbRv/P4@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1UkSecnv9ZgODQNiL5DZIUo+yyzVCRo1ks+PLIvkemxnfo10o
	EOpfYfWkai5KJdTRzZdneMpDm++PGQP7zE07M5x9opKHizNW19SwjLi/Nb0snKHzuXb2lWF9Hge
	R0IusI0wiNHUUP9Q6kJ24vQq4elRDFRNADTH86g==
X-Google-Smtp-Source: AGHT+IGxVD61+vnO6Sd1PNMSaYrQo9NkwfAClZ0FVDtlnROBKd2JA5fPqspTbiQbddkGddY+tZ38AMM6AmjuFdGb7sY=
X-Received: by 2002:a05:6214:5014:b0:6cb:6006:c98b with SMTP id
 6a1803df08f44-6cbc932a05amr17137026d6.5.1728473747881; Wed, 09 Oct 2024
 04:35:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241008115648.280954295@linuxfoundation.org> <CA+G9fYv=Ld-YCpWaV2X=ErcyfEQC8DA1jy+cOhmviEHGS9mh-w@mail.gmail.com>
In-Reply-To: <CA+G9fYv=Ld-YCpWaV2X=ErcyfEQC8DA1jy+cOhmviEHGS9mh-w@mail.gmail.com>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Wed, 9 Oct 2024 13:35:36 +0200
Message-ID: <CADYN=9KBXFJA1oU6KVJU66vcEej5p+6NcVYO0=SUrWW1nqJ8jQ@mail.gmail.com>
Subject: Re: [PATCH 6.10 000/482] 6.10.14-rc1 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jan Kara <jack@suse.cz>, 
	Christian Brauner <brauner@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, LTP List <ltp@lists.linux.it>
Content-Type: text/plain; charset="UTF-8"

On Wed, 9 Oct 2024 at 08:22, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Tue, 8 Oct 2024 at 17:42, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.10.14 release.
> > There are 482 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.14-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
>
> The LTP syscalls fanotify22 test failed  (broken).
> This regression is noticed on linux.6.10.y, linux.6.11.y and linux.6.6.y.
>
> We are bisecting this issue.

The bisection pointed to patch b1a855f8a4fd ("ext4: don't set
SB_RDONLY after filesystem errors")
[ Upstream commit d3476f3dad4ad68ae5f6b008ea6591d1520da5d8 ]

Reverting patch b1a855f8a4fd ("ext4: don't set SB_RDONLY after
filesystem errors") makes
ltp-syscalls/fanotify22 pass.

That said, I also checked Linus tree and fanotify22 fails there too.
Reverting the upstream
patch d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem
errors") from Linux tree
v6.12-rc2-58-g75b607fab38d and run syscalls/fanotify22 it pass.

Any ideas whats wrong here?

Cheers,
Anders
