Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E6B362;
	Sun, 22 Oct 2023 07:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LFdy/Hb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EFEC433C7;
	Sun, 22 Oct 2023 07:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1697959959;
	bh=fHG4TaMUd7HGuQQYQrNguovNk6O76d5irTKRQs97D9c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=LFdy/Hb2XmwN9zLKA+ALFGtWIzbshRB3gZkeBWgs9/Ja7kho1WVnyMUMHKIGXt5ui
	 k02p/mIT0hcUgXDwXfi2+ZxNZdFm2pWgUDU1Zao6+04aJxz1DnFEOiSvfWSslJFBbo
	 ZyvOLiaekukVGEqvWmwClqHR7pL6VtPOvzS/EQ6ic9or+vjQ7I1V3W2R7EWgEqhiFj
	 ptXY2DjBxa72anz3uYYmrAP87A0gseXbaM5j3ika7IS+8fX3AdN2GepfGW2T7wz58N
	 8gLN6xcutMHwpJaVOQqMeiLgwDw/1LYJ6cnBE/L5/xhHIOnjok4kUV24bODmcuJCF+
	 fQ+BqNze7nUgg==
From: Leon Romanovsky <leon@kernel.org>
To: selvin.xavier@broadcom.com, jgg@ziepe.ca,
 Nathan Chancellor <nathan@kernel.org>
Cc: ndesaulniers@google.com, trix@redhat.com, chandramohan.akula@broadcom.com,
 linux-rdma@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
In-Reply-To:
 <20231020-bnxt_re-implicit-fallthrough-v1-1-b5c19534a6c9@kernel.org>
References:
 <20231020-bnxt_re-implicit-fallthrough-v1-1-b5c19534a6c9@kernel.org>
Subject: Re: [PATCH] RDMA/bnxt_re: Fix clang -Wimplicit-fallthrough in
 bnxt_re_handle_cq_async_error()
Message-Id: <169795995500.45770.3213574948546186734.b4-ty@kernel.org>
Date: Sun, 22 Oct 2023 10:32:35 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d


On Fri, 20 Oct 2023 15:17:02 -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y):
> 
>   drivers/infiniband/hw/bnxt_re/main.c:1114:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
>    1114 |         default:
>         |         ^
>   drivers/infiniband/hw/bnxt_re/main.c:1114:2: note: insert 'break;' to avoid fall-through
>    1114 |         default:
>         |         ^
>         |         break;
>   1 error generated.
> 
> [...]

Applied, thanks!

[1/1] RDMA/bnxt_re: Fix clang -Wimplicit-fallthrough in bnxt_re_handle_cq_async_error()
      https://git.kernel.org/rdma/rdma/c/9040c0d96fd66e

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
