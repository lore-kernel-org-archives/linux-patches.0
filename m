Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A522E36E0
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 17:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751996744; cv=none; b=apy/PD+PyTgkgEdtdN4WKltmTfDpg8q9zKRuxPueyUaubKRGHcv6B26hq+lYOuLKEUtwWb9YIvPb4C9k5EgiKBkFK+qcrZ6QEHl/Lrng085gemKF2OgXU5ZQIjHrCXqrQx3ipAIYSACHGXp1+tAoRYed/3fL4aeZSTMnlwIPmus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751996744; c=relaxed/simple;
	bh=ITeoYUUoWtvVZM0zk10CwzY4y1MQvJIazCo3oHdGdL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xz2c2E9KgstKmMeIud99Ur4TlxDsHzfanuBQUrAuQPMeZL/3fxP7J++j0aAZfzk9sN6KBS6K/Qb7Q9cB4lLoYUpUGf3DoHFSxtaHXSkaZl/K5ibgmY3ytFf7yHqd/eDkyX49q2a9VCqit+RS6odPqfS+cPD6OQdaUPMzUddKDYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=J2Px3hV4; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="J2Px3hV4"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id ED63340E0213;
	Tue,  8 Jul 2025 17:45:39 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id zKPvNUUkjC3s; Tue,  8 Jul 2025 17:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1751996736; bh=iUaCpOtckmpEcP+qmeD5+mnA5zpSuY1P8qu24w8soo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J2Px3hV4FoPJiMME3Keu0WsUOJwar7h+LbUJjlJFJiBI0Hv9thRKg5jSzuEZwBpQJ
	 STqAs74K97aq986MhYDryVIfXigj8vlX2ZebXc019D7jR7I1XsJKTmgcqd5XlGZu/j
	 tFOgLsCNWO8fkvYxRstva16aP9bxj3VrBomoFa14D0qB/5tqUZss/jIqFWkGE/JMV+
	 Ildcb5PXg25uQ0Z5lI8ywryBWh9Tx7xtZrZo9Po0D++0P+pU9izNBr0ReunG0xzyOm
	 sPKJCs/zne8P1c638PV6o5XYA2pTH3bN3ndzWNRrqOVGx48DboWeatTUOg9/U6TeBE
	 K83j8G7IKSqHdROB3xGlTBEsmkK1x3N3ZpHPvop5aeeTHVF5a20rupqzIwBk+nkVNt
	 b7OzMQL7h6UhmuhYXrbB/Oozkkbb52LUM1mYSDvc/h9Qu/dY47FDst/iA/46Iz0xLh
	 cT35/plf00Yaqccufrr8bZJ/fOohuXeX/f1Q1z5ofnHL+kQzIkFIzJk814MrsTix3z
	 i7yb2di+DVVZiT1rVxB2wEvtSYzftoBHqHs1C1idL0t8u9o7qp36C8f8RYyZ+bY5RD
	 QhxUIAJRh/IruuDpQk1ucTYuBWYnsa7JzLsG466JN1RVT326RzVH6c5F6M8b2Ik9Ch
	 zatt7BMPL1M6I4QGj6sUvq84=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6FBA540E021A;
	Tue,  8 Jul 2025 17:45:15 +0000 (UTC)
Date: Tue, 8 Jul 2025 19:45:09 +0200
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
Message-ID: <20250708174509.GGaG1ZJSHsChiURgHW@fat_crate.local>
References: <20250708162231.503362020@linuxfoundation.org>
 <2438aa80-091d-4668-90e0-fb75f3e0b699@gmail.com>
 <20250708172319.GEaG1UB5x3BffeL9VW@fat_crate.local>
 <12b05333-69c2-42b7-89ea-d414ea14eca0@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <12b05333-69c2-42b7-89ea-d414ea14eca0@gmail.com>

On Tue, Jul 08, 2025 at 10:26:56AM -0700, Florian Fainelli wrote:
> On 7/8/25 10:23, Borislav Petkov wrote:
> > On Tue, Jul 08, 2025 at 10:20:01AM -0700, Florian Fainelli wrote:
> > > The ARM 32-bit kernel fails to build with:
> > 
> > Can you give .config pls?
> > 
> 
> Sure, here it is:
> 
> https://gist.github.com/ffainelli/2319e6857247796f0a9bd99c5fe6e211
> 
> FWIW, I also have the same build failure on 6.1.

Right, it needs the __weak functions - this is solved differently on newer
kernels. Lemme send updated patches.

---

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 2c8e98532310..0e7f7f54665d 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -601,6 +601,11 @@ ssize_t __weak cpu_show_indirect_target_selection(struct device *dev,
 	return sysfs_emit(buf, "Not affected\n");
 }
 
+ssize_t __weak cpu_show_tsa(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "Not affected\n");
+}
+
 static DEVICE_ATTR(meltdown, 0444, cpu_show_meltdown, NULL);
 static DEVICE_ATTR(spectre_v1, 0444, cpu_show_spectre_v1, NULL);
 static DEVICE_ATTR(spectre_v2, 0444, cpu_show_spectre_v2, NULL);

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
