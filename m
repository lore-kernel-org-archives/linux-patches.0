Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB03D2D238E
	for <patches@lists.linux.dev>; Thu, 31 Jul 2025 14:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753971170; cv=none; b=q/E4BchX/lXnuS9+zIE+O+MdjxDGFqaNjZpdP5pG3nWjw100IEmSpIVByJQUmV46BhvO6XiAeY0GDEQEQiL1OriU+FLSGAplwt1TsRUceXaFPieRqJErjp/2f5y8x4Frch6oFn3hy57dGxGC3VGIVcxKtRIZmwXCpx+8iJnmOHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753971170; c=relaxed/simple;
	bh=Idh9foYlobnkqdDD9TDu5/SpFZZrciK/ewtMb2geQbE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h5XAGTAJ57KIlxxZ2cuEMR5XfwUxKlT3PyrJ6pehEI5Z4jYvb87Qu2JJ3BVp4HQtIxMnxKel0T+l8MdxSsuLq0hjCqcXTp1/8EkJ7IR90ujaK5noMBqiTIQLLIXUWX6HhEcEuRdJqdJTIrXyILZDcs3v4wxOQfbym+4UUN9vjGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=temperror (0-bit key) header.d=ciq.com header.i=@ciq.com header.b=XsI4dDis; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=ciq.com header.i=@ciq.com header.b="XsI4dDis"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7e33d36491dso40380985a.3
        for <patches@lists.linux.dev>; Thu, 31 Jul 2025 07:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1753971167; x=1754575967; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ilfwqsoaQ9met52S7qm5b2+HGaecgZb3Z6l9hEzitcs=;
        b=XsI4dDisKcn+RGW58g3KtRf3S8epeVwfSIWpEF9vb2Vt1vt3neDON63gPAmooBr17p
         pKfExLA8Mcu8q0ybqhFG/3Y22/2H4S7OTntR9eN54eZWewRQB/DHBENJLNUashbGkDh6
         nLeySkiGfov81V2HvQmVdsBuY0GcMP7PMrtC7rZoglior3ZlXM25JnDqmj78E+Lvx1vC
         23D73/HN5nO4p8EAlsPq/VCghQq2YLOB3lGQpccQ8hR8B0SrPB9v6bUpQaoe58znzygI
         CX6DaxwJpxd8tmHgy03bTvyvIA+p7PcZG4tR6AkFfdDwpVRAL3MkOwYrKtzcjZQJRpZH
         8t4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753971167; x=1754575967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ilfwqsoaQ9met52S7qm5b2+HGaecgZb3Z6l9hEzitcs=;
        b=jMl6Ard8ecSlhVP3R7PcI2cZiDmPtQANTebS5hMo9qe/7OhsMWH8uNBf1QVHaftgjB
         UcXIi/OYrUqY2ibYt1AnNmTcrbY+sPzlAPi7AOAV9Oohw1zfsMNGFUE+CNy/TmuiNw8E
         MNcpHw1HBe7veROvjGPMtpQJW8ZY2yO8L9Y3hMHKaZy1NqbzsYTXpcUUjiNZM0XeSDgU
         NJwXJCX+BHSTp7ERncsHy63uJf0Nsuufp3HfCLHPtWG4vsfW4Xaed+4F/aH3ec0BCq8n
         +vrT+7+H1+OmQnqQAGBdXAdomy8LxH6j0y5qQHd2Rpb3/S5TZ4ynb3Rq24BjWbdeqcSv
         o40Q==
X-Forwarded-Encrypted: i=1; AJvYcCW6S3DMCYSODQpjHN0QXzFwnAcnZSZrLVLJ9RJING+HiFQRYLKCa4iAcKCNzEzp7vL/8K6fuoPf@lists.linux.dev
X-Gm-Message-State: AOJu0YzdkJYsX0qXXh1tzpol1hwnU5iH9X3RvFkA1bxddM0c1RK/xB7x
	alVsPBT+84+LSmLg8WcbCAAL6fFVKSgwUABMUY+X7gpAAfsabeqwqxcxLtcXTI7zd7Yc2+QyKbb
	pb9iWRdfNQQnCd+b+5i/c8RyFpPcFylfqufWkl5DxDA==
X-Gm-Gg: ASbGncsKydNmdEcfMaQcCEBp+fB+dQ/w2K7vbmFibJ0opXMfQ0PDTNSY8nnwm8saQox
	LHPi2QzwBUQHbC9JteOwDEpbQMeLpHUZXHRGfK89M6nKX2QWAB4CxE6Z/YIL2xh6sjRpGdfe9mW
	+qUKYCffwtymmJnS7ldzMHRZPVaKQgG5Yu2lqvWAPzKrKeE8+f1Bn28WsgW+12iJLY+zIXnYKmZ
	+hgpTws
X-Google-Smtp-Source: AGHT+IEZGZAjJ6oTT/y0eC5XEJAwdjFNArop3uSkBDdCtmPqSMYvdMHeSgLNTUW+1pljPGLH32dL1zf5CykkNJQ/IMQ=
X-Received: by 2002:a05:620a:1997:b0:7e1:31ca:954d with SMTP id
 af79cd13be357-7e66ef7923emr1043723185a.13.1753971167480; Thu, 31 Jul 2025
 07:12:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250730093233.592541778@linuxfoundation.org>
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Thu, 31 Jul 2025 10:12:36 -0400
X-Gm-Features: Ac12FXyV2Urw95nrCpp0mmTC6H-HCM7BEoKwi79mPFC-PVRxatkeHBA1vjTgd5s
Message-ID: <CAOBMUvh13vSvX4m7x=AvW1zrXTYfyF9J0JMsAwECY9gku1+=RQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/117] 6.12.41-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2025 at 5:45=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.41 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.41-rc1.gz
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
