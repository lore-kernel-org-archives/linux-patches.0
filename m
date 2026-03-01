Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DE4331A41
	for <patches@lists.linux.dev>; Sun,  1 Mar 2026 08:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772354180; cv=pass; b=txYfBXjJOxFLCXIOgyuodRxdz/4/Q1jCKLD+VjLshH6TT+2zrRPd//4FYkFFo8EWpPJlj0/tNFWZ+9o4bxeMP6uwnGf/2mTJlgJte79iJiOUu7dvs9MiLFLf9s5zPd7qXkikeZbjlCQP9Jao3touMr06qhaQnB1Htlwi1NI8ejU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772354180; c=relaxed/simple;
	bh=r2pphhJdINlvzPXll7Wfz0QDJeqbUJhM0Z5EZajYlOk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hh0wPfm3PafliaX8eVBDgaLGDwgenEvXspaDQQ1KPeOopXZAptkP867E3LqRtTNesh63+SlbjatRN98LDk4BZgu45PDisaGLzx9t01YxNu3d4X2/XF8dquB4KAuriNXbaQUszht/evTtyFb7lZ/N9VR/qFv0rTqemPtnVMqYAlM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=cu2nID2b; arc=pass smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="cu2nID2b"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2bdd40d3c61so2628597eec.1
        for <patches@lists.linux.dev>; Sun, 01 Mar 2026 00:36:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772354178; cv=none;
        d=google.com; s=arc-20240605;
        b=BvhvNU3dZ0+5np0bBlSg2/U9CeeFFwq3tgymo5Zb+naxgWi40uG5LUEcOTZpWOgmdX
         30BYjgy8Fiw/JxomqZZI9ML4n4uUqSKYhDw07tCULy42eSUkl/+QSe1P5g/oHFsjp1uK
         /7xokOJkmIJMr6vmM7wIlWHeJ/iZDS9iC0FIk0cT+psxryNyz0NEEdCWnqdxe59zUbMP
         /ZkPZWhZX41Gl9IAhZkSz3uV++Xfq3/AJJFkV0LF9xiFYEM7YVCRd+M9maL5rQOA2pxi
         p3wTwGeaIRqix1fJH2/qQjH2TmXSKsBBct0Kk2wSUNS2gOz70qkEZECPOVseaJgfUJhb
         qFvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=urH6iFQEulOdg99se0fOOar92YcfJM9z08+hSFrPGZI=;
        fh=SNp7698t1RYODbyow036t+gaOkQMKTensAMTcdbZYmA=;
        b=EzSRRuwu25BDmfjhlZRa3narQ3SGZevraEfYdzFFgHovKPRBC8n9BwRrmPzq9wKG/g
         Oz9Krtj6Y0CCjybO3bdoersr6rLCC0SZQTzuO3quS81YN51t6Zrb5NtJhINji4mUMP9j
         3AEwhJZi7Kd1QtP9jgFoCqCwqmY2mSlj/SojQ4x17p70aDP6kKcEm5NHI6dcYDXHgZUv
         cwKZ8lLw5FS561PQbR0JUUFxKrLRCsVJWuDyJnx7ltP7gZX+d4X8jS7eulPV0P4/POZh
         bxfDotomES33opWG2pGMtcwKCmqh6mLp7iVOMwu8bZX+Dbve/9HWom7UFiLJ/Ux23xZl
         dT0w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1772354178; x=1772958978; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=urH6iFQEulOdg99se0fOOar92YcfJM9z08+hSFrPGZI=;
        b=cu2nID2b4wc1w18MBcAUGORUgEX6BwbwbEWrW5Fo+b9rpTAzTQQ9ffRajIgCsBgmxW
         PvEa/pNajH64/q/HX8WqoDit8Gtu/GCqJtpITocUKHKlgHDzE90F37uyuK9r5zgO1TGe
         1GvmCDXTwD48JoncLoWwKvhuCz59D30QUNV/hfYPb1fVJx290GNAlDD/1AxRhOgd7PJx
         SMFeZRtiHbWdj1QYI5WT1RIHdaTBc5r3kRV/EspVbAUYgYiJnQLPq1OEfA8mf5PhMr0G
         lWkUI39MU6tV6+KPA03DssGYQv57YlVsY8ImWD0j6h6e/wACV1QTJwhBQmDlPXhY6lDL
         mCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772354178; x=1772958978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=urH6iFQEulOdg99se0fOOar92YcfJM9z08+hSFrPGZI=;
        b=xD6AtgfeG6584JuNHPq2vXGgp9OVCUynFgJ3DwqtdqYJ2pNkkfmS0k5ywfVl3XkKJz
         vUQt1GsUhVQL6vt3753LOqRr+wiqOyXOVNgja4hsDfMN9rgJhtSusJ5oKJ1ibKMaw3Iw
         oPTZa080/WbeWcK94olj79t4Xz2GgJbfWDgx0pTKfBj6vy9J/9n0Zh+Kalpwz/MlSJHx
         VgbZkOzqdiN+OgJuYEddzTDBtDKyFRDhrQ7WkR0IgXGDQz2QD3PPqyGpL4mnrbEC5MEJ
         +rGqA0DFRErc/z8yVl9LnJtHi6i6ejxyAHLYPweqKudtSsYudZVLCSl2s7mPxVYIuXRf
         P9Dw==
