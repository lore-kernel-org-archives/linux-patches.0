Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA722F12AC
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 06:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780900256; cv=none; b=h5NA6pSXJp4+F+bBJVMlaPnXT895fqsoqNxnu21iP/VfaRihXwIxo8PIYOVdUscj/V5c290jbhE2jJNEca8QBo8cPErqDR4kOrH4j5r0+nJVJOGHc6zswkHS+ZmtkBRijj0FF8n5s6HWTM8NWDTMGLTA0z22sWCJzTotdD20F+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780900256; c=relaxed/simple;
	bh=PmTj2ntYlT0hFTsceg3H+NF3uQVcrK8SzQw4KCBituo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=imH5K/sppctrH2fxQssY0qQ3SxVgkwucucYYi4jQ4qJWC3Ht5N73UZ/eHk49OGzf34jGVoZO9grqAZaUqVzVCYTJQisqibMWxaVRuPCkgukbKBKnU5Neuvk3Gui730B7s9Ku2nKzLs9QR9AozQLqVZlCnn38063gqCHeQ58zoC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=Kjw/Ui50; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="Kjw/Ui50"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id 469C11F92A;
	Mon,  8 Jun 2026 08:30:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1780900244;
	bh=f4vlcejmN+4pqyqSMq9klPgT89unpijOOfOwM67ow4A=; h=From:To:Subject;
	b=Kjw/Ui50l1fYNROPB2HfdBMHcMKbNUdFYl1BCY0mEIhvXyrlDTIPVbuKYv98cR9Ro
	 9Lefp0KF/CySG1hqafoXRM6cADu5/ljUi5RyuuQw1mYHGuVSIAz3Pa+yShuF0DZJNa
	 lLTd96dWIiuTCg1bLK58LqaZ/xqmA0pl5ZVF6rOmh5DYAMSoBk+a93Cdk/OVfmwG2f
	 UACHZRI/JQVpD683HUmzUv9EuirYBlf2yu+x7bTPn9UqQyx8hezNFEnrrvCRROLK+2
	 AI628OugaW4Nr/pD3fPLU2LUVHmQh8A9YdQHBrbIT1LEWL8tko04ntTbgyRCisbhNE
	 gkzKYhPyCvnUA==
Date: Mon, 8 Jun 2026 08:30:40 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/307] 6.12.93-rc1 review
Message-ID: <20260608063040.GA11711@francesco-nb>
References: <20260607095727.647295505@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>

On Sun, Jun 07, 2026 at 11:56:37AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.93 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

