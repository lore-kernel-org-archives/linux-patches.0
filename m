Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C7A1FA3
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 11:11:15 +0000 (UTC)
Received: by mail-pg1-f172.google.com with SMTP id h193so16448674pgc.10
        for <patches@lists.linux.dev>; Wed, 23 Nov 2022 03:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jcfXEcruqvTE2G0on9M/bXzLRbEd9FM+dGkOzqj5auE=;
        b=STg8oyDVjJ95ozkHYKBwCxoKKj15bLbGMbv335PGZHqMTJw86ZgweIhxINoun+8qds
         uxQIDZFk9WU19P0ojQ+Zu7EwZb8TThefYKUdIHexlXfDaSh5nHv0xV7/m2r7dXJd7Neq
         J44TUAqxfGi7ELpSAOc1UaAUtTyDQEDuMZziQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jcfXEcruqvTE2G0on9M/bXzLRbEd9FM+dGkOzqj5auE=;
        b=wZ46UKtgdFEfMpe3qVy8VHQEO9xHKKqntprYzbjw6YAL2kv9kDZzlQOuq5bvKyHqRH
         ttFH6b2ISYYjsPpDdAEq6vdWuUlODGevx+cvO3MuQ3d5pmjlN6XKGfTPG3uZW90FfdqO
         nT3yqBh+lfbKjfud1KSHPNU25dyy3r0N0xX4Ue90IQyqN7ayvSeKCHMawR8esWep+5nZ
         iYgLK59r+eQG97NDb9/6NARjIXGrf0XXfQVuP8UoTWvUNcZieqck07kVmsL+Du4EWel4
         6ShclKII4h0i7Jq32suKp3LtPIgmeDDRcVpHbSeN7jQDL2GSl7ZXTQJeg7el996+1bzI
         TixA==
X-Gm-Message-State: ANoB5pn4szLP9yV2N2LHMXmJNTOVDFdrzHhY+sbk4L5SHeiONuELgNxk
	uvowrtCQj0+DCFgDwSr8VKlQQg==
X-Google-Smtp-Source: AA0mqf5DeCVCvYGoX+mI5w2NZxsP2alnVqmS3+XGoCLpIGrKuvlbL77Knf091D8CiTaTFYjdMJf/BA==
X-Received: by 2002:a05:6a00:298d:b0:561:5d08:761 with SMTP id cj13-20020a056a00298d00b005615d080761mr11655969pfb.14.1669201874767;
        Wed, 23 Nov 2022 03:11:14 -0800 (PST)
Received: from 1682a9d2d5f8 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id f5-20020a63f745000000b0046fe244ed6esm10626904pgk.23.2022.11.23.03.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 03:11:13 -0800 (PST)
Date: Wed, 23 Nov 2022 11:11:06 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/149] 5.10.156-rc1 review
Message-ID: <20221123111106.GA3974538@1682a9d2d5f8>
References: <20221123084557.945845710@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>

On Wed, Nov 23, 2022 at 09:49:43AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.156 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.156-rc1 tested.

Run tested on:
- Intel Skylake x86_64 (nuc6 i5-6260U)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