X-Forwarded-Encrypted: i=1; AJvYcCXegqFm9OBG7U3vPgpMvQ5GDYrhdkvekSCibvFBylZ6MUPjwKwW9/4bJxRRqnv5tAoEe4si+MXa@lists.linux.dev
X-Gm-Message-State: AOJu0YyOx5l49Y92iSVfnWIIE3dtDQTrgCcEOeIDzAxU+wTWxQVETFGz
	l0ml0ZsQ9S7TlSQF8afAcK/+shyJusj7sWW6Y3DJ70URZ7Sj6W7kjIl5d7tfgxy4Wc9Eza+KaKr
	7FeZwnjJTv02s1Lqsy7CdWSUUM4tXWkH2Ow8giSgrUw==
X-Gm-Gg: ATEYQzynjB6CNA6Rrh7rZxD7W1se+gd7BqdCmq1FGQOEJ3FWeQ8sdAk1SBZGXpe1tPP
	OiNF6H4La0MxW+tAEwiC5RbLdPVKvxrGGraynJGs9snueSnb6S2TDHnbMMKMeefh5RMx+bgcEmK
	+jJ3DAM/9p5c3t4Hilbk3mBHzK5ozrzjppdiMzUtbQJ5xKZmgxLspilRHFgDUgIMBlK7mX/QMHO
	3KlJGhdgx3Pj52BtMt9+IiCGY/roMmycmEv2NCB+p3TWPMO7qWXsE7FgcB4giyCxs9XmcHTS3nI
	qAsPkRJq0OgRKawoZwv4CZMjUvTSlCjpD3UHmfklExSYjVtSjMc=
X-Received: by 2002:a05:7300:5714:b0:2be:e4b:60ca with SMTP id
 5a478bee46e88-2be0e4b64dcmr39449eec.4.1772354178287; Sun, 01 Mar 2026
 00:36:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260228173244.1509663-1-sashal@kernel.org>
In-Reply-To: <20260228173244.1509663-1-sashal@kernel.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sun, 1 Mar 2026 17:36:02 +0900
X-Gm-Features: AaiRm53InbxY9FB26D-DyQSgtkquYGLoS1vd3enstVkB5_CzVDKTgfLaOE3TzcY
Message-ID: <CAKL4bV6ZxZpVRVLiqgJDrvws4bWB=R9S4cwR0ZAX_SSZpW_88A@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/844] 6.19.6-rc1 review
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

Hi Sasha

On Sun, Mar 1, 2026 at 2:32=E2=80=AFAM Sasha Levin <sashal@kernel.org> wrot=
e:
>
>
> This is the start of the stable review cycle for the 6.19.6 release.
> There are 844 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Mar  2 05:32:25 PM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/patch/?id=3Dlinux-6.19.y&id2=3Dv6.19.5
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha
>

6.19.6-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.19.6-rc1rv-gbf28ec292fb6
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260209, GNU ld (GNU
Binutils) 2.46) #1 SMP PREEMPT_DYNAMIC Sun Mar  1 17:00:33 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
