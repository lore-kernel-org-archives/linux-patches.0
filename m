Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9B92C726
	for <patches@lists.linux.dev>; Tue, 16 May 2023 09:12:05 +0000 (UTC)
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-3f42b984405so54282655e9.3
        for <patches@lists.linux.dev>; Tue, 16 May 2023 02:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684228324; x=1686820324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aaoa0fYi/eKZjvnkX5ryATxZDZXTxrAGQl4PfS6nayQ=;
        b=r0g79SlYpHPiJyjO+tMkzIcbafl1Fqx+pGWn9NTvt0GP1V/kmvkm5eo0AHhrph0PGG
         8EuBgtfrQVNW0rzlvrCiY5dToX4ngBug1OXY8iDdxO2v6ppAvsDuKtX3/fJkDW+c8TA3
         hZPj0hkIuAo/kpe/txtvB5jRzmRhniHF/eluMvVm4/uvDRmVhnK7fjLiH4xnlYWm13RN
         w3tzSwWTj7934LTZRoa5vIWVkiWn/Y0ld85eDArerxYFNwTMrZiCg1tSlfH4+syeheVw
         6DAo7SeMKKCVXCHG+g5MrSXoalbbBu3epcWM4m5EQGqtxNFyraYz6ZrZssKh7CKGiBWy
         gGOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684228324; x=1686820324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aaoa0fYi/eKZjvnkX5ryATxZDZXTxrAGQl4PfS6nayQ=;
        b=g6flSklVX5QMHZJ142Uc8mZUxfODHgpLrswaQJ0ST1dCeLhdaNYxFnYLscJrtb3p1V
         iZA2gdf1z2qQa0OAnOx0l3ZGpb8JvB8W3L0UyMYsOOt8FNiJZV7+3yZOWMIG4qXkAAu8
         8vNX0KrerVSDMS2t+uVJ0sMdI4gM0pnXwArv5HkPjDHaMyUdSgVYmSNgbASIXjnNVCQ1
         5jneyZNq9s9Sd3JhTJV8KAWmZ4KqDOosATDn9OT9AqBh1kPMoPuzlODchhQ85tCoWynd
         iNMn9CV+neTZEa9cJiiPMyjNdWCaCDCR/borAqnZDRO3yb/+rgA5JdjP14EY8mPEou7B
         9T8w==
X-Gm-Message-State: AC+VfDzmIOZvmfLcLevjh9Os9QpZctmI0mEiS5fSn8sdkjk1hIigZa36
	Q+T+3jV/vRklWLcuTfDfr24=
X-Google-Smtp-Source: ACHHUZ5UmGPABv6aBli65iKjKR1PNtrcM+N9BOKW/B9/gd9mSjf+GAaxcp4MBDgKIVkPhrFEt+SpzQ==
X-Received: by 2002:a1c:7507:0:b0:3f1:9acf:8682 with SMTP id o7-20020a1c7507000000b003f19acf8682mr23295633wmc.17.1684228323628;
        Tue, 16 May 2023 02:12:03 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id d8-20020a1c7308000000b003f1751016desm1601921wmb.28.2023.05.16.02.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 02:12:03 -0700 (PDT)
Date: Tue, 16 May 2023 10:12:01 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/282] 5.4.243-rc1 review
Message-ID: <ZGNI4Q0K6HyU13eM@debian>
References: <20230515161722.146344674@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>

Hi Greg,

On Mon, May 15, 2023 at 06:26:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.243 release.
> There are 282 patches in this series, all will be posted as a response
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

[1]. https://openqa.qa.codethink.co.uk/tests/3528


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
