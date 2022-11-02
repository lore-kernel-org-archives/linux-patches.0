Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C3227708
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 21:11:43 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id c2so26359plz.11
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 14:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3M+sHlNYCN7sAislo/RH+KZwpXxxsuThJWN9NTi3ze8=;
        b=SKbTIb5ZUje+04Fxqgi2dCCsr7GtjbXxYcezZeif0u27dlGuWqRqi5yFkoRVYKptH+
         yfUq72SnjZDBCdjU6toqyKvUSWHW078b9tp62Dkc88bOOrLV3oUwh3waPGb8uoGnZJET
         BdaHYCC6me2kAf1Iy6dgLb1YQVlwU88J7y6csi+CFooXQ696GsvJCv2GdtiAgo/U1buU
         VvRnApJvBEb0U5hyNbBHLrDTqa6+Poz4vX32Cv4tKjWWdQR1a/nJd+U8RuLCopKGuHOT
         2xayw/2vLA7METj+0ZiKp8ZrsVUfF6c7cA51cdSxYCLBPrsoK9uIxHfQCh9ogAambfyI
         Ymow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3M+sHlNYCN7sAislo/RH+KZwpXxxsuThJWN9NTi3ze8=;
        b=3x7yrw9hFHcfrvGrx2ceCvfeYbufKZOaraWBDU4zomiTBX7syhFaf13SaNPs9GLzrF
         gSt3+nd/x0f4kEWyaxvbSNc7fXhVl+teRxVMWF1e6Vb1Dq4QAPk2/YH11fh38j6bg4ZX
         MdOpXE7MsvO/5yy++rgOOx3f4hLxCFZhlCOghQLaGC0XNYvHG9cABfts/Fs42fPTlLjX
         KTCkA+Ikebw4C2Yz4RDtmBjTNbVTjBgs+g7u1TwCsA+lzNwCWd7+6nTakDheiUCc+t4j
         vHcki/D43U80KM5KMCUBOkxeOCQduamO0WlPlbAEWbe5wNPtbN30GERwc7NX4HkseVhV
         +xeQ==
X-Gm-Message-State: ACrzQf1NPvZvpT+POwCVLaiofHK1f8EpCqjDWnSTihgitWgxvgkMf7Nj
	HQ2VIeajXZHa62CBjm3J/g2HA0v90P0C2+UOmLc=
X-Google-Smtp-Source: AMsMyM6x23xn5X6mPDToUVYK+WYedRKZPDS7hf1oCwc5mKjgz7COMLSfdhFZUOtlOSLTbI7vmEZfBTwfJeLGHFLGSZc=
X-Received: by 2002:a17:903:1211:b0:178:a692:b1e3 with SMTP id
 l17-20020a170903121100b00178a692b1e3mr27535486plh.48.1667423503511; Wed, 02
 Nov 2022 14:11:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221102022059.593236470@linuxfoundation.org>
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Wed, 2 Nov 2022 14:11:32 -0700
Message-ID: <CAJq+SaAdQOtwnRTaT0nOxtKHJD17O339fV6atmyTs_u5-wyAkQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/132] 5.15.77-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.77 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
>
 Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
