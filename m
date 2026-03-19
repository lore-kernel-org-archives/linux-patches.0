Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AE119CC0C
	for <patches@lists.linux.dev>; Thu, 19 Mar 2026 07:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773904761; cv=pass; b=OH8c9DPp/66+Kb5njgwXsPwdGy1ivYjBK5jPokyB6Ff8gSmQ/3Om/Fi+uEhP+dqXyGqADo7grb3z6JqAnBV3rod+9y5ltOUl3LorDCKDuvnA8oAXq34ywH8zQVOlij/ZWAKLny2XrN+mWbo7GZNeMh/LDiG8heup7DE7OVz1LjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773904761; c=relaxed/simple;
	bh=Ess8UgzNaW/EIxirEyq7C8jN6f+gM036d2+Xn+xAiV4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rWoNhl+i1u5oWcT78APtFpTFQPSkDxxhTMnj/6JGI7LJGSun4t7hwqPiokmszon9ZS5uDKK9McGQd1InG+6cFKICnKUOqVf0WtDtJ9PBTZCHv6a4lNKFlNjrQ+OzaNW17f2dz8VlsW6bkiUYX0cimWOsj4/3zCFATsxeKnccLSY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=ZJAFSLrF; arc=pass smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="ZJAFSLrF"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-12732165d1eso902683c88.1
        for <patches@lists.linux.dev>; Thu, 19 Mar 2026 00:19:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773904759; cv=none;
        d=google.com; s=arc-20240605;
        b=Ez7SK22D8ENnqZWJc8bOyd6GBRrYK8LxLWXt/Xnt+sb8tgwJTMZpsrGfdgMXAW7HgL
         D/VEPec20EFj35zvaOvAPJt97HbcuLy1MFMtf0g/GQqkVOyg0B06J8KazP0wesqInSr6
         895N6OkIYrhxauHhqAYzS6nMHjjhSGWoawMO+IXhwjy7HyBZXNedM2FiQx2GCIkSWv9v
         Kim2r++n1qwk1C2f3JPdM96zK1Hs1lTWQv1W3UjuynpetoiReU1KKreLqz/yMJZhfpDf
         WTXRV1V1h3CXRzyO9UPdbS3l9JoiYrfpPG4luUIfjndwtGR43vPKvSvkIQ9lymT6paYk
         jgiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1l/IMVVtSfWuUyVYPnAu5GRDB9eD9+5LvhqvP+t2DrU=;
        fh=C/EqVxXHA+bogZCNksOCPB7rNWiQj5GSxuwoDF5dpc4=;
        b=DSPfKqFD7sESmf6H61oNCkN3OZOVRtSN8Mh991xeALFxeC3DmWmifylCSOO7nnuo0j
         /uOOfOwmTB5K3jq6oP35XbCJ2w+8IEGNN3SfJTiOikPJFzC5c4kOrdZIy9v1WbEmKCgg
         VTFQqprZ73t0Ftpf1fPI5AQP8JQLBu7NOf10Qa72DVp078KNYLa1jqKJetU5DIndmVRp
         2hiyDSwt6dzAfTdtc7rn/zzqJ1+z90wYy6qCHoY2eDF3I+lTw2S5nSOXnGA8DlFZWbj6
         VhVtsKVTtIB/n64NygFxGxuLuxkLI8JOwYIjKzg1WVN65s3/+JuRaN9a4jvusiB1k2lq
         wk/g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1773904759; x=1774509559; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1l/IMVVtSfWuUyVYPnAu5GRDB9eD9+5LvhqvP+t2DrU=;
        b=ZJAFSLrF4LbuaghFLFyqIg/HRk5ydkOfU+WK5N0TjnH93+Lwn7OMZAoOxMN9CEVIwU
         MqbA1IZx4WKxtmXgWN05p1fDgZeZKVN+m19RhBStocZtQkh4VboYu6zCG88Kn9yRUccL
         uPPuvSA32yfUnYDkSMBKsI6RXs0gdRmiJttCYliiy8/IhIdJQfYypXAxzP8ylw9xBWSl
         DWSUfCl7GQOgjKH9tRQ3YlMfbnQx8kiI/uXEgn9/y0WMOjFM/Srk8eL4D7Uhty4AGmWT
         xE+ckU1GDCoIfS0Cu2aEaPakrY3T+A05rZhzxPuqDFqE++0hG4vz0YDKSGA76mces6uu
         bQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773904759; x=1774509559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1l/IMVVtSfWuUyVYPnAu5GRDB9eD9+5LvhqvP+t2DrU=;
        b=g4emjes+YaUtEc/hZFD0fVxXC05j+FGjfZ5QaiUfLmR4bru8DQ6rghGN2Xsc45e47m
         r8QjmuWZRBvfjqjr5uTnEEuZUTesfc4pohTm2Ivsb5DX+BALdoZbyXXGYRrB2WdeUElQ
         pidXICy8C4zHbsMUg5NdkAhKhtfWp82L6hPeC9pZsXYwSVliP6ZqUd0CDmvZ2KeV/TOX
         WaJUhp1Eqn6Wd0L8uXNj0a9RQ18Cn7ggjg5ibMqpnMrDdCNA6eOzCB7w/nqtejaak22R
         MN3i5tDxamJdpJ9Un1fVWxYu1Zo3SSCe29JmqxupLvAOfJPkQKQW7190/Gwi/GqkXona
         ae0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXHVjCD6o8F9JU9Tvq0bb0Sv6bx7x4HkQIWuj7l7dmBplS1/3T+Rilk5HbdpdqXBev51eklZQiJ@lists.linux.dev
