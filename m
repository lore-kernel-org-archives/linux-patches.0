Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41BF17D4
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 03:35:55 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-63d4595d60fso4172228b3a.0
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 20:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681875355; x=1684467355;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g6PuzmuUY8jHhiY7WeAnASdzIf7vjuTT8wHkTuOn1oE=;
        b=DyFBm3PHi8J9g7ZrM8qZjEyTa+Rk8HEiSZ/JmMj3ilMojSjjnJXBCE09vaiXnWoAAF
         W7jpuoY5nw60mbjqvGlUlcXIn7NA2HCp4ik+UjhTX0W9n+vFZoMele03B+4XGP1SDvld
         9LNG/9xNsaPODRiE3fvScUgSmZez93cPCneXXWtW7cI4tmaoaItLT3mCoARBxGjJ3kYk
         9gkK2w1IAT338AIGob+hKVpV7O9h/Maz0IE+yA4XK1icWYxyfgr4E/2eS1XAMYUT06us
         g92eDutPlWYdIK5gf/9qqkA0+CcvQyoaGo1yzDCeiBLlpm8N1zf7lePli5ZJ+PPj1Uo6
         uX3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681875355; x=1684467355;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g6PuzmuUY8jHhiY7WeAnASdzIf7vjuTT8wHkTuOn1oE=;
        b=V6ZEjLw31fCYltiAabCisELt8nt+nI/TqRrUb5nJmzM2fNRDJv1QlmSNiNtmeltK4G
         noPQMWLikWgB2KTyjWmZIbik9IUvJB2en4XB0wzj6MdDAQKmudQw9BDKCVysNpo2IV01
         9yvO8+IWV50JeY69KTskszndY/PoCuap1UPI5zpogLBkPrdJ9oYGATEiB69RXpZaagID
         n2lfoeqjCOYE+tPzXyfVgYtev8RO9z3wJ46O5YyCtSlH3+WbNxxyh7vSA3FCgAVFH+Cy
         bjEwNW2t7NPZpTIXlnLXmwCKDLZcA7yAVYjaSRNjctjOB/ElCJ3PTKWJCwN1XISjdLQE
         4KuQ==
X-Gm-Message-State: AAQBX9f9hBEN1thAcbYy3SeQF2LNKrZfnODjkj427I79YU2BOIsMnrOw
	AOLioi+tRbFiDXZCGIekpZM=
X-Google-Smtp-Source: AKy350ZpI1YRgG+ADC9n6xsZoNwqBan/C40lNHS6eBFewR0aWxflxerjp5JW5Mb+qc/tg/D0lbJQ0A==
X-Received: by 2002:a05:6a00:4285:b0:63b:8da4:352e with SMTP id bx5-20020a056a00428500b0063b8da4352emr928270pfb.1.1681875355001;
        Tue, 18 Apr 2023 20:35:55 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x8-20020aa793a8000000b0062ddcad2cc5sm10061831pff.30.2023.04.18.20.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 20:35:54 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 18 Apr 2023 20:35:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/139] 6.2.12-rc1 review
Message-ID: <090c2946-4bb5-485c-8c55-58e6420a8030@roeck-us.net>
References: <20230418120313.725598495@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>

On Tue, Apr 18, 2023 at 02:21:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.12 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
