Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8058D13AC2
	for <patches@lists.linux.dev>; Sat,  3 Feb 2024 23:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707001683; cv=none; b=MBVDMTTzYLMQISrTur9CVGkuC/1L3nWlHoud+LcsV4JpLsAh/jZ6rwQ0BeqcePEF1iy4XfnWc4BgVno1CTx39n5gdNujj+YRnLHJbdKgy8uiiFVVEa9ZA94HbO5wWaQE0FW3xmEmL6k80AvhMFLNElWLDqckS4ybX6uTd0U7Cyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707001683; c=relaxed/simple;
	bh=7p0zw0Zru3MsWw07ScgwZWkx1CMQuefGCDRebXcKKrU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NVeWp3pqSfscOjtaDkuCX5gE27os5YuqMh4DRS7l6MHP3jLfAAyRKOBfoo24P3gLeUUXVo1kuycG4YzRC2LKlh04MxEk9c7nh6Yk5xNm0xMSnKuc7LcFVgJz85Ka0NKIIvU5KsattZY9l3EZZQdWbjZtq5sGLd3TxRX9FvNIqJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=GwVHrnE9; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="GwVHrnE9"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5cddc5455aeso2857322a12.1
        for <patches@lists.linux.dev>; Sat, 03 Feb 2024 15:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1707001681; x=1707606481; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+bcyaVUeNaxyEoXSbmvlmjxUQdhkegwt1YEX58Lwf4=;
        b=GwVHrnE9Z6kpUEgLQbhdP9sWvEz4jBd9xapl+URrkUPweynkPQqSBNXNsYo9kwjxOh
         M55OPOMr1H2fF4NUq9UE0mMiX86+jVQg7LKSgIbK5KgehuLE9Ty9zb12kgLEIHkIdbU1
         Pmn82C7h1kupBF9s5SIJHm4Rh7cRRYbdWOSKqwsOXcS+YLIh6AtAVzS6rCWJeFFnYMrf
         gQtLoFKvDQdNVXqiBzZiKjh9KDGRdNETmlUfe8izCm0xslecvRsYwfpgNSwv0JIjkcI0
         Lm/rMYmTto5V4GP8ekPGjVIyl5AXcitPjK3qsB/NImiiXD2S2yqalYLDA94GjYFRSwDa
         YXNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707001681; x=1707606481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z+bcyaVUeNaxyEoXSbmvlmjxUQdhkegwt1YEX58Lwf4=;
        b=RO7fmVc9awPK9eNbkCX2CVk4qAszis6DtLndmlaxax3C0/jOHBMzvoX8sI5Mf7/hwM
         XIDk6eIMRP535JesVNQnxOASmfAlVXSSQx8s8o2NyjhYRqbxeP0Wn5zbEeETNsdvs3wW
         geVl7pg6Jf6wHg4OFbDRyAoGDDh/8IdJCCwXq4OzxckXQe6xVvlnpTVME14hH/3bvxaC
         skmnZH/yR63oHpjbiThhvfFTC6+x5Ye04lq3QWeye4VHujILtGrOZkmjEgsQWmN7A72j
         DjTw9mUYWkAYGACPYgesoIDZnfmDE1gxvSKd0jlyy6nh2ENt+M0Ys9wIWWqCNFsvMepr
         aqMw==
X-Gm-Message-State: AOJu0YzRArdFmM498nBel3STWSz+9v3Lzc02e9dHnefKUSfQkaIwQQuq
	vkhAzavF8QVkOk7IJaVI94wselkspmEffVg1DhhGasvJBeyLG49AsnyLnYgQbeELDdBYgUhNoNy
	Uf46qvcyZknQ46Cz1SsdJ9NnRtyk0lzUvTf0CQg==
X-Google-Smtp-Source: AGHT+IFhdozQG1G0hMbTqVxDG5libdTTSaFkdNxFFWC7hBg7ttK+Qdlvater9xOWBPPUyrohBpk/ISI7HXXI3zOZug4=
X-Received: by 2002:a17:90a:b113:b0:296:1da3:c9e5 with SMTP id
 z19-20020a17090ab11300b002961da3c9e5mr5159730pjq.4.1707001680720; Sat, 03 Feb
 2024 15:08:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240203035359.041730947@linuxfoundation.org> <CAKL4bV59sRxqmyn33Xyh9uU8EMxytfqqNFAKxAdFALdWXzr-pQ@mail.gmail.com>
 <2024020321-predict-twister-356f@gregkh>
In-Reply-To: <2024020321-predict-twister-356f@gregkh>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sun, 4 Feb 2024 08:07:49 +0900
Message-ID: <CAKL4bV5OV8JBr0LFAmXyaqb6N3ir-Jsaiqtfc7FDx4dduFq7Hw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/322] 6.6.16-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 4, 2024 at 12:57=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sat, Feb 03, 2024 at 10:48:48PM +0900, Takeshi Ogasawara wrote:
> > Hi Greg
> >
> > On Sat, Feb 3, 2024 at 1:16=E2=80=AFPM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.6.16 release.
> > > There are 322 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Mon, 05 Feb 2024 03:51:47 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/pa=
tch-6.6.16-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-6.6.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> >
> > 6.6.16-rc1 tested.
> >
> > Build successfully completed.
> > Boot error.
> >
> > After selecting the rc kernel in grub I can't proceed further
> >
> > Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)
> >
> > Thanks
> >
> > Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
>
> Any traceback report from the boot error?

I checked the log when the rc1 kernel started from the kernel that
started normally, but there was no log of the boot of the rc1 kernel.

Symptoms include grub starting, the screen blacking out, and returning
to the grub screen, but no keyboard input was accepted.

The problem was resolved with 6.6.16-rc2 and it worked normally.

Thanks
