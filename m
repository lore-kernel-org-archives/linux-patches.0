Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9613EB0E7
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 13:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789304689; cv=none; b=HDV/qoLr+crfHd2anyUDe6vSHBZoqUijbpYyeSwhAeis5ixUm5jn/vTa+3Y55Q9cCiK80Zu/KQ2GAjMjFTheQ8ZFYsmuYtD0fhK2jmBniwOFpAYcg2TjIb+2yY+JooJ5vS4dtL6FY7lt1dDh710y2U4Ix5c1vMmEXNo0dn+AOR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789304689; c=relaxed/simple;
	bh=BN+LCmYTlQ7QRUUr/X/TkpZUcB+cbrrZNxjtaiHYttM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LSHFHWprzlxzzrvPozOA1Aaze0j+lGV89w8EJp7HCi2HcQDETLnbiRQDbUW2g6rqRNX23ElbZGjQEPtNXuAlGPktAAo++6Oqqyfaw+FFsOGPahoj1By7xNan9kI7flgG2Cx8jgBqBXtf1SzUKwV38PhMjzsGbk1nNwyCoDQzFuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=T1uxbt5G; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="T1uxbt5G"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4hjT5L6PXKzKp2P;
	Sun, 13 Sep 2026 15:04:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1789304678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A7omPkq/GEt3RWx+PUwe6C3e6zmtx+VVdL4qPMq8VkA=;
	b=T1uxbt5GaxNDxeO48kC7xTz5RYiENgt2wc581Ak35Ks/TxF5XoRyWhI+aGkgaH3XyR8SDv
	kdPSko5kDMw26KX33/SuDfQ+SqopYio8Aj1BE/fSyqvAVp4/5CyOVSmmStH5sRINQRFezD
	KVLdogVc5qailuMZEwkLaONpRkzSXyNzP6gGKUHPooUdpvyx1GOvB+D0SN75PRL+KbY7fl
	Uw1APy3Thjk/w74EPY/vhEdCtO+XsbQct7gRo39U8dUmIkYURvgtTAmn+5CQQAWxPOOU7N
	53suuNGA6KKg1A/1jR4Iwjm/i+KsTxMD9CpobZ+YH7ZR34VjFs31fJArD1CjBw==
Date: Sun, 13 Sep 2026 15:04:32 +0200
From: Benjamin Boortz <bennib@mailbox.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.2 0000/1815] 7.2.6-rc1 review
Message-ID: <aqafOCD5Jo5knwPB@bb-82jq>
References: <20260912065648.999753832@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
X-MBO-RS-META: h4z554icxbd3h7idfxdd7hx8xpxniii9
X-MBO-RS-ID: 9a7677f3c588cff4b4b

On Sat, Sep 12, 2026 at 08:29:10AM +0200, Greg Kroah-Hartman wrote:

>This is the start of the stable review cycle for the 7.2.6 release.
>There are 1815 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let me know.

Build and boot tested with QEMU for x86_64, i386, arm64, and riscv
across multiple configurations, and boots on AMD Ryzen 7 5800H.
No regressions observed.

Tested-by: Benjamin Boortz <bennib@mailbox.org>
