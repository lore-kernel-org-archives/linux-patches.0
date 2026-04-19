Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83326223339
	for <patches@lists.linux.dev>; Sun, 19 Apr 2026 20:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776629109; cv=none; b=PxH+qKdjgmuxt/Sto++HL2gskcVoQbRTooXZxuAoO44BgL7AsmjFcn7aagOQl6d4TNjf2wrDe9UeUzHVTJw7nENjgr2Kzi1q9uDKZMZX83dYJnzVO9YxXStmfd0tXoB6XKM3y+2JwFrPb6rlU7Lh5xbQ4NUvhd4mpSHGtyXaa28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776629109; c=relaxed/simple;
	bh=HaEcoPFFJSsso0nYJs1rCaYbcTkCVAnWij1EmPFe39c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S95lokaNnt6o0s+LNkQWVzIEiG4579XtvXPpr1NW8DagzEzOIQNKIpw/Z/Ms06rIp0ndN7hZvo/H/YdOLF0pGwcEI+Z7J7HzK99LelLzuNDpfRs6F9f44oMLe1ihk8QigeQbLx41KDRQTMYwgcR4RJGcD/dSGbojbr0EhQAGnTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bv8QeHNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bv8QeHNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20520C2BCB8
	for <patches@lists.linux.dev>; Sun, 19 Apr 2026 20:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776629109;
	bh=HaEcoPFFJSsso0nYJs1rCaYbcTkCVAnWij1EmPFe39c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Bv8QeHNPR1lyefx454Wnu1aOCVW+FObcN7t7/RrYpU9fjyWcNt2+pzSTJaq2Ws8CC
	 X+4Znt5+R0opBNUAsoRM3Gpc4QeHQsJyb2yCsQjbw9fGYAAPEe9Mvb/fxT2CIGIcEX
	 4BzUVjxnxUeuhTb9saAX3q1r5p5YzxpPrm1ZX405ym2J0Nr6i6sQYY6xt6rBelB3eX
	 ijjn/QnGey9rZXV0Q4jsANz1Nnr5Wv7WsURSsSJfkwznehCcBMcJkwGpHBcS4pg/O/
	 F64qcsMAMe5n3IstN3F/8eHbfiVuT/cyJC+nj2eg1OKJQ7wjRpuVa3Ag6G7pcE8COw
	 CvvPWVg3UWb0g==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5a283c44478so4002564e87.3
        for <patches@lists.linux.dev>; Sun, 19 Apr 2026 13:05:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9EgDCZTnLRYX4TtJoHaoU1dgmQQwIvC1Te/FyJlgp+7bTBka2YM9xHWXQR4JfN8R/Dm8fZlDUC@lists.linux.dev
X-Gm-Message-State: AOJu0YzqR7q2Frz04/1RklGh/7cphViAufF8f18hVUIBAVcz8xqIOOJM
	201D/zq5XpynNOzn4myKdbOrUeMMlJSYp07vlqNB3kqJjXmmhLgl+CmKXpE2zX2MBUrzfTNQ0ag
	rdeGwQtUIUpsPm6syPuI5wNWryYEPBCw=
X-Received: by 2002:a05:6512:3981:b0:5a2:c4f1:2635 with SMTP id
 2adb3069b0e04-5a4172e307amr3088773e87.41.1776629107806; Sun, 19 Apr 2026
 13:05:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260413155724.820472494@linuxfoundation.org> <8bb67921-d8e7-4535-bbec-249e9702ce62@roeck-us.net>
In-Reply-To: <8bb67921-d8e7-4535-bbec-249e9702ce62@roeck-us.net>
From: Linus Walleij <linusw@kernel.org>
Date: Sun, 19 Apr 2026 22:04:53 +0200
X-Gmail-Original-Message-ID: <CAD++jL=PEFV_wYtiBixSLixvk3w0xeSOaSrjNtPFEC9fdd5s2A@mail.gmail.com>
X-Gm-Features: AQROBzCr20naR9jzOpPgtjd3MIvca2modC6ZBLfglVDKvGbe1Zgju9vQ6UXQ4fs
Message-ID: <CAD++jL=PEFV_wYtiBixSLixvk3w0xeSOaSrjNtPFEC9fdd5s2A@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/55] 6.1.169-rc1 review
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com, 
	Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 19, 2026 at 4:31=E2=80=AFPM Guenter Roeck <linux@roeck-us.net> =
wrote:

> Looking through my test logs, I find that the following build error has b=
een
> reported since  v6.1.166.

Ugh not good, but no disaster, OpenWrt is the only downstream using stable
and it only used v6.12 and v6.18.

> I have copied the patch authors for advice.

I'd just pull them both out again. It's fixing a runtime crash that appear
only when you use ethtool. Annoying, but fringe system and not appearing
in normal use.

Yours,
Linus Walleij
