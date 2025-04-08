Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E58B2253B2;
	Tue,  8 Apr 2025 15:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744125580; cv=none; b=DDxy5WHozWpU661pQAAvc5LiSo6jChm327jbFns6nnRoG7XzQ3+ecfrNJNl6avrmlzg1cCs8yLiA0HbViuqjMtvEbuD+Oa6+ylxRc3P/QYZfhUPGOb069EG4OW+F0wJ5pdhFPSsl6EJgiTyfVqwERoSdfPDoL4091Y5JM5fKTcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744125580; c=relaxed/simple;
	bh=vxmSNKymLi8xbiLOcWiQzcEUPNJ7ESCvQ2P4jqjnbTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HtC5AJ/hkFT9aeXMUzPRwGx24PYirmPQcvkeMEE6AdL+WQtSLbRWbmiKB3JMv1F+P/CKUdauGhRI+QJ3d3lPOmwJYV7qbrvNybw4I0jk9LXTjdJLxMAKZH5LGm9DMSgt1UlqT4azbvonw4WBNNNhw+SjF2m+UCFHnwSKoUI1f08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffoQAeXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffoQAeXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60C9C4CEE9;
	Tue,  8 Apr 2025 15:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744125580;
	bh=vxmSNKymLi8xbiLOcWiQzcEUPNJ7ESCvQ2P4jqjnbTE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ffoQAeXwfy/rled9CfrSszOOpxiDOB1vZQ91L3ihVL9r6jPVQtPSnwB+W0RqzRaM1
	 6My0lHCBHuyhFd93t2XTBxGWS6cIaRmQUG0f7XHFudpBcpR1jnatC6jA+K9X+w0fBU
	 MAaiEMGIe/mikdHsOUU5AC84MyaXNF2S9WHiOpKI=
Date: Tue, 8 Apr 2025 17:18:01 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/423] 6.12.23-rc1 review
Message-ID: <2025040844-grueling-debatable-6f0f@gregkh>
References: <20250408104845.675475678@linuxfoundation.org>
 <37b6a9f3-9a64-40d7-9c69-5c09140ccddb@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37b6a9f3-9a64-40d7-9c69-5c09140ccddb@sirena.org.uk>

On Tue, Apr 08, 2025 at 04:02:46PM +0100, Mark Brown wrote:
> On Tue, Apr 08, 2025 at 12:45:26PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.12.23 release.
> > There are 423 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Also arm64 defconfig gives:
> 
> /build/stage/linux/arch/arm64/boot/dts/rockchip/rk3399-base.dtsi:291.23-336.4: ERROR (phandle_references): /pcie@f8000000: Reference to non-existent node or label "vcca_0v9"
> 
>   also defined at /build/stage/linux/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
> /build/stage/linux/arch/arm64/boot/dts/rockchip/rk3399-base.dtsi:291.23-336.4: ERROR (phandle_references): /pcie@f8000000: Reference to non-existent node or label "vcca_0v9"
> 
>   also defined at /build/stage/linux/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
> ERROR: Input tree has errors, aborting (use -f to force output)

Ugh, again, now fixed up, again.

thanks,

greg k-h
