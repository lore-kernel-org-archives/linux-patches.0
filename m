Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F5070986
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 21:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marliere.net header.i=@marliere.net header.b="SK7ZQ7m7"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-58d12b53293so139574eaf.0
        for <patches@lists.linux.dev>; Wed, 06 Dec 2023 13:42:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701898977; x=1702503777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:dkim-signature:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=G+/fJM3jhJ9Ym3ibRvsgfYVd/7GnLfdEWeKgca1GSDM=;
        b=WKOflLYuoPp1LGopNbmDWjv9qBsDZeF6WEalhUP9g6IqO5bsVJoCmIxxYo28YuSlHP
         jdjCZIjyvUqF+eR+uNAouINMNSTMDpwsxMGcPZBNZGX2Tjf++kfSC131YzV944Jz+EmP
         jfZgv3MmIh8OQuHwi3phs+YWBj6j9CyV+NxxxDEYOhJHebgYRWPoKu8u3G59gxzmP3ye
         y3cklFD4PP9x6wK05ugPGccvIiG7EskLurPzGnsqhuoepLqcUyewACLWpfOsnnWhuCdf
         JpsO4eSRrSPsk+XFA1/D/YOAW0hAFIXiMCNgWuZQBAcSrD30QXT/08YurHGTYVdmECPN
         DzxA==
X-Gm-Message-State: AOJu0YxQu9pS/M449Rv52nzrzYogTpHXnEPziww63gZG+4q/6fTa6xef
	E1D/TqjyPswjSpeadV0gnZ8SNha9++LnZQ==
X-Google-Smtp-Source: AGHT+IEGaBIM38k+345rksTXCmqkaZf55qi/QOP58bKt3rV7Q69ICIjRIzZGQ6PJVsI/HVeMIJBjZg==
X-Received: by 2002:a05:6358:7e84:b0:170:2abc:6e34 with SMTP id o4-20020a0563587e8400b001702abc6e34mr2358249rwn.19.1701898977379;
        Wed, 06 Dec 2023 13:42:57 -0800 (PST)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id b1-20020a056a00114100b006cb7bdbc3besm447820pfm.17.2023.12.06.13.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 13:42:56 -0800 (PST)
Date: Wed, 6 Dec 2023 18:42:54 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2023; t=1701898974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G+/fJM3jhJ9Ym3ibRvsgfYVd/7GnLfdEWeKgca1GSDM=;
	b=SK7ZQ7m7+KS+DkQUUFCZ8kDv0apQxPzOOmE+WUEaUfR4yg07D0DfAWbIkfyrHlnqOkyLaA
	u1fXezvaOIrBWqe0X38jIl2m/RnuU34waHDpBbT4cKFcFEqU/CsSA9rLoVLPSHqrN15yIr
	TMxf4gcQuQtAVryDgbTLrBmiCUTnHMR+6GR+KL0Cq29jap+abUaz+fCUQiBoT+LJ/wLXFM
	jFFa8l6XjypUwVNkDG+Txs76A/gkNfvS9ul/D9FaEUDHSf8huAELX5nUv1lq0+/+PCpV05
	5XydvWtHBeFRk+/E7bBv2copG43W8KH7V6N2H5o6zrH4N/GDp+/ayiyusK7NQw==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
From: "Ricardo B. Marliere" <ricardo@marliere.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/134] 6.6.5-rc1 review
Message-ID: <vtxguldy2soodrfvvfqrvfojlfpo66axtaodszyuguc73mfh4u@qbtwh5qxjuzz>
References: <20231205031535.163661217@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>

On 23/12/05 12:14PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.5 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,

No regressions on my system,
[    0.000000] Linux version 6.6.5-rc1+ (rbmarliere@debian) (Debian clang version 16.0.6 (19), GNU ld (GNU Binutils for Debian) 2.41) #10 SMP PREEMPT_DYNAMIC Wed Dec  6 18:35:57 -03 2023

Tested-by: Ricardo B. Marliere <ricardo@marliere.net>

Thanks!
