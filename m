Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247FF200A3
	for <patches@lists.linux.dev>; Thu,  4 Jul 2024 07:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720077555; cv=none; b=nsPKxwXeqoexSa8/02Z2FxdMtHFqhTEVJFy2E4ZOr/VEWAT2zCXG3pQo28hImkGcnFiWtfyw2f2OwWByMb1kRdidnfXPoI33KgmZ8d/VVa/xZ7yMFSdJLynDs+PqFJyKgCfasOgDJV7tZ3NDlh5nKNZ3aeoBtJYsCK9apCtk7GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720077555; c=relaxed/simple;
	bh=eU1pLxVnCsq58db3k+Jkm05WqYQYeVvSkPTrd6hUrKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IdGWHXACh37kURsQ1qOKUSje4+D2DTtqDJ2mQ0VMj8PZGHycC7CeEgJPtulTxUgA84U2v/uXbqM2D1/1DwFj5wWGaGCuCEWY+xkBbJ/owdlrkc703TrTxEDzA99t5/OYvQvCZBxPnJ4LEtQ+YLpq3sNwjacr3MQW6H2oR2NOmoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=XFJEny48; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="XFJEny48"
Received: from francesco-nb (31-10-206-125.static.upc.ch [31.10.206.125])
	by mail11.truemail.it (Postfix) with ESMTPA id 16E36201CA;
	Thu,  4 Jul 2024 09:19:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1720077544;
	bh=5C0XeQUe91ah5KjrbKZ7CBFuKAICvHVb5FVvGU//GsY=; h=From:To:Subject;
	b=XFJEny48E2ShYkFeSpRJ9pVIXmxGDxA6b1t/jWxOhBl0lVKL0C43kw3XtO8KhFoPZ
	 OjaJiNn24gjmwHAI1SsN+yTCj6poXNNE9UsmRXF7nUyUKnQnvCKnlUcGnzlFUJZEY6
	 Eh2pV/tYQR45dQyqqP+VrZTp/7mQIrqLpthkP/+zBOkaWQUIrrq8Moqetz4G7nLMo/
	 D9jMjs83o4XCnDZmy9+jYPJzKGSMih77VI3O/y/39cxGeYbRvtWVSJcsm/4Axa8wcv
	 +hhFs64DUDVVv4kJzLcjlRMbd4eKXf/HaBSS+QjbTC9K9em25oNSFyj73Rd9POyaGe
	 326ptFZMFgK2g==
Date: Thu, 4 Jul 2024 09:18:59 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>
Subject: Re: [PATCH 6.1 091/128] serial: imx: set receiver level before
 starting uart
Message-ID: <20240704071859.GA4355@francesco-nb>
References: <20240702170226.231899085@linuxfoundation.org>
 <20240702170229.664632784@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702170229.664632784@linuxfoundation.org>

Hello Greg,

On Tue, Jul 02, 2024 at 07:04:52PM +0200, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
just a head-up on this patch since from my understanding you are going to have
a release soon and you did not ack the previous email from Stefan.

This patch must not be backport to any stable branch, it introduces a
regression when the driver is using DMA (a fix for this is already in
your mailbox, but of course, it's not in mainline yet).

Francesco


> ------------------
> 
> From: Stefan Eichenberger <stefan.eichenberger@toradex.com>
> 
> commit a81dbd0463eca317eee44985a66aa6cc2ce5c101 upstream.
...

