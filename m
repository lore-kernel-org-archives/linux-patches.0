Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C6B7F
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 00:23:44 +0000 (UTC)
Received: by mail-oo1-f54.google.com with SMTP id f184-20020a4a58c1000000b004a3c01646a0so1492149oob.12
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 16:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eKYxCw4845UWrKxWlr/gmTKP2dA8kInVNKwK2c576sU=;
        b=KmbMPr/2L2lmVlM0Fbay2dFxyPaBtGdbatmPpl7GOU0GqJLvxApoSkLWO3usESmZYK
         pQdieVE2dO7B1TBTMAQdf85XIbkqWWDeW/eEnSsk51pbgbu/JiIXAcP4etyXlWnIBJnY
         Cgxf/LTwP83jWcyOAStAf6NAFHnnmmMgrMN9aJ7X2hi/N/PvQPSyBgAfSIbpHpuxURrt
         Pxqu2SzTgsIBvnP+R/jmCizN5AKepF9zJt+N8udPGaLWnR1Cab78P4UJgrm8d85Lfofu
         xooUoAK5W5WOKjYK7S4a6eiykBEPpmC1CNpO7KUvYefofpLDIfli3oV3IfP/8WGD+iqH
         RVrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eKYxCw4845UWrKxWlr/gmTKP2dA8kInVNKwK2c576sU=;
        b=rQdTyU39PgX7aeA3ZTzGOufuwEf5PIHdsFaswl4tLpuqPvSDcQqyKNezP8Kw+BLN0f
         t9i5X2Kl04JhpyeM/qFktHdJuocqNWy3u8QB442s/r83aM2CxXygXqQsQoEytwMiq+Yq
         VpxdaWxvivzFC5t7/TuSfia3Cx4lRK08rwm07HRfCwBAwFI+qIX63wzyUkHXZnHQ5SQu
         izeNaextPlkhf0lULEEde6324nnzVzqf63teY0Z5C4SH/0io2uJV3Q8Bm9Mj/ehphwCn
         89dufWGdWLFI/zdBFheeamweo2dnnFqr9sbO/VVLB7h3aHo7aiUR9OC40MzGSmpVdHQk
         /Opg==
X-Gm-Message-State: ANoB5pl1CJcPm6AcBjH/iJ7rWOj4077TEckY7XO/VoXrlC7+81e5dtVC
	Lp6kdzvdqb+iZQA5lfjUqzI=
X-Google-Smtp-Source: AA0mqf4IctTlXzYNplyKEUYBmYMZIoMCpS3BMHO5P4yu28Wk3E2byaCSM+AiwLHTG/2d4FxC2AtLzA==
X-Received: by 2002:a4a:b445:0:b0:49f:f5f9:ed7f with SMTP id h5-20020a4ab445000000b0049ff5f9ed7fmr7415135ooo.1.1670891022027;
        Mon, 12 Dec 2022 16:23:42 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k15-20020a4ad10f000000b0049bfbf7c5a8sm524757oor.38.2022.12.12.16.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 16:23:41 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 12 Dec 2022 16:23:40 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/38] 4.14.302-rc1 review
Message-ID: <20221213002340.GB2375064@roeck-us.net>
References: <20221212130912.069170932@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130912.069170932@linuxfoundation.org>

On Mon, Dec 12, 2022 at 02:19:01PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.302 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
