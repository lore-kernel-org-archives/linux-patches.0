Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81122E54D1;
	Mon,  2 Mar 2026 19:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772480811; cv=none; b=IshJLn+U1+5U9dpZDmGI1BiYmznbm8/uJoYt8C+kEmgZ47e74HrdZZDPkcHoh8ZSyC+G82mjE2Uz41UZLPt+d1tZ0rq8A/VH1VOunl0xRVDWQWgNUhAOZv3CAhDWsNQMzQo31+YOy3YFROvB589Nghlzjr/FmH5Kbsq4tdsO5ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772480811; c=relaxed/simple;
	bh=YnvBRQ4D7WmIPP7Jo0M1C2cHWB/wmhg9ump9fzSpnbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J7lbLrbgaGGaNOrcHlWKvKtnEdPbBUf/Jmpg2QzpdSA8SZDABNFD+Ex9hKa82hMHDEordtnKFfaL0cvOgFYQLJ3BRNTHCaahyatyZKJe7fqcwSE7LW7YLU5peXuL7vYfCw2AMRr2WXuiilhFp4+LCa2+lBMUKcp8wPtndSY+JT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.211.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Date: Mon, 2 Mar 2026 19:46:39 +0000
From: Brett A C Sheffield <bacs@librecast.net>
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/533] 6.1.165-rc2 review
Message-ID: <aaXpH1EiNugoQwaD@auntie>
References: <20260302160943.2522184-1-sashal@kernel.org>
 <66461c13-1bb3-473c-b57f-adba9db4f756@googlemail.com>
 <aaXNiwFkUEy8SaTm@laps>
 <abe2fb5f-61b3-4597-b27b-c6c61f5efc7d@googlemail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <abe2fb5f-61b3-4597-b27b-c6c61f5efc7d@googlemail.com>

On 2026-03-02 18:57, Peter Schneider wrote:
> Am 02.03.2026 um 18:48 schrieb Sasha Levin:
> [...]
> 
> > I'll drop it and push the -rc2 branch again for all affected kernels.
> > 
> 
> Wouldn't it better to push a -rc3 branch then, so as to not create confusion? (I'm confused now... 🤔🙄)

Agreed. When we're in the middle of testing, please don't force-push over the
top. It makes a mess. I just spend quite a while retesting because suddenly my
branch was out of sync and I thought I'd broken something.

Once you've called it, keep it.

TBH it would make life a *lot* easier if RCs were properly tagged as such.

Cheers,

Brett
