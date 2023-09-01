Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A53881F
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 09:41:30 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-401f68602a8so17494635e9.3
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 02:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693561289; x=1694166089; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SxEtOzBuXpkAxEd5YMJavUAy4d21QZX3bUg6RyTknlQ=;
        b=co4vEA7D0vOHjDsPRr0SdRPuywYahYEajX0ihfnpy9kr6PlgtDPHJHNdGu9B6t7mmf
         UqS3o1caHPcUHy+2zpaQ+CSQ4kXfrrJNiq5rkPjzImi/TS1WCt9FsmRKesC3ADxhh8mI
         mpUeom+vEGXBuxRUm5/BJITQIElmuxpL9jM672VGeSczJL9dKnKnSi+H6ChtwS7fh4WJ
         i1X/8cGfKSeisZvecP57p1rfBRX9ua5TNaEhy16uw2aVo+9GQKwCVz2bJNMrGvRwHlZA
         sIwloZmBMP8ASIDE1urzISMSCIxQT0F7J91Zkqayza5NOBA3G9bGWyKaOB76e7zgeBVe
         p/zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693561289; x=1694166089;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SxEtOzBuXpkAxEd5YMJavUAy4d21QZX3bUg6RyTknlQ=;
        b=HEYRKiEYLnQxnVozX/OczbW96+6y2VjC6XK2yN17v78FCYfQEtiywnXRI/7cpzhU3H
         uKyDTxaMCtEFLK0MR8mJq7BolB5s5iIGKiK1rxCOSPOn7x5gYSP8gMDFgQ9iY5DaeXji
         J6sL/28pZlg0ryYaksg5It77jJ9DMt+RL+5V//IEZKifl/YznYrMVCNKds2q8bj37+eo
         6hr9b50L6mbNKfpuJ4R/bHfcV2J2pCUJu/6lxaHTR7SaqgFtudJO6n9HHXqW59pnKcSG
         ZyYwxNJEQHgYUXy7ENMgwe8E5/tqatjjYSUNtvnKVE1BtqBkVmDS1OLeq6t5oGgGGpga
         zP+Q==
X-Gm-Message-State: AOJu0YyOJFylhaAF9MRjdWk92+2ocL87wOb+iM8iazyKAusHCSuBQRLq
	ws8wIdi5zFyGFUvVsyYYHNY=
X-Google-Smtp-Source: AGHT+IE9EmYhdCOlENTTPa/wqm+fCsAFERo5S2tTfI27sSovINHc9HJE8L6T57CbZjfYwyKz/oqk6A==
X-Received: by 2002:a05:600c:22d7:b0:400:cc2d:5e00 with SMTP id 23-20020a05600c22d700b00400cc2d5e00mr1374552wmg.7.1693561288969;
        Fri, 01 Sep 2023 02:41:28 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id 11-20020a05600c248b00b003fc01495383sm7468670wms.6.2023.09.01.02.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 02:41:28 -0700 (PDT)
Date: Fri, 1 Sep 2023 10:41:27 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 00/10] 6.1.51-rc1 review
Message-ID: <ZPGxx46/alty9X16@debian>
References: <20230831110831.079963475@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831110831.079963475@linuxfoundation.org>

Hi Greg,

On Thu, Aug 31, 2023 at 01:10:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.51 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.3.1 20230829):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/4888
[2]. https://openqa.qa.codethink.co.uk/tests/4890
[3]. https://openqa.qa.codethink.co.uk/tests/4889

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
