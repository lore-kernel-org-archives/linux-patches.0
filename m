Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FC2C2FC
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 18:23:19 +0000 (UTC)
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3491568afd4so15070025ab.0
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 11:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692037399; x=1692642199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X7mGXj27nvKPdrvcjphNzAz8ew1VuijtpTDLahQ3Me0=;
        b=hWMjL1VuMyUFT8geI9ue1b8iwLBkOB3bKjaIkfLh+/InmSXL3pgaU9XPHJP2Z1HXL3
         Jyin0VTpIr80W8UlC/6NLiWP9tS1PuVB09ddv7Gdm9GZtq26cBOjD11CRl2rDKSqlsvA
         2jXuBYnr8hd/XGA4U1wHA8sinqvwe12676xRpme1mmc909XNRHPtzev714jdjhh8/fvi
         gJd30zGBsjnwFy/myaK9LaYJT+5a2NECwRcbmsbbY5n3HLtbPfDKdB0jrFmVjyoTb3/E
         lyQkLa34sTPbO4YceSUDM3DTJdny061s+iA5XzQrTJZ3onJtder7AdVZzeP0boJqkUF9
         EoIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692037399; x=1692642199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X7mGXj27nvKPdrvcjphNzAz8ew1VuijtpTDLahQ3Me0=;
        b=HZV02G4/uwo/jlizKmjdW7JVcJWwYcci1jODMSMc6h6rUkNL5pCnRtvrRyWPlYu4mJ
         2ZEpEYt8G1iBFtkpdCeP+MsWLnsYa+1NANadozQrGYUed8vCtG1OGvhtebqW2wxO+hUP
         szQJ3RsapEOVTI0uvt7QUaeYhG2E4QUpNgC/AirYzVc3KPilof6lI91kydX9kiIeaOmU
         /DeTarFj9jdm0FMmTG+ROBeFirSAhetHvEydaL9WalR+85h+Mi+Vm+DdyQpwbrvLY/oV
         TlrQpbm6Jic2+J3U8hO+nU7fIJ1h0eC9fSiJSDkFH6qPzZ+s7GY5jdU4vCORFpwFWfT/
         Rx3w==
X-Gm-Message-State: AOJu0Yxjm8IVRKiumqfsM9q6/s6nq6vrA8VhZiAa5aLTsjz3ajrafD/7
	++/g9F5fYNXpVuElmATJ/2E=
X-Google-Smtp-Source: AGHT+IEdztibrkeZFfGiwXGgE6jepWqbfp0eXjJOV+qCac72t6Z/jif5IKBKkhio8ZsAy6iSofsL2w==
X-Received: by 2002:a05:6e02:1110:b0:349:76b0:4dde with SMTP id u16-20020a056e02111000b0034976b04ddemr12506149ilk.11.1692037398971;
        Mon, 14 Aug 2023 11:23:18 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t5-20020a028785000000b0042b144abf71sm3075325jai.179.2023.08.14.11.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 11:23:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 14 Aug 2023 11:23:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.19 00/33] 4.19.292-rc1 review
Message-ID: <b2a9b6cf-d9fa-44fe-9b63-52e9e3163669@roeck-us.net>
References: <20230813211703.915807095@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230813211703.915807095@linuxfoundation.org>

On Sun, Aug 13, 2023 at 11:18:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.292 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 149 pass: 149 fail: 0
Qemu test results:
	total: 432 pass: 432 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
