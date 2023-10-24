Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6D17461
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 08:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GLdJmkaE"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-507b96095abso6279526e87.3
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 01:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698137924; x=1698742724; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R3ukY78Kprvb6C1LoI+nPL4aI7gxBNbUgQKPAJ7OQLE=;
        b=GLdJmkaEE2WqQg8AHV76vD5uj32gcwEn5vjonD9DsFzSeQnv45ZTb1gPgDg5BihlBg
         XLGN/R2QFxhwLtTWuPUCyarbGbjkIm/nymBCuR0Ap9fVEkF9iZzMTmZTwLu83V999eUO
         +GpBRufh8bNoyiw4z8MSmAIUqhQkIUJh2dKLHLVrcVN0pmQ+7AIdPnjQwyxiP0vIXl0H
         j+tcN9RpKn70FvTzFs80nc35nPfZlcqox1rrhJuNPX02Ah3bywYivAh96tWodFx0QUA3
         Zz7316Z2LrsVoWSZ3ux2Uw5J1ykzLKYOhbpb0FRjwu4viUrmuF7f5Er3AjOar3Wmc3ik
         tvag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698137924; x=1698742724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R3ukY78Kprvb6C1LoI+nPL4aI7gxBNbUgQKPAJ7OQLE=;
        b=Io36OwqVQAcA+lqew5ppklgxpIj2QnX+piNdkWk+uZlW5kpM0LYa7V0UO0HAemfA6y
         5CSfjp/ufyQPmjosNikbOOtfRrs9/VJySKH7xdzxJ4pMj6DQtPKpAzH4s/udJltVNjZm
         806stf54QTaTZtz/OVM0XYDorIkGXyzZNE0BgpINOiIjHupdciOnpoYY6RBJB2HtXjTZ
         JZA4IdeI8N8Bl6y9J9RmHI1gyFGz7HfCk2ndtZmFQyY78FyFfmv2E+UFEK+4KZAKH7Kr
         kmp/zMpeXh7efEAzMfSsggPbFEcQ4pO9Ktw/jzf7lVLN7S20aVCaYHer59erbJCJ73/F
         aGaw==
X-Gm-Message-State: AOJu0Yw1Zro/NPPRxI5IdwYRVjO5YaGnH8qgq3suAB/+2+ApXscuo+oV
	COZibXG0BS+3nF/7TMDmBOI=
X-Google-Smtp-Source: AGHT+IGYWqD3rltla/ILn0B3w4VTLRUMK+wO1IisM/F6AuKk6mqaTE2sXgcrkONCvmhwF1KdG+pzzw==
X-Received: by 2002:a05:6512:ac3:b0:4f9:5426:6622 with SMTP id n3-20020a0565120ac300b004f954266622mr10094777lfu.69.1698137923908;
        Tue, 24 Oct 2023 01:58:43 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id t22-20020a05600c41d600b004083996dad8sm15997945wmh.18.2023.10.24.01.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 01:58:43 -0700 (PDT)
Date: Tue, 24 Oct 2023 09:58:42 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.19 00/98] 4.19.297-rc1 review
Message-ID: <ZTeHQl8avxkq5Kfq@debian>
References: <20231023104813.580375891@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023104813.580375891@linuxfoundation.org>

Hi Greg,

On Mon, Oct 23, 2023 at 12:55:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.297 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230511):
mips: 63 configs -> no  failure
arm: 115 configs -> no  failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/5351


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
