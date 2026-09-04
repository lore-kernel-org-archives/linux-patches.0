Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [83.223.95.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6043655EA
	for <patches@lists.linux.dev>; Fri,  4 Sep 2026 09:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788512545; cv=none; b=md/0rWXvjiOxetg/7LA7cbnfSZNOlOGQH6S3k3aDCfP3F9ljh8XEkCoFYQUawCyRs+mt6UFKAtB+NQOj7jK+km/zgZjEfgfD5CYD3yx/ChcZlE7zpex8YCMrRLAiNiOBiIsIL/kOplLJMdGs16xh/SDvNFPK+pY53mqgH1an9p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788512545; c=relaxed/simple;
	bh=vMoPaHvYNDs/Pj3sG0TXd/LCo+iMlwy+6rJXEsVamb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o79S8xD3Bey6G9X1TLC2ucsruZfgBsJy5WTJOSH/lXyi7loYv8v1PFmHPhdvSXOGbVAAxJKQFcQcc9BWpK9g0skb0DhHMdYDhCYJzaBVXSpiyXwj7Y8RoxmRLWMEaHR5t5p/4M73mHiyC5IO7hoayZcDWywvKNGUm9VCWcjG7/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.95.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout1.hostsharing.net (Postfix) with ESMTPS id 6AD063B40;
	Fri, 04 Sep 2026 11:02:13 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 448F461A11B3; Fri,  4 Sep 2026 11:02:13 +0200 (CEST)
Date: Fri, 4 Sep 2026 11:02:13 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Darshit Shah <darnshah@amazon.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Guixin Liu <kanie@linux.alibaba.com>
Subject: Re: [PATCH 7.2 532/713] PCI/DPC: Allow DPC on all Downstream Ports
 when OS controls AER
Message-ID: <apqJFWNrcajdFyad@wunner.de>
References: <20260904045803.810145556@linuxfoundation.org>
 <20260904045815.744991650@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904045815.744991650@linuxfoundation.org>

On Fri, Sep 04, 2026 at 06:58:20AM +0200, Greg Kroah-Hartman wrote:
> 7.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Darshit Shah <darnshah@amazon.de>
> 
> commit 97ca178c899d0049210d325b123ed024eb5ac000 upstream.

Guixin Liu has found a problem with this upstream commit:

https://lore.kernel.org/all/20260901064554.2178688-1-kanie@linux.alibaba.com/

There's no fix in Linus' tree yet, so it might be best to hold off
for now on backporting the offending commit to stable kernels.

Thanks,

Lukas
