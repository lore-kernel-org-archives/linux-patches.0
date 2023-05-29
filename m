Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C4E747D
	for <patches@lists.linux.dev>; Mon, 29 May 2023 13:48:10 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5289cf35eeaso3137005a12.1
        for <patches@lists.linux.dev>; Mon, 29 May 2023 06:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685368090; x=1687960090;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sbFSyfRcHjKjP7DsBh0HDWun6Z5NhHLqrv1Cu0fSBmg=;
        b=A0zcVJWZ1hYG248bC25y4nx6Z7Olu1rixcosAZpBx5A5x/Z2OOVs/rAYnHqvlKupA2
         smjqg2/W4h0qr5UVVhuFARK67LvCP8XmridfdYC73JzLGW0AeEF+C+lLBKPKSwu68JXW
         NWP/+IyuG2ZP4nrFqHhaXW+gKRywXIuW0XpUqZZvU0TjM7oovvLZtFUNkfBsxHTz7SyO
         jU8keQrs41graqzFA7kK4z1ALDKIOwZVyonHrPUp6zOROAIas9BGC6ZLMzYCTjGRxKJx
         g/NwnyN7Ops4LgwSMfbiGOPgu81QU52U9Pepf5Yr48agfTNZPf+fRISUC3pUNwB3r4Ab
         HgKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685368090; x=1687960090;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sbFSyfRcHjKjP7DsBh0HDWun6Z5NhHLqrv1Cu0fSBmg=;
        b=Ari3u9iz2VjOOT2EJ1DaGI3IYJdPAsrSn/CGbkNsvp9LALiVUfoC1Oz4lKJuuhUk+A
         ye0tcPXoNYfWJpXGzWSW4CORkGqKjMrGQXPMCXUPDBc2/yH+V/RkrN1YdmXDlv0O1YNe
         HZC+ZEEFfLZLjGsAx5gALtAZJWWjDRln026FFcZC830V0l3c9YoIO6CEaebjN61c0T5J
         Nra1O4v4CFEMmdtP8oHHl87meoskp375ieX7iDoDTdI9Q+KaPzL0uPjHz4Mphc1CepkA
         q3l/bpf5sY3sSS9h/K/TyOctZRjNZKXP1JgU8R6OCy3JHrrmhsHT+PV88x8Mz3FjQUlg
         lMTg==
X-Gm-Message-State: AC+VfDzQc4F98EoxMrRzt586usM811SMn9KdjrYwOFrKAVYwNlS0G3Eu
	obct8Jx/ILfOS+4mhFqcXtQ=
X-Google-Smtp-Source: ACHHUZ7M2hQvQWZjhae42ciJyF8vZr6ju+Cd6K5d5L7J638XOVQ8Q1Xq+jDC8WWdSuXG5wPzncCoYg==
X-Received: by 2002:a17:903:230b:b0:1b0:3ab6:5140 with SMTP id d11-20020a170903230b00b001b03ab65140mr4622115plh.4.1685368090378;
        Mon, 29 May 2023 06:48:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id jb18-20020a170903259200b001ac2c3e54adsm981300plb.118.2023.05.29.06.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 06:48:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 29 May 2023 06:48:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/132] 4.19.284-rc1 review
Message-ID: <e98d3b88-980b-4487-baf8-4685cfe62209@roeck-us.net>
References: <20230528190833.565872088@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>

On Sun, May 28, 2023 at 08:08:59PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.284 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
> 

Building s390:defconfig ... failed
Building s390:allnoconfig ... failed
Building s390:tinyconfig ... failed

--------------
Error log:
s390-linux-ld: drivers/base/platform.o: in function `devm_platform_ioremap_resource':
drivers/base/platform.c:97: undefined reference to `devm_ioremap_resource'
make[1]: *** [Makefile:1061: vmlinux] Error 1
make: *** [Makefile:153: sub-make] Error 2
