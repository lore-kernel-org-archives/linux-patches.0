Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF424A947
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 08:15:12 +0000 (UTC)
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-3f7f4819256so10671055e9.1
        for <patches@lists.linux.dev>; Fri, 09 Jun 2023 01:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686298511; x=1688890511;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K/umIzeMz8geuBnQ70Zs8Lyt2KL70GKQujvQXIJTU5I=;
        b=KbhSHFa3fD+CZYTpEwafl5HoL6JuUzJZuMZpzscp3yLZVVozMf5fQ0nRfrR1PJ4b5K
         Tbo6jc8my7YAH3S1zBQU2riLYK3wN78KMqQO+1/dGzFFcusd3Brk3TMm5NExTmpRzK1j
         S/gDxOo1hkzvvzLwKh52hF84jmTaOQLaroUn3s1gIampmjQwQ1/quqd/Q99XEwrcjZwK
         BVEP0l9e85LDkR0/p1u+fB72sOWWjEl3pBuHACQqQThNpnddoYpqdjoEn79eWHyvpuC4
         UgC8eXdm7lH76nr9jKbLKFP3iFJTdm1VIRtVAQDl1HZkEs9i0UHsO0mxwEoFLwyRDtAx
         +5+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686298511; x=1688890511;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K/umIzeMz8geuBnQ70Zs8Lyt2KL70GKQujvQXIJTU5I=;
        b=VUsFfNg2U/DLJtWZkDrzVxuQ46/zxEWgT6bPKccOodxjn2e19gEH+Rie4YIMg2m7Nw
         yUTu6cJbUWsL3DIdoLUrv3BLoTZhqIIGY+uz30FZOCgK16Kk4FON14qbgRGhXHSErb6h
         mzkxSACMCN7LAP35NkN7+JYMROiyysCqE/5EWb/DtICuagv8lRgBqK0ACSnnqBxcw2e7
         fra/Uu2C7J05jNFeNVqwao+ZPxK4Z/JVjdngdQWSLb/jcWQr8fyv2fkqKrrf3YeN8XQk
         gcKdlCJV1wumal62loI+G6t+MjmzT0OsjYaOD23jL0zFIFTA6+jhYMTXLk4VymUFF9Ne
         OiHQ==
X-Gm-Message-State: AC+VfDzq4Jy2k852D8czaUbsemyb336c0cYvkPyDB8/MLGNWevCVdE89
	vS2KKh+EY6YoLNu9fJ9ARRI=
X-Google-Smtp-Source: ACHHUZ6BmpVI5x5ggkMD0w0VWUNdDghA2OcdaPfkM0WhYLsbQuTeAyMgVWyqXMREJl7lSLDzS44VVg==
X-Received: by 2002:a05:600c:2044:b0:3f7:e800:abc8 with SMTP id p4-20020a05600c204400b003f7e800abc8mr325327wmg.15.1686298510644;
        Fri, 09 Jun 2023 01:15:10 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id gy15-20020a05600c880f00b003f7f475c3bcsm2583686wmb.1.2023.06.09.01.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 01:15:10 -0700 (PDT)
Date: Fri, 9 Jun 2023 09:15:08 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/99] 5.4.246-rc1 review
Message-ID: <ZILfjLdOLfXkBbYS@debian>
References: <20230607200900.195572674@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607200900.195572674@linuxfoundation.org>

Hi Greg,

On Wed, Jun 07, 2023 at 10:15:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.246 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 11.3.1 20230511):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/3802


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
