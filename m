Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B1D185D
	for <patches@lists.linux.dev>; Wed, 21 Dec 2022 01:16:19 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id d15so14034412pls.6
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 17:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w0sDuoFh6MSuhNngxpWhM/u9+zdVKy8ObNvF6Q1i44g=;
        b=kR1idSC/5v3uYvDJN4qO9E82qhonSL05hnd79797sZhhUBXcwLYsom9onDacq0NcyM
         D617g1OSnEnYTdZuTq9mNrVXCh9EwsDXs3q+wYvJDX3xE+V9frrB5jHWTE+Z3Rl8qLDa
         fV13cqgdfl91jH/quDK7qZBWzYPiBriywE6Deee/CN0kcyVXtwNzatjzvyglLKUR5RI3
         nIhQOTb0LOY7onBgPvqxwXXOBbO/MEw8hz2n39TTMo8KvzZwWkC4m8xAIoH9rNmLTa6h
         UhQpfkbSewbSyiPCz4OPoUQFtbwt0PrgRv8v9frQQsA3So5K9P7FjFYzxM+fCys7Wnyd
         zvxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w0sDuoFh6MSuhNngxpWhM/u9+zdVKy8ObNvF6Q1i44g=;
        b=0Gxu9SOrqirvK1p80XOoWW8uU3s92l8KWaUD6vwvg3BQojYF0wRywXN+fVevqzFZd+
         jrC5GDK95uWoWGodbDrB4E6P5s9LLhTOklYYi2KQgnFr6QqI6NzGa/Z0jgHjPSWaVlDF
         NEAGeDaGm9NnyyDiHexnvKSXViOyrB/38mVydNtSQE0i/Itc2KJqVAojd98qfJ9LSR2j
         FK/84Xt4eNbudJZ+iP4RrGJmSbRUznqth8eYTDYlAD5+LuCvgEgt4LY0mOlyTHuCFYHl
         1AI96/5sKEyX7xDxpCgjxRRQKDmkqGO3TOMtU6Cfpa8f/Br1RT9fe2rM84mMmPPwpYMu
         9yiw==
X-Gm-Message-State: AFqh2kruWN86s1cNR2pmzp2Z+rJ/AnIwhiRxS6XKMvMn+N7OQV732Tsy
	1LcWapuljGQXS/ZTYS/z3Md1ejuRIjtlC+BYzTN3Iw==
X-Google-Smtp-Source: AMrXdXskRn9c72nwM9MiqZVBhnmRHi9uC0mbTXP48nGEwJyF1XRb6i5oUctJRN6w5Wj+cu4aPZ+vVBgWFuVt6teGTnQ=
X-Received: by 2002:a17:90a:b301:b0:218:fb5c:a762 with SMTP id
 d1-20020a17090ab30100b00218fb5ca762mr8952pjr.241.1671585378255; Tue, 20 Dec
 2022 17:16:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221219182944.179389009@linuxfoundation.org>
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Tue, 20 Dec 2022 20:16:07 -0500
Message-ID: <CA+pv=HPwsCa9qAHORB_5U7B6MYbRsR8Lk=rrQkJm0CD7+Z7T-Q@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/28] 6.0.15-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 19, 2022 at 2:24 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.15 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.

Hi,
Compiled and tested on my x86_64 test systems, no errors or
regressions to report.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade
