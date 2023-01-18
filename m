Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1867B
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 01:39:39 +0000 (UTC)
Received: by mail-oo1-f41.google.com with SMTP id b10-20020a4a9fca000000b004e6f734c6b4so8439447oom.9
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 17:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bN8e9VcYrQuqVqjQ+f+mGITMg1hr725vXgqqgBJYPOY=;
        b=WEof6l8KUfX79/EsXXGLExfqIaK4eaJ6i2xNi9hNc0l89b5SbdO41Ppgl62iexlVBS
         p9La2pGcTUmzJErzwutk0uoyFKdnMxIrU2QLYegch6mtBRaGuoKBP882c5vkzKPxJOQH
         IXcqvp6FvE/H9RnpQnwgiCiw+JWm9UmiD/t1kzBd3JxICeT7Z+2rkmH3Xte5K5x/nGgo
         z7HtWAmmYThTxZxFtvgzdJ7KnuvNG33GQdCS9WNqWUnUZ+u9lr50q5VSKze842B+aekq
         sVcjT7tqrU1cIgt6/qJnAHCCIP6FZNbb+faGSOuay1qbhuDS2zavyr5TB3abJDjPdjDT
         qnIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bN8e9VcYrQuqVqjQ+f+mGITMg1hr725vXgqqgBJYPOY=;
        b=xUWK4J79ct53iK135E04BaGWxqWgSjyG+jY2iLz+HjbsEYbtOyAU4t8ozpupFSQPYC
         xY2S/ihvI8UsnKZ2jDEmkMubnhj1wyj+yj2RCqEd7jiioXnPYa5y4ZzXO8bNF8kRTA/3
         BUhd02eCmt5krVxEJVRwnCP5Vlw65ME2hXVtNcQrZkLcnyqudY0IqG/zm/bqjaN3D/tt
         GSBHLDK657NBNQ5Pe6g/RXBNP45b6I6V2ooxHdcpd0roXIe4XjOJmZaShKMszKBEkiq2
         R6W8LUwKmAkDkWgB8eUKpnClf9N3QSOFfeIsXeujovkeIeHuDd5cb8/L0gimnZZbbB8u
         d9Mg==
X-Gm-Message-State: AFqh2krABwMdihXRmdGKarI1G1sOZg32lZpigAX/oqmLHWZIZZD29Jpq
	fb18LFPVK30zS4+GWnz1rLk=
X-Google-Smtp-Source: AMrXdXuzKckJKM1nwEcIinQYWBgqY3hm9EYEKEZgfkz5Cu+cRYcWDDIQtRDzW35PjlVafsqvI3kxFQ==
X-Received: by 2002:a05:6820:1390:b0:4e7:5d43:a654 with SMTP id i16-20020a056820139000b004e75d43a654mr2531992oow.0.1674005978431;
        Tue, 17 Jan 2023 17:39:38 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m22-20020a4ac696000000b0049bfbf7c5a8sm15690774ooq.38.2023.01.17.17.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 17:39:38 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 17 Jan 2023 17:39:36 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/86] 5.15.89-rc1 review
Message-ID: <20230118013936.GE1727121@roeck-us.net>
References: <20230116154747.036911298@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>

On Mon, Jan 16, 2023 at 04:50:34PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.89 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 491 pass: 491 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
