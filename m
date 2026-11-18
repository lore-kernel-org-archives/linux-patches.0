Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033774;
	b=xtK2dV7x4apXyH2txYtl7Gx1Os7w89dBMavKBLM6fGMje4NRxAn7URSLsAK6aoBTWTrB
	 KH8Krq/yRxaEeA3hzfl8JxtB9WvI5kPxlePui4WO1EbsezQGkFp04/hSzdF66vR40zMBG
	 HUxsFJkQBx3L+MMEJjtIvEbqe+3wZsZMhmigO7coubvZXL5cWE2if2bk8F0KwlNtRCHes
	 ZhBvvvkybr2e8JZxmzdQh5GNQcqnahqfPw9/XY/uKS88nyOIdlQza3RwVZ9W0/AVuX7E3
	 ZbDPhegcatxdHf+u2Wrkyf7k1Z4VMfeVJKGzhoAyJQdbkZ8X9W+CL+M/3yAH/OcvmSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZOC7qGX8zoZoMNNO2fUa6E6xlbIbnccaPUYLx2FlTe8=;
	b=FAAooNO9C9Cb58O8k7GtLTHnC5ePRBYAahaJxzP1t/ctkaxGUC1CqM+oRpsygyrbk1TO
	 RbQKBwd1LVTIE0IJ2Pdl9ZCCg/DfP9CgY7pozlgPU8/GCgWZ+V3qZI42e3BH1z/aTa1bK
	 VYveb7gOLIu7wXy9wB/aMinscxgT9isJrfF3YV0c1AbZ12Y8DHCAoJ5+05lq/aQoQbr8R
	 eWbuwV0UocJVWLOn+Qr1rEGlNmqLbuRmcOcUFYlCSUW/bgmicM8eQWtAnEhNv4S18LHlN
	 8Rh1cirjuxZgP/KsvxzNTw3jdS/X9UCtDKKf8M/uiMuNgXhuwX0uOMBj+F3GgUYmY5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CB10S8Cf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83D4606A31C;
	Wed, 18 Nov 2026 20:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CB10S8Cf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223921F000C4;
	Wed, 18 Nov 2026 20:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033774;
	bh=ZOC7qGX8zoZoMNNO2fUa6E6xlbIbnccaPUYLx2FlTe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CB10S8CfFXMe10dV0IEPrymysAmQhjr2oO8lnV/bop1ufsddT9qcqpgV1UvlkzeRE
	 CgwcwNJIcWe3q22wQl3ma0rRj/6b2OVftALXKydFo/CEpxLLUx/JNu/9WuXTJlQodO
	 p1fU80CKolvb3Et628CgslP1xbaLl/HiIOK3ZeUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0134/3318] misc: genwqe: handle a first DMA address of zero
Date: Wed, 18 Nov 2026 15:12:36 +0100
Message-ID: <20261118150318.435632403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit d401772a9e18e837631450844f835229354528a4 ]

genwqe_setup_sgl() uses zero as the initial previous DMA address. DMA
address zero is valid, so a first entry at that address enters the
merge path before last_s has been assigned and dereferences NULL.

Only merge adjacent mappings after an SGL data entry has been created.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260630104923.53827-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/genwqe/card_utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
index 1c798d6b2dfb1..520ebfcf6fee3 100644
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -413,7 +413,7 @@ int genwqe_setup_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl,
 			size -= size_to_map;
 			map_offs = 0;
 
-			if (prev_daddr == daddr) {
+			if (last_s && prev_daddr == daddr) {
 				u32 prev_len = be32_to_cpu(last_s->len);
 
 				/* pr_info("daddr combining: "
-- 
2.53.0



