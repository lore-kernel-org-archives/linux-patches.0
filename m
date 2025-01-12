Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFF01E4AB;
	Sun, 12 Jan 2025 10:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736676226; cv=none; b=gBjbKxqtVApjXmRr07YFNm1wmJRqAaDcm5e00ludMXa3vSfjX7Itg8flw+WpI8O81Oq+OOco0NvYc/wk+DKcCR12jYayKH8zn1Uovuec6VbXVKKya+fB2rf+SQ+tPLYeUcYvDUjUXADOowlXVa9ua9Z7dKF7m6NqgvEq2lhZ/Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736676226; c=relaxed/simple;
	bh=MgVHksWtkfakzbdoTyUz8P0cfqvMXubttfvo2tq0+20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CT41IvmwTqufAqjOFh6Y0CnsphTBYufIYah49bLHLTbQ7ltQrJKqWW/Iz0/epaRIodDZqKU5yf3u78euGYmo/b/05b/sCtlYT3svb70SWdeBJNwrPHCW46F6Fj6/irvziRkTfUS0zIjhzuPlfW99uTFihYxZKKRro0URcFBZ7vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+U6toiu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+U6toiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF14DC4CEDF;
	Sun, 12 Jan 2025 10:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736676225;
	bh=MgVHksWtkfakzbdoTyUz8P0cfqvMXubttfvo2tq0+20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h+U6toiuU3Z2OvJm0c2tIfA4+YAvnI7ObbQ5PauXcjcHhKhsf2dK8Q83G39Lxivso
	 ROC3mO/mdopeoexc4lLZGiWXc8OPMfGsCojVa/2ahJ84qxzTGcmc/MymNEBnuL9qic
	 6c+twmESPDrcVMoDVzuu569ggrtvS551cGrYpUAA=
Date: Sun, 12 Jan 2025 11:03:42 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 0/3] ZRAM not releasing backing device backport
Message-ID: <2025011201-scorebook-kebab-2288@gregkh>
References: <20250110075844.1173719-1-dominique.martinet@atmark-techno.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110075844.1173719-1-dominique.martinet@atmark-techno.com>

On Fri, Jan 10, 2025 at 04:58:41PM +0900, Dominique Martinet wrote:
> This is a resend of the patchset discussed here[1] for the 5.15 tree.
> 
> [1] https://lore.kernel.org/r/2025011052-backpedal-coat-2fec@gregkh
> 
> I've picked the "do not keep dangling zcomp pointer" patch from the
> linux-rc tree at the time, so kept Sasha's SOB and added mine on top
> -- please let me know if it wasn't appropriate.

It's tricky to know, I dropped it and took what was in Linus's tree as
Sasha didn't actually review this one.

All now queued up, thanks!

greg k-h
