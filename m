Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6FE17C7
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 03:42:52 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id l15so16548232pls.1
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 19:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3KYhp7BVqrVyOrznEFnFb4ZtNJLmanhkAsoLMLCOK+Y=;
        b=LPgJHuS2FiIrAtIYRxjA3746GLb7RxOpWi0NeNzKvSc4+BMO0RDlTqhT7JYLSsdiET
         1M3I1Hx1TiJ5Z1LbLl2JGlILhZnhMJ9RtPQLP22K1pCn+Ez+JKVVOH8qr/+0PfcvzUO/
         wkf3acD71POeh4SIT3rcTtSvt95pqRw5740wA65tJKx5fcFjtii3NkdqApoyDU6clLSK
         RctLCp0ROyxqhAAqjcOFIJTLe9wZXYo69Z9V3g07boIb++mbZkmoE6I5ADaMJFaU8xaO
         S5cqXO773bfepkOJ8pzrckkOYDWLAmbvdKSrWoo1Ze8yMbO0tY5soIdSGnxzGXyoSd1x
         kOOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3KYhp7BVqrVyOrznEFnFb4ZtNJLmanhkAsoLMLCOK+Y=;
        b=ynBOhtP/Xt+LCSmHK4le6Adthlk57VI6JXHylOIvt/vdQwrctIY5Rv3u8Aw5HfpMnY
         yucKSh+JzjI52BzJ9ATlgoZojPeBxtlYUSUkaw5z8Z/0HagAQcfkNDCYuQ3todog0CeD
         7yfFejM73e1IU3j+KFh+Em14BHvZuy+2a/cQfTATybgtcUKH7HaFHXa3FSWPSVaenVgp
         pvcRHpatoO/fMT1uE0CqNuDISlp23t7JvmB1T6Q4a/xVPJUzrSDkLRQ8QWylOhXXh6+F
         cpQOIXpDF/xOugN03jtdx8VpEvrHcBr42IbM698/bSnMtZbNDLHffRQ0kXPvWdC8U+Bn
         aUnQ==
X-Gm-Message-State: AO0yUKUqwBqdL9tUJXjr3I2BEpxQR1JSeoqiEIokuWkwkzRKGhleicwz
	AqjhDBMayogiE/pbMj5whtI=
X-Google-Smtp-Source: AK7set99C8IMLIReuTwpFk7MxtnjBQoYQrGFX5q06LsSMcZL/ZLPFgDBCra0D9aUERuIU+Bc6UnWXQ==
X-Received: by 2002:a17:90b:4c87:b0:234:b35b:f8e7 with SMTP id my7-20020a17090b4c8700b00234b35bf8e7mr14449372pjb.7.1677210171873;
        Thu, 23 Feb 2023 19:42:51 -0800 (PST)
Received: from debian.me (subs02-180-214-232-89.three.co.id. [180.214.232.89])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a0f8300b002340f58e19bsm424520pjz.45.2023.02.23.19.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 19:42:51 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 5800A106506; Fri, 24 Feb 2023 10:42:48 +0700 (WIB)
Date: Fri, 24 Feb 2023 10:42:48 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
Message-ID: <Y/gyOLu5VtE4MbTO@debian.me>
References: <20230223141539.893173089@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>

On Thu, Feb 23, 2023 at 03:16:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
