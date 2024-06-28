Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CE71DDCE;
	Fri, 28 Jun 2024 15:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719590322; cv=none; b=HpqztHRvvcz82xPFyqaBVgMjQ4uhxrkA31brTi/GCjitr8g2PufXp4RJIXxGvv4Ys/y4cC9JTloolh996qAxsJ4MFiRQd0cc/mHiJ50oUVAYbludWE+smhrbxOZ5UhDVYd9nvAWQTkIAvokHw4Id9J9X0/oMjGwsCVtTt/OSR8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719590322; c=relaxed/simple;
	bh=f/e4U8iAuP+2TmfcKdxe7mT1z7tLie+Lb2MQm83FeRE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t2ZicU54lN8TjCzCiXANfYSRWSu8pcvFGUwHsNg1FeJCJnDvYwo/tfP+EvFxkn15EWXw+pvsqpX5FQRVQKScyP0OZv4zvl17Sq94VTf6TeFn4MaBL1uuiHcqCcWOLRjgYqDndSNMTcl0D5j+34Qqp1bfHgVdKypHF7DrwL9/HcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c4+Nw2Pj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c4+Nw2Pj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C906C116B1;
	Fri, 28 Jun 2024 15:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719590322;
	bh=f/e4U8iAuP+2TmfcKdxe7mT1z7tLie+Lb2MQm83FeRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4+Nw2PjtC6C8bWhaLxBPpyO6vQ9boOxSB/6VrfhUazxEfJu/+HOZuscLns+tfZLI
	 TPA9wanTng9zSvzPG2MdLqVC3ohD+/AyEzLDZEKuLwzwIujddV13SecOQh+OwmjYWU
	 tQ4o0wvqLBbiRemJYX3mZWT/oWVRf87aSxobcb5z4WXCUKPP+BjTmFYTg2Zyr8VXPJ
	 G9jo/upSz85dClRRY+S7u2xLC74CdDoATU1XFDD603X7F7vGhurRSx2a9yp17CF/eq
	 XWE+BkO8PUmLCXv0L/jQKc71Oa47S79iTKiz5SBesf2Hdg7HFy5ChGpZl0WY98AzKo
	 zgL+3Mu1fcYoA==
From: Kees Cook <kees@kernel.org>
To: Jiri Slaby <jirislaby@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Nathan Chancellor <nathan@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-serial@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] tty: mxser: Remove __counted_by from mxser_board.ports[]
Date: Fri, 28 Jun 2024 08:58:34 -0700
Message-Id: <171959031201.3280156.13125871408921524311.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240529-drop-counted-by-ports-mxser-board-v1-1-0ab217f4da6d@kernel.org>
References: <20240529-drop-counted-by-ports-mxser-board-v1-1-0ab217f4da6d@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 29 May 2024 14:29:42 -0700, Nathan Chancellor wrote:
> Work for __counted_by on generic pointers in structures (not just
> flexible array members) has started landing in Clang 19 (current tip of
> tree). During the development of this feature, a restriction was added
> to __counted_by to prevent the flexible array member's element type from
> including a flexible array member itself such as:
> 
>   struct foo {
>     int count;
>     char buf[];
>   };
> 
> [...]

Applied to for-linus/hardening, thanks!

[1/1] tty: mxser: Remove __counted_by from mxser_board.ports[]
      https://git.kernel.org/kees/c/1c07c9be87dd

Take care,

-- 
Kees Cook

