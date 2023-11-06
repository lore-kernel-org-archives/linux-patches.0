Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A5B33E5
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 19:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OFLAxnn7"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-27ddc1b1652so4401114a91.2
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 11:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699298086; x=1699902886; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BjfMvuwNwCbN01EOU/kgUhQ5Db+LEXDJHgnY99KXI80=;
        b=OFLAxnn7VduD/kYkw2BeKDpw/Jm139ujvQFei/MkyFMqoJQ86Wr2NQO0550d6z3TkC
         7fEfs2vOoNFVbAUPnqgWqa66OZ0kW+mLGmxdr+3p1BVtlOe9JvacNAFmC2PjlHJZzE+m
         mvYP07DBmKigitrYUK2YsrmxhmzRyexUVYWHN79Xjd2AXvF/fu3AM8mcWdgPEv0PN/Dk
         CXRnJ5Yh8Vabe1pJPXQFX8RwpmevStj2EuYquRxjq+Ka49OyvqgV8+QL1D9FiUaVYXk7
         YcCjR7yEPqjzXgps2C6UiOGzQOi+MeWLYMdomNvzcRHO4VCCrZDRMmB4LG/5y1BGNJPV
         44AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699298086; x=1699902886;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BjfMvuwNwCbN01EOU/kgUhQ5Db+LEXDJHgnY99KXI80=;
        b=iZqdrox7yiKBsbRwVZ9B+1jQ7gltkEIleniva1XaSCc2rE0SVd1aQOnCok5Drz9wk8
         uNrvhEEd6rV2OoFIACePzR2K1aB3iKXRYjZIdvN2QxRApi4ELJnoK00o01JD3lk8HLHz
         CQl2wN3holIA4ty/QJ5A3T29w1aRjAy15L0+G2mIQza0HYAvDBaE+ZWh0rFkJ7PWJhYA
         KyEyDQoHdM+HmG/UsK9KJ+7okOdHNeLLyIAiPzh6nn7S9D9hJkhTuukv2dyIlbG3Ofby
         pNwLFc2evX91J6hAKIBgQZCCDShdB8ODPp7HQIKEyVru1I4ErZK8AKVdKkPHPEchcs5o
         OQOw==
X-Gm-Message-State: AOJu0YxXEzGqgR9/yEmbRk+flP/lcp94YTT0Xryo9L/DJv5mJ6O7Wkht
	neNah37dpyWtwTefMr/Wxpufv2udw77KTcqjAFc=
X-Google-Smtp-Source: AGHT+IG0wwbQtoWmqA5Czskad87T0bV50UldJpeLWxZVbB58I+00z0I6QkKffEoj1MNniHfiFo2sdc/rE0gjIs7KsJc=
X-Received: by 2002:a17:90a:cb8e:b0:280:29d0:2c6e with SMTP id
 a14-20020a17090acb8e00b0028029d02c6emr23351427pju.11.1699298086269; Mon, 06
 Nov 2023 11:14:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231106130301.807965064@linuxfoundation.org>
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Mon, 6 Nov 2023 11:14:35 -0800
Message-ID: <CAJq+SaAh97zV4xwgxVbKqYZY4ZL7qnBufYzMBnjRehWn13iT6A@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/62] 6.1.62-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.62 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.62-rc1.gz
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

Thanks,
Allen
