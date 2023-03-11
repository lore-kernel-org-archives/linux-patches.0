Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379397B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 03:27:59 +0000 (UTC)
Received: by mail-oo1-f43.google.com with SMTP id p6-20020a4ab386000000b005252182b0e0so1083520ooo.6
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 19:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678505278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=73ltC76ja99SXS0x3lMZJ2kFcQpVMIC8+o6DWphx0as=;
        b=WAE1M2osG3fr3u4cGgm8Cir0jz9AXvwKp9V6C24VF9BjrIjP50T/2Y8KVzjT6kaDFc
         0cpyud3g2DeCqmMLz3LeitTcOcUTJJ0hzeZyiiPN06eRtQoxlfptZemulqtESlCWs+q+
         /Fxyyy8Hb+ksitfSS7CRrFVm04+zE2lkWK3nXXcbBYULLmMWsATyvoRfCAhG2QMvhGFk
         NQiHPJ6z9AHW3VvQOGlH+RUnt16otESpgeDdfBi5Xv+xZe/GjtkeJ4RGkVlYHN0is/Cy
         jU35Q4ywXngSzLQYxIG8H5/SgyOqKCbltZl7ogJ+0iWCu04Ntvw7f4zB6ASMbSM/fj5E
         eawg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678505278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=73ltC76ja99SXS0x3lMZJ2kFcQpVMIC8+o6DWphx0as=;
        b=UNGOs6NQ6LG9ms3qRgzSToH3wwnh7hnNMZjXGM1uxGGPuaj8SzgpJF7EGCLGN6tUQK
         bWy7ksitIyx8Ex1Pjgtnbj97rj/PUJ/Z2Vb4t8imWTIouGvN8A+jG31s1AbGBB/V8YuU
         TycqbR3QOV2T+YnVUg6GcjIY+Snz8+QbfdzM222qOcPCnXmlfyJtJNLuuTsDgFW39MOG
         yQkaUprDT+qG/vWjNtTcn6FwFV11bkwyKwC7Em0zR9eXZ8aTwC9agyYxEHHwj6ADoUqM
         2Eq+QmgnEPmFhEagYWCu+YQIMQnYg05Q8b/3CVr5vTO/8I3RdIXla3VsFFs8KEo8jqKG
         1cwQ==
X-Gm-Message-State: AO0yUKUrmbfBdRIJyLkImVSTboxDkA8PKEDjAReg55mVrQ4PQBDIWmNr
	hWQXt0D+E13si3l0XpWOL2Lg8duuvGc=
X-Google-Smtp-Source: AK7set9c3q+RzEuGRYuQANxke5HaEFi5TpCYYva6K2yjPctqBNX063vhkn+p6ncwehZezLQ/lkCfdg==
X-Received: by 2002:a05:6820:1048:b0:525:d9c:b1bb with SMTP id x8-20020a056820104800b005250d9cb1bbmr12535468oot.2.1678505278347;
        Fri, 10 Mar 2023 19:27:58 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r28-20020a056830081c00b00690d0daa17esm779242ots.3.2023.03.10.19.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 19:27:58 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 10 Mar 2023 19:27:56 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/529] 5.10.173-rc1 review
Message-ID: <4dbaeddd-65c8-4646-96f0-581f48386639@roeck-us.net>
References: <20230310133804.978589368@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>

On Fri, Mar 10, 2023 at 02:32:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.173 release.
> There are 529 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 160 fail: 2
Failed builds:
	s390:defconfig
	s390:allmodconfig
Qemu test results:
	total: 485 pass: 480 fail: 5
Failed tests:
	s390:defconfig:nolocktests:smp2:net,default:initrd
	s390:defconfig:nolocktests:smp2:virtio-blk-ccw:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:smp2:scsi[virtio-ccw]:net,default:rootfs
	s390:defconfig:nolocktests:virtio-pci:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:scsi[virtio-pci]:net,default:rootfs

Failures as already reported.

Guenter
