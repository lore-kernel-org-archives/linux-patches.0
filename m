Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84391B6541;
	Thu, 29 Aug 2024 17:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724954061; cv=none; b=DqjfxVsGiPR8YNIOlvPgRjV/7BWeYmmYQLa+sRUDdkbqZOY7fhgjQqRpYjVaBm5MUneJWAXr2ZAQgevLDQN0N5jmiagz6UzkDWZ6GgYtOPhv2NPzH5R5GavDp1+TM8W9kUQ+kpYbOFnc90LAFgML9yDoNvN4YsYY31n9ISc9ybM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724954061; c=relaxed/simple;
	bh=Cv8MmMBWcGvz3OY7f8d0fsXzks/ivKkfdUsNqgrItfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IdTodVwxL947R+gjZPL+KbSon5gXMGAPCVpnM1zccDSVDR9GbTzTdp6VKWooDyBUHBwlrn+SlPqS8cmOkNEs0m5XHhR/vN5oC1hO70FmJvc510umXvE/W9POvYnhViLSn7ahkQd0x+MJ9VMkzqjxRjfF/cVeeqNK1c4u5mekSBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sjjLX-0005oq-OD; Thu, 29 Aug 2024 19:54:11 +0200
Date: Thu, 29 Aug 2024 19:54:11 +0200
From: Florian Westphal <fw@strlen.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] xfrm: policy: Restore dir assignment in
 xfrm_hash_rebuild()
Message-ID: <20240829175411.GA22324@breakpoint.cc>
References: <20240829-xfrm-restore-dir-assign-xfrm_hash_rebuild-v1-1-a200865497b1@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829-xfrm-restore-dir-assign-xfrm_hash_rebuild-v1-1-a200865497b1@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Nathan Chancellor <nathan@kernel.org> wrote:
> Clang warns (or errors with CONFIG_WERROR):
> 
>   net/xfrm/xfrm_policy.c:1286:8: error: variable 'dir' is uninitialized when used here [-Werror,-Wuninitialized]
>    1286 |                 if ((dir & XFRM_POLICY_MASK) == XFRM_POLICY_OUT) {
>         |                      ^~~
>   net/xfrm/xfrm_policy.c:1257:9: note: initialize the variable 'dir' to silence this warning
>    1257 |         int dir;
>         |                ^
>         |                 = 0
>   1 error generated.

Ugh, my bad.

Acked-by: Florian Westphal <fw@strlen.de>