X-Gm-Message-State: AOJu0Yyg+DBbwaQQIRf/Ax82I/tubKY9VdmCCQUne5wl+2JIGVuPCaUO
	OGy/v282VSs2Kxm+rbpW6HMfY8PYS3p/b84n3/zlHVKaVFW9cQxwfMWIhvXz0C2/bs4qe3TfPHn
	zLhHkfHJwmUuIJEtw+6hdCuQ/qLbQssMlX7U/V0DPTw==
X-Gm-Gg: ATEYQzxzYrwTnKxcLfifSJ7v09PSyHoR5Nonk5ezPKvJmiUz5XW0LpVlWSZiYpsy7lx
	f/828S6Ta4AQIP0rHar808Dqn7dVZTMELnSOJHzl6ODvsf/nIn6nMxuz8jQItWoI34lKsp4l+RZ
	EPOOBSyTZ+/sgr01lbdisFCfoV4RVg9JOz4JCrsazcWpKJHqYq4a3fY3PXP0viUvkFXNzGMJA0s
	9+b+SoWkZ7PGHp6H6ijng+23/FrkNyn3ltJzD6Pcd+t7H9D/jC3AzrIUgh9X6JrJXnIjW1EHWm7
	H3L4jNnW
X-Received: by 2002:a05:7022:4387:b0:119:e56b:98b1 with SMTP id
 a92af1059eb24-129a710b318mr3124030c88.24.1773904759139; Thu, 19 Mar 2026
 00:19:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260318122547.233850204@linuxfoundation.org>
In-Reply-To: <20260318122547.233850204@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 19 Mar 2026 16:19:02 +0900
X-Gm-Features: AaiRm538NfcS2nSWnnd6YoZ0SN9yUH9Nu9tWCxpdQAUJqOjdqqRIGvM2oxef_xE
Message-ID: <CAKL4bV4hCfaHMUuU1xx_=3fkOAS8Y-6wtZHY7Prgi096SLoqcw@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/379] 6.19.9-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, Mar 18, 2026 at 9:30=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.9 release.
> There are 379 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 20 Mar 2026 12:24:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.9-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.19.9-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.19.9-rc2rv-g08e4691d3bc0
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260209, GNU ld (GNU
Binutils) 2.46) #1 SMP PREEMPT_DYNAMIC Thu Mar 19 15:47:54 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
