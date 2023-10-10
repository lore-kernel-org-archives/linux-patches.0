Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B74225A6
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 18:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mRL+EsgR"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1c8a1541232so26415335ad.0
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 11:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696961979; x=1697566779; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nVup/I8HGkRjJMex/HjbVAuSvuvoEQIVY8MSOxC2piI=;
        b=mRL+EsgROvCORPT2jFGiVYvvgV3qo19lv1cmt+L984Wj7j0RV8+sj9VOPJB7hu+nIz
         JQLQVTKkLDu5Mqk2THn51PgXefIxULYDxf55mR7fzdZv/imv8bEr7lUVZj/K54VC2nXr
         Gh/8hQp0HjlrgiakgESnazh7YHrOc3raLN0HsV+3A3y0nSctJXkdz3mhhnE/wV/ghT1U
         kQu04qUMWYktMuA1v/x3eh4ZAqmqcq6w1rMJ+R/U6I6mnON1hNGNgYF2MDA7lZ8dS2U/
         R6ZtG1Q8r/hGfouubWn4N2bCotj0ebF+KbFYbcELPcnFrSRTufUDxBU8jnmoeR8yDzMW
         Rurg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696961980; x=1697566780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nVup/I8HGkRjJMex/HjbVAuSvuvoEQIVY8MSOxC2piI=;
        b=GyRZ8PVVP+4rEcih9FYpD9z+oyoU2JMfFyqE+cdSx+MSlfQhDja46cTghUndYZ5HI8
         xYmKqrempan+ZdaId+gcffsiHXIMHmAsV/GJBA5TXwuFC0xnWQ6jbUhw4/LqhrC0uXyt
         iEeBkOU4DDnSXDNHzzx+wFPhZdp3sVGuiX0rIVbc7nIibSOoKOkodiunvfC7KvAEPp01
         8S4sRvSoIF4ApDwGiA9De3EeMfSgOylcjxVGyMnJUHde2hWfIpY69gb1B90UWeaEKHcG
         m4HDC3OlIKhQORE3CsgQ7uXSM8W7bXfPKogzo0WUin1Kf17G7wmutQ7/9v90rI7Pox9a
         eRwQ==
X-Gm-Message-State: AOJu0YyuIDLA8PTPoDz68FlgThErJAj2w0H4bVgFJS68peFMdzmifaSa
	u+HnWKKYJKw3osXunWtS+1M=
X-Google-Smtp-Source: AGHT+IEt7h9zLR9p5Auap+Z0WvhSVJdUH6h2nUn2eT5FcqT6CUOLqVXFyw3IqM1U9k6LgC2LGVi53w==
X-Received: by 2002:a17:903:110d:b0:1c6:17a4:afae with SMTP id n13-20020a170903110d00b001c617a4afaemr24114475plh.4.1696961979692;
        Tue, 10 Oct 2023 11:19:39 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 5-20020a170902ee4500b001bc18e579aesm493990plo.101.2023.10.10.11.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 11:19:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 10 Oct 2023 11:19:38 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/162] 6.1.57-rc1 review
Message-ID: <3da68535-2b87-4901-9efe-31481a97922f@roeck-us.net>
References: <20231009130122.946357448@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>

On Mon, Oct 09, 2023 at 02:59:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.57 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 529 pass: 529 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
