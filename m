Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F949199B8
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 16:01:40 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-34fe5d0f0ffso3699255ab.1
        for <patches@lists.linux.dev>; Thu, 21 Sep 2023 09:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695312099; x=1695916899; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WU8P0CekVto2VQuEEJkIEik99UNqAGFpSJMBei3Lvvc=;
        b=TH34ZhoVc2MCFRmv6Ld8vNKromvO3lfUCClsdjPMFPCNd5OObibp+LdpWjL1cUnsrc
         U36tbJ034BiGvuMu6o0tKq6ZYpsgulkehrB3vKcbbCuJplgXxzIdfzZg4klYPyiDj2T9
         o6nxlOTrSc1WE7P6Qcs1hlvz8O9wBdreKTfwCylAyebC//YfyywZdx0SVZLrE1emsqbT
         wxZCJGBhiXnULSUsTfL/gcD+hg7RttcvTBth9KHLk7qtK6lFtakFSxy58uxmpjXIifaD
         Zp0ajLCNVTko90ScFVzDbX8sTl1nRV20GCS/58XIG9m5nv/xsJpCCUiV+kEoMRyka+xy
         woyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695312099; x=1695916899;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WU8P0CekVto2VQuEEJkIEik99UNqAGFpSJMBei3Lvvc=;
        b=VQaLvUjzMqcipucHMDoKubqyU6efyRFr5iIKaQBc7jDpfvtBIpelwYw2k+RngqHDWI
         sy9NftCK9O1YjGiIFu860k3QrzDrOLKHP2Ta8bkQNMzpvQ5bUrBs9JTHFWTdstZJsvwb
         V8tUyifqiWqC01geXt0GULhL1PuGnjOXmp57mhf5MDakxEHny5RtRicbZRAL7ALkGu9A
         u4VpzD4H7PfnPGTfysFRW69aJ1CZj0TNhYxGlgaHDdW5K6ArH5ENZh45Bhp3PKON80FU
         m1OXicVxy4IorgFD0GmmCWWZScnpeUf5IhFUAXacWBivXGAPZajeNI4dobziRUiLyzxr
         7jqQ==
X-Gm-Message-State: AOJu0YyRs1jVhYHZh3sPa7gy1TPHEydmGE+JpIVb43xug90IdijEtwHq
	wRphtDx2bhBPHZM59XBv6DQ=
X-Google-Smtp-Source: AGHT+IHEv/CSaHX/fbLRdTnOGYJa6deCdOKlP7QfQB9TdWWM2iN9gdfnXB5iVytkf1NYOP814o1arA==
X-Received: by 2002:a05:6e02:eec:b0:348:e9e4:4902 with SMTP id j12-20020a056e020eec00b00348e9e44902mr6117606ilk.0.1695312099570;
        Thu, 21 Sep 2023 09:01:39 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r15-20020a92ce8f000000b0034cabf65f2dsm505719ilo.64.2023.09.21.09.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 09:01:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 21 Sep 2023 09:01:38 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 000/110] 5.15.133-rc1 review
Message-ID: <90acb11f-a4b2-4918-8b39-0bbd2357303c@roeck-us.net>
References: <20230920112830.377666128@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>

On Wed, Sep 20, 2023 at 01:30:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.133 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 157 fail: 3
Failed builds:
	i386:tools/perf
	powerpc:ppc32_allmodconfig
	x86_64:tools/perf
Qemu test results:
	total: 509 pass: 509 fail: 0

perf:

gcc-10: fatal error: no input files

same as the problem in 5.10.y.

powerpc:ppc32_allmodconfig:

Building powerpc:ppc32_allmodconfig ... failed
--------------
Error log:
drivers/usb/gadget/udc/fsl_qe_udc.c: In function 'ch9getstatus':
drivers/usb/gadget/udc/fsl_qe_udc.c:1961:17: error: ISO C90 forbids mixed declarations and code [-Werror=declaration-after-statement]
 1961 |                 struct qe_ep *target_ep = &udc->eps[pipe];

Guenter
