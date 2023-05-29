Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1D48F71
	for <patches@lists.linux.dev>; Mon, 29 May 2023 16:07:53 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1b01d912924so26823525ad.1
        for <patches@lists.linux.dev>; Mon, 29 May 2023 09:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685376473; x=1687968473;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=urDTXxsjrGokKJEuNqWBCmuPnIpK8aci2gJZ6+Wwrwg=;
        b=CDbxiHusCRrK1WBUSPRq4/nPfMfdkLeA1pOc8mTjLfeloNGcpEgZrCiT6snSsWb51z
         E7Bc/SHwCYiix8HdHRljCm0fjW2+DQjuveNO40FQin9bd/Oca+1jUjk/rJ763JvhVvyI
         1XD8L3OEevHlsye2ATa5xV2SNTiKnpGfzysXgBdkAVdGoBJtfeXQpHJal93eEdFbtyOz
         Alw9iwgX2dgi1ZiZZi3BU+fEqPMXNQb4+BJxeI2YBbN0QsrIUutCVIrgJeX7+LbNS1vI
         RuAoF+ORZEtK3hczBN5gVdcCZkk6YQM6UWnr997+9QhrUvOm+zm+O1iVtcTsZtKQfTBY
         XdUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685376473; x=1687968473;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=urDTXxsjrGokKJEuNqWBCmuPnIpK8aci2gJZ6+Wwrwg=;
        b=CE+lN3XLc2dj+GshAcA5iXfwCPIjvIhZahiKcdcm287wHPhg99Wo9HWD4+0n0M5rLv
         CFa7F+ly2LexDsaodU48yE/y4S7KelQNJVcE3IjX8UFZFneXab/QVwNB+2M0zWwJoKiO
         9eXchxplYWMx0KDprsVmAHAOvhAlHXr1+mBe1fSH3AA7SewBVlnR3QolOMjrjjlBltaZ
         DkCH7kjsZWNyDbYf64U04u0kvNcgX/EFO440Vz/juyysTqsYxtgULpUJI7PMDJnBZMAm
         SqZmNSwr+5AG1+iKRClZMxAVmkTFmPLy71D8agX2B82lZaS1I49BnnQMBR7a4CiFEVs4
         NzDw==
X-Gm-Message-State: AC+VfDxb6XPp8IfOmHTyiOoAyW38OI+6WDdOQWTnXvQ4Ty8MwjJ+h1KN
	1lDmtB6ZhxwcO5MuXRm8WHs=
X-Google-Smtp-Source: ACHHUZ6K5y6yBeaLBTeJEdyC88S46Gtr0nXUkQKk46+Oj7BqXmPbAJPfXHOABg+IPVlA5applL8rRA==
X-Received: by 2002:a17:903:280f:b0:1ac:a6b0:1c87 with SMTP id kp15-20020a170903280f00b001aca6b01c87mr10631105plb.48.1685376473490;
        Mon, 29 May 2023 09:07:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 17-20020a170902e9d100b00199203a4fa3sm8466280plk.203.2023.05.29.09.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:07:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 29 May 2023 09:07:52 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/119] 6.1.31-rc1 review
Message-ID: <7969ae12-4c2a-486b-b41d-1cb18178087a@roeck-us.net>
References: <20230528190835.386670951@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>

On Sun, May 28, 2023 at 08:10:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.31 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
