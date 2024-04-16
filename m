Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43C586AC9
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 10:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713262423; cv=none; b=I6KKXA8uLzUiDcH26zHlRxuOszOHP4W/AWWBpl+ETIYq0PYlKZ6vRE6ruT+o4qPpL2wN7vEE3IpRYYL5/rSdaR58M2j6/YE9WDZRdJgTu/OON08iA8Em7xDFFe/R83d7q2GyphCyHGNdT4nRnjXaH1G6VCwyJxQzSmpJFYv+clM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713262423; c=relaxed/simple;
	bh=PLfHS/pr861fPjFBeMBoEopPIt381ou0qj9dA0o7sxM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TknyXeoZMBSeerhY0U9EyUlsLd0SMs0HYpSYd9tlHwr1JSgAv36itw13w5Rb1ePXCwpIHo2nXSfhzW6/0dpcXNJ/LJVeF0ankJMNwFmVmqAsBzupe5xGE+p7Gqkrawk3BUCAL4WEZ9WbNeFzCgHBgCM9Sj4X0m1DulBGTDXpZUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=ScNb0YjH; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="ScNb0YjH"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5dcc4076c13so2782460a12.0
        for <patches@lists.linux.dev>; Tue, 16 Apr 2024 03:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1713262422; x=1713867222; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZfb01z1cElSdFgczCPztvVWoygfwcGgF7HnVAPTuEs=;
        b=ScNb0YjH0uz49vtv6WVyuE6jKviP0K+KssowfMaKy6zhxuISHHR8aPfNl8G+ndn9H6
         hzPRLU2/IgjSxur3yPEKT8ZjZsjbZLhizoo4Y4t116qBiy7ruuuJmv8LOG2Nm/2jxU5s
         uhJwON9XZYbjUYi5xwIKUsLmKHGTlZTHfXG6BXOusT1Mk4vgpJpsyi3quP7sSKCpal8E
         WcJbZzU7JVl5alrddmqtzxLr5rpf7doL966wd74aeIIHbw1k2jHLdpF293+EyGLazpsh
         tA41sORaYWOSK/NX5DMDREHmOxNc9ZuUvXfrmGKiTZAOOsru1v9XB+nFgDq59+X/A6q3
         ZRQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713262422; x=1713867222;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YZfb01z1cElSdFgczCPztvVWoygfwcGgF7HnVAPTuEs=;
        b=ff6XFHGjwqS7iNgaNa6SEi6qbRbEhz9S9l7aBFXn5xNXSMeW+2jAQ/MzNW2YGHtaz0
         KCfjxYSG4azXO7fQCqVvijL9pqAis8xWxK839Wv2yA7EyMJlb2SuLdFvbM3o0sGRy1ZH
         N0PQ92Le8iS+13CdkaSoqrloZhfwdAIjsdEFdrNlQ2Gia0mziPbmt0rAldfDVw2ujB8U
         rD6iraQQwfwE3bFCItUzSF9CeX902+6n6VEL+HIsBIkci7vGBE54ic0jRlTLawkksVzT
         2zreQciS9YDwLq0nUx0L71dMRkiitOJ/r6PsJf1tz2zTa2NP6mF0dKjGdUyXRe9qcpHl
         vD5A==
X-Forwarded-Encrypted: i=1; AJvYcCXkK+vuFA+rfkWQGFq90Z3fzdNs3ph1JSkWmgs9GANtkTuDr54gHTRfV/B7PHqQoh1XazY5clO04ft6S1TrXi2NHX+zKwK9zw==
X-Gm-Message-State: AOJu0YzV0NJmi/YKlrSuj60ZnCA0zIN1DkyRkALAGMNtRAtpuJnX5u8E
	+6QEvyQS/+rHOt+7ktBWJ1pTpU8cT9QHHyC69jvk+vLe6MF8Ix3mo5d5JSBjkEwFtLl5CZFFT3t
	gEdwT9nRcZhU+vAoPuh+yXkZEtp6ZiwOczMIDgg==
X-Google-Smtp-Source: AGHT+IEAmCX3pj6Nd8BE8HVb4J6COM8iyob7Dnrh8XVaPFzBOespQeJDXW+F7FT5eUBAa5B9DPn9VuXJil6nMAitpYE=
X-Received: by 2002:a17:90a:f105:b0:2a7:8674:a0c8 with SMTP id
 cc5-20020a17090af10500b002a78674a0c8mr2945956pjb.1.1713262421827; Tue, 16 Apr
 2024 03:13:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240415141953.365222063@linuxfoundation.org>
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 16 Apr 2024 19:13:30 +0900
Message-ID: <CAKL4bV6gTOUt=LomZjGceMm6SjqWeOXXeTE8EQ7H-ovQvnfzZA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/122] 6.6.28-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Mon, Apr 15, 2024 at 11:35=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.28 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Apr 2024 14:19:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.28-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.28-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.28-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Tue Apr 16 18:32:52 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
