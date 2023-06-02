Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95073C13B
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 22:36:16 +0000 (UTC)
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3982f09df74so2136050b6e.0
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 15:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685745375; x=1688337375;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=of674XRvlx3/FzSHdFSRdMppyBXBB7Firiv2U8wT/bU=;
        b=cYOr6LStbQ3rQIrtdbTdHjzgR5m6u66Bo5p+KO8lEDSsdK8HUE0hUIuzQhYafkDwix
         xPzTdY14ks52OKikb5o2jLwC48FeqNWi1t/OK84cHM+EcKQLvrtlqZVRaj+5LuJoFdQu
         72uoCT0nbZlxTA6co0a9D6H+nB2Jdu4BEsoxCz8DBJzk2FZzN4RTHtP+hxo1Xhe1pjBm
         hfTHp4S4rxZ5uzvR0FY+BXZoAzdHEJHh8mjm1naOlRZ0day1BL9FwysO+cefR0O6JRNO
         1KsBRF91rqOg9a/CFBEXzkiwarjUl0FNrnp8vy1eZD1xo2bmcqH2ZpUzaAw76bhITfJD
         xPPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685745375; x=1688337375;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=of674XRvlx3/FzSHdFSRdMppyBXBB7Firiv2U8wT/bU=;
        b=NHzLSQAmzKOg5f7X/D22OtgcjAmKRh4dXydghQ8k/KB39N2q8R/9XoMqdOIUP8LGTQ
         nK6Ek5O+aLjylxveAZyXzxTz8GQ1QMjYgr03ZYhS2bg0AMsQsrHjpfHBZidgi6UkK8JK
         3zMpcHXiaMGK4ed6UF7vYI9BmcohxayfbNMps/DWDubqUHGxiWJfFhW8XxWr2fS5Qdft
         K4w4GLsOmGljGUAu9eNtUFuZycLDLIr+AFZ6P+eQEXOvWXZ0Z3d0txVjJzvdQDk3kwws
         70X1c2QzDxsLwbTeIkFXIaLfmOMEipu3GQpKUVpzxqLTmSweFnnUNxf+gomguOdQzHCb
         w6wA==
X-Gm-Message-State: AC+VfDwHQeshPxKpj9Tm4iH6yMFKEHmwnY7jxrEB/v0P+1PeRB8nNLAf
	icOmoletF2xg/LjiZZ4fM34=
X-Google-Smtp-Source: ACHHUZ7lSmvU5fH9/0RO8nspGwMqr/NGHrSuB7aPRrWM4oGtYd3eyKrAsG/6f17WVxdltdL/VQJFYA==
X-Received: by 2002:a05:6808:8c5:b0:398:59fe:6ee3 with SMTP id k5-20020a05680808c500b0039859fe6ee3mr1106424oij.54.1685745375577;
        Fri, 02 Jun 2023 15:36:15 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x4-20020a170902ea8400b001a2104d706fsm1835249plb.225.2023.06.02.15.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 15:36:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 2 Jun 2023 15:36:14 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 00/45] 6.3.6-rc1 review
Message-ID: <f3c90f5e-696f-4458-9fef-ff82f5d41e1c@roeck-us.net>
References: <20230601131938.702671708@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601131938.702671708@linuxfoundation.org>

On Thu, Jun 01, 2023 at 02:20:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.6 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Jun 2023 13:19:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 153 pass: 153 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
