Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00231365
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 01:50:54 +0000 (UTC)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-16a073ace03so3278017fac.7
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 17:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kgDBzDEdhA9Rukgr923OpczSXtScR2mYWzeNG7Bc+uw=;
        b=BkRkwrOqwzC8ibdWyI5Omrdj5RxqQfQoak+TvfBKEhAbI8Kb9ToMA9qqWo27A5gh02
         TZWUeePjQ4slyUACLuSM4c0JhyMyuya0bqqtt4a5uXBK+v5uN+VRQD9mVX7F6j/44IZ6
         VqU1ApzWUV2yjJBbi+7KOGZ0zUefboG6mgDnLuiZbH1GrsR92OOnlG8A5dezZHR6qV32
         OuGMtAE3vX0VPmZyrC40XIyNwNU9loW64qWA0p36QUOk70B2j5btn4g0xUbzILlolz5C
         S9CygSJC15ntvCnRm1iOJTVzj7y7UPoJADjI0+K0Mr3qwzDKawNwogjFietn5EXtqUOP
         mx1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kgDBzDEdhA9Rukgr923OpczSXtScR2mYWzeNG7Bc+uw=;
        b=3WwplPCrS0tpTkfaiXaAX9bnaC2dBR4SJRk2OtvDzhzQOaRTSH7vjk+WDdfb8ZZ7vM
         wZ038yt0Z6LooEkdLetAXKbcEEDuZO4dkZEfPVmT2gyANIbOhczUDq3NbwF7u0xc42d/
         ZSdIeIWb7CB3JJBB4SG2xV2cMhfkf7H+4W9jInR7M5KKa2QTHZeu5WiavCw6v7/wDZbz
         aTWU/o5zWuXePVluQhkTgYG+XYfA3m8hO+3zAQ3c99TogGC9bVUVaot++jMf4dTWEury
         aPE7J/2WizgoYWo21j879oGbEHmf4k8OEYnXWmo4qsM14bbocGiNJgbcc4IXaVKLTbJJ
         o/pw==
X-Gm-Message-State: AO0yUKW5k9YEdqj9HbdG1ipcWbqRDv3HWOKgNxQL5E2OlhcUNX03fJ/l
	itNwilLufu8ALdSIi0IhAM0=
X-Google-Smtp-Source: AK7set87pblL4yU2ujeIWb5utCQl0NqR2vIEES3GW+8DxwfRymMhGyv+Rmht07aXwjqRiT8VreRLyQ==
X-Received: by 2002:a05:6870:c89b:b0:163:7812:a0e6 with SMTP id er27-20020a056870c89b00b001637812a0e6mr5959559oab.57.1675475454123;
        Fri, 03 Feb 2023 17:50:54 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w1-20020a4aa981000000b0051763fef75fsm1594736oom.37.2023.02.03.17.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 17:50:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 3 Feb 2023 17:50:52 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/20] 5.15.92-rc1 review
Message-ID: <20230204015052.GE3089769@roeck-us.net>
References: <20230203101007.985835823@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>

On Fri, Feb 03, 2023 at 11:13:27AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.92 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 492 pass: 492 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
