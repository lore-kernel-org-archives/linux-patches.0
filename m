Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD9D29105
	for <patches@lists.linux.dev>; Wed, 17 May 2023 02:53:45 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1ab1b79d3a7so2732705ad.3
        for <patches@lists.linux.dev>; Tue, 16 May 2023 19:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684292025; x=1686884025;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5aBQ4mEPzfDLNAurJE9vtcKaHJGJ5KAIeFlJrI9UDdc=;
        b=RAd73w2dvXNMAvwPEY+hWFGpMdqe4GcTKRo22aAkZdmmALMSOTSl0JjOZlV9wLyb5p
         EVFFv7ko6XFkHr1xHLeglzU9bAIN3BAQMCttieyvIt+c89C27tQt/U1SdgofPwe3zXPb
         l4Ox0cOxQk/RheKz+KBFZqxIXZXp+GPheFbci7lmDxtZDhpk+szhShjciCAoFBIyD6Cu
         RJAEQNJ+DDgsb6lq0xZt9FsGjnRAaTRrWmcWZ3nxWlno7Bt0yvsIpTA/EasrH4tg3jQX
         LpbLD1kvG/U6RwE8OyCmRG5elMGaerkOnMGUCjRJS0GEH6uUqtQXzc7MuZlyf+oHJcso
         mRiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684292025; x=1686884025;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5aBQ4mEPzfDLNAurJE9vtcKaHJGJ5KAIeFlJrI9UDdc=;
        b=UTOe4nzzlA1pdiPNfn3J/RorKb3NhzbTknpDMLDcvLFRfVx2eRqjCQ7oob7+6jIdgr
         K4Ilh3BATzOhWdM8qI7v5NqmUeKWMgJXUUk/CroVCCqKdZOvOn3k0tCUyLDM5K/8wt1/
         Cx304ArlqMQCLYHXFwm01QTgDDFB2Fo+TYYjs2r2PjMS+cFywOLfSgZsGnisB47oxJXY
         DLtegkRwbd4v2D2SNhjT7PHZFRHqOt/qyD0zUOl1jrCZK+Wz8Gf/IpPHUdjVxs9KWlHm
         cYhVA3JHSWbiKlBYGhcByhLBsKNYHAH9QXBomZD1W4I/mJe+lgRn8whhp4jzULJla6vr
         FaAw==
X-Gm-Message-State: AC+VfDxvH8Oy6b3J2/8njrmwRGhdMuXESgvxduN8LkMz/HfpI8KT0BbQ
	oCu81HR2BqCm5FJQIwdiDWY=
X-Google-Smtp-Source: ACHHUZ6MbQ6GboXNdJq7qJOCzsUz2Ls1xiZzpsrPFtoeiLb9StBJQmBSNgiQ7qJhPOtLyP3y7aeT5A==
X-Received: by 2002:a17:902:da84:b0:1ac:a28e:4b29 with SMTP id j4-20020a170902da8400b001aca28e4b29mr37702565plx.26.1684292025292;
        Tue, 16 May 2023 19:53:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d13-20020a170902728d00b001a217a7a11csm13183659pll.131.2023.05.16.19.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 19:53:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 16 May 2023 19:53:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/246] 6.3.3-rc1 review
Message-ID: <2b1e9ab4-b416-436f-9437-bce488f300bb@roeck-us.net>
References: <20230515161722.610123835@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>

On Mon, May 15, 2023 at 06:23:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.3 release.
> There are 246 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 153 pass: 153 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
