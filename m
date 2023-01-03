Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EA07F
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 01:13:35 +0000 (UTC)
Received: by mail-oi1-f178.google.com with SMTP id r205so26063454oib.9
        for <patches@lists.linux.dev>; Mon, 02 Jan 2023 17:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yUSv/leba9Q8axsenHUf6zXYFVRcTyGLlPdp1AvGirA=;
        b=ZPtv1A+0c/LYbTYf8+62Xm7V3htqTzY8fpIRU9yDMHw/DlKurcu0aikSSnSJwPn2+C
         wxDeGoUstJMz4i2mPn8CFE9FXh1rTcaQ4LI3mT+Qog828iFZ61mkgJRolL67g1qdg17z
         dE7tOXdm4IbUMrw3OqzPSPQ7fB5Q4w3O4mNR/UN5E6qaVNn+hEA1Rp0XB2GNAjtGDsUq
         ubhDnr1wv0fWU8aMylRO0AdEpNB/CbmJ5eRjhD8Yhpl8NwJmDQ4jfGbt+S+ACQ+HHd+h
         TqTmcLIzcU58XVlH4t9CQlXtXVi2VwD/E4lfSWZFa/mryWcbTw9Ix8zHGBc77i7EKQvr
         sMQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yUSv/leba9Q8axsenHUf6zXYFVRcTyGLlPdp1AvGirA=;
        b=WTjqT9wWBgJuZcDhPgrd+IVWDopsVHMnuO43/CCVXyIBm9NuVeTrHoO9tijzIuaZY/
         5J9iTjsfMCaxXC3K4B2ZqmGK05gx5qjsfX289yrpl4jwKtJkptZVtpu4p51uF2pQDgut
         hZdqdfrI2nevBWA/6ze4Kw/kD6ReIrDkBS82hUAzlqMSoGjB0SnzPrzAqsq68Mgzp9hz
         hoEPR+cFq4djToh1lyiLqBtZqT8bsrryzqrKKvvcX7vwFPQcecQHK6ZoFRIwVo2InThL
         e8IUsaPfWb6rVY9NSR91LIa9mN0hKrFmdeIoabQkYXCiS0xO3KHjt7wrgEuEraCzzihM
         p5rw==
X-Gm-Message-State: AFqh2kqOuQZPEc1GSKrD6G3pnoXKQkkBcX62L3BrVHix0FWUf6LusKMb
	z8zctu6zcm++nTb5slGt9Sg=
X-Google-Smtp-Source: AMrXdXt/MddaeJmBDvEOtwTLEkRefIyHiJ+1xi+k503MqBN9qtpwKWFx3A/YiYTBlQvisEVDbs9J9Q==
X-Received: by 2002:aca:654c:0:b0:35e:4002:d914 with SMTP id j12-20020aca654c000000b0035e4002d914mr18450549oiw.2.1672708414237;
        Mon, 02 Jan 2023 17:13:34 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q3-20020a056808200300b0035e461d9b1bsm12577911oiw.50.2023.01.02.17.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 17:13:33 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 2 Jan 2023 17:13:32 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/71] 6.1.3-rc1 review
Message-ID: <20230103011332.GB149144@roeck-us.net>
References: <20230102110551.509937186@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>

On Mon, Jan 02, 2023 at 12:21:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
