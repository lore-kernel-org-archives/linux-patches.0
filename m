Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2133184E
	for <patches@lists.linux.dev>; Fri,  7 Mar 2025 12:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741350319; cv=none; b=lf0Qy6G5k2423ut1iGIy6KRCauXi4xg/lLObWcI21Aef/jRJdMZ3mW1xVX04d36yePOXySNCIV/YXAvukb+KgI17vxSYvjB5s0bA6vF1eIgkcaeLN9x6YkVYjbMhB6+lpjUC5x8P6UASyR/M91PO7fUjKnpgutF5goxu0Lb0VHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741350319; c=relaxed/simple;
	bh=cWtcLtZgpaH/BcPDoH4lq4uUZE4PyN6b3+uskMHMYW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pBHcxsDujWAtrLEZjDcXRDc6QlQrZniISwcoQp0ZkPZHeWbDEPULFoor0VFGwUGpeEKszt8lmCx2rpAN7RhfNDrlaVilBkWw/GRUGOx6oHn9DsYAvlJCnlMcxdqlhwL1hEW/iomKkMN1m566YGYAs35V/zwQDt/pS+5+3GphyDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=GZJs8g/P; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="GZJs8g/P"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2f9d3d0f55dso2825972a91.1
        for <patches@lists.linux.dev>; Fri, 07 Mar 2025 04:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1741350317; x=1741955117; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fDU3rB3lwTDhzbpDMnrAAgHgs/LQWtd52vWgHpI2VSI=;
        b=GZJs8g/PePRxdTcnsEDWE03QQfYiKYCgJBTbNRLfN4yNe22UP+eV3il6N4+aTmm+5S
         87LDw8MDAUEyTIs9VifrAd4I86A0qyOggDnS/vbKNAPWD8kUIsRoeF4aE9bcskmGADTF
         Z1vSKudWFVVBdokZcc9Hq3oCym4Q+f0E12EetKc/tyIwrGQS6a3g+bTTvSYuXgXHCnNB
         bQpkolBw2c8yyvZXddNRudHxkC3kDYbCd487JOLvK3sbzQ3E3YpfF6P96xP/A6hBtxqz
         cdM47L2VuBPp+DBtrsn2zZp03LVWk1vu4jZPQDO3p+Oq3HS149lWauEmC2RGmw5olhcL
         ZISw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741350317; x=1741955117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fDU3rB3lwTDhzbpDMnrAAgHgs/LQWtd52vWgHpI2VSI=;
        b=t2Lk52dZ3EJHITDnTDRkPEb0UcZ5o+EwD84u4CKx5nq3K9Zwt3O6LQbbhWKi4qDM6S
         1EhjWjdNUofDgSolCtDPba/oQ17Gjb5c62YeoYv3A3KM5lJqGhcjTrCLN55iHBb8qZDn
         szd7LY1xgXRr89VkdbgpWS0CU9wka78lyR7PVgD4qrEwegwEnpz0nQBcTETwCX3qiEu6
         Pnc9wvO7iQh1oHkEW6vZ6rVKRoYp4692ovESDOcrKF9S9lzMxdbxrgVGiBwb7SrH7PVX
         KTWUBDsaWCDFPdsfUEMUYVIeaEQ1tzCQ0jdUpcJQVMbZM2NYX5HjFVEzm3O7l4vavHm+
         2mXA==
X-Forwarded-Encrypted: i=1; AJvYcCW0CXCAKvpnBTvp1s4fsIEEasIWH6W0nGwKjDYEUtO8b9GTt2tXhZ7eTWVGNU0GNeG/PjLlLPV2@lists.linux.dev
X-Gm-Message-State: AOJu0Yzg/O7dcKBXk26CcEuz4QRtP2PaVFb3fiTNCk36vEORsiZ1yeBi
	Dd5TxS3QGEHdPuE8P0IY5KTJZVhith7F4wzOyvjI6yfeNOhq3A3NgZpwfj5DQp3dFxxw6Wk0Pyk
	9+UgBMn4kXNjaxR0Rg07LMpq/kXcAdIB+I1a6bg==
X-Gm-Gg: ASbGncvHpS2NAtSlom7EoTFmn+00iFhyBTZbnolDroIcdKjpAspJzSZmnXMQ3Fo4biu
	7e6MVSn8PAcgpsRmgftEd7uo4vfaJMqVUcJAYHdhgR/KtegsyRMR0FnhyJcVqT1NfyK92eZGama
	IYkIfwEDkECYnGbfOxW4DaUrzpiw==
X-Google-Smtp-Source: AGHT+IGIGXETSpV0breS5/h5u0O7Kue3nNAf0M2JvAyRjW//VoTRE04GF88gdeHWev8c3/TxvH+ghyGuEq0/lEZFOuk=
X-Received: by 2002:a17:90b:3ecb:b0:2fe:6942:370e with SMTP id
 98e67ed59e1d1-2ff7ce70a09mr5339946a91.7.1741350316997; Fri, 07 Mar 2025
 04:25:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250306151416.469067667@linuxfoundation.org>
In-Reply-To: <20250306151416.469067667@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 7 Mar 2025 21:25:00 +0900
X-Gm-Features: AQ5f1JrjYvBGN-wb9TdEeE7hFb2s31KStFO0Mmp9jf2eKZUcyW3LZfYCdYbFDbc
Message-ID: <CAKL4bV623WMkm3dXFKhd-84yVDCCxxCJK9g_zAE6_ign9=2m4g@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/154] 6.13.6-rc2 review
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

On Fri, Mar 7, 2025 at 12:21=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.6 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.6-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.13.6-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.13.6-rc2rv-g3244959bfa6b
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250207, GNU ld (GNU
Binutils) 2.44) #1 SMP PREEMPT_DYNAMIC Fri Mar  7 20:34:19 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
