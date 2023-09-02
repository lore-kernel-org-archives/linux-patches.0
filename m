Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049F217EF
	for <patches@lists.linux.dev>; Sat,  2 Sep 2023 04:20:10 +0000 (UTC)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-1cca0a1b3c7so1745744fac.2
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 21:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693628410; x=1694233210; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+BeF0qo1QDa7OIOcRTZpHC/vNEQNnCtwtVp6krVTuy8=;
        b=bR24P+7aBr5iAATiTPl9XZrAHrlXyG0qNGrTeG1VF4p8HJsw29rTMNUgX903ibqsbv
         gm9cnfi6+1W+v68ooBkHUfXKRh/BiXa3dN2tLB8MhrXGu5sluzWU8pv33Zf+getBnbTn
         PEjYjIjeMpqv+VgxkPLXbLCZ/+lcFyWBKvjDDoBpa58xFh7nztWJjkBGC02jID3D150h
         LHvWan/P+S34aclNt5Do3FVa6EXLiod7WGMNxhat9NMfoTlbQ7BPxv7HOiGDeEfj28mL
         D5cS+47kiTXmOaSIiyuH7VuQdP7YyTL1KvMJcZ6DBp8f0pgUqJxg7AjhtjYaqeE5l1R5
         /Htw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693628410; x=1694233210;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+BeF0qo1QDa7OIOcRTZpHC/vNEQNnCtwtVp6krVTuy8=;
        b=U+A5ncXVTgS0yMH1qrqpW1vYfQz+BpjkaW8p7mLe0tulALCZiApauyfT42ZXoKOWDo
         j+4YhV2fZxvePx++Hkg5ukgahcGGTmo/f6wKoxookB6eX+iFGwrPDjfFSQVSD1vAaGmR
         XYihBrR9cvhILN095pYDBEtHjJZtlxxgMppTeT4fZTeNODXZp5Alye/nUSUgoYhR6Itr
         oFnDUoJECQL0d60WItb7KqL/3gEUFskDA48RROkSkwhvBVVQCzduwz2qd3IJ1QREs3dm
         679GsuLJ5XT9dPYI/Ho7KR3XUEBV5SXBDIUNhq5t+l++fHDxYNLxxmTNZmWdgQQ8wIeD
         STdw==
X-Gm-Message-State: AOJu0YyEnyD7z74U8aQAlD/9HtYO8K7VxU/asqQQZqgN5po20z2HK1Gs
	3Nh7oVDNGp2DJy7syVV0r4c=
X-Google-Smtp-Source: AGHT+IG2LY3kqoImoMbvUvRg1Kays39XG+1y7t3IDVJEhS5vu+CS3AHHd1b7mL4lK3G4rF5rT9IksA==
X-Received: by 2002:a05:6871:892:b0:1c0:1caf:3324 with SMTP id r18-20020a056871089200b001c01caf3324mr5558212oaq.44.1693628410004;
        Fri, 01 Sep 2023 21:20:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g7-20020a02b707000000b0042b34d4d07fsm1511337jam.156.2023.09.01.21.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 21:20:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 1 Sep 2023 21:20:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 0/8] 6.5.1-rc1 review
Message-ID: <0b487032-17bd-4b57-9e84-e98e63a05a7c@roeck-us.net>
References: <20230831110830.817738361@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831110830.817738361@linuxfoundation.org>

On Thu, Aug 31, 2023 at 01:10:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.1 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 522 pass: 522 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
