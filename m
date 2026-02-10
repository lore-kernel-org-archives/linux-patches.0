Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B765332E126
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 20:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770753930; cv=pass; b=oOI3oOQfqHt0/hPhU5lC5ejpkapQ1HIRmy2J9AZBzk5WQUTyRIFi4Bbspt34pde+IrQFP7FvI8wGlhqCEciqx0j2eM7c5lCQUAw5HFhGTDBFQoKnaAipNnlBwb3+TPnmNqolzvRb9WFTyLj8e9MiA07IvnHmUTcbsZVw7/yqPxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770753930; c=relaxed/simple;
	bh=GM4WvX4k1hhlZ7z6g7fakRrj3LuWO11ON9bb3kfHd+Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P9N+vMHIIvP602hUuZ9En48/IL/kbsW8dNxq07z8ByKM/Bd6WMYcZmIExF/kLWrAfjbFPax6MzAiAe5HekKpUxDGTIU0V+GhPEYhdM+l9P4ErtkHlKYsgTHjgtckJ1liUQVDLfSd5n++rVv0WpAJba6mCudmaYj2CGvTzmAYKzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hDHutsFw; arc=pass smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hDHutsFw"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59de6abf324so5157845e87.3
        for <patches@lists.linux.dev>; Tue, 10 Feb 2026 12:05:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770753927; cv=none;
        d=google.com; s=arc-20240605;
        b=iVkc+Pv9TifjDzjNHumE+f6ka4BJygJ0QPGDhq5bMUS/TlCcVDEMjp7qkYbftShiDX
         VbyzJSeXNJvcrEMA8PcTXqoGpVlA8IeraXqiRjcRZ0Er6yv/gmQWvUA9QVwNkf1C7/dC
         vnO2dMFcaoIXqCyZBHsxCdyliGwYLxtSv17/kOcmn1cpF1pB6H8fmfCTrwcuwV+RWXuE
         40SLD+petGDi6Ml3QbVegda03ouzYhsar5M5NLqDsRWRxkslXUZPLOZgu2y3ODZe0BfM
         LjZYfxmdZaoQqT1u7oh8dcpXSNqFGQcZpLNiSpjCSNrep8SnCyAMjHr+1uR+BKaXfCvG
         UDvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vjAwjDJ/ezfg/0BqYaNJZsTIN6huCN0MNW7yeqUs+0Y=;
        fh=avWvsc2KlRb+3UWpgksPUsOv/G/SRmmG0EF7pGO3gW0=;
        b=QEO8si1YCqH9yfZ9fhw+fTfqH8hWpNNtRHgQqsQbhjhjS872mBqPenkCWOU6V93y3h
         PpYagHjzPYBLt7SBY3x4kSr0h1dW+tNmE2RS8XqPXCCbY8kR9R6ZuXC7CPmxXKHkKOMd
         P/Pqtnusq/annHJEy6GmoxMGkQh5E+35vLbUBSFAZf1dh3AQSQQ1AyVr0ZwS4OPJaBeY
         6503/nZIzhWXHct8wDBXbmLGt7tblsGxOp90/eyylpz/srImFMqUIupdWQifV709C0O9
         44BeYzBSyFd+HSQbwR5PrvUk9xSOQ9x6JpTko+6H4E2tQ/CK3frvvzfgZtO6k08ab5E4
         BYTQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770753927; x=1771358727; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vjAwjDJ/ezfg/0BqYaNJZsTIN6huCN0MNW7yeqUs+0Y=;
        b=hDHutsFwPkX+FoLpEGL1rbk+HY4RfCqQ475sTJ4/MQBNLwg8OFuYRdKrh3HSRC8y23
         wCjlxWMKzEpLGy5XTvJCNR+GwnlsYsgJWpegR2B9ImfVw37VLJkLn2N/NgJ0/EYMueKq
         mpDEHBqcSCbkZR6XuW7IWX5Sr492YxXbeOh8QRLhpJRcTkNiZmDeyZfuOrrTxz14l6Ai
         lsgBT0dNy5/ZDVqa64b1yTU1ynd81KPPF71XI8inyVN0+PgDYl/5tK64+9W/bO4L25Wu
         MZBAyf765j2XAZ8rksN0EdbBzCxXvqLgRRRy1cFsdXcmrrxnG4XXG0sF3c1n2b2wHnfm
         q5oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770753927; x=1771358727;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vjAwjDJ/ezfg/0BqYaNJZsTIN6huCN0MNW7yeqUs+0Y=;
        b=I3TY2B7DZSjO6Tvt5Nn5/RTk/aawL6N5Loxl0+lgw7bDEya1/ulcpHD+pnVrKUizOc
         zIBPVBVsAQ+9vyGWlft6jXhFz5AULyKP56xDC6t+zifp/F9JynSzica4O/gni4ypHdPl
         0GU6FHPgdEamWUZt+wbCABNtavYwuOAbUYg7LDmMesfV4PuN8PaFGcKWUdQKT/OjNvIp
         mH2+FEEJHVwzqQzXQM0hjCdKO/WwCWbdrYFFbMoBvvW8eSorjkB4NCRSPbOJI+N3LjJw
         o7y90vhzYcvYMUErziL2vElTGSt+dxUBPNBcFnGjMskdofhFFbIiYIKFAZyV0VyCaOaT
         hy1A==
