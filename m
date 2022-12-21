Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866B91365
	for <patches@lists.linux.dev>; Wed, 21 Dec 2022 01:07:56 +0000 (UTC)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-1445ca00781so17566806fac.1
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 17:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SA7wPis3qfy2mAWSDnJYGuGWdIgrAcp0Jn1gFSZFKIg=;
        b=m3NG5wkj/m7kkFKRhSMlP1JND+8MdIIGHEYBzxjoSqZYzVFd7KEVnfkvEch6PmjnRb
         i/b7L7frHtBLoOlumMAZhQz0pobwBxl3cOTXxqJ8Kto/Q2LOe01Oxv2mOLi37e+76ym2
         fC7hB3P92Nv8KZDLFutXoiJ4cJ/JG3f1Vgyemx9cseeNTtsGcZIVP1PqMk7bsOiCFz4P
         qyytWi1QmCNQXNa8HxGm6uitXW1zYAfxFzgHQeWoicCV76H5vk2pPjIkvyq5s44w3JkY
         Kr/oZOlZltX8ljNauhwdeISVUKM9apfonea/8T0ZKaLku0uOesz03FVV5aQx1s2MFp/N
         VSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SA7wPis3qfy2mAWSDnJYGuGWdIgrAcp0Jn1gFSZFKIg=;
        b=KTDcbEw3jtt/8W5v8hsRaQnahahC6saHZq1ifmoej8FvLP25jBss8iOKU0h8d4pB7k
         5fVdji+zAOIMWRFLGmg464Y179G7n38XKz0K5cLUcr2achJWVOsCxE74xYLdF2iDemqr
         KO8zFBrwcM8Incs2LZUdBQzJx2zTMFq2+V8giqNWLUIQElOag/EWjKLk+2aSYCw9/vfg
         ABdoPiYOUQm1Ywbd7XIJ2Moh6VuH8o0VRtAO1Rb/mjROI2JjBmvCTRf/BcPWhe7do4Wb
         jmGQfqK2sRh90pSugpc1mrVBfTVuPUBp1wa/Kn+yYiK/dDOZwIxBq+NH+uQXtDPpHjpd
         wKnw==
X-Gm-Message-State: AFqh2kp0oo147U6R+jRirhv9XuMjFFAI6Fs2mNAqgXrO4r0KT0X6oym6
	LvheVVW6bEeQoiVxNlZAqY8=
X-Google-Smtp-Source: AMrXdXtWoE9P9QibiVW9qIOny6LTxFjK29vK9WVgIiBvgohFEoMFmzx8osi6URBhEsG0FRcCFydeiA==
X-Received: by 2002:a05:6870:bac5:b0:143:fca2:e03f with SMTP id js5-20020a056870bac500b00143fca2e03fmr6943142oab.11.1671584875576;
        Tue, 20 Dec 2022 17:07:55 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j23-20020a4adf57000000b004a3543fbfbbsm5647721oou.14.2022.12.20.17.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 17:07:55 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 20 Dec 2022 17:07:53 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/28] 6.0.15-rc1 review
Message-ID: <20221221010753.GA1319848@roeck-us.net>
References: <20221219182944.179389009@linuxfoundation.org>
 <20221220144900.GD3748047@roeck-us.net>
 <20221220153302.GA907923@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220153302.GA907923@roeck-us.net>

On Tue, Dec 20, 2022 at 07:33:03AM -0800, Guenter Roeck wrote:
> On Tue, Dec 20, 2022 at 06:49:02AM -0800, Guenter Roeck wrote:
> > On Mon, Dec 19, 2022 at 08:22:47PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.0.15 release.
> > > There are 28 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 155 pass: 155 fail: 0
> > Qemu test results:
> > 	total: 500 pass: 500 fail: 0
> > 
> > Tested-by: Guenter Roeck <linux@roeck-us.net>
> > 
> 
> Wrong results, sorry. I'll resend once I have real ones. 
> 

Here are the real test results:

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 498 fail: 2
Failed tests:
	arm:xilinx-zynq-a9:multi_v7_defconfig:usb0:mem128:net,default:zynq-zc702:rootfs
	arm:xilinx-zynq-a9:multi_v7_defconfig:usb0:mem128:zynq-zed:rootfs

The arm:xilinx-zynq-a9 test failures are seen all the way to v4.19.y.

Guenter

