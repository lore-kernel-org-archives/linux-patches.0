Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2195979C5
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 13:23:48 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id 7so20128621pga.1
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 05:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eRPbEtbfmVz3R4J2b3g8fPSK88ox6UwjS+JxggJkrJ8=;
        b=KUNrBJ8qgTtpxHggAF37pOGTy1xAk1l8qzxGh8PqT30cB+oDcgxK7p0qw5wFthAZJy
         WNECZVVmtaDG7lfMvz4dnifINz4uIROcPTUdwiBjUHj+0zbKDTJWwazaRlWvKQ9Rc6k2
         QdRgfNsEhWbAqZQ+O9zbRwcW9d+akWQXBKH97XxoxBEFEW7AMLFNx4IvP+/c43VeG7EY
         Or12AFBbXyYPMUwRtZZockd/mjVHLX/gjHah0Pp2lB3Bt9R9nM4nhyS2PCfJwEzclGip
         tVd9TvBzcETSfTSLksCnvMAxYtxcGwlZMqCvEBOARTbT8pQReZ8uTYpYT9SCpLb6vtDU
         T9ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eRPbEtbfmVz3R4J2b3g8fPSK88ox6UwjS+JxggJkrJ8=;
        b=rEHjCnhYQkFaEYPsAiwljWyRImJ5eHLcY9KbfwVynpO9EoBQ5EkqiP1ef669SH+sy5
         UZFab6F2mx/Lt6TaU9qdKOtM8Q4B5KjNvIohTOEESJlY8gH1PioTxV/RPOUvIruwF+o4
         2fN9hZHzh9KMOmjnk53cC2PfadWqalmjJpIrY32T5mPw+eRky3+70FEA2pOBtdWIDuw1
         EpGCzqllbqTa3qlng1aSd/HG6lKEM7FWeHIhNNxDg4uSFM6BYPrMSviHk6AEGIjZ1hb3
         Fg7jSRncweVQvPhiGL07GA68t+8aM4VwngEfniskBWb6S27oJePsyR4wikfN4XvgxISt
         nrtg==
X-Gm-Message-State: AFqh2kr0c9o2+Euknytf5oStvpVTK00YBi5oHWB48yYAgxOpUg5a8s0b
	MEvdCLq7y6BbWtlhj/6wvspTiVMXgotgiFVeyg0=
X-Google-Smtp-Source: AMrXdXvQ1a7h1n0kUst8FBUP4hP5eedIcCGLIn+U4wzph2MFJI5+aVrxQc4vjKolG2hZZB6iVxWg2mCCajiQLwqhuu8=
X-Received: by 2002:a63:1e57:0:b0:487:faef:be12 with SMTP id
 p23-20020a631e57000000b00487faefbe12mr1869675pgm.333.1672752228560; Tue, 03
 Jan 2023 05:23:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230102110552.061937047@linuxfoundation.org>
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 3 Jan 2023 05:23:37 -0800
Message-ID: <CAJq+SaDrGuOk47sbSY=XGPDdD7Dx2uTNznK95FOkM38-73+iDw@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/74] 6.0.17-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.0.17 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
