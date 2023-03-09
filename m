Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0425C284
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 19:52:46 +0000 (UTC)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-1763e201bb4so3516142fac.1
        for <patches@lists.linux.dev>; Thu, 09 Mar 2023 11:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678391566;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XWQCnh1x5+krXU93i8HgoSaF1uKg4BYDXFBKy+L74+8=;
        b=Ry+xObfcK1uOH3V2pspxGgO5Skos+sB2LZ8Z+7up+KxfpdewG9Z0Y9TGciBDSjWGUA
         7+dBGoCwGGGNpJhUDGQYUMuJhpGlSDyYbT5vnkNlHYFMF4zMSMJaZ6zBXNSz3glBcAjD
         uQZENBkA8T9WpK+DG3Qta2j9to+s25mGiw26Xo7UvTjhfesH+X4JdOHvn17N/MlUzrJ4
         VnSMx8TAK2rxKeg/m9upDFPqqBxDl96XExNhHwCbd01rYg6d7YWF5pcp0eBA8Z0ydGfv
         b1lI2XtTry7Nge/Ugf5jVTZmihi6Y59NNjnqwNAuEAAC7GsE72U8uZari6tNWgSWx22Q
         osvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678391566;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XWQCnh1x5+krXU93i8HgoSaF1uKg4BYDXFBKy+L74+8=;
        b=b1mPcRtD3IeEj4wmKF6ZwhYN+uW717ndn+tCtCxdH4FCO6Dch/nUKGb4tBsVqzsRvn
         72kgAvxFV8YUpJRgmdmLSXUViOKyiVbaXsvP/iI0FKep2ZrUu0KfVxvAiKBxm+e9zINc
         qvMLqm5cljDoSR3D1Z4CmTCbnTQbOjohmBgnSpx6kqcUPgOCGD5zSZJLnpwSWbTP4sVO
         1NJFk+CVXhzDcOM6Ym5yFfZdd2y3TUPvK2L8XHG5WY9j37IhI68TwtMil2pWPFEb8ImV
         clc1BGFRFBC7vvDYkt2panhe6PjTmETlW0RwqA8b3hJKUeSGPoSWLshRt791B4m4+2q4
         Kh+Q==
X-Gm-Message-State: AO0yUKVkT1JXPS1f1Z/R/M5ODr7AFi3/dB4ufQoUCZbNgHkMQWRZexi9
	flBjbUmVwPGJ27WylXRyu1A=
X-Google-Smtp-Source: AK7set+8qJ0xreXKo6gMhxrSUyU+a/gaVme2i0vyc7OYJ4R0Ki6IE+sJkLywCeoiVpW8ec0CgzH/KQ==
X-Received: by 2002:a05:6871:5c8:b0:172:289b:93c5 with SMTP id v8-20020a05687105c800b00172289b93c5mr14269520oan.0.1678391565922;
        Thu, 09 Mar 2023 11:52:45 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k19-20020a4a3113000000b0051fdb2cba97sm60206ooa.7.2023.03.09.11.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:52:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 9 Mar 2023 11:52:43 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/570] 5.15.99-rc2 review
Message-ID: <81a8e51c-153d-4f11-a222-240e9a532639@roeck-us.net>
References: <20230308091759.112425121@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308091759.112425121@linuxfoundation.org>

On Wed, Mar 08, 2023 at 10:29:40AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.99 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
