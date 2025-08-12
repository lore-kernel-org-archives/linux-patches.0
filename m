Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F9E279915;
	Tue, 12 Aug 2025 17:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020969; cv=none; b=A2+KjVCVMaOUFGlqzukKaZYQR9tCIiA+JTLXt9X0j7PYVwjDOgvunM9HSmUFxEN3uQe6gpXh+J4GHOYEssQvIt2CJIH7K9Qd0uGf8PdBG5OHIbWPgKJoPd4NfUez0vR7CiU2zDcv+IBb0YPe6IIonaVgbD/aePq6KVxKcygKJaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020969; c=relaxed/simple;
	bh=+wuPU98U4ApXAIQZV2YoJqPKOl4g+Ig86Ywkj7EZ/W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loFQDTkP6dKRKRN6zcxbRz8x8JUj6a9VQLVuYe7zC347pgZEk+vcnXSw4yX1rF7NxE1n/wEgXc/FaaNQH7xrLMjRnbTyPmnaIjhfx1XeLIN8VsiTMeO2aSBQpYaEsVFnVifOyPBLAqnhpZzEQjXUtXf61W2AMGQDxCF9xJ9EQJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xqxm0Tkg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xqxm0Tkg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D89C4CEF1;
	Tue, 12 Aug 2025 17:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020969;
	bh=+wuPU98U4ApXAIQZV2YoJqPKOl4g+Ig86Ywkj7EZ/W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xqxm0TkgZzLTxnY1Vc6SG/gi23F7l2t3AfS/CuCIdBRrwjya+tTgfhlg7hDTLo6JW
	 E3VRA3JtzNuAM/whUr+gyw5+gBzOKtEWDcimUvlDHllFAclnMr7fdGDNU85vR17Yma
	 qd73N9Hnt8hXYZU7QWZpiKEYtJ1N3+knt32/lcnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/262] interconnect: qcom: sc8280xp: specify num_links for qnm_a1noc_cfg
Date: Tue, 12 Aug 2025 19:27:12 +0200
Message-ID: <20250812172954.843053195@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 02ee375506dceb7d32007821a2bff31504d64b99 ]

The qnm_a1noc_cfg declaration didn't include .num_links definition, fix
it.

Fixes: f29dabda7917 ("interconnect: qcom: Add SC8280XP interconnect provider")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250704-rework-icc-v2-1-875fac996ef5@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sc8280xp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sc8280xp.c b/drivers/interconnect/qcom/sc8280xp.c
index 0270f6c64481..c646cdf8a19b 100644
--- a/drivers/interconnect/qcom/sc8280xp.c
+++ b/drivers/interconnect/qcom/sc8280xp.c
@@ -48,6 +48,7 @@ static struct qcom_icc_node qnm_a1noc_cfg = {
 	.id = SC8280XP_MASTER_A1NOC_CFG,
 	.channels = 1,
 	.buswidth = 4,
+	.num_links = 1,
 	.links = { SC8280XP_SLAVE_SERVICE_A1NOC },
 };
 
-- 
2.39.5



