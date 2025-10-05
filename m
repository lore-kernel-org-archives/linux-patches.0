Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C61241C72
	for <patches@lists.linux.dev>; Sun,  5 Oct 2025 14:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759675049; cv=none; b=dTdOdT6xbav4fV/Uap3GKvoOgkNHxkSHQYFfo+L8znpXlYQSmiwzynp6WO1XPZFYAgxd/Iy1NUyztvXg2SWNtq74uPQ+fOlTEl8fQzjrwkTe3ksbUwwHL+T2F5NLWFapw3slydEHx+n+IbUUl3+htRV61xbjSBbaRtNN5Gslxks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759675049; c=relaxed/simple;
	bh=68Hs1m2KCNgUTWFrubMbAjOMlruERL80FpRXR3jtVUY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H9+CRXbPjtfbhumwYmoW0jt8RVBN+o08B8rffqLDCsOtKNBjHMRx1/mcFiRvg0MTKvV1SAf4cTk7Cxw3XOx8bCLPXqhoxqZPvsMZCSSMi0mP3puH33Lq6LcuNndrXNdo19R889eHAIYXxh8zohnjAOMcW5wz0kdFAcVzb7Or8ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=xSEa6V9Q; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="xSEa6V9Q"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3324523dfb2so3449724a91.0
        for <patches@lists.linux.dev>; Sun, 05 Oct 2025 07:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1759675047; x=1760279847; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nqeLcDuce/fJEO6dWcvk7aWGQEF9pvPJT1tdDWjmEQM=;
        b=xSEa6V9Q7G5sVimA/fIFgPOQFlVGeYfjYepi+mxfBRGxNFh8hgEEu8txrZs3WLmRCW
         yeSeK4CLveKq/UMDCP7L/QSidFlSe5RUt6bGnzQFTpqLfU3I3q+oNcAt09PqbFWj6ZIX
         WRsx67reSLMBBfxemZgjIPBW0jH9G6LNrkLyt+bQsyiV2opnttvULrm3bQUznH/5tvpm
         PhHmUrxMb9K4BieM+pfY/IWxJ3qaJZVBGz3yyuHyPRuuORCkcc5lUzFzJZ8+Ly/dmgDX
         VT17uThY0L1NIFuveKq0A8laQwsi9WcVfy0cQRFqGJe1SIpWXgm7N357wLFNSU4SGCEW
         ikzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759675047; x=1760279847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nqeLcDuce/fJEO6dWcvk7aWGQEF9pvPJT1tdDWjmEQM=;
        b=J2rUAJB4TJdwyHYZNlfJ7cILlZ9LZ2igITrChDIbVRl+rLz7HmxFsaFjiAAXJQOd4H
         441Pw8T5eULphetiwWDa6k3ZNXcS73OQAzF9zYPZVWN2BCmpLkUgK16RmQ2PeGiaop3L
         7cJ3eDJVgE6QYFD7dhxQE0ydW1bQl2qihR7FrrZwXKQOYgcbDFb0jPS/4jY1VLa2KzzO
         3MICmAHer3pgAn0AAU5glBi4IEIv8ehMce5noCj/qc3b31Jg7ThWesXGKfTEBe+vmp33
         C5NtGyb3nUx4RY5y6yvj6EuN9WMbTX24Ju1xUotqtm6uvMVBVPl58+3sUbXzPw9p+b8p
         pOMw==
X-Forwarded-Encrypted: i=1; AJvYcCWQ6IhcC10PEN/EU643/JQnwvFc/wdY+JTIXJjAgUODI75dAyqoSNjbjuGmBCqrtpkNXYET+2AT@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+CnsbLyxnS9JPACwu/VzlS+ri2pjOE85KDm0IpULUUVUEeocK
	UbSbZciMe3sSFdZ4oPNZ/jgj5tMdr5ljmQ3LH8ZyfQ9ZXkxl5xBvxNnU2QKDRpI79B5qTLtvoiN
	7yGfNCZZSPX6iJ+78MyZ+P2XDGcGSH+RXiVDnt1nxeg==
X-Gm-Gg: ASbGncsy4SBt4WD5cZYGzEb9QHmAEzdtYvwIrdUeXX2f73bXrLKQQQswHWrOuD0Ik9C
	5rtuv4mDkamQP82tnnyejfI2/iQ84tuQKLrCz2TQnPJWonYmGQDqd55wC1Qs7rYxummP5w67cIC
	Tweho3Yp9hlKbYFw98Grl8P8Q3CGCAZWkky/i67/nJL2rVCV5ayaJ27hfurAapMYGgzC0L48lTX
	wSuhMLnIwEkoq9Nt3oPo03JX6BrD6/waONZnnPszA==
X-Google-Smtp-Source: AGHT+IF2SH2TFu3dkLS6uR8T8yDPp0+s2BJIdcXwXmq/VC0MdS0nzpDNEz9+ew3L3311RjuGHEf4dr7QtIGIj6GFOYw=
X-Received: by 2002:a17:903:3504:b0:24a:fab6:d15a with SMTP id
 d9443c01a7336-28e9a5665f8mr106992295ad.20.1759675047357; Sun, 05 Oct 2025
 07:37:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251003160359.831046052@linuxfoundation.org>
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sun, 5 Oct 2025 23:37:11 +0900
X-Gm-Features: AS18NWBfJZ5Th1MJIXFkn-PdqzYH5JpHlnaEZ3ST9sWDu2YJAX0wQLCac07MmBY
Message-ID: <CAKL4bV6Gw4KL0=bnh3hWk1bwQ2txSAViM=k+BKZa=FT4opoXGw@mail.gmail.com>
Subject: Re: [PATCH 6.17 00/15] 6.17.1-rc1 review
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

Hi Greg

On Sat, Oct 4, 2025 at 1:07=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.1 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.17.1-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.17.1-rc1rv-ge7da5b86b53d
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20250813, GNU ld (GNU
Binutils) 2.45.0) #1 SMP PREEMPT_DYNAMIC Sun Oct  5 22:53:48 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
