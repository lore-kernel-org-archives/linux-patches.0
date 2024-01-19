Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A2D55C27
	for <patches@lists.linux.dev>; Fri, 19 Jan 2024 17:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705685727; cv=none; b=IH/rWZ+6JWp/Q7DZp49PsYTF6WjsLJo4UUgL1gLLxZIGg6kxuasqHS/osGy51AglYw08krsAEvUUYaOStQUFgx/YRrZP+aQv1qSg36KkQ3Qa9EN5LWrpkww0Q0856GlY0/OLMtBaw6UVPW6q34C3An5KON2GuaWQFzWWU1Nwmi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705685727; c=relaxed/simple;
	bh=YYJtFFrWyFN07iC2Pnj71je0b557cDdHcxt6rp4uPyg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WgEBe6VvL+PbVtw6WIMHDoikQRSKH1ZshjbMgxtNMpIm4DBbmwerI3U/vhYjXt6XAQe14MLpB4021BMWdi9sEK4+fqetKyFwF4hrgZtE/OSM27qAFjJi9kujzPUIGY3ys13XjcRdtYGal9EHlwEKddIHlAZio2llyka7CC7O+1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=H2ulepz7; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H2ulepz7"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-4670af5bd56so343865137.2
        for <patches@lists.linux.dev>; Fri, 19 Jan 2024 09:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705685724; x=1706290524; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nij5MJXPr1Ekua+uc/RF5x/wvNKaJmQ8aEq49qT0/oo=;
        b=H2ulepz7jz2ZhC5IY8QNJ7WGB1fo0o0zHfpjfpr+P2PUdbECn0Z1nPVNOQ4nhnehKN
         Bk33GYUN22+aMlsBMu3HXhSIL04OdC6vB7FqFiKb06cZQYLaSlJOks/eXONbcp1dC7Cu
         FNvKFnM9zyE5aw4dUc64+j66v421CbRG0jZexFR79ZFUeFf9K4edbApzNCz4UazYLpF2
         69TlyvdU5Kq/4ARq2B+0ivkU283/1MxpdIY7Iik76pA0Rx2sCUUBJSYIGhYyopriy8ss
         AFEBI0zUE1l1W+N6Wo7s82HO2pBUKreCwf93yvQOFqwzE+8LjYZ8N90GxqwbOq72U5Li
         Ea6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705685724; x=1706290524;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nij5MJXPr1Ekua+uc/RF5x/wvNKaJmQ8aEq49qT0/oo=;
        b=j9s0bCUsf/g4euBxcKfcwjRNKGa24KWsLQgPjkRA3n0OYJ3qp8WbQkgO8TLZxQLP6l
         QTVk4/IGesKZbQU+B+dsGwq7j2MAOEZ6wbNCrxdt8XoMnQ6v0o4bF2UAGM8oXAp0l0b3
         eRHqimm+xO8nFxW8c1Y1GWbDsmfG0rQa0hysjHVdYQ2HgnA9DoKqHWCKnBfV7YnaO9p1
         meezHxsSVEMqEllo9UydpEBBWj1vQi5dOkCXnOSZhUXhOTg6+zqiOEU0vxVLkHFX/Rpm
         Jy3FzyhQpNdlQqswl8Qr9Osei5WYOjQMwOvGOQQWt08QGhArglQQmN5DQg5UD2EYg2wH
         ymGA==
X-Gm-Message-State: AOJu0YyIpJeBRJ9iqfzcAAasaX731aGhxzs0evTFxctjN5eHJqh/epzM
	2jAxeTNW5HxiOnhqt4LwjbDvSyn/T6AD1FxWC2YaKe5L1e8FuD3iq77tgx9Rb3OZ25gUo9WEV2N
	C2mFpeppkNbXJeKmOHU3agYy/SMT23NtC/GMbig==
X-Google-Smtp-Source: AGHT+IG5Dkka/sL/bUHyUu1DFKr5XJwN5zLeHhnPzHMX+6g1NXFOSn93OMgjK9uC5DUpUSsoEJIHIlvpsa9TcitWnnA=
X-Received: by 2002:a05:6122:9aa:b0:4b7:3986:de56 with SMTP id
 g42-20020a05612209aa00b004b73986de56mr87335vkd.11.1705685724319; Fri, 19 Jan
 2024 09:35:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240118104301.249503558@linuxfoundation.org> <CA+G9fYv4PdOsuFmd2BGoq57omiXWuvnSpJJ1HuLYT0rJ_h9xEw@mail.gmail.com>
 <2024011935-pushchair-affected-e2f0@gregkh>
In-Reply-To: <2024011935-pushchair-affected-e2f0@gregkh>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 19 Jan 2024 23:05:12 +0530
Message-ID: <CA+G9fYuPpL13P-5Zm8agOrGKEzAc2kB5yQ_MvWs0AYRKMkNKwQ@mail.gmail.com>
Subject: Re: [PATCH 6.7 00/28] 6.7.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Jan 2024 at 21:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Jan 19, 2024 at 09:18:29PM +0530, Naresh Kamboju wrote:
> > On Thu, 18 Jan 2024 at 16:20, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.7.1 release.
> > > There are 28 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/pa=
tch-6.7.1-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-6.7.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Results from Linaro=E2=80=99s test farm.
> > The arm allmodconfig clang-17 build failed on 6.7.y, Linux next and mai=
nline.
>
> So 6.7.0 is also broken?

Yes.

- Naresh
