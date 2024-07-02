Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6906114E2D8;
	Tue,  2 Jul 2024 08:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719909765; cv=none; b=Rfl8Pr9aS8lziA6MbFekWlCe7ep5s1oM0boMjpO8DHjYvfo1POf3OMzD0Gv3lC6FkLob3onFtxANw+oO6aGigEjYDodPydQetqrJvkCiPAfUV5W/k6/Lkejgy4vy35Y9FXR2pBWFlLzo3dyjPQOJ6cJYCP43dwFQlV3ghn5VW+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719909765; c=relaxed/simple;
	bh=5Nsih7U/aO4FDaKQBrW36vzZDZ8b0W+azxYjgclNQlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gnY4C6BABixIkSJwmqgiTbQ1E+IVeGuE4e3HOBcvNEd2SkkYsN3GQjeKh/8PvJ6iFKCuSVnNoNpVBRmtfWMvjoYojZ8k1737MQOneOmlsJ1SZjmVV8pz9opGSrTZPDEIw/lhfESlB5DXGKPQTXaUbmdTQtFXRQuog+AhscptHmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LK7R3hU7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LK7R3hU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA0CC4AF0C;
	Tue,  2 Jul 2024 08:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719909765;
	bh=5Nsih7U/aO4FDaKQBrW36vzZDZ8b0W+azxYjgclNQlU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LK7R3hU71yLTUK+9P7JB4kRVQbvtCiJ/Zt9foC/8C8W1PA8lz7h3QPCdLKZ3kNjAS
	 ZTxL2UCmtGozOlddTbAj+YG5PVhfGe59eiw4TmyOVup6u4nV3yp5oLkSoNrAsQdrXL
	 kInQLSZY5Z5pFSDqHEEkTR/C8ra8kU+k41M6jY2E=
Date: Tue, 2 Jul 2024 10:42:41 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: Eric Woudstra <ericwouds@gmail.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.9 029/250] net: sfp: enhance quirk for Fibrestore 2.5G
 copper SFP module
Message-ID: <2024070235-troubling-effort-056e@gregkh>
References: <20240625085548.033507125@linuxfoundation.org>
 <20240625085549.174362251@linuxfoundation.org>
 <20240628172211.17ccefe9@dellmb>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240628172211.17ccefe9@dellmb>

On Fri, Jun 28, 2024 at 05:22:11PM +0200, Marek Behún wrote:
> On Tue, 25 Jun 2024 11:29:47 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > 6.9-stable review patch.  If anyone has any objections, please let me know.
> 
> Sorry I overlooked this, I thought I already replied to this, but in
> fact I replied to another patch not to be backported:
> 
>   net: sfp: add quirk for another multigig RollBall transceiver
>   https://lore.kernel.org/stable/20240527165441.2c5516c9@dellmb/
> 
> This patch (net: sfp: enhance quirk for Fibrestore 2.5G copper SFP
> module) has the same problem: it depends on the same series, so it
> should not be backported.
> 
> Eric informs me that it was already released as 6.9.7 :-(
> 
> What can we do?

Now reverted, thanks.

greg k-h
