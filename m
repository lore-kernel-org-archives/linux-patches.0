Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA5C1A239A
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 06:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781073225; cv=none; b=h2B1DdFQIwjqrSrIuREnC8POJy1lWXwm+2ncwRQ3aBSAiK1jvBU1TtswUsQh1uFn81gmI9OA8ybxVfuCbW0U52nyGaFnC9I7zrkfHvUW07rzmBUIuVYeRcBHL6dNoqrr9IZYIjGkRYyJmYExAGUI0BZyK5aPQVbcl4Cm6o7/oMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781073225; c=relaxed/simple;
	bh=H9df0iu/urFPy2TAu0n/tlZ8whI1THxyXVYS8uwNWkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mQJpOG5LMZ4njtnH9hjUVqLDzbKEQfQbRFQbC9nYixQbTjuXDQs3CQnHm2fn4/oeDFhVvaXU1MQMN3IuWYzpxnFS3sign8CuX6tlQWUBauh+E3RpigtEdk6hR8vBWsnJaiUmDLwrZR5nfzfpqlrkkp2LtVkwmqVAFkPuDQeQ9KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q75SFmGM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q75SFmGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160721F00893;
	Wed, 10 Jun 2026 06:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781073223;
	bh=H9df0iu/urFPy2TAu0n/tlZ8whI1THxyXVYS8uwNWkI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=q75SFmGMEiwITnd7tUEgrU1Zup+dm+PEVpODsGzJ5dGuHT7DJKoRHmhJNHzcfSVTw
	 tBr1InrLXNx/l+mbhFjdmaYQxi5/agxFhdKx5pDIsGjjJtqFCobzCvb1yKXyqs71SP
	 JzXhGjlHm35u2mDzCymjh4Bfmf/LO7JtQLwWrR5I=
Date: Wed, 10 Jun 2026 08:32:44 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "zdi-disclosures@trendmicro.com" <zdi-disclosures@trendmicro.com>
Cc: "patches@lists.linux.dev" <patches@lists.linux.dev>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>,
	"mchehab@kernel.org" <mchehab@kernel.org>
Subject: Re: ZDI Vulnerability Reporting Issue
Message-ID: <2026061047-actress-storeroom-9d62@gregkh>
References: <BYAPR01MB3830E81BEC422B76C4A8699C801D2@BYAPR01MB3830.prod.exchangelabs.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR01MB3830E81BEC422B76C4A8699C801D2@BYAPR01MB3830.prod.exchangelabs.com>

On Tue, Jun 09, 2026 at 04:05:34PM +0000, zdi-disclosures@trendmicro.com wrote:
> Hello,
> We are currently experiencing issues sending emails to security@kernel.org. Can we send vulnerability reports directly to the folks on this email thread for the time being?

Why would you send vulnerability reports to a publically archived
mailing list?

And what specific issues are you having contacting security@kernel.org.
Based on the feed that has been coming from that recently, lots of other
people don't have any issues with it...

confused,

greg k-h
