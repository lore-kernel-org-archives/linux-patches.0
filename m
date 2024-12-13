Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395A81DF746;
	Fri, 13 Dec 2024 11:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734089746; cv=none; b=M/3KWHOFYaiHLY9AjjiDKbvDq3Qnp+hRRx6+uhplUBPzTCDDfxrTTnNi02a4KiFdU5WlLo84A5iyq/QRvPI2aZm8+7GM4jdgk+s/bPaM/QUI8giQ36TdVXWWBaJtqyG8yLlcKvQTFgJrBmH/D6Uhf3/ymoswSfulJv8doYZodA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734089746; c=relaxed/simple;
	bh=4K0e3AnjZnOzkDtaYF79h8zjx4loy6ySDiA6j7tZYFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xuek9VtQ8rCmnVLjqJwxtv1Yjsno4mfiRXodqj/5Mg7atqa+KfIekqXd6ZwRGITtpaAsx/jGwmnWxfFXdHZNWrI8e7ieUeyfe+7dXbgOmiahtr746k3Sg1usjQq3mugk9IhCQMcfy8HHJUXm3y4MpnNifeT446HrvS++V2VAmh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/pYFHN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/pYFHN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45968C4CED0;
	Fri, 13 Dec 2024 11:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734089745;
	bh=4K0e3AnjZnOzkDtaYF79h8zjx4loy6ySDiA6j7tZYFY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t/pYFHN9EqzcuHH370T1DVvo7eEjGksDgm3fx+CM6UXFGlGzO0OVYxJTm7Qnp65It
	 FwLQ2nV4hKKWNTBNYDse5IiG6uSL27QoctdbDYu+ukIpSYHFKKM2JSjpXQg+PjT6br
	 9RmhnhwNFc1eeCENQLiRllb2JP5kLTE9mw1UHJVU=
Date: Fri, 13 Dec 2024 12:35:42 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Philippe Troin <phil@fifi.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Anders Blomdell <anders.blomdell@gmail.com>,
	Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.12 162/466] Revert "readahead: properly shorten
 readahead when falling back to do_page_cache_ra()"
Message-ID: <2024121312-caress-wham-39e1@gregkh>
References: <20241212144306.641051666@linuxfoundation.org>
 <20241212144313.202242815@linuxfoundation.org>
 <4ab51fdc37c39bd077b4bcea281d301af4c3ef1a.camel@fifi.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ab51fdc37c39bd077b4bcea281d301af4c3ef1a.camel@fifi.org>

On Thu, Dec 12, 2024 at 10:12:54AM -0800, Philippe Troin wrote:
> On Thu, 2024-12-12 at 15:55 +0100, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let
> > me know.
> > 
> > ------------------
> > 
> > From: Jan Kara <jack@suse.cz>
> > 
> > commit a220d6b95b1ae12c7626283d7609f0a1438e6437 upstream.
> > 
> > This reverts commit 7c877586da3178974a8a94577b6045a48377ff25.
> 
> Isn't that moot now with 0938b1614648d5fbd832449a5a8a1b51d985323d that
> in Linus's tree? It's not in 6.12 (yet?).
> It may be worth backporting 0938b1614 to the stable tree, but it's
> beyond my pay grade.

I'll be glad to take it if someone says it is ok to do so (we need an
ack from mm developers to take anything they don't explicitly tag for
stable trees.)

thanks,

greg k-h
