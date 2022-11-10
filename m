Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7EF185E
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 10:48:13 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id j5-20020a05600c410500b003cfa9c0ea76so858132wmi.3
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 02:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r4lCer0ib8yS53NHws+Bg+/IpBVhxKdIhbbb9FfeQ6Y=;
        b=NswP7BHKj5WrqjQKDpq2XTXXsyeEtBBjanWeho/ilGSVsneCeUtMV2m1Iw3NT7tGcb
         O7tiArYZ49Y23Ah8SuKDp7BJuuLwSZwlgVvdTm28mrEJNaxMbk8x/WWaA+hxSOZ4NY7X
         aDZY9NqY6UkarGWJMy73oHrgpVIpXsXkMk4kx7z248luvsePkZE9xgqipBpyXwbyHj4/
         orfqhQwS5lQnMHBioRoB9QpsI6iM6/Hzq7yWP8Q5YGyUyE+A27ZYQQLxO4d3RLP9JYMl
         rZ2k8tW9Ngoe4huWF6r3f3TeBzx6FgnyZ3CHAgl9b1YIPymeH1zZeMVI9DUupkf7Qr3H
         H5bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r4lCer0ib8yS53NHws+Bg+/IpBVhxKdIhbbb9FfeQ6Y=;
        b=2/CGRTScJ9SB7vE3T+5bnd1X3m2obo2+Gcjuy96JZovOR3vB6yPTEMVNgYIKLOq0td
         4mCGB9QyaqaV9eK9MLcIvuQRpfBAfv/B/iMX7qeaF2wlYw+RhAgGflMgKgil/7+bn4SF
         AVxz2V5kLEHAuqwp6eBVuXgvVXgm8XS6Pj2V1Q+UGuGBslCieoTEtQSJxe0eRDXuzLcr
         WITHr8LAvfd9EEQmHYbkKAnB56iPwQaNeYVLir3/cMWrOTNDMmLGDjUnBSmgBCuc3bgx
         aokzc52uLl8lOYVdKKMUp4tHyo6tnnkmNiEGLWNCwHmG8shuLbpQtc3CGnWWsyqw9Up6
         9U5g==
X-Gm-Message-State: ACrzQf088V6h8UEJiX36aoTqMegSxVNsKKVe7ZZPJHYbnTQHx4zYLGNO
	KDVpj9a2n3ibJHwlLVqVXv0=
X-Google-Smtp-Source: AMsMyM4tGBAOjXlYHpbkc3qZVctPxopJbqfkaYyotAvXQhmIBEBt66Ff0mG9T4P61/bOCLH5sktB7Q==
X-Received: by 2002:a1c:acc5:0:b0:3c6:eebf:feee with SMTP id v188-20020a1cacc5000000b003c6eebffeeemr43577006wme.122.1668077291909;
        Thu, 10 Nov 2022 02:48:11 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id m23-20020a05600c3b1700b003cf47556f21sm5145207wms.2.2022.11.10.02.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 02:48:11 -0800 (PST)
Date: Thu, 10 Nov 2022 10:48:09 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 4.19 00/48] 4.19.265-rc1 review
Message-ID: <Y2zW6e3wghpG3egX@debian>
References: <20221108133329.533809494@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>

Hi Greg,

On Tue, Nov 08, 2022 at 02:38:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.265 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2131


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
