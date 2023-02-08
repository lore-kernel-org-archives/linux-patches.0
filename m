Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BC536E
	for <patches@lists.linux.dev>; Wed,  8 Feb 2023 05:21:24 +0000 (UTC)
Received: by mail-ot1-f47.google.com with SMTP id y11-20020a05683009cb00b0068dbf908574so51384ott.8
        for <patches@lists.linux.dev>; Tue, 07 Feb 2023 21:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HWiqZrImJXEuLHbtd52IqcloEJiiELL3yBzzB//vuKs=;
        b=oFzWTEqVuoYaNCaulckmyLVfy1vLCJESrVmdFRsP6viGFPz5bwc4Vap7pEOr/xA1om
         66EsFf/YBqet5kV/ingNyFmpSsVoGKszKMn/QpknUY5jfCJRPQbIfxUExoSoPlQa0MoA
         +DlGUk2Lrx0voXFsUkQ4Tawk7RsrrxeAKuvV30sHSrAWkggWhrTIbzifsCIGlqWNQxm/
         bdoOYPeVL21aOKm6Z4BhG+qr4n5Rg6Kx8icMYr6zDx3kysTxeLxiSbDumBYqe1+k6V6C
         nyl8HrPEld6ZQz/QBHzpY7KZUUPD9+K2buEqFb3sNHDg2nTrOw1WQ98YP2vMDXy5pgnP
         feWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HWiqZrImJXEuLHbtd52IqcloEJiiELL3yBzzB//vuKs=;
        b=2ujdXQmR53wR32zgSsebHNVCqytortDdIM9UfBpWSczVi5mRl5hiw0QZRgVAYWuTJL
         Hazrok5Acdu7EVFWiSu4v8PTlQD5eNreqtGHoJsFikkqoXYYjsnP4MiplVsGu3fxUfOc
         JMMyJhIeXz2+tfNWU4MNrOnyUOqRczAv5ClKzLDI6Jmb0AoyvxUwOw7sdJuNuUqZ9zob
         vQ3x/c2lFUr1vKt83oC6QM6NanKWcHqElZXmnkSgAgyv39RIY4XBIGSgefI+3vxXXVYR
         GXQhVy8Y8rS4z/ExJgScbWbIx6SYsiqie3xgMbMmwAyZW78LWOajDkKKIR3hwNzBSRe5
         rY1w==
X-Gm-Message-State: AO0yUKXgb3kjr3/QyVsuXSIbWKwnCISCrRluE11JlBHosFS3Y4qMZWmd
	3XXsvXJWSM4BQJo7NXX809I=
X-Google-Smtp-Source: AK7set98deWCt/leTm0NgjpKMk/+3LSkE6y9uuuda8BdpPD8vxLgAFk4bMmRrZdbUJtm7OeZ+Xhdyg==
X-Received: by 2002:a9d:758c:0:b0:68d:b390:e6e7 with SMTP id s12-20020a9d758c000000b0068db390e6e7mr1814624otk.16.1675833683759;
        Tue, 07 Feb 2023 21:21:23 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h13-20020a9d6f8d000000b0068657984c22sm7589039otq.32.2023.02.07.21.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 21:21:22 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 7 Feb 2023 21:21:21 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/120] 5.15.93-rc1 review
Message-ID: <20230208052121.GA3509133@roeck-us.net>
References: <20230207125618.699726054@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>

On Tue, Feb 07, 2023 at 01:56:11PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.93 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 492 pass: 492 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
