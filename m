Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9BDBE66
	for <patches@lists.linux.dev>; Wed, 13 Dec 2023 14:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iHsGUazK"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-28abb389323so1320602a91.2
        for <patches@lists.linux.dev>; Wed, 13 Dec 2023 06:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702477869; x=1703082669; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V7cxGDpyTU0G2lgbj2ZNrA+U3QoFsrWoQUXlkBO5j1M=;
        b=iHsGUazK+FM2ZVg49ml98WPWU+iOOktE2BJAZ0oLN2ojiSRpKMgLLwQpObklLeHUrD
         KdN4iAoy85Lolbd1dkXLXGEOYSeBPCS1duBnTlk37UZq1g/DJoQ7pun0mFJI046uJ68p
         xjk0twRgldz+CW0HzufUdVB30JkA1MPITLAB5my80MjCF1pkjWynT0vv7izB6+TDBKw/
         Q6sP9O80izsSXE0kRiM3rZ2w0WHRWyB+L7LtlZ33M7h1rZh1BU/Bz0ry5f+P2Fy+7sSE
         DXaASsEyMlp5j54iJNV6W01+SZneeDsqruEIOMJyWRLlNm55mhfwc+U9bRuCIZcA+BYx
         tBPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702477869; x=1703082669;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V7cxGDpyTU0G2lgbj2ZNrA+U3QoFsrWoQUXlkBO5j1M=;
        b=qzwT5IE7BsSdC3tbHqijuuHCuhkTuDEfbpR2WhcNgQXiMogySOuwd16ixzLtE1Ncvu
         Et1dNdS1iM1wIPbNLlX+lxesbPikA2VEBt2DQZau1CLBWE+ofmhVYvZ0z1/by1sS6xij
         lAWIKoTUkhlo50N2A32x/JniU+QNMtVJxj+O66Ps62t02w2N+0PFL+oF/vFibi1E4k+i
         eNKeZ2mdfs61q3Crgiqxbk3BIBF1Wr22rt9mcW4x55ipl5gwCakEEOeLiN1NHhlZVUO6
         uLrfqyN5E+VjIbYIyxXoGPaSQVtWgP/B7hHxu34bFIzYGfQ8StsxYVuPFxtDo8NYY8Zg
         wvtw==
X-Gm-Message-State: AOJu0YwS1CTImOmRrAB/xSzVLBgR1ZgMcjxC1cT/IXo1cJ7ta5tzfMvW
	WGgwsEN1DaKthkE+YshZgn8=
X-Google-Smtp-Source: AGHT+IGSQmA9WJzh0JjBuy+h+XO1/qpBe/PJbDadqbdnMqnIBKqgHDtrPiXZp8yg5oxNLJD6dWtauQ==
X-Received: by 2002:a17:90a:d242:b0:28a:f301:be16 with SMTP id o2-20020a17090ad24200b0028af301be16mr210730pjw.56.1702477868922;
        Wed, 13 Dec 2023 06:31:08 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ft22-20020a17090b0f9600b0028ad9d801e3sm1418395pjb.46.2023.12.13.06.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 06:31:08 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 13 Dec 2023 06:31:07 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 000/139] 5.15.143-rc2 review
Message-ID: <a798a295-9e44-4d30-9069-59fcc57c33c9@roeck-us.net>
References: <20231212120210.556388977@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231212120210.556388977@linuxfoundation.org>

On Tue, Dec 12, 2023 at 01:04:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.143 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Dec 2023 12:01:32 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 525 pass: 525 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
