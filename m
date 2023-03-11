Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1397B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 03:26:33 +0000 (UTC)
Received: by mail-ot1-f46.google.com with SMTP id g6-20020a056830308600b0068d4b30536aso4003551ots.9
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 19:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678505192;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pC9WYJ0DayXmpMOoglpBp7yOZSkpByqHsAA3CKpSObU=;
        b=Qvd7j5zO67M2VNYTb/KmuGq8+/jeCw4l+uy40mLeIDBiT2MhOc6Y18vRvrL0keCbgK
         srCEt98zB0dD1NA4KcvcDBvDXFP2EVRYQzBZm63KCO7raytU3q3qPSyHSB+SIyVepLMJ
         5tLs9dldzpZySCyc8EruLUK635s8b+3UcFMDuXmPX554o/sQcIGG6MUAku760xLaTJmp
         KEyOQluNIWqdvErK6cwaW1sm20cyOxTCjPWQyPVoUKWwvfr5ug+bPWTHWlJLW0vH+R0g
         gYMN1hnlP9MbDbBNlX5yNuM3UAcddZxyEwegeDEmfigsjdajLfc9S+u89VB3fds8rwBY
         J+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678505192;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pC9WYJ0DayXmpMOoglpBp7yOZSkpByqHsAA3CKpSObU=;
        b=pA0T7GPMTqpVpJMS/9ZF1apFJdgGfazKE95iZUkbrpiKAtkO6Z5ulfsBIo7QbLkix1
         trC3r/uZalPhXxlV9lzL4+8bT/vHAgnQcmpyH99vHWu/ObuVuPV7A0xLt08CI+1Ei/XS
         h9BHB4gFJc5thiNFwgYg0kg4rxRm3I66255TGnUB+Q7e/WGvjgLaV+T4+fAhqGEFX1j5
         WeQZfry6gYLSmR/dezqyubOtypyVlVO/oQ/4o+4u5GR6tgvt1gjzNaxRQBKcZJcikbdm
         pijB7NLKyeac5z7B2p8eeQmhNLzPf8KP0kh2IUoOZAz3G+1nnBWL4zAJkj1MHdDpJEDT
         iPBg==
X-Gm-Message-State: AO0yUKV4b54befRqyIpStgug5F4hGaigu0rPw9XhEWxZQ9iDP44EOep4
	kI1W1uQhPEaEvWKeNpQWyKU=
X-Google-Smtp-Source: AK7set8n5pAfWb5mjc6QGNNXuLWyD1frY89Malp1mtKiNryBTpiJysPLQWXQPYBJstAZlkpzeQgaLQ==
X-Received: by 2002:a9d:310:0:b0:688:4c9c:d45f with SMTP id 16-20020a9d0310000000b006884c9cd45fmr13856448otv.20.1678505192399;
        Fri, 10 Mar 2023 19:26:32 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o4-20020a9d7644000000b00693c9f984b4sm758278otl.70.2023.03.10.19.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 19:26:32 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 10 Mar 2023 19:26:30 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/252] 4.19.276-rc1 review
Message-ID: <9fb78cff-b92a-4ad8-a1f8-4c1e096d52db@roeck-us.net>
References: <20230310133718.803482157@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>

On Fri, Mar 10, 2023 at 02:36:10PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.276 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
