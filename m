Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A0E18872A;
	Wed, 17 Jun 2026 03:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781666148; cv=none; b=Bk+ogDG8d369wA+ag/Y6mJDmo1qRg6lgNKKrcGv/d7qGpeLEf6B8H25c0FlfPM/YHZdKrl79ds8UOzL7il5An1UjrjenBorCYqgqkkezlmDWJOmTw/BLSEaBdnYgTo9amVKRZ7QaPNvL/lxR0u0cYsON0ecWTzJzXfFPvQaisNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781666148; c=relaxed/simple;
	bh=BJxMgaJXgouj5zGh9dh2J7oHbtUDdbZpJ3CxO7htx/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mAsju66YKgMvBARQF6mOh6TSVIHyxMDO6CasnL+QkvwLzPsRL1IGox+FwE7HHfO3O/nO8BaIOOKMSiuRgA9wIrKATNEFG2EFoZiuVLhWwXKdhv7xGORWxD7D0rl4rBbSjMTbYWwgqy+kh5az61eNOYMLr84AxpLzD7ipSCBVEsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqUZ0PXU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqUZ0PXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6811F000E9;
	Wed, 17 Jun 2026 03:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781666146;
	bh=tWH+vKDhOqk082ZzJdPzM8fKcwQ8biGlnRZlqoX9AK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=sqUZ0PXU5kC4xo4JYdp34NIqnXwIA6skd8qZAzk6hu37GRV/4EjdoH3aMk8WpsKzv
	 I2s44/pZBcFO6O0xpAKI10ijFRR0UXYTishx9NZOoK3ndMUoMTBwzJLHwQuKfspF9d
	 1k5dot/L6+XrQcRt0ifkIsFmhC103dnXW31/3uw8=
Date: Wed, 17 Jun 2026 08:44:41 +0530
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 011/522] tools/bootconfig: Cleanup bootconfig footer
 size calculations
Message-ID: <2026061731-stadium-backer-bcc6@gregkh>
References: <20260616145125.307082728@linuxfoundation.org>
 <20260616145125.946340231@linuxfoundation.org>
 <9125d5976feb09ef919f2a287b079843c7671325.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9125d5976feb09ef919f2a287b079843c7671325.camel@decadent.org.uk>

On Tue, Jun 16, 2026 at 11:06:49PM +0200, Ben Hutchings wrote:
> On Tue, 2026-06-16 at 20:22 +0530, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> > 
> > [ Upstream commit 26dda57695090e05c1a99c3e8f802f862d1ac474 ]
> > 
> > There are many same pattern of 8 + BOOTCONFIG_MAGIC_LEN for calculating
> > the size of bootconfig footer. Use BOOTCONFIG_FOOTER_SIZE macro to
> > clean up those magic numbers.
> [...]
> 
> This causes a regression in some configurations, fixed by commit
> 729dc340a4ed "bootconfig: Fix negative seeks on 32-bit with LFS
> enabled".

Ah, missed that, now queued up, thanks.

greg k-h
