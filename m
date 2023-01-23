Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44087C
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 11:19:26 +0000 (UTC)
Received: by mail-wr1-f50.google.com with SMTP id e3so10427240wru.13
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 03:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HY1/widmf/JGTUi3jZUI01Qdi68/p1OXBYwlq1TYmD8=;
        b=nCkaKGh+0wLqzKx7OGXh1fhiLJNreEtGweUYR2a9UyK+BSc//7CyIrpSrOQ3futSYJ
         nswST/+jVQoPc2+lyclyEXFvan7WjW+MFBnW9qaOJGbKgYFHlXP4RqG0oNl2v4V45mKJ
         hB1RW2BL9i9hj4pLQSWGgVX6R3bwpsmM+s6B5+Roq9Jl1+M16I6+qAQiUY8Fyopzb58g
         qlxQVwT1zrSorDbm1RLGh59zfUBZvCBY2QZJBPdckORrp/2JAQ4lAZlX9rF/11tPLQ2B
         n2b2UazGi4tbSFxut7ZTl2XVm5RNcOPLn5rpzNdD3Dy5OCq5ERBo+XUFxpgD9lqkraAm
         IIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HY1/widmf/JGTUi3jZUI01Qdi68/p1OXBYwlq1TYmD8=;
        b=7FJOJxruTyduNinLO3wS8stEmZ4vrTr0vxuF656mNEZvTS76Bfc4BdgYxmDjHqY2Aq
         5rXAEiDcmiCFi3zO919ZCy3Wc9e0hUqA08ZMMO3clFo89PGqummQZIswwETG0jevU6zL
         5R86XlhlSDOw2OrGVqnICe89zZSUs+Vza+zCOn8RFRM01BEuA5Kcry1idaHQxU5PdgBV
         v4UoWPcIVg+soPlLWWfadvMZqiYDHlZ+f4Db1Oj31yOQBVz4BtsO4DjPFGVzcGuRK5fz
         qBl0rVuIS9XKZp1zEzb5yzhfaBdJ1SDHWb4NbegHxuCDdiTScpqqEm7QAaJfb71Begnb
         1QeQ==
X-Gm-Message-State: AFqh2koqKWcw8w3B4yMBK0P9q7/FmmpnF2PybySZORRalmtPX370VOSN
	z+nX6vg0ZZRbg4baeHbFbAA=
X-Google-Smtp-Source: AMrXdXuZkbKk51RfvmCcmtkNS2c0SKule2Ctc0rm/gvSvioE933kAYvM4W7cunKYBvFl0Y1/NXOPHA==
X-Received: by 2002:a5d:4bce:0:b0:2be:4ae1:215a with SMTP id l14-20020a5d4bce000000b002be4ae1215amr11906254wrt.16.1674472765077;
        Mon, 23 Jan 2023 03:19:25 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id z14-20020a5d4c8e000000b002bdbde1d3absm6362878wrs.78.2023.01.23.03.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 03:19:24 -0800 (PST)
Date: Mon, 23 Jan 2023 11:19:23 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/55] 5.4.230-rc1 review
Message-ID: <Y85tO/mJOxIaWH4c@debian>
References: <20230122150222.210885219@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>

Hi Greg,

On Sun, Jan 22, 2023 at 04:03:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.230 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230113):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2695


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
