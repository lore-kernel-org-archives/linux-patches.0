Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903A279C4
	for <patches@lists.linux.dev>; Sun, 31 Dec 2023 16:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EP/02qpD"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d427518d52so41947115ad.0
        for <patches@lists.linux.dev>; Sun, 31 Dec 2023 08:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704040436; x=1704645236; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EoRqjvUgh8JU685KBdBRezA/nzCz/FKUz4z7zC2ePDk=;
        b=EP/02qpDS0JZiIBDkFvp7Ap2T3MlEh4eYkXVeEf4kINLrmlB6hPGur1vjqCFs6w2gt
         13LHEFplYSML5itkqUkbPslckHdrIZ9RxeZa5APmUfzXkCUUAsQwvq0WDk7F3WlH0AWi
         ViIVYRF5lJzQ7ykcU5IQyT41uDkQr+391SjTtz68gHTgWZzlPKUzHi+caiQdh5xAsXAf
         rywaygLMkBxoRlJ6erW2X//p+dYZXblXkqAPABkXVPLMFG/YaUqtI+G0QJMQZv64jImf
         3tnMSP0RaLDPJzI3nV3o2IUPDR2vn7hO8Un4F3FtXtxxsUlf4EwBx2FIHnMYEDd7ditZ
         zOPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704040436; x=1704645236;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EoRqjvUgh8JU685KBdBRezA/nzCz/FKUz4z7zC2ePDk=;
        b=kFzytkL5P2SqagV091ThpDNFnKkhkaNsDhjvbZ8KPcmELd2UiKQktJpIveMyalpBll
         kX0YfC3IbLJPgdnbg3lWtMAiyUnd0GQXPB/9jlEdgkVHpyP41Xobrs0EJCQk0/PXtLKL
         umiYl9ZqTWtlrxffbM/uroFQQH1A57bI1Vqebytgq9fEBgatVwhvaxvSUM3qOmmHmBYj
         PO41HIABPQzGi6oJ/vKruelVDe2AgNbLT4usL/axeZHAR804/hnLll7P05i4QjqKyClr
         9cSXnwk6z3MCIWT3FzKp8Vk5S/Gsy1REl4XJt+Km55jxJXWQzPnTvkt+WT3gftx9Sh4T
         Q0iw==
X-Gm-Message-State: AOJu0YwyGRZgY+/1CnX3QHYNRSO1ZQ6UrmrLVvJLFPs1Ow36YDb6N8ld
	bFyY8ECr9v+TC7vTrqvNki8=
X-Google-Smtp-Source: AGHT+IHgL5gGyZDuBEhl14AgPpSIdkLnqgk8VZzGiZbirzfA50CFCKnOtDvmGuvntYuu7oPq+LX68A==
X-Received: by 2002:a17:902:ced2:b0:1d3:f344:6b01 with SMTP id d18-20020a170902ced200b001d3f3446b01mr17882203plg.3.1704040435686;
        Sun, 31 Dec 2023 08:33:55 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u10-20020a170902b28a00b001d3dfebc05esm18812619plr.21.2023.12.31.08.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Dec 2023 08:33:55 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sun, 31 Dec 2023 08:33:54 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/156] 6.6.9-rc1 review
Message-ID: <15cdead7-b9bd-4531-9222-3d41d2989f7f@roeck-us.net>
References: <20231230115812.333117904@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>

On Sat, Dec 30, 2023 at 11:57:34AM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.9 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 01 Jan 2024 11:57:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 545 pass: 545 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
