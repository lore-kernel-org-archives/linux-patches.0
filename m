Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D734189F5F
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 07:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729753297; cv=none; b=YszLq2j12+KHvq7lFoKvIQh6b6w//hmOt27H0qmzN5hEdir4/+RvlqNb9nhJYWxUaTJdxOagRLtc6bogjZzRu/Vcu2qZ1AkTMcc7+9meghjMRUPsiv3T/tHesEB46uGHY8ZSzN0bZU11GXtTdeGMMSs6Tls8Yf78aMsE0gvgVrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729753297; c=relaxed/simple;
	bh=vD3IrRF/+qmLRBs/JLN6gmx3hMkKr0r3AFZ1sLjhq9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s33NhLdq6R2nV0Cg7LKyL55PXO3hVzatSwfDzSwadHnkfEVJp4JQLsQZUE0FJD9kpGoQtZclHvTkX+zkh5ntNxl74Jhfhhvd5F1/vnQYQ+3xdXKjXr8gV62pwUGTj//TbAwmKnxKBDwkSxJFsK3+SCyTvkBThRQUieZ5vIpO0Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.78.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout2.hostsharing.net (Postfix) with ESMTPS id DDAC32800B48B;
	Thu, 24 Oct 2024 08:56:19 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id C76D74D3F9; Thu, 24 Oct 2024 08:56:19 +0200 (CEST)
Date: Thu, 24 Oct 2024 08:56:19 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Remove some entries due to various
 compliance requirements.
Message-ID: <ZxnvkwZrkaeOCRAo@wunner.de>
References: <2024101835-tiptop-blip-09ed@gregkh>
 <a520d1f5-8273-d67e-97fe-67f73edce9f1@linux-m68k.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a520d1f5-8273-d67e-97fe-67f73edce9f1@linux-m68k.org>

On Mon, Oct 21, 2024 at 09:49:56AM +0200, Geert Uytterhoeven wrote:
> On Fri, 18 Oct 2024, Greg Kroah-Hartman wrote:
> > Remove some entries due to various compliance requirements. They can come
> > back in the future if sufficient documentation is provided.
> 
> This is very vague...
> What are "various compliance requirements"?
> What does "sufficient documentation" mean?

Looking at what other organizations have done provides some clues.
E.g. the RIPE NCC initially took the stance:

   "The RIPE NCC provides critical services to its membership spread across
    a diverse geographical and political region.
    The Executive Board of the RIPE NCC believes that the means to communicate
    should not be affected by domestic political disputes, international
    conflicts or war. This includes the provision of correctly registered
    Internet numbering resources."
    https://www.ripe.net/about-us/news/ripe-ncc-executive-board-resolution-on-provision-of-critical-services/

However due to being governed by Dutch law, that policy had to be amended:

   "The Dutch Ministry of Foreign Affairs confirmed to us that IP resources
    are considered economic resources, as defined in the EU sanctions
    regulation, and must be frozen for sanctioned entities.
    The RIPE NCC complies with this restriction by freezing the registration
    (not the use) of the Internet number resources in the RIPE Database.
    This means that sanctioned entities cannot acquire further resources or
    transfer resources. However, we do not deregister their resources or
    terminate their Standard Service Agreement (SSA) if they are RIPE NCC
    members."
    https://www.ripe.net/membership/member-support/the-ripe-ncc-and-ukraine-russia/

At least the RIPE NCC was transparent in the process and seemingly did only
the absolute minimum to comply (freeze, but not deregister IP address blocks).
An approach that might be befitting for the kernel community / LF as well.

Thanks,

Lukas
