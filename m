Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D320FEA1
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 02:03:47 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-792707f78b5so172121239f.1
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 19:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693361027; x=1693965827; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jMNQ9Jfk5H6z6bxhcK2xh3Qd/m36ZZ9zApc5wXHqb1g=;
        b=r7OeWc7MEdxF2pWbbVsfm+y4LgzWnvbBPnJGKyIm5DvBPzLVEy00FwsUym9ogbiSvc
         LLDxp1bW7/llgvCKjNjGky2nS65DBcnBWBgv2twRPqgP2jh/zCgNQ4ADrGJJdSP9k2gv
         2SBhUMdrlYRgdbbxQP+f6klrT3GaBGjgZHSCowmQ1rA1LWCcqq4MYROWBRKsaiVqINZG
         jJGqq5lYjcL+kmkMndZcb+q3unMXX0WtTTG/KmpVKXtWhicfoPessijJW8U5fYtx9VlH
         k6soOwqzoPjv2PaUUxeXYdGmTC4dPFrECPRK5WOyLExQVBv7qt7sYrRN8OZhHd5uylaH
         uKZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693361027; x=1693965827;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jMNQ9Jfk5H6z6bxhcK2xh3Qd/m36ZZ9zApc5wXHqb1g=;
        b=fV4HvC7D9WhIq3abIY4qEjIQeGPh9MAuDyiS/9EI8k4UYsdQ61kQE3aFbFF+Aim2iH
         EWqZtUTOihI2DUgP3mcmPh/qT76A651QHZ5prVq6NlLQDoMIaxACqmYb6cZWIBTd9CUM
         zZZwP5ctv3xGPR5HSiuZb9ZBu3TcF7SQk8RJpDrh+/o/BEZgRD2DcxpxjFqwLmiK9gkp
         bp5i0e6TqENW2Wy746qbU6n4VjhJ65NA8W1A1TUw+xcfO7lG+BB84VIj/z+Jfz6+tCEd
         WzcoW78b8nyIJsCKX0EI7jZZYM/EZSJbWOWC0NDofcTdoxMF+ltW2dIQiIdNoRIhemPT
         YS4Q==
X-Gm-Message-State: AOJu0YwHK/y4zYT6U6tgArE0Hr5+ayY+n23R8TPuHYS+/3FShkXwJzOG
	NlPmH+0u+y5a5mKQ/8KTuAU=
X-Google-Smtp-Source: AGHT+IG+tltkoe7RqfgP/13MOOIV4MHC6VU778gu/Jt/HySabHuqeD56STbUYo3oQM1RrY5ogJlcVg==
X-Received: by 2002:a05:6602:474a:b0:795:2274:1f3f with SMTP id dy10-20020a056602474a00b0079522741f3fmr146983iob.3.1693361026938;
        Tue, 29 Aug 2023 19:03:46 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id cw18-20020a05663849d200b0042b149aeccdsm3560022jab.104.2023.08.29.19.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 19:03:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 29 Aug 2023 19:03:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/122] 6.1.50-rc1 review
Message-ID: <4d88d905-51eb-407c-bf7a-f390c5ab6ed1@roeck-us.net>
References: <20230828101156.480754469@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>

On Mon, Aug 28, 2023 at 12:11:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.50 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 521 pass: 521 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
