Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20E012DB0
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 12:02:53 +0000 (UTC)
Received: by mail-wr1-f53.google.com with SMTP id v1so1909503wrt.11
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 04:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Avvv7NRvku7zvyizHbN8B9ExE8lCIMUiZYQSaRhLeWo=;
        b=Xmnjw0mG/ThpwygD5TA8lP8tXz3wGo8gMaUAgaFGm7qxDjd0sio5SwlKiPPsg4rG69
         /jF9UJ3lrpcQK4Zgq1J10uAHYltBaDtZoVFxMrJ2MtUPYOgOzn6ZP62/j8gzjpKKCMRI
         dVOjXrp4bNZGnaIoGtgl7Nl2H6YjqbdF7WNmlhobd96nr2cc+zZT4PCF8gLKiMh8WtsL
         DEA31PMZ9b/aWTl5/WrqRUnI9QHY3X9fv4Sk2B13yn4BhBwzzNgaZ1i4evWctkeTYqVE
         ik2kjc1lIDIAyx6+9pMygNQ9c9AOwlMk/blucYFWPQMGNsP1AHQJ1eukhlAiIYMHKiEn
         PwOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Avvv7NRvku7zvyizHbN8B9ExE8lCIMUiZYQSaRhLeWo=;
        b=Ncmi92BxzvJH3MFJ17PknN/fsWIx7bqI2xVFphnZ6Y3yQixk8oGK2WUQrfCF97Hyrc
         HIDuduAiPubmYCs96JyaPP9Z1I2fiMK3+M/RrGtdCzeFQV0yJALPq+QZ8yjSwFRMXGJx
         IWcfkj0VELbORpQgs6lDC2/gcukQGHbqbAJ/OpeiC0DXU6W+d1Q2INdCEkauM9iTkOM0
         6XGE9T6/jcU3ooqKRWF33wtY1gXXqJdc26ez4ROsQSZm5JLIkAxXVRQUBclnYN64DkAK
         Xgs92qySUfpCmw50PQvnxeEiYtYBbeBRUYdmZnM61ahYRUOiutzzc+MvdzROA3yhTOuR
         KySA==
X-Gm-Message-State: ACrzQf3J8PAS7p4Vd6hkYQ+bkbe6IEWxG22u3SMfMFHXpwfz23GFbTME
	QO/HQjhb7JWIgn6+bIKYw40=
X-Google-Smtp-Source: AMsMyM45PjxHkkftJgBg+V7naw2V8wpbAmLUTLj7z87KH6UOtWUN9cVTI4B30lQr0dnHZHieQpqMGg==
X-Received: by 2002:a05:6000:24a:b0:236:bc3a:48b2 with SMTP id m10-20020a056000024a00b00236bc3a48b2mr38913563wrz.495.1668081771820;
        Thu, 10 Nov 2022 04:02:51 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id j7-20020a05600c190700b003b47e8a5d22sm5607828wmq.23.2022.11.10.04.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 04:02:51 -0800 (PST)
Date: Thu, 10 Nov 2022 12:02:49 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/197] 6.0.8-rc1 review
Message-ID: <Y2zoaQsn8tARua/n@debian>
References: <20221108133354.787209461@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>

Hi Greg,

On Tue, Nov 08, 2022 at 02:37:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.8 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2129
[2]. https://openqa.qa.codethink.co.uk/tests/2135

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
