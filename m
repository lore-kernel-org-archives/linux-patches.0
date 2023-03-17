Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7833A20F8
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 10:16:54 +0000 (UTC)
Received: by mail-wr1-f52.google.com with SMTP id r29so3912141wra.13
        for <patches@lists.linux.dev>; Fri, 17 Mar 2023 03:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679048212;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FfXH9z2G8WERyIamgGktUjZj8sQfxYbgIgLKsc1mGkE=;
        b=dC7UlPDx8m5getrCCm+YihFdbCyC7jB5/IyK0iwAtMAqY5xaBP5dbFlDJMCb2ghbvP
         xfYwzNqjDml0s23JxtodhXSMz9wQOO91FWI9f3SXC0VsL3Xvo9rKZTF+aMDlvt8lzuJN
         +11Tvj0fwsIjrQ9OScDn46FOQTIB+fwjAprhpiuJZ03wi7JOM5vJuhmfGVCW9+zSIm1c
         AEUaTu1r4eqWzj7Vbn8ACDR/OmdTgFflN0cO8tGleofDCot5/qWH3WP/HD3yCWTVCoH9
         cJQnUCjmcpKc8xUx7vQplx0ibVADGIuQm5AMW0TzoilfXQX2gUJoUTc22/ivxdD0LVv0
         s0kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679048212;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FfXH9z2G8WERyIamgGktUjZj8sQfxYbgIgLKsc1mGkE=;
        b=16sZZ14q4kiYuEZLk/bOuoOI2r7GiGu+KmoyEBdcxmXsNg+43v4+ym5fLqJI3J+2/7
         916yIMM4jse6CXEIkEICZiFNhOiDTEigRghWP8+VtcGk5fkLHovSrz9o8C0bTxwDt56f
         QirVKfdBLO3LHbppteMVsBpbAeyuv/9VwPua9GPsjMPy5Bu3cD/05BxBzPJywZRcFV87
         eNZx+IHXWf2cfJn87x/dVbdO6ak75HDXAQNN6mVI2l0PZMCEif5pJIFFciWqMUKvHSDn
         ieEuXHAA2dIUUWoQvVkraYqs0k6Wdq3a8QN0STRRwiDrWbUmbVszO1CeopubBhfXu8bV
         9j5A==
X-Gm-Message-State: AO0yUKWjjeJSorO/KFqWw5PZ9JLTDKXV4LvQwSPU72wpGjKfoa+VBabB
	EMOgIoz/zZ0hcUt8yofTCRw=
X-Google-Smtp-Source: AK7set/3Bx/oRAuleWjyhvnFFlnoKIVqXnriz77IvbmfZwrcXOGgfyPdw8FB3pbNocOteCziq2CYcw==
X-Received: by 2002:a5d:6902:0:b0:2cf:e8d2:b550 with SMTP id t2-20020a5d6902000000b002cfe8d2b550mr6400189wru.14.1679048212523;
        Fri, 17 Mar 2023 03:16:52 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id r10-20020adfce8a000000b002cefcac0c62sm1629334wrn.9.2023.03.17.03.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 03:16:52 -0700 (PDT)
Date: Fri, 17 Mar 2023 10:16:50 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/91] 5.10.175-rc2 review
Message-ID: <ZBQ+EnIXd7z73DzD@debian>
References: <20230316083430.973448646@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083430.973448646@linuxfoundation.org>

Hi Greg,

On Thu, Mar 16, 2023 at 09:50:03AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230311):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

Boot Regression:
x86_64: Failed to boot on my test laptop. Only black screen.
Will try a bisect today.


[1]. https://openqa.qa.codethink.co.uk/tests/3132
[2]. https://openqa.qa.codethink.co.uk/tests/3143


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
