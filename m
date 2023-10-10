Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FCE225C3
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 18:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WGLkhCGz"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-5789ffc8ae0so3920787a12.0
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 11:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696961873; x=1697566673; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zSVqlZ2QCY+q+P0NY4Jque7YOngdew2/5/sX2viPqJs=;
        b=WGLkhCGz2ATpWwVSa9Y578j0nYAqC4Snki0hUTppzrTiUBRa8SLmkz5ghyU15X/yl0
         6JHx3LDnT3raJqdYtjsrgOnSxNoVD7nlNoDwLr0tN6unuVYW893EL8kva2PBH1vlclo8
         MSCKoK2rBdwuPU0TDk2wL5xh39wRtrIyeadwb9qNuIDXJ5ftrL2rl3+suRGBQRPKCM4C
         06rpGWTMRnD9n3PrsabG+qz959XcImTbhXFVqNO7A1fSH1vrl1ULz6M8r/MKvfFdKSI9
         w1w/3PwFVDj3zpZvmQGufO7c3Epy4GSuchUXhJPoNqh89aUdP+HETACmEB/CvAY+umsI
         h1sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696961873; x=1697566673;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zSVqlZ2QCY+q+P0NY4Jque7YOngdew2/5/sX2viPqJs=;
        b=YxfcyIuMxr4UfUmrSCrNPyxVeEsgLbc5fcHBj50ZKXshj62+ZGZH9/e/TX/wUSDwTN
         88q/a/rvtngOsoH5mxDdPnLddkkri+9d6Gl4A7B5y1F02tJ3lexT0a+7wa00iksI3qOH
         uEXKSkwENlUdtqXG63QahXErq9zHf5vWx0rZQy3DtRtdlsBT+Ql7v5i8+qDiBt/buVIx
         jXK4vERd5jmZOS6MRNNbqhxJAwKEE6advCP1+DrOUPatU7OOuxc0puAUOvRN2DkAmWB+
         7BlYkRSJS5I9xVgoeMcn2PMabRVzQAsjKEcH/yfTkzcExCPn64UZNZBbCZ3PFhD55MBX
         zaXA==
X-Gm-Message-State: AOJu0Yw5FW8Jm+gP8LdDrOvGfkS5PSCJmfiJ4sv7BSb+58d9M9IRlWzv
	pRF5jZGwoCK4CWodpj/DhO4=
X-Google-Smtp-Source: AGHT+IE5LF+MegL0OYswGhEirUxxAiyTuJATRJ3N2ByD8855jj0Pf8wUiUJQ9tgMVpEM2A3U02D6HQ==
X-Received: by 2002:a17:90a:950e:b0:274:8be8:f767 with SMTP id t14-20020a17090a950e00b002748be8f767mr15907087pjo.15.1696961873147;
        Tue, 10 Oct 2023 11:17:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id pc16-20020a17090b3b9000b0026b41363887sm12295693pjb.27.2023.10.10.11.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 11:17:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 10 Oct 2023 11:17:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.19 00/91] 4.19.296-rc1 review
Message-ID: <2de5ccb9-39d6-423a-bb4b-bbb094dda746@roeck-us.net>
References: <20231009130111.518916887@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009130111.518916887@linuxfoundation.org>

On Mon, Oct 09, 2023 at 03:05:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.296 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 149 pass: 149 fail: 0
Qemu test results:
	total: 441 pass: 441 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
