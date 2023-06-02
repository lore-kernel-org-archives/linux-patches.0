Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106231365
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 22:33:53 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3980f2df1e7so2121288b6e.1
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 15:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685745233; x=1688337233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wJtFZPHY3MGVr+9DX8nPaWiMw0hM/7qSMyJJSj5f3GU=;
        b=JTYpHL2Zd+/ADHGN6l0wYbuYTELLHOM5zRgoIoP6S5hBK52uu+drS10+JhMZvbSFMt
         ZVfIvX1TvY2LdjjriYTetweAikwNAVE4MujYV2noWbFsn3SFuzF4j99UivdzGKTsKA86
         YOaPNz62x779P2cK7yAzNx405RRKanbOskY/DuIAGxtyL3PYfESQmAX2C8C656dtLOCQ
         Dh3PnkcbKXRuqXnX0Wfk5dLrCQnjjg1AAzZ5P87yp2U4nTvFUSI2b2cwE9a/B1nqoHI8
         icZBMnB6uyu1U4+wb6lZZxZh9g+9CA57BMWZzcSB8XQ0FnTwTaGjoNGzyzEDRC9MZStN
         mQvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685745233; x=1688337233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wJtFZPHY3MGVr+9DX8nPaWiMw0hM/7qSMyJJSj5f3GU=;
        b=eTgk2m07TXGjiu/eqApNmK2/CYrCu2jZGSioAFRE6EsEhATwGeS9uV98D1ie5xHkfW
         x6zJgwqyG6wQFt+M14O8ggovgmyfNx0PGGR9s//voQdBbuItrAOzdTl+NLol9ikDikm7
         UC6lR7vQttHkvHCNYZwlh/m9T+cNaC5GHIUd15av29til7UCCNdobZGWxi9DwDl/YbN8
         SMTWqh8VBmULa7yn8aZQh6dN1Y7DynrMtcFh+afO87KLf/Ikytf1hptbUF6plJz14MTI
         I1IDsFfadd8QZrCncd4pyiIlG4mGD48ONK+zEgt1cDFx5Nry2xhU3N/6Pm78NV1ygXXI
         s3LA==
X-Gm-Message-State: AC+VfDzQfFEZytM2+8oYJyy4wu0eVINKzLE8Lwck1zxGViYb/YCDMw71
	HxS8wS4M+EW3IVP8boKr964=
X-Google-Smtp-Source: ACHHUZ56/4rheRxPYByafkdjKLl9/nvdKD6Fq5YsLQn65EIyVQxinecVmTCs3U36mxmLw0QvNUAW1Q==
X-Received: by 2002:aca:f18:0:b0:398:2a8a:1e02 with SMTP id 24-20020aca0f18000000b003982a8a1e02mr1320924oip.45.1685745232865;
        Fri, 02 Jun 2023 15:33:52 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d17-20020a170902c19100b001b0358848b0sm1839375pld.161.2023.06.02.15.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 15:33:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 2 Jun 2023 15:33:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/16] 5.4.245-rc1 review
Message-ID: <c6bee3f3-412a-4ab0-bb9a-983e029fdc5f@roeck-us.net>
References: <20230601131931.947241286@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601131931.947241286@linuxfoundation.org>

On Thu, Jun 01, 2023 at 02:20:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.245 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Jun 2023 13:19:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
