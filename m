Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243C22102
	for <patches@lists.linux.dev>; Wed,  7 Dec 2022 14:26:47 +0000 (UTC)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-1441d7d40c6so21414620fac.8
        for <patches@lists.linux.dev>; Wed, 07 Dec 2022 06:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TZKo5xO8WIl4oGvaEmRGqMfk5H6mgyCctKN9hJmv1CY=;
        b=BoG1WB2FajwvV60vaIW2rUvrU5pXrzMfEfjM7SJVHYc5YXVAFHhb2ww0ShYPurNh+l
         0oeFrmezDcOzrY1KjzYqznUe43acMWJkaf2C6yMH+oY7OO5hcELSxQ+vWTkq+sneGtLl
         MtsVqGhtFsya3ruMHeFDGUGaEm9XL1AHi1OB0bwHQEyZFsnHXNCb2ItvDN+IH/xAi/vM
         2ZaD8s8q+q78B3BbC2LRkFoOCoqhH7unxB0XqTOabYtT7JacYg6L6xC0RNmDPNY3j2tH
         rPn/MpoqtHGGoXwsA13o8R0lHGqRZqWbE/1vYGDZgJFXn6KI/mL9/a0bqL42EWoKNzI8
         kxnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TZKo5xO8WIl4oGvaEmRGqMfk5H6mgyCctKN9hJmv1CY=;
        b=d8KEeEu3NxVN522YYZgrlWq2tug+4FXgNja/Xn5L7ghwpsAn9CfSpHQdfbnrnRKvc1
         ysQjFXfa9+pbKKNCOAdvtFzwjygkdBApZPv4B2hw8EtGYb7+JdjXBhY6nnpcWTsshsUQ
         OlLVQPrwzoKpb8W6x7niXRmXqAgKThbJzLpBrs+UyzYgjwJBHNwFIAWDqRPhYbyfOvS4
         91evfUermmrSqw7OCH1AZLKtI61iFI5sbvBvqVz5+8GaXdhU1XhXPoze4BAbWduQCFDm
         QtqTOg2OmWwKA88pWch/zrfLwblwB2zuT8JoDowhpzOwE1Vx8KEq+HyRGVi25u4g+V3X
         eSJA==
X-Gm-Message-State: ANoB5pkiAtYRg0lAuBjLaZ3l0LlSkE105wZO1GCSXYEMmoqzKyyN3Bpl
	8OB85zDPch2h0IUXH0gyh9U=
X-Google-Smtp-Source: AA0mqf7Aj68x0HUh8BgD3XGGHsQgkMjY0E5h6Ke6Dch/AM0Zu1fPvnM26olu03RYiD8JhaeRDzh1Fw==
X-Received: by 2002:a05:6870:bf0f:b0:13b:b20d:5c72 with SMTP id qh15-20020a056870bf0f00b0013bb20d5c72mr41857101oab.200.1670423206124;
        Wed, 07 Dec 2022 06:26:46 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m22-20020a056870059600b0013c8ae74a14sm12213112oap.42.2022.12.07.06.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:26:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 7 Dec 2022 06:26:44 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/96] 5.10.158-rc2 review
Message-ID: <20221207142644.GE319836@roeck-us.net>
References: <20221206124048.850573317@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206124048.850573317@linuxfoundation.org>

On Tue, Dec 06, 2022 at 01:42:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.158 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
