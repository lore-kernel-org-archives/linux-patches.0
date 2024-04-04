Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996901B7F4
	for <patches@lists.linux.dev>; Thu,  4 Apr 2024 09:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712224572; cv=none; b=vErvpdZR1L1UgLTT+mjCPLTDQEjnmwY/f3teksk1BGNRSNrwPEBNLWMST9VV1qXgJqtRMGLtA/9doMR8Fgvg7Y4RET9wh7gWVecQoVmGUxHUKz9Tv3+WzG/xCjMmIfCIkL9nV9Qln8+etS/8qbelndJoinxNYL7SOCGc7oiWBwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712224572; c=relaxed/simple;
	bh=rFOMEeE9wjKXL12KHdSVVyEFH3wl2lY0KudiodUN+AA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aBnjwr+ulpHVNsapUHZlP9ufPy3fn5+Tn4EIGnZXFzJOerWG8Byf1U6I3D80TcNXHux4EzxpVb8ml3M2/UhENm3orbEQH8d8yVmPixPvRGGsUND2y3L/RdvsrvUz5jj1MjcYg/Ojeix24z6GeFa3RrC85EggikY7KdypW1OcnR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=fCIEXTKC; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="fCIEXTKC"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E4CC740E0192;
	Thu,  4 Apr 2024 09:56:06 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 88DGYgZI1WEY; Thu,  4 Apr 2024 09:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1712224559; bh=VeSMHN7V6xVF3g/+m3obfaXDgxbH2JgeuMTx+4wfz2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fCIEXTKCVZK6f3pIrR0bTlknkyQUQgRJDvpHllMBqhJRzctUsC97Pl6Rc3T1tja2/
	 UG/vSQY3xVb6dupyfEVmhHqEa6qcAj6z46C8/DooWu+HMDa0dMJ6xw2Si9NRl2V6RR
	 YA87Hqgsro4Si46ndoXNF3nXlsDqVTu16nzvLuBv0qebKQRKe5dtNk0o59Acytkvxc
	 m0sNETncGJSsxQzLOjcw4SSzm0ScCFP3h2NANUGv3PpQ0TnEjpS1nRS5EvOwy+IV6E
	 lPQvVQOerl2zRw8TUzKW+rt44WM5414O1p+a5WZAsAMR+16oK//61MLmr8g1fl1xnI
	 8s4qv90XXuD8fyUFqTrfVsiXeqnXZRrGLacOrBNzcLRSa/PDtFPCRQ8V6kd5p2shTt
	 TDnoeLT1ijF46q2T9Nm6yC6x/2mxxvAxHMV6ImlVAZBKnsc7JGq6WesrWj/Tt+2/ey
	 vq1Z/rGZ6kcfuWxLvhJ1WFXsXXgqVkslsn+FxrC294jzK43SxwgbWPKQNZKwlLc4Pe
	 IvVwJxTnwcEW9sviNW1uWSz2B3SOxOl19xCuG6ScmHE5XO+KKPFTA8O2MqpPcGCiYG
	 YqFA51o/vLa1WMXFR8RneLoCq7kRf3Q/qS+xmtQLNASTRB8/wwWu/tTva0tC/X6mKf
	 5Fb1RpKLNmDK5UdX7xk61lqA=
Received: from zn.tnic (p5de8ecf7.dip0.t-ipconnect.de [93.232.236.247])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A412840E00F4;
	Thu,  4 Apr 2024 09:55:52 +0000 (UTC)
Date: Thu, 4 Apr 2024 11:55:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Ingo Molnar <mingo@kernel.org>,
	stable@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6.8 387/399] x86/bugs: Fix the SRSO mitigation on Zen3/4
Message-ID: <20240404095547.GBZg55I3pwv8pttxHX@fat_crate.local>
References: <20240401152549.131030308@linuxfoundation.org>
 <20240401152600.724360931@linuxfoundation.org>
 <87v84xjw5c.fsf@turtle.gmx.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87v84xjw5c.fsf@turtle.gmx.de>

On Thu, Apr 04, 2024 at 11:48:47AM +0200, Sven Joachim wrote:
> On 2024-04-01 17:45 +0200, Greg Kroah-Hartman wrote:
> 
> > 6.8-stable review patch.  If anyone has any objections, please let me know.
> 
> Did not test the release candidate, but noticed that the build failed in
> both 6.8.3 and 6.7.12.  I have not tested other kernels yet.

https://lore.kernel.org/r/20240403170534.GHZg2MXmwFRv-x8usY@fat_crate.local

Once Linus commits it, I'll backport it.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
