Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B17A17FE0
	for <patches@lists.linux.dev>; Tue,  9 May 2023 17:02:58 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-24e09b4153eso4359408a91.2
        for <patches@lists.linux.dev>; Tue, 09 May 2023 10:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683651778; x=1686243778;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dzB6zXeLLyFlCHebfFpxWpNyEmoL6v/kG0Zxv4l8LgA=;
        b=mutBSZXL9ybuZwzsxpgW8DoesXa5uJk4VDj6zD2pz9V9wTs0Lcn8DXS/EZnEeufX3V
         truznYxiMZPv9kYK3N7iOyAgOWuK1LtrCrSxxK/S8F8vETAuw4p/cPn28WoKfmcZEl8W
         fHa2PtqTTmh6JRVc9nPpUZUCuqlwdp5n9o3VOh9AxjyEk9JZsXJXQdAyR5jy7RKSl33t
         4VMzPtIBQpu0mi5SjFq+oFhHyvU/0IrLPCYx+x9U+G/yGgHi/TEsgcrYiQ/RRBy+GKlL
         7qJfma0rxZbOWyHm8ugpP+DTkh8PCpl8o+fvGBROCEDgjPjt0nNFBl6bZZaOlhul6DHM
         A3+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683651778; x=1686243778;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dzB6zXeLLyFlCHebfFpxWpNyEmoL6v/kG0Zxv4l8LgA=;
        b=FgAbw6TNHx/rI2zA+zFE/H+kgqq7XGDVCCMUrpNyBhtJaAVCyJhIYBUd/OQOOe3/pd
         hAD4cGW+HmweXJ0fX/UWyRgbTDdJdAdqt3ES66dj/Uk3X5WzHKjTQp1c5/ILJbYKaT9v
         n4jkB1bO9IPRjEr6sbHHfjI9bIrjZVcOgIU8OVlVI5DDCLVriXjMD6T6UhB8vUhbf20X
         GnPS7oVXiV8JBKiFRVDJlRCd45pEMel8YN4+5+lmeb9439OfrOyWDilnZ5VjuBR3CCEo
         T83QD17amc2aq9FOE8oY+j+6zwq1izCIyHi6EmdXr3+a37/pwE/hlCWVW+GjA/Pga3H9
         UFKw==
X-Gm-Message-State: AC+VfDzxRTG9marNO73rh+1HOM7NfaBuKZXroL5zS2sE8tyAwULePqrp
	1YnNWEzrfrRLzB5GpDxiilm2+VV0r5BvQ6n3LJI=
X-Google-Smtp-Source: ACHHUZ46/Bn1TTRRMmux+tpvAHmZpthxAfGAEUENhehYrsXm+f+TSVdLGdpFquvt/x2zOEfW9F0ybEuGDFUX5s1S3Gg=
X-Received: by 2002:a17:90b:4b4a:b0:24e:3316:bb99 with SMTP id
 mi10-20020a17090b4b4a00b0024e3316bb99mr14471863pjb.5.1683651777920; Tue, 09
 May 2023 10:02:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230508094421.513073170@linuxfoundation.org>
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 9 May 2023 10:02:46 -0700
Message-ID: <CAJq+SaBaBEU63Ch1shuvK8k_nifjPN4M0BCc5WB55KKYqJUV7w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/611] 6.1.28-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.28 release.
> There are 611 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 May 2023 09:42:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.28-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks
