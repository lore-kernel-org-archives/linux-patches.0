Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C075817E8FD
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 11:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721214352; cv=none; b=jMoI1me8AZ5bb1b7mNDtn/HIvLxrojybiuugnSalDpRyP9n9Eg7kEaPw4Nc8FsecqJjjar47yiarSKuHEDAB8u9AnTqiCNIbFm1b4nwr8Q1FT25gynGVjDiwYnawfzX7d4QgIr+MQHYxje2NEMoLz9GOjwtgOlqN16p/G2EQz8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721214352; c=relaxed/simple;
	bh=P8bA1rS6MaVNpvk9zT8T6Vnj+t+0m0xxGVPMegUW/sQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kwckX1tVRD30CpLoqxtKG/SJnOXV4tw22CF/QEzDAmNf95KsWOLAOyjjpdv4liENnoHY6Durp5gfibwW37BfPC0COIliGrtNFEd5tsVXHS0V/lMWrrwtqs0E4RQXMWe9RaVDZKisuPVAeCXKDca3If706FRQUg8wAyhSmPf1szI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=U3KPxSRg; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="U3KPxSRg"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2cb52e2cb33so309958a91.0
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 04:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1721214350; x=1721819150; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4B7F+PXb3NXcc4lYdWvAiUE7PDiOcWtXI9jJyLb/EpU=;
        b=U3KPxSRgJy4+LTPPlBPNguWy8YYs6KhQyNsWFglly8asIJWEbbkV9qHXF8iZ1R+rEH
         0i+jRW7M6bSWnlFBwdTEHwC5nYpADKJy6VDbOSNIgAVsBtfVgiN2QvbKykQJlovrU1FK
         w4YMRQRboX/wDhbmf+q7zYPg34xL7TqFl1c+Vk55QPzuoyFvyc3NjrtvbB75Amk4Mw69
         XQLROg2LcZaXHdR77miIbtI87HUCUqmckzQ/1+fu8UOTQQK2TzAvBDNCjgRrmZboAdRs
         ahRH+FBN1hV1a3xJWwIurNEgwzCUgX5ZzBVWk3rjcJeB0qB8Zi5ZmXLEGhiFvoz3L7f8
         M1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721214350; x=1721819150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4B7F+PXb3NXcc4lYdWvAiUE7PDiOcWtXI9jJyLb/EpU=;
        b=R2VBaGC/kYMj4DezE2Up+JwD+U9m5s97ANm4ww1eAwWEpqnhSSQ1n5sfQDfIUc0Kcs
         l1O/hzf/Hho5Wx/OOT/jjw4U2fHYUt++phjHGz/Gz2yGQynU9y9poTp7doeM6dYfodyW
         mgrDKKfp+Tr/t2bGjbm3Shx1df2riK20EICbjQ+c6OAG7eI6UYEmGdsfNxF/mDSrgwx2
         +0BYNsKfqHxSD+OnoHqFramdmP468WvcT8tDRiqRgFoqlN+aZxs6I4ZvI9uu5KL1V9Qu
         JYMjhgUVujcHd1kicoVl4SRxsFarpn/kC56BABQgAY00aQt95h7zGGr1wOqaZFVs6bxJ
         dZBA==
X-Forwarded-Encrypted: i=1; AJvYcCWVQKS2JGjTbVO6xlSqA3gyA1EAMd6mEelfJBvYygdOPbZzDo8KdOPpGHwvTehHkNnAcQaQDWkaeQP/cAnCiDnJd9Y/XyDV6g==
X-Gm-Message-State: AOJu0Yxtg0kYFkvxy8ZtVCMxurr+B3h6VMu7ih3My6dE5CLkK1bqH2+b
	UZbX7EkMhNxy/Fbsnm1/uPunsJwtn6Lga/UkT2y1tRJvjXxjlV1jubByEtxlxoOfHUHy+CFbrHw
	QB5a0Ni8EYEbT8UolzTmipAAcFmGClS/qsOS1oQ==
X-Google-Smtp-Source: AGHT+IGpbT+LGHYMMEvAwob3anXjVXuRNtGMAa8CZJI2wGGY0WG7oGPHIyCVsYd+8uK+P36Ly1r6oAyhxwJsQfCJp+s=
X-Received: by 2002:a17:90a:db0a:b0:2c7:f3de:27ef with SMTP id
 98e67ed59e1d1-2cb5281bd47mr877582a91.42.1721214349817; Wed, 17 Jul 2024
 04:05:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240717063802.663310305@linuxfoundation.org>
In-Reply-To: <20240717063802.663310305@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 17 Jul 2024 20:05:38 +0900
Message-ID: <CAKL4bV69HvCt8wuFFjSxk69PT55e_qERN6NCHDRKuO7SeF72ew@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/122] 6.6.41-rc2 review
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

On Wed, Jul 17, 2024 at 3:40=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.41 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.41-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.41-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.41-rc2rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.1.1 20240522, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Wed Jul 17 19:25:19 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
