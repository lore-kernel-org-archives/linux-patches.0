Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B1E3AC1B
	for <patches@lists.linux.dev>; Wed, 10 Jan 2024 11:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marliere.net header.i=@marliere.net header.b="HioB4ei+"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-28db4f860easo532724a91.3
        for <patches@lists.linux.dev>; Wed, 10 Jan 2024 03:29:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704886168; x=1705490968;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:dkim-signature:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sd9KoMYLeziNK4DDc7cQHmh6PfB06g+zdl70q6cPYIg=;
        b=XcWz9f4WdnDLgbM89i6OreYCT+HsSqVaGJDG1sShI6uTDrQLTl8lg6VOzh0H/EqOQl
         tljf3Zkebqa/KO4cdjpUkpbrEkW36O45qRu8SfpwnJec3gFV9+mVW22JkavDiO/l6fYf
         acS5Vc9k1TenanwlR1hZm6JFqWw09otzDyUtc/JqQEnv3FTTzzyIgKWhzIzqQdTJL5Ss
         hvMtEZX+ahJMG4pKcnlv2NC30HTRkT3O+HrFZTSL6RyRXTKCSUH53DRAPleOyR+MEmQ+
         7VlBenpa/OrRFA5ml4GpH2O+Z84S2Zz+wYqibcdweOiWdWWJPmUh6LIjN+ChJzZTfkML
         +kdw==
X-Gm-Message-State: AOJu0Yyiu0n7ffDE1m7xKXAJ/iRLXpB4sl8MglLcHfa9tOHvpGsBTxi6
	Xu/QjqMIQZGVvxUrkV/ZE1A=
X-Google-Smtp-Source: AGHT+IGUaroPt6ao2/Q+kSx/LjIuD93mF78quMxU86dAnctI1ISMFoW3uRBD7N6iSjeIEqnKq9uaDw==
X-Received: by 2002:a17:90a:b883:b0:28c:5b7:87c5 with SMTP id o3-20020a17090ab88300b0028c05b787c5mr411371pjr.2.1704886168502;
        Wed, 10 Jan 2024 03:29:28 -0800 (PST)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id r7-20020a17090ad40700b00286920600a9sm1283168pju.32.2024.01.10.03.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 03:29:27 -0800 (PST)
Date: Wed, 10 Jan 2024 08:29:26 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2023; t=1704886166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sd9KoMYLeziNK4DDc7cQHmh6PfB06g+zdl70q6cPYIg=;
	b=HioB4ei+m4iR+RQEiNF+din6hdYrf6xMT6HKSS2BpKdw+CcHDihLB3fyM2aDVCUMvmKHpj
	FJSy8F26WGNT6Gvqoyf2j+Ctss10SrgFfIrHJ3MbwGHlfuPMrDIzy8VgYjU5LH9BB1uqhC
	PSpxWvWPueimV/USCu5ziJTIhgTptIfOkrSKshflZR7Lfh/XndzC2J69yem1AOogCkaNtG
	TVPL5Zl2LenfqSoFR4RcDeJZQg6qYCP4xr9UAXwnFO7SGcEIJ4DMQAcshXlmEOD9dEJ22X
	LQtZ6N0rL/O5VDpbyXTv2KAB94dmd9gznwo4ABAopTYraXooHnhna13lIGK90g==
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
Subject: Re: [PATCH 6.6 000/124] 6.6.11-rc1 review
Message-ID: <4mmnqui4njnmr4lik4jf6iaoi3ykivewytoba4dhydk3qr6juj@2im6qkfei2lv>
References: <20240108150602.976232871@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>

On  8 Jan 16:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.11 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Jan 2024 15:05:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

System runs fine, no noticeable regressions.

Linux version 6.6.11-rc1-ktest-gc52463eb66c8 (rbmarliere@debian) (gcc (Debian 13.2.0-9) 13.2.0, GNU ld (GNU Binutils for Debian) 2.41.50.20231227) #1 SMP PREEMPT_DYNAMIC Tue Jan  9 14:26:52 -03 2024

Tested-by: Ricardo B. Marliere <ricardo@marliere.net>

Thanks,
-	Ricardo
