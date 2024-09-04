Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7721F1DB520
	for <patches@lists.linux.dev>; Wed,  4 Sep 2024 15:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725464032; cv=none; b=rlVQwesn3KozoBQgvhBFA0HSYIOnSVC9QyqPdZzpaIuYv8jYYU1c0LEVcu2WqBaT4ShOma2Dh2nqDH/b/dzLXNSP019eRBps529PBEtixi6ToNQnbq0jX+1ImhQKplM2rd//sl/E/ZIMG4uC2nlV28Ab/2u0lqrz8ZDmLJzBFD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725464032; c=relaxed/simple;
	bh=1khepDIiYxes/K6ima8khZA4PdSisVruBwmkxcY9G/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=buuZkOYvMFTAzDq1unx+qgQccu+SuEP47HzQbbmjbmS7O9lzdeAjS72TsZ8MerlKgsyjK2mIQ2r20bu++F4GoPo46bkgdEiXlha7kJE8JYNeAzfYI0+GFrDDjTamrOm23MWP7Cw2obPBxso6Nm2RSO7uKyMlwZ4A4LwjOJYIOjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=XJ/yXhRc; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="XJ/yXhRc"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5F0B840E0284;
	Wed,  4 Sep 2024 15:33:49 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4KlB30wnbXb1; Wed,  4 Sep 2024 15:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1725464025; bh=nKla2rrw8QnSN8ocMvJl7FBisgVHM7qzJ9tQjcz/CnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XJ/yXhRcuseBmUI/Bzbi2/o4h71le6xeHH6hq3J74vpXWa28nFH7HW0i+7LzTY1sx
	 vnrzxxQo9fmtS1hhMXp5TJWfeq8fU2zSl1rC+HWFZbQklAwhD4mWb9dQf3WLtVaVqt
	 yhRxhwUM77aZgV3X7WgDzeu31kswIBgd8Cr6/no/rnHdIfLejRo9cFzFLFHsWulT1T
	 2ds1gRRfwmShV6KvXDbnUOFjk8SFV1HiXPJ0v5qjBTd1BW8oJNTFMRlLm5qRNq0KLc
	 052OBlMYnzTwmhdm8upU379/YhId3UVWdOLOOGLuKvl4X9R3dZMIogh3oxtMjSUbEB
	 Yv8cUolqp5RIUdt5RpstC7t0DpY67b6i7LGjUAcuo31JoowKaT44mVeg/FwVrAAbxn
	 zAnlC49Doi7poeVQWM9EhOsYN/rBCO+xfwcEvTbY/RfUabrGGhdMUHOUrV5fjH73QS
	 AZJl4cn2P09WamfK9pLJZkkN7ccBAHXYrYatAYwELIL18Hdoki7/p3bHOPeRDXOqd3
	 0Sw04AzKllleVqh+ZrM6LKwKeYevFSy/QSanJFmdCsRTgsK1fZ7cJ2FeMQJ5FGrnHX
	 gbWoPxeHwLB2Oq7unQAoP5YZNXFwnfggdkXq0sZNXvNRrIzS8wKXKYMKQiluwQcxJw
	 nqO9n739eb0Xw2YrgWjQkBTs=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5A9F040E0185;
	Wed,  4 Sep 2024 15:33:34 +0000 (UTC)
Date: Wed, 4 Sep 2024 17:33:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chanwoo Choi <chanwoo@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Chanwoo Choi <cw00.choi@samsung.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v8 1/3] extcon: axp288: Switch to new Intel CPU model
 defines
Message-ID: <20240904153333.GFZth9zY4_9ZkVsztt@fat_crate.local>
References: <20240903173443.7962-1-tony.luck@intel.com>
 <20240903173443.7962-2-tony.luck@intel.com>
 <d114d151-950b-49a7-8be5-19c1b8b15d7c@kernel.org>
 <20240904152420.GEZth7pPI4NKghUxUS@fat_crate.local>
 <28103118-911e-4b1a-9c76-2bd4ec7c830f@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <28103118-911e-4b1a-9c76-2bd4ec7c830f@kernel.org>

On Thu, Sep 05, 2024 at 12:30:13AM +0900, Chanwoo Choi wrote:
> OK. I'll remove it from extcon.git. 

Thx, lemme queue it through tip.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
