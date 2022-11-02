Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E6624F2B
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 20:47:25 +0000 (UTC)
Received: by mail-ot1-f49.google.com with SMTP id p8-20020a056830130800b0066bb73cf3bcso10935660otq.11
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 13:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jI1AdsKV3wVOr17xjeLihkIpdii2P9AsBZRr09EhVxY=;
        b=OTCxNRcB5vJ4JIK2po7J6rUHopR5fi+r8iKXKfTy/B6tIqSyr04AYFq90dwFdIoUGe
         XFCeIbOUp8IA8V0uvd7jGnL1u4eZu64YiHPVog4M4DthAJhnrRuADiEp6nkTfs2/z4nI
         csoQqGjKbWpPzbKpME0c/J+qG8H++VXsXXxVHFyV1me4mIYz0hvhW17toOG5sT2q7l4I
         w1raecqgtEFXA8aRKkZ1g6zTPdff26KJm9L7rR4spJr7FgCnvXNPSxG1dFjInyYg/vuA
         j99vEAONSYX31a+Yuc2IaotazEUDyFiUeHKFW5Monm1NNttAKrBxZqnIAbgIehe7rgNc
         G+WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jI1AdsKV3wVOr17xjeLihkIpdii2P9AsBZRr09EhVxY=;
        b=jvzJEbdrn+x0v+h7FNuZxNIf/ufKeGrMhrPcnoz2A+UCUlU+sTZGwKm3G8oHrH5wuv
         FnyXhXn7SVJCXPTAYWvFEnmT2ONAv/6RE8BkuviKpCF4UCFiobhz00Aruvh7qNIQ8Ti9
         YIbEK5xv4wByFzbKX+ScxxnO7LJPLPTm+Qu25GyaIxi4Fuic3lYVrWGSeyPAFFQhBwOQ
         MetoHPGOGnG4o/6GnMMS9eKSQPwBUXuUnl6xquEVw66i6CXLmPVLgyfeb21IAj4WjclN
         YkbTQBw6pZXUtF1DaeT3cXu+vOX99XInYQ5wzZ66FSvBw4u/ng63iVR6b4QVn5tYfg9/
         oPfQ==
X-Gm-Message-State: ACrzQf0BnpaIdWQsAOAk0D4z4wTWxuqGBFo8HDx/sAFo22A8+sEyUjrZ
	gba63EYtwx/uYmFszajB6U8=
X-Google-Smtp-Source: AMsMyM4PAVo1QnjVxcmmSgT83sLeyilx+KSzdczzKhWTSIimh6ypkgloK2sl8bz6hAZD4mjio4+23g==
X-Received: by 2002:a05:6830:6303:b0:65c:5bcd:c2d0 with SMTP id cg3-20020a056830630300b0065c5bcdc2d0mr13028303otb.115.1667422044908;
        Wed, 02 Nov 2022 13:47:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n17-20020a05680803b100b00354978180d8sm4927305oie.22.2022.11.02.13.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:47:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 2 Nov 2022 13:47:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 5.15 000/132] 5.15.77-rc1 review
Message-ID: <20221102204723.GG2089083@roeck-us.net>
References: <20221102022059.593236470@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>

On Wed, Nov 02, 2022 at 03:31:46AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.77 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
