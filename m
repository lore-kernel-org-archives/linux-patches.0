Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877AB10968
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 19:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jr1/pDSJ"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5ab94fc098cso2012236a12.1
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 12:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698087953; x=1698692753; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CoXVo5DxTAi4EBRQZDyqhjyxY/df+SUG51aUayqk9HA=;
        b=Jr1/pDSJL7i1JR8n1hRaXWPh4Nrca6HVfxdh7H701jd3eWqTpSU6MfulmynbnNS5fU
         OfEwmtSoNjypmw8Y6vBKtUQNIaiOS5g6Nxb5BMCn0ZI5UAVgJP+2rP+/KxSQDH+8x3dk
         M00Y0LcaKxObsRkNAyRoUWmcQdKCJysfb1HlnK8FxLbakyTrrCg5M1oRqeib89+s5LvM
         zTYaEpBKNpr5O0HWmU0jVm/unJkRSpWasBwvgnlpZkAZayqmiHQ4WGOB29djHyNBt1v+
         DPNULOs1YvHeZ4F86tHA4MdGpZGl1zkUIQVuYGps97GAlO5SB059otLqlV44yeNRErb6
         QEvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698087953; x=1698692753;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CoXVo5DxTAi4EBRQZDyqhjyxY/df+SUG51aUayqk9HA=;
        b=fg+wiee0ujJRXkz7sm3n+XhnUr18rGXsMu+iFG+2PKr345nAzhmUFK4GExYGDPVHwa
         pOFS1Toqha5YGk+wov3euvphLXjntGJ3Y6GEJLyHnnQVMhU11dzgQ6cqHcTCeaYn2bio
         m9ylRePYv27jrLYR5Ey+8WK5kO/BB5IHlqPwew4VKeiPzUiiRZK1GKWgKgH12cPdgh3P
         Bm++WfpbIs31KY6FeWjnEb2F3ShrIph9YYFd0whitpiH6cYQF0lUxh50I4aIs/A93oeD
         sRt/3kr3cGiAvsrHMZsbS0pYTOjDHbaacmW5DfpX3hIlHCzcg9JZ9Bron5HuQpgF1p8w
         T9bQ==
X-Gm-Message-State: AOJu0Yx74ewoX7PU4b/7LrHhX19l/5IauWmEGBNocqvhuQpEI9oNGhYY
	AZf1/BTP61ZV0uBF+rgjrpSH9aGjVso0A1OT5XQ4XHr7IDN6Kg==
X-Google-Smtp-Source: AGHT+IEmjuv59mNMB6QoRW34CgTQjFoFjhRKl9UCcPWJj5rbo+evs1HNpQ1eApafLDhOh3rJGbS6HnyW/D5i5doBuk8=
X-Received: by 2002:a17:902:ec8e:b0:1c9:dfb8:a58f with SMTP id
 x14-20020a170902ec8e00b001c9dfb8a58fmr9595524plg.20.1698087952872; Mon, 23
 Oct 2023 12:05:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231023104828.488041585@linuxfoundation.org>
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Mon, 23 Oct 2023 12:05:41 -0700
Message-ID: <CAJq+SaDPXFvHfmEGzbhxtPpqPCt-HHbvGyMjFWrTJWJGEGV7BA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/196] 6.1.60-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.60 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.60-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
