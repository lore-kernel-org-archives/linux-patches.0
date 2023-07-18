Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224F7C2C4
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 14:57:36 +0000 (UTC)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-1b0419f758eso4307901fac.1
        for <patches@lists.linux.dev>; Tue, 18 Jul 2023 07:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1689692256; x=1692284256;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2ajGnbQm/rLYXuNtWUbCODJbO/kcfV5H/sqF7rkfA50=;
        b=Msx4QTQtSnVJ9XtUxSqqTdJ0CRSQW04CPD3u9jeJGkFbeTt4zs0Nvyew7U1OJGEVjZ
         RrTu/YNaBBiYru30zFQNB19eD3V+Z0YKjZjd0JthlwVNmcmMofXdv9c0iAbYDqDh6YYz
         kipF2gHUbJjsb7PljnF0HRUrQie7KVZXYc22o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689692256; x=1692284256;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ajGnbQm/rLYXuNtWUbCODJbO/kcfV5H/sqF7rkfA50=;
        b=iDZZQcUK3JJZ4tk4U7wIZU3gpK3qq0vliBMFKQWtWqMZlK52cPTPDmTplONkeYRl3H
         6j53TqSWgZMWJr+3XyJzxc/UgbVnIhOyUyMp3/kV/KNvIt0Bo+1ZrxQhdP2999vx8nQE
         Pia+klai5maGckuNVuf3FKaaL+BpNQjVY9zjnYibwjjBW8u6EAGTO7ZOc1DTGegQqCbn
         UX+eosQkXn5Pe60loqIf7ZGV8zcvnGwfG/GYnKOWnlnGM1Yb+DSMhUbCatW/g7eTkujY
         tHGdxJPgWN80y7y7WdVEM+Bzlw4gRqJt5AdIi/O5akmH4MC5+bF447hFqBBtWlsG9NUC
         M12Q==
X-Gm-Message-State: ABy/qLaw6Lxurgt4FOzVNNlcKTrDsmqaXBbGqzZEomzUWZaPtpxFMc2p
	d3CoX+NNXVGVl7DPOfXz49FQ7w==
X-Google-Smtp-Source: APBJJlGZ/mf6wjS6YG1j3smF6gpBVoDg0/l1WxbJHkjurwV48aiML6HbMqZw5++oYLIn1hZ4MmLjYw==
X-Received: by 2002:a05:6870:d209:b0:1b7:5ea8:1fb with SMTP id g9-20020a056870d20900b001b75ea801fbmr8939199oac.14.1689692255657;
        Tue, 18 Jul 2023 07:57:35 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id t12-20020a9d66cc000000b006b93d1e8e7esm879561otm.69.2023.07.18.07.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 07:57:34 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 18 Jul 2023 09:57:33 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.4 000/801] 6.4.4-rc3 review
Message-ID: <ZLaoXb7K1O+19CEa@fedora64.linuxtx.org>
References: <20230717201608.814406187@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230717201608.814406187@linuxfoundation.org>

On Mon, Jul 17, 2023 at 10:34:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.4 release.
> There are 801 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Jul 2023 20:14:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.4-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc3 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
