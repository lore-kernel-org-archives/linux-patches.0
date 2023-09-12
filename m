Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A3F81A
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 18:35:37 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1c1ff5b741cso54296995ad.2
        for <patches@lists.linux.dev>; Tue, 12 Sep 2023 11:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694543737; x=1695148537; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h24xyAGax89KQjODi2859PpmigCup6QNPCrrNOaC24s=;
        b=OaMv1K3D2c2NuaglA726iZJSAvijCVT2+8YvAxFIJAUm1W9qrfTmBGKHD9jR7ZA+R6
         mvCkVGrtgYlP46UbS3amesoyasgpQ3lusdLK6gtjly/SKvmU/1VLjmiopcW7nivR0Wyj
         7odAD4gg1tvat+kA77DVV6d42DF6VW4IeyyokKD4EdeM1vur3VGWbZP8pmLAXVwkNjBa
         BpalPYA0r0Vahf771Z6NHDJxdH4aPRrhlJa5u5z2Hek4OTwO8uAgVMxKmS3CExlof+kV
         4H09WqHZhC+m0GJpa0VWxH73bwa2ch7CW/KDGC6fXHJ5b/9iBhHPJoc9p5XmdAhWb8b8
         OA2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694543737; x=1695148537;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h24xyAGax89KQjODi2859PpmigCup6QNPCrrNOaC24s=;
        b=oDPdRZW+ux96UXsYBG9+Kgn/CoM96mNjhb9CTzoENQBXtyP1+zx8wyAbkhvcxtNBm9
         nAwkZahCU+Hfho5ujm/JEZxpHHwzyfQ4lzda0QBbEFp/KLANW/eVlm7uuBuuMAKvV4bD
         UWHgxU1Cy9+6FOVPAtQFVGF4maDe015xNpe73j2iziFe6+ET75IXCzwDcY7AThM9G+jA
         9babTSeN/EYuWIgFD4BAk8LyvFJxTUdNSpcMcJm+ZRtH9WYKKnh6oXXICZhDiGqESC56
         9oOYz2rWCYujMq1FXQs2C1AQCxplCD5ZuwcaCMK+Jw+xOVZWPqx526k8oZOALaVp046S
         Te4w==
X-Gm-Message-State: AOJu0YzHt5z1x4klOMLMa0u5D+xu+tFkW4fwvrnMBvTWBORqJElY9f8b
	+aVI4XQ2MRV/pecpZgTgo58=
X-Google-Smtp-Source: AGHT+IEyYs0usI7E4zusi8ydwn2ENx3zFpSB+mZ19YzOMCzGIT9R1Qf3BiU1x7tWSu2xU8AmNas1wg==
X-Received: by 2002:a17:90b:fc4:b0:268:15f5:9191 with SMTP id gd4-20020a17090b0fc400b0026815f59191mr105037pjb.36.1694543736980;
        Tue, 12 Sep 2023 11:35:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u11-20020a17090ae00b00b00264044cca0fsm1402310pjy.1.2023.09.12.11.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 11:35:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 12 Sep 2023 11:35:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/600] 6.1.53-rc1 review
Message-ID: <ca95eee2-b776-497a-8c64-c98d016d05d5@roeck-us.net>
References: <20230911134633.619970489@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>

On Mon, Sep 11, 2023 at 03:40:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.53 release.
> There are 600 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 529 pass: 529 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
