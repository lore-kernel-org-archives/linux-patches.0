Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3ECE2749D6
	for <patches@lists.linux.dev>; Fri,  5 Dec 2025 11:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764935545; cv=none; b=kb0epax41J2ny2Ned2EIak6UlYdiHkxSlpQIDgzDfOPkTkO+vu5QefnksNL0VnmV3Z6PCbjRYifpRGm6Pj1uZY6qyfHeadYv0o1yFJku4T4+PmIn2VfUkCz2DyWLUiRMCBNSEmaoL8yzpgxr4i4zrmMk2QoxLcEb/hgXRF35wSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764935545; c=relaxed/simple;
	bh=AMyHnTnXyIiCuxrw44BiBoykn2XzflaqAFpUREjKdbI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XYlMxQLL5bJTjz6MWzjYY3HxYcaPWRksOHWbwWUedrmdrVkJ/zjaqSRO0fbf16qJNurIsvZCFFoBajMIs4UtDIn8zvce2wAFQJdYjC9HyohlCTjo/Q35KtRDdj+xNsYWP1VmiunbSo71bAEScmnqyPfdEundb5wdhT77NcHsCqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=Xo74KMHd; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="Xo74KMHd"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b734fcbf1e3so443841166b.3
        for <patches@lists.linux.dev>; Fri, 05 Dec 2025 03:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1764935535; x=1765540335; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NqSIEKbo/CixPo289Ao3k/usAnKyS/YtdMQMTBUZnho=;
        b=Xo74KMHdEAQ9LJxj2sHALLqwtQbofoNFsv9zifscX69O/bZbzXOlXyECqrLTVwo17j
         IPsCpunYifcJt47bQinhvB8V9KVyI1RP3n61a12wIPLlvy8RZ8Notw5+ZEPQqa3eXrJJ
         nIRNxtd8wXuqYAfnLprhKB4DtLC/TQk1IyPFDLyt/gHU18Z9ZaevKYtRuShPVjBBK5Nj
         29rnZXyAh16rD4xSkwhSG+pIgDgs6HwOWF19t9IgTpoB/ZPLjVrQr/0JgdcuiJV4RBH6
         HdRou7Uqd7A3B7DQkMl+zFYwH2Aiht6UEkQtipnmWSJ2UrA2d78xjVjfkEur+9ECqGeV
         c4xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764935535; x=1765540335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NqSIEKbo/CixPo289Ao3k/usAnKyS/YtdMQMTBUZnho=;
        b=hzaWOlmNBB4jxgnUujrxqfmIciRlGJXviIreU3C+uL7flv53sWKdzLtm3o4gHAHvry
         VMDlhJ4ZjDCaBmXh6lCgZKgzYof2ytVMVBTwyD5OqUAp8VdoCta97nArLfLVPDHlqMUN
         CL8EWxRHxZ4mRetTizMCKPujxPAkh9bs+2bQE0s3FM9j2nYCRHJ2Mn1eAu/4RR2LrWea
         WvknY6LV0I4ekx+bb5gJpaCjGCIEwX3uHxrNIZwAXslREC58S1nT5khS6fAXOH1LUUO6
         /QDXJPVMOJyKDLvGVsG/g5Z3UpUP1yQlGLwzYqGoh3lX7BMSejpj398AxmzgdEAexhJ+
         XeVA==
X-Forwarded-Encrypted: i=1; AJvYcCWIwJDRfB6GE/Pzo7h4ZBauAC4I3Zof08vHKaWcjw8EhluxwDsgyyKjB4Y61LTXtkgPun8ix5XE@lists.linux.dev
X-Gm-Message-State: AOJu0YycvA0mW114xIJ1HDSk87MiilrmoAzaLoE3K7SxLL4Y3uc/hM28
	7pRFCJv3VMkIL5jlRRSbZ/aEAJpMLSukkXD9EC8zq4Ub1NlJoM0xoyc3LqY/mFA47tLwus+qXjB
	mHYHnh16U3aWekz1XwPyTehdaQFLqPu//QlfWFT+4FQ==
X-Gm-Gg: ASbGncu29ow4olD+O7yY9rfJduh+5BhOixQQ6Tx57th7dgTJsyMS71P9DB2gjed5ZM2
	ZUwxmaLbdqSWYa9R9XtggqgMlB80rkxvs2nmwIwzG0mGWzEAWLKOUD3LhpiF1KjpXOYhKno71eG
	mTQtU7v+aK4yobHA5c6APhMaGwS1gyoUSTiPI2gdM7tUZmiO+Eqs0QuGSNjCmyTDCtJnbuDgvu9
	NUC3Mgm8eokYj5Czo1YRrOdpGarFrO/1DfFX9PGdacIGQ//JIMFll3ZHB7MaLnZspgdvx8=
X-Google-Smtp-Source: AGHT+IGTiLj/ITAy1xlqaCMY3nft1UZ09b9A4g7axG+Y9Ggs8A1/6Tc74DDdxYafG6Fbxu5JDhye1GJl1WkmzzZEgjI=
X-Received: by 2002:a17:907:6d09:b0:b72:5983:db07 with SMTP id
 a640c23a62f3a-b79dbe4967amr1068299066b.7.1764935534874; Fri, 05 Dec 2025
 03:52:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251203152346.456176474@linuxfoundation.org> <CAG=yYw=7i7O7nLLDQ5hdP03wHFSQ04QEXtP8dX-2ytBmiJWsaw@mail.gmail.com>
 <2025120413-impotence-cornfield-16aa@gregkh>
In-Reply-To: <2025120413-impotence-cornfield-16aa@gregkh>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Fri, 5 Dec 2025 17:21:36 +0530
X-Gm-Features: AWmQ_bmcQaXxzg-mejUZu_ahVJ8U_GoVzPlxQ29FRCaXN9PRLpqCK4-8yMohzTc
Message-ID: <CAG=yYwkbpW8KG8ks9QGfOroV44sishtjFwvhnxBpD9O2en+7Ng@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/146] 6.17.11-rc1 review
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

On Thu, Dec 4, 2025 at 9:46=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Dec 04, 2025 at 02:38:10PM +0530, Jeffrin Thalakkottoor wrote:
> >  hello
> >
> > Compiled and booted  6.17.11-rc1+
> >
> > dmesg shows err and warn
>
> Are these new from 6.17.10?  if so, can you bisect to find the offending
> commit?
>
> thanks,
>
> greg k-h

hello

6.17.10 has the same dmesg err  and  warn .

--=20
software engineer
rajagiri school of engineering and technology
