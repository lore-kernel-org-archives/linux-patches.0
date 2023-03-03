Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123221107
	for <patches@lists.linux.dev>; Fri,  3 Mar 2023 01:29:30 +0000 (UTC)
Received: by mail-il1-f179.google.com with SMTP id z5so868185ilq.0
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 17:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677806970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PxQNEiPDmTPJLaIsg96dsFSfhrhfU30ebbBE9xZS008=;
        b=ho28SczbORY4AnVI6w71l2fRc89s49trtyWRtkf/dUcCqtfsC1gBc/TwzwCBc1mm3H
         Wow/wsRQVZUsMewx8vjzYsNiqccs+bOCdd408DDNTuoMFCM7bNgae8aZWBHSBCiSM6Ha
         0STPzlOpHfqKNXDefom/zu7rmcln3dhAzLX2MyYcqedHiLS4M7sFIYDhb1r0aHFy/jpN
         QOJ7rpAfqFYwbMqU9ydQW//tyfcprVr8eHc8KnfiUfOYSvW2rN0IThS9NFnBd1lM9fZq
         FAp3+4B4LkClCXJR//znycJMrsvDP38A8Ie9GKouY4456+/tfur8/HOj/nMaNHfIYbKr
         7npw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677806970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PxQNEiPDmTPJLaIsg96dsFSfhrhfU30ebbBE9xZS008=;
        b=d7qJdZL1PpzqzIT/ftFQjAa9uwoiaruhRO29Z3kwuBhzmcZ2WfT35RKzoJp5QdH5ml
         VRpjSxkGzQ3Ede2An5YoYrTaqW/XGEXTi/HIdk1Q+vlFr7TjqaztFUss0XOZ8RObBGrW
         c1L6iW22QGx3KuVqkwle730G4iQK2qLJND1yFSyh+p3UK+d+j8GmgEnRm1QXdb3V/r3/
         RhsS6WConG2/xZG773wtwB8QRmxO39u2nPzFcRCtjB6ydbOZJSmbIAMidDEJdc2QjauQ
         NgZwIIvQlJPiVstuORgvqRV/9+CJitaepxIHXfDpmClVIAQWxUUojedXBDpO6o9dM/P/
         7QtA==
X-Gm-Message-State: AO0yUKUdhCpa71rcZpgiIal5FH4eXvdQr1OGjci1PaMVHAWLqTxfUJzE
	Az6VLb4xJC7bwPS3DCi5frQ=
X-Google-Smtp-Source: AK7set+lSm+r4B6lpAtZ1fIuHWIKXpNtAuZBNyobZm/IrUN+9aOIVPrd9SGwZ0UHwt9OolEVq90J4Q==
X-Received: by 2002:a05:6e02:1d8f:b0:313:ee3f:2b2b with SMTP id h15-20020a056e021d8f00b00313ee3f2b2bmr490126ila.8.1677806970134;
        Thu, 02 Mar 2023 17:29:30 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y8-20020a92d208000000b00315972e90a2sm239457ily.64.2023.03.02.17.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 17:29:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 2 Mar 2023 17:29:28 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/13] 5.4.234-rc1 review
Message-ID: <93fe1762-ff43-4e6e-8adb-fbf84235aafb@roeck-us.net>
References: <20230301180651.177668495@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180651.177668495@linuxfoundation.org>

On Wed, Mar 01, 2023 at 07:07:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.234 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 450 pass: 450 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
