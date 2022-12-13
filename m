Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2A279C9
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 19:06:30 +0000 (UTC)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-1322d768ba7so13758110fac.5
        for <patches@lists.linux.dev>; Tue, 13 Dec 2022 11:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=koNp7ZPutVcD4qQ3Y9JWftj3ajcM/O99x4q/w4wE8kI=;
        b=dfL2u8z4jbcIQuFsiCJwbn7x/YxX/PyFNpkuQEvQCC4ykFiOc1qFuYz2/Fn6YYTAvz
         6aeZpDK3MA8awnEJC7C4s78aqgyDPHA3pdB0l6pAOop70170o2j88lcb3ukiULw4sXgd
         gb9PZ8PlW7xYnfmvX8kQ4+OwPQ/AdvWmWa0I911JvYoEN3pWNeDl+NR1iGAQxWWnEReD
         wY4At8u+qt4L3QEzIkK+quXkkDUpjYLXI7yyymB0Vy3a6DOgdOYD3HQhtaIbLg9HR2Rl
         xhhhTVN89GzipGNu3ibt3kcqbAvjAZ3RmHKXjtxQ0wt/oQ0j2JL1SmhL04sSybfPQep3
         Oocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=koNp7ZPutVcD4qQ3Y9JWftj3ajcM/O99x4q/w4wE8kI=;
        b=akrMuv9Jk+bnU1u9NlPWHo5cGP+16dxw0Bmi42rlOAmRjVMeUERY0N3FJqvSttEKQ4
         2L2xat3iOzrTIThBOpS8/AYrvqfszLwVTPtXGUsLEqMFNithzYquQqJi7ZXFv0lQWCNB
         hJpiTHBAN+PU0QWfC/Bj4IjZGdnaRPeJGCO6/mJtCvpulA8F1awdcSXo7dtWhukIcnRE
         RGMAXq2ZHuSm708HafGZqF7UNYY91TiKLwJOpHe2yLLctgXRQ1LaueZapU8Tu6jPD55H
         AnbrNcrw9xxmdBA9Gh/6RYQB1COaUzperyfQddgQwxWDB6mjccCQlk40Z3Qr7fFDNGxW
         3hbA==
X-Gm-Message-State: ANoB5pl/s1yOy8OHazlNAksz9D7tZ+pJPz+S+dHVHPgeqgjId7rb6f1j
	TQkYNoDI7cSwCsqxjYOwGC8=
X-Google-Smtp-Source: AA0mqf5R+M+eG9DcifGZmSIExwUM86fVy3r1jiti2wpgFFNTTQ2EREjBHpXshp77AsqyxNIIZT3JUw==
X-Received: by 2002:a05:6871:87:b0:148:592f:83d2 with SMTP id u7-20020a056871008700b00148592f83d2mr4843218oaa.6.1670958390070;
        Tue, 13 Dec 2022 11:06:30 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a36-20020a05687046a400b00144705fdd02sm1764447oap.43.2022.12.13.11.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 11:06:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 13 Dec 2022 11:06:28 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/98] 5.10.159-rc2 review
Message-ID: <20221213190628.GA3944422@roeck-us.net>
References: <20221213150409.357752716@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213150409.357752716@linuxfoundation.org>

On Tue, Dec 13, 2022 at 04:05:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.159 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Dec 2022 15:03:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
