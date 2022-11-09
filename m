Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BFA6AB1
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 09:56:24 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id d20so15552746plr.10
        for <patches@lists.linux.dev>; Wed, 09 Nov 2022 01:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8OrF8dH4eiZS9L3s0WZftm0o/EO5zf8rOLBRrHL6Sgk=;
        b=UfQdVdb9j523nu0DU9BEjD0S3rH/cUK+pofD3d0h9hFKs3F/K4EXQUmtY8f7+WETW9
         gequo3sOKgP+CBEUrvC+X3MWGADLF51b7Y/4Yc4lho8Fp8itkrBGXFjV99s0eK5UelIL
         rzgdgQo6K2dE/RUl8WKEl5VnArr+cfVSZVylY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8OrF8dH4eiZS9L3s0WZftm0o/EO5zf8rOLBRrHL6Sgk=;
        b=PQ/nPXb/59DzyDYR/Dkvw+GRjKaqauBviSXlmAOw++X7aOz0TjjxGOmit5AbsEOA7O
         Aun3VIm5iz/DPZohP/f0nmd5hsEOd0ajPfH1XoCLfAFD38A3kB/67F68JTjNzMbMdJNd
         6KSMrUouNBbDPDdez/LuXmpcqp8o5AJbTEAQv5htI9oZZXH0HpMF9C/vmEAXp+VwhrCt
         fZCZrr6WSZRXLjb9DUjW109zyMmP6DJw6t8+0HhEvZEF6uwbmT4lH428/VJz2DyD+ZDt
         Pix37909CofcXxr9GE6Dp4nK3tzsaZSGQPlOV77RQzCTpzxlO4UOVMrseZ9z91a4zvYw
         VzlQ==
X-Gm-Message-State: ANoB5pn34yjgrE1Ui0BGAyIax8I+ajYciHdW46bAWsgnuZ0t94KTykwi
	PGTaac9gxwtn1C+jrA30kCzkCA==
X-Google-Smtp-Source: AA0mqf6PiYdLhpF666M7VNwWUnrYO42eGbuAHrm0em6JnnekdoRCAbfsdilmDvZDDSmatRzbcqDUbA==
X-Received: by 2002:a17:902:9f98:b0:188:6593:17fb with SMTP id g24-20020a1709029f9800b00188659317fbmr28111548plq.173.1667987783369;
        Wed, 09 Nov 2022 01:56:23 -0800 (PST)
Received: from b0ad8707f47a ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id a9-20020a1709027e4900b001783f964fe3sm8582947pln.113.2022.11.09.01.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 01:56:22 -0800 (PST)
Date: Wed, 9 Nov 2022 09:56:15 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 000/117] 5.10.154-rc2 review
Message-ID: <20221109095615.GA947857@b0ad8707f47a>
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

Hi Greg,

5.10.154-rc2 tested.

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