X-Forwarded-Encrypted: i=1; AJvYcCW7aGaIXnYHe46ZFwvc+DHK37z2ve6NBlzf9p2rTN81uzR3oJLsdxrPnI7TNmjjHiKwMJU2Wbvm@lists.linux.dev
X-Gm-Message-State: AOJu0YymU+1i8mHkPyCoxQYM1j5DBN5cNFL1gV55BI3lLyg7i5K0+Mlx
	jq0Rwv6lv9C141VWIggNNJHo6YobOszmvW8x2HXdBadRf2h0Ow2j1H/SIaWz/21ZZeq5wFRUJtz
	ID+1t0Vlj1agIHlvu+K2d9ETBzH+Jyes=
X-Gm-Gg: AZuq6aIfEaXBMLmmlNUtS/mYKUQ4Bs75e//Z6EMn9SI7Dm9pof5Cy9MWbZ5WoTs3qFy
	Qi7KVb+2qJxOs4OOlfb/Or1PJSZCgRZ4vACEM0XmDEzQWpDIu7EJnFih/FzTuuf7lPnVv40yY3m
	ldFQOfG8rohWH+oMUJbHtXaMI7NH9kWEJ15lsRw7pVEadoEfFWm7CgL+vUNuEzPaUNqHsK4Tk74
	P/wRaWBW8CUOVq605DWxtnAZADNj8Hd5LMsWYh8C6kNk1xyAcDmdijvwfJ9nKACFLD2NkPS4Fgw
	KEgOa4q34cgzCPJtkY6GJSrTsNIgyoQmEy0o
X-Received: by 2002:a05:6512:4014:b0:59e:3e25:d19d with SMTP id
 2adb3069b0e04-59e55b8a76emr1172197e87.23.1770753926546; Tue, 10 Feb 2026
 12:05:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260209142320.474120190@linuxfoundation.org>
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Wed, 11 Feb 2026 01:35:14 +0530
X-Gm-Features: AZwV_Qhf2pJdbrO0mXxW3oDwJCN30EpqwylKm7th8zjy4lrr9gMnIWft0g25CLw
Message-ID: <CAC-m1rqZ14nPC7zmGo8dguHRQUf0b7CbUSN2V0ADKk7krCdgkw@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/175] 6.18.10-rc1 review
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

On Mon, Feb 9, 2026 at 7:56=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.10 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
build and boot report for Linux 6.18.10-rc1.

The kernel was built and booted successfully on both arm64 and x86_64
architectures using the defconfig. Testing was performed in virtual
environments,
and the system ran as expected.

No dmesg regressions were found during testing.

Build details:
Architectures: arm64, x86_64
Kernel version: 6.18.10
Configuration: defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit: 0aa40b8da17f82a0c1a41b57be6e920434a2a78d

Tested-by: Dileep Malepu <dileep.debian@gmail.com>
