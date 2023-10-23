Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DFD21343
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 18:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marliere.net header.i=@marliere.net header.b="YiPNrgGb"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1c8a1541232so30314375ad.0
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:03:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698084197; x=1698688997;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:dkim-signature:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=x2ZqpTyCO+kJIAJ7HqJgpSJj35kBsl28+6ENLNRZ63I=;
        b=U7D4kj/BgVSiEtaVR0IfGKt24NLsUsQE3gq0+WBsDotZrULiLWS9fBT8RGilXQz6T4
         QyysOpIOVg2gFQpiMnRVoCGxTHTavPbMl/h+qLDAFH0tUKDUCo1RmK3IoILvo5U03CZO
         ruXH3tByQZ11UA5SksGoyMrqdxsDRcFyVrfd+HVfPJDy0OaStLswhVPzQHLzpAgHpGh9
         tRc5YVSMpa+gMZlI2Obbs+MygCEhiXGFY5cDP/Qaa8PiWR09SYoGK/lnIiughYqJ9Sca
         tIeUXW0EqTa4PSbzbrXV/3asNmpXGOav/s+SNYv2/I/pVpXxRsTMY0bR1ZkkxDSpXCX+
         dQnw==
X-Gm-Message-State: AOJu0YwgmZjNmtmE5tX8RfGoIVqY2tGJIja65PX77cXylm8FeU+l4WOf
	O+KsM1R5D2BqPOzzC3fzIT4=
X-Google-Smtp-Source: AGHT+IHH5PQ07hCGgq+WSZeo7fx93rChffPvxtWeFggG++Gzf1iak1AGF9mR2o7X0poh3s1kwFr7tA==
X-Received: by 2002:a17:903:1383:b0:1ca:8e79:538f with SMTP id jx3-20020a170903138300b001ca8e79538fmr8233599plb.25.1698084196857;
        Mon, 23 Oct 2023 11:03:16 -0700 (PDT)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id u17-20020a17090341d100b001c465bedaccsm6227165ple.83.2023.10.23.11.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 11:03:16 -0700 (PDT)
Date: Mon, 23 Oct 2023 15:03:17 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2023; t=1698084192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x2ZqpTyCO+kJIAJ7HqJgpSJj35kBsl28+6ENLNRZ63I=;
	b=YiPNrgGbrrWiFs8dHHlwO55lm1ipsGjy2+/viuXz1VrCybJ+Wojs/uHrzyRgESyVnIKgXa
	UUdmbR350zYHGAAUHtDJPShfAdAyYSBa7T5/hWn1Fa4ZaH7U0OOFs7dTCshUtkUayRRqOU
	AxStKeWJJF97x3oqzJtncvQPUgHorIiPqAwmDzSdZvzyjS/ypiNhJWwWCvMwQcGl9dUV/t
	K+X+c1G1lgHDZQhV3Yuxsq/26EyPN7iCBKyOe7+Y268xgTEsVU3sIfzDMLOkeaGcYBet3y
	RYa6nmO+LnTCdsGAcN2SSIPgTMEIC/0vjFfY6wFPQQBwVdXroJm6HDfVkN4piQ==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
From: "Ricardo B. Marliere" <ricardo@marliere.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/196] 6.1.60-rc1 review
Message-ID: <n2fduxk6hes7u6wqii3mqg3eqeojc7fknraltfevuvlhnhqoa3@x3ykifdp4f27>
References: <20231023104828.488041585@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>

On 23/10/23 12:54PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.60 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.

No build and dmesg warnings, my system runs fine:

[    0.000000] Linux version 6.1.60-rc1+ (rbmarliere@debian) (gcc (Debian 13.2.0-4) 13.2.0, GNU ld (GNU Binutils for Debian) 2.41) #3 SMP PREEMPT_DYNAMIC Mon Oct 23 11:52:39 -03 2023

Tested-by: Ricardo B. Marliere <ricardo@marliere.net>
