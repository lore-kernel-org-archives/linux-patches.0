Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663ADA4A
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 10:06:47 +0000 (UTC)
Received: by mail-ej1-f48.google.com with SMTP id lu11so2706510ejb.3
        for <patches@lists.linux.dev>; Tue, 31 Jan 2023 02:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Xkw9ssCWJyclisbP9nCkp/nTlcXWXM8FpBUVmi1FLp8=;
        b=F3O/hTi2OdGhVbsp6wAE3zXX4ww0RuFrx7DQFNPnvthLyF9Sr6AUdHZ/WiuFfErBXi
         alvm5XJJ18R8XqKwGKfh3/hxEv9wmqQ0GzajLZNqhVDka56IBjS57hLr27HSWPP5MePj
         LEABo7NzS5eUxWfvv752DRbE7wC9G49nVC0c6IS8TmKaBWi/NruZMJCljW40awXw1CY3
         mx0nd2zOt7W9Qb2ZKDHpKSPtfxNII/Ly+vaI9w/sLPppKRbMDnrFJhOcWV1H+RVV0jrm
         gLxGQR6nm5SG6omCh7opXFF7TtKSTdSMNyeNNwaq06Nl24wPGtsz9jN12ojdxcq5DbFj
         KUDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xkw9ssCWJyclisbP9nCkp/nTlcXWXM8FpBUVmi1FLp8=;
        b=W2X4ldyJRF7LLOflQp6VQG589r3Xz6+xJSTQX6YH0ttTQCe924Y195bS+V+f5Dtafs
         8w/SuSEo+PKg28G5855nTBNtuFr5rMsEFKeMc0Lm2i852FfnUETOgKccRldsPMslSEFo
         gA0HzaXH0P/EIDTtyvhYurmsL9rSHaL6sKl0ooHI+aGVVrfyB6YPieVAGAD/HA29tWJb
         eeoI7xrv60eS8MsclS4NlTtQ0XHtJrWzfRWK2ck2ZxLW0H6Xi+5+Cy1UHKQSIIcwNXoY
         HZLvXUCd6IhMtfWm0sNy5NuUoFCrxa01jkPv/skReuCnjXfht6HJ91oRQ3sqKBMrpsIz
         odQg==
X-Gm-Message-State: AO0yUKU2pNrd1pQaRC48sO6DTyNpL7e9CicYRSdHZ+t16MkO/TebqzCh
	ur2haQefgdA6bZ+08MJSTx7OZa7YrSftZDrta5tz0Q==
X-Google-Smtp-Source: AK7set9RfNpPl1SDeMeR6WbkTsxeGy/wDlqKFk6JaKuxcJ1m6+ZQ2J0rQE5oO9OSoJpCExplhpYOJ7Y3VUnjmnrEYQs=
X-Received: by 2002:a17:906:4950:b0:88a:b6ca:7d3a with SMTP id
 f16-20020a170906495000b0088ab6ca7d3amr1183718ejt.1.1675159605583; Tue, 31 Jan
 2023 02:06:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230131072621.746783417@linuxfoundation.org>
In-Reply-To: <20230131072621.746783417@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 31 Jan 2023 19:06:34 +0900
Message-ID: <CAKL4bV782_oo+2JpTrNqGuxMh9kj2vo-9Ra3gDpDZ9YsYSeXTQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/306] 6.1.9-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

Hi Greg

On Tue, Jan 31, 2023 at 4:34 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Feb 2023 07:25:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.9-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.9-rc3 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Nano Gen1(Intel i5-1130G7, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
