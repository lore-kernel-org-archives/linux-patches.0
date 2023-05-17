Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832BD17D0
	for <patches@lists.linux.dev>; Wed, 17 May 2023 02:53:03 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6436dfa15b3so143766b3a.1
        for <patches@lists.linux.dev>; Tue, 16 May 2023 19:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684291983; x=1686883983;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0knSTukOUoEA/wmGwfwoC/dUcviWijr3YWx3zmFpESE=;
        b=I2qhuRSewJs18B8O4auIVlb/sAKreimAlq3iRAucDkEok4WWKA6apTvqsY9XTtXWrh
         Gxh48MzPmvUF6CZZts9tBpETwZSijWSpPFW2NtxkPXCHBazJe0t5Z4duKKZ4m3rnJoWc
         Q6U8HktZycdtl6JnMjkK6K188SnFg52UXwgbLZ7fMsJXgLYbQ3UrnAZl+eFI2LverAVi
         sTaADRiuGUgyJwjRweSx10myrgtSWIqpkvO8afpGkWYamFRKqy6m49yUfBWBzMSOslEJ
         jxJMlhmHsd74hJOqUixoeS732tsIdI+6y38W65dw42QBhigHm92CWYQ30sr5MX0vlH9g
         8JCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684291983; x=1686883983;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0knSTukOUoEA/wmGwfwoC/dUcviWijr3YWx3zmFpESE=;
        b=Gf1le/bnxXEqnjhl9BbXxduj8wayK5Im4JhndIa9Bg2FJwUaGFFW8E0oQ/Y8D34X57
         VnoL9mfltj9PfziPrPWBJdM0TGmO0EgFIq9fbyECrpYQyZPDVnFQZCbZCFaaBuKg590Y
         cyiaUkqns2TNTvcOzxw+Sqa+DD7/9J8/VG7Mvq8FopLQWF3oV+WEuV3v8iJP3WEJfo1S
         HfbU5qNypX/6UT/LUmoCoNfwQN/uynILFBUhTHX1OQxLwtDrvqEPGwnXTIf+kTDTc0WH
         7dyore3VVVAxGk0mPMMebRmkkC3h0FXLZr3dOll2FV8o8jS+Goh1UbNy7wl3s3R4E5HB
         eSVA==
X-Gm-Message-State: AC+VfDxsnmOZj4awtovj10lVOVZb9L3nMDnbK02hNuN/62j2QoPNZdw6
	fv0bqnKNsknk/1cJGC2ZkdE=
X-Google-Smtp-Source: ACHHUZ6a0/RxnXNMIWD1GSAs8zOBKY2SfU8HCTVG/QLyFqdcVuSI5jdpWPU+VFRkizRuPS8cqFjydQ==
X-Received: by 2002:a05:6a00:1813:b0:64b:50:240d with SMTP id y19-20020a056a00181300b0064b0050240dmr17694439pfa.5.1684291982915;
        Tue, 16 May 2023 19:53:02 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u11-20020aa7838b000000b0063b6fb4522esm11077308pfm.20.2023.05.16.19.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 19:53:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 16 May 2023 19:53:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/242] 6.2.16-rc1 review
Message-ID: <233bbd74-0d89-463f-9dab-c057f8dac7ff@roeck-us.net>
References: <20230515161721.802179972@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>

On Mon, May 15, 2023 at 06:25:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.16 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
