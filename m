Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18A117D0
	for <patches@lists.linux.dev>; Wed, 17 May 2023 02:47:21 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-643bb9cdd6eso204458b3a.1
        for <patches@lists.linux.dev>; Tue, 16 May 2023 19:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684291641; x=1686883641;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZmEY7joOP2smV3ufIV5wtQ50nKOyO5RSPs1EXTLpO6s=;
        b=adluOgkf6M2EH1GV3xF+lre/wQvGXa9mA/zI++X2iWDGxt0tPWL0iDzY9iZavzjZfr
         Ag5HuJRT6J0EpCMK/oGfm3sAZkDOa6jE2DOXO2LwRIzP643D4leJZSY0SC1FJRf1kElq
         Oag23Ed11aAgtobU2h97I6mJsToOSYDVgPLw/oZNATJg97J62jSVue10PDGEctMJrBC5
         l85/AK8KVpVpsuyxBV6jOOG4vdHEHIXevslOTsUuQC5YEwuiHBco9ebVxh6gV0tyes/R
         8u3cesOdZhyE3kmKNwJgsn5y4OEcCXNAWE5CYrJ5H+J9AVbzxMym7lKKq1UzYHIpIN/Q
         dy9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684291641; x=1686883641;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZmEY7joOP2smV3ufIV5wtQ50nKOyO5RSPs1EXTLpO6s=;
        b=CGfKHwzohEe2HRK48fDSGqwpaU43y4HDuREYne7ftYkbemkityGTffrX3aNQhuPKw5
         Uepf81BTCTDRm5zGQH69e5cnX9RgCVcNtXGQiL8zEC29dvJo3jIfYEvxrcjirmhBA6CJ
         M8xBbScyibbPjYNILuHznsjbzSznKTYUSZ1x19haSdkDXwCZw2Fsf4ZRfIPjWxNDzr4k
         9WLZPYKlAiJHqzGrGVBszq5JQ5zQM+fzqo6lbkMzntT+8AGk2hLzojCIlIbuvrEwxcrr
         H7gxyk2N27lBl9jb1y7wo2gFayUwehP7X98YlNdXFat680aogGYVqITrmNI8cmiB17lA
         1TRA==
X-Gm-Message-State: AC+VfDylFSSRskQYmvpDUluWlvNkXSzJL9V2Ny55r9ePi0NgAcgafsON
	R7j+SoDhryNI1Kewru6Znos=
X-Google-Smtp-Source: ACHHUZ4fiWV0hVLkM5e6EkSfxjeQuFA03yXTwqQx+0RYACKxW3JX1g/49w5DoQaBPAZRE+Ch9VpVIg==
X-Received: by 2002:a05:6a20:54a2:b0:100:85e2:26c9 with SMTP id i34-20020a056a2054a200b0010085e226c9mr43226201pzk.13.1684291641433;
        Tue, 16 May 2023 19:47:21 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 63-20020a630242000000b0052c737ea9bbsm14352099pgc.39.2023.05.16.19.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 19:47:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 16 May 2023 19:47:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/191] 4.19.283-rc1 review
Message-ID: <f2c6e976-f430-487a-b073-5dc3790ed04d@roeck-us.net>
References: <20230515161707.203549282@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>

On Mon, May 15, 2023 at 06:23:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.283 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
