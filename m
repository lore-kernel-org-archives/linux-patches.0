Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E203793BF
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 06:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769669686; cv=pass; b=Ts3kfKUouHSnxt9N+y2dV5mtdDncT21fFWT8E1iEBasRQbT7FvhBM8u1CdA7GpMA5L1kQtGBS/471waKwr5UXb0W7g3UR72eWPmTHhTBMGDeJWUShORiHhUlm363tSAndJY0qHATxlZdM4mFGZr99OLXPBDBCBYFYLGOR6/FdIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769669686; c=relaxed/simple;
	bh=XDNu5SJ7NlxJ/w3kwjRLCAZTv+l7SQBkMa4RqVUjAEc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LY6tgxCKJe1XjGb1ySvdzTsVMOEvDW+n18VNEIvU60dkWkg6mIHWlduhx1fwgz6NdK4HmGXRzuG9exxiiBRXCHzxAWtpS60ibxLwGDaDIJvwVBE4k8eqg/ymfghEG3TcZeczdRE0tbmvb6PXIi7m9lJ/tQZVVPQnLGvuxp5bWwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=NJ79W7EU; arc=pass smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="NJ79W7EU"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b883c8dfb00so145982466b.1
        for <patches@lists.linux.dev>; Wed, 28 Jan 2026 22:54:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769669683; cv=none;
        d=google.com; s=arc-20240605;
        b=kwL5CmK5bjSAyI/PU9uom2a1hVGjpAhu7XpqSTSynikADa5kLYTnNCjivqSXCJBDYp
         gwXvyBdBeiS2UPN3yuuu54Bi6m+ga578v/AFB7KSDoM98I2rVwcNQ6ZqF614L98Fp0fM
         UWaLlFcx5BYYjNdHtDxWJAEklYzcKx0g2GDhb5AbZgpz/kiTPkk5WjVTFDFyaRQnPXW1
         A6M0zSuTOrHNNsNKXmyEvwIUsIg6Vcd56nI6/ctw4Ojy2RNJ+XipA+ghC/DHsqA22xeI
         1uNR03fwz2dFY2/hGErV+YX8M55eYztcjisVCHEP/o+wlWppIqk116vy+wVtIU7gjep1
         D7Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=01bbw/wzbRiBXVf7AycG37TcaFvtUpv7cQrw54iOmM0=;
        fh=ZB3InLL04ap2IWFilO4TYvt7OMhrL6N6B1r4LoLGre0=;
        b=Khkr41FETlXK3nlmKeeWdEJvYVyl3QqGEq8oBkXyY6D8l2rejTnoj3VfpOmNqR6Xvq
         JhaE539Mcitiiempeyq6kYojy+EyEu6o1NLv5rGXnEonj1XoLSCQkuxMUO6089EZ2Tge
         MVPvwc6bRS88rn+uSr0nh6le2uQorLFcpd7NlaBcy81TRuT1lFUhy02Eo+ICvRSPQpqF
         DY+PDkX8rFUI2P9gQh2ZNW9odPtcxWmb9P1tzOWsVndDh0Vt68Jb1Yniu7xAZEfXxt3K
         Mr1C78gThIWRnMTn6ual1ZAS5rINpJThOMhGmuRODY/xLmTMuIZBbJrmBx6mkZgAhCyb
         8ERg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1769669683; x=1770274483; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=01bbw/wzbRiBXVf7AycG37TcaFvtUpv7cQrw54iOmM0=;
        b=NJ79W7EUtPkMAGfTUVy8nEAhPyz0Xx0YyVAA3S9Fwz6muQjay9wF24eQKY2wieFLqi
         dMQYslEUCgqogl20SzaDAHh+6TMvxWPdzUdz9lTW14SUCjbjP5+AQ4/h3PPeWm5wY4ib
         gXOHdhSoHb3L/DucAGUGMZY1yIR4JnjU7sbB7+mNhFDdyUVe/u6/qgFiOJdjeTS3qecU
         xHczPDtigVQIgcZ/LutPoA+C/s28b8RuWf38H0hb2fZxats4pSKTNBXKDMcgX/sqLcRH
         cAQr0nYc7eoDrq2yUOfVnj9eUpx5IE69OiyCf0SnPKw2ZPVoJWxl4LWkCVuROFnUEr6q
         8srA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769669683; x=1770274483;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=01bbw/wzbRiBXVf7AycG37TcaFvtUpv7cQrw54iOmM0=;
        b=Fad3hpYF3oTP2/N07mJzLFFi9ik2j5Au9//hWBzii5eSK2zIHpxbe8awBNYGc9UYvv
         2W3R4KUSWcGuRLIwS0lz1LbawATuBPqerm3w8jfo+Fexov0w4V2qz/Q4xtNr4TZlxzLT
         sb/sOzreNeSGIUKoMQplHVloOK8qFbI4M/EOdyvrvO+EK4YZvxrO2M+OJ96e2oji9lfs
         ycthO1javrhw4n/tQulHlAzOzx6bcFQD/+MAU+4O+KLp2hFVBhoj7CcUpEsod84QQQcU
         yGwKMSFhK4ImmUeV9y5pi5FJN0karO29Ljtba982TdS1/1FthM5u2HUIi6iD/Lf5hayA
         ITtg==
