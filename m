Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DDB3E8C51
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 13:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770384866; cv=pass; b=BjHpapA+JC9ig5e5POfZBHMELpBmktBg3I85obH0zd0/XgKtocSTIu0ToFRkvtCjhoEQ599HBbd3FdxgQYZLEXK3av8MvbhfpF4xwSx8mDu4uxH0wmFe7g7trLf+OhO7jEfLs/6bs1l7RxTg4PAb5DmTiJXi7FXaZTGjgYRn7jE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770384866; c=relaxed/simple;
	bh=l7dC/Cdx5LXD4uXdt40TEZn1Frr+MwEVwXAggRPqJ0M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nKWVyhcGChkqlvh0PxJKkvy9NXTqB2mUkEhuuB1TfS6znFMWlJLAH8lmCE8j73j8+C46K0KFjt1uIAlHRRcrKxm1YJ7LMv3NDfPJM+Q18Tfw97z6YR8beoyyaUUaXGnPKeqKatVFecBE3oTpjcU93Bo8lvga54xjb69Fnxaq9v4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=l18dbqJI; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="l18dbqJI"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b884a84e655so314420266b.0
        for <patches@lists.linux.dev>; Fri, 06 Feb 2026 05:34:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770384864; cv=none;
        d=google.com; s=arc-20240605;
        b=HCg/tBrMtfnQB5mGOGc6r5L3jomK3jDF/k8ORuklcgUUFpMC7VCsyxuYA3bjEMqel7
         w60y2JuXcD7II/nOY3z/+TrR/px5xOQpF41UhvIzS91rdEuG4RgMbWCBrSPfRT/0TDgg
         cTjGj5ZmJ9nkEKCdx7IYcI0qQ6hsb0LgfExjBK6S94Ch8vKSXb8yPyFQnFlRO55ZlNWd
         d7r9n1+YEy+GM8vJl6gjScHcbmo8vQwM/eZNsqFEo+XQUO5Z6z0ZO8PVsi7IbwuzlE2f
         ix+vTCcY4Z1iCEeipZuCE72q2s6uHr5MWQwJrdNrljkkmOiYxbYxsfcVCVzdRx9+d39T
         L1kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=tN5Q1rb74JGxqPEaMraAIeSQS8Pn+Rcaf55IL0Ede0A=;
        fh=MnzLrW9k60vKWHImiXaYMsULf7vC5omVwxWw0hbr+qg=;
        b=GD7Gf0WTEzarf+EM8mcwI07yWDpuTI0xZq5QidPko4hYDZxEE9Ukk5lQW4jsfXbZHt
         8KbpiDEp6JJoJUj3LbNrNTUsTfCzx53mjJkjIwmYYz5lnaRrCvGLz//+ExgKSV9vNLwG
         GiauKFbVHu/TUJwwycGIvbr1WLebUzWua6vlZRQCru+VpqoOUsf7HjL/rLo5MMvh1K7J
         X7JpToskhNDlUE5xJXqq6diSW9ym7f8auuNDnI5WARxLthFpDH5IRZ+T+iMB6Cgjeb8J
         Hk1+9r3ZZghs+TfslwQYn0i3QYfGHvXRj88xYBwj+TaQYoA0rJ/ZjmNFegFPXIzO2Ghx
         +NMw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1770384864; x=1770989664; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tN5Q1rb74JGxqPEaMraAIeSQS8Pn+Rcaf55IL0Ede0A=;
        b=l18dbqJIsfNWlhHrI7O0n5SZGBeIT/90VvmFNaseVltf8xltbzAY2uYugInoMdtPZk
         jgGETdoaRl0yA/YQs5zZfeM6/rMZ6TG2LHGnbiRwaP/M94YaB2zWW37jLk6V16XcJ6Jf
         sLFNJTsaNJGxrxlDRnKdppcxIHg7Vy3J9Mx8BhF7brTHEsn0aCpfu7BJ2nYd5aK9uSsj
         H28aHimfVHVpJfmQ/wFTjrjJEu/kWvYs7BntwMsCgvxL2Fnd+ylRIMevr/Gmv8odHJUh
         2TsNil2ZCUfReLp591wV2VplQso7JkcPy5OnwtbMvBHvZ6Yp1YcddIKJTV+cbWwyhoPC
         oicA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770384864; x=1770989664;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tN5Q1rb74JGxqPEaMraAIeSQS8Pn+Rcaf55IL0Ede0A=;
        b=cxOaktJ8/0XtuO6i/p6R/KUjt2Dr/QunqiZbHUHNR4dO3tupA59cWcfyrpwtW6mdOh
         UtGUWupubK9Yd0vVnt9zQ5X5nhXkKeB2RH+k9qfcLl0CUy3QffMaHW3OtlUs6miCa+6B
         qnvnTrM1JEcAidmikTsAXuHgAfiddcafyUkIEKhFR9OkAgQnmDEjw5TohnMNmI6e35Fw
         VTCE+CTWnsstn4GtZfpMwRw2WNRWiABk8kPekulUVT1Qg81aDqPUHLqHAQtz48ME5tq1
         2BdLi9mrUCQDz+grEczX4iGb9IIv4QHFtEP028O4qO4nC5KsbHt0I99Jpqkasqng8wfp
         S6qg==
X-Forwarded-Encrypted: i=1; AJvYcCVVSlv+z+AyR6a0jB0n2M57iGGbuXUOJZ0hIHHUWcpRoYdZnmM/wLU1jzVEGmkoZNg/SPiVErs2@lists.linux.dev
X-Gm-Message-State: AOJu0YyTtbg4PPQ3yawF81O8QPb8vQrb1MP3RrsHJI017hjUWe/MRyAZ
	IdV+RN9lJLzSRuSjTcbM+z2qtHQB9rxCAtKzUxPIXtrNV9P1Q9cb6QUFZ7iAgATLlVVKdJWJmUJ
	dmgoAtRBUH21RyukzDLNrcUqbWy2lihrYpq4Flwm4kw==
X-Gm-Gg: AZuq6aK6V22sVppWbO30c1p7BFknTZXJS+rGsXjI1h4XBxLSMzake4r+rGbtDdvSORc
	KoNlfTvf5VnbjfW9GXxai0t17gOIdUD+aAJvWQvUaqN80NREz8wMfSL+DLKWjbWyD737LJshANN
	MsvSkFYAngbJsVWtifxMnXUuDcYJjFWsccf8sYsgf4KEuhZM+M4W/lSVCRb1SU0pPo0v4F9Fc0q
	t3Gcgj8ChL3g1qglvL8v1gSIy4peD3/IIsYFro2xVxm8b6BxaphZiJ1yUiF0un2vmEBMkiR
X-Received: by 2002:a17:907:9451:b0:b83:1327:920d with SMTP id
 a640c23a62f3a-b8eded474b9mr137535166b.0.1770384864142; Fri, 06 Feb 2026
 05:34:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260205143450.492803005@linuxfoundation.org>
In-Reply-To: <20260205143450.492803005@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Fri, 6 Feb 2026 19:03:46 +0530
X-Gm-Features: AZwV_QjgAt7gGa0mQctHiV4Enbff4TAbrSGzEat7SXsGZhk2g61R9nmXHK6dSRA
Message-ID: <CAG=yYwnKCZ1UTn7a5jtgQfgoXUsG6+OTGe30pdfcw4O3YtZ0bQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/276] 6.1.162-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 No typical dmesg  regressions.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology
