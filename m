Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D8E4C8A
	for <patches@lists.linux.dev>; Tue, 19 Dec 2023 03:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EZU0ARb6"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7b7aacf6537so159894239f.0
        for <patches@lists.linux.dev>; Mon, 18 Dec 2023 19:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702956117; x=1703560917; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zoV9GqduPrVGm8r75cHOkBWSja9eINizeXsgtnG0uG4=;
        b=EZU0ARb6SQfd6nIzPz4fnK0T8VlPAjfK3yB5E+1/W52bdtFausjHIGgWek/hStFNEp
         pzE6zUjp+h20KXaP9fbzv9fMygGSOj3TQUHX7tZ1CxpABKWzPhCANejJh+qho7QLFDT6
         p99tGgiaUlKVr9pyEatQdaDhzAudNfy/HyDjpEag3BdUm1C5me96C4g+4nZBUiax7TPK
         EwzwChnlvO/cvt+wyz0WdIAjUeKor85eZM3f9gKzWPCQ7VneJ14BVqkfaUWDV/1mFNJm
         HwMpELBpLMn/j6yn75WFjp9yVtTmi7e4UHzKTJd5IcglzZnUmUUAea/hJ74krNJdL1ZE
         6RJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702956117; x=1703560917;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zoV9GqduPrVGm8r75cHOkBWSja9eINizeXsgtnG0uG4=;
        b=sHasZSVA1vEllIFV/yS3AAIs702eO6evUI6lG8eSEjq1iPB2DvX8XYcauRPhOvnDCn
         KfGdELJ7+1pPhTOYrPnh70v98c+KhXzcLvIf+antqwsOA4fiOBUVtHZIxM1u49T9IVwi
         ZA7+GExM2qqtU3aZs1WopnLHBWZZQTMHnDsRpma8d3t+380QrNr4pMNEdHoNj7EYIV9T
         3oVKRNJ9eWLFUDoyQbMBiWsez4o3l8kxSrV7L86wD25HlPbOcTtxK+zwslJdIu8ud6WN
         ER/tzEz+YRSIqsm3loEBv05uJIU8wA1arHh87nYyq/z/ABqrbPWsiErVKMYzDxXc8lwq
         n7/Q==
X-Gm-Message-State: AOJu0YxOM3s1mYGqwyiv1cKmD0UC3u725pN4L/3n1BXS2OmITC0/9k1m
	VjOIu7bZhDck6r4q+Kr5YQA=
X-Google-Smtp-Source: AGHT+IE2jR79j0vPZNn/aP7SsfnghxZOh1HIZ40/PouucYaYoNdNb1JkSy1KnWl1m/i12RdwOEJUxQ==
X-Received: by 2002:a05:6e02:33a0:b0:35f:a493:86bc with SMTP id bn32-20020a056e0233a000b0035fa49386bcmr6438950ilb.63.1702956117070;
        Mon, 18 Dec 2023 19:21:57 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id iw19-20020a170903045300b001d37bdc4934sm5711561plb.110.2023.12.18.19.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 19:21:56 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 7A77A10211E9D; Tue, 19 Dec 2023 10:21:53 +0700 (WIB)
Date: Tue, 19 Dec 2023 10:21:53 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/166] 6.6.8-rc1 review
Message-ID: <ZYEMUZKX9uPO7mpq@archie.me>
References: <20231218135104.927894164@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>

On Mon, Dec 18, 2023 at 02:49:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.8 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
