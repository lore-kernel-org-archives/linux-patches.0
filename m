Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D303E2F2F
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 12:09:19 +0000 (UTC)
Received: by mail-wr1-f49.google.com with SMTP id i7so746795wrv.8
        for <patches@lists.linux.dev>; Tue, 13 Dec 2022 04:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S7mo+32hCAdhTEsB/h4ej2yddd4gj6GzVkAb5emTsrQ=;
        b=fXQzjyb++ZUafp//8w5B4bODhZeoUJvUOtDLBqaURXYK/XYE7h9FpG86ZF4cLGN2QA
         akGIYZVLmkIwkPwWeCb64/aajtR1ymlxaRUEBk9ktzd6wmtfJ3LtElFCdrdknAwY0qIn
         PECZLcO/jR/ezzFBHMlP15CzvU2D2RYa9W2No/qiHJhj+19USP9PcyggrJyTusnzsHaK
         wBlCd6KnJ9/3hWmS2+s23TlWmROvu4daYEuRF7npE7eA516I1v7wcoob1uxPq6uWNo6w
         2HkrVrtaUox+2Du326yBxDdNtLiKifsTEwy5hI6lwB/1ehsWGcHI+lKJHotkIXFDQI6J
         mhnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S7mo+32hCAdhTEsB/h4ej2yddd4gj6GzVkAb5emTsrQ=;
        b=NiMR93p/1wdvkuKc1b8P2+pnru7TyUEYkno6ElK/SOG5iBpUD1pxg6Fg3gkf33y6bx
         82MbPk0TMRtTv8ooi91eQ/B+ii6ShcyP00+6EseUQ/TB8U3/5IOuT/knejVJbnjy/v6u
         z0QPg6Y9/cP2LPVXgzeYQs365r1rJv7SL1CPCQ9ZNzXDkXMQOaVok7E53kjv9h/to4PG
         rg3vi1byw0pkeGngNfOijLN0pjZ7D3QBH1jfRgseZ37WnEYPv1m2WE5VH4eHfqD77cuY
         0Y7aYGgcC0859AADuMDJwsorZLqNZeibhyJMtDSvoZ1KugtFF6uTGGNYKZuzZ/Mde5u1
         KYJQ==
X-Gm-Message-State: ANoB5pkJ5RcOYmUjGNm9E10czmGrWhvJT94CDO1PCqdr5iYqH+VNY+tl
	ZN/wRZknz3lmPsVDlLb6Oow=
X-Google-Smtp-Source: AA0mqf4JoX1P7+deIH1yzYTqw4QP70qZorpLiOopnZuJ3Ywc5/DJ59eDvBwLUOU47jV6eXqIXRRl+A==
X-Received: by 2002:a5d:68c8:0:b0:242:15e1:5805 with SMTP id p8-20020a5d68c8000000b0024215e15805mr12712664wrw.55.1670933358068;
        Tue, 13 Dec 2022 04:09:18 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id v1-20020a5d6781000000b002422b462975sm11329673wru.34.2022.12.13.04.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 04:09:17 -0800 (PST)
Date: Tue, 13 Dec 2022 12:09:16 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/157] 6.0.13-rc1 review
Message-ID: <Y5hrbCeCIHo+tigK@debian>
References: <20221212130934.337225088@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>

Hi Greg,

On Mon, Dec 12, 2022 at 02:15:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.13 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2341
[2]. https://openqa.qa.codethink.co.uk/tests/2343
[3]. https://openqa.qa.codethink.co.uk/tests/2345

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
