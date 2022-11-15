Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6753234
	for <patches@lists.linux.dev>; Tue, 15 Nov 2022 10:40:08 +0000 (UTC)
Received: by mail-wm1-f52.google.com with SMTP id m7-20020a05600c090700b003cf8a105d9eso9905764wmp.5
        for <patches@lists.linux.dev>; Tue, 15 Nov 2022 02:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3WMQbkosnl9z7yXTDnS2EVl5UPXC0Gu253HYTa4GcJE=;
        b=A+j8/L+A7kozJHAxLA+l738i3z12lDvhttAvsxsKzb3fA4aGFc1DZGjvJEuGZgMtLr
         VKOMnEnYZFDa0mKGp8mNk6OSSMTtQf+prWY59O5C26iQC3QXgygcFHYq2058ZINeyQio
         6Z9fgIlj4sr/VCPVcACsNsxf6ZiEN7sOcs96nV29YPEzvWW1G4gjpDUKzQptQFyOYuFp
         ViHlWGgX8wKBfEaWvIS+T1iw7F57ul5C88wS9m67nZsGmbcPnNKKaGis9e9uJrz+S7U7
         3j8kKAKvpZvUFVd5X8WhNkL0Qoju0YeO5qwCabMrQzoF1inh2DHHtEtAhT+lyKzYVR+m
         faIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3WMQbkosnl9z7yXTDnS2EVl5UPXC0Gu253HYTa4GcJE=;
        b=JhPnX+d0RJW/OxRxcxrP1fAsjyQYjb4C796e7VK+8TkwztShFsOFigwUoDBix33zut
         PhkxA/jh/u6Zyx6IBJbmcEqXpNYeMPXrjT3mPdldrGj5WwrE3Q4AESXYSjI+KZgTuoSF
         41gUqS91vWrsURHbGK1LXwpSJVP1v9rf+wVokv33NzMT75Z9/2RrcEVfyIwL55tpz00e
         mz3CiBnrIlbu9oTueMQSIXQXB4JpwvdNPxDlef3Owe5h4/teU5+rcYLcu0BkVvLcwLG3
         oU4CoxSwqYLiLBT9SmG2Uo39x2P0oheIZpvkTlZNh156kD9wGPvnyV3uY28SbLYfOv81
         i1LA==
X-Gm-Message-State: ANoB5plQzVzhNRZfwAUSGxXldjZve5+JYTBq81K3yGS/CdgtNgtap7An
	CxSeeaLlpYlBt8T7bsMs1X8=
X-Google-Smtp-Source: AA0mqf4/dNTp2hR9OB70zETvsMmVoOKlshqJqzaWzKau67cx59GbzlyOleBhUBWJPBEsBkDme8rS6w==
X-Received: by 2002:a05:600c:689a:b0:3c6:6f2c:64ef with SMTP id fn26-20020a05600c689a00b003c66f2c64efmr973532wmb.91.1668508807141;
        Tue, 15 Nov 2022 02:40:07 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id p10-20020a5d48ca000000b00236705daefesm12102281wrs.39.2022.11.15.02.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 02:40:06 -0800 (PST)
Date: Tue, 15 Nov 2022 10:40:05 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
Message-ID: <Y3NshYevwCyl7OlA@debian>
References: <20221114124458.806324402@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>

Hi Greg,

On Mon, Nov 14, 2022 at 01:43:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2159
[2]. https://openqa.qa.codethink.co.uk/tests/2165

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
