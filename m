Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EE21D8A0B;
	Thu, 20 Feb 2025 10:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740047506; cv=none; b=jSD5D1BQy4vM7rD0QVPxi73HggIj95tnFMgNXn5u+yOgQb57m9EGsy2wRqgmjHfaHG3FSxrUFvt+g7PhnS3V+kZN4dbSbXU5f+nj3fpFX70VT3iuDRr31PB3fzss/FI123PIRA5X3khkBQ3hC7ivLmhs8M83gOGRSH03BgLWgl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740047506; c=relaxed/simple;
	bh=0gGUjcCcjD2H9qdzcj34mjqEXMPeXP6ZWHyZiV1zUD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W3mmSfAhSkUjtRlG+4MFfqPLOP17jbcD0BUeFXibianiUxgYvrEYG08YGZu7Sd8TzCFJS4597EKn9muZp2N7uVfQCOBdGYFBZVOs6jMcgF1B7xUZcEo1ZylW0peGjU6kpm2CdY42r8b9GpY1xwXJeboMDFfb+FS3+7pyjCtuCkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNM9aKpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNM9aKpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C49C4CED1;
	Thu, 20 Feb 2025 10:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740047505;
	bh=0gGUjcCcjD2H9qdzcj34mjqEXMPeXP6ZWHyZiV1zUD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MNM9aKpfjOvOYQvliGldkVbqoeYgsmCTJZ+oc9JVqALkcT3Eb9+i5wsZjp9pErpBR
	 0TPlnMEPBguZ0eGIXaxCyLoYyQra9tIG8G6Mpld0V0kEM20NqagQE8kxiIdLBhgOMR
	 smEd5Ao5flRCNzEA/edC8PxRW5GHJKz/TTeatvIQ=
Date: Thu, 20 Feb 2025 11:31:42 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.13 230/274] eth: iavf: extend the netdev_lock usage
Message-ID: <2025022029-confirm-vaporizer-5a86@gregkh>
References: <20250219082609.533585153@linuxfoundation.org>
 <20250219082618.582615972@linuxfoundation.org>
 <20250219133453.0550fb92@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219133453.0550fb92@kernel.org>

On Wed, Feb 19, 2025 at 01:34:53PM -0800, Jakub Kicinski wrote:
> On Wed, 19 Feb 2025 09:28:04 +0100 Greg Kroah-Hartman wrote:
> > iavf uses the netdev->lock already to protect shapers.
> > In an upcoming series we'll try to protect NAPI instances
> > with netdev->lock.
> 
> Please drop from all branches, waaay too risky
> 

All of these are now dropped, thanks so much for the review and letting
us know.

greg k-h
