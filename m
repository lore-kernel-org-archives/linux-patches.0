Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77180260573
	for <patches@lists.linux.dev>; Fri,  4 Jul 2025 06:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751611330; cv=none; b=EW7xmwJN5ID0m9fGm5fCKwS24v0btuZH9OilekBHYGopTUWnkspclcOmAseckM8Q+7UWPp7gofa0rltRtZ4awyHq5JO2I7UjFla8m5x6+iWJKxjgUCMiX21oOCXFvfEPkOpTkZ9OOkjLX9OQvAHKu7F1AIkVcjEGMt6JG6gitl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751611330; c=relaxed/simple;
	bh=jBETVF/lxjKsUb/UL+/VlaD0qcbwryLeRPhZsZ/91pE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=axGhzheLXJlRXYJsVyfLa5a2sKIy7BY7mAnzpNHw0uKT5sdFKPqfpxuVgXYBFiDDzcCUSdqJOIRhkC0yHBBVdQqCXBF+mFvsQGUGUbWoYUwNjR07isLvgYIijtX0lx4xFuUWCn/65+ClspSIS8hToxrQDENgUU2xpY+pnepBKAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id 4A0E32C02503;
	Fri,  4 Jul 2025 08:42:05 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 2F1E44153BF; Fri,  4 Jul 2025 08:42:05 +0200 (CEST)
Date: Fri, 4 Jul 2025 08:42:05 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Krzysztof Wilczy??ski <kwilczynski@kernel.org>,
	Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 020/218] Revert "iommu/amd: Prevent binding other
 PCI drivers to IOMMU PCI devices"
Message-ID: <aGd3vc6EjHQhp5ED@wunner.de>
References: <20250703143955.956569535@linuxfoundation.org>
 <20250703143956.766086832@linuxfoundation.org>
 <aGaY4Y9trrnMlxO-@wunner.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGaY4Y9trrnMlxO-@wunner.de>

On Thu, Jul 03, 2025 at 04:51:13PM +0200, Lukas Wunner wrote:
> On Thu, Jul 03, 2025 at 04:39:28PM +0200, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > [ Upstream commit 3be5fa236649da6404f1bca1491bf02d4b0d5cce ]
> 
> This should not be backported to stable kernels.  It does not fix
> any known issues, but conversely it is known to cause an error
> message on boot, for which there's a fix pending here:
> 
> https://lore.kernel.org/r/b29e7fbfc6d146f947603d0ebaef44cbd2f0d754.1751468802.git.lukas@wunner.de/
> 
> Long story short, please unqueue this one. :)

Gentle ping - I just noticed that upstream commit 3be5fa236649 is still
on the queue/6.15, queue/6.12, queue/6.6, queue/6.1, queue/5.15,
queue/5.10, queue/5.4 branches (which were all updated 6 hours ago).

Please drop the commit from all of them.  This commit is not eligible
for backporting to stable.

Thanks,

Lukas
