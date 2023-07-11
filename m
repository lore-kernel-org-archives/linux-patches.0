Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0657618AFE
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 16:27:25 +0000 (UTC)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-1b3ff2460ecso5099781fac.0
        for <patches@lists.linux.dev>; Tue, 11 Jul 2023 09:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689092845; x=1691684845;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oljS3CL+A9NlQFaPM8t1XUxGkq5OOWrkjTs5IXV2lUY=;
        b=AC9SHZY7OqY2h6kRrnt94oFO6cvpIzP/1SdJ12umUwa91WhJK8Vwig9/387HPtHja8
         UwTq8lGvCofB7HACCWP7TOb7Cgh9D0UCVh2FgWDdXASLosEJdIMfRutFXA1zl7xlBxOi
         ndzY3LHfeqpM5isEWbRVhVaHO8teQcSMFqFb1ABOeOHMYi3JEFkVi29sm/JrJ5OL44Wo
         CfpiIZOyL867EI5TFSZK6paBOj87XWzZfW1Fa11sXHSG2AHYXA8xwWdScSfJ/5MT7qr2
         l3kL49DxGtu7E7S3oaKvIObmKGZhVSFoX49cZdiTtemXujU9WzVbtLZjJsKjY1giqzyP
         pPHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689092845; x=1691684845;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oljS3CL+A9NlQFaPM8t1XUxGkq5OOWrkjTs5IXV2lUY=;
        b=X8MVrmVuSrOKeUoTrSRJxeN+aOiFdNYcI+8u4qQQXiVv9cwuzEKOR42HMsSbLAhIYw
         uUiPalZo3hnnBHPwckr9jS4uDZ1tSgaIy7x2LhxsINmDKn7/fgHggdXjys35NmD4d45B
         Zp8+NMUGIbjMSa3T1fFczLHswarMPTzst0CAwlehMlMXjxlaLMSbeYGgTw4rkA6sHI0g
         dnh4arGUF9HJH1QO0TX8wgXF5a/OiCih5Kpz9B75H0U2ToZPHWVQNkc36qshv1aFL+GW
         2pcu/OuQqb/L3Wt4x1etcdrjNCYYiDiSPAucfEA906rL/1Z9vjNluePEBHKUk4JisFa6
         TZbg==
X-Gm-Message-State: ABy/qLYYWcErb5CvMmxOajx+/e3/Wn8TyIJKQq2taOKqrCivkg4FuccQ
	vJYs3VSXp6wRhOC63pVr6aQ=
X-Google-Smtp-Source: APBJJlHNVeZOBOzJuy/jYVc5k/hN6t75kg0q2tbRSr6JY3djdH+35anpSWDOWPN9mLD3cuPNzd4TEg==
X-Received: by 2002:a05:6870:73c8:b0:1ad:4c06:15c with SMTP id a8-20020a05687073c800b001ad4c06015cmr15690310oan.18.1689092844838;
        Tue, 11 Jul 2023 09:27:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a188-20020a0df1c5000000b0056d4b5cde00sm646581ywf.118.2023.07.11.09.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 09:27:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 11 Jul 2023 09:27:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.3 000/424] 6.3.13-rc4 review
Message-ID: <ab657651-92f8-47fe-a8a0-099b76481743@roeck-us.net>
References: <20230710142227.965586663@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230710142227.965586663@linuxfoundation.org>

On Mon, Jul 10, 2023 at 04:23:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.13 release.
> There are 424 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jul 2023 14:21:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
