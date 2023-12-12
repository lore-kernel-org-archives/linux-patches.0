Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C1C7B3B4
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 17:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="igrh2npg"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-20316647099so52965fac.2
        for <patches@lists.linux.dev>; Tue, 12 Dec 2023 09:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702400484; x=1703005284; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3FhVzYWda/1YKc/fSv1uyXT3s6nzoViCVsvqyIDm9fA=;
        b=igrh2npgWO9nVCrcjo18YX/wn/Ybmj0lstUWA2y/Y3Ax45n81ZGficwiWhAQbw+qfp
         mctKkhKDV+hfgOGmg+nGCzD7jgeUR3XRrbBsS2mOlENSbVotXlsWLJnhPIeqKtrJNjES
         vf4A4wEVIhfKLSjtaVv2GpmQjc6cQKU6rCi6q8FXBHsK1DCsH9JWn2DWoAedtJaKcUWL
         l7c6JnbAwu762ohHDvVryUHk1vnfw2tgNtNPa0cnMLtHRKizaHp3O3+bNc6xT4MUU/Ed
         pJyayoK147L/rZMiMi1wWGO7gtwA3Vp3wip/qlK9hJHkRyizeld1lExb0YPjxpuUAx5F
         61/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702400484; x=1703005284;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3FhVzYWda/1YKc/fSv1uyXT3s6nzoViCVsvqyIDm9fA=;
        b=m6RFi5tCdImkpjwh7ZUqhje9jjRVgnG6sh0vK2QfeyVwM/kw+UDXvpJDyG2o2RJXOz
         HZsqfD1QpCdS0atO3lq5zOM/lqS4JYnXKQGOL9tUVAvnuyJ6oyYzc7KomSlPC3dRFTqY
         H8KUC15bnxsvCIHxljSldR1IEVUhNi+04KKDeyfczTJSMhDWr/Id1QGTyEN/dNzf4me6
         NKqPkVgNA0Tl5+0i0V72LxORT8XFrwdnfDIDVZEO4uel9j+yFPwUcilXShy1WUj69L3g
         tRRONiHaNKYQ3E3FlR+3XPw6P+dH6b6aYtCgVAGBZeqQxOPwx4iYrrTVVranI9+kakYg
         Im1g==
X-Gm-Message-State: AOJu0YyRDS1Z2LOPJkOq661BbTqZwqkVQ7T6lyLJwwqHFT9IvoJnYlxr
	MAgNrxjwqe//pwSEvwmylSY=
X-Google-Smtp-Source: AGHT+IFGQtN+ItUbfxXhZIMFm4LB9DC+KDHLOiUSUrfESB+fKdBZbBDRdNSBSqdGz8U2dG6mdmvS1g==
X-Received: by 2002:a05:6870:700a:b0:1fb:75a:de58 with SMTP id u10-20020a056870700a00b001fb075ade58mr7982583oae.70.1702400483727;
        Tue, 12 Dec 2023 09:01:23 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k29-20020a05687022dd00b001fb0edac63csm3267075oaf.6.2023.12.12.09.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 09:01:23 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 12 Dec 2023 09:01:22 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 00/97] 5.10.204-rc1 review
Message-ID: <687d692f-389d-4990-b678-7486c6b7ff4a@roeck-us.net>
References: <20231211182019.802717483@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>

On Mon, Dec 11, 2023 at 07:21:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.204 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 495 pass: 495 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
