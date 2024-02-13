Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C496627E4
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 22:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707864413; cv=none; b=klHmouCHn6Dwze1wyT1vs+x69wcOpbEryKI79+vLGsI8kIjym6ZS477DLOJm2dtokmDu4pLqCd6sWIj9P/JNO4WRgSEKeEQkFZgnS+7lejqtWfRfgnER32IiKfvwgZLm2TppaciWSQNZyD3DEMQ8ylqSJ6j+l2voGK9GXqYd8Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707864413; c=relaxed/simple;
	bh=FRDJja71U5DrXktTUBUgHd1rXiPpJ9AuqTb+oGn1JSA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P/zGzNT1VG/UqNu54YaoQEUTubbVPFRm3eVTWrn3Ng/5KQE0owX/kBEVLeqQq4TcyjZk9g+jemwRWRS4EEEW5K7AMCKPtimXtIbTiRd+Zk0yzC94WNJuDbGhXRTYKe3hOmYflDp/beIlJkEBk/NXye4LO58wUXVCUOy3toq5VCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ezlk/9jF; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ezlk/9jF"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-4c01c53efe5so1362893e0c.2
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 14:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707864411; x=1708469211; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Uy2JEYRD09aqM5i7KnSx7BIhhrKS/3nlwMCyB4mYneA=;
        b=Ezlk/9jF40PH/ceZ3ZnSMjdfXvIlgY40WQzP5vFL0ppld0dx5lrYkhNLfCiBIdmSnG
         xPVNLBgQmRN2sVBBfospvDu4NmChtUhyGBTwadd4anWJ1rifTVnqoV4+vznUmGEQqIm/
         n+QF6Twd2AWZ6oYriUC2YMod+jMMhS2EqLShC7g/3sRzzGG489ifXIor6q0PHsj6aYz/
         7tYbt57zkzhp1205BcpmzDYxi5SypgXMXM87v7e8uJjxi09tH2NQvNKjIkKLX9qVCTHc
         zoiVdL8xVofLY6wCT/iekQbm+mbFOLAfHR2IhMTkOMhVFxwTcvwtRXzjBmBHU2IhZ6Oy
         TxPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707864411; x=1708469211;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uy2JEYRD09aqM5i7KnSx7BIhhrKS/3nlwMCyB4mYneA=;
        b=TSac7fHQRbuFLGfX8LjSarnw3s+4ZnyRPOJMBP+X8hp7uExb/RF528NNRtIDCq7VlM
         YemHoVvSt5eJzQpX05uGjexlGKJXOfkKYoQi5TI1ypfa4JFM5fuzMv9OGHyD62BKI/sy
         4M34VkUwlXjRjcyw+b4yg6c3vxbQkC24YLRjpkNIL36KDAgEHJYyhWUtWNKCM0rCz9vV
         E6s8QKWtLodNxo+mDVW6RxPwNO1nU4Cgl0Xdxd2PnWGZi2doaRWp1vjV1xIrEoTMsiZr
         RwqVz5+bIEuQIMr0NdEAyJIAtzLaHuIyZ14GO/CgPZVGMc7rPjgxKG60I2FEp986OXYA
         E17g==
X-Forwarded-Encrypted: i=1; AJvYcCX8vy97cNZ5lbBxVz7qkjBANhnkRtFGMcHnVdfDy02r2G6L9Le7swcx1o4Wc2TLD2zJEhFYVa5YRz1/Qc1jm9C6b7+MHhDdJA==
X-Gm-Message-State: AOJu0YyXcWN1DNGoyxxGqHHb0wIJ/3ztg/l99BiBpC1H9WlMswEDuu6Q
	n9wtudndWDC/MhOsxfzjx5M+hKeowTcOThseCmBb/YZGtPLaF1mqBEJ7Md6hmHqYXuXDStSpURi
	iTxTw8RBJvxnVrh/Xx1UOLU0FWcI=
X-Google-Smtp-Source: AGHT+IFOoLL4fRg0zJbClul7V0irJCq4xfQlGRkgqqm0tw7lpzVjxWCGpCimyJ59GPzIsD+EQBElNVzfv+JC/cyMkLA=
X-Received: by 2002:a67:f051:0:b0:46c:f77e:6f28 with SMTP id
 q17-20020a67f051000000b0046cf77e6f28mr1032548vsm.0.1707864411160; Tue, 13 Feb
 2024 14:46:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240213171852.948844634@linuxfoundation.org>
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 13 Feb 2024 14:46:40 -0800
Message-ID: <CAOMdWSLjAwrdYJYjejkWLRTZTYjgFqJ5=_PoWfQFLA5mpG7Mkw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/121] 6.6.17-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.17 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Feb 2024 17:18:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
