Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A108533E7
	for <patches@lists.linux.dev>; Wed,  7 Dec 2022 21:05:14 +0000 (UTC)
Received: by mail-io1-f44.google.com with SMTP id 3so6318107iou.12
        for <patches@lists.linux.dev>; Wed, 07 Dec 2022 13:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AdwiBta6Dmh/OYr9T4sarFHL36j6yKAVLPCIdX41e8E=;
        b=iyOxLy9XHzFy2XbMQGIodfZwE74F2VQH2uw6Bajf8jyz3A4AAae++mdUyn3jXnEZwE
         2R8olZssDCz82JVkilXJq20A90qXgGw/mu64hQYfp2GRa6GtFbqd0m0DtQU9Kmny7THl
         muz0haDH8RD0Irkt7Mtqm0sVN73tJLeVnWmpg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AdwiBta6Dmh/OYr9T4sarFHL36j6yKAVLPCIdX41e8E=;
        b=s3FoUvu3qE1d2hmwgIJJClNGa717c5oYmEChbSAvRA2gG2X+41OVgKStyL9MfSmKaQ
         vI/34brcUISt9ylF/r5k/XH1CFST41B4C9BAvsRx5f/15wM0v73kfy3Iq2A+j9pC/5RF
         kq0i5I2oLU5ZpVCEH9pOg3dHIwPf83hhhhY9OzD7QATpcqHSBaiiFdj9yNxuyuPl+h2u
         AW90H2CW/iKTgou98q26ETIckSSaH4F/yG6TolUV31NZDtk+o1dmXCDY2/YOElILGIeJ
         fMaFK23vnTHm4WYfY/eIzQSr7BO6z+zxhyDJyn5G6BtionwWgXQEfcciAm8YRRC8j6m5
         Yf4A==
X-Gm-Message-State: ANoB5pmYA30j3hQ83cDxrQXKlMDQ4VEK8/PpOiBldq4PLWvSZM9V6wxj
	Toi+M3+PhDFBpgO0PzOpE9zJfw==
X-Google-Smtp-Source: AA0mqf7+fo5y7xXq0Es3jfEYzCY+qMiBTplapo9Q5usgMzeur5M/qhUHuIanSgxE53hS1CuCZ9d9nQ==
X-Received: by 2002:a02:954d:0:b0:375:569e:fb3f with SMTP id y71-20020a02954d000000b00375569efb3fmr43537632jah.200.1670447113419;
        Wed, 07 Dec 2022 13:05:13 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id q28-20020a027b1c000000b00349c45fd3a8sm7971766jac.29.2022.12.07.13.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 13:05:12 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 7 Dec 2022 15:05:10 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/125] 6.0.12-rc3 review
Message-ID: <Y5EABpt77+wwnGLU@fedora64.linuxtx.org>
References: <20221206163445.868107856@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206163445.868107856@linuxfoundation.org>

On Tue, Dec 06, 2022 at 05:39:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 16:34:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.12-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc3 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
