Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46107B3B4
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 17:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cccTy2ko"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-1efb9571b13so3767704fac.2
        for <patches@lists.linux.dev>; Tue, 12 Dec 2023 09:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702400535; x=1703005335; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qoqQk2DmNjPGewPO9m1lqeM/IXVqiFBd3DSgwHMPKp8=;
        b=cccTy2ko1nWqBKzRPnI7n/rKaLMX0wfidQ8+qBI3g31lTphoytOVBzlEqV4P3YH7rf
         XIGojj7ahhyVxx6tYj6imCeB1UafZdBJzOu5PeIlKcRfGMgPrYaEwlSQArMFnQcs8hen
         malh5wFo1JvvLQC5qdnRuxOEanOpZpCdaXq+ZNkbJlMbtKVC+zu3V6c11Yg1AB46eTV0
         3m1L2EVnRa8/shrofj+AD7ZXXmVEqfNi1EYJtah9QFJRLqkYGsXO+0723TdIsASWrVzC
         DpuzeF8P4tZp8+SZKgBzwiaGWbQ3y6Ld0i6c+Ol7mv5pOuiSxKIsnIuuvGTc1veW1vw3
         PwLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702400535; x=1703005335;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qoqQk2DmNjPGewPO9m1lqeM/IXVqiFBd3DSgwHMPKp8=;
        b=ABvnQ4ULYqtYZfwJdW9lqcAhp31W2UdztMgCwoMPJgSjyUddg17gXBn8LtekKSKW/u
         vhmAk7m4tJfMvORbr0N9QkgC76Av1HGLyz2npB0IYK+pS+yjDQtWZmg8nVgByaJ/GCdi
         Pa2N7edNaz0C0PYG/rTPRd6l0c7haks118qypWIh8vO69/CiLG/nzse8Pej7slbqZk/d
         Dlwc5CkB8DCmSSVwSaVipMDTNW9p7jIwyinlHs9/24OrsNUzwgCGbZ/+3Mn7kokJkMRb
         nmCjn/RFyqB5erfzKXDSIDsIhWSkS922IrnSw4XGcu4PYp/2fbkXB0Vw84Z+nlWm6YLZ
         ta/Q==
X-Gm-Message-State: AOJu0YxJZtfmVdn5SXJFZ3UK1ZdFTMHnJcAtN3K75ZAIa/SJjxRuAbnS
	CfBx755ZkKLeMLY3jrZHr50=
X-Google-Smtp-Source: AGHT+IF4r5BEwMRI4su0cbkDOAvMvmsdh67c/77qUVUOdyEitoEGMI1BoCTbktLSy9vPBysa16GYxg==
X-Received: by 2002:a05:6870:e98d:b0:1fb:1f51:e7f3 with SMTP id r13-20020a056870e98d00b001fb1f51e7f3mr5842413oao.39.1702400534905;
        Tue, 12 Dec 2023 09:02:14 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id gy16-20020a056870289000b001fb1bf9f5ddsm3297150oab.21.2023.12.12.09.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 09:02:14 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 12 Dec 2023 09:02:13 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/244] 6.6.7-rc1 review
Message-ID: <7962c895-674f-41c8-a7b2-3b0ec2c19e0d@roeck-us.net>
References: <20231211182045.784881756@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>

On Mon, Dec 11, 2023 at 07:18:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.7 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 546 pass: 546 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
