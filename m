Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA752C860
	for <patches@lists.linux.dev>; Thu,  4 Jan 2024 17:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RyfYTQAh"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-466ed49e160so182263137.3
        for <patches@lists.linux.dev>; Thu, 04 Jan 2024 09:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704388368; x=1704993168; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TG4BujtMj3cbNtXYHg1i+tLfTW6XvV1xjqQK0OaXaOs=;
        b=RyfYTQAhnfPt5c2XWbGXK9lSaEvzXGZ9ZTQ1TX1iCTqJ8VtedOPvnZ+SrhV6mmL+9B
         lRIlQW/R4mB0UHFvv02T+C07zkCPF8gTucZ2P9QtYbCXehmGBwc6ljQ8KjVPIyZz9OJW
         dom+Km55j7ntX782lkw0/ZbCuf/1Zu213+ZhABXwfsFps1raZut1BodoUQQltUJAlY/u
         9F0NZ3GevEbt6aW4NQB4q+p8JrniL1IPseFxHKxvsjvabv+ZxkO94viXdaoTTR3hypEJ
         mOCHg8aC59jTH7M3tCaKhSpWi5VctJklP9krQFs5ipmC8DRD3OV7XQmA5vuHY1LvI9Db
         zoQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704388368; x=1704993168;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TG4BujtMj3cbNtXYHg1i+tLfTW6XvV1xjqQK0OaXaOs=;
        b=FJNowc/dZ6C3Tq7iOsBb8LfNgzGM5PEEVg8CEcXM8ppMkHgRoZZiWbQC+Ac7G6/d7R
         2xMMfso4s+Sgz9r7VTQsT3CRXEZYiCzzmcMierm5gs7Gn9GtXPqeL4rY1XGojSfPAmxW
         J15UIjXXdz977aZKPQkjYCl79PY2/Vw02VHtzNzTj8zjD/5xQQNRcINBqNhn12hiXiz5
         J0YA6GMuKUcUT5gHKBeTE2m7EYnzImKg9hZohAKsRv9sNJZGqTnVXTbiWJ3XEDseO/sC
         JTIOFfxnV5aUoEb8cGIwzTlKYms4+fPJwsQSVkCszsbYKhRC/voxcV3J+xYlcj0M7+Yp
         zgVw==
X-Gm-Message-State: AOJu0YysfSfZ5uWRuVsVoiusNTKKGvMHfZs7cBJVmzfbN7C0gRr7PM8E
	bcGmVu9z4+7gVNHUJLeppTeYNGcOKuxqG9WlfD4=
X-Google-Smtp-Source: AGHT+IFrmcj+Puw2qnuUPoLyUWaS7Db9upBCzJJBRIu5AU6fiRZU4h7S9uS8EWYb7YplDmhM/1tXnnCA4xoP2f3NBt4=
X-Received: by 2002:a05:6122:90e:b0:4b6:be94:acc6 with SMTP id
 j14-20020a056122090e00b004b6be94acc6mr785170vka.10.1704388368500; Thu, 04 Jan
 2024 09:12:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240103164834.970234661@linuxfoundation.org>
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 4 Jan 2024 09:12:37 -0800
Message-ID: <CAOMdWSJov=9kVY7DFdS1=p6BCxi8E90xedU44TS90NPq18iZbA@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/49] 6.6.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.10 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
