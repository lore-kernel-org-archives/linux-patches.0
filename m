Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283742C859;
	Mon,  6 Nov 2023 21:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tra7q/wC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D684CC433C7;
	Mon,  6 Nov 2023 21:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699306450;
	bh=lg8M4ZU0WKeEUMti2afp6mI1H9am+64JDctsVPEWQ3M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tra7q/wC7sAJllKQsTDPF/BYwJ6aPrtzVwacWSwuJzOpq/qmotoFcWxnOMpEWg4RW
	 cqK72ElIXTi2lc2nWkoCKVHCS/0uTzrlnrkdxJFhOJFs9sSgRvC2gpgD8aLxc3sUuR
	 TtQ810xKB7lOSdTyS/8aTRmXCyEXVdLV0+Wf0G/zoMpCZaUiGC6Ix4OIIkCxYcvQLv
	 i2mq050hio1bLfRN12aKVHObKH1KRUUIwnFHAwgq1fNEVem9+IPO2+acSP8N5XR+uO
	 i0TZIqnYHGIvhkXgwIAfi7jyHzJzSIvX+Ot7i1Nj1PMmNSXBSp1ju6EpP/7U+HzkyS
	 ihY3sjoc7LjKA==
Date: Mon, 6 Nov 2023 14:34:08 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Dmitry Safonov <dima@arista.com>
Cc: ndesaulniers@google.com, trix@redhat.com, noureddine@arista.com,
	hch@infradead.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, edumazet@google.com, davem@davemloft.net,
	dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net v3] tcp: Fix -Wc23-extensions in tcp_options_write()
Message-ID: <20231106213408.GA1841794@dev-arch.thelio-3990X>
References: <20231106-tcp-ao-fix-label-in-compound-statement-warning-v3-1-b54a64602a85@kernel.org>
 <a8cc305d-0ab8-4ff7-b11a-94f51f33ec92@arista.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8cc305d-0ab8-4ff7-b11a-94f51f33ec92@arista.com>

On Mon, Nov 06, 2023 at 09:26:48PM +0000, Dmitry Safonov wrote:
> Seems like exactly the fix that my git testing tree had, with an
> exception to naming the helper tcp_ao_options_write().

Heh, not sure why I never considered that as an option... I am guessing
it does not matter enough for a v4 at this point but I could send a
net-next change later to update it if you so desire!

> But then I found* your patch-v1 and decided not to send an alternative
> patch.
> 
> Thanks for fixing this,

Thanks for taking a look!

> Reviewed-by: Dmitry Safonov <dima@arista.com>
> 
> *had to fix my Gmail lkml filter to label not only emails with cc/to my
> name, but also the raw email address (usually, I got them to/cc "Dmitry
> Safonov", but this one didn't have the name and got lost in the lkml pile).

Sorry about that, b4 used to have some interesting behavior around names
at one point (don't remember the details at the moment) and just using
emails avoided those issues. Maybe I should go back to names and emails
to see if I notice any problems again.

Cheers,
Nathan
