Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C77A17D5
	for <patches@lists.linux.dev>; Sat,  1 Jul 2023 02:52:33 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1b8171718a1so18637795ad.2
        for <patches@lists.linux.dev>; Fri, 30 Jun 2023 19:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688179953; x=1690771953;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TRrHr6UEiq56x6SWgCHurtfSPLy20rMaAzy+jSm0CKc=;
        b=ZjGI98TRa1qxIvziozFUY2FEPZAksLh/7yLdUYiFmOxEO68OhLi63ynh8J6EXVAKil
         7XZXpyQBdXEFRv0b6YOB0y5l1XHJfz4wq1ffgFybhTpG6gBLyefIFt5ThNi3GS20BS0T
         Po8T+7X6QaRuL2GIXNOof2z1zpZ4Zl/lIpwDn1r0tJ5wQKf+x6Xxo+1u8RNnTb6ShvvZ
         ScB8IXg2zCngn0BhdAA+lvaXJ3wXyIQaOwZiSnRtrAdMs69FmTzZaT73bCoKeAMHAaVv
         /ZwnGy1+LfAWyGHichONUkSgF94WAtdzwhrPKatP2EcbUsix3N2IEdQLtKRxLZZs0r35
         QKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688179953; x=1690771953;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TRrHr6UEiq56x6SWgCHurtfSPLy20rMaAzy+jSm0CKc=;
        b=No6SWyCJeApjgghwDasH6oRmYdIEQH44dCnLs+FKCLRe0fiIE/ReugBor2pdN1Goe4
         E+hi+XUhzx1PaO62ZnRsJKnVbFeCiYAPHG0riWMTXHK1p2dMBYH7oxgvKIhOkYwKmU0d
         jg6hr2y1xkfqItZJkQumSMG9EVDTwNivwtYxLPi+UxFWlRhh3+aPU02L72wCinSdgEB5
         /NukVawAIKKWS3QzkxKHrdGXI+MJEBREbNRMmiR2GvhtHn7gFsdgOQnQXdwxqk/Y/O5P
         j9ckrEpIy6Gs2zKE1HzN2LJ6oLl7iM8ba8uladk0hCYqTc2XwKx4+SaT4w/LfnrL9nur
         zlhQ==
X-Gm-Message-State: ABy/qLbaV/12JtcBMGWRYDLjuI/QuKP3JSrd3Gf3+6qn2zG6bxxhqnnC
	P/zaLfnqV4aargHlNqRalGo=
X-Google-Smtp-Source: APBJJlFqB8Bf8VkiGpreAMOsX6QylwofUfVYvcXRfj1zAgibD2LC/YRQP1Vgyp9B+2sNdd1Ge36MYQ==
X-Received: by 2002:a17:902:e5c1:b0:1b2:a63:95aa with SMTP id u1-20020a170902e5c100b001b20a6395aamr4572712plf.54.1688179953021;
        Fri, 30 Jun 2023 19:52:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id az12-20020a170902a58c00b001b0034557afsm11370517plb.15.2023.06.30.19.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jun 2023 19:52:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 30 Jun 2023 19:52:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 00/31] 6.4.1-rc3 review
Message-ID: <eb3f2352-98c8-4d33-beea-d2d88dbe3371@roeck-us.net>
References: <20230630072101.040486316@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230630072101.040486316@linuxfoundation.org>

On Fri, Jun 30, 2023 at 09:33:31AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.1 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 Jul 2023 07:20:45 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 152 pass: 152 fail: 0
Qemu test results:
	total: 520 pass: 519 fail: 1
Failed tests:
	xtensa:de212:kc705-nommu:nommu_kc705_defconfig

Guenter
