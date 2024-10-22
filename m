Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C947319DF52
	for <patches@lists.linux.dev>; Tue, 22 Oct 2024 13:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729602525; cv=none; b=QTCnl84sVn62g2RcHK/riawvcMBhy5EnTHcrqLysBSwDJUuLzLOsyt1L4lxEci3V4jxM74sCKsFH8sBFq1l5lbbd5o+Sozvnm8qhugQYMy7DrCiw2mWnNFCb7i+pHyZnYrpy9r8ztfjNeeJJ2KfbGTS4LQ0iw4okCvVe8tpXvL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729602525; c=relaxed/simple;
	bh=3cVOqkFRTnn4fFWxsQTNO55gu0wUXV9eMQLfnE+68dU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gzw3Xe6rSQF2Rgb4Cd/gJVTP4qKjgUC+ZsaRvnHkgCGxxFDsjkRszbxUZNan33ovkdobpDNoFkAQzptO5ohge7bkSCVz5sYOLLzXf9BWNd7tiZuUPxOa9xK+x7PIXLDqEyZXWvBW7citPVVTlltkZWp65l1yCqiS0S2XypWx778=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=3R1EqWD6; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="3R1EqWD6"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7db908c9c83so3571682a12.2
        for <patches@lists.linux.dev>; Tue, 22 Oct 2024 06:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1729602523; x=1730207323; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eSD76+9WkSJmJmUZ0lbLq6LmsKkpMwJOlweUzuTVP0o=;
        b=3R1EqWD6FnvW39fFcn6ROAkL4M1LS7eU2GQFOmp4T+1Yxb3C3h8xJzfH4AQEJRteRc
         RLSSJyxUtZ3MSJYDuOI6gzBMbedIoLttW/DD/9WO2UBtglsptQf3RHOfVZLoPrpsVVzG
         SxuhoY6So+jYGdYnlb2tt+Gu5i5OZuCxuPMh3LWxz9h4Ei5LfrWgVj/DqdWj6rQipBza
         Nz7SrAZv81kq63QU6H4jBAPQ9HFi2QTmBNXcxkBo9VipIBCLfh33FPY7z7dx8QWQWmMM
         Pn336Ceqzkj3CYlBS1/lpRa7Xzj61uuhUPjYhUJRQAo4lro20WkO0W7rLaz4mNOhSA+Q
         j7Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729602523; x=1730207323;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eSD76+9WkSJmJmUZ0lbLq6LmsKkpMwJOlweUzuTVP0o=;
        b=bzGboHYe7yCckKbUpWk8UQ1s/pTv8sXZ10+1nZREvBabGJcSpdMJRwwUpWpNmzU9yr
         SQwlvADf3OHeKqdt/GB/eiKWpqDcDrbqm9qpeP4yeJhHGlE+SaJv+TrgLIahg9UyZRVt
         /eVTkCid9kItLRgSqEOS1KjBgSyRcE9l7t7eUpVqn5iIv3hOCHjUJHqr5SBfyz2GpQjg
         fTAbWrYYcfzurEPz3ornZTG4Spcrk3o9HGgrlIKo0/cqIADat6wm1CusbiAhVHNk2KHr
         nPEMbopv344SDMw/JV7j8mp21PAq1hCzR6SDQpvNPCZOgTaB7NDd5qANDGBwe5G5fcgi
         8tlQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2KGmPvnxh1KraECY5LFX2iy2v1QbvsgP3ZtH/Jhr4JPRVQGYVpJZDiVAvDRBZlsXEk3NT2HQq@lists.linux.dev
X-Gm-Message-State: AOJu0YyNf/B/9lxvDHkxVIZEXT7qdIN2D+CRtDqj+MbzDSCLyfj4OsON
	5A3eI9vTCOGd5ldIMEhKjjTiw9uZhZE9NSAXoG2AoVxBWQyETltISthopLwix2DMBOObMGsn3BV
	DNqPXd8pr6Sh3CfDkfoh9JeCyf7NBJ2f/FNjHCQ==
X-Google-Smtp-Source: AGHT+IHbGo2VQ8g5GmCprVUnwQHQ7CqOubSGDzGzyMmpKVAzodR2cXRT87GluNUR/opfbavjfYATFita6FYBPaa1n2s=
X-Received: by 2002:a05:6a20:e617:b0:1d4:e51a:932 with SMTP id
 adf61e73a8af0-1d92c4a0187mr20939890637.8.1729602523000; Tue, 22 Oct 2024
 06:08:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241021102256.706334758@linuxfoundation.org>
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 22 Oct 2024 22:08:32 +0900
Message-ID: <CAKL4bV6PwEy7ShiMBj18NofyQxtC3guaRwh_ZNUOOS2Ei4Hz3Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/124] 6.6.58-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Mon, Oct 21, 2024 at 7:39=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.58 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.58-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.58-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.58-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Tue Oct 22 21:03:58 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
