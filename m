Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4A6760AD
	for <patches@lists.linux.dev>; Mon, 18 Dec 2023 23:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="a1/8lQUt"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6da2e360861so2010761a34.1
        for <patches@lists.linux.dev>; Mon, 18 Dec 2023 15:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1702943058; x=1703547858; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s38PvxZbBMTVGvQ0kbtSdyWDBrmSjvOO/03Z8xfaLco=;
        b=a1/8lQUtkipD8J8t3Q5/kz147i6rzgOTfBCvKfcrNv0Ipu17hn1+7zETBHYvVMIKz/
         M6CQFOVcgZlxsJ6EjXezJLxhk2tElh7ygzDuF6XXLzJ0WDx1kwYNcF/11R7djk0NkHGM
         qnjXdcGmjoDSEyH+ZDExOt7OulFh326lkXsLw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702943058; x=1703547858;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s38PvxZbBMTVGvQ0kbtSdyWDBrmSjvOO/03Z8xfaLco=;
        b=aP7DW9kQpvDKdOtYzJNgiSirmk1EeOuYn4vqsZDCTVG5u1nXfumkO2Ny4wH3QfGZMV
         x+PFMjVBWtgk0x63ZeDWhFF/Nd9WHD4io+PaaR+5w/WgZr5kDRX0EdMny5DxXXu/EOw1
         Sy+o30YH6EMyyD8MmrJ05MKB1su4xBw9BcG8c1eB2JgBvVXN5GAVjBvN7lb8d+5ZiWBt
         Z6kPYaqoPGky2rQeWK1GtIkqDfBBH51alTedOyM0gyoM1MyD3Jo/ZazS5sta7xX6CI1A
         cMy3g746s8HPxF/c15IuDsZXgQ2j4Pfn4RxGC+dZxveGrYI2S6vrTWEbEvYtXKwOhQd2
         VYoA==
X-Gm-Message-State: AOJu0YyQ7RJ9j0WMOc2EkyQNYYOGJGdOVPMcJ0N7YBIyIEEDqfUe1kKm
	/R86iazn7YqC30DB5eVBf1/sig==
X-Google-Smtp-Source: AGHT+IGRv7a21r4zLDBsHKyuUtnKJGh7ThK4XMmPsNxiSeiENXirtAI6HZ3j/MXWq0z0MRxacOfwNA==
X-Received: by 2002:a9d:6e08:0:b0:6d9:e61c:2c8a with SMTP id e8-20020a9d6e08000000b006d9e61c2c8amr69003otr.6.1702943058308;
        Mon, 18 Dec 2023 15:44:18 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id t15-20020a9d66cf000000b006d7f41c7e11sm4792433otm.33.2023.12.18.15.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 15:44:17 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 18 Dec 2023 17:44:15 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/166] 6.6.8-rc1 review
Message-ID: <ZYDZT1sLD1D9Kcjo@fedora64.linuxtx.org>
References: <20231218135104.927894164@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>

On Mon, Dec 18, 2023 at 02:49:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.8 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Dec 2023 13:50:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
