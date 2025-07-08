Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D982E6131
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 17:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995440; cv=none; b=YcoOYLzk77SF6El8ACEavOTgybUDNDaKZZK0jJbeP/yqdMnwugT575jcFi06g6UohfwykxKt1h6QLJbU5bvJDXft6SLtrP+47oIKAQjIYEBNYdlipV8RCBqGuzDjipTJpJGkJpBYgeNgSsZVfbSOYaWgrKLWJ7dH/EOQqzY8iLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995440; c=relaxed/simple;
	bh=FY31zHYi8emkhgcdjvkzMSW74VcQ8ljIfVEX+OzkNZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jguj4IrlatjMd4GK9W/zd+m2sSUGXnAnw9PcQAEn5VnG/6mCOa+q49VMBU84F0vQj0S3p+a7M1MHCqPSowS1/l49wxAnnxWs6dvwkJQ9b3dkbnGJxpHpf6iNOb+WE7OdnaWRtBHk+0HMFeyJ8Y67phpousjB14jEOI1y6EXeH+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Y6JBlOFk; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Y6JBlOFk"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 73B1440E021D;
	Tue,  8 Jul 2025 17:23:55 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id YJju1TIK55oj; Tue,  8 Jul 2025 17:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1751995430; bh=DDciVo4dZIhYvTqDSCSNwmpmxcoETN4xI226KLR7z3g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y6JBlOFkFzSvrdczOgVTVc1c6Xuuc4goxaKaFH3W6xqWBTMV6w/n8NaywwB+hTtex
	 WYxQrR4dbGyDAKRgWZOCUVbTman/AK8Sl96yRJzDIrQn1Y4SMIbYIZTemtzMzuSdRv
	 mgu+E9y1v8vywWkaAKo2BXyLeW43PwRPXrZ7cPawM5J+RKhIO5DK0Lo+0dMet55INT
	 H1vUpzh2L/XaxEz64q4RAcQlI8C1DoIbpOO3pqPuduDI0I4APlj5XhMuP9j3+8dqyY
	 eGWLH2n7tz3vS0fSKtsr1Eo3Cc6LJQt0J4XDr2Uzvy1lY+gOuYH9pPOFeSnVd9OUGY
	 /GXE5/O0pJGDWgSeaF3vZlLjWXJAbI2dBTQjpyO4Ocyrv2R9mJkI7QFCV+YgOmhCNP
	 f5GPu+OBRjsNmZdCecv9snO+lQy12MwVrTwVaj+TcEB/sibjY71FNqrc5gfFO3OCXx
	 0+vNUvEy9PSNvvURy44ClSYcB5hZUBUEDg73arAHqUiaXqOYZM85x+AnoiCqVH2U36
	 azdyLEH4z3c+0b55P9AmRGHfTkGm0yZmdHV93saGgTcx5bQTr8FeBmM4YuqueJrudN
	 A+/NpuQQ1HAILdrBlifOenRIC0nBHkt2nIczdyskAcpH/GkFECn0vVNzUnje0OnxVo
	 H0f/DWOSTrxnD9RD/ugQuRhI=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6596640E021C;
	Tue,  8 Jul 2025 17:23:29 +0000 (UTC)
Date: Tue, 8 Jul 2025 19:23:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	Kim Phillips <kim.phillips@amd.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/160] 5.15.187-rc1 review
Message-ID: <20250708172319.GEaG1UB5x3BffeL9VW@fat_crate.local>
References: <20250708162231.503362020@linuxfoundation.org>
 <2438aa80-091d-4668-90e0-fb75f3e0b699@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2438aa80-091d-4668-90e0-fb75f3e0b699@gmail.com>

On Tue, Jul 08, 2025 at 10:20:01AM -0700, Florian Fainelli wrote:
> The ARM 32-bit kernel fails to build with:

Can you give .config pls?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
