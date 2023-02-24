Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05599197
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 16:43:31 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id bf15so6919646iob.7
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 08:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HY2UtiVyvy/vKybfSDlvC0TTjuRRDl4x5K9/kfOfLH4=;
        b=RVS29WlY5AX8PUbJxXE9JjyjaWIGBBA283l8jXEPdRnaEfcyBQepFOvjsxT27r7G+o
         +5coBIYlgsmLlwlWPu8y41KffhrRA6YyIdtAmmE9qp2LNgw8RL5gI+BlG8vWAsvz/c4m
         qhcw2KiBJEvzMxsv+1mKHUxADQaozy3ngXp31K4y9qSiW6uwrlWyl3WUSN6nuNF8qXDN
         MGJ4W/5VOXJlbiX9brLirW3FbdxKL2fjZTyC75M++biKjqmiOzVmRtxAMx3z6jeAN5hO
         p5ZNkxwsfJZfbF0wTuJhGFfgWkFxBlBSTVVhJBJix3BfTheC3SN7PPEMN4RGdfvtgN09
         8ghQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HY2UtiVyvy/vKybfSDlvC0TTjuRRDl4x5K9/kfOfLH4=;
        b=jeQwH0hCYojhaD1OCRoRQzSNpGP7xShSCU9r7yKVhMrUYWPoPwFOldoyly0SvTXHN8
         n/oYDV16FAxYZ/3e9R4F4+M4mQJX6GwhRlHSSudRvzbvlXgIWISDgOlnpOXJ/32cWdOL
         XSz2rgbIqWg7u2zrOS0+rx46xF1YJ25Md10os9WM0IDTLa+HAlf+jU4GQ3ywnvThgkMX
         nnqebGLO6+f1oxUq2+XiflNEii1ObM3GgQSC7MFmjMJPARYR8p8Cd688N4koYLqI8Z3g
         A+0/kVEM8dMBU3g/Dpioo0cyRQBu+UKvZ6sjS9ercQpkmhI2uiXoC6ampAp3gthc6lqZ
         LaeQ==
X-Gm-Message-State: AO0yUKUPzszhdbLWRwEWwiCaqNFLuXnRLHwwQG/zPD0WDghGlJU7/lKf
	XT3vk21sWCfFU464lTiOfJw=
X-Google-Smtp-Source: AK7set8RKsZYElYJA+05Y+fgThPxM20kuQhIHsExgSM/L/sVlZR3XgK5v7nltYzSY0iS+kCMFLnk/g==
X-Received: by 2002:a6b:f712:0:b0:704:b286:64c3 with SMTP id k18-20020a6bf712000000b00704b28664c3mr10222682iog.16.1677257011050;
        Fri, 24 Feb 2023 08:43:31 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o4-20020a6bcf04000000b0073a312aaae5sm3333108ioa.36.2023.02.24.08.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 08:43:30 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 24 Feb 2023 08:43:28 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc3 review
Message-ID: <20230224164328.GA1223038@roeck-us.net>
References: <20230224102235.663354088@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224102235.663354088@linuxfoundation.org>

On Fri, Feb 24, 2023 at 11:23:55AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Feb 2023 10:22:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 492 pass: 492 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
