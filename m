Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A4E336ECC
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 10:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772447975; cv=none; b=Z1a5AWGJG5NOwwkfzHEz60G5e/LgsTXTjevB8wRKatVrvP0eiEreLki3mmMt9KGCb5/4t+s1u70Jp030qTl+OgYb9EOdITtRa7q3kMr2bPKvHJwEF8UV6DxDsC9e7Gk+GRcQ0IcRtNtXRZfhba1dYKnRrstnu8kagMwlv5KTm1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772447975; c=relaxed/simple;
	bh=bbY9w/nPzFfuOSEqok+sgaFbOInyplZ/Ml3wdVmMFB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q+2b1r0hj8Tqx07LBCWGuwHnmcGf9NlbOF2q1BDYFtJeUZkraUB4qqn+8pg6gssKWt5pOmOURJPDqHqlbDn8THXkEjwdazYkdBTAIoQiVKk17jnC9Eo+tEf2ZH/rAAw6hQSnb9MDXXecUhVTJYx7F0mY+aycOdZJY/MMlk3QTtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=y9h/0DFa; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="y9h/0DFa"
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id 46B041FB1F;
	Mon,  2 Mar 2026 11:33:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1772447593;
	bh=Kgw7Uazedw77+KTnogmLm77W4uX+OeiOgtLH6wuCZDk=; h=From:To:Subject;
	b=y9h/0DFailGlKps8uWOdnOaHo9sbAMK76LO83mdLtNkg6CrwyihZUsghwOlSWqF1I
	 5QVIWExVPm5+1KVqL2/59cjz7jmtk64FBsfZeBm/k/nxe5ku6JLN7HrZwvOLHBc9V7
	 /gDWNyxbTmP8esGqOOR39jriR/OTLVP3yINJET4QiMbUc62kTRZrE9zxBibnGt7dHY
	 /2qC9TU3mswzNh6wpT74Dh9NkskQJFSbufg5u6pHioS1aeS7AhAiIWYhccodA1Aqwy
	 1KgdhfII8IYhS8TMgGFo7QWIrFGs4GrDNvVnhgvb9HpGbtu1TLS86ddiIUGh2sdbIr
	 8XAm16LrmkmNg==
Date: Mon, 2 Mar 2026 11:33:09 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/232] 6.1.165-rc1 review
Message-ID: <20260302103309.GA41413@francesco-nb>
References: <20260228181119.1592516-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260228181119.1592516-1-sashal@kernel.org>

On Sat, Feb 28, 2026 at 01:11:19PM -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.1.165 release.
> There are 232 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin iMX8MM
 - Verdin iMX8MP
 - Colibri iMX6
 - Colibri iMX6ULL
 - Colibri iMX7
 - Apalis iMX6

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

