Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED0B3B2BA
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 01:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761182432; cv=none; b=TmQBPlZ7Myp5lDkBASbPX0pVNVaeQ0bRlraTOvbjM52m4bhMvF58xOHiWIrC4XvhBy2UHFWf33zRALAGW5nEjqjdftT4wKZJ2UbFWd5rAL/eTliJiOO05vd3dTo7Py/X9KAQMzAs5BkJ38RUny838vRMz6MX3YT0BxAajjlPBY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761182432; c=relaxed/simple;
	bh=HWeVzs4HkP0W/Y6HvJDuWMbx8SneTc7qsQZMtj9yvMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mrAsJMvBOgixZt5ZUqMxHutw+RV6AQHBgN0s8XH9d+kiOXoClnCorS53BW4YsFG5KygvEZqR0MNRQiI3NVw7etcUAxs8rA7fSbkERR+s/6EUsUBxWAEvlMs2T5F5LmP+2ditgmHsE7J4bEZKzsQamKhJwZsZsOV6QPde3nRvBEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=Sudk1bRo; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="Sudk1bRo"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2698384978dso1542525ad.0
        for <patches@lists.linux.dev>; Wed, 22 Oct 2025 18:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1761182429; x=1761787229; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8ijG+3nszibgNynLBA4c1V0LvvFa9+rH6/8ywIqIspo=;
        b=Sudk1bRo5AkLTPCNPK4LvYw3/O5CH/g+wzfE4VBrUFTXdDNaPLlwTK153nPtlzMnby
         D3GRA8PM/vlRt9Kn15HKrn4r5gLGrhJXVq13cLqMn61LRYC/8iRYYC0Du5kKBAJGWBbm
         /CIDIDVXTgvEF7z652qE2AwZHg0SYKhTkoAEQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761182429; x=1761787229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ijG+3nszibgNynLBA4c1V0LvvFa9+rH6/8ywIqIspo=;
        b=OtpuANwtfIMAnNXB71S19nfNxxE+do9VnKiIeA+F6KfLozPmngANNwu+pvwh9sedQ7
         ls0B7r0sTFfIBCwysbGeBs91RWYorMuijO2K5xu9x8ny6zct3zGTTCgjIZN3UOgqxqg/
         UU6wdcmHifNFoxk0O/9Knfmp1UWfO4dtfuBjd7d4eSVnHdINa+bz8n5l6CYYyLqlFB7M
         3ib52c48dIHuWPfmxhKyAVs3DvmykAP048EFZ/HNuvWJdrEGhrvvnxh1XnO9LVHd207R
         EqgzH8oFjPWSWj8TDR3BhV6pYNfg33AgRNWUIkgBd2LdPwBmfB49Lo2ZSbahg8H7+X+Q
         yV5g==
X-Forwarded-Encrypted: i=1; AJvYcCWs5ID8hQemM80q7wsUiHxjILjBw/nnV1u4GDfez03AYBKVBid2PgCq2r1YiVrUE2RowPD7rtWN@lists.linux.dev
X-Gm-Message-State: AOJu0YyvvAb7K7bKzIqOMuYWyt+xvPu9EQCvwZ19xb1bBzatnf0nODxn
	rE9xD7TpOFXBlZG8NVGkaLzYUhjfkAVnqDtDUftDu39e4NCdiiVwA2LGrhH5MjA91g==
X-Gm-Gg: ASbGncu/ZVUL4PNVV15UdEIHyYPAQyz6QktWfoOrkruhta+LYE/unzWXW9odjTGTgDM
	ZhsyQblSFGEDvM1YMFb1NnH5GkksMiSN2siCZL1LQbGFF9rerAct3yKJLaESgwphtA/DFaTru20
	BTwuIlsUom7vOmD1ggM/P2UPr7Otqx0Mz22Z7aKBfwWvJzmzTeCF3TJ3HRUkFEjp19gOSTJv7yX
	1LVk2Jb20zLiqGjNq4sQEloRLyA607EnwJbuf0N0Wp8/DNfCLvHdbl0UPNgoCsy7zQB4LksBfMd
	H11YizmpRG3+fWYsZ6ev+e+3f9om8lILQOH2hkAfwv0d8Ob+h6EA6+4a+ZxAqbu9p2xR99Pcu0K
	QpN1fhG5TV6RzbKsgXGAjMxMPIUqcxX466KexHuQ6iA6wUb+DiJ25HbvGnl0iwi3no000EdBqtE
	oophjhBDPDcbChnG4tPN3h9m9wzApoXVc=
X-Google-Smtp-Source: AGHT+IGqlsv2gN808APRt6SB8St16ScWc42axG4K0bEhdfrp2ymJT8G4ZPKTSW9b6iTHmmaAgcxKNA==
X-Received: by 2002:a17:902:d2c6:b0:290:c0d7:237e with SMTP id d9443c01a7336-290caf831cdmr329156695ad.39.1761182429389;
        Wed, 22 Oct 2025 18:20:29 -0700 (PDT)
Received: from fedora64.linuxtx.org ([216.147.124.76])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6cf4e4303dsm378640a12.37.2025.10.22.18.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 18:20:28 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 22 Oct 2025 19:20:25 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.17 000/160] 6.17.5-rc2 review
Message-ID: <aPmC2fnwdvffkc_B@fedora64.linuxtx.org>
References: <20251022053328.623411246@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022053328.623411246@linuxfoundation.org>

On Wed, Oct 22, 2025 at 07:34:14AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.5 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Oct 2025 05:33:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
