Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DF7342534
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 04:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768537399; cv=pass; b=qiwUZioDxy7D8s7skCCyP7ax+YEpMxZB+phD/DSqxo6yGiXBXy93trpgagZ/CZBSVjWZBsT/zIPf5Wf8Yeg1uJSDhwhvlKokf9N1kJGi5avID71fz6gblDAFUmC1RxZoYwJU66LdRU0SeWw2uJJLkGRqtBAKFa8rE19yq/+7nZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768537399; c=relaxed/simple;
	bh=oIc/W0gXzZh1uzQpfxKweLLIwk6rO7k6iG8RXQYPZ1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jEb9wBeNtKhdFHEe8aR6RKYEzBiuaEu6SNGhuGriyLESV+4YxMAATaRYVpsFijqZ/qv52llg76qiBvpKbekOz3rHYECCP2BqOMxvuj+Su71PauFCXoyqEYDYHyKWDNKtJcytjjDd7LyMpunO3XPPzssHp70sKapXIjuwwTeJLic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=fDLsExN7; arc=pass smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="fDLsExN7"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1233702afd3so2078671c88.0
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 20:23:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768537397; cv=none;
        d=google.com; s=arc-20240605;
        b=hFi6tBP69RBQaHGqoPcpGrT/s0T1teuhXuuhjg1HdlR2lJkalXpf3pjcGMl8yN47Fb
         qWPya76n5sNiPuCvcIV5lB5Zj7lNt2eS0gqVMCdeLvdk8lvtXv5g+9BZSchS4/ySpWUy
         Jf6JDhKZE/kyyyY2MUKHws71Htjjf92lDF1l8rbGOIbKmUF1Ny0e/wNFsia6re/gCtHp
         wzwAmYGfqZ6IqtOpGJIRFGz3xeg6FmlwSm5iWDGOblkucO85fva/eh0cYNBWvMjZ0Gnv
         lPyAlB9c0OyQJe8afSL45Syf3koVYDm7+SFivfuIf7VJO7qKUL1fbHyYXCwobAvKuITE
         WMhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mh9FhGoq8sm6eyeYNTJAWc8S8MpG3hZZAO2jpyOlG4k=;
        fh=W1sSd0MJUyezzx19Ni15ZoyU3nlYApajpoS4O617jTc=;
        b=Q0NfJjj8LJlbVx9v1vEeZgHUbq7gGUuC9eZgPau3n+Ly1sEq8NL+QuqZaJ2bMzEjst
         Y8dPfq0I1TpbmmitvqmDM1AIX0AuUGnhWrwSwXaCIQ5iUaJ/9Zzh9H5SdMcA9l6IgRhU
         5ORlrCbQi2iHR6In7+dE1fnljee5QT9B1Gg9BLUtrz+u2vk7M3oLo+UaWq0pqdofosGL
         elph6DFs4wzk26E9lMD+eYTXqsZmtpWwmGcgvlDbGQYkD68jnjFTiLF3WwIDK7vknmEC
         r+rp5R+w41uTxNJW3LCiRjA/aNeiSqbnNytiS8yCCiEElBMyKLkgf+/P2ZDhWKpH7ze5
         hDLQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1768537397; x=1769142197; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mh9FhGoq8sm6eyeYNTJAWc8S8MpG3hZZAO2jpyOlG4k=;
        b=fDLsExN7wR/PaMrD8Z4LzPAMSx1EleoEvhPzJK2BtJMT2z0KUaT187lJydxo6weJ+5
         sQtWUmmX38a8tE/x0GBw9zDuha7zo83cH8YH6mbarDGvxSt6TvTIhd/wLgU+HTo/qZqv
         YjKrjih9SBzIoNbbUMGXSWZreCdJ8CZN6p8QuJtXweDmT+3CtcvscZqMACPkEPnJ+EfK
         YDoKXGGwQg2wlau5mjWRMoTcQGVWcAW3dafTiOVICxswVaTpWk6ElEYQB7Uaq9fqGnjw
         m5N2BPEsv3MgkvS/WeBcvpmCbj/lsSVXAcVFt7TkzInvDzHBXe50BAwRM+jssVbPDQ8c
         q+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768537397; x=1769142197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mh9FhGoq8sm6eyeYNTJAWc8S8MpG3hZZAO2jpyOlG4k=;
        b=CTgUmb6ekN+tN5/Yp3ecEaBZc5ZBt2tdVBlNpmCkfPIYGetaCqeH2Ckl2PjZ7Cgl2X
         bWe1vWFgbTNgNleMl5GkzH3vCItvZ76Xyai5x4yoY4tpjO9RpWx0D6NgcgV2w41VcWHF
         dPiJXt0KSvc76TRN/yihNW1x24/UhVb+2bpgT7REKD0SVMXkJjVy9WDr63J42T5WF0bC
         rHpr9SnvZYJZN16MLmtXrGSpuvk40ckI5M8XHuBRS9QFoLHthVCAFYLA0c4xbDI08LIQ
         AekkgQd7HEGwR1t4ppBCOzh46rxyjgKoVMUu71EX1kgiApjYWvJZlG4u+njQXiMsivRs
         Scbg==
X-Forwarded-Encrypted: i=1; AJvYcCV/jyjyl/z54u51laRFyxRMTh8Dsss1SEdqqQSPTybpTyHLkooYRE3brSIgNtemXMJnS6brq9N1@lists.linux.dev
X-Gm-Message-State: AOJu0YzBGFOb+EkrhZp3HLJDUfEPPXasEIvJFpvY5jzHyDYbD6RNSp3Y
	18Oo8EApN6pMgYq1M0dxx6EfW0BtfqUUdlliV+WbPsJ6PIaoQ8Bq4SYbhZo9Bnyxlk4J3WL2Ljm
	jLfrMaV1GefYnQdXIhJxJtjHz/xWSk5dxaygUowrW/Q==
X-Gm-Gg: AY/fxX5rXX2n3v2onBXiIoJGc0SMpq9J8p1S6VFB8dYzlckAATdcHlre0MF636LSBL7
	HKrtn99LT39hCTZ+zUGdkdOCzicMEL7w1rtEN9ksguIWqw3kluXSYB0r+dERVjngPGoC+NGXTRv
	/s5SlGxzIV8fYRSBew5UqkcsWV0RAohtvu6FNNNKRDdIqmEVR9rTnM9Fq+G4gbuY5e/WolVYmmj
	GYf3hR6m6QrlYUL2x1DtEd6fH64rwgAANI47fMGdP3utJaTvOQAUA2V/stRE3IrC/qFc9y4
X-Received: by 2002:a05:7022:2490:b0:11b:9e5e:1a66 with SMTP id
 a92af1059eb24-1244a72e86fmr1741303c88.14.1768537396781; Thu, 15 Jan 2026
 20:23:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115164202.305475649@linuxfoundation.org>
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 16 Jan 2026 13:23:00 +0900
X-Gm-Features: AZwV_QhAOt5D8K4FCRVQ3uE5njNkZ01Tql0uDAMEtJD12DsjTp_Gz93cS0619uI
Message-ID: <CAKL4bV6i5fAq5Tf9VJ1Yv_X_jj-SHX=8CX=tHKAxwCQStDt84g@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/181] 6.18.6-rc1 review
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

On Fri, Jan 16, 2026 at 1:54=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.6 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.18.6-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.18.6-rc1rv-g486e59ed73a6
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260103, GNU ld (GNU
Binutils) 2.45.1) #1 SMP PREEMPT_DYNAMIC Fri Jan 16 12:22:57 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
