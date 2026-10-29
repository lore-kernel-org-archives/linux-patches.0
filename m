Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793264843;
	b=rt1LRycCp918ylYBegUFlCrY8v0UnNhEKa9ZQnavHs3hkDQFSTzThZoyK/0bHC2tug7v
	 yMWmLbgB+959Pm7mUs9L2QO7Po+4pUubHp6QDCBVp67kgSY5moFfPQAeeLFrI5ctnSS9T
	 tg2mLMW++CmSlwLUBdpD5JylOIUR5RzlOwdf5hxyiPDjqFarM0BnlpeCfy74YYhGj58ul
	 tGf3K9tRpMvaq6Q0iqMuddpnkw7XLrSkkEem9vUL3Cr7e4YuAGW7JyQ50Ak8vpIZEbwG6
	 HC2MQ4yqGuDssmAT965J62Lef+HRAxIyegk7SoJCOsxBeAnjrYrU4WQ47/I3v0JJVfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793264843;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=aeD2rvRr8yCH9Pyjyd9soiL1vIOgxA2CdjNlALkdgBI=;
	b=YpKx8ax/DRQZKqV4SpqEQLc51gRQgDTqWc560Eb6TSfgbr6sVyo9QMdrr7+8FvGaDWHE
	 slSqVPkKOOqbLDykodzzvVOrsLxFJrhaxxbKsnh1QO7IXSayKxY7XTJERzMeCLLiDGqfp
	 mFYgLbN4vQgxCRm608H7UChxURhV4ztYMVIbssLZKl/pD0UZVOfNE/Aqkt/A68gMnM856
	 jQGlMO0fVoYNc+wUZmx+2Y1gP9S20leF9RfzuhzK3OsukDtsHx/HKQj8mJr/1Hh2O4VW2
	 kS+35NkXx1OgT9cvGRHbobVcbk37X287/BMasQC+gO2SXGUtOmmdjB+kGV93NuAcWww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vzu/LSSD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137C8606A31A;
	Thu, 29 Oct 2026 09:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vzu/LSSD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07ABC1F01825;
	Thu, 29 Oct 2026 09:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793264842;
	bh=aeD2rvRr8yCH9Pyjyd9soiL1vIOgxA2CdjNlALkdgBI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=vzu/LSSDz5PzODr/uiHsZUS9uQB8SnQ8cd6S/p7ZBlANBDin1lQ4bPhb3MvZxgZje
	 QDpfzrkCiNBlUMOa3iFOfcxlWui5GJoSENUViD3c3nKn7aCBVbx52g16N9NnuV7MZF
	 SLXrDLGDTXveOQHV/aWdTsH+Fe1sPtKOz3jrLO1o=
Date: Thu, 29 Oct 2026 10:07:19 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Juanlu Herrero <juanlu@fastmail.com>,
	Anand Natarajan <anand@meta.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 7.3 14/38] io_uring/poll: avoid retry wakeup loss when
 dropping ownership
Message-ID: <2026102946-stubborn-magical-d432@gregkh>
References: <20261028165940.394092994@linuxfoundation.org>
 <20261028165940.759766255@linuxfoundation.org>
 <9eb403db-31da-4b6e-a2b5-69f311c05d00@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9eb403db-31da-4b6e-a2b5-69f311c05d00@kernel.org>

On Thu, Oct 29, 2026 at 08:53:12AM +0100, Jiri Slaby wrote:
> Hi,
> 
> On 28. 10. 26, 18:00, Greg Kroah-Hartman wrote:
> > 7.3-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Juanlu Herrero <juanlu@fastmail.com>
> > 
> > commit 937d38dcacd675dc0572d6c9b6743960df3128ed upstream.
> 
> Our machinery flags this is needed as a fix:
> 67bb1ad9a517 ("io_uring/poll: don't loop on HUP with multiple references")

Thanks, I missed that one.

And for some reason it was given a different commit id in the backports
that Jens gave me, so it's already in the older queues, and I'll go fix
up the id there to match this one.

thanks,

greg k-h
