Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97987321A4
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 17:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marliere.net header.i=@marliere.net header.b="DEx/dWax"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-1f0f94943d9so628327fac.2
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 09:15:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699377356; x=1699982156;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:dkim-signature:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=o3JkKLwAwJdKQeiiREsn2ZXGc82r7DnIspAVxlaKU+0=;
        b=XlkWxNzdihX8ZUCGH1mLoZ6BUKtLZrSFVjjM5ajj65TNP2pJo2Okt4VBmDPr6Fefm6
         BU21QX5ifitwfSHedBOB5zx7Xrrr9UvFaMsYDz941GN1xxjQ76OnAlNqwtqdpfYrNhnE
         f9DB1X+xvLV5JVdPZ6v2VaHnc8Au1mhNL0tYbFVupY4xJxbMPzc8Oq1YMB+kqpAJAkf7
         xK/XmqcwaVjO5zeuY5hvC556k8z21ql2zaiGsmHarv2DlCgbj3J85ZFmYuCSZ9BgP6/C
         eN7R5+lyHJEX/1kpFlwOZacBd12RQMQgJJuwxY5t0giUA1gAmZ22b65m0wtJO0dZUiDD
         4k+g==
X-Gm-Message-State: AOJu0YxICA+UHVuolCYt8wAuxoz6X35GZ/rbasmG5t0YQlixKMo0Puxf
	nXZN4cnuH9HmRX0KeWGKsGI=
X-Google-Smtp-Source: AGHT+IGao4fOJShZIACLhtD6KQuHOGX5J+O2BcDsJBuMTHdUquuPkkev4d2UT0d5FsxOhAmLASQi/A==
X-Received: by 2002:a05:6870:32cc:b0:1e9:8a35:8635 with SMTP id r12-20020a05687032cc00b001e98a358635mr3597086oac.21.1699377356597;
        Tue, 07 Nov 2023 09:15:56 -0800 (PST)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id v17-20020a259111000000b00d7b8a1074d4sm5179434ybl.57.2023.11.07.09.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 09:15:56 -0800 (PST)
Date: Tue, 7 Nov 2023 14:15:57 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2023; t=1699377354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o3JkKLwAwJdKQeiiREsn2ZXGc82r7DnIspAVxlaKU+0=;
	b=DEx/dWaxQ8ccwrSDPzBixw8L5Txa0uRanlzCRi3maelhkr8nqd6Y2/S8kyabm9NWrAa4hp
	C5oQnyxNNzXZMuoZ3PTMkTp53n7tiwj+jtKsO3lIL3CCRqb/dmPmlDEkeJqvUNK8pbmF+a
	7+vkgGBanhoVjJ7m6pt9FxVcmp1359LlVtcpA4I5K/WHwWI0ZjUJCSApQ73hsHKMDbo9xN
	P39ciTvHVMMC1cIWBPaVWaEm9a3q3ZiDwWipru6FriaAMIBikJWyF63srq+KZTHFf/G/jn
	xsytGVvSl8EJfpdx5YhjhcdlHnxOKdkHEX044m3D0YUQ5tHoYmsjpOVMLMrLbQ==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
From: "Ricardo B. Marliere" <ricardo@marliere.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.6 00/30] 6.6.1-rc1 review
Message-ID: <2ju7wq3iidsei6szpvxahrjd7ii46ojmtiwrycdstlql3l4y66@k6scuz6argwd>
References: <20231106130257.903265688@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106130257.903265688@linuxfoundation.org>

On 23/11/06 02:03PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.1 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No regressions on my system.

Tested-by: Ricardo B. Marliere <ricardo@marliere.net>

Thank you.

