Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CCA34A3C1
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 17:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761671532; cv=none; b=EL81y4/2kSu7YgWqyfQBi/GIXTfnCaTiUX6j5NTcV4EJkTuBnhCv/M74xhVFiU+SyxELt2wKnE6sfaGwcMbsVBLR1QhBDD8c+o4gF83fQhEJEjUGWruND+g07MHNi+mknZERx/F6B36fkjhV+ajFdaxK+Gp5bH/QuCdzm4g6FQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761671532; c=relaxed/simple;
	bh=8aY+K6oJRK42GwUHaRODz04gZAOQSJRTEgx7aLu/TlU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SZCAyz18+AUxg/qENneorm6oh+eJSi5mRYTAUy5J5DBYkcSZO1VopleCj/jSYVe94V9nrAsTuJ9MYAgEiasEjHBcL4XpBW9Y3ec80g4h6l2l3bcNmmZCNB12jPvr0Dy8w+NLSLh91+bdzaDES8ijnkFrWNhfv/Bbbdsr6M2r9Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iSwgJpRU; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iSwgJpRU"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-586883eb9fbso7893566e87.1
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 10:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761671529; x=1762276329; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hhaEim7pp67uySZyfPHViLfH6/90BA9wjTtQgKcXy9Q=;
        b=iSwgJpRUPp38iCRSCqyKSQOL4w+I2qWaAo6Ky0O6ssjEvzGux3iZbSvGtaVnZDM+SU
         D9iITs/hgAM49oDG1PcMccnBkvMA1h0Q+0ENBjsQtXQ1GWy58oGx0TmZvo4QagVNf2SG
         CpkXLXNEi8HfLVPQaBnxUXSbadP2UvIjW+qvyOB8+x9P/mJ+KdM2yhr8ce/iRp9P+oeZ
         5l4Tehxs83tt/SvjecQekHu3rGObka9ORTSlnQKwowOUxA6oNoZBqNBCoUvio8/thO0c
         YYZi3fdveMoLyEbSSDl6tnjjx2sQTKmPBxsmL6F3Te/5EKTgm07caQ5g1ioWAJGb1BP4
         XwyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761671529; x=1762276329;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hhaEim7pp67uySZyfPHViLfH6/90BA9wjTtQgKcXy9Q=;
        b=LIMmCrefhvWuWB8HjzzvjDXN0D+d4ENG5YRpCmwJUD6Vuw/IctQ8FBoh8zBumclmxg
         kEDZ3D+FnFDJIo/I0AlPiJ4nsmaTiVGSchEusZcIW+Co78ORfoiUwAaR1a+Y9pV40t8E
         nEseuEm9ZVvtd5SRXssQOm0yZFj8o7IUtR4XuRpdWQg0om7YxrUsrF3MTgfQ2qTdqkYV
         m8Cf3VgsKK5EtvcYaJVJcC91xysJnj42bYsmAQ9zv7JF0i6z4r3L3mf+pXpV9WCh3Shx
         gyn5opeUEKcFBuO4svQ6Oj/XKnH+RAOyaSVaiuuAylC7csVfuj9Jw3vmoZfbLeuZJxUI
         bP5w==
X-Forwarded-Encrypted: i=1; AJvYcCW5IY+/eg2uqwsNMPj+K+Q8XAKIx5+fdnV5MQYQdlOkgAwQJB0UXRSL5BqZXQ6NaNXJkMuEv1oW@lists.linux.dev
X-Gm-Message-State: AOJu0YyV1gkVzl8+CMM//ehjICmlzfJD3Rb7yW5o2TdTtnVx8MZMt4mE
	nJqBUhf7n5J+7ZrHp4cTLEz8XTTuXPQW9FYhI1MXuPk9MD+TJ/ikOKhSQGC4WpVhz40UKdoaQ6B
	nF54tQDiEANp4Phek4bAogEm/GKa0uOM=
X-Gm-Gg: ASbGncu9H1RUjilXSredNa9Tboi5f6hxYAwHIp7bXw3mTREQGJ8Xep5dmVS2PGNq4yG
	0v2x+aHOJJhQ6sn/cAVYBDnH+gYInwswlFAsDt8TK3uzVXMMrkYgp2R4lgpFrV6qd8lLDJRILIj
	SNpG9pqab+n82a8SfLeQmuzbeJecEaDV3Jn2doIjC4b7URQeJpDBKwVwNLhp0U/RVt//y6yl9FE
	289NQzxSqmpcOw2Kc2j+KmI/sVZVyf+YK2/0gT/COdHAff/ez2ZG1EDHhvyRr0tlX5sDodwahd4
	JHNPCj53tyTGFVpfqg==
X-Google-Smtp-Source: AGHT+IGXVzMpnvwsNeD4NLKZTNTvU1+LcBI9oWgBlxyGBWCgiGyua0eoHig285ENZWhSAfa9iwDHF5qVrZu8Qf6uHOQ=
X-Received: by 2002:a05:6512:2312:b0:591:d903:4384 with SMTP id
 2adb3069b0e04-594128df108mr29896e87.51.1761671528566; Tue, 28 Oct 2025
 10:12:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251027183514.934710872@linuxfoundation.org>
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Tue, 28 Oct 2025 22:41:56 +0530
X-Gm-Features: AWmQ_bliD54_NlxW6lHqh2heDhMGVKTWJMWeMi93yWM8vkjT7VQBefaXUu-Hg4I
Message-ID: <CAC-m1rq0XORNAq70r7SuRq3=4=QaAkKoPBWZ58uZz5fYH8pPqQ@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/184] 6.17.6-rc1 review
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

Hi Greg

On Tue, Oct 28, 2025 at 3:23=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.6 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
Build and Boot Report for 6.17.6-rc1

The kernel version 6.17.6-rc1 was built and boot-tested using qemu-x86_64
and qemu-arm64 with the default configuration (defconfig). The build and bo=
ot
processes completed successfully, and the kernel operated as expected
in the virtualized environments without any issues.

Build Details :
Kernel Version: 6.17.6-rc1
Source: linux-stable-rc.git
Commit : 10e3f8e671f7771f981d181af9ed5a9382cb11f3

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
