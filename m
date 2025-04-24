Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1F64315C;
	Thu, 24 Apr 2025 15:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745508524; cv=none; b=czLOCSpFEIFWnBkq3z34i1nigDVvWps5UhUDZiqLm9FSdnqrn/vwgm3OxgT8uGyhLNim9mw6AFYkSCel5/4MB8xoC7aeG4KMjwQdtF1UQFfIbh457iERJVKwUS/+ZKL9f5noJyF2xKSMSflZEzSmWY2L1D3rdtMkacehFBDJ+E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745508524; c=relaxed/simple;
	bh=Euv6tom3fZIqVEpTEjRQbUyHhU+/a5Q3E4Z5AiMuBNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kj02iGamtPcQ9Jyvyw3BZyg61oEcJFvinIotyAVzXCLfTJKYHJ8gtusWtF/Kd6INfGmRTQNg45Ft+cRFVrlAuakubDV6grSd2dxHLF06o/0x42vlXuKBEWP2PQP6dXWGOtH5tyIzEwNanfkfSBnSnbCFNaRhYpkT03TRn1tkorI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GrxRqP8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GrxRqP8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6117CC4CEE3;
	Thu, 24 Apr 2025 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745508523;
	bh=Euv6tom3fZIqVEpTEjRQbUyHhU+/a5Q3E4Z5AiMuBNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GrxRqP8PlUoaiYbRXy4O7PJv2OfyiR2e4+i4zK0vKA+0iymFhjn9CPp5sM/mmx7WV
	 wfnMR8dDwpxcrrbOhWSbGV6i1SJ4+oKsrHiHwhZISaNczapcZR+6ODAW0ZSieSPvlZ
	 37Chbr+LQvH4/ttgnpq3ApNGBgp44iJca7zST2wc=
Date: Thu, 24 Apr 2025 17:28:41 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: He Zhe <zhe.he@windriver.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Guenter Roeck <linux@roeck-us.net>, shuah <shuah@kernel.org>,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	Pavel Machek <pavel@denx.de>, Jon Hunter <jonathanh@nvidia.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Slade Watkins <srw@sladewatkins.net>, rwarsow@gmx.de,
	Conor Dooley <conor@kernel.org>, hargar@microsoft.com,
	Mark Brown <broonie@kernel.org>, Netdev <netdev@vger.kernel.org>,
	clang-built-linux <llvm@lists.linux.dev>,
	Anders Roxell <anders.roxell@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Nathan Chancellor <nathan@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 6.1 000/291] 6.1.135-rc1 review
Message-ID: <2025042404-playhouse-manual-85bd@gregkh>
References: <20250423142624.409452181@linuxfoundation.org>
 <CA+G9fYu+FEZ-3ye30Hk2sk1+LFsw7iO5AHueUa9H1Ub=JO-k2g@mail.gmail.com>
 <2025042443-ibuprofen-scavenger-c4df@gregkh>
 <e77b24ce-e91b-4c90-82d6-0fa91fcce163@app.fastmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e77b24ce-e91b-4c90-82d6-0fa91fcce163@app.fastmail.com>

On Thu, Apr 24, 2025 at 04:34:04PM +0200, Arnd Bergmann wrote:
> On Thu, Apr 24, 2025, at 15:41, Greg Kroah-Hartman wrote:
> > On Thu, Apr 24, 2025 at 07:01:02PM +0530, Naresh Kamboju wrote:
> >> 
> >> ## Build error:
> >> net/sched/act_mirred.c:265:6: error: variable 'is_redirect' is used
> >> uninitialized whenever 'if' condition is true
> >> [-Werror,-Wsometimes-uninitialized]
> >>   265 |         if (unlikely(!(dev->flags & IFF_UP)) ||
> >> !netif_carrier_ok(dev)) {
> >>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> > Odd this isn't showing up in newer releases, as this is an old commit
> > and nothing has changed in this file since then (it showed up in 6.8.)
> >
> > Is there some follow-up commit somewhere that I'm missing that resolved
> > this issue?
> 
> I think the difference is commit 16085e48cb48 ("net/sched: act_mirred:
> Create function tcf_mirred_to_dev and improve readability") from 
> v6.8, which adds the initialization that 166c2c8a6a4d ("net/sched:
> act_mirred: don't override retval if we already lost the skb")
> relies on.

Ok, that didn't apply cleanly either, so I'm just going to drop this
backported patch and wait for the submitter to fix it up and resend it.

thanks,

greg k-h
