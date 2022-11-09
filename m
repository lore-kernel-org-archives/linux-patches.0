Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F124E29B2
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 13:54:44 +0000 (UTC)
Received: by mail-ot1-f49.google.com with SMTP id 46-20020a9d0631000000b00666823da25fso10154444otn.0
        for <patches@lists.linux.dev>; Wed, 09 Nov 2022 05:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/epm3ScqC4GWlKhg/7VA05KC4J41B1cVP/6AFUBS4Gc=;
        b=qo9wSUPViGxLQKEbvd5RAvF0I6z7z04d65jczEDXkDIx+Q4obVhH7Qn2+D89yKtsRz
         l4QAG5uIGwivFHV82R7vL6dv+DaogThXunFvJMoO+yCBIeglSUnP7coobgCmWSEUvzRa
         /aBRqSy7fnY680ku9o7i9Jjw015Ql/4mtc7AfOPdCQl5N2tbNbKiM3RPeAP2HRsDPcVY
         OyNOmMpTMxW/a+92V5+GcDXfz7ZF78X5QVFnc4UL+O1kcnBSCQ3iuSp9vcXzBTpMauHz
         jIMHZ7XxH37rkxHM6KbfHLaTKYXrZi1JteR+JNLJUlMZS3jinoutympHFoFUpKuAUXO4
         hekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/epm3ScqC4GWlKhg/7VA05KC4J41B1cVP/6AFUBS4Gc=;
        b=ycRpisyvmMpBnpMZjCMRKHWdzFZJ2f91EDQJsGLbCQA6/IkEd7p1tbrNECLG+KC0CW
         vNyrf+mEH5JW6JZEZZ4fp0/DOTqehM5kyGgCjMyqFvHmdkhf3vq7Rc1qlLYfZ5nXclfU
         ECbltd6IcexkY/TRBGS98J1amUDtN02A3+6MjhdRuWle0yQixFwYeYtI6FovO1/+9qba
         UL8NZvbO0KPbLjT2qDleTjxcWAfLLfVh5Llkzqp45jdtQQ26q+/zNsp7bCIV2TQEY/oI
         6MLJIcZcZmVNSF/Fzv6LitdHlgYymyEEr/SU6lEk1Rp2gPYj9WSZOKSaWn9ltCKLtYpN
         GRsw==
X-Gm-Message-State: ACrzQf111aB0MRvbt2KKytCTb18CmIBR5dhst/n5kaQ3JwqqTzLZjvgG
	pg3hSpUTx8iWLYwdotF9OtE=
X-Google-Smtp-Source: AMsMyM5nE1GK0w1aYEymkAlj7IHJoTlVFC6/S43Rz/6kXC01MX7zpjLZWrFbdy1bDV+sm0WhzH9Vfw==
X-Received: by 2002:a05:6830:2901:b0:66c:3305:4ced with SMTP id z1-20020a056830290100b0066c33054cedmr28489108otu.300.1668002083915;
        Wed, 09 Nov 2022 05:54:43 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f15-20020a056870210f00b0013ae5246449sm6084549oae.22.2022.11.09.05.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 05:54:43 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 9 Nov 2022 05:54:42 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 5.10 000/117] 5.10.154-rc2 review
Message-ID: <20221109135442.GB3538893@roeck-us.net>
References: <20221109082223.141145957@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109082223.141145957@linuxfoundation.org>

On Wed, Nov 09, 2022 at 09:26:53AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.154 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Nov 2022 08:21:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
