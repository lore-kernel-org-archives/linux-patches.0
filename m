Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A093B27FF
	for <patches@lists.linux.dev>; Tue,  5 May 2026 04:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777956935; cv=none; b=MFlBf6/LT0o24BL0pEIUEdUpIEN+GOu6WlmXqKqQZmoFya1msJTqadyHc2hffJld81Dv5Smcxbzp5/m2Ts10lXkmGyit7ox/lNq0DlKt/GBB0HyxIPgzrDJVtATIHVUXNafxO+MFyYoiuc9dXgtvswV+xxBiwEkfVhsCvsMQLr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777956935; c=relaxed/simple;
	bh=l3ZY0xZux9Q1HvWi2sHUzTcTUS1zuFCOJkABS+gmnH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jzsIoqpjEMKAooCbHOwNw4yNPxS+3sNtq1pVtS1wC4WQd2cYKW35kPJFFSs1Zg7gVRO0yHFUScz+jqb2Ikr87aX7regaEpXNaQ2y+/1YRu7COlLLdPjlVFrG0x4CuSpBh/nWRor4iVzVbdjHb3J6OEceqFYevApW4rAuc7zgCqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=olvMa/Pc; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="olvMa/Pc"
Received: from francesco-nb (93-38-224-205.ip72.fastwebnet.it [93.38.224.205])
	by mail11.truemail.it (Postfix) with ESMTPA id 9073725542;
	Tue,  5 May 2026 06:55:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1777956924;
	bh=mO1TMsnvzR5lhmOyZ4mTG7H0z9kzmib0UoUE3JUq9ow=; h=From:To:Subject;
	b=olvMa/PcGYmVTtqeLB9P3gmhXjDWJA2KI54qn49NBbgQXJU6y/ODsCO9Yo6DybPa5
	 twph//4Pxfv/MZonY2U/+t4RUFrQKlcl+OQUjcDZU6SfpNXa4EY36RPCYa1kt4L8ch
	 MA9Dh6XASAi77cgJZAeN7BRbBskkmxNktPqU9RAah3SXqYoyLHdKLmQ0iPKrD7Jqsd
	 PCk98Isy57gLbE2ZyBExr0IJ8hUq7viyHB4K5vRSCyZSjS0qHnrUY/bWkjZyN5gYqk
	 W1sYQcbGZ9kIRCDb6C0P0CZt25JPpR27SqGcQgG/D1ZdsIrXhd+E2RXdRb9J3aQm1z
	 enmoTVee1d0wQ==
Date: Tue, 5 May 2026 06:55:17 +0200
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
Subject: Re: [PATCH 6.12 000/215] 6.12.86-rc1 review
Message-ID: <20260505045517.GA5559@francesco-nb>
References: <20260504135130.169210693@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>

On Mon, May 04, 2026 at 03:50:19PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.86 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

Francesco
