Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822DF1078E
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 23:13:37 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id d14so4826317ion.9
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 16:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679440416;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zcm9v+PGW/Q19peCi8fchQeimPfAq6vwMy79sQWh09I=;
        b=gutqzjN7URlUUK2yMHhP3MuP0Qd5lyScN3Vk/+i4xlNPPQbd59JuzufB7uYFpNZLzz
         5gL3x1P342AE2H1dGkz+G5P/qK7ynE5KH1XWzxFTAw2Bb86VNFXQc5nFpx1TeTg88x9F
         nEzp7LGyvnMX6zJDgz4oZdL3V+E/HhBAOpImh81q02M3hk89fPuNaIh+UI6Y9nBhqleV
         OrXJC+oiNvB2D0wXouDGXXp8/9RUufwPvIuA5qZ9Up2cMtnL+Q2N9zrbpsdLZr1w+2g1
         Ts107DjWxTxT0qgZ3x0aaKKUhDjjTTQIyzRGxXGX5fpDTAhuILzwZW/+nH2vF4tsyUE9
         8xgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679440416;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zcm9v+PGW/Q19peCi8fchQeimPfAq6vwMy79sQWh09I=;
        b=xOu1+Dpx3RLHcddvsveGTpGI9YXXBpOvzHTKOW8NX2fEaHGHcNuJIEDSoGSNGaIrqH
         6mthtCEvdm6RO79NviucB+yIQXeJwUSzayxm+6Xj6XinLEFRydkpso/vRp/AX/wTifxB
         pFb1jWimKG47tArAAaNh47NWXUbD6Wg/yf5bDocTZ/IO3jcsgHQNwhwhGoZyIg6ZI0qn
         F17dmVd5lBBawp2a/VUCnVTAFvQbINNwQhL3D25KWCNUYEhXRI+aiBF5l9xj7J9HFrz8
         F2nUM9Y3WDy2i99JwFa45xD9igzM2dCKXTKWpyui4wFSpIKJ3Uzf9Ku2JMZnbYDUnypt
         fxFg==
X-Gm-Message-State: AO0yUKUR0nEXhDl3ZvlCVOk96waMMiv3ShvdvOJy7xyzU57AKhVO3fB5
	+HWkkYhAAkIGh1U8yvFXPV6nG7g3cZo=
X-Google-Smtp-Source: AK7set/ylowbRbB8X4g3HZNlIgBfkTkRz70Wyh8zR0IuDT3LlQeV1sKBQH5PLkpuEVeMqYgVnspmSw==
X-Received: by 2002:a6b:7a01:0:b0:74c:8b56:42bb with SMTP id h1-20020a6b7a01000000b0074c8b5642bbmr190425iom.8.1679440416619;
        Tue, 21 Mar 2023 16:13:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m24-20020a6bea18000000b0074e3d8e8e13sm4081145ioc.45.2023.03.21.16.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 16:13:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 21 Mar 2023 16:13:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/57] 5.4.238-rc2 review
Message-ID: <1d86c213-9948-4fac-b783-d5faa547276b@roeck-us.net>
References: <20230321080647.018123628@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321080647.018123628@linuxfoundation.org>

On Tue, Mar 21, 2023 at 09:39:06AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.238 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Mar 2023 08:06:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
