Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810A02561A3;
	Thu, 29 May 2025 06:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748500521; cv=none; b=RfoCFw8Zp0muFxQOv5txYDGYopYqm+sqbRmnkUkhHyn7fcDjF7heHUzFBBfngLJLV7uFXmNJmMF69lFJJkGp842gq9WJpd6AAQFSCRGOcdUMC8/TBkJa/lMtqqWHOWkMjJ9JphpFnoZ3yNMCVNqwYiSIyU9nNNOeGHj0zVKa40g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748500521; c=relaxed/simple;
	bh=kFgWPNPDMFfTx4pGGCIHlZVFS9J4PDiW8Uery7HOcLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Clps1ZF/CJNBQN5tMzK5Wl/GWaqz8sfl7nwmPBSZa0Ai7Ly++7n1xbl9Gwx4fp1Cv3Jgup65LQNrZ0CZxjySc4pN07b1zYGLRH//Re8pd5Q/kkoAHAyZtGZgBFTLKIaYDravwcbG0dRhyMjZi+Qep+sI3Kju0BI8t/rSaR49edc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIBcIJAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIBcIJAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4DEC4CEE7;
	Thu, 29 May 2025 06:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748500521;
	bh=kFgWPNPDMFfTx4pGGCIHlZVFS9J4PDiW8Uery7HOcLw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cIBcIJAmawBez8Xhtwxr76icfjjs+ieOdSuzGOsLGKy0ujHMgFemy85ZzaEamW9CO
	 TN9Drxypj0N/iT7R1ZIdzl5mJPa217SYwAizW8qwwJU8Ic2DL6AasfhPcK/w0lTyfC
	 R93dLchoRNYQkca9mCozL7cT5AILzLLD8RS2PcFU=
Date: Thu, 29 May 2025 08:35:17 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Hanno =?iso-8859-1?Q?B=F6ck?= <hanno@hboeck.de>
Subject: Re: [PATCH 6.14 750/783] Input: synaptics-rmi - fix crash with
 unsupported versions of F34
Message-ID: <2025052959-corrode-outback-6ecd@gregkh>
References: <20250527162513.035720581@linuxfoundation.org>
 <20250527162543.672934881@linuxfoundation.org>
 <i7tnbh7l2blxussxcdgjuvcpkzet5w552dqu6vl5upus4xf74n@dva72me3bdia>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <i7tnbh7l2blxussxcdgjuvcpkzet5w552dqu6vl5upus4xf74n@dva72me3bdia>

On Tue, May 27, 2025 at 01:42:39PM -0700, Dmitry Torokhov wrote:
> Hi Greg,
> 
> On Tue, May 27, 2025 at 06:29:07PM +0200, Greg Kroah-Hartman wrote:
> > 6.14-stable review patch.  If anyone has any objections, please let me know.
> 
> Can you hold this for a bit? I might need to revert this.

Now dropped from all stable queues.  Let us know when you want this
added back.

thanks,

greg k-h
