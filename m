Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1684D7F
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 00:23:22 +0000 (UTC)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-144b21f5e5fso10558743fac.12
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 16:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VWRRBJwqz9M78uBhUbPd2Wqa0O5Mu6T0Z4NHOcknz4E=;
        b=alRC+lsmlCQzCgOLkQEwDacTNL/gdlGT5N0HZmjwTuAmmvnGxTTWkxCH2onpHs0uc3
         ef418gZEWMCbfeum/GLCj/vlr5WWtZyWbuBarCTWd19DlqVrcZtYvxlMYdtP/Odphbd4
         1uUrauOpWiaN813DvHjKQmSLgAlO5AhctL8p3HfqGsZzFpCsqLqn9+fDNAxm6tknQ/wg
         KzLKp775N8gJXMVOmRso3Rifn4mHmvwmstNHNPwh0JiaLmIuTb0AnHgRCJGsyxSDrkON
         YfEiaf0FiJ3iM2z4MESSs5Q2wOYO/V2M5j4KBEsnr5BufUo7SvP+QYACX1tG2w1NKov/
         yegA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VWRRBJwqz9M78uBhUbPd2Wqa0O5Mu6T0Z4NHOcknz4E=;
        b=rk05fDD/xFAQjlzPibrhnHZ2+m9J4oxrbWCXWjHqK3rjQqv+WJDBKjnzrBLCrFEnhK
         o647gntMOfM2fXFUTYB0lAczA+AH4fVNkntVsxhE2zuALXgz3y4y3hp+Iyqn7lk8B+Ic
         INuHZROWHxyFrz5ZsEDtWNvaJ8WkA9jzMjfLmvnB5PvKAAU3o6JfioCtCpUdUon8P1qj
         zI9TbS5nKQ5wWpOuQLtplaSuHiS62I9Xq884TFT4lpIvaoEM0hYJT+A4T5H8kvXJn+Hm
         Ydl97dKej9ST3mKxbP6UvIaxNHpZTMCqfoDIZzz7fChoQYpJwZK2HceN9aVU34cTKKHP
         lFgw==
X-Gm-Message-State: ANoB5pl2Gl2OdC8u6ainJqjClwrgAKpw6SNO7bhdYPBrSyj1mE4LJct9
	FQU8DNFQPiDOKAxZmft9k9c=
X-Google-Smtp-Source: AA0mqf70hQVz1iHWAblz6DYY/NExSanSWJiQZ0ImgGuZLWoh/tWxLIpGUpPzZa6k4OwAWlyLk3jbyg==
X-Received: by 2002:a05:6870:d9b:b0:144:a3cb:3fe7 with SMTP id mj27-20020a0568700d9b00b00144a3cb3fe7mr8831699oab.40.1670891001148;
        Mon, 12 Dec 2022 16:23:21 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n1-20020a056870558100b0013d6d924995sm667219oao.19.2022.12.12.16.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 16:23:20 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 12 Dec 2022 16:23:19 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.9 00/31] 4.9.336-rc1 review
Message-ID: <20221213002319.GA2375064@roeck-us.net>
References: <20221212130909.943483205@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130909.943483205@linuxfoundation.org>

On Mon, Dec 12, 2022 at 02:19:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.336 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 395 pass: 395 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
