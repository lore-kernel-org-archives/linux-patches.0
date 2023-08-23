Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45936BE79
	for <patches@lists.linux.dev>; Wed, 23 Aug 2023 13:37:23 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-68730bafa6bso4438033b3a.1
        for <patches@lists.linux.dev>; Wed, 23 Aug 2023 06:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692797842; x=1693402642;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RBV4mVZycvazG00CEeCMMgbKdtVlMwGoxgal96JOqm8=;
        b=c5uK2/yEVgheGwNDxvDtN9jont/mVokfXSQiVzZsDZ27m1nzBvGUCs+OVscEqOk3y4
         GFO/q/ceygMb1VUrgLAamTQfIVn7X2mmsK2G6DR/mPuFrLUF2OVEygUcEJ9U7RGb+OH4
         SxoO1xo5KsdCkF9FpFI5dA6r8gdHzJEsO/9XRuqw/CEDzeZa1a64ApkZMfwybtZpuSt4
         AF2B4aloPftmiD9Bwt1mixTNBmjRCop9z/nykfBrMwu9NeywqOWxSv3OE1FqJyj7kuAu
         dcGsFbCkVUtzMP7LxZ3uUikwkF5tUBEhX+YFinaQbW6HbzmIhT/RHDH175AZkzkhUDdU
         FqdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692797842; x=1693402642;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RBV4mVZycvazG00CEeCMMgbKdtVlMwGoxgal96JOqm8=;
        b=EswXl1NeXl+lx2SeiIAgYY6sVo2Ro6v8O1Uh5hMWrZ4fSX+VtvM/gNldxt4Ic5lYv7
         o73nDrU3jd0/X7YTEP0bsAHX1tSnJLtjFU9PjMl8yQ03Vn/EBhLSu9X2hXBmPWrS27X6
         8U4RhxzwbVIJzYl7yEB7jF5zog6kfUKlYK2pz5JbIVWvcEZK8N3nOuuTSF3uHFBfHejV
         wDE0iiPNqNQwmoLywAbsfp+VKBEiA9HLD8a1vFOiOBmJ3wDW2n2E21utUPgDeGT5oIjf
         MsKStzZaXrhwyE8yv7B4QIEWooMlS3Jh+GU1aBIwTjGbRHlV5CMIk8CNs1vFJoLriPmr
         8Zcg==
X-Gm-Message-State: AOJu0Yxdbs5JLz9SCCy6q48yYzR9ApzpnLPhy/Hl0oa5ThGgzp3+yg8+
	VaRlHG5TAc+GRZ0CdTjLi6Q=
X-Google-Smtp-Source: AGHT+IHwfzJtIZvvvhyk9RroOV8k3n3HK7klBFMpH4M6Jg/WjJb12HaE3OAFIlpqdFIcmdhuwkwPfQ==
X-Received: by 2002:a05:6a20:8e13:b0:141:2cb:2954 with SMTP id y19-20020a056a208e1300b0014102cb2954mr19555782pzj.3.1692797842480;
        Wed, 23 Aug 2023 06:37:22 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u3-20020a637903000000b00565d82769d1sm9826613pgc.77.2023.08.23.06.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Aug 2023 06:37:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 23 Aug 2023 06:37:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Conor Dooley <conor.dooley@microchip.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/194] 6.1.47-rc1 review
Message-ID: <fcd08630-6ef5-46fb-bcf9-2be5233226d1@roeck-us.net>
References: <20230821194122.695845670@linuxfoundation.org>
 <20230823-washer-reemerge-a412d55f8214@wendy>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230823-washer-reemerge-a412d55f8214@wendy>

On Wed, Aug 23, 2023 at 10:35:54AM +0100, Conor Dooley wrote:
> On Mon, Aug 21, 2023 at 09:39:39PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.47 release.
> > There are 194 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Fails to build for me with gcc-11/binutils 2.37 on RISC-V. The problematic
> patch is "riscv: Handle zicsr/zifencei issue between gcc and binutils".
> Can you drop that please, probably from all of your branches. It
> certainly affects 6.4 too & I don't personally test anything older than
> 6.1.
> 
If I recall correctly, I had to be careful with combining gcc versions 
and binutils versions. gcc 11.4.0 combined with binutils 2.40 works fine
for me. Note that this doesn't just affect riscv. loongarch and ppc are
quite notorious for that as well.

Guenter
