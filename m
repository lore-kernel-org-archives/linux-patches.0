Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5E513C3D5;
	Fri, 30 Aug 2024 12:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725022038; cv=none; b=RdZRhLVc6jXwvr3wMqkZsMh0055GiAcB1E0Ef+qYF+S526UZrYVGT9G8yr8mYYfFkS3+vspu6Qq52GU4fA+D/zsvPVznFTqYPHH4VCzfh/JuEEv9EG44UBirhv55IiE9KAhv1ZykGIRtpv/NaZaXxKmRkwFkspsbYm0T6xG8bWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725022038; c=relaxed/simple;
	bh=LcGBkLQt3MdE6QDzY1xhZinz4rSO8r3XSJhxINE6t3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qCMlajbNcJ8iw8uTLP2zbGbSQU1vZiZXV0kCt4uRyi2whEwxPBhytfNoMV6kQjCDWxNyjNF1bPsqGKDNq8DkZthOAf34/UvGkYsA/oW9B3kVHNA9IhIQAnlr/jJuFKxVH+mvlFXVSbkKbs56kaj4RGdCeeMM/geb/204G39X9E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0X1aFLxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0X1aFLxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31ACC4CEC6;
	Fri, 30 Aug 2024 12:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725022038;
	bh=LcGBkLQt3MdE6QDzY1xhZinz4rSO8r3XSJhxINE6t3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0X1aFLxdlpi9qyBswVmslcyTJBTY7VhqYcih6atMp0NVDxzoCqNa3/b+vvXRz6lJb
	 BVhH+OgupmEOqNRno2juT9ei2n2K2bJKt9XxClFOsctveLLFyHZv2We7NgzhnFdNpG
	 stt3t6GxLFfBbnl+eMklmoNaCJ5mfc1cCd5WEgXM=
Date: Fri, 30 Aug 2024 14:47:14 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 194/317] Input: ioc3kbd - convert to platform remove
 callback returning void
Message-ID: <2024083007-gratified-cesspool-6cfb@gregkh>
References: <20240613113247.525431100@linuxfoundation.org>
 <20240613113255.060736154@linuxfoundation.org>
 <Zs6hwNxk7QkCe7AW@codewreck.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs6hwNxk7QkCe7AW@codewreck.org>

On Wed, Aug 28, 2024 at 01:04:16PM +0900, Dominique Martinet wrote:
> Greg Kroah-Hartman wrote on Thu, Jun 13, 2024 at 01:33:32PM +0200:
> > The .remove() callback for a platform driver returns an int which makes
> > many driver authors wrongly assume it's possible to do error handling by
> > returning an error code. However the value returned is ignored (apart
> > from emitting a warning) and this typically results in resource leaks.
> > To improve here there is a quest to make the remove callback return
> > void. In the first step of this quest all drivers are converted to
> > .remove_new() which already returns void. Eventually after all drivers
> > are converted, .remove_new() will be renamed to .remove().
> 
> A bit late to the party here (this patch was included as commit
> 0096d223f78c in v5.10.219), but 5.10 does not have .remove_new()
> (missing commit 5c5a7680e67b ("platform: Provide a remove callback that
> returns no value")) so there is no way this commit will work.
> 
> 
> I'm not building this driver so don't really care and this can be left
> as is as far as I'm concerned (and since it's been over 2 months
> probably no-one is using this driver on this old kernel, it doesn't look
> enabled on e.g. debian's build); so this is just a head's up for mail
> archives if anyone is notified about the problem they'll want to either
> revert this or pick up the above commit.
> 
> (I checked quickly and that commit was backported to 5.15, so 5.10 is
> the only tree where that broke, and there is no other driver in 5.10
> that tries to set .remove_new)

Thanks, I'll go revert this!

greg k-h
