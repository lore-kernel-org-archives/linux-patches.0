Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794076330;
	b=QvjvnF/2wTV70zEqiVkvKHpKcnpEm4nzhEAWMqDbxaieHscUbgKBC4DkesZ9JCtxm7Ow
	 d+IhSnpH57ohXgtGPwqpQkHU36DvpTSlMD8/U6XUVIByvmWDHNPpSkcikD5U+pLOQogdi
	 JMYcxTMqhnQTIXlSLC+L32dkLcJdRj8iztgDJllB57KIcQ6Q1pTaExGL2oFuAOPAxdMyf
	 2CXLTXP+U3w30N4ce5aRgX6DmgP/+tdubUWSKZd+ffTBfZsyhkZn+uGOb8J0jd2O7Tuz4
	 t7ABgQ2q73IeaJcU6oPVxqyz5jaw1NJ3AikzcyiwHRyeNxyvWCngIHu249vCWJH+CkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794076330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=I5WBhDYjSPXvoHDXSLP4PU4c/heeUu6oD6Q6bomZbfY=;
	b=ZuP3MkGpyBmBZV5gBDKmoQpo/iTt9ed2grorUAn30TMUfUSgYmGYVb1jRCjm7/l0yirm
	 ZySN7GXutb2e/2+RKwfw00yZkG53Is6DMnMA77LYPJT69cye/Vx+h2A6Y4jz4Sp2pbnjo
	 cDFvTC0gEB6bhTPCFFjFFoqrtpQd8g4cuybbKzSxSxfMxs+XokgvB1NRZbewU6aSAk3ql
	 I2VMQp9842d2jV8cTWZ6xFxYxY5frlIaVGccUm2H4JliL1ubO52h9MR/u+O7+7MRtZvyQ
	 v/gnIU+HNJkJ1Gwx/JeRU/5hQnu3J6rdy6oOkU3Z2qyZJBoJTV3DnLG091bBwIcx67Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YBjlA1DM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3A4606A326;
	Sat,  7 Nov 2026 18:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YBjlA1DM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83FE1F0089F;
	Sat,  7 Nov 2026 18:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794076330;
	bh=I5WBhDYjSPXvoHDXSLP4PU4c/heeUu6oD6Q6bomZbfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YBjlA1DMxdS+hZU/5ZRtiZP5hm3RMpANBVRBE8iuALrZv2Z6UpXntUdyxkh92x0Hy
	 zx9WYHbE+iqmvdMwcZMPxgrQz6L5g5ltFjvuBEqlr02Q62d3S0p8OiLbgdUlcYvXVL
	 UgIfsOTupu+p5Uw656LPolny4r9xpDb5XHWy0V9M89P70qeYEsHD26hJBedLgxr7UZ
	 5R7gYdQ5n76l7dxfWyeVATs0fM1+1BLVw6LdrUdGtT1auWTF06sP/z8gJGha7VoxXt
	 eXQvpDMN8YwYAJ+JB69tRzl/0lbrRnxr/ak19F3Be+IZEP6MbypXCUtmk8HbUINKKP
	 Lo7/iHCb3rFaA==
From: SJ Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.3 0655/1257] mm/damon/core-kunit: test invalid damos filter commits
Date: Sat,  7 Nov 2026 10:32:02 -0800
Message-ID: <20261107183202.177477-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107134957.352235224@linuxfoundation.org>
References: 
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg,

On Sat, 7 Nov 2026 08:49:11 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> 7.3-stable review patch.  If anyone has any objections, please let me know.

TL;DR: Please drop this.  It has wrong Cc: stable@ tag.

> 
> ------------------
> 
> From: SJ Park <sj@kernel.org>
> 
> [ Upstream commit 409d2ab6d98209c30d45123920721710475a30b4 ]
> 
> Add test cases for testing the validation of damos filter arguments in
> commit time.

This patch is for testing commit 1bfb9384ae0e ("mm/damon/core: disallow max <
min damos filter range arguments commit"), which does not exist in 7.3.y.
Hence this patch is making DAMON kunit fails.

> 
> Link: https://lore.kernel.org/20260914142327.92510-9-sj@kernel.org
> Signed-off-by: SJ Park <sj@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Brendan Higgins <brendan.higgins@linux.dev>
> Cc: David Gow <davidgow@davidgow.net>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Cc: <stable@vger.kernel.org>

I didn't intend this to be applied to stable@.  My original patch [1] hence
doesn't have Cc: stable@.  But I show Cc: stable@ tag in the upstream commit.
Seems Andrew added Cc: stable@ while applying it to mm.git and I missed it.
Sorry for not catching this early.

So, this patch is not really meant to be picked into stable@, and only causing
the kunit failure.  Could you please drop this?

[1] https://lore.kernel.org/20260914142327.92510-9-sj@kernel.org


Thanks,
SJ

[...]
