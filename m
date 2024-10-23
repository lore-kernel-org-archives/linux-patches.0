Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A8A1CEE9F;
	Wed, 23 Oct 2024 15:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695902; cv=none; b=axVxVagM0vMKZ4POzGOkxxpYSXlN2C5voIt0oJ9wKFPNBbW5Wp3bMSfnPeeLoVNAn5TSVV32aLViruTXBx/0BwwqHczjo41/IF9ry0nJYe5YnKpeolY7nd6U/YMst35GK1QqIdGgX7ZiIjfrPdJ0Ed9YfWFaWB2NyiI+gW4NtP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695902; c=relaxed/simple;
	bh=zwm0YdUlkRPFpLJprNcgJfyNzN4ksSJVM/GonbtuotI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B4nKH951SOgw2LxHV9nUZLe/y3fCjeGQb30eAyo+Y6hN7tma6l5zj/M0CXIRtXZw+GgcLTXjUT3sLwKQPMxTpnQ11mno6WXeT9/7m25Oy3Hfl0T11WZhIG/9L2HdyIz6pTwwQ1RwHzFIKwv4/gH0+nyMjjY3DZHi0KiC/+nzwU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D9TuTazK; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D9TuTazK"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5ebbfcab9f4so2041686eaf.2;
        Wed, 23 Oct 2024 08:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729695899; x=1730300699; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9tuzyAe8JQhERe3dQ6ji28tLfp5niGHH7P19VuAauSs=;
        b=D9TuTazKU7cF/swAY3IGYpALpLUSMYhRsBswKAOCMmXtA/9VW+uyp95fnVfsR7Vea7
         5Z+pJEErUhHCWDohs2qprbNWClmB2UAPtpahpDlk8tO3KUVz4pubQmVFK7C9FI4RiUuC
         FiMO/asD53hgvfg0TcJcR5A0jssgWm9Q5fGNZ7LN3QtyGT9oZfjfbcNrqSzwYefB9Dq+
         CmGgXUqnCXgxmhFp7GvidMDk41HpRe5MBisUoT2+7B59tU9qnRrBnd6SiHZ3gNfl8l3P
         7w+hlMLQ544F7m4boK4eMIDtXxB9RZJBvO4lMb7+VdehIMVjuttBx0EvKWCzu34D1uoa
         Nuqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729695899; x=1730300699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9tuzyAe8JQhERe3dQ6ji28tLfp5niGHH7P19VuAauSs=;
        b=ORU0CxXhko6TJoEQ8oRkZi7UE4WABg+e7XLBhGd67/bDJvLKM52drX9bHjKgDd/SS0
         TbuFYULClfRb5JVqxNqC/AwdfPBnMCACgz6sCvxOCWrk9itVP626IEMwvgBvns1jZANW
         u1BR+PzKiFRdUXZQZu0xQIVOa2HZSiOUKo5SeN2/A5feVa45Sk5nPg27h3EFMrQ8NhOs
         23xPkYYugXjGa32SE+FpsqZqvSoNA72gXOxk1ox69EnP+i8EPTZU5Ht4ABKl9SIO9PvA
         aQReLEMt0Dnp9+bBNSk+2jnWvP4NbHU4Vr6vV7OLSWCLQtSWA7N+oscE3VZbzi8W5OSP
         DWnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbVTPxxftJ6tphDI2MwIKBj3NPoX9qzGzuH2kaUAe6ftmgJnj5NX0HBmrXFNLk1jYLH2U=@lists.linux.dev, AJvYcCXjv1paCaWuczAjkm93waBvToGdZ5eCvjEUav61JsqN23HdI5zdfgbaqRdCxNjrK0zw1OZBbXm7Ig==@lists.linux.dev
X-Gm-Message-State: AOJu0YyTvnW9ZZa7mtcc1i8jrM9r5bJgEHooGeU3IuUzY0G0BzVFUWi+
	muJ/FljwqKuyRs9iUgtibqCafxp9R/65k34xxOte+xvtHrw9pymUVb2UNWFqaMQkElF/ngfHb7j
	waL2LqWXzoG10T0/HNyC213Co/AY=
X-Google-Smtp-Source: AGHT+IELnyS+e/TN/dMdHzvAA3dedAZFpyyaBekY76IOdFg+Te4WZUxhJCCdMsqShzs8WjVE+pUlBhArE6QTMefHWi4=
X-Received: by 2002:a05:6820:1c9a:b0:5e5:7086:ebe8 with SMTP id
 006d021491bc7-5ebee308838mr2092425eaf.0.1729695899332; Wed, 23 Oct 2024
 08:04:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <a08dc31ab773604d8f206ba005dc4c7a@aosc.io> <20241023080935.2945-2-kexybiscuit@aosc.io>
In-Reply-To: <20241023080935.2945-2-kexybiscuit@aosc.io>
From: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date: Wed, 23 Oct 2024 17:04:47 +0200
Message-ID: <CAMhs-H_2tnpeynm2m9KNGL1GVU9m+odSnTk6F-WKLruMfEjXUg@mail.gmail.com>
Subject: Re: [PATCH] Revert "MAINTAINERS: Remove some entries due to various
 compliance requirements."
To: Kexy Biscuit <kexybiscuit@aosc.io>
Cc: jeffbai@aosc.io, gregkh@linuxfoundation.org, wangyuli@uniontech.com, 
	torvalds@linux-foundation.org, aospan@netup.ru, conor.dooley@microchip.com, 
	ddrokosov@sberdevices.ru, dmaengine@vger.kernel.org, dushistov@mail.ru, 
	fancer.lancer@gmail.com, geert@linux-m68k.org, hoan@os.amperecomputing.com, 
	ink@jurassic.park.msu.ru, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-fpga@vger.kernel.org, 
	linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org, 
	linux-ide@vger.kernel.org, linux-iio@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, linux-spi@vger.kernel.org, 
	manivannan.sadhasivam@linaro.org, mattst88@gmail.com, netdev@vger.kernel.org, 
	nikita@trvn.ru, ntb@lists.linux.dev, patches@lists.linux.dev, 
	richard.henderson@linaro.org, s.shtylyov@omp.ru, serjk@netup.ru, 
	shc_work@mail.ru, tsbogend@alpha.franken.de, v.georgiev@metrotek.ru, 
	wsa+renesas@sang-engineering.com, xeb@mail.ru
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2024 at 10:20=E2=80=AFAM Kexy Biscuit <kexybiscuit@aosc.io>=
 wrote:
>
> This reverts commit 6e90b675cf942e50c70e8394dfb5862975c3b3b2.
>
> An absolutely no-one-ever-reviewed patch, not even by the maintainers who
> got removed themselves - at least not on the mailing list. Then the patch
> just got slipped into an unrelated subsystem pull request, and got pulled
> by Torvalds with not even a comment.
>
> What about the next time? Who next would be removed from the MAINTAINERS
> file, the kernel.org infrastructure? What if the compliance requires
> another XZ backdoor to be developed without further explanation? Is the
> kernel development process still done in public?
>
> Are the "compliance requirements" documented on docs.kernel.org? Who are
> responsible for them? Are all that are responsible employees of
> The Linux Foundation, which is regulated by the U.S. legislature?
>
> Fixes: 6e90b675cf94 ("MAINTAINERS: Remove some entries due to various com=
pliance requirements.")
> Signed-off-by: Kexy Biscuit <kexybiscuit@aosc.io>
> ---

Unbelievable...

Acked-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>

Thanks,
    Sergio Paracuellos
