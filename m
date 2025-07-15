Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8261DE896
	for <patches@lists.linux.dev>; Tue, 15 Jul 2025 16:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752596304; cv=none; b=W/3Tt4vQsuj0IkdbOFilMqZpYYpjuANujaWL1s7ZYrbMHHJX1XE6SUx1wy4mPnjfLuhD7ZDJXU8ZPI+QsnRk8qmIWYKz/xkYs14t6AWEOl61Abi+7lKXh2JDW3XrKjlOdmmRzQ0GlO+2BYsbAuqEzLWglk2Jlxb3maZEWMwcTCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752596304; c=relaxed/simple;
	bh=D5HM/AiGWG/RTIrmsdvX3PwrNmHErjS+CHkJMQ0huQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PjN70a5kSrF2CnA5kr4MJgO9KD12E9HC4IaGI8KADd7CxUyOMGBVXGQ3VGgsFrxiW/1O1mK1LU+dSZIyafiB1H1mDIAP++LUpahjhjskL9stOs1Kmj9fNSKRM3NepWNmlHbnhSUifZLrbGhTwnAEbYojSNdjw8LZpk7hGOtauNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=WAIJXAUq; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="WAIJXAUq"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0D27940E0216;
	Tue, 15 Jul 2025 16:18:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 41XEyuvr8gHt; Tue, 15 Jul 2025 16:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1752596289; bh=UlPD2gxshN4+pJ+n/7OKMBy7g/CUTL5Hksgcd75C7NE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WAIJXAUq/gBy46D24YV8knOe076giX6OAcIhWoh92MR6CdW+eDJtMcxVNmy6I3JSU
	 fIva34alkie1hg3lrGvbKihch24EVpSCdXpH6sDw5VZYp1BL/13g0hDB79zBnU0jZm
	 w00QoMUSTREwMA9BJS8k58U+3+tozRYGLGwQxl204lEka2JYn3LMnio5mgvCwT3X9K
	 nuhfXUzWFloSavsVpfILV0niyGWokW7idn2Z96aU37/wHCs2iXYk2xe38hl+kkN27M
	 8Ht3HndDp/hLQzzB8NootWCfXQrObflrIK8rpNhMTm2nUGn7ekC6Sv81TzvmbEy9W2
	 rQCbm1djP2JHwYEwfSbfU22vD28n+S7+kQgBgnwgv8nrilcwHAMs1N0QJEB4eC94c0
	 ZNAZ1TtbedXWcer3RKgizL9JZ8RvCBgM7aJNZ9JnlMa6wPV6K9nJrZ2/hD2JY1D24f
	 h8PfKnM50tGeVIuF7PEmC2oT8b/F5oCsiQ4eGWMsdNrtYe4doFSCJ5I1TaZ6LW3R3r
	 glQ1dfE6H/0BLd3Yn9gAD8gX3sGZTVJbHHkBSdROi1b0Fql/RXA+h87vAF8QbXN8/3
	 1OQrGlkq/BZoD0nr16czmX0G7XbBMK268y5ySHtlIvQFevcCx86wFQafSIHIJMpnmJ
	 xMlXSJLx/0ssoHsAuVydt5xw=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6002B40E0213;
	Tue, 15 Jul 2025 16:17:43 +0000 (UTC)
Date: Tue, 15 Jul 2025 18:17:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Borislav Petkov <bp@kernel.org>,
	Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH 5.10 000/208] 5.10.240-rc1 review
Message-ID: <20250715161742.GDaHZ_JtZlaAWUYsE5@fat_crate.local>
References: <20250715130810.830580412@linuxfoundation.org>
 <CA+G9fYugxp3W1-0Q2QNruE9r_a65M0gaE=1bgb-q+JS5GogAfg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+G9fYugxp3W1-0Q2QNruE9r_a65M0gaE=1bgb-q+JS5GogAfg@mail.gmail.com>

On Tue, Jul 15, 2025 at 09:20:00PM +0530, Naresh Kamboju wrote:
> aarch64-linux-gnu-ld: drivers/base/cpu.o:(.data+0x178): undefined
> reference to `cpu_show_tsa'
> make[1]: *** [Makefile:1226: vmlinux] Error 1

This is fixed in -rc2.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
