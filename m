Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5539B3C4547
	for <patches@lists.linux.dev>; Fri, 22 May 2026 09:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779441894; cv=pass; b=UWKuZ6DJ3Xs5YzcywNbaVsi4mggDAsXAnsi6il+eGiU286V1fbdGhO8lJ2gIkwTHdmZFJEEiOTUeLD821s8lECtvUuLuQ7TH1Wv0lFEeA+6zqwQmx/BPknv9Z2j0f98exTI0rZkDzHjJAAGCID3BbH/wEX8jCc2auyG9Is6VN1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779441894; c=relaxed/simple;
	bh=IZF7VWTEkxD+pJZjqgXH9QW6HzII5dJLvwjpAdoSmuQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kW7IAb3jIr5n6YH7pr+nS2yGSCJHTZ6lldFpyDbMbYTX7rpXv7r+S/ZMwVk1yPAGxdly4v+vw57XXwFQkc3hoqtDfzun56Gx6an2Wheh+5mKOsW2gnG0KYzUw4Q1KeTqq7Q8jJsZ+pHIwAFaa9KP9BmMjg0O6kqvCFn90LE5TUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b=nSlUl87G; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b="nSlUl87G"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bd124546379so1151599366b.3
        for <patches@lists.linux.dev>; Fri, 22 May 2026 02:24:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779441892; cv=none;
        d=google.com; s=arc-20240605;
        b=jOf294LfRlzi9QEKvBHAIVDBN/RHbXNDpnfCZsdks/R3iApVpmUZZV5jF5lT9HzxIF
         MP9O/3+gq72pSbc+vKChd6fNz/PLJN+Rj5WYSlYWc1nLE3elwGH+g8NWrfeFH8G01IHT
         hYBXPFnorPv/+Cjzu6ncg2XvzZu4HYb34TcRXhDwBkckcZPySOZj83YZo/Fuffjr0obJ
         YYt+US6z2nXi8txfgmYEpPnx1xspWO/uhdSmAk6Zy7dqhNEC2dwyeA2pYnQSi+zC7OdD
         qhj/cbLrU4LTzYu3HgePqRTmL6eGTO+4PCgfudbmzkKcV5jSQvTK+hgO5j7QN3WDokdA
         47mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=mGl6OXIZjtxEF7piXmOH4UUqJJTESaRkqOGGFe/ZsnI=;
        fh=J8uVE5qEqt7umuxEqnrrZTnlH97YvjvkUUzEdsKnQk4=;
        b=Dd3tMIhQL7BashFKu0MQUhGtXdnxFPWiPr1Qc3+03kxTIMz54kY2wpXwLiCA4Ppxu3
         +23wsvU3kx6dq3UxZ9AyYEredYu5C67H2/jPTDJOFQRJ1SMCnP8Vq3w1MYjYgOzS1VVK
         LLQY3wfzOPq14N9KxQ3dQgRBHvG/0P7GdL67GmjfYAkBWraDOb244c4RZrfbhSm21Taq
         6VHgr3WxWSmRPTbbVMnW1Xy2XLU3uYXgYL7wPIY0kff4JsJ1fI4ot3TydVI09vHw8Scc
         kcS+YmTj3Tzs+uIZzio+4KxdtT3r6INW62krZ8TPvjyqzxBqpyeiHgOzMXc7ZxhrM9CV
         QL9A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20251104.gappssmtp.com; s=20251104; t=1779441892; x=1780046692; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mGl6OXIZjtxEF7piXmOH4UUqJJTESaRkqOGGFe/ZsnI=;
        b=nSlUl87GTBpjNyO+IIqO7Vc2i4cPz3ppb2Xt5We2SvzCFoXWHfZzzUsz3zJ+evkHYh
         Fi3rPZWDY07hSeiVJI8tvHXXkyea1aaDhq87rwP2URSBqk/mOmG94Pm1I2oe36j/KLgY
         gm4Pk603hXQzFVcDDwDwcoiaxYr+UKxiu471mg+JuGXspQrzym49yUFVsTlKHPGERDCM
         kd6PhApJs/yfnxom5qmzU5hqZI3mopO97ZGLnujxBUF/EEvhMEy4zeilK6hbfb9qAU8Q
         GlumIgIqwi+hGY/rsJjho3HJR5xmSWxrnJabKQgOECLSJC6mLu2J9RiUzI819Eidix3c
         kNZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779441892; x=1780046692;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mGl6OXIZjtxEF7piXmOH4UUqJJTESaRkqOGGFe/ZsnI=;
        b=qnYETP45XLbvfijFMbgUVj66TUZk+OKGJpgPhimxmnKcRhafF38KEDkBHBx9RyFGl9
         KpM1Kopn+Rrwjo9CLJoax48V4lQrpbAzcypyHUYx01Qcri6v78c8zDa5L9e+qnIRiEE1
         e2TRDZW92M80yhP3cy3h4vXy5+rRqh6Fi15oz/HPgnqTPjtDCCGCKmaW/Bd4Gd4DWjlg
         28DwRptkVkhprNEkvzP8qiz7h6JWbqgeFVXj3Vz1GIEmra6fOVb5hP5z2NXBfSPQ3s7y
         oj9/JFXEEo/QqV+slWlVMzUg+jqminVJgMJmJ6qNgKY2FmbbvmbbEMfvdslPl+jkWHuo
         z55A==
