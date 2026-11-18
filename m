Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027338;
	b=xAQrdXnYaa4aJj/zpEttREGcYG2BvcM+g6o4IY5ESPgkZGY7lvRwoGh66R0r0s7k8vXE
	 xeCrkTqDDxDoudFkuCpHmOOLCjsBObcohSu1eQXcQMtQBJ0U0MRVWJuWRTzyoDprf6huw
	 u1lUzfhl/hBXBNKsnmDW5bC5OjZJShhmMdyaO7qGka4b/jZ9lAHFoai9t8iXnzeQ8+EyV
	 co4XQ6v8grAuiusGZJBr0z4S2Wlhv1nj1t8Tv0RJ0uBDrXYvQs5weypnwYY75pOuftEsk
	 SMpUrMdA4v7PpXjpqcQsPWsu0hzD2Ul0cUgMzgG7EfNa5sU+IutOsIoDQLB+/qjWfig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2w9DH4ykW8WS7GOSt6qMoX60sAitP+5ZVgznEqFnxKw=;
	b=E319gpCqYdoFOSH34wegy/2yg7fi84kJDo5xMNES+4MDIkr2SZh3opYN5jYDh+g2AGJW
	 Bi/O4dx/0YlvGGlubYi7YnLzCeVllEtgIgjh97S6VjCZAy6UGjBam2NVVjTeQptBzzk2h
	 HpBNXcwwKfCIbatAPgwYHllNMyxvZQnEiqkB3oZn2qeul7c4i8GonCGqcNbvspplB6CGU
	 7osYxcWPUeUrOHRwGXozU4iXYWzJBAhlCPHNE3v+twIOUoOjt+jEm9oshNWlM7f/8ET1E
	 Lzf9+6gdeanH2cfDY/Esi1hyvdDksnyrByHI9PtPUU6bdc9OCDsorv1bXp+B7B3nCMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UhYc8MhY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D551E60A2610;
	Wed, 18 Nov 2026 18:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UhYc8MhY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DAA1F000C4;
	Wed, 18 Nov 2026 18:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027338;
	bh=2w9DH4ykW8WS7GOSt6qMoX60sAitP+5ZVgznEqFnxKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UhYc8MhYrGDxzgBYoShf4zZ+RJX2u+AUpV1EffoD9GGfytmVGvoVKRhbgaIDmMKfG
	 vrt+qbqLtaNmcVsLt/As0/FJKUjW6FpqwkzF9hqcDXXpS+RNr8Zc93T7CWHTAOhLZo
	 QzLd+5KFvl4p9gJVVdU5GnncAF8E4AoOiJqdEH34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1754/2151] RDMA/srp: Avoid reading uninitialized has_port on srp_parse_in() failure
Date: Wed, 18 Nov 2026 15:58:09 +0100
Message-ID: <20261118150225.745678289@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serhat Kumral <serhatkumral1@gmail.com>

[ Upstream commit 4b8f20dc8d25f575e8b8bb5abb09ab803a7e1a3f ]

srp_parse_in() returns -ENOMEM without initializing *has_port if
kstrdup() fails. Only check has_port when srp_parse_in() succeeds.

Fixes: bcef5b721568 ("RDMA/srp: Accept again source addresses that do not have a port number")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Link: https://patch.msgid.link/20261016211509.12973-1-serhatkumral1@gmail.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 0397934b1bcbb..2261a62b84cfd 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3479,7 +3479,7 @@ static int srp_parse_options(struct net *net, const char *buf,
 			}
 			ret = srp_parse_in(net, &target->rdma_cm.dst.ss, p,
 					   &has_port);
-			if (!has_port)
+			if (ret == 0 && !has_port)
 				ret = -EINVAL;
 			if (ret < 0) {
 				pr_warn("bad dest parameter '%s'\n", p);
-- 
2.53.0



