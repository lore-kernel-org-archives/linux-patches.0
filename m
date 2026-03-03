Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A523D6480
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 14:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772547338; cv=pass; b=lPDrNgmizNf/Rhnes8DCQOOBQl+nNZ0EHE+y8u8ZhyoMf6mH2VCD1IIvu1uQ0THApFVQmXNdQ2buIpkcvTVo2WSJYwvw6z/C/oyh4TtShPNwXjC++EWXtGN8f1bQZPItkhfy8tdznTSp2xLmmoA6vHygLGh0Dxjxf15Gk+XaeOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772547338; c=relaxed/simple;
	bh=wWJbpY/42fHgMyOjdlR2gjXY5cxvMff7kY1YRZ1JHWI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kd3hv3RlWdwLVhsWIkeEpTsK2TJLh+XTzBxnHBgvc7cyBmPzQokBK7LcThAhc+0i+tpIG0z43NVQJqi2XnutOzFgF61tcCDldxswFKXPOKPDARuJ8oTkH4vryfeyFamwwWgnyHgVXM244Ct6nzvfYSGXgdmAuBu1l6AJUNQgqpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=kvn7tsW+; arc=pass smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="kvn7tsW+"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8c6f21c2d81so549572585a.2
        for <patches@lists.linux.dev>; Tue, 03 Mar 2026 06:15:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772547336; cv=none;
        d=google.com; s=arc-20240605;
        b=dgMEUUFyZe284oz/MCHRG9+w1PM4dKnkDEXcYyRY9J+x1bQdHOJ73B51+S9xXGj5MP
         hVBEyNNssFQdjri38Z1qigy8CjK1pB8/aH7r71ohskyyrGuuMZuR+fGU0QPvSJSCAkmH
         D1Xan15DkXerxAWR8oDDbAGeKOuWI5YovEVFDN1bzWLYukphtzxxmEBejm2Mc15TVdN/
         9bL3t8fXDcS4v9juW3/3ao1a5yJRpyVTZPPLRz35ubdnvm9CIEitGPA9vJvt3rY9d7at
         nRrHkHVM995tnalVax76UjrQ1KpIT0+UE/D0CkV98fK6taUxNZKftJjaeU07DUCjfwhQ
         3alg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M67oupMhXrY0+DWlqzwxQF9Ii8HtL6+92EQ63WLDIvc=;
        fh=9S8i2Mp8CMj4GKW90QUmRCjOoAI5piS7+cEaywAE09w=;
        b=fvdzpJ8GbbxWOeKWQjoDoCEdPIX4LskvWy4sUnweZAxUc3+plM53cbHdZf6GJn5mBI
         VMMRlFx+0dWQYwOguBmmrxlJCJR4iQBavEW5N9HSt4glDq70fyTYqfjCbhIMdeYGp6DY
         ujNAAnnXkEgJMG0xCfth8wmqjNTzTA9lLlIqeZw4FlY/jtoqJxZrfpPvzF0QMDhoa3C6
         btm/fknENODK+1UpdPDqYXMDkXjgi4LXMNaP1M8r7VqxioD3BKXwzRflPodvLFH5llR2
         6TX7s3GAhUsPnMxeYEdSmJnrvubrbto8TC7fHdULDQw7uGSLu7gpah8pK3rsXSgwODgl
         EGOw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1772547336; x=1773152136; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M67oupMhXrY0+DWlqzwxQF9Ii8HtL6+92EQ63WLDIvc=;
        b=kvn7tsW+rQk1roJKxlLxlh9++2fyYHa6ouuXgMb6lOes5qJuWzQAYrXyKqrxR+jPCr
         WCXznipQP9W8tZ3/PgQ+oX7SJ0CpHop3/iUz14zVnl5GB7/sI+lPonXgc6oRsHyBuZkt
         xGzVURyBi2fZwO1c2UFdFSSCTeh/pK88h2Ne4NDfO+JYBy7aX/dJ1qF3zyBh6LqMX6uJ
         Y9S6JoissOn6wN1BGH9omFkzxCOPq+iNLG3TpEkow6pEn0rxGMOw8u6wjeDAH3vNyGun
         UJ88YnbeLiOlG2hmOhtkgoj5M75N9F6RHu7i4t8Qa9+ZaUeE1nXg6ZR3HVBzvj/dx7Pv
         +RCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772547336; x=1773152136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M67oupMhXrY0+DWlqzwxQF9Ii8HtL6+92EQ63WLDIvc=;
        b=P0Kj1YyT3Hco9/IttvxEViMNOKAHN7rMTP34FI1iaOYyk/6G6k4x3JGBUy0AU9Hw5s
         HcmV68ipQDmVhMwQ6IavjK+elZozaiPvqdtyYfehbOPQ/eRNeZpSyYYoDEhJD7Ujxwfj
         A/SLkoANoYGW1FhuRCQ/JuFEcdmH0GVL2++EZ5e6gAowFGF75UWHI5XgSpHQOiocMYPL
         MnQPkVENcrz+xKFizm9EWHmQqMFqb2OVe/Z632nVMONojQGoBEuy1ewEWlzAWLwgWvny
         28mLjpXM0/kmCZ6znsEj2DBAMg4RoMJ9ZPQ9nNc2SJSlng6PY2TrqWT90h1ndsWbOVbq
         fhDg==
