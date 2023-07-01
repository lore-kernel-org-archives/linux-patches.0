Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB94315D1
	for <patches@lists.linux.dev>; Sat,  1 Jul 2023 02:51:41 +0000 (UTC)
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6b46e61638eso2114422a34.0
        for <patches@lists.linux.dev>; Fri, 30 Jun 2023 19:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688179900; x=1690771900;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kLPVDuMNu8QoPIrCuHyB3Va+xnlEJ/NgNsqkyyDjCyc=;
        b=OPEUcxnDrKfU6GZ6mi4LV50hrrWi8CImvIlvn/lA9vOnJ/aYEfKtT3LRJQci33Sls7
         8a5dFbeIL7fce4t6BXggaaWhG40EBftFZipYgkl+2TwIEwafqHW2Q+mk2DLOcwgyLtIE
         sX96SAdGOdR3mmfNXWBShZcxLvu8e6AH6zqWbKzRE6K6FE5ATus5Ny5fJk5oWzvuCGL1
         dbbJsj6VVUGrFzwvxD0DjOwe+hec2wF3tewIXYv0AD8+Grw+QOygbfrSoS594KAS+N/Z
         ZmkJN3JLVSZYJYx6PHaRBCtqSDZNa+M3j64VC5rdiWG/C9Jj8G59nc5mlMKW91F+2Gni
         lG/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688179900; x=1690771900;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kLPVDuMNu8QoPIrCuHyB3Va+xnlEJ/NgNsqkyyDjCyc=;
        b=eVApl3euXvJ7AwEeOBXCdf4k6d3nWPXJqegWoKAilsTCeeutF1DE/WcpErzd6Skg2A
         9LugJdYwUt/x/iILq6Mbf/kL94vs6ORi6z4E0pnGnXM3XfoWwKar7wlXZlOYjAuUZYXK
         xVAhaEqZ7kGVdH8JEUjlkD9vuJcw/5L0GRsZJJ/ZuebpypzCn1x3qt0ZGG2jtmy0SGhO
         prKccJQrFKic/6ABtXIURjKb1JzTtY2OwY1R+qhGnE96ouyJ3XatgCxAi8nDcjUdAmKd
         MAr+TJrbvfMzlCZAOJKedRHCGSwA/g76VEyBGhYhMgTwjOf++FjHKzbQOKRTqfkssZKf
         YP9g==
X-Gm-Message-State: AC+VfDxUysNQ1PrQdor5a218wBT/H7Ibv64CCIXiUeFUFTWgThmWOkNV
	rjB8nVIJ3dwU5NAEThPJMPM=
X-Google-Smtp-Source: ACHHUZ75LvssH6Yx3LyBVIJFhCpmgOUIxglC/nRzy7Wt7L6yiDHPk9/ZNXK0ChdrTCt1PV+N59S6mA==
X-Received: by 2002:a05:6830:1288:b0:6b7:1e57:aa96 with SMTP id z8-20020a056830128800b006b71e57aa96mr4668578otp.6.1688179900746;
        Fri, 30 Jun 2023 19:51:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ne11-20020a17090b374b00b00259b729eea9sm11408080pjb.8.2023.06.30.19.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jun 2023 19:51:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 30 Jun 2023 19:51:39 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 00/33] 6.1.37-rc3 review
Message-ID: <7dc94d48-4e2e-4bb2-8a53-3555295b5a3e@roeck-us.net>
References: <20230630072124.944461414@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230630072124.944461414@linuxfoundation.org>

On Fri, Jun 30, 2023 at 09:32:49AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.37 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 Jul 2023 07:21:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 518 fail: 1
Failed tests:
	xtensa:de212:kc705-nommu:nommu_kc705_defconfig

The mmu code again. Patch from Linus incoming.

Guenter
