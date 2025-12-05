Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69590315D26
	for <patches@lists.linux.dev>; Fri,  5 Dec 2025 08:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764922906; cv=none; b=MQwKvCkYkvcK2SbUloqX2H/y+fJoNARCL28FyQlq8YgRq5RsujD2axSmzuciSkU+4wkf4GsayMXhkkVgNVz1XE5ocmCuGFcZti6btmQMVUQyD9v8nOx2lb5Nw46at2LUhPrWZYB2HXxFYkryH0vj1tMbS4tFvVIYZ+JnlZIYoCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764922906; c=relaxed/simple;
	bh=r/FEYp9G7BrUaKaqwcSpDLY7KkubmezBOfuvt/6isEU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qFbEK7d5j30V+rg1/OVUuTk8nflVsq4S44Xgm60iehkd0eAGj0PrA4U07egFVdfqHhdmwE53QxnL6hyw84GYJoPHOZoyNtjXj3+9/yFMqeRDXshoI2S6S/mD18QzL7G8IpVL9tA8EzDi/hDEBF53KeTFD0nvHJIb63pjdtMbWks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=boLemkue; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="boLemkue"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b7697e8b01aso82976466b.2
        for <patches@lists.linux.dev>; Fri, 05 Dec 2025 00:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1764922888; x=1765527688; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CFTqnO/Fd2sawQQhIPcCoLFvSOoCx15UbnxbNG9nqpA=;
        b=boLemkueBzN7VdPmiWC9kCT7ZZVYrNSm5EujGdIPiH9DUFE9799Qr7EBoUHkhA7XV2
         CRMXfmwD611LVC+EoRmTq3o9I3hhn3LWbS52InbYgPrjo31BMD5SrPAVe6UjLO6BMKr5
         Qaa8bdc8HTtngYm9NFxEV4GzFMKg8HzlS2KW51yIngSWEsNj18oU+x88us+aCWMIN1pl
         Tgt/7t4CJ6RfGugyhNyJVYjRsNyaf6nBslYvZwtkfHqYTSekz0/88z6qC+nN3nzjikHf
         hePq/48mUST5z6u7xgFUe4M5Nl4L7e4RJANCMgiSbEzI49eBzWu83NYTfddlPthYEcPu
         mrVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764922888; x=1765527688;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CFTqnO/Fd2sawQQhIPcCoLFvSOoCx15UbnxbNG9nqpA=;
        b=L+kOaXev7FIxXwD/BXZXnyp71rQIiYQav3wa1KU6SKi6/auh/rLT7TEv89Jj21KS1q
         rY0Jtp5BN/QpuHInBJPeC/9AV3vUmWLZEoXPgjFhRslyY6TtVavq/o1X02c4ZIBMjMah
         YMO9fi9bKr/LQqHC4JTA+wVaWbpkEwMa04Ax4yshNPKYhEb19qmEMV2rqUOiGRW0bVNc
         5ThkqvYY9OrPz4jYybJhbs9dYAtWxuyUMf+lu0PGmG7xVNwend92wMivI32R0KPr5ha0
         PIRJz/FR2SIkJTH2eLyxpxJU8VmB6gwWVSx/cWtFanZGRWdF/zpCqxt/vWT4mwaqMObG
         RzDA==
X-Forwarded-Encrypted: i=1; AJvYcCVOGXjrLuQ/DHmWJE0Zl4UifsYeF4NNI7OvItHzoZbV+Q1lpV6/la1EY1+o1c5hO62YENYHqVmI@lists.linux.dev
X-Gm-Message-State: AOJu0YxVFSoV3/OtnTl77bDunRPbsjNdOnL5s0chs1b1dPcnZa0UqaKH
	7U+kHW9jmLRxZEt4rdyYW+w1Lfsfi2rN7ZAS2JCcuuyPcvi2O02EN66f5mO6E3ga3frCigvBVsE
	OuYls4aw8z0SO5l/u1Lj/bTlJJYV8ZfzlryeuAYj3UA==
X-Gm-Gg: ASbGncvfKIgqfTaYcoXoqS0MVfSEgm5iLuuO6sRIfzwj6unpy4Jjys3nrNMXx6WT0w7
	wBTvHTs2VWJTP4a9srWUTlu0/XpduM5WcmNpfDdjy7SlLfXS8qgYb0kBH2aBRKowHljqa3Ql7Dw
	SKfOLKSYFM5jgU4QvDB1e8vV9HaUP02DCEr3zfd/FjRTY2MFdVVAI8MqXdAHxUSv/uGBmWfOz0R
	8mK2V3BK7s0peAPG6aOqZ+xHOtC77fc54FvN1HqUJMqV2et6J5uhNIcwCQry7P7XyyG1I0=
X-Google-Smtp-Source: AGHT+IEhwwxVHvBzGnvcRs1ZBsC6V2SXb5WppN3WR1olH3vWXdyabaLt9X81lmdZJ3z1dsJ5nsyoiNdGQcjQaOVSH5w=
X-Received: by 2002:a17:907:1c27:b0:b73:848b:34ae with SMTP id
 a640c23a62f3a-b79dbea8994mr919780966b.18.1764922888243; Fri, 05 Dec 2025
 00:21:28 -0800 (PST)
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
Date: Fri, 5 Dec 2025 13:50:51 +0530
X-Gm-Features: AWmQ_bnFM0yAOGrLLgGAq_Fa0ruYEvV3PENXxVfn2W7oaTqf_5z9_nXm-BZquAA
Message-ID: <CAG=yYw=8ZXmf3KE8QDAOJrJ8VtRWgMtCNv6=6FNJw1P_jFw+Rw@mail.gmail.com>
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
> Are these new from 6.17.10?  if so, can you bisect to find the offending
> commit?
>
> thanks,
>
> greg k-h
i Have not  compiled 6.17.10
This machine  is not the normal machine i compile  for kernek testin
THis is a typically old  processor and motherboard
But let me try to compile 6.17.10.
and see if i can do git bisec ( i kind of forgot .. i have to learn again)

anyway THANKSt

--=20
software engineer
rajagiri school of engineering and technology
