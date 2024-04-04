Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD046BFDE
	for <patches@lists.linux.dev>; Thu,  4 Apr 2024 08:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712219109; cv=none; b=aIwj+8wqMgXTedguO6w4aq0sWY87D1EameddCgogz1xNTmLNMDFKePl2rhqdIPhGaVaHrTF0PZB67WNowdLw8yANWn1gAX4MmHkcLhd3FaJXhL0nsT9zf05xOngOjMcmvIl5CWf66pNes3HAXYKdJjSTSns7v8ohLDMWFT/y3rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712219109; c=relaxed/simple;
	bh=LrK3xAPTQqfV+xsDOVCRWUgxE3ONbMiMSCOYKjP9yEY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bxoOzPbkpIFFzGG0GdS0nXJEO+hoc2xfwDNwMpmH29ARTuJJCBp8blvKDO0IjflyYZKm80OKYcZArQyQXu/pwQ1r671avFUFg/1DU9pTohi1fLwbGNN2/N9xtWsOqQb82eW8N1CgJhqAPI8aNKUJgR7ViYji1FTOwNMRqfz55tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BFLEL4Jr; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BFLEL4Jr"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6eaf7c97738so545859b3a.2
        for <patches@lists.linux.dev>; Thu, 04 Apr 2024 01:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712219107; x=1712823907; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H1Cs/1U20b71/iJrSnxluFtesA0Ybe4cNXvTMs/mjag=;
        b=BFLEL4JrzZlrxXBGpJv6iijjMsia871vAPExezCQucJdSGMFgpldP3Q/zZeqKH3X8W
         dcO4NJYyZtYy2k7Eiajkf0J79WXAIShwgsB/SyS2/f0rz/kd2f21mg3rqI26/np0uqkH
         apJttQEFGtKCwzphrxN1ky1WutIgcX/6wNBRU4Nl+gRzirdmpzR3zVp/Nw179n0NVU3V
         kMQM3QxTfcjNnp4+TFYTwlN4ywrVvHFOZb1N7ULyLC6Xg1ecOHVdel9ioaKISEkWBt9w
         ljnSSxENJxqbaA1oXXojsi1YFbs7ggwjR03aE7LX1kttrJNDxRy5fAyv88btkdtXIT5x
         5LDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712219107; x=1712823907;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H1Cs/1U20b71/iJrSnxluFtesA0Ybe4cNXvTMs/mjag=;
        b=GjqWA9UrIhgudKjSDYJ337goqpp9ySKJnq9Gi0Ma5jNgFjqSfyu/9h4Fs3nB6M8reT
         OHjr8HzsKQpkjfB0cuze2Ja1+mF0Zo+JUouOmA2FaMZpa4cRsc68QqeiXfleYjh3jMoK
         hVyYIbBVOBdqRuRR/UQbzoeKNzQU30hgfim/hrpgzHft+jVJtG8JgJC8skw3GMZsdqBR
         7d9uPK/MnICIP5p+5tGm2WCHBi5G8cGyj4dFJ3327HJyAc7YsU08Lp9cDoNsXTZncmYh
         R+EoCcXztfSXEIYHcQZJ3vOwPZK8i+/3kcg06FkEhCnz2bRgXWiFlXh66KgdgYdgJLhG
         uxMw==
X-Forwarded-Encrypted: i=1; AJvYcCXdOZY4vVeyNB5ovd9LAErtQCORgHn5KDc5w15BzWDI+2bk973Nk1xGLyQcizefaZImZarvXohg4oFrtBicxHV0LbsJxIR1YQ==
X-Gm-Message-State: AOJu0Yzp9ajV9mdlN1B35mggHO8KCKWE+dxZH/BD+6014QpWqpmS9E/U
	4+MhrfqdZqCtdgD6FisMgyed5YEJ5UB8/1Gbt+kFNYy1W6lxwgu9Ff5yARCIyB7k22mu7cKASCU
	iHqYZw73Bvr3p/mPsywQxHNyLLjU=
X-Google-Smtp-Source: AGHT+IHpzrZ7vtYaun8Dk1P4IDiwX4yPdWi41t0LdBAiMRnEnthPpThqCcJAKOZj8x4EU8NhzLLtkRMs+GWuSkbdMmw=
X-Received: by 2002:a05:6a20:9c97:b0:1a7:c2c:c882 with SMTP id
 mj23-20020a056a209c9700b001a70c2cc882mr1913334pzb.39.1712219107341; Thu, 04
 Apr 2024 01:25:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240403175125.754099419@linuxfoundation.org> <63e194fc-07e4-bced-f0ee-7617e0232e54@w6rz.net>
In-Reply-To: <63e194fc-07e4-bced-f0ee-7617e0232e54@w6rz.net>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Thu, 4 Apr 2024 10:24:54 +0200
Message-ID: <CADo9pHg7w2Ha=cXcGf7RUn+Qwtv+Q-asUkcYuEjkOMj9ES_HFA@mail.gmail.com>
Subject: Re: [PATCH 6.8 00/11] 6.8.4-rc1 review
To: Ron Economos <re@w6rz.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

Den tors 4 apr. 2024 kl 10:03 skrev Ron Economos <re@w6rz.net>:
>
> On 4/3/24 10:55 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.8.4 release.
> > There are 11 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 05 Apr 2024 17:51:13 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.4-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Built and booted successfully on RISC-V RV64 (HiFive Unmatched).
>
> Tested-by: Ron Economos <re@w6rz.net>
>
>


Works fine on my Arch Linux desktop with model name    : AMD Ryzen 5
5600 6-Core Processor

Tested-by: Luna Jernberg <droidbittin@gmail.com>
