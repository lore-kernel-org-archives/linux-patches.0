Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986EE54650
	for <patches@lists.linux.dev>; Mon, 18 Dec 2023 20:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marliere.net header.i=@marliere.net header.b="siimhbt5"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-28b0016d989so1502710a91.1
        for <patches@lists.linux.dev>; Mon, 18 Dec 2023 12:54:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702932899; x=1703537699;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:dkim-signature:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oyqQ/Wvr4doZBB9HaM9FngNfKFGZsIGpvcft8cmNfOo=;
        b=V19olQYIINCshjz59O8PDPSqflFExP3v2jC3k73+z72WZSo+PJtdcHKJNm3yaOnwXY
         3zN/b4s7UNpAqqOr82m/T1wlSfFRQ0wmwLBo/3ni1h7OAJYZYyUefsP0BIkpauQXzkwa
         Zpf2wKRhFtjcaKu35l6dOPUDycgxmccwCRHFV/dPXy1F0R5abJFHJMfgZmPWDuES2JeN
         IBFmN1+jQ/kev+Efo/3P/hZcrETBUAQ+A4knSon6xWiPr7cbxyhnfLouYLdFDKPqA/Xa
         h4/+eScperXz560S43OOV9f0QYvT6il6x9i+tGvBTcIFKrZBBcKDT7K61MpGlemqzz4B
         mIWg==
X-Gm-Message-State: AOJu0YzoK5GEuorfo0iBc7whlKKseKiJ4uRdukduMBgPV3ebhK74c2Cr
	FQjVATlsHrS43MlKiyTeemk=
X-Google-Smtp-Source: AGHT+IFERz3rs4RdAWJgq6WTgWn0TmksVSr8VOrVO3aujyG/amJD5/zezu8GxPpfcuOA4ZB3FDfDuQ==
X-Received: by 2002:a17:90a:c7c3:b0:28b:7ee0:4ef0 with SMTP id gf3-20020a17090ac7c300b0028b7ee04ef0mr1098616pjb.39.1702932898720;
        Mon, 18 Dec 2023 12:54:58 -0800 (PST)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id mv21-20020a17090b199500b0028b96c9424dsm1850894pjb.1.2023.12.18.12.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 12:54:58 -0800 (PST)
Date: Mon, 18 Dec 2023 17:54:56 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2023; t=1702932896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oyqQ/Wvr4doZBB9HaM9FngNfKFGZsIGpvcft8cmNfOo=;
	b=siimhbt5hHKDQ19pCpHzQ6fYMLH+cOLBqXU8H2jSwJx9pZO9wOYzPxq3UpeILIgVC0D0Qt
	42QIgsZlb11IwEyqMFVg/Y/MHZeAiOeT99qxTnBEhNk2P1vmAVGneIY3cNEEJFwZqyQpZ0
	1h+/LPd51yv7Mr1N5GH3RFrRVR0gwYRydvKD3fmF2ZyTV9VYOv4FcLXXUPlhfNKIFHo5dk
	WQQS4ne7OHeb5A2X+zz63PepVEOJG2sKfGVrnHD87H22R0uu/XQIWlhN6NFT6VZOEbZ0x0
	ipJS3o+CAi2pE2dA1oPcb5Z04iQS9Mb/QqSg/U3lS0qRDeA0MOTXcCyfvLBayQ==
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
Subject: Re: [PATCH 6.6 000/166] 6.6.8-rc1 review
Message-ID: <6ax5yt6ximpyqdsv7lwkqh53uezui2mkifgcqh3hocirebvn53@uzodujfok34p>
References: <20231218135104.927894164@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>

On 23/12/18 02:49PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.8 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Dec 2023 13:50:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks

No regressions found on my system.

[    0.000000] Linux version 6.6.8-rc1+ (rbmarliere@debian) (Debian clang version 16.0.6 (19), GNU ld (GNU Binutils for Debian) 2.41.50.20231214) #14 SMP PREEMPT_DYNAMIC Mon Dec 18 14:51:26 -03 2023

Tested-by: Ricardo B. Marliere <ricardo@marliere.net>

Thanks!
-	Ricardo
