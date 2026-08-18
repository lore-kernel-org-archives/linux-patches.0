Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E71B433041
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 08:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787042801; cv=none; b=uknuJsm3KOAR7GS8IwKrqOVzb4fROhqWHp7PCqP5BSzYoe5GUUb1s7h/5mNb5FmJzwldC4A6D707kEnwm5wWSsfxcYhRWLDkGDow57fGYd9faHFV0VNuTCPUZu+u4g8oRNxLxb9Luvhenly0MJIEtsc7LegvWXNNy8OffQ+Q8Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787042801; c=relaxed/simple;
	bh=M8izG24LnQGmCzo4+uYgGE7QULV4MSRozrPno0jep3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GWaMz+k3f2uKS2j+UqU7x0CgF7kIY4qA5A9wXr7OwxjprE3GHkkPOSHSs7RFuymacAxCzMuLH0egSvGRT9Vu6slGtCqh2FF9I/O96gPggxCHWmzlA3enZwD6NAl8hsTkHGP1s/BbJYsi0Uq5xPTIIZqhsjVQXkur7oeoDPlCCxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=Ke7t7E/p; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="Ke7t7E/p"
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id DB1081F947;
	Tue, 18 Aug 2026 10:46:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1787042796;
	bh=LjyyxwqrhKohOvxrAA02yYe/zoSBe9XswAFfcxjNdFU=; h=From:To:Subject;
	b=Ke7t7E/p0w23jVPfLa5poOL09nPB/pyWD6FjlzP+UlazeqiLAH1Q2kROQgCO8ZLXr
	 xzPk1hpwwvVIbpxz6x++MxfA0ywbh2IPzhRwccQabDX91bJ+55fTvDulZMqXJFgO78
	 2OH3Fi74LHxEplVmK6EjY66IXqWt6iiySw6OG103sHasF6TcMF0cWuHFI10fJEMBLK
	 bvY8vFfbV+4LOe225n9R3HkeVyV/KxGKM55/gY7KhNhJGvj30JB1mxg0xd1Z3RvP/p
	 9oShjZF16hO+Bm9d1r6kmN/8NZZiLzx4UoFk5wv6M3ulxR4wT0j6YjbuJi+qLylIu7
	 CiBf5j/+WJGgw==
Date: Tue, 18 Aug 2026 10:46:34 +0200
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
Subject: Re: [PATCH 6.6 000/156] 6.6.152-rc1 review
Message-ID: <20260818084634.GB119228@francesco-nb>
References: <20260817132534.666299318@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>

On Mon, Aug 17, 2026 at 03:32:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.152 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

