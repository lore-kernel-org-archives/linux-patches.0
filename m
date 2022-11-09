Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7C517C2
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 02:57:05 +0000 (UTC)
Received: by mail-oi1-f179.google.com with SMTP id c129so17589498oia.0
        for <patches@lists.linux.dev>; Tue, 08 Nov 2022 18:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h6Sux44Q2CGgE7BKTrONowpFACwKq+Ls//yVTckb6pI=;
        b=c/9bXMN26wLnDTvuugz+DlxuIfXoiIlZwrPZLxEQ5EAhCJgJy6It3ck+1RNQ031AOu
         jteokKeSxiYGnpy3h0yscWs47IMrLPKerdpHnpQqlrVJuXaXlYEN257FAkecbOjT5XJE
         M9A0Dfg6v+H7N1ZOadfC/xMNn66aO6qSt08SX7MGRaWBq/YWjW5ShOUu/hjXl78ELH8w
         YrfLy0gBJSE5r3OrR4+B7WK0wqy0oGd7yERCeDYu80tRuuOCKuGdzkg8gxdikwOfNmnm
         3BfpWBVOKHO6hs2dYt28FEl63fGJHvj7CU+RRGovU4Mlax7cM/poYOrMxJBWAq5Mdtfu
         T0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h6Sux44Q2CGgE7BKTrONowpFACwKq+Ls//yVTckb6pI=;
        b=6hWtHzD3AxiFD8glrMfqIZBWd22XY8rfJocjHV6RXaBuu6BY6Ppu6QLS8KvDXvJUBi
         pphZ/mZAk22gZh2AR0mMsKP1niFz0zaaLEJYEeN3hAoWVwJS+fcNvckFvYdk90KPbSAE
         zarDf6v0iHalYqGV308xw/1Gnkk0XkSIhaOyFQ5mL8VpaMZcCgJTkZy34pCZ3bTqTOmO
         2JpM2aUN6nH7bsD86Cy3K5REJ/rrP3I0zMsZYFQKmI2Aq/+6cc0W2c407MatoJYh3Bq1
         FQ3bFkGTIht+Fvfbg7FXESzhS8xA8ReCOx9bpUOajA/BNU1rsjer+II8dvZNFy1J+b+u
         tMFw==
X-Gm-Message-State: ACrzQf34qBw2XvkfBPv7W6bfGQptBYdQ7HfQKgTM2eX6P7dUwnRiuS5R
	y8r1oqFEKBYaU8RhAmxkRgo=
X-Google-Smtp-Source: AMsMyM6wrj/dg1ngX6eKsKdZsDhM2BciITU0IfeI50LyDeoheTooyX+pOUKnVmc3hxW7We/dd9E5Mg==
X-Received: by 2002:a54:448b:0:b0:359:da58:1073 with SMTP id v11-20020a54448b000000b00359da581073mr31570108oiv.159.1667962624912;
        Tue, 08 Nov 2022 18:57:04 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bg36-20020a056820082400b004956ee06cadsm3846520oob.43.2022.11.08.18.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 18:57:04 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 8 Nov 2022 18:57:03 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 5.4 00/74] 5.4.224-rc1 review
Message-ID: <20221109025703.GD2033086@roeck-us.net>
References: <20221108133333.659601604@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>

On Tue, Nov 08, 2022 at 02:38:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.224 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
