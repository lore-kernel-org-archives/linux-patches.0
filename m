Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7B8EC3
	for <patches@lists.linux.dev>; Wed, 21 Jun 2023 00:38:39 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-553a1f13d9fso2960848a12.1
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 17:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687307919; x=1689899919;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z6jTOFm5SC0/E1v8Dy/9a0PYzsnVfaB7TCXxz4lclcQ=;
        b=CAAFdeIAhI0kCKKXG96LFa2nxhHSC51CFixnF8x4/0r7xcJYP0zI0ghpeSJwD3w4DG
         V5whw/eDAeK/vvrG1OUDJcyjqzSMD6vblO1zSsC1JHlO2/jCnP3mCPJ+Pu9J3wb6zTFg
         ZIvoNkt1HjLrsX72axV08f70m6z8na04J42Z15fmCiEG2qeAQDSB8vyBNieiyiaBBQZ0
         k0VbfgFGHqXKs0o7l0RcGwbNdmzGzq1uaSqb34Vv/Zg9cAL0JZj3bSgvB9OPBRcM9vqn
         uHNntgpJxLUnrSGY0W/ZgmyykQSGwgbHlX5QJ4fU2LRrleauow9Oqr8QkYKeI/10+YOW
         oXug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687307919; x=1689899919;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z6jTOFm5SC0/E1v8Dy/9a0PYzsnVfaB7TCXxz4lclcQ=;
        b=fB1k8p8nSOmwbcBUkaPHhMRxvC5d1mO4o3BMrdJ0iQ05AwHCQPEy3UJ4LfMyBldOko
         3RMyZ061n0tpe4YHL9TYabzH4BK961uLQbBp2CaasW2KlA7a6GU9XLDcaPVGTc508Dyr
         IjYr1dx/J78OEqKdeub+WH7kRK09tT1WZJ5QRcYbAYip74wn9CZFJJmOiAMc8ghBJi9Q
         WOmcMusPbTPC2Let+amBDaniEe1sbkK7dqQ2jqfVp8l9Dw/zzfDA+16nY765jT2SsoFK
         BBxgN/RjRvZuvpKVLtvTHDXD5MmdwXjCAyGMsPONZImDNLxX7WfbQEQld1NnEw4dx9iF
         Jqiw==
X-Gm-Message-State: AC+VfDwOwtT8NVHG0oGnjqhrj38yiO8uFkNjicGdXwowOcrOPpZQB3vd
	yww0PtmstGxHXq6tRaeRZuc=
X-Google-Smtp-Source: ACHHUZ6v7mFwBN6L93oYixMwrZP6/CH/ftr15ZYYgBXwF94zmmQmtviieW/04cnjRq44q+VAQ9aHnA==
X-Received: by 2002:a05:6a20:548c:b0:123:100e:c8ae with SMTP id i12-20020a056a20548c00b00123100ec8aemr1277622pzk.52.1687307919096;
        Tue, 20 Jun 2023 17:38:39 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id jn9-20020a170903050900b001b679ec20f2sm2164377plb.31.2023.06.20.17.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 17:38:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 20 Jun 2023 17:38:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/89] 5.10.185-rc1 review
Message-ID: <889335de-3b21-414c-8395-cbb92e58a950@roeck-us.net>
References: <20230619102138.279161276@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619102138.279161276@linuxfoundation.org>

On Mon, Jun 19, 2023 at 12:29:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.185 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
