Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8229715573A
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 16:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734108124; cv=none; b=TAJJAfK0kgRmeF087aaPWHJZiVgvGw857H4a7+osSLyyhlZ7NYq8onUGqZ5fedBncnRxHcQu8k5/x0bVmQEnXbCyw2mxweAEQZtiGWDSJW0vE98tP6UZydy+Rck6j+hD6Y2Ai/+EbinePYd4uS0SxDABZfCRSYyuTffYInbj6Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734108124; c=relaxed/simple;
	bh=DY3G1tEAET+rKuduOG5mnAvxoOROA2irBpLrMWyo+Y4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a/rAYlmKnlkGmXdYxRohWd4xO6G1eZvJxLhxMn7XG3U3VxIjh6qztVN6CIwiYJ7Ur8j8X6MoNEo6lKh0ImLalcM/MV3KEklk78Z//N+hgvAXNYqdKd/wQltHycyz9A8htf2PbITgh/aV1dUSPDDp980oEBPvtkbwi9TGWfxT8ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CtgzIK87; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CtgzIK87"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7feb6871730so1460858a12.2
        for <patches@lists.linux.dev>; Fri, 13 Dec 2024 08:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734108123; x=1734712923; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ky0lIS9S3eaYrQM5awNSe7q/rYLMAUYMFW0ogX+uCfA=;
        b=CtgzIK87HW41SvetV8bPzEqf9Oi/CED2BwRMhQH7SX/GtdsCYB0EP4a4R/V2fay5rl
         8Hy5OcA3Bhu2GhBqCkqRksa2QqqJOiFKO+H1VV25k1O0y6CCTH9Xp++B3bP9UmDSAZrF
         qs+7QdN+tn2FxH7MpCr332xZIPxj8whU6siX9TCNxkXKg8uKKxtAvckGjBNjqJbyQGSv
         2AD4jM4s/heVTEL2NHlpWwq87TusglWJJSyW8afTy6dT1g7Wb4sCgeDTHQqymHiN9yYG
         MZgyJ0NCNzUdzV1ol+eFp+bQST98BnC5YvlkdLiG6L+xMDV5iUhoZ4gMuow0Gc5kYSMO
         /hQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734108123; x=1734712923;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ky0lIS9S3eaYrQM5awNSe7q/rYLMAUYMFW0ogX+uCfA=;
        b=AsghAic050G3FU9PU23BrzYyTqazJsa8QbCCIDXtLnWDz/H0eA71jD+eY38i/bnN3s
         7sTdyC5MLfJHTAMdTS9zhCYNU+lkt4j82MGhZuxhV1fq34HfEgJznMOBNalN+lFt63Ek
         c9F+QjjdrgQvnuCzGchV6N7YaHbTCMwCBHlRFFpQi5ynNJ+qF8iFjF0cjKPWKpXXrH5H
         RyWD/+qLcy/C8EM9+Qqd11vt2t5m3a4n0hGHK9cwsqMLouDHEn2T+wrTJ0Jb3583n01s
         36B5rpqKkh1MoZD9xPPXid1ofEdusveyyNtC3bB9qfHnnXmVylrno763Q4x1MeDhrsKw
         OIOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqTzVX2LkwZMIPgYLQIpdJ0BXJk82aGvYLGa5OzLKc/0GwJlsYA9DbJVpN4PX1FyGpXWRmtvRG@lists.linux.dev
X-Gm-Message-State: AOJu0Yy58YouyGWFrTK2iNum1kiYK8QmnThMJE2pdnVNvaVTQ1rLE03Y
	0+Uux7o1VN3tuNx/lxeWeSQSd4w5pk1178UrnVXog9HpDr00HpHu75pIhlbAo+cRsoVfUX0j9LS
	mbZCHrnqArlZS2IcE63pDwQfzVug=
X-Gm-Gg: ASbGncu4yEK/kuX1fRcjYtcgEZxBvwj88OuXf+438i155jGZPYSldX5UI348kfmZM7p
	BiFLfUmEaMkGNs/kW5MAciAr6tARPrkkXXa+Q2WanjjOI2nftCJ/k
X-Google-Smtp-Source: AGHT+IFcd24FZlpjUic/WsMfDzCsGJdnlZaR48ryc9Ed9Jt5q52x8F1rQAtl1jjed3NlptuAOvqmbZa8Hib0UrXxvcU=
X-Received: by 2002:a17:90b:3952:b0:2ee:db8a:29f0 with SMTP id
 98e67ed59e1d1-2f2900a6ef2mr4924037a91.27.1734108122860; Fri, 13 Dec 2024
 08:42:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241212144306.641051666@linuxfoundation.org> <26e5acac-0732-4394-9efc-da91630a0a42@linuxfoundation.org>
In-Reply-To: <26e5acac-0732-4394-9efc-da91630a0a42@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Fri, 13 Dec 2024 17:41:50 +0100
Message-ID: <CADo9pHhLG8KFcPc-puqzOq00grvuceu_KPoxM2Z58Ob7e6A+fA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/466] 6.12.5-rc1 review
To: Shuah Khan <skhan@linuxfoundation.org>, Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, patches@kernelci.org
Content-Type: text/plain; charset="UTF-8"

Would it not be better to test rc2 now instead?

Den fre 13 dec. 2024 kl 17:39 skrev Shuah Khan <skhan@linuxfoundation.org>:
>
> On 12/12/24 07:52, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.12.5 release.
> > There are 466 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.5-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
>
> Compiled and booted on my test system. No dmesg regressions.
>
> Tested-by: Shuah Khan <skhan@linuxfoundation.org>
>
> thanks,
> -- Shuah
>
