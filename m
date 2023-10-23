Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D432110D
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 18:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marliere.net header.i=@marliere.net header.b="gTtBmBYK"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1c9e95aa02dso25839995ad.0
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:00:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698084001; x=1698688801;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:dkim-signature:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=if1LMXlv0NhauuH28lMDtOeb3mWnKzXBZm74izG4Zeg=;
        b=bfq5EfojYBiXqp76/1h1UX9NG33SjlcA+KyA2NimXZQJgv9WciNatjqOvTm8UGVBpj
         C03CCvJQH7/vtkm7AW4Ky+kGhoyMuPtB2tq+hwwd+7zKilIjcrjmnnKZCFEIXA8K5Lu9
         CXtNiZ7nG9WYME81NH1JLcqSZqRGHV9qmBF7LBakR6T1F4F65eewvLkpvFdmSmCU17hY
         eOd7GDwBpqii4INL/zkLV+03V8V3aXmxRmGA4SKKLGeN4DzIOlEA6rwlowPcMTxPv/Rz
         AwKZSSYp9R1G+7/HpDa0Z+fssn0jftlEcbw0VKsbPxFsTIYywMxDZb9R561KC8yKwj18
         BbEQ==
X-Gm-Message-State: AOJu0YxGSH3aQ9pFuIevUImhX8p29hl5K2RzePJKGZJoejCNLoaeb3Zg
	iSwyGVhoOonTW7dMgT2pVXk=
X-Google-Smtp-Source: AGHT+IFPsJVzfo/OsLom/DGay5ElN50D6Mg9r1ORsvr+E5Vaiqj5Mg4VAHv4nQ81x5tqmsYnXxHHvQ==
X-Received: by 2002:a17:903:6cc:b0:1c3:868f:5958 with SMTP id kj12-20020a17090306cc00b001c3868f5958mr13544298plb.20.1698084000520;
        Mon, 23 Oct 2023 11:00:00 -0700 (PDT)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id w12-20020a170902d3cc00b001b8b45b177esm6155629plb.274.2023.10.23.10.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 10:59:59 -0700 (PDT)
Date: Mon, 23 Oct 2023 14:59:50 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2023; t=1698083995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=if1LMXlv0NhauuH28lMDtOeb3mWnKzXBZm74izG4Zeg=;
	b=gTtBmBYKRR0gMuSKRaMDRVG8fsRnt3LpbRHsD9gI/89/og95qXEOq0fm0TStsg2vgEaiaV
	gTo8yAfMW7yPDIJ1uo5jGHSSkyk0S1uOW1BtTiiempUVIKgmcQx4DrNxYba2Cyt4XbvGbk
	HwX2dUvlcsKWWNQsLg2kiSc1t9AJQGEfPQKa74628fcIIZusdFJSlCwwPrFBNWHdFcyfYc
	hhz+DzfKxkLej9C+i8aP+4Yz5i2T6fT9Oe4fhIGtrBkpyJW2d86ScWYkr6Miv16WLvkKCG
	WfpYAoxgIyK2q8sS2CDQh4nI6Jm8R2InkOUr3Km2YV1kpF/QxeGi0L9VcRsO0g==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
From: "Ricardo B. Marliere" <ricardo@marliere.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/241] 6.5.9-rc1 review
Message-ID: <oeyc3waqchvvqlc5adqr73gqcz3tbvygq7lwtthccrvo6glhpp@bribwsnfv4rm>
References: <20231023104833.832874523@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>

On 23/10/23 12:53PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.9 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.

No build and dmesg warnings, my system runs fine:

[    0.000000] Linux version 6.5.9-rc1+ (rbmarliere@debian) (gcc (Debian 13.2.0-4) 13.2.0, GNU ld (GNU Binutils for Debian) 2.41) #9 SMP PREEMPT_DYNAMIC Mon Oct 23 11:50:20 -03 2023

Tested-by: Ricardo B. Marliere <ricardo@marliere.net>
