Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C462F8820
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 23:12:35 +0000 (UTC)
Received: by mail-il1-f179.google.com with SMTP id l15so7466852ilv.4
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 16:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679440355;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aT9QAWb2N3Cl9PNqz1T8q5HyOZdF/U6pbqVGEeaogMU=;
        b=XMHbfGp6KgnR9xCfDh7D6f+AWv+93I0dCBfDAjqyD07JFT/Uq0rGSkr/r8SVucF+Sm
         1FgvkU5K3mClxt11T1aWICszr0+7QB1QOTLfbzqAmkDo/jFWT/zVHPhhrV6rqYUArQHo
         bjcEk7oD9yv0oHomC/4QqrtZPJkyUQchZPouNGA5TdozkXUotM23WETNNegWCPUnCENN
         7Mdrk/YoD7iwDesU7O1KhBBGfqUOvNQZiqZqYSsSKdoUBN2knAUh54fS1gP3Gf6mzxV5
         BRmTEH2WEu+13l0FZsDlOeFlBKJY/u4gFuAYtW8Ba/gAO0G4XU8Eu/mPB5D0XtCggu/h
         QJEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679440355;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aT9QAWb2N3Cl9PNqz1T8q5HyOZdF/U6pbqVGEeaogMU=;
        b=ufGymKHn+paY5HpTAqIP9jO9tWkgKWEB8d15MGdsnbzOAfKppqb5lyXDV0ZEmeH1gV
         GOLQBM941dIJogcEqobo/SfJ81dm0+gJoslPB6XzJNA1ZJJLb5CTNI8t2PMf/FMFas9K
         xWOyunwMkI5F2fmoboOr10QPS5wBRc1+Ch3/uA3FenGMptJ/VTdTNxLUa34tBfmfj3ZJ
         wO2ROD+ku0Iv4GBEfocs1cwZAlk2kC/7bR34EkqN4MPlQewuFQ5LHD4h/fCfyhQ4WjsE
         moMSMItLUTn6YJnAxcH3qZckQcM0HNUaLR0SzjBEPLfO1wANRUvH3kNrXh5mMTfXakhc
         2KyA==
X-Gm-Message-State: AO0yUKXI538uyiiIMkyaNbNrr787WPFGEKJPSHfSiTp6cWPDrHfamlDs
	teKvvYTAEViqpDBAceVMlEY=
X-Google-Smtp-Source: AK7set/CUPlNqLHXRRkRwnqohqfZBGWTyduS3uxVJc2LJwQu2wPQ4A7pf+D7otm254JsLCRgq3/4LA==
X-Received: by 2002:a92:d78f:0:b0:325:b9ac:9451 with SMTP id d15-20020a92d78f000000b00325b9ac9451mr707349iln.28.1679440354694;
        Tue, 21 Mar 2023 16:12:34 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s7-20020a056638218700b0039e5786d7b7sm2810138jaj.18.2023.03.21.16.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 16:12:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 21 Mar 2023 16:12:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/30] 4.14.311-rc1 review
Message-ID: <ec3c43eb-ff2c-40b8-8078-53cd28362e0f@roeck-us.net>
References: <20230320145420.204894191@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320145420.204894191@linuxfoundation.org>

On Mon, Mar 20, 2023 at 03:54:24PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.311 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:08 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
