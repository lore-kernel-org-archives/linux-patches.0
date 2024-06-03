Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [176.9.242.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C619613A244
	for <patches@lists.linux.dev>; Mon,  3 Jun 2024 20:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.9.242.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717447605; cv=none; b=NeKOILm8TeLKafZPvDRpABtxJhtk+j9PsdMM72ONhGLcUGA1+fGGo9dcdOBgrvtasYHBIf7et50CmybGdxTIMTM+w8IOLi9g8VM7Q/Swde4GaZkY7wOELSZlzo/8uwgyRdME/0+0ll21TwZXcAjP23oJnSMTLTo2YZ+UymPNlcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717447605; c=relaxed/simple;
	bh=FsvxSX/KBaDFhi+ZDmk2mVbiVY6TXD1Hp+ZfY7jSulQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nTQerzEH9QF4YM4bu0ScmD5QbSKCPki+xXhwugwaMPQemSPfQbAefB1YBJS3fJVMWK74EfuqKEBOe3aCyND/trh3nYpKaKX8aWrail9VuXZijxD5vn09wqRW6TU6Z8qBpvKsNyG50G3qP4Hjc0WSF2D0BJkWOWIOErbk9VVD2wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=176.9.242.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout3.hostsharing.net (Postfix) with ESMTPS id 131C3100EF4A2;
	Mon,  3 Jun 2024 22:46:35 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id CC119FAB5C; Mon,  3 Jun 2024 22:46:34 +0200 (CEST)
Date: Mon, 3 Jun 2024 22:46:34 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] sysfs: Add stub sysfs_bin_attr_simple_read() for
 !CONFIG_SYSFS
Message-ID: <Zl4rqswlbGM-eRY6@wunner.de>
References: <0-v1-44baae71b833+ab-sysfs_simple_read_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-44baae71b833+ab-sysfs_simple_read_jgg@nvidia.com>

On Mon, Jun 03, 2024 at 02:30:45PM -0300, Jason Gunthorpe wrote:
> Since the only declaration for sysfs_bin_attr_simple_read() is inside the
> "#ifdef CONFIG_SYSFS". Add a stub to the #else section too.
[...]
> I don't see a patch for this yet, but I did find a 0-day robot complaint:
> 
> https://lore.kernel.org/all/202404200345.eGdn5uxW-lkp@intel.com/

I already submitted a patch on May 23, but it hasn't been applied yet:

https://lore.kernel.org/all/05f4290439a58730738a15b0c99cd8576c4aa0d9.1716461752.git.lukas@wunner.de/

(My patch returns 0, yours -EINVAL, but I don't think that matters.)

Thanks (and sorry for the breakage)!

Lukas
