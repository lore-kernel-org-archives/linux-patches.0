Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9010D16EBEA
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 12:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720011295; cv=none; b=BVW3BEDiOGDv83urM3l6LG7eHZL4yqsw8Lv6TpIUqLMONQ7bQt0Pe+vOYu8cv0c7fY+NjloVnUBH/YHBhy+pcGIpjSzp6O8ab6Wi/2SshlGW0hKQ1QFPsNj4uPc8bi1MjdBx/7ySIxXvdgkz47AGy2+eGEc0brP7D3kNM2x/f9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720011295; c=relaxed/simple;
	bh=rS/W1TqSZ7g/nTd/PX/LNoXQ3bRZucqWJPbOkYLIWVg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QbnFlf7UGyAkp+OTN+SbgWXSecxvtCScjtRivvCN7lK9oT+wWrPzhPXuTEfpUULplBmHMKqe2OBMGlr7HzHYNkP6/nvNy0SI6FAs+12GFYhJnJm5EyegcBtdV4XUIUfYkXcjEYUJxVHnYY2bWcnMw0HkvrsX6veEY2PjWb9RfTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=Wzi+cVO/; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="Wzi+cVO/"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2c8517aab46so3997583a91.1
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 05:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1720011293; x=1720616093; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=855SeBJK+kQf7yXIRTBaRAUIqwJW4HXVIPFfDWbcfMY=;
        b=Wzi+cVO/lZgjIitqPnwTzQmmd84rdZfHq/BTJZBaAuEdFQ+71uH+rbr9aMsUVhSDvG
         ueA3LR7KZtuu5qAnT4ib2S6c2ExWPV04w5TAddU80mAk/RKOVSLYcIB2NOJmm8aG+vBX
         X8DyXpJ07IrdE0hERrvH0sfrGOI2F4r68PSwB06hjkZg+LR7wjpl0PUr2Qq8j8KEP4Dt
         B0bMD49Z2h6nnYIpKl3llyQUdWmiAgXt4UgX15jm8tDQwssFHyXAzInb2XhVirJlrufH
         rfK4g4JenUR0Uwrcd0EpIH7uW8tcKvqHjU2Yk3uJraCoWcELf4k48VKYpZS3yYPAny9z
         r3Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720011293; x=1720616093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=855SeBJK+kQf7yXIRTBaRAUIqwJW4HXVIPFfDWbcfMY=;
        b=mPPs7/sGFHm7/TNSmZZ8wq4EXW5UwZPkvZ8YKogeG3v0QP9f/2HhKQe4Xnwp04u17f
         fyfyaKanL30o/eJ7ttUXvuEOrRGH/aMxXjxH09W2y8L3k5saO2K6oX5HE6cVbqfjEkAs
         w16rrxwF7op1VWbZXN3UMzn7ojcnGuRChJirZzp3lGVqAGHMEytq/q1ZzUDkzIsBAyYA
         NoY3XXixkXoLzOJ9XXkFSMQDGlWZx+ANKl7sek717Pkt2YggGZp4z8RAi3tg7A30TRxq
         xBIG0hzmmtNUUZWtLYzfJlF66AD2+ky9yZSal9fpd9t59l5KtJ9SFJB0D510LGF4sXUy
         7Icw==
X-Forwarded-Encrypted: i=1; AJvYcCX4wk4C5SDIVIMgQ2JwGIRdfK3C8cEdP9Jx+s5IAvo6FOxRQS+ZZtIAT9+A8PX4GUoOGYpphycpOUfK/w0hDtWD7a/qwcJvxg==
X-Gm-Message-State: AOJu0YzkiH6GXcepw08vPsLrjPu+vNmGtGC2bzqV0pAlWS68kHrKb0WT
	BtHASzmXJ+DcuCIwFtCqf5ccloWRLBtsOQCLRTtZ7GeWpdXQ3aK06AoSwtVp2tfUuybiA/GW8lE
	ym+OcVYdDRYR+PUaxY3EDA8L4N+AsNHcEJ53o3Q==
X-Google-Smtp-Source: AGHT+IFeyxBhLt9MzjsdGvcxDI6Ss8W8+j+tZYOJYbNYqfjc+caqhGP3E6bzdV7g9BE3Tqajxbf9EkaaSQfkC7aoh3c=
X-Received: by 2002:a17:90a:8583:b0:2c8:df15:5ad7 with SMTP id
 98e67ed59e1d1-2c93d777302mr8133982a91.45.1720011292909; Wed, 03 Jul 2024
 05:54:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240702170233.048122282@linuxfoundation.org>
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 3 Jul 2024 21:54:42 +0900
Message-ID: <CAKL4bV5_povtwC25oFZfBHHzjHN_=aKGb_0zE_ZJyUJ_WseeNA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/163] 6.6.37-rc1 review
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

On Wed, Jul 3, 2024 at 2:19=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.37 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.37-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.37-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.37-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.1.1 20240522, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Wed Jul  3 20:52:59 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
