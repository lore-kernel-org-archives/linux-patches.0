Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292A8EA1
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 02:02:47 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-794d98181f0so90081739f.2
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 19:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693360967; x=1693965767; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0HdvKkJi2c+ExbelovmbW80s8E7flt09p5Cj4ccXEHs=;
        b=qbK5n5o9OZcT9ynVxAs/I5gJXjMrP16bgJiS+LfjEgz0OCK7CoY2Vo9PjICv4taJbA
         bC/dYG93Gljp4z+oUkQt7nVArUHlZHY3QbLZD0RTiT9iSwf23i1tyB5wjGyUYeO9qOOH
         lHnARt2V7kz/dEXePRdGNlqeHyYSI51cb7GiUsa6REXBUVTZjZKHdXTlBtIrVv9cZR0+
         cC1H4WVbxHH3JbMpbldPbvebbq/EIkTQ/hCWhf57umrAQLtJVHYFD41dGto7938qSofZ
         lBJPGYZOC15eEB6DMOhO7jbSTWEmjjSiLj6iAEmS2tT60HI4NzpRZDrkhyUnM8P1pqDn
         hRXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693360967; x=1693965767;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0HdvKkJi2c+ExbelovmbW80s8E7flt09p5Cj4ccXEHs=;
        b=PhGnRGEIGMK+x4KxIVKphREXPk+dUtEAnki18E4iy0Ky1yug9pj7trTmhiysbDVC2Q
         k0CLdOMoo8D+A+HaSwXM3bYjEF0T3jOCHsy4EZ1oH6K4f3V6QiOPk57vu6scAqdiVrbC
         ALkNL1MAkgn5JAFm2yoRmKih4JAWszbaMkKT9gmuLVJXTQNU5oh6d1ygkcIvNLW+JebD
         HMBrt3YGpOhARFgj0fUYQEgoulRxlWzvAJO8WJr3xGd8Gt607jqO7TkbMUJtxXibEPJd
         /AeedqbA819KHuuwm2uQkDERksx3SorP3UuPkiP7YvVYEEE/+l9ggOaC24a8UB7tJQ/V
         /srw==
X-Gm-Message-State: AOJu0YwVUWR9YTPUVgReZU/MaooUbPBoPNVO5zL3UeWXIuOINAL83HrX
	Kqd9nXgI1hPjlUsNs2WcMEQ=
X-Google-Smtp-Source: AGHT+IFqJsjo83gpaGlXAPmitQ8p6dvFtGBhgUqFDq40D+IDv6LtTjNczlr6RzeXm0LhlXaxVEbIsQ==
X-Received: by 2002:a5e:c91a:0:b0:783:7275:9c47 with SMTP id z26-20020a5ec91a000000b0078372759c47mr1134770iol.7.1693360967114;
        Tue, 29 Aug 2023 19:02:47 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m14-20020a6b580e000000b007951e14b951sm160847iob.25.2023.08.29.19.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 19:02:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 29 Aug 2023 19:02:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 00/84] 5.10.193-rc1 review
Message-ID: <014b04d5-8b2d-4ffb-9460-69b0ad166f24@roeck-us.net>
References: <20230828101149.146126827@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>

On Mon, Aug 28, 2023 at 12:13:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.193 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 157 fail: 2
Failed builds:
	mips:mtx1_defconfig
	mips:db1xxx_defconfig
Qemu test results:
	total: 487 pass: 487 fail: 0

Same mips build failures as with other branches. Not new so

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
