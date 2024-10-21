Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE84819939E;
	Mon, 21 Oct 2024 16:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729529880; cv=none; b=Qeptc3J98Jp7QF86D1ooHqI0sS2dFtsPO3mgVWwYUsYsDzOC2OiMwYzO1cfZNsAlPY6gZkMlmM0gmz0yW4JWdcnbHu8LhbVBb8JB22LjildgSMF1jaAoyiJ15kM0qVJ+Ok7jDAOozBFiwhj5E0dfK2VVxWXCF2CxxkpZJgXO1vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729529880; c=relaxed/simple;
	bh=OJcLM7T921y1T5TCeSZBnjnyS17/aLOym6hqQBcpEKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RQkbweO7d4sHzmKK9u0oCx24ai/2UIIgkSmbzaMGjX/zJKYYyPrxQ8ZVkaJnJF5UngO460wxGUa6c8Obbww6uEdGUmDKuknpH3QZUv2sM8+AbuTC4wIb/UMkRxaPvMK+K9Cgi4KT8vK5KPUG3cZbBRmuna1ou46XhRxfZnhXiQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ss4cr2Uz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ss4cr2Uz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1293C4CEC3;
	Mon, 21 Oct 2024 16:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729529880;
	bh=OJcLM7T921y1T5TCeSZBnjnyS17/aLOym6hqQBcpEKc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ss4cr2Uz5SeSiEN8pZte0xbI8OjJPQjRcts8KqAzdEKxtmlCaV56ww0n1cJsK49Dm
	 v4F9SNdMrRzu3SEDYYjWEXb6J32KGQbRsHDSxW1rvVo+pcj+CPxD3TY0owI6Zr8pab
	 B4YBq9GOoqljlkKO2OSVgmLdpbENHEUEG/jGMyeE=
Date: Mon, 21 Oct 2024 18:57:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.11 024/135] lib: alloc_tag_module_unload must wait for
 pending kfree_rcu calls
Message-ID: <2024102130-tweet-wheat-0e55@gregkh>
References: <20241021102259.324175287@linuxfoundation.org>
 <20241021102300.282974151@linuxfoundation.org>
 <a4163f51-cc1a-0848-d0fd-e9b94dafc306@candelatech.com>
 <ZxZ_uX0e1iEKZMk5@pc636>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxZ_uX0e1iEKZMk5@pc636>

On Mon, Oct 21, 2024 at 06:22:17PM +0200, Uladzislau Rezki wrote:
> On Mon, Oct 21, 2024 at 09:16:43AM -0700, Ben Greear wrote:
> > On 10/21/24 03:23, Greg Kroah-Hartman wrote:
> > > 6.11-stable review patch.  If anyone has any objections, please let me know.
> > 
> > This won't compile in my 6.11 tree (as of last week), I think it needs more
> > upstream patches and/or a different work-around.
> > 
> > Possibly that has already been backported into 6.11 stable and I just haven't
> > seen it yet.
> > 
> Right. The kvfree_rcu_barrier() will appear starting from 6.12 kernel.

Ick, how is it building on all of my tests?  What config option am I
missing?

thanks,

greg k-h
