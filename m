Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A372808
	for <patches@lists.linux.dev>; Sat, 22 Jul 2023 20:39:56 +0000 (UTC)
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-34642952736so16853725ab.3
        for <patches@lists.linux.dev>; Sat, 22 Jul 2023 13:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690058396; x=1690663196;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sheU/pN73man5/rqxD6wz8PZXz+NHmbMVYqD6and/RA=;
        b=TwmodeBddlMtX5sAq9tJazwTjv9UEdk8GqnWgSR95BB8aIu2J2k5STrz8OGCU75EpP
         Zsj9UdJaP37rJjmsL/mJF3fWvBqaQwm+CTNmGx4ZFaP14H72Qb4a4Ksu7Yq/+umZP4T7
         1koH93do9Cu9t9ppHo40UVObdsu2NF4hwE2jAbAv+ZtyTXNHi2TL9/yfjSTPCwoXMxLO
         ZZt/VGBAUTyGbIaOA4j7pNY7wIvIDlmHZ8qZ7eeehktI2r+7BBCtwlYAo9ZgUfT7aYKO
         r87qWcO57fYmUgY+g7nPQQyxl80GYv5mLQDG5jVxj4pPU8S/Ycjdy+EcdWtxlYguZu98
         ALMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690058396; x=1690663196;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sheU/pN73man5/rqxD6wz8PZXz+NHmbMVYqD6and/RA=;
        b=kNJ48JgzorcuunR2UZ11yteqErdG+BnXmTbsxUL4EKd1WoPXpdkFDWeUxIJXCbplDJ
         6J7RbGGMZz6SAvXb0ghP1oU5nBUHPxEK7YSHi7I6VpZpK2hAudMc8yjr/SOkLUbtPQbR
         GelLCEtMSpzTVUH7kxPEL6UZjuFnRr+IPO2lrL0elyqF+LNh4UgjJKt8gwk4NxtpBhr3
         PE4YLncqomwgmPjFaJX/aWzd71dOHkEuZWfBiz7mVUSVT8yM9rzu5atOnZHV/6XfV6aX
         SrjKgHEpfiB73VTgwqZzqA3m9AfNciB3I5PDOgtIwQwijrlz37Ki94+RfGbl0kuD4+OI
         5hAA==
X-Gm-Message-State: ABy/qLZWFhbB8VECFv8AfcXDcXp7nsudDiSizk57aaaClVMiE/8PdPfW
	TIAq0iBu3rSX4BS2TifBWCI=
X-Google-Smtp-Source: APBJJlEnLGewhEaGoGk+H8xEsKCQEYSwxvo94/nG7Z4zmYJS0sHzwrkhPKC/JJ8j1/Ud3VyNZZoxRA==
X-Received: by 2002:a05:6e02:118b:b0:348:a412:b1e2 with SMTP id y11-20020a056e02118b00b00348a412b1e2mr3973542ili.14.1690058395938;
        Sat, 22 Jul 2023 13:39:55 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v14-20020a92d24e000000b003424b3d6d37sm148021ilg.24.2023.07.22.13.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jul 2023 13:39:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sat, 22 Jul 2023 13:39:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 000/532] 5.15.121-rc1 review
Message-ID: <b07a1b7f-8c54-4e9a-8b35-28fd2b12eb75@roeck-us.net>
References: <20230721160614.695323302@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>

On Fri, Jul 21, 2023 at 05:58:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.121 release.
> There are 532 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Jul 2023 16:04:40 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 502 pass: 502 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