X-Forwarded-Encrypted: i=1; AJvYcCWbWY/LEGzu9GGk2ahSlGo/oVFW3XCVVVgPQ4+1zDwvMS22hhVd7pdoHxNgynjYFyIcWoQDGvux@lists.linux.dev
X-Gm-Message-State: AOJu0YzLVD43mIVa1pY/yKmCvudZl0l1lMR6Q9TR2orK/X7g5BkzLuVe
	eeLDVBtIAXr457jTUJHt0poU6ERt4wiG97GFvs+T/eo3iiWc2JdKDjpoHeLcpnIjhilyNqP0bMo
	BOCN7OHGpgxmTK8cbuZlQXm15kUQ7aQ+PtNc0fWqO5/5c/6UB7v3YQbhd6VRh+fbVa8oRimDema
	pSj7SCjzUv0RrcZdNmML3/+GAW3XS3
X-Gm-Gg: AZuq6aIF0UWrqfaqa3ajk4NUKJ/If4G0Z/RXTPGBpy5m/0qvPq0v5HX3ckgLno5uZO3
	iGiajOVv1NYk8jodbzG7pqG0MtPQBGNRusrKai1M+ZvPgcnOrz2+JrOVnxUlGnuFFHx6rSKc7zo
	Jq7uNjZ4pbTnLyxNDENIJSMHkwlDJrixck2lBPFhks1OG7WDtdjJVOA7GEiPFMMyJV5SnWa6jDe
	FGzlBj4jsbZshkZxB5FlKxYbtUCDnw5fgGEcYkhRd09FYyajuDAY4wKJRMVxSRQZPn/1oeuR1KP
	JvWmVKagL3nn4iDvP8XZPRVJYkQ=
X-Received: by 2002:a17:907:c22:b0:b87:6d6b:1366 with SMTP id
 a640c23a62f3a-b8dab33093dmr550624466b.41.1769669682055; Wed, 28 Jan 2026
 22:54:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260128145344.698118637@linuxfoundation.org>
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
From: Slade Watkins <sr@sladewatkins.com>
Date: Thu, 29 Jan 2026 01:54:30 -0500
X-Gm-Features: AZwV_QhMwQVgQ5G6i9WzR7U8oXW_gCCL5BwmoR-L73Bq9ZYhkj7dXgbA3qhtoIM
Message-ID: <CAMC4fzJ-3WDwOgi-PjYUdnqECE2up5ihzJrCgVYy_NuLUVsSBg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/254] 6.6.122-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-SW-RGPM-AntispamServ: glowwhale.rogueportmedia.com
X-SW-RGPM-AntispamVer: Reporting (SpamAssassin 4.0.2-sladew)

On Wed, Jan 28, 2026 at 10:28=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.122 release.
> There are 254 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.

6.6.122-rc1 built and run on my x86_64 test system (AMD Ryzen 9 9900X,
System76 thelio-mira-r4-n3). No errors or regressions.

Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade
