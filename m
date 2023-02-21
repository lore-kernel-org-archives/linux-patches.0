Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3264C64
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 16:20:22 +0000 (UTC)
Received: by mail-io1-f46.google.com with SMTP id t16so2373840iom.12
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 08:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WnsUJ3ZfQsjocJ1MNs8mmeQobzQph5HK/7b0ejy/R4k=;
        b=WGWXD4N8ZtnmjS02bYRr2xuqHXSrLva2PFeCtNfQTQOB2r8cpMOMUud/ejKUxKazAE
         q5wyIV1z66FNch+iu2ZAtfh7eFcoK51lRXrZP2k5Lkhq92ixCZbhr3d8F/QZqdJMA14i
         Vh3QVma4J0KA7bSCh2IfYBZ6+40I8a4IEQv/yPoOcnR3/gjLfu2WNgyKtebyLD1NAiJ0
         OH8gJnCmVMYywX9iD2cIAGEInQ7LGGbOgcULpZMEmnXWge0N6tf0f5KvYDLPYQcWrwQ5
         vhTLaCzC2hCBMxEZhxhFJwRn1F7/7zm6NzLrrXK566yfiHgaPP2tHn5rYXbw9SIfzJ6F
         RLYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WnsUJ3ZfQsjocJ1MNs8mmeQobzQph5HK/7b0ejy/R4k=;
        b=itrv8mTHLaErYC5mCSpcxWTQG7o1ovnftPMNW1uJjGigbBLRnY8lA0r+18wu4AybPU
         KAKAN/5b8pIZM3KEovjIP6p7EzVvQl+feEBfaGJErgrH3/I4KqBAZPX3k9lqfGN/Vpbb
         eEspJ+RejCAwT/4/lh/Nj/TDzsOzi2PhsK+8xmfS35qJqWFRlBtBctGvu8/XGyEbASN0
         H+LubIeeBmHZKd292g/LjUwEEwCzdn7D5kamVq45BEfofTn8agcsTwPgNUAM54U/8C6o
         uo71qQF3IIiLgpeS/09xHIVGJ4djRU9XgnZ9RBYrR2550fEqmNqrhr/DZFKf3jZYk2ub
         PLxw==
X-Gm-Message-State: AO0yUKUAN7l6pSaiafDOIYYzaW4PSc4qCaHr8JqK1YA7yptmFM6GlUCq
	XRKfqZb010dYlavyQDj7lUQ=
X-Google-Smtp-Source: AK7set8K26MePS+VB0vTMu+AJq8hl4TQYc1y3scWRkcT6GaIaxBWawpivNDabi94udeiuX04mJplEA==
X-Received: by 2002:a5e:880a:0:b0:71e:24ee:5352 with SMTP id l10-20020a5e880a000000b0071e24ee5352mr2645650ioj.17.1676996421620;
        Tue, 21 Feb 2023 08:20:21 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k7-20020a5e8907000000b007192441e5e6sm668397ioj.45.2023.02.21.08.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 08:20:21 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 21 Feb 2023 08:20:20 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/89] 4.19.273-rc1 review
Message-ID: <20230221162020.GB1588041@roeck-us.net>
References: <20230220133553.066768704@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>

On Mon, Feb 20, 2023 at 02:34:59PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.273 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 426 pass: 426 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
