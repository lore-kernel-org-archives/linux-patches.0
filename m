Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF2F67E68
	for <patches@lists.linux.dev>; Tue, 30 Jan 2024 11:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706615683; cv=none; b=DexHzdyQtCGB28LpQIxUkvumB/vsHrADn5qGz6/ccqUwgzNIaH/JI+Q1J39GeAFCo6sJP5BnOgkZs6dmTRqaSt+cIcp8Pt6FbKJp9Qz3dQK6lfsxZS5D2+bEG/GMzRFX6gIHQakoPnl9EZzLYuOl8h+i9Zmboa7+j6OPB6rgoFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706615683; c=relaxed/simple;
	bh=vNdnIux1xX62xc2eKT/WMUKc9JQEqx7tiep7+FUX95I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nCWEEJMCrmCyHP9Q/PEKIZ2oAWPTNbHPe+oMpC39Ei/M3E5ch3S77bCcB6gYHhKEXOpXH6m4ulBtmnGgqMOezHK1eLiR7Iw5oWOw4SZOVu9s7CPUfLHIRlZahjTLtg5+znU2vso+mCKxbBTot26ARI8aCHnEIOavgvYp3NDBXiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=ufMuJ9iY; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="ufMuJ9iY"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-29036dc3a63so1964288a91.3
        for <patches@lists.linux.dev>; Tue, 30 Jan 2024 03:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1706615680; x=1707220480; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DWvxEqM2sAiMA41B2v7Y3h0SQJvpGs9/4DqAKQgags4=;
        b=ufMuJ9iY1EBMYTtIw7MsFxV+4xMeB28Z+ZRuvOZZGFbQEiEfzUEkx8Bm3b6aZMDUVs
         CnlXB/5wU5yMN+AS9++LRGtius5qPRwJof5Pe9EI643of0D98j7dyY6kAp0mEzf0eJze
         fBicszv4cjg345ku74AWfLSCg/aen18MthOPHRGEKqiw0YJ8nR6H1PztEDCwx1uyzuHE
         O9LZXDtw/EL8Ow0w/hAFWCnK3mFVwkuEwnrXkdNVAfIDnt/SZg0MYgkJBQWnW4uhv4cP
         GBNYbVxhsH19JkC/raBI5TfDW0P+5WYTpgWYtLR7ShXAzQ6o4+XcOleIlLUaGqrn2CHq
         fWPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706615680; x=1707220480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DWvxEqM2sAiMA41B2v7Y3h0SQJvpGs9/4DqAKQgags4=;
        b=JbbXnrsBBSmQDBJDDPQ97F4G9Digx7NiNjsCUCWZHIGU6rX2KXfqr6B8/CaLW4w5wx
         7kX5Jf1JDvckF5ig+FNDyDg0jCc6kYr4ZlqF35YF0Jwh3819X9R2nHvyitK/OtXxbJ5Q
         W3F4ANRu62L7KjbHmFfsEswS0IC8m0MOqYpMHXVzLU5g1O+/rWdHGl3Vck4SlFKi89PM
         EY/+5qokLCivwogqi3Z0wL8XTm/+tTa3mMJpNuevLlhLzQdCS8z8Vhebn9EK/5G1yntz
         /EdWys0G3mYpa3+PC6AT8Q/X3bkBifaVynSprA/AJBx7/RVSvFf9U2z1D6wp9eIn1KeC
         vjKA==
X-Gm-Message-State: AOJu0YxHWbY8jt6gQk46vlMqfswLcLsJmWlUT7J0JzyhCN0EnwLb5PGj
	G7qIVBjLcHm1bMjolVVuWfwImL+2ZydrSfJ2wDSrNtc1erdhGmMgWXKYiycQzNbQnJ1zWGgsq3F
	OGcimn1e85JvjAtVv9pCrcXOleUWVH7Ykz634zA==
X-Google-Smtp-Source: AGHT+IH9c3sIo7Ld5jc0z4sK97HzRMshtPUDQAZ0vZw+NLsRxgD8BOaqACZQUS5hFwA6GvRwGajwBgs7ZIKruDMHNBQ=
X-Received: by 2002:a17:90a:bb12:b0:290:304f:e651 with SMTP id
 u18-20020a17090abb1200b00290304fe651mr4886258pjr.39.1706615680339; Tue, 30
 Jan 2024 03:54:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240129170014.969142961@linuxfoundation.org>
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 30 Jan 2024 20:54:29 +0900
Message-ID: <CAKL4bV6poHN0WqBN7Z=TZ9E3uaLz=h=5Ovn9xHm8y6E-mabKfA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/331] 6.6.15-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Jan 30, 2024 at 2:22=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.15 release.
> There are 331 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Jan 2024 16:59:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.15-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.15-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.41.0) #1 SMP PREEMPT_DYNAMIC Tue Jan 30 20:22:49 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
