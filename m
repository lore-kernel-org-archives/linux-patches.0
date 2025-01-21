Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9061F03C6
	for <patches@lists.linux.dev>; Tue, 21 Jan 2025 23:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737500758; cv=none; b=Ngv0WUpjrkw+HD8uGhmIRyuuLoNjH/mNnI6ZsVCmcNZmutajkQ1cF7lP1MAGsILogkqykyTjE/8M8FxutUUgdbhJsZk8Vjzx6FTrUr8rAkuipHw2uXGo1TsiiG7oDxA1pL4clMBcPuYfCuW23sLGMz97hSuZGSyt8WZfUwN6sdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737500758; c=relaxed/simple;
	bh=F43YpV97/2e34lwkgwRzcQwPcwiyx7mnf0CMM3+/Oeg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q51KoERqCMoDCEYJ8A6Cnkt5j+fes/rYMmOHD4H6/AZdhhGQiJXsIHqS2PGU/VeMTl0niNDt54BzH3WApJGUi3MQH+P6xC2AeNiqLD2dXZBKdYOmtP5/I1Ue5VlbnxiJTDJW4TctwwfqQjKXDS2+12Z9tBH5we6u01JmAMs4FuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=Tmw2T51n; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="Tmw2T51n"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2ee709715d9so8721861a91.3
        for <patches@lists.linux.dev>; Tue, 21 Jan 2025 15:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1737500755; x=1738105555; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cbc+hOIvCMSLBiq+LSaps9a+lLu/i8zz4uUX9B6mAUs=;
        b=Tmw2T51n8z5/74f2+eodCZc4kFttKxVzYerPPzqDrkEcuYyUepcvmO0eWQSAOj7ryD
         I189e/gC8gxRU+6Wq1Y6elvm/SEPaOPbLN6pavl5vHSB0ahrL2b/c1UBfuGGRm8fFuL8
         oe65HCCeUUgQ+Cje4rPsNGBso69/X3/4ejv6eQFmQcXXh3PV6R4IdGpj1S23bNEe40yQ
         QMh6jjkaaZHt19tDlbjQsdZlUNv6IJMvJovxAZgxBKpDWkjyStWiMyoRjh2YrCMMyo15
         SBfREa5jOFx7Dwu1wZB5HHzC3cZ0heBrG+3cLRsnJ+E8GWqejnXqNofltKn5cBb33nkS
         1pvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737500755; x=1738105555;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cbc+hOIvCMSLBiq+LSaps9a+lLu/i8zz4uUX9B6mAUs=;
        b=byKc4G+8K2JWRv+va/BvFixfLc6/lMp1GL1xY+vylYXqviCvPVsTuFbKcZklq7bZTk
         QvJmQVVzornDToGy5P6WH/Dgig3Zw0rt1J04iiE1i4FlySISuIXzJRCKIPpRG3hX7ZrH
         eOrDxWCA/kkkscjYTPb+pyRt+1PW7IYyAKMfBaR9vEeSVek1wVbk1H+ckHpJ/fLJmb+Y
         DdmOy67Jg/fLPexW4EGM9m/+aE8Nx5aBX33e6zB0ZfNWGTwIo6DbhTdPh5U+y2UIlrvG
         zg/sGcEPlA1JSLHbTI5TnoaDd8pE7ijAOfPJZmpMy302mhGiy9DZ1b2BHohTMj12vZlJ
         alVw==
X-Forwarded-Encrypted: i=1; AJvYcCV5iMJJYBjVc/x0crB+n7eZnmttWil6mjeIgDTEweCUjjyAIMwhoGf+lsXXYXLViqtGTRKnlPlX@lists.linux.dev
X-Gm-Message-State: AOJu0Yy94iWps8m93biU/m39mQ+JSqzyXfi87y6M5SqJS2Wf2EUx+ODM
	EkN1FH0Cul3gNqbElEP2piDq1abtmiHGZ1oH7RRg5jdeomQ83hCmilU9wk4lsPiV8aEpBkO6tPL
	CUU/ULoAzU+oxX6ezgpcb2To32Ui71hczqaj4UA==
X-Gm-Gg: ASbGnctGmmhTx3StJkq5cB+Jeqdxnsl8/TD7UfQiZQtO9U37XREjlqs6p4wfq7Osg0q
	hSWVJ567AxJ/+5CknaWMTXnYgYQLLGo0g/2VSzAf/aFpyPOGxfzzM3k2xNNQeAg==
X-Google-Smtp-Source: AGHT+IHkVyzJhhaQnkoo0AJ3z3opglPTYUcs4UNSGyTQPF9cYLQEHNy4jQCtu9Xo+kRPGM/3YECqs1hsiy+Rk+liXg0=
X-Received: by 2002:a17:90b:3a0c:b0:2ee:e113:815d with SMTP id
 98e67ed59e1d1-2f782c70168mr27143860a91.8.1737500754764; Tue, 21 Jan 2025
 15:05:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250121174532.991109301@linuxfoundation.org>
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 22 Jan 2025 08:05:43 +0900
X-Gm-Features: AbW1kvYfVZK62JDtxQbJM_cj5GViCl6ulHuCvzA9Y8vq2d1LiNMgoRG34ryGx7I
Message-ID: <CAKL4bV6wb6uVUTQHxAokCp=fR+82_d8gfnRSUokGjACrW5pCxQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/122] 6.12.11-rc1 review
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

On Wed, Jan 22, 2025 at 2:59=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.11 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.12.11-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.12.11-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.1) #1 SMP PREEMPT_DYNAMIC Wed Jan 22 07:38:39 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
