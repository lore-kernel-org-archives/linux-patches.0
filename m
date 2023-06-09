Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30F97E2
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 00:26:44 +0000 (UTC)
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-75da00a1eddso120711685a.3
        for <patches@lists.linux.dev>; Thu, 08 Jun 2023 17:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686270403; x=1688862403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CSvF1kXjBVqORXWJl1VpFJ19jMtWDkAEwUrdeGrCGho=;
        b=oPworUcizTNCZLkeD6AE1X2GgLcgTHNCCglRnabdiC1JEGAwwMgh79DF3lRfuuYLSG
         myyAqGZ36ZlEv48olY3uF8Z6F8622R63lbJiAOFXCNNUpYw4phOip9JvkhNxWBnL+ucB
         qHvrgxQP8HOCobXfhb//7ao61G8m6ho9xfYLNqP6b6E3m6M75zzzpEs2EN1mHUoOhsLx
         med046uB56EfM5awrGEZh6+yjW8WZIvjJC6XOVcdJkflh7ixpjb1z3rmqKTv9hr5BiNP
         z1G05v34vlUesIdDQXK6/TuWXQq9c51Ki8KdfftYDANx/f9uuaHeKdRa9i41MgDiHNpH
         jGeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686270403; x=1688862403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CSvF1kXjBVqORXWJl1VpFJ19jMtWDkAEwUrdeGrCGho=;
        b=crrAmbbT+1a75/oFi5Cv9EyvXGguGXvD0wOHSKngCjvDP6kMRUXczYHMWnFBHElpo+
         6UyjzdQAn9T9kEv+BFRI4maGW3kxLV+jgxigKd1Zs1Tl6RHI+RD3YnphjQeKW7qOJyX8
         UT3JN2hw+4/04fhWxtfy+Jx4Tn6kOmMcAhAwdtltBj7Th+vX+dMfnZujN/mC8FliGtKa
         KvkyBraxcbmhjk33kaXf0rcG1nYkecZxnakCHt7i++mDTYSBJksO9/ovzkn0EUla2dXQ
         mtyorOKH8t3dsYJy1bgiBMrBImwhG5+OnroWw6hGcRz7YjrE6O1W4up3MS/ed89ExDBc
         HDrA==
X-Gm-Message-State: AC+VfDzEIwbn6Ixx13kabGAOQ+vn5Cq8tlBe9l+Y+3dcGnF9Z6fEssiv
	olztBpdZIG4juatP26M8jsU=
X-Google-Smtp-Source: ACHHUZ6P5gN19nyrCAbbXKebZIGih4YPKE/q4d35wzHys8hbCAw/pNlW9xliu/aGknBGts2UBFap9g==
X-Received: by 2002:a05:620a:1b8c:b0:75b:23a1:469 with SMTP id dv12-20020a05620a1b8c00b0075b23a10469mr7109768qkb.47.1686270403571;
        Thu, 08 Jun 2023 17:26:43 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 30-20020a17090a001e00b0025043a8185dsm1884185pja.23.2023.06.08.17.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 17:26:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 8 Jun 2023 17:26:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/88] 4.19.285-rc1 review
Message-ID: <a85cbe67-3e19-4bda-b6b1-b5ea08a5dfb4@roeck-us.net>
References: <20230607200854.030202132@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607200854.030202132@linuxfoundation.org>

On Wed, Jun 07, 2023 at 10:15:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.285 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
