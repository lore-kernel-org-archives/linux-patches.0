Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C44548EBE8
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 12:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787314367; cv=none; b=Eqjn0i9dqyblxN1jes7IXyZVMtiVwvM0q5HhOBy56nkXaxmsMK9/VJDZJNBKTc4T/dmTapiDCTU0PzU4AFn/qL93v6IY887OgcVlr7N4fkqhmknR7SYfoS8C2VG9g5zV9cw+5M4peWpl+tQNtLETHO5rpii958O1wIXfTeLG3w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787314367; c=relaxed/simple;
	bh=Fik43ZyMz86ORTpLi/mtYF9rT9qzUW/D/BtWcXSDi+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hHXYbYZMAHvHf2UreSYIXobp7mrKxG2OiXEQn0Z93cj/wv6BYUJpS9d1dD2EjEAppdQ2tpzDRoSZ29HlRPJ6aiP8FHbexrRt7wR32F/f32CnNOu938gMYfXfFKvsZp4sK8BQNvvYVyRp1FQTV4fBfhruTinePrEh7kOQBQlzLtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=AsK2mqHO; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="AsK2mqHO"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id F0D0D1F81F;
	Fri, 21 Aug 2026 14:12:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1787314352;
	bh=/DjE9hdGmblHzNBD2IBtvxRFNYQbHBgwTgZi4wrp/Xo=; h=From:To:Subject;
	b=AsK2mqHOOvKI35Rq7OsO2FfkuRZH4gGN/EZb0v6EOZpCfUkudB4a8uzMraded1JD6
	 xP/H5B86J9M9KAu1wnOQ6fXlyLA/dTONmj/FlZMAURwW82cg1I4KqOBr/M0yot34Jr
	 a6Fhd5p8DDciyFAjyl5QC+LtLZWTEb4VpDoR5YR9NG0pyuEAhWquqPIghlSbGYziZc
	 FMqvwqjxhPrDQfyPS+V+ztiJP849j9gVCamcYA4yXq7KoeQdM4WadfKyltjy/wPlPO
	 JgqzYw3tZd5Yx5SofS2jiI26O7Vw7Z5NphqSTlUyv5VCx5avN9hlIEUo6uQUxVy4WQ
	 uYQsbBtcOFJJw==
Date: Fri, 21 Aug 2026 14:12:27 +0200
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
Subject: Re: [PATCH 6.1 000/303] 6.1.184-rc1 review
Message-ID: <20260821121227.GA69762@francesco-nb>
References: <20260820145253.200766705@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>

On Thu, Aug 20, 2026 at 04:52:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.184 release.
> There are 303 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

