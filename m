Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306C6321E
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 21:30:14 +0000 (UTC)
Received: by mail-oi1-f180.google.com with SMTP id r205so2148987oib.9
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 13:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S/Qk70x5TBPU2i02XgnzB2ttW0o6WKxWCkbaWFneW+E=;
        b=mDxU4nhX4L3zB6DkGwLxZIMYfQAbquZWl35hMWG7xmAb41/uxw31B/GruPQb3Rcmj/
         DQJwM9/NlqrI2KoyR/J9ooyD+SFRlDOlU0mlR+IwfVo0olU+CJFFzBq8KEE1yMkEMxz4
         IPGl9BnN05MWQuMR16fVavM+0V6YKm4x4cOub4XPx9A4QL/CEi+ke12d7tbJqyovsVCe
         mpOomTC8z/dNawmjoWS1VTdR2nBzMV5nIwH5PhpsbASdOfV5DorbBFARiyiIYS1ZqCUh
         Ct02dPur0wrBdMBCcRsNCiZqmg9MpVWf2ngxuIr/u90Wadx5UTJ0YJsVeuUx9GUsrfP6
         BSqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S/Qk70x5TBPU2i02XgnzB2ttW0o6WKxWCkbaWFneW+E=;
        b=Oxuhm56CVMB1D7H6b2SfE6yIKftB7oAZ7qI+dDxzwB3//YDYoGQtJ2KMwmLxSMIxWx
         nsOLkMn39uBQ5pyNuKgFXzr/yB311KKqCuX//nmmJApJsIc08eIjZbPPWO+dc0WzV8Wj
         maTUEjWBLLruabyBW+ZGVSRO4uS1UtJXk+PUEJIAw9pQ51pj3zdEZ7iLgiAkwFsi1w6I
         HkFIl1Zrl8PhpB2vulHu5kWainAOD2gV+RRw+MaAi56MC4tglCvigQvufWsFxxIrfgdR
         ObY4znlvFirJBeqSlbkdMxJHWzzWk9DumUZ/rHNOWssS+Nxbc0Ck/90iYkiulD6XwSZT
         46kw==
X-Gm-Message-State: ANoB5plMvW7Eh/XjImIHXcVQpU9UpR2jG3ikFDzC+gUPpG2xfQDTg2uz
	lupEWXAK1lcM/6Smkmu160Y=
X-Google-Smtp-Source: AA0mqf6+1stzUnnU5rBCMAkM4zhg8NpnztKeFuZ0iPNbi7iJpsoaCNne1BmOjY2g37gDcBdaqpVPtw==
X-Received: by 2002:a05:6808:d49:b0:355:1dec:321b with SMTP id w9-20020a0568080d4900b003551dec321bmr20159429oik.31.1671226213283;
        Fri, 16 Dec 2022 13:30:13 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l20-20020aca1914000000b0035173c2fddasm1212502oii.51.2022.12.16.13.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 13:30:12 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 16 Dec 2022 13:30:11 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 0/9] 5.4.228-rc1 review
Message-ID: <20221216213011.GA4067594@roeck-us.net>
References: <20221215172905.468656378@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215172905.468656378@linuxfoundation.org>

On Thu, Dec 15, 2022 at 07:10:27PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.228 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