X-Forwarded-Encrypted: i=1; AJvYcCVvYuIuTvBU4xrDu9JXnaOnkUI/k/Z3QBgCBwdIN+TUAjO55DDQ/icV8UB5agRcjXrQqTMeZZGY@lists.linux.dev
X-Gm-Message-State: AOJu0YzQxzRHx06iSbq5+710Xty/jNxLpgtLkZZDzqLBzb+r8wIWIRk/
	XsLlMxuglY0K/SFxu1tqQT74fCnESv7vQdt7iECLRiEZHu7I/h5tZg6IUTnH/RA7H/9DNOdXwIv
	C0v8So53ymcf0iwFg2gLAkAElVbpc1TekaWBS8y+EhQ==
X-Gm-Gg: ATEYQzx7+GZtpmqkJj8f3OiFDxgNd1hAYfPNzFm0SCz5NyKW7Q1kWksX/ZJ1pCIKcNU
	sl0Fku7KBHHxAps8st6VieR6YdVJch0sojSMxZGWbgaFmgcp3fnTWXQlzIE7b4mDo4YS/uBGg4U
	m6ChI2iWe9jyGRwl3c1kVm2P2IgsyP/3qjwi1rfA20DgI3YWgvnB3jyF8UQoln3QluoSvmwPLNJ
	iUhjNlaoXIgHUq1f7zflKlVLI5lX5mEti7bhVtCYWn6S+eRXrhuLOymDMm9f3egWNkDkvnZXcYv
	N7XPapn9QqEM2/sSt5I=
X-Received: by 2002:a05:620a:4509:b0:8c5:338b:bfa0 with SMTP id
 af79cd13be357-8cbc8e7dc6dmr2032573685a.20.1772547336078; Tue, 03 Mar 2026
 06:15:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260302160918.2520730-1-sashal@kernel.org>
In-Reply-To: <20260302160918.2520730-1-sashal@kernel.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Tue, 3 Mar 2026 09:15:24 -0500
X-Gm-Features: AaiRm53-OaYjRfWbC9pMghHZGosU3gXJ2IxK_UISbdkSNGhbNsynY5rfwvgLYP4
Message-ID: <CAOBMUvjE=nLRuRiD6gt_oFvC0gd6zqGK96kT+PoL8x-r9xAF1g@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/956] 6.12.75-rc2 review
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	gregkh@linuxfoundation.org, patches@lists.linux.dev, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 2, 2026 at 11:27=E2=80=AFAM Sasha Levin <sashal@kernel.org> wro=
te:
>
>
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 956 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Mar  4 04:09:04 PM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/patch/?id=3Dlinux-6.12.y&id2=3Dv6.12.74
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha
>

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
