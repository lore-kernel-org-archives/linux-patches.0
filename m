Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBC63C25
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 12:12:00 +0000 (UTC)
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-3f8cc04c278so3822305e9.0
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 05:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686658319; x=1689250319;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JiZLKGxx/obOBwfx5ZXrNlXAMV40xGv31BFdtweV1Dw=;
        b=GKgafrdBUG7C7YWkzxxj0bfx+26A+gq8hhshr+iogR9KUA9fZIxbtol8Qll6nLXPrT
         y/zUPy/8ekuVc4Z5Aox2JGowpzPqZbf0HrjmytQ/2Y76/nbA25nxY2LIypA7utQNYI5e
         8hgRw/5NGZNLfo16K/+JKN9nDULJIagFQri0sNuFeLU3OE0xddVoeItOC9eqA6Kf+8Wy
         QuLzVpLUUnNy4/eSQR+pNHeg3RCI9QDJ3Ef/6btiZgX5uo2fFsqzZeq71O7W8F+mTX8B
         XLYUKXOnD3AdfNtihfs+J97y8CWF/+XJn5MX2pvFboZwBkE7lIb1tvTTjGhQOZYyIJya
         qwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686658319; x=1689250319;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JiZLKGxx/obOBwfx5ZXrNlXAMV40xGv31BFdtweV1Dw=;
        b=bp+oItE4n5aZJOrCRGALqhkwMNIU7nyyF61IhyEUly9Ql9M1M4C9VFrjNG/PIoojxI
         LiHSZbVaAOJeyXQJ5sLd8+zYob7WLtwp1lKADxWwTa9o8+dSH982yh5AjInGmhoyr7rE
         lFddq3UrYDv7FcXjoebx77j8XeuQl8VnU/1fQDOsJSA9rwyl5FgW8vtM+8zNWkKvYk7P
         XaeeFIFtk2RvR7OCEXEHREYERvgfzwPQnHcNIHkk4j9Y5gZTeOYhgCcBaOuuuMgnMLXW
         Sk/9FBi9VYaGk3gaJAIOu00qkbARS6Us9tpBRZKdr8QEjw2vHhbH0URfsQSc9g98MsgE
         v6TA==
X-Gm-Message-State: AC+VfDyL0Zl6B3FEMmolik4xKcBL4znIF2titbvS2o2eD94/vEyPxHMm
	d8HSnQ6mnIy59V5EvCuIATU=
X-Google-Smtp-Source: ACHHUZ7GJhRdshkb1048wUmGAGhogLKcFmKEWoBC5TuAQNknuGpMyneSA6A8ru3RRnMPYhRfxciyxw==
X-Received: by 2002:a05:6000:4e1:b0:30a:d459:8f72 with SMTP id cr1-20020a05600004e100b0030ad4598f72mr5783874wrb.60.1686658318731;
        Tue, 13 Jun 2023 05:11:58 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id e16-20020adffc50000000b0030fbb834074sm7486868wrs.15.2023.06.13.05.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 05:11:58 -0700 (PDT)
Date: Tue, 13 Jun 2023 13:11:56 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/23] 4.19.286-rc1 review
Message-ID: <ZIhdDNHSoA232PLZ@debian>
References: <20230612101651.138592130@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612101651.138592130@linuxfoundation.org>

Hi Greg,

On Mon, Jun 12, 2023 at 12:26:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.286 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 11.3.1 20230511):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/3909


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
