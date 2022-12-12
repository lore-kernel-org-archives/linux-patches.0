Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5326FC6
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 20:21:22 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id t2so10294034ply.2
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 12:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+2Gol/W/vrCkBFnXmVYWrTmzG1dFrYwfn0LfkKp3QVw=;
        b=dz3c2UhZUInkpt3Imw6LrTTI/SKv2nCAj1lwVwpseUjw8FiPOFPPhk/FLhS4g4+1eV
         b/cZ2MG3Gd3VWU/JiDY8DdvNHTjxLqVoYa7ZJ4U+4wATTOG8N+b4ySv97ZvlUE1/IPKO
         hGOsT8Nmqm8GlhZF2QFtdKoL8Az0Q0Axvm2gpsP51BIJSwYtprj1KyMeyZI/0o8mnltc
         WZU09UAaCqRV45FpMK+MyRCAaMwgakEaILjPY4YA0k0ZP6vRlrIIoma0mRbGL0PVkJho
         6AfkGV6JoHpYRtiuLcgu02w6/yfZ5GApRHm/VudMhbA7B++rYgx2NGKFmYnciUlI5C98
         k0TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+2Gol/W/vrCkBFnXmVYWrTmzG1dFrYwfn0LfkKp3QVw=;
        b=WR6CNjUjSU3MpBnZkikGPxQxgtxLkfsx+oJyjZMYf2CBcIDmxNs86whxuqmcmLaApN
         kVQ4FIlg7qFZLBlBt4tt/dTJedT21Ziddc1gEaMeeRZmgWSQFwb5TIsKE/P9Yk9TQIpR
         IerkBaEckQ13Otb3UwiiPE5xmcXHWxFjBygKKStEdHJ/2NtAaXgcSimhHnETIQeZQH80
         fgNDJLa6bkupkE5amneUM5j7/HM0hCiVD28EtrVnpXLZOrEKwfFn1qfE0/DzWXYlkfSQ
         E5ZtEo8hw1ZpuFO7OGroWqOWn0BlNAvrJsU2XfAeQ4hXf7Vy4Q6HYYUsVvojrzIN0zWj
         9KMw==
X-Gm-Message-State: ANoB5pm4z5aq9yd1fV/juVrwRCXmFmlVqMnpqSxDKNVAEpiiAXtYo7TI
	KI55sqvtOCHwE3A8jQ8lSg102ELZSNViyLAxU0DKaQ==
X-Google-Smtp-Source: AA0mqf5EDTFf7Lta+JlVNQNOYeNcWvG89NdL/KjJDks+33xbbjl98uIFJc4VZhz50PLmcRGlQodl9nipFN5akmcP3HI=
X-Received: by 2002:a17:90a:740f:b0:218:fb5c:a762 with SMTP id
 a15-20020a17090a740f00b00218fb5ca762mr31716pjg.241.1670876481712; Mon, 12 Dec
 2022 12:21:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221212130909.943483205@linuxfoundation.org>
In-Reply-To: <20221212130909.943483205@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Mon, 12 Dec 2022 15:21:10 -0500
Message-ID: <CA+pv=HOANBfmAqBLi4wyeejs0W1BsZtbhcHqsNmhs2WA3YxGzQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/31] 4.9.336-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 12, 2022 at 8:55 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.336 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.

4.9.336-rc1 compiled and booted on x86_64 test systems, no errors or
regressions.

Yours,
-- Slade
