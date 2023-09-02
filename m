Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D0D17EF
	for <patches@lists.linux.dev>; Sat,  2 Sep 2023 04:16:12 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7927611c54bso92951939f.2
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 21:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693628171; x=1694232971; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W5mTjDDsIVAoQfJnfsps3hPdAwSGyGWAPaJJUcHWL5w=;
        b=n/Jn3OU1RdU2XvgtqVI9FDp/ZX1qLE5GG4SBpiF4brPtKDHhdTsKInKa2QyLe2GGaC
         5q5bfzL+8NvYYSHvCPayyTKvkcvK91JwH2xRZIc4woq+8pTvY6V/t5hK44VzAnoBsX5R
         DKvcfdayilvg/378Ib2z3o9jWkfgblijjCvkUAhMJILf/nieNcBcrnN0wIbHkpWSv/cZ
         7mtYX+tsLOcgrcbl/0g8oKZ+e+VQepWMui6GJZZB82+g7KQydqrDdpfeGxujsAsbtQJ0
         SPhWTcAl2/VLIh58ijHL+6sdSvQyKz5sayOvN8M1qo6KUf/rSjQKzyDEPYq4aj0ylr3K
         A18g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693628171; x=1694232971;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W5mTjDDsIVAoQfJnfsps3hPdAwSGyGWAPaJJUcHWL5w=;
        b=E61G0lPjDsKgxcDWcveisw7iCEZFRkT7b1eyy5aKWyHkfhQZalv8RWxXOww5qNtQNx
         PbxzocaUYVeW/mpvkJnwGda2I42PHdFhhrjAsiRjItrG9dccd/A/gHM5GMm/nbCLM8W7
         56LVgFrvYZ9Bpor3gKW/obQ5GjFAwvgHvDjudZON0xwevtjpRUreYiy2yr2Oto5otXA9
         Fgt26netXt/dnJ6KFBWGupiEgE6GM+f7c0BpZe6oNVoF8iSNDbhHvx5+xkOJSoUtEcJp
         A5S2x4ucaRYgsvHahOescIVWPUpff/frCg/7E891DAwjk4rx39DRNNO0TS/9j1Kk7kp5
         y0wQ==
X-Gm-Message-State: AOJu0YxI6zpOqE4tn5U5JwEKoRjkC923+irXczhbKqmzJeyMY/MM8xkX
	Xg38PHYfqBf5dj/O8fLN73Y=
X-Google-Smtp-Source: AGHT+IHSet6TSJOotSDq2D0Tv8YX6F10eAV1fBrTk0WxrX9c9+Lvj1V4mPVSARY2aicSp7ABjjyDiQ==
X-Received: by 2002:a05:6602:22d1:b0:786:cc36:360c with SMTP id e17-20020a05660222d100b00786cc36360cmr4683810ioe.8.1693628171493;
        Fri, 01 Sep 2023 21:16:11 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 24-20020a0566380a5800b0042b05c1b702sm1512790jap.12.2023.09.01.21.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 21:16:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 1 Sep 2023 21:16:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.14 0/2] 4.14.325-rc1 review
Message-ID: <b412f90e-d355-4ff7-8bf7-7cb8fbaf5169@roeck-us.net>
References: <20230831110828.577111137@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831110828.577111137@linuxfoundation.org>

On Thu, Aug 31, 2023 at 01:09:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.325 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 139 pass: 139 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
