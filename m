Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5ABB27815B
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 13:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744983359; cv=none; b=JyxDQ8CTS5pscJyja4LRDvfJh5lMJUsD3G17Csf2/JppWPuPDqgOrjM9oMN3qyFmoXWsYes0MR57ogBX4qUM0QaJF7xYMT03W+ud2fusJ1/ErlKCsJ1L9Z6dUoy9GVZSOU7VrUNQJvBq8ONNevzWd+zThRYSXVPWNNtZy+SiKSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744983359; c=relaxed/simple;
	bh=3QDmuHmDcXII7yvPfaVTp22nIGOY70Z6X9jLpFJwTO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PaQiZpOgz4rmgA5XV4EQv2RM8tWbqrPriXLRj0/pHmL+E/p8Ouv4ZVQHh+z74dW1rcSxj0DpjnhPtqV5NE24o3bxbVnGCD2wt+KnbWXMY42dwzkhZg9xRZibmLJzPrLYrdFrpXnmndudktc97z2XhGHsCXdsSD7AXp5N4zCtyPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=wYX3kSXz; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="wYX3kSXz"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-306bf444ba2so1653933a91.1
        for <patches@lists.linux.dev>; Fri, 18 Apr 2025 06:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1744983357; x=1745588157; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r45gHrvj+34dC5NFe9TWN4ATAYJOPM9aWOmtX/SbRpY=;
        b=wYX3kSXz1eYIAzGqG/RTlOQ/wHfSpRhp4qaeGOb8ePrZSfGCLD8L93j3a65bj7CTRZ
         1sVnFTvuqhQTz8PbTFBbGme4CVunHlBFcY/GX5f99eRi2SCPPJw3RmnJSgAWHMB3CKSm
         Qay1O5uWe/27Ui7u7jrm4MyViSpIkrG5dayyuEzEn8kRYMayWUPauwKfOEhLOrnJv2k/
         2GXRm2k0ZXNE00s6wYo2Z7JTt4pf0D2aivEqXMOKoxuq9BwPK4Cr+PkT6HvRd0eTRf6d
         Zjkmp7AkZBG+ioxwXIbidTNr/h7fMZnb5gPXlaZ5qmOd3kEQSjabeIxf+KszNypSCs5y
         QI9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744983357; x=1745588157;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r45gHrvj+34dC5NFe9TWN4ATAYJOPM9aWOmtX/SbRpY=;
        b=IU8nf/OQTHMbVWbusdjsttVfh6F3aSwlPbFONlDVXxUzr/oZurPsN/dot5j4eVHgGQ
         l3tJDMo29XlMQJE1H56wrvy1gutaO0bYZzLlRNlofFAqvF1+2viUEk7LzZieFgLH0ZMS
         igdpYvt53QX5nq02eXk8zOvfDtcD3JHp5S7krtTi+BuDVwX8caIj4S+JAfNwXO6MhEzA
         tiKWqsbmDWbkCz7r+Y9RbiwTrxXhyc33CEkukP4WqEUULkU7UJlE1MHPuDMNw8PjLlWR
         7pH7UovXnXX1VPEq7TB0JTb1NnP9iEWxi4lBDo4YwsWhhUSdiLYBDtcJiXZ553w/HvwJ
         nzTw==
X-Forwarded-Encrypted: i=1; AJvYcCVM6YpDq+3ozDvANOK87Hdp4aXjn29vPdZL2v/YtyrOd4KLY2QzQ4MyDnxKruvpIyE88luccOlu@lists.linux.dev
X-Gm-Message-State: AOJu0YxVs8+F8YcLsLh6o2A1riGb7EEjiTwWkcpSNhzvGAH4GOLOFWWi
	vuaJHDWM34a6VAxA87d8q3CgnO7UmGVn86MNNJHTquYY2kF6ESYXOk1rdt+SCiPQ+gyezgfHPYl
	0tDQnApQLKOQEphREPAAJQdpu/xFKF0PxACQ4eQ==
X-Gm-Gg: ASbGncuveESSlP4jWi4RETsOxHiViZ5+IqNV/2mVL5rY7ADyAhsvFF9X6qxIqXbcc17
	2atgaRVYTmRyPTlxedGPFb77qQosFkStNBvyXyyiS763fbkkoOeS0Q5XJdcibFGuksB78PNw4yH
	A/gORoeey78tagGRgRAiRncQ==
X-Google-Smtp-Source: AGHT+IFqngEBbHaX2QdwEE3HsnDHxcnw7w8+EIZiIRsTTuz89IIJcidVWtQ0RrBbV3822UkQAYwqoYqBNqqBeud2jKE=
X-Received: by 2002:a17:90b:528a:b0:2fe:9783:afd3 with SMTP id
 98e67ed59e1d1-3087bb396abmr5001654a91.2.1744983356901; Fri, 18 Apr 2025
 06:35:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250418110423.925580973@linuxfoundation.org>
In-Reply-To: <20250418110423.925580973@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 18 Apr 2025 22:35:40 +0900
X-Gm-Features: ATxdqUGfPD_Fn3CbFgQ2JqWIaEF-HIOZJH7bBppNB-unRzzXA6xZw7RWTQbVovg
Message-ID: <CAKL4bV6cjDh24qpW-g_a2i+OF_kujS0kMp-Dvy+OoVAiOJLHtg@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/447] 6.14.3-rc2 review
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

Hi Greg

On Fri, Apr 18, 2025 at 8:05=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.3 release.
> There are 447 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 20 Apr 2025 11:02:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.3-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.14.3-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.14.3-rc2rv-gfc253f3d7070
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250207, GNU ld (GNU
Binutils) 2.44) #1 SMP PREEMPT_DYNAMIC Fri Apr 18 22:09:28 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
