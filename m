Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA030364EAF
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 18:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788200112; cv=none; b=cs9L7zf45jjLL15Squq1oRZurgtwOos9aJDjkZVn2zk1WQpXkHQVu7M/ZAePhaVJP6s9m4T81ceQCDxYem7ZVKRgpQse/mx+olNDXmaT+fFliQMUJSeeWBAHgPuDcK2fLcaHGHl16N8JSVGzhevPYNs58HQiZsazNNWd1YopqlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788200112; c=relaxed/simple;
	bh=E1qN9DH8Ee4RdtW5tvDpU6m23+dulZWUA/HYxpmaacY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iUu0ULePhJCtbsw1SLcAp2Jz+mYmvdVc7giPr0pZqckqGkk8hgfzk9/AS8XMrn/k9TZMVCuDHcXHIuSCTcBHIw1jSDI2GdjuzqTRTnzUj33WSkTovDks7aPWFHeKG7Or+Ki/G76DHMD61gsfAT6KxRKjVLnlyrKSUbDsTqoKS7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=vxj4dT32; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="vxj4dT32"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id A505A1F95D;
	Mon, 31 Aug 2026 20:15:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1788200105;
	bh=54DWobeU3TiYUqKhR2D+PC/HtPzaoe/TNQkclMgxpHU=; h=From:To:Subject;
	b=vxj4dT32+J9U9+Dhlu1sQaXOXTshZh6C1uijymEmdTbU0RmnsdvgptMw4IbcHKbX8
	 NhV0Au1d2P9IXjAt2U71ztX4V6P3q33WKhSrynjSedmNYK3DZPq6ueePx1Be+HHwfz
	 OG6gMzClo8+4Khn3jNqFnB1GJWQsh4UQ8kOIx9heO/emC000oSYbYW7Dm9/l29sqK7
	 Xa2qzp0/mo8u8ldYjiVWsLR/VGpr87zsND+vAkr2zphlHlsSmwmoTinqXKMPsfCHz8
	 1vi+BRL04Z0Ps85J7k0I8G++J7zN8CfPmEnQCIjK7dSeBS7C4xhwPick3dID3a2ob3
	 Lh5X1mlMtAvXw==
Date: Mon, 31 Aug 2026 20:15:00 +0200
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
Subject: Re: [PATCH 6.12 00/99] 6.12.108-rc1 review
Message-ID: <20260831181500.GA124452@francesco-nb>
References: <20260831133359.740409777@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>

On Mon, Aug 31, 2026 at 03:33:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.108 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

