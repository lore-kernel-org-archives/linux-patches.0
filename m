Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8F43C25
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 12:15:22 +0000 (UTC)
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-4f60a27c4a2so6320069e87.2
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 05:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686658520; x=1689250520;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sCn0G1jAnb2l8Q0t3TTQQkzbNPgWAe0+4F+PNu0+i5U=;
        b=JvBdOhW6oGIW/DglOocdvFBfzz7v/c/7iafIda4MlyDs6RqoB+Vn8mTDKqxKH8H8QU
         yNKLgzXcEg61X+wdUvh7jho+5P0gXvtGdUikaXBCDPqfDBMgvlyCU5FTWZ1C4gWMnwlA
         XGAR8SnFCw4RhWHvwoKM7Uc4B8m8QqgPZmEDyzrsvgFmjEEPcn3YO4qV9XxEx3T15kNH
         zg+1cFJK4CuKniOmcXiNaqz02UYo52k36jVJj+OKLSKJuE4f0+f7aMQIK4yljav6snv+
         h+kGY27R5CbXoRcDTAC7q3eBOJ0pqJUJSL3d5jfUMNJYWl/AhHVqgk3eMasB7R2Kxj6A
         iRGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686658520; x=1689250520;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sCn0G1jAnb2l8Q0t3TTQQkzbNPgWAe0+4F+PNu0+i5U=;
        b=VoT3u7IG3SaqUF0ZRY7Q7ixKO+PsG82bMxPli//LjqZheufXJTqZcuZ5N5aS6ahn53
         ta8oOoTYYWa7AeJ6B7GRZQpDwm/pKajPaxS/4xNJOJsBZxpcyzZESUF1xMG7aN1Mya/T
         nbhmL6aMt+5hjXdQ2k6bDz59NcwwkUKdni4csi+820hWRQjM5/xR9FjW8tQtKfwaMrcD
         msXriMjBooP74o4+m9WF7WgHt6IWEssI8p7SwIuRwcBbAOvVPY+umtp0GhPUuW/oxHaS
         Rkgnin0do/rY1E9fsoBJwzBY8ZruAz90WZtHlqP7XRbDfP7yLDXqn5YKgKvgW2n3EREa
         ETPQ==
X-Gm-Message-State: AC+VfDwF/+D8jU1GaIYYn89QMntvKJTGTs8QQcvPnOrocbj9g8U2JDFF
	v2Dzn+YVUWy9VDjRi7kisC0=
X-Google-Smtp-Source: ACHHUZ5lYQq79DmjmQHtNhpGflnqbhW6uPcONxEUF8x8NFBH76Yyf5RnHUpKPfBAWteZVOYieJWk3g==
X-Received: by 2002:a05:6512:465:b0:4eb:18d:91de with SMTP id x5-20020a056512046500b004eb018d91demr5624773lfd.43.1686658520220;
        Tue, 13 Jun 2023 05:15:20 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600c290a00b003f819dfa0ddsm7061913wmd.28.2023.06.13.05.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 05:15:19 -0700 (PDT)
Date: Tue, 13 Jun 2023 13:15:17 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/132] 6.1.34-rc1 review
Message-ID: <ZIhd1WKf3SpKaVx2@debian>
References: <20230612101710.279705932@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>

Hi Greg,

On Mon, Jun 12, 2023 at 12:25:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.34 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 12.2.1 20230511):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/3920
[2]. https://openqa.qa.codethink.co.uk/tests/3922
[3]. https://openqa.qa.codethink.co.uk/tests/3921

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
