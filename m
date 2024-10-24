Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2988D189BB4
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 06:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729753173; cv=none; b=VVDYFS40MJ7zFDYeZeCWSgpplh1wC5jUm6iprltA5MtLs1h8+K/o7DKucpiOQImJ3T9xbucqmGO3JWT8vRitMyr4XMP7tu4bBlN+eTtOx5NGpNBX1fST81ovhiYyepV2hoGnNC16OzlvtySilgo6GRx3nPlzoOMuyeVqq3CQN+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729753173; c=relaxed/simple;
	bh=jo5ugP9JRmzsH1Sj1m0nnIn7eduYie3IBYkF39QE2mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gZ+rZ39bRW6BMvSNHTHngV4MdY9NA0meN0KNCMumuyjn6x6Q6LnD0NbAD5eWTQHjGBgzN39xS0gfVoFtCIjl6WcrZFikaGE/kEh9i6Npv5FUTuozcTCCV+UT2IPo39YY+L9le80dNlLwWLtbKsJGUuTd2qytVWtYU+QF/UYdTcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1RJjEu35; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1RJjEu35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8DCC4CEC7;
	Thu, 24 Oct 2024 06:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729753172;
	bh=jo5ugP9JRmzsH1Sj1m0nnIn7eduYie3IBYkF39QE2mc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1RJjEu354IBQ07D6E5Tm3hE6SBuE87Ug2UalhBslb8PioHbtP4jTr/ACoDQfk2GGY
	 UP80Ytk4sm14tCOMYxd7sU8Da4/KitDeeDFGFjCvPX4HCdTpOFJwP+UMOXxARohSgy
	 Oe6sAF57ex6TZvz19kupzXYod0ZKHEzEp16AUO44=
Date: Thu, 24 Oct 2024 08:59:22 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Abylay Ospan <aospan@amazon.com>
Cc: patches@lists.linux.dev
Subject: Re: [PATCH] MAINTAINERS: add netup_unidvb maintainer
Message-ID: <2024102409-couch-earthworm-2508@gregkh>
References: <20241023163425.30492-1-aospan@amazon.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023163425.30492-1-aospan@amazon.com>

On Wed, Oct 23, 2024 at 04:34:25PM +0000, Abylay Ospan wrote:
> Adding/restoring maintainership for the following drivers:
> F:     drivers/media/pci/netup_unidvb/*
> F:     drivers/media/dvb-frontends/helene*
> F:     drivers/media/dvb-frontends/horus3a*
> F:     drivers/media/dvb-frontends/lnbh25*
> F:     drivers/media/dvb-frontends/ascot2e*
> F:     drivers/media/dvb-frontends/cxd2841er*
> 
> Signed-off-by: Abylay Ospan <aospan@amazon.com>

Thanks for this, I'll queue it up!

greg k-h
