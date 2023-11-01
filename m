Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDD963D7
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 11:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marliere.net header.i=@marliere.net header.b="Tw24Q834"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-5b3b17d36d5so6924267b3.0
        for <patches@lists.linux.dev>; Wed, 01 Nov 2023 04:42:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698838959; x=1699443759;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:dkim-signature:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=C2egqJtjMEVY832Egz6NiSBaRiA5E24nP8wjEBXHQN8=;
        b=MnYFrCBfWlvsthZyBl7jJWczA75ik5i0trbQecAjsdH2g1F/6fTISE3kQoHDF0IrZt
         YPXEvqZ0zTdp1cba3u2llosJo0vftBoba6fTtsVGNOK1hfFH0PXI0ym5OEkvYwSNj+Qz
         keurvr0HPti9T3IlXqV0H9mAnY3+e9xTZuC2FjU317RnQ/0bJtM2A1dHGgnyAiyLqGaY
         9volLcivC/3TV+tpO4GkpqCzYA/K0t1fr7g2K/+oPtpAPCRDZK6mERnN+trXMkLf15cR
         IpKgHJvwx3Oumf2YaNOFip8dJPYoW8Zj53UA4cv4WqxwfZJ95yvPQv7nJnL8hrtLOdwZ
         l+UQ==
X-Gm-Message-State: AOJu0YwQVh7aQoOfwZbUceBTqfbU4E/iVICtvJo9s8L5l4GG2iBAieHi
	uok/pozsEQQpF56ZXwqocjY=
X-Google-Smtp-Source: AGHT+IEt5JUHNTmKjGlZ8GO1dh1xbcpbijmW7pMtYlfK/Xcx/u3VdEvLqB0v/QGRx6umoMZePuSUiQ==
X-Received: by 2002:a25:5104:0:b0:da0:c582:da97 with SMTP id f4-20020a255104000000b00da0c582da97mr1608076ybb.24.1698838958782;
        Wed, 01 Nov 2023 04:42:38 -0700 (PDT)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id y62-20020a25c841000000b00d8674371317sm1881279ybf.36.2023.11.01.04.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Nov 2023 04:42:38 -0700 (PDT)
Date: Wed, 1 Nov 2023 08:42:50 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2023; t=1698838956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C2egqJtjMEVY832Egz6NiSBaRiA5E24nP8wjEBXHQN8=;
	b=Tw24Q834At+VjLLYYDiTPP7WDKdtXf/WpkSqRdr2q4G8sJ8sege0PFd3aIFJRQyrFO9jkw
	utZbRqZL092xcXtxMZOH+/ewIcIfZCQ9cz6CtxYychtj1MXCK0aowlQZ70H0PxEP3qKaPh
	0pQ/vdmeUZ+5H22DI44WW0OXHUKJGD01gjKk2ZrFmAteWKcbQNC64kTHY/GkLk4ieZELOX
	OMTdoMzXCfBHlLfx4WZMNxvYi3Obh5gsFLMF4Kxt9kGnRVe4bCtceF2hxhIl6YliUYE5/S
	+JD0On4xBuFnTWfNVYcPIHIhhVEQMguMpT9IKSNhAOxTF4X3m2rMsi1ltS6NAg==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
From: "Ricardo B. Marliere" <ricardo@marliere.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/112] 6.5.10-rc1 review
Message-ID: <ozrwtfpo2njf4qdojazb5jpqdpjqbqmcmh3akjpqbphvg5zwpt@l6e34jngmvef>
References: <20231031165901.318222981@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>

On 23/10/31 06:00PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.10 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Nov 2023 16:58:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No regressions to report on my system.

[    0.000000] Linux version 6.5.10-rc1+ (rbmarliere@debian) (Debian clang version 16.0.6 (16), GNU ld (GNU Binutils for Debian) 2.41) #10 SMP PREEMPT_DYNAMIC Wed Nov  1 08:08:55 -03 2023

Tested-by: Ricardo B. Marliere <ricardo@marliere.net>

Thank you,
-	Ricardo
