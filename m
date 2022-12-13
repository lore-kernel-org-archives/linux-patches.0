Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306817F
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 00:24:28 +0000 (UTC)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-1442977d77dso10598463fac.6
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 16:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=puW+NA+qcVfbNDwy3Cka1eMBFMm0X68cK1dM0/fozLw=;
        b=Gt7OaSH+GRgqDlxMmqcg+BrgJTkKY2zhgR+fFFSpxbeOVYubEGSgMMK7VZbTDhi5OU
         5eFi9ZJ+BJw9SlQz+ZI5LPFB1/f88G8zT9wFLdT8+mZTWoyYzPwGKgnR3RbGc0TbPbxN
         mYNdrUukBvYLuxqSjaWSCUwm9B9T6XNOAQIrnzMmansPPvL+WhTorjMiwY4MVo5DfZOG
         687+uMkPySjwwfSSWubNmgOH4DtSjUIySm2S1O8jnK9TaCIGhKw7eOV0XMzYeYNa4DR1
         kSLFJ43jPUFELsoBrhHk6AAMv+55oAvtoOhZD7dTHvRpJNzpPrjppUi387Xkr4gJ12wU
         oBSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=puW+NA+qcVfbNDwy3Cka1eMBFMm0X68cK1dM0/fozLw=;
        b=jYZ/YuSMUHGmUANHcW0YtDZ0ssK5Gt2H2w+MmFnBz9TUHiPbhVvUj2WwSn2d26Bjq7
         w1U6rNmOAxL/nH/Vl68pJ9bt8Q0SWJ9ACM/W37XkFy5H3lELZp+Leg8RKCFR4Y2e9H/r
         InC4lWRywXuc54YgmCUrb9w/wLhtuD1gl1ElEf3Uyl3V2lShdRx4Mc9PU9DiHGY+XRIv
         BllAxWL/Ecqn8+zl8IVL45oRjLhE1h0Gcv7BHnCv21hdeVPGjf6cb39taUUhCatE0v4a
         KofDRWpm/Y937hpQ2LoTxsNTKTJtixOtCrmsXcHManBvWsz2m6KX2KIw/mNwwgHiivAn
         4wfg==
X-Gm-Message-State: ANoB5plIPe61WPZ3it4ogWzTSDvZI9cua0YAl8IfEjPCLOMFtOqFCOsV
	qDY3n242D31d3NUBvY+CUYc=
X-Google-Smtp-Source: AA0mqf440i5VoGkq2sLet0cHK1bXq6hwkYJwe5Dmt9UoKiow17dF+uX43VZ2wMJJnd8N+esnys9KMw==
X-Received: by 2002:a05:6870:b388:b0:13c:14fd:e901 with SMTP id w8-20020a056870b38800b0013c14fde901mr11662446oap.27.1670891067327;
        Mon, 12 Dec 2022 16:24:27 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w6-20020a056871060600b001446480a042sm616253oan.58.2022.12.12.16.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 16:24:27 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 12 Dec 2022 16:24:26 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/67] 5.4.227-rc1 review
Message-ID: <20221213002426.GD2375064@roeck-us.net>
References: <20221212130917.599345531@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>

On Mon, Dec 12, 2022 at 02:16:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.227 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
