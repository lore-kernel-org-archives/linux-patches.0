Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E05163
	for <patches@lists.linux.dev>; Sat, 31 Dec 2022 00:17:52 +0000 (UTC)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-1433ef3b61fso26289643fac.10
        for <patches@lists.linux.dev>; Fri, 30 Dec 2022 16:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aD2pyMO7OOE2EFdyuJsS7VOYOnoYMeTk7hsW83uEvV8=;
        b=naU9FPp37XrnNa1LOC35fGfJk80sHKGQCuzXDNRYqJXgI1kVhvEP309ieCEzfPyTla
         cnyM6S1EhgpJL2Is1X9OPvDnCirALAPvmjRa0ull3F7uhgzDf73J3ZFg6MQV905EBljF
         30afWCE9plt0QpWPrGygfk9QFCsJGfgVBfVSa9ndoOij1YenmFJXOPTiALviGFasnCZc
         0hUSucO2ERDG6bJxbVDt518wAo2SyWEcwPXxXCTe4O/ErDsFaKFWXgi0xQBz0yOTO/3/
         6JIsssM8a6i0vWTQazva+9JgiwqrjnmZVsCLSRfrdOE7y2zB9QEbdir8NOlJf4xYQHK8
         /ySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aD2pyMO7OOE2EFdyuJsS7VOYOnoYMeTk7hsW83uEvV8=;
        b=GUmE/XKJ/naEi8aAFbORWjaiGJWnjA+Tt+CHNEDOv9LRgw3lqQ8h/2fVrZ3VRhKj1T
         LaIJz4y2MkKsrtlFCzcToZ7KzeRS1WyPtLRsjSCHg/6chZ9mtjAsWSj6LVcGOlCdG7ta
         JiNT/HmGg114PRyeQ/kX9PcuV3jyB4B9iF1ajwgYmCASiC1tfhRi+A94R9NlvhKOcwXk
         UAqGlKjWI+h+Mb0hCx/uU8oF8IhXQ9zTc8yn9wDy8vRVxlWgTVjRqATOZDiOWkufWQqA
         0868o+K0zMWxIycDZTU92kbqmjVnZhsReyKCdhYvJkJjre9D7/bimU9XK9q56soZSDL5
         jhgw==
X-Gm-Message-State: AFqh2kry3icCeB+oafmp438Evdkd15rERNqTq4NPPWTgiR86wzBGYczg
	Hv2zU8bXxNtJbBgg5BIHge4=
X-Google-Smtp-Source: AMrXdXvh5c6ArRE4hrT8wtp4YdQBLc8YF1onZBgvBw65Z0PgjH0Lio4pTH+xarRBf+MVDtEy/kGqAg==
X-Received: by 2002:a05:6870:3c0f:b0:14f:7a46:74f6 with SMTP id gk15-20020a0568703c0f00b0014f7a4674f6mr15625758oab.33.1672445871378;
        Fri, 30 Dec 2022 16:17:51 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z13-20020a05687041cd00b001431bf4e5a0sm10407602oac.38.2022.12.30.16.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 16:17:50 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 30 Dec 2022 16:17:49 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 0000/1066] 6.0.16-rc2 review
Message-ID: <20221231001749.GA2916712@roeck-us.net>
References: <20221230094059.698032393@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230094059.698032393@linuxfoundation.org>

On Fri, Dec 30, 2022 at 10:49:23AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1066 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
