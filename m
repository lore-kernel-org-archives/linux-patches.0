Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756DF156862
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 12:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721822450; cv=none; b=it2Enz7BPJqZAOsRdsDI8eeMUlsh63IrYmf4wASE7GXA8Un2GwmKwVkadsoTbM3vMCrzczuzoEvwbMljztHteayHk8D7zytQrS6E1jxKjN9nDlAYRG2LLPUTeIq7oSwXEN15qCRtpFXZ5d3NpjhSUOsyUnbLiJKQqn3e7/iS0jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721822450; c=relaxed/simple;
	bh=ARLkQ9XjuW/sdIZVYSLMjO3/Brz1hGee5E3ABOheFTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G9QWLiTTnmI57mKLP/8BVhZlsBwtkpwJegjYtECZGXTmnw9W5hue6tvpL9R5mVusBqXkEUTviSQxOv9KmOBXV1UH/pYId6+tM9/iD45e6Vj8dgJWTAR46vBckb2e6FTwsIOImYWL5h1j3nCKax4ZBRoSGGm6J4Zpct6yyCRkCu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heitbaum.com; spf=pass smtp.mailfrom=heitbaum.com; dkim=pass (1024-bit key) header.d=heitbaum.com header.i=@heitbaum.com header.b=LPE1iPmm; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=heitbaum.com header.i=@heitbaum.com header.b="LPE1iPmm"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-7a115c427f1so1210351a12.0
        for <patches@lists.linux.dev>; Wed, 24 Jul 2024 05:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1721822446; x=1722427246; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QiwB4GQfBTgHC/AKNShPIPrSgCPO81S3+a71ysnwoBs=;
        b=LPE1iPmmKyBU9nP767zXq8GxhzNk3tAxZSnotZKlmhlsXMNAfcGlWuyF0hbBRfPOSl
         tiZkMG7f9IgLdKCsec+ysmzR9sRVwwLXSpBPa5Im4T3eFHBDZ2s1rOoDOZrrj0rOJ9OB
         ywDqU5GWdKkBp9vEL8Hor9JjRHFRrblFH+/jA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721822446; x=1722427246;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QiwB4GQfBTgHC/AKNShPIPrSgCPO81S3+a71ysnwoBs=;
        b=n7iXTljKYOzYNQZeZP+cMI7QhqYkPxyTwXwCz+Mm70wOuJ3cgVp7+vKCh3gsJgXRX5
         lTMkopfmztOGN1NMathDjZTlosmG3jw9bnbN2tiYLdlho6eUqAZ1Oy7PDw2Zj6DQasPI
         Po7OYkaT4uw+FQPk5jnJ5pFCrk3if03jlTLIGlSY/a+QJotiIIli3szIM5LOpb5519s5
         sLxXM8cjaDnNxMdQc3Ik1JIgQLAOeVLxWSE5ZQi7KM7e6NTtc3kOck49YHL1WJdzTL+z
         EHHdrsaXpko1yI8NrF0SKO9Zy+Y/UDV9IZPsXDiXIKXH/AFex/3RIt/OyFbGsrZInyOv
         bTJg==
X-Forwarded-Encrypted: i=1; AJvYcCVlzxDSjxSDGiqNPBZ1UqjMAupO4LvL4plLzC85lOvueoOwuLorJ3VU3VbsxT1B+xCMAyBIvQ8rT1GoR4zRUvGQNFgTVZY+uA==
X-Gm-Message-State: AOJu0Yw9PaunqquD4f42ldoNR0v9vC94AuSPIn7orOebHotFV35Cflg2
	+AuRDr3kccqfscwUgNEs5OF1bzuFwqP+2ZQSIUC1RAx708O1sz4gm/WXobJNn0I=
X-Google-Smtp-Source: AGHT+IFhKhVhIQu+7EUnE6JTQdP/zpTXnTCM2skGxc7+KC+bmZ1mOa01+8QMHHJXhssZm00E2QlUPg==
X-Received: by 2002:a05:6a20:7fa8:b0:1c2:8949:5ba1 with SMTP id adf61e73a8af0-1c45e799ba6mr3044095637.53.1721822444230;
        Wed, 24 Jul 2024 05:00:44 -0700 (PDT)
Received: from 928c5557b914 ([122.199.11.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70d2245f052sm5405193b3a.159.2024.07.24.05.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 05:00:43 -0700 (PDT)
Date: Wed, 24 Jul 2024 12:00:35 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 00/11] 6.10.1-rc2 review
Message-ID: <ZqDs46wpHhfUUX95@928c5557b914>
References: <20240723122838.406690588@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240723122838.406690588@linuxfoundation.org>

On Tue, Jul 23, 2024 at 02:28:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.1 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jul 2024 12:28:30 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.10.1-rc2 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi 
