Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608061845
	for <patches@lists.linux.dev>; Fri,  5 Jan 2024 01:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FD1zCFnj"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6d9b37f4804so79933b3a.1
        for <patches@lists.linux.dev>; Thu, 04 Jan 2024 17:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704416704; x=1705021504; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+dH+F/QKQH6E1OsUIiJJTGUViUA5WXNbG9cweobn3So=;
        b=FD1zCFnjCk+uI2s2rV2HT87XzW2qkwhGUjpMXMd5m8N98GaWmHWDNsV3qS+UIOQoaN
         ZX3xehszZT0PKqH+iXtgZ1CRL+iHq2H1bvLPFHi/wbRjYD83Q6tVzgNYlt3a9MjhaHJJ
         33cu+6WxSt3etEWN9mcdgrnSF1ifTkZZbOP66GXrYpBaVIrAefW+eQ6+GKjeDx+ECdfr
         PuL8uWB55T6vplnaf/ilc/h9X5dL31FyJinDR6KLCv6UKj4PA149LXQPGLk/pdGN2oXg
         lGMeeaPfpz5n4ha/fq60w3s/psu8Wm6cJNzKqp3+LiVcRqob545rYP3OqJH7a7/6XjxD
         X0gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704416704; x=1705021504;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+dH+F/QKQH6E1OsUIiJJTGUViUA5WXNbG9cweobn3So=;
        b=xHnXoxCJ+JRHXLLS2QSymbk0ic05hW3lyqKGyzQvf9BajgIUkza2k/PKoq7SvumJDE
         PnqcGhpvqVz/lLP+BHABNyHcwjhMiyD8fkS9jWGsUt+hZftQWyZTxl9m8zHuD4LJI7nZ
         mk8pQ3ssHhC26cYGN7fqHjwbjod8rRNWLJ+qSMAj8mxPxQuRlsHJnUVEhxdB8/KnfU8J
         roh0/8ct9Iyi1omI4GfW92gnrRCWshtTX5lPVJd4ltNqOr9/l+P1A7HTujGzJiaYSl6Q
         zj9EKzHT2wyT1gt0N3tyMfjp4DBIimkleEnU7Jypj9MNqLBD+Mpfj7J63KKshbNwFDMu
         6shQ==
X-Gm-Message-State: AOJu0Yzl2XHrXeIYrAGtt76DlMpn3hK0XFddfuB0CRmz7mqRkwWmDp/K
	SCQMTPUm/0iZ69C64rvhZro=
X-Google-Smtp-Source: AGHT+IHJ0ADFw6/58wTNB8QD7JMLXWQZA+eOoK9PfRVDPGM4RVjsunisoFAKyY/PwIu53W0h04dHYA==
X-Received: by 2002:a05:6a20:6320:b0:196:1b73:3bbe with SMTP id h32-20020a056a20632000b001961b733bbemr1148206pzf.63.1704416704564;
        Thu, 04 Jan 2024 17:05:04 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j5-20020a056a00174500b006da8f6650a2sm258580pfc.155.2024.01.04.17.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jan 2024 17:05:04 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 4 Jan 2024 17:05:03 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 00/95] 5.15.146-rc1 review
Message-ID: <b5532cee-6e11-45b4-9157-f2c3de331e95@roeck-us.net>
References: <20240103164853.921194838@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>

On Wed, Jan 03, 2024 at 05:54:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.146 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 524 pass: 524 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
