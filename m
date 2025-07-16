Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FFC21CC4E;
	Wed, 16 Jul 2025 14:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752675053; cv=none; b=fh9naTAh2PMD1huNdGPTok4fv+0W+9/pGsp1VTOlbH0W3YRSwLCUfAnG+c9AM3jQHYg2P6Of6rGN4DeGaXUVoTKhlC2BZoeAttuY6/PKnruHWpHZEcrVHSFy+FCng09KY9OVc9/nPJ4V0suVX8pkS7sOYJVKc5t/P620ZrSjGZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752675053; c=relaxed/simple;
	bh=J9W1MVnwck+hzI+6SM/9tvNOiPeA18G64n4Ayirc+Jg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J/BlgVU41ZE+yLdkhqGJcajLb4AbcmSFcAue+ZZ385um0gMvLopUcRGrWhCgZpxxhCL37T5Jz2ngk1h1gQkc1DNlK0qiz2q6ff1ZKGG2vlBCxLG07S9S04qpzrXaf2wGWs+EFoOo8ZQ541VsgsoN5Pk7MbBQlOVkhA70lT9uu+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNiPIImo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNiPIImo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9FBC4CEF0;
	Wed, 16 Jul 2025 14:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752675052;
	bh=J9W1MVnwck+hzI+6SM/9tvNOiPeA18G64n4Ayirc+Jg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aNiPIImo81cWsLg9KRjquqeeiP4+iPkSqbMQzIfEOo3Qd3LyGtpEb95VQwm3FVAcs
	 2ut0fE6g3zyIp4kzuQoJ6yCjzBvFSkgdEvGy4HZwjPuMeVeP0jC3fpryZ9cbA368nU
	 gWNyD9LpyxSGysN8nR836RedrVLou6nvuo10JVA8=
Date: Wed, 16 Jul 2025 16:10:49 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guido Kiener <Guido.Kiener@rohde-schwarz.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Jian-Wei Wu <jian-wei_wu@keysight.com>,
	Dave Penkler <dpenkler@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 022/208] USB: usbtmc: Add USBTMC_IOCTL_GET_STB
Message-ID: <2025071640-booting-kettle-7062@gregkh>
References: <20250715130810.830580412@linuxfoundation.org>
 <20250715130811.725344645@linuxfoundation.org>
 <b7899ee9fddb4a39bce1349d7d1224ad@rohde-schwarz.com>
 <2025071536-rummage-unlit-70d4@gregkh>
 <faf41397ab4b4344af294bbb8c2e6030@rohde-schwarz.com>
 <a35a4e1b6cd6484d893b71da487dd8b0@rohde-schwarz.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a35a4e1b6cd6484d893b71da487dd8b0@rohde-schwarz.com>

On Wed, Jul 16, 2025 at 09:59:08AM +0000, Guido Kiener wrote:
> Update see below:
> 
> > > I got the series
> > > [PATCH 5.4 015/148] USB: usbtmc: Fix reading stale status byte 
> > > [PATCH
> > > 5.4 016/148] USB: usbtmc: Add USBTMC_IOCTL_GET_STB
> > 
> > Odd, that second one shoudn't be there, right?
> 
> Yes, there is no need to add both patches.
> 5.4.295 is ok and uses old implementation of usbtmc488_ioctl_read_stb I assume, there is no need to add [PATCH 5.4 015/148] and [PATCH 5.4 016/148]

Ok, will drop all of these, thanks.

greg k-h
