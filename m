Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770321C04
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 17:02:46 +0000 (UTC)
Received: by mail-ot1-f48.google.com with SMTP id 94-20020a9d0067000000b0066c8d13a33dso11570812ota.12
        for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UkcutNoQNHT0SEKewV5b+U7+CaUSl/CCAj0E129sAe4=;
        b=Pw9aCddYqFM/i+lfl68OL5qgY5DG1TjgLucwc+QHIo2LNS0wRAclUjR/Tui7Ak1zSD
         LuT3ArRzw1jBikSh+PB3tHqeXRhtmZDbic96Eg2ce/mVTCMpNSJXz4XNUODUkv8qLa3O
         4sA2yxSzRequCqVTknSONwrpRUrC36NP887L63/QHZD0RMdWogP9L1Py2SBDex5KkyuV
         C5Ey2tAbWX8ziNmHzVVx9a7Gh0DBvft9GEdB0luK07Dd827TtLi3X7g58e5omVLbOAUk
         HxYF4+YElrBrluC984WBm1JCnn3Xifdbl8FQkvxVXfBnZ/09COpE4gXyH9jyAWaS3Fh6
         JrzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UkcutNoQNHT0SEKewV5b+U7+CaUSl/CCAj0E129sAe4=;
        b=xZc4ABRbfAYtF4PpyRpnal5cs8KC2uEINb0tk0dDgbcsJ8OXgb6gtr+4OzsjEBWqdG
         +dIoNY/yRCCj9VXBOSa6KGXV2tovShwndTtmSisKkFRp4xOVV/zGyH4VjXWJYkl1d8jO
         b3FTKd5jNp3nlhZ9oSPE3CxYr+2JP8/DXNeyz6fZMm2gc6F6G05OfUy2HYzARkJiZinH
         LZtDs70BbfBTyqN/e5U8YASlsgbTlRsm4AULFvhJ4z33jJLboq3SHcCJ/aDEhFAH2PTd
         SNnTHJ/1M6HTqZcibqpiyUvQUQ8px6P5ckxc/6arxMcBJaO6YZDSpQvZBcxRUHEERiND
         cDCg==
X-Gm-Message-State: ANoB5pl7alX33cwRKDVcZq+ucILnikbvV32eQdheN3eGefUNrlAPBayf
	BEPeu9AOb7poSXd4LdD2lSE=
X-Google-Smtp-Source: AA0mqf4BOTNx3936uKcCuJ/1h8jvtibalq4JjNNo65ZNWJwuzlEAhKRnqAxJewVZMGsiSgw0LlS/sQ==
X-Received: by 2002:a9d:628b:0:b0:66c:6afa:5006 with SMTP id x11-20020a9d628b000000b0066c6afa5006mr8430705otk.233.1669222965494;
        Wed, 23 Nov 2022 09:02:45 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w11-20020a056870e2cb00b001428eb454e9sm8168566oad.13.2022.11.23.09.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 09:02:44 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 23 Nov 2022 09:02:43 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/181] 5.15.80-rc1 review
Message-ID: <20221123170243.GA3745358@roeck-us.net>
References: <20221123084602.707860461@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>

On Wed, Nov 23, 2022 at 09:49:23AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.80 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 

Build reference: v5.15.79-182-g1ac88d934860
Compiler version: arm-linux-gnueabi-gcc (GCC) 11.3.0
Assembler version: GNU assembler (GNU Binutils) 2.39

Building arm:allmodconfig ... failed
--------------
Error log:
drivers/rtc/rtc-cmos.c:1299:13: error: 'rtc_wake_setup' defined but not used [-Werror=unused-function]
 1299 | static void rtc_wake_setup(struct device *dev)

Oddly enough caused by "rtc: cmos: fix build on non-ACPI platforms".

Guenter
