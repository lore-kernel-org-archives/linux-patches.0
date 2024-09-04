Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F19B1CC16B
	for <patches@lists.linux.dev>; Wed,  4 Sep 2024 10:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725444837; cv=none; b=n/fCSrBENfKm9BCdXTWp9omMr/tlrPBHEU1A0HG9Zl2ljK0j+cReCJdUQLQadNBb6IHAr+Hw0FqWwyQv6aUwHOKsomVbxEF+NLzR0WkguAgBfrwxOHsvTNEKF1hNVJfJdEDZRmsahOdps5szqG5EdVKUoZxoCKtsjnbRQ4FrcyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725444837; c=relaxed/simple;
	bh=egu6KUuOUr3qxa89kLRUGMP2PnrU8/ncNgUmVSQHj9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r4xyLGaR2Q+QbSFvXwfKHu8Xa7ijXJxTIU1keHnKYoqu41gBxKDsOOwwTLSRdHPIwC3ZsnRzUQb5rEXqonYUN6L3fEmhKOfnbBZ5BG1r4C5lM+VTcAqnhhSAw5YhLvM0Oc7zwzXblTUxlT+gBL1uCKUVoq+aKlLSQmL3sDEBpQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=AJm9suZU; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="AJm9suZU"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 179A940E0275;
	Wed,  4 Sep 2024 10:13:52 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id W4tFNaA71j54; Wed,  4 Sep 2024 10:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1725444827; bh=a7o76Jb1YyH+cC7wR2ZXV5t2sUTN+Rmiomgx5u4Ts/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AJm9suZUI95dLDfDxaksIFdVpDbW3XFZXyCS2whPzpmjfeA7mbbFr4c5QaqiqmMCZ
	 3gj9tgjeI71/3aY90INJZWkkRf6Q/4whxOU5ob+B5CRKQmRk9pZ2yTc0DVZVBoyJLV
	 NBQmcu1ttmDb566ylWCTd6M+apEXEUo4qfK3fTHNeNHbYElxlwbdgf70UQvyt9TSF8
	 3YzAcPFf0TmTappp8UYnHP37bdYuRzatfT98Xu6sqNxud0km6cPpeHXf3TlPxgkyP4
	 ZdIYGMs/LRvVeEEB6/Qpa7WLnat6JbJ4KSW6PUSgIwYsIhqZVY/P//deSTlkt9CeQe
	 35nEQ+I1/4yYEuOFxYSSrYvomTiZ4H1o3GuwhqxqEIs5aje+xr+rB62hH7QWJGX4CW
	 e+vTWaxY7NHBoqKpEP8Cy4kNjMqiITwgYYSDk+9JGcY9aM94EuAYvoRT0e4Eal/Vyh
	 71/zB+Q0ydGp5YY4ZyLjIOPSHaF55kOAY5WRYoRvh7YzY3C5lcScRSjq91Xy5RZAFD
	 hHvl5WQCAcN+ESuwQZr1lVWS7UVVwrfFVRcRCh9ZDjLR0yAxdZehmHZEwj8m8jhbWs
	 t+Or26O4RZpJT7KvtCTIHDdjUv3AI7xJdfUA0wfYp+xpPCrcGFtFpgzMUGB8Jp0E1+
	 y6H7wDmNsvT6qVauJTwwJ0Qc=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 734A640E0198;
	Wed,  4 Sep 2024 10:13:37 +0000 (UTC)
Date: Wed, 4 Sep 2024 12:13:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v8 0/3] Final pieces of Intel new families support
Message-ID: <20240904101330.GAZtgyysjdKRJ9sBPj@fat_crate.local>
References: <20240903173443.7962-1-tony.luck@intel.com>
 <20240903192655.GCZtdi_w9xN6z9hPGV@fat_crate.local>
 <SJ1PR11MB60832E477464FFA09B248CE4FC932@SJ1PR11MB6083.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB60832E477464FFA09B248CE4FC932@SJ1PR11MB6083.namprd11.prod.outlook.com>

Chanwoo,

On Tue, Sep 03, 2024 at 07:43:35PM +0000, Luck, Tony wrote:
> >> All except one of the precursor patches were merged to Linus' tree
> >> in the v6.11 merge window. The exception is a one-liner that is in
> >> the maintainer tree and linux-next, but didn't get pulled this time.
> >
> > So when is Chanwoo planning on sending that one to Linus?
> 
> I don't know why it wasn't pulled.
> 
> > Or should he drop it and I pick up all three and finish this conversion?
> >
> > Hmmm.
> 
> That would be simplest at this point.

how about it?

How about you drop this patch from your tree and I take it with the other two
and send them to Linus now so that this conversion is done?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
