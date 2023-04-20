Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03B617C9
	for <patches@lists.linux.dev>; Thu, 20 Apr 2023 02:08:10 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-247122e9845so304176a91.0
        for <patches@lists.linux.dev>; Wed, 19 Apr 2023 19:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681956490; x=1684548490;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zdSEkI73DrLdrtlsakWea3Yq7SYKQaz8Y6NGT/rNLsk=;
        b=NEVs9Zp7ARFZpb9Q6bhVwoKiXi7tbqwOdSZSgIL1e0vfDgtKo90tG0FQCw6+wB31Hi
         tL3W/DHuE6wc3fh+kXVrT+x6D4wVbie+iQUpOa7LNaE4pUB2ZarvN/kWFvsMqbmuinYO
         5viF+yyI0DhgODcP5zskygUaRm9KaJpfHNorCw++IGeptEm2F2O/8Ek2P9peust7y/KB
         6NC4+nvRLoSYMCAvuMoYkM318HO+CgTf9C60GIq5WtJGn39EvgkFcSZe+143D8DMCcHr
         pSbLUW9YGkxsx8J4FNJQU0LsgcdNZ6luki9O3T7tHwKMdtKwfM5uz7Daq0YbIfXFgcot
         2HAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681956490; x=1684548490;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zdSEkI73DrLdrtlsakWea3Yq7SYKQaz8Y6NGT/rNLsk=;
        b=gz/zm2MREXYKFPKWSMqVLvFR6HY4GinHtiEWojkfEEGYkEUlEZDK4XJFWFaCcde+Pz
         VLm1btoP2t5ZfFNIJeGKiRTxHPzDNScMDYNqp6IXDktVs4B7WDKIoJdAHGj+1/aJUnKw
         yXID9xXyzdBt19NFzaB0Ysqm2z0KhB1GEbL8uBe7xGFXEpdFi0a8DKrYgPbjutFLS8JR
         ejLGdzw80TXdP+AewlOrHIVxYt67A4rCsRemi8WuBGUdB8SsfSjpBWwpYVjIQhT/DZbo
         ca3Pg5NGeCcxlyqCub3OgFM+Qsc86xWolMMB2kgaUPxKOhASvqysxfut8u9aH9BXlPmJ
         MhiA==
X-Gm-Message-State: AAQBX9ev4MVzU0jOSHKebQTl0q0BgmyKdwzjafjRCtkvMnRNX6BwnMI5
	wM3tOSK6ZDcdxu9ole3IGfA=
X-Google-Smtp-Source: AKy350YN0P6CUplxZRzI8tOI6GMBzSW9Q9TBpgT4bNdkqpcogxe5AUfINrZdvoWj4WklggIyUKSpyg==
X-Received: by 2002:a17:90a:5081:b0:244:99f4:2f07 with SMTP id s1-20020a17090a508100b0024499f42f07mr15423pjh.30.1681956490209;
        Wed, 19 Apr 2023 19:08:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p21-20020a1709028a9500b001a2b4c79f34sm93096plo.252.2023.04.19.19.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 19:08:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 19 Apr 2023 19:08:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/84] 5.15.108-rc4 review
Message-ID: <9d2445fd-3b28-4788-aeed-3aa30786a3f4@roeck-us.net>
References: <20230419132034.475843587@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419132034.475843587@linuxfoundation.org>

On Wed, Apr 19, 2023 at 03:22:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.108 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Apr 2023 13:20:15 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
