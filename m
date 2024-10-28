Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9EC1DE4E9;
	Mon, 28 Oct 2024 12:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730119337; cv=none; b=XRUtP+W1yfNkiCPgMM/sGwD2uGzXBeypIneBDwGdctR5FVK85f47Fr43DCfVJ9uggPF2bigvX2axkvNOv2QEk1+thZDUstMJb9hZDA1ymMP9nWzp3yJDyncDGt1nBmmsHT2BXmw3GjN5AFfzaMZfmetaRtndf+M/jIE/0E9u4wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730119337; c=relaxed/simple;
	bh=r2wydnfVm8v4NwIeVCJc9UK8GtaBZ4LbV6yLNH7jT/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i2wJi9SKsPD8oOQLGL+4mcQ/xSbCMWVI9xcRPAgoce3gHhlQRFQVYBmjKEc8s57+7U66mQZ6oBEJHErVZErsMgokj3R2iva9okWgRkQ3W81NERgDd7t84SfKN7Jv0F2l9V99y8PLEE0KDQcoIqITpO4T0IHueWyS4moFEwNr9QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3qzsgTl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3qzsgTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCF9C4CEE7;
	Mon, 28 Oct 2024 12:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730119337;
	bh=r2wydnfVm8v4NwIeVCJc9UK8GtaBZ4LbV6yLNH7jT/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X3qzsgTlGPvQK0RJf9MbQDN5tw0I7yVVfv9VkigUXrGxwr27ciuThvkcTAfAII0PK
	 a2h/4igxEdU+WA46KXg7TvKgZnfv7ZNRsW5b4HC0PWB/ka+YfqZDPkUeGyuDP3RT1s
	 IR+0p2hF43XYgVIi2f8c4cbQeya7RUfvctTN7sigJkJr4jRvFGz3oZ7p2KTfbayKWx
	 fD9W0P5j/cVItyz54WtScM0IJP3bnjA0ASDhWUOYdA58uZcQp7HxZjbFsNhIu1fcLc
	 1mqwTP4EaEjogsa8nhYsWS+Y7pI455dOj7fT0dxwMqVrbeweKKtiNMbxi2ZaKmj+yT
	 57ZowrmnRHojg==
Date: Mon, 28 Oct 2024 08:42:15 -0400
From: Sasha Levin <sashal@kernel.org>
To: Antony Antony <antony.antony@secunet.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 6.6 133/208] xfrm: Add Direction to the SA in or out
Message-ID: <Zx-Gp8f9jjxmDsIe@sashalap>
References: <20241028062306.649733554@linuxfoundation.org>
 <20241028062309.914261564@linuxfoundation.org>
 <Zx9wp6atLMR1UcCL@moon.secunet.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Zx9wp6atLMR1UcCL@moon.secunet.de>

On Mon, Oct 28, 2024 at 12:08:23PM +0100, Antony Antony wrote:
>On Mon, Oct 28, 2024 at 07:25:13 +0100, Greg Kroah-Hartman wrote:
>> 6.6-stable review patch.  If anyone has any objections, please let me know.
>
>Hi Greg,
>
>This patch is a part of a new feature SA direction and it appears the auto
>patch selector picked one patch out of patch set?
>I think this patch alone should not be applied to older stable kernel.

It was picked up as a dependency:

>> Stable-dep-of: 3f0ab59e6537 ("xfrm: validate new SA's prefixlen using SA family when sel.family is unset")

We can drop it, and the netfilter folks can provide us a backport of the
fix above?

-- 
Thanks,
Sasha
