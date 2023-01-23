Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7FA7C
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 11:18:40 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id v3so8689212pgh.4
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 03:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sP/ck1rVE05Vv0gu7f80XpF6ZgtPOzhHpAqqtvJqe/c=;
        b=RkHjZEpLvCNlRS2ztVVt81CAo4UOyxjfhfcNlPNv7fDg+AUwJnPuCPxDEGMG/ExUNr
         8vbzjNNCCQRy/0lrz12Q7JNxP9SpTWsW6PEIV4TBXKxiAQLMzcTJNn4TFdvX9aFKXAr1
         WTBRUrfOcY+vZbPbqOSrRcXaPr4iFzqhj6f5g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sP/ck1rVE05Vv0gu7f80XpF6ZgtPOzhHpAqqtvJqe/c=;
        b=FACX4wy/LusaVYcb+mTHO8siMETqw0P1CBSggmmJ/0jrrLPvWIXy/QgrQ0hTWjBdir
         FMJML6wb8t5CIrXnVMhPcBbgSSRLwJvFcvuGceSXZcE6boiX+XijBCjKBoxrkrMdhjtA
         xe9LNbvyNGOohlGb6XCzYYul0kAccrD9qwDLtZ6vukDxaoObzWKTQ2/6axvqrjFwshqh
         nnrEeUNOL+OAwYmhDJMLEGHD/p2fYlRY75NJTg45xIyzUf0aD4MN0jUNvYRLWu4/95qH
         mY7fLqK/Dt6pKUXRhLdb4+Zv/1lXkIREi1CiqlhX0oFOeoDUPKjR1XMrKj/nr75SATyV
         srcg==
X-Gm-Message-State: AFqh2ko/2w4y8xoLHz07dKoKNmma9dPJDZI6NjB+rYwZ1B0g26/oix6O
	hwlWLPWqndRxPazTqtZ4RiLtDw==
X-Google-Smtp-Source: AMrXdXs4KCeQoc8M1qanPuzr9g//pDGp8EpHh9iqpO3i0jtL9OoLSjTkO0SE5F/eCO9VKmDNahXhEw==
X-Received: by 2002:aa7:972e:0:b0:58d:b330:6e7d with SMTP id k14-20020aa7972e000000b0058db3306e7dmr27153901pfg.26.1674472719663;
        Mon, 23 Jan 2023 03:18:39 -0800 (PST)
Received: from eb716ca105ca (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id b126-20020a62cf84000000b00574e84ed847sm20796669pfg.24.2023.01.23.03.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 03:18:38 -0800 (PST)
Date: Mon, 23 Jan 2023 11:18:30 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/188] 6.1.8-rc2 review
Message-ID: <20230123111830.GA484846@eb716ca105ca>
References: <20230123094931.568794202@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123094931.568794202@linuxfoundation.org>

On Mon, Jan 23, 2023 at 10:52:24AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.8-rc2 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
