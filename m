Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167932E64F
	for <patches@lists.linux.dev>; Fri, 24 Nov 2023 19:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FxaCopvz"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3b844357f7cso1350647b6e.1
        for <patches@lists.linux.dev>; Fri, 24 Nov 2023 11:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700853218; x=1701458018; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a2IO8yizkwbvbCYaFuIwyJ6cSJQCDEdd8cDV+Lv5n8E=;
        b=FxaCopvzzZSDSNE8/nUo0sgnjAEyspemTaUthrWZjjDmNLcA1uUKPa7t71+cAC+yos
         9OSq0sUdtp7SvtpReKOWaflQfA/rH5bXvp82DXr/R1fanbxJGn70+lY7xPNnK8Cd2dck
         UFSDkPvQfA48YMGUrn0cfLh//xGSDJsEaVABxzDv+gWPhRQfHocK3SeKb6L2/vRmiNwS
         aQ1wOF1EKhqVcuIiI+BUrnSEbXtBW6Nc0EZfNbTxrHqQaCGM2/N6q4ooWhKtMlqi3kfu
         EjvWnpskyBlSk7gUVtpYCMfHGbOGa9CI4MFmKstLg3qEQ9HI94QNoy2L4eBzkxi/OBNM
         D9bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700853218; x=1701458018;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a2IO8yizkwbvbCYaFuIwyJ6cSJQCDEdd8cDV+Lv5n8E=;
        b=DpMp5Zb36DNTnGOv/phmfed7+f0rIJ5L4ox9rDdFoO+IBUrF+vJnVKIltk5qBBJEEV
         9oRo5GYJ95OJ0bOPnMsDi9TYWt9BXGPa3gjVLu93tqe+KGg/IrBGTkn9tC47iy/4jDLW
         c5s9NZzui3Lg6yQ9mMqgEJtkDklhg/kiMReaRDFqcUq7z+AJELQY9UP+N3BTAViofaN5
         jn5A1ZyuUPARAB3LRnsK7gd6KMYLixXXcIjNhxErJdbEKQ86Z0mzUZIvN8d/z32RU3dc
         Q1N5Rm83O2P+MlltLFEyJy1yCLpdVFPK8krJNskahBBK4JHsCPeePWzPQ6bTgTjnTDSW
         +qog==
X-Gm-Message-State: AOJu0YzIpuf70WXdVy/8j9Jf/ue0mDFWdG6RYSIALs0WvEbh04YjQmkg
	ioWEdn+sewUknt/7XY7q7F1mgQ==
X-Google-Smtp-Source: AGHT+IH/0sXZh5zqfrmOwBVpS6YXkNjXU+rhXoICsM0imj/RkzJhHK8GyS3CVsMYOcx8rQNu/MGYPw==
X-Received: by 2002:a05:6870:b10:b0:1ef:62fc:d51c with SMTP id lh16-20020a0568700b1000b001ef62fcd51cmr4609887oab.51.1700853218070;
        Fri, 24 Nov 2023 11:13:38 -0800 (PST)
Received: from [192.168.17.16] ([138.84.62.70])
        by smtp.gmail.com with ESMTPSA id lc28-20020a056871419c00b001f9ef405fd7sm467750oab.24.2023.11.24.11.13.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Nov 2023 11:13:37 -0800 (PST)
Message-ID: <d48b5514-759f-47a0-b024-494ce87ec60f@linaro.org>
Date: Fri, 24 Nov 2023 13:13:33 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/97] 4.19.300-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231124171934.122298957@linuxfoundation.org>
Content-Language: en-US
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231124171934.122298957@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 24/11/23 11:49 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.300 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Nov 2023 17:19:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.300-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We see this failure on Arm32:
-----8<-----
   /builds/linux/drivers/tty/serial/meson_uart.c: In function 'meson_uart_probe':
   /builds/linux/drivers/tty/serial/meson_uart.c:728:13: error: 'struct uart_port' has no member named 'has_sysrq'
     728 |         port->has_sysrq = IS_ENABLED(CONFIG_SERIAL_MESON_CONSOLE);
         |             ^~
   make[4]: *** [/builds/linux/scripts/Makefile.build:303: drivers/tty/serial/meson_uart.o] Error 1
----->8-----

And this one on Arm64:
-----8<-----
   /builds/linux/kernel/profile.c: In function 'profile_dead_cpu':
   /builds/linux/kernel/profile.c:346:27: warning: the comparison will always evaluate as 'true' for the address of 'prof_cpu_mask' will never be NULL [-Waddress]
     346 |         if (prof_cpu_mask != NULL)
         |                           ^~
   /builds/linux/kernel/profile.c:49:22: note: 'prof_cpu_mask' declared here
      49 | static cpumask_var_t prof_cpu_mask;
         |                      ^~~~~~~~~~~~~
   /builds/linux/kernel/profile.c: In function 'profile_online_cpu':
   /builds/linux/kernel/profile.c:383:27: warning: the comparison will always evaluate as 'true' for the address of 'prof_cpu_mask' will never be NULL [-Waddress]
     383 |         if (prof_cpu_mask != NULL)
         |                           ^~
   /builds/linux/kernel/profile.c:49:22: note: 'prof_cpu_mask' declared here
      49 | static cpumask_var_t prof_cpu_mask;
         |                      ^~~~~~~~~~~~~
   /builds/linux/kernel/profile.c: In function 'profile_tick':
   /builds/linux/kernel/profile.c:413:47: warning: the comparison will always evaluate as 'true' for the address of 'prof_cpu_mask' will never be NULL [-Waddress]
     413 |         if (!user_mode(regs) && prof_cpu_mask != NULL &&
         |                                               ^~
   /builds/linux/kernel/profile.c:49:22: note: 'prof_cpu_mask' declared here
      49 | static cpumask_var_t prof_cpu_mask;
         |                      ^~~~~~~~~~~~~
----->8-----

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

