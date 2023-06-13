Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABD71361
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 23:08:57 +0000 (UTC)
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-39caf0082f3so3174430b6e.3
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 16:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686697737; x=1689289737;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z9M/ss+rdoBanhZ72S4Y+ozQ77svOJMSyhGeoYM/6yQ=;
        b=R5A5l6QwgwIPYZcsFFFFNVy24AXx7/WY2c5KrZ7vW042rFwhFGIFO1vzW7sC4oGEBW
         PFjRLh1GV4BjzJjjoaPr1M+NSbz8lYuZHHb+xilq6sF1oYhQohD5B7SZOs22DqPsjFF8
         lMf6JwqhBAIi3aT5aIqgObSmWiVIsgniFTggRkz/or1IdGtv1UgboxhnmQ+OgDXIbq9J
         4mL9iehwAV+vK/BnrxctbSfFF238NOoqZw0fFzlNVcK476hVaifExiTw/IS7rpEX+fiu
         gNDgkuRUuMW4cGRIVGcchp8/PssRbONveNEQBCLdnC0YEProGV3tTQ0jdADC4B6ESjfv
         U/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686697737; x=1689289737;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z9M/ss+rdoBanhZ72S4Y+ozQ77svOJMSyhGeoYM/6yQ=;
        b=NjL+1iIfrPh+SOpCo8Z1b10yVyJmU5zPk62Qbrm9qxEw6TpJsDtiPHEkHSmmnYVwMN
         gxMh8ew6WCL1sHpItD2j/4nVSe2P66xwM2bfR9Fqcc6GUMlHkHBOhyTPy25V729tVb2e
         mTKo+lEbXXgIcHrxrfIIR8XH1h7QPY4MqR85pAeVQGFZnxn018cr0Io/OatUERS1q/IG
         gavxwzAH9k3k026TeJ/i+6pqTIq2keDWIt1iYDsEo4Il6S3ZBeREV01ivhWnxK0ppoFv
         o2Je7pIGWWv/JOiGyNcpHxovxgH8jy7ca2zETmkNdtW42Gsmgn5aXmKVNqATYCQ4GQNx
         axpA==
X-Gm-Message-State: AC+VfDyylO+eJAUF4RuDZ2iA/an5Jtr5aVHG8j8kf4aC/5+h23AUT0Ro
	fA0QpwUyvQ0puegoMEreQMY=
X-Google-Smtp-Source: ACHHUZ4yLU8QuJO0JPZqzDcwd6u0OOvYXRoadqagnOkHPpdqXHYSLIcFh01J5GDJu3By7WpG4Olk4g==
X-Received: by 2002:a05:6808:3089:b0:398:5df8:5d63 with SMTP id bl9-20020a056808308900b003985df85d63mr9237538oib.16.1686697736771;
        Tue, 13 Jun 2023 16:08:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s19-20020a17090a881300b002532ddc3a00sm11468575pjn.15.2023.06.13.16.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 16:08:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 13 Jun 2023 16:08:55 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/23] 4.19.286-rc1 review
Message-ID: <3879bcf5-e472-4a0a-9de7-49c767b23ee9@roeck-us.net>
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

On Mon, Jun 12, 2023 at 12:26:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.286 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