X-Forwarded-Encrypted: i=1; AFNElJ8DpePe4nP4yLbJr2SMmDsX0NUY5UjQjQs71C9V4uHzbxZrG5P01XZdZvclyY+LXLhL3G8foOHX@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/ZthcmvZnWZccF9djF/k40v22ZiGT0C1bLi7dSDmANvEa6xVR
	5+5txI7xJb4GoN0n7dw5did0qU1HeGnquMi6boTk/bCvwxRHQwRXyqaX8AhLAJ05EtvJXOxP8CW
	FMJcv/hILslU0Y5KUvKKwm7EzJMzzf8UlM/R4AeHYZQ==
X-Gm-Gg: Acq92OGUg9XKA1eg2EIUirhL8dJlEUoylrQ51PzcizutEBcDLDHvHJUQZTgDfps6IPb
	HEEKy+f+vt3bi18lhrt8U02BVUFOuafkFuTXMTz72DO030fnwYk8k78bwNyk3pB4fgpBZ8YDWB8
	kc5KctaldEQ4Y3AdCVVAZRW3wp2DQYvC4REF4lPyqgGTtb+jFUZOU/QFgnNiwdRv+sunvTp8b51
	AwDJO21HZ8XmJ5tmCSITsYCrh0SkQzqcUP5vMnWaHbIgfgJGxUMkBn77+Uo0KNqvRBHCqXpJqDC
	XWBNcrwsv/ndIZLdCuFFV+FLh4EhhBwY+ooMc8mkANl7SGTrhTT4S+KnmqobLJog4NbEWOeQIU8
	6r7yvzA==
X-Received: by 2002:a17:907:60cb:b0:bd7:bbae:2002 with SMTP id
 a640c23a62f3a-bdd22a3d558mr171790466b.7.1779441891775; Fri, 22 May 2026
 02:24:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260520162148.390695140@linuxfoundation.org> <CAG=yYw=zUeUFxBvLhAvhbhaSv=H0qUi+CFkcN1D+Oxxw6fW58A@mail.gmail.com>
In-Reply-To: <CAG=yYw=zUeUFxBvLhAvhbhaSv=H0qUi+CFkcN1D+Oxxw6fW58A@mail.gmail.com>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Fri, 22 May 2026 14:54:14 +0530
X-Gm-Features: AVHnY4JkxCN04TKCulppq6Xi8XeZ872LpbUc0lIeILi89vXoCyM1TV6E1paAoTU
Message-ID: <CAG=yYwmZExpLR5DY73s4c2iQ1cQq=7UcTWO9W2saaad_fzu1UQ@mail.gmail.com>
Subject: Re: [PATCH 7.0 0000/1146] 7.0.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 hello,

when i  did " make install "  for perf.
then rerun  "./perf test" have changed output.
