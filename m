Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3B51891D6
	for <patches@lists.linux.dev>; Thu,  8 Aug 2024 12:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723119899; cv=none; b=Tfm48iD+OqpHHlGRJeVtsXB+u2xYw55oHAS7JbEJjPopcxJ7JsJjGJ72nE/YtYNX4A1MypFn5P90N35nVBIeWpwV2t+Yoz97RLk/7Kpb7bnPrAJGvcW0T3p6YA4/NmvN+ETi3SWZ6hlzX6gCh4Iq87UCmlzwIQwJ8uRbiPbFY8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723119899; c=relaxed/simple;
	bh=oEuWZae036GQ7jXBrMcJ89tlNiHxMOCogZ5ebECNtmQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FUnlNqMAoWGQaLFZONNlM+7g536Cf96OJPYJSR6dl+JIVPpjgHHT+P/2+X3kVjghxZZsKAVylEt9KowpBkhkUp001T/sRLbW77DR6DixSBNsqe6Rh6YoJpsxFoUMx20+0QVgqMZHf3j3scAIM1Ou8JhvaQ2iG1Jovvj5e1H2hh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=ik+ykafC; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="ik+ykafC"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2cb4c584029so739793a91.3
        for <patches@lists.linux.dev>; Thu, 08 Aug 2024 05:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1723119896; x=1723724696; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rfAfcdXAF2CMiBj/87aqcHqpCcyX1shZ8yk7dz5R1uE=;
        b=ik+ykafCLSxHZ+SchCpmAOBjn4wSpKJzrGTQf9EwtVxg6VPEmG4GIPrJsRgKqPu4DR
         y//K7Twn7j4ND1AOOcKbyR3xeLFVG/hwcgddR4yXL88Z1f++n57a6AdYwCJErrD7NgAF
         DHhIKjEvbCxk7gaYIctpaCcs9C2yZFPW9IRwwWY4CZuFcFkSXurdXgI4a4essQPaDRCh
         l3zA3aSD6DvzuoOh4ahdNNDYGMHGnDxZl9WFotu+uTpzWB961LLfmiC0urQ3tByf+1Cm
         LwpDARUDnS2i5ZwRnst1j7fOu8vkloczZnhwEo9J++XTm47OrGA9nSQaidj1G08oBzy1
         XQZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723119896; x=1723724696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rfAfcdXAF2CMiBj/87aqcHqpCcyX1shZ8yk7dz5R1uE=;
        b=jNYAT7+9y4KXw2mr7lTKQVkGLCD3C3p5doRkjzAH8KD7yxgMsB1LiZ6qEOuJQEvUkF
         ZN9su6qu7BUYS2aW48x6oXeqBmtJdcxWeO90D6tr+4AAjTrx+YhpNR3J0mkWo3k+8IsS
         TyNHVueo4UrsoOnwkyW1S1p6yBUJCErC9Upm8arzyswovWffmMfP9PXA3q/qLDRS95Ht
         7BdSl208OBoUDVKLlOzDD3X24BZvit267S+21YN7N8qNx8z2fEpbXsNrjhIdinLYuPqm
         PxZGejDfwc+LpXSTS+xJ7TIqBh9Try6zWQOYI0Y8Q+rq0fClviAfkX79Efhy3HHNj/Wf
         halQ==
X-Forwarded-Encrypted: i=1; AJvYcCWR2q/9snZsjLZIs4hTklU/I6pRsI1hoz/zGh6ulR4ceoHtzaYtMQoN5vWFvaJPI0Og0W3hTV8VEJvuUCrjfLTYpDSBERb1wg==
X-Gm-Message-State: AOJu0YyI3iZKwxRXi8Oor4i2f/ASSwKcBdbJYTha2P2hFcf2Mxl1QMYd
	dK92mChHPboEWKQrpnE3zUpV5dc1jugj0WgF3DHei1zrTVQ595X+uU1WVhKe/BnQAFBM1fOlqW+
	8QzlM5BJ/cxHKvNv+du/uNaQ0UZ2YzQSN3JMnbg==
X-Google-Smtp-Source: AGHT+IGZfCQrsBQaBp8v+W2s/fAHN32pPPoANaguDaxiXXrdG2KlTFuQjIkgMbIJzL0P5hzPmIHrN+c6QDv66p+Xf3Y=
X-Received: by 2002:a17:90b:4aca:b0:2c9:96fc:ac54 with SMTP id
 98e67ed59e1d1-2d1c336efb2mr1862632a91.2.1723119896355; Thu, 08 Aug 2024
 05:24:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240807150019.412911622@linuxfoundation.org>
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 8 Aug 2024 21:24:45 +0900
Message-ID: <CAKL4bV4CXPtyD9Jj5wmUjMnmNgre5UVtmVj-hGAWA7VjRJrzsA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/121] 6.6.45-rc1 review
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

On Thu, Aug 8, 2024 at 12:07=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.45 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 Aug 2024 14:59:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.45-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.45-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.45-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240805, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Thu Aug  8 20:02:46 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
