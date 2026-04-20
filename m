Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F7049691D;
	Mon, 20 Apr 2026 13:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691957; cv=none; b=TkOVAgIoawOGDRFQmn59bU5U0rCeqNmRxua8HsdmgrZRQplOcdkb6PkkAfQGz9rXhZlr76lVw0v3lVgRstcjqu7CxTly163o0vU3XsXEzuPTM6T3sIZND5ajtP2Mgb2R37BfykKrPiuaktpMIU4gSFPHfKg0Hxhj4OC+d1Bi2Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691957; c=relaxed/simple;
	bh=yqcxUtB/nKOk115s5moCJVayDci/jQHuuFf6AK0cv5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixlN7AM6NFP7f7MiwTTlXX95Q2Sh1PkSWVB5LaRZIn+a1/J2V3zNyBdwBWpja5LUVD3ZVyBN0z3rEAAkExLvnBVcdhpI/KTvYC7G+mK2ndx6hf4q1+TTUT6yXmPW2vP3uYvjLPB4qWABT3ogapDNpcma3mvtu+RdcJo1zsXMJWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rc0qW+pS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rc0qW+pS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FF2C19425;
	Mon, 20 Apr 2026 13:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691957;
	bh=yqcxUtB/nKOk115s5moCJVayDci/jQHuuFf6AK0cv5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rc0qW+pS9mFqbrstcnJyZLs0gRmqweLgCV8axu2FZb3SKeD6EQ6mQWyCRd+nAURxK
	 YykNRYCVK80jGSxSa8f2uXt8BksaEvoPWn9AF1KlsitU/+uxPrV11JNpUmftMxHx4C
	 aOzoG58XcVyxyj8jMmtZXCJQUVFc5i3HI5EO/Ly+4qj7qLIefvKcGqyFccl8Oz68QR
	 RKXgvHlIfWvGkWHiENvXjF+pCeiRqeT0vU+5SmPMhCB9pcGoOlmZFS03orcovOLOyU
	 k9gaU5iiBP+sQMk1YVONKJ649cZmgnoMbvHjLdH0D0rdNXERvxTjqkAOzbnYC/x4eY
	 Av/HRhN1C4WFw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexander Koskovich <akoskovich@pm.me>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: ipa: fix GENERIC_CMD register field masks for IPA v5.0+
Date: Mon, 20 Apr 2026 09:21:24 -0400
Message-ID: <20260420132314.1023554-290-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Alexander Koskovich <akoskovich@pm.me>

[ Upstream commit 9709b56d908acc120fe8b4ae250b3c9d749ea832 ]

Fix the field masks to match the hardware layout documented in
downstream GSI (GSI_V3_0_EE_n_GSI_EE_GENERIC_CMD_*).

Notably this fixes a WARN I was seeing when I tried to send "stop"
to the MPSS remoteproc while IPA was up.

Fixes: faf0678ec8a0 ("net: ipa: add IPA v5.0 GSI register definitions")
Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260403-milos-ipa-v1-1-01e9e4e03d3e@fairphone.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/net/ipa/reg/gsi_reg-v5.0.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/reg/gsi_reg-v5.0.c b/drivers/net/ipa/reg/gsi_reg-v5.0.c
index 36d1e65df71bb..3334d8e20ad28 100644
--- a/drivers/net/ipa/reg/gsi_reg-v5.0.c
+++ b/drivers/net/ipa/reg/gsi_reg-v5.0.c
@@ -156,9 +156,10 @@ REG_FIELDS(EV_CH_CMD, ev_ch_cmd, 0x00025010 + 0x12000 * GSI_EE_AP);
 
 static const u32 reg_generic_cmd_fmask[] = {
 	[GENERIC_OPCODE]				= GENMASK(4, 0),
-	[GENERIC_CHID]					= GENMASK(9, 5),
-	[GENERIC_EE]					= GENMASK(13, 10),
-						/* Bits 14-31 reserved */
+	[GENERIC_CHID]					= GENMASK(12, 5),
+	[GENERIC_EE]					= GENMASK(16, 13),
+						/* Bits 17-23 reserved */
+	[GENERIC_PARAMS]				= GENMASK(31, 24),
 };
 
 REG_FIELDS(GENERIC_CMD, generic_cmd, 0x00025018 + 0x12000 * GSI_EE_AP);
-- 
2.53.0

