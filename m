Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5435B59544;
	Thu, 30 Nov 2023 23:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i1n159ZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A81C433C7;
	Thu, 30 Nov 2023 23:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1701387509;
	bh=w52d0r50Yf+zo2A4/TXeraQkWvCyUTlhrY+nz36LfGs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=i1n159ZASs9dm20iwbPJtx5xoshF69CkmCjS5ih4vv+vKJKoMMlOOlJKkoDP2/JSw
	 Tl9+asyhBoQZw/aK/1TvqbaiOQHqF3h3xsj51aZzL9X/ekT5k14WlHJNiLtl28u6qQ
	 H/t3X8YUelge1kex3/iJHM2gUGPUpvX9RSubxqos=
Date: Thu, 30 Nov 2023 15:38:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: bcain@quicinc.com, arnd@arndb.de, linux-hexagon@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 00/19] hexagon: Fix up instances of -Wmissing-prototypes
Message-Id: <20231130153829.5f33c1bf08a7fcf1c407a52d@linux-foundation.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 30 Nov 2023 15:58:13 -0700 Nathan Chancellor <nathan@kernel.org> wrote:

> This series fixes all the instances of -Wmissing-prototypes in
> arch/hexagon, now that it is enabled globally in a default build. I hope
> most of the patches will be uncontroversial but please let me know
> otherwise. This survives ARCH=hexagon defconfig and allmodconfig with
> LLVM 17.0.6.
> 
> This is based on Arnd's asm-generic-prototypes branch but it applies
> cleanly to 6.7-rc3 as well, in case Andrew wants to take it (as far as
> I remember, he has handled Hexagon patches for me in the past).

Thanks.  I added this to mm.git's mm-nonmm-unstable branch.

It precedes Arnd's "Makefile.extrawarn: turn on missing-prototypes
globally" so everything lands nicely without bisection issues.
