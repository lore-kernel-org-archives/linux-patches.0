Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA1933F5B0;
	Mon, 20 Apr 2026 16:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701005; cv=none; b=ZTJ7lKxAhg8lnl1RTsYyshcDtQBpG8qPl1KdW1jshTzQ2oFvllOI4Pp1ddcj7qtvkO2cuK+HGDbT+gAkUVTOuXp8THU52EavDwHYb5yzB9tT3ZYeJ7dprH+1BdwJEbk2z0Idt5iWEaBJXSzKzc9etC8xIpvBci36KQDpTNXkb5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701005; c=relaxed/simple;
	bh=PpbXOlA6YII2abyPFCVsLmV7G6NEDNckdEtxbR3t56U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeJYpn0+y1xTmvuCedhpgulKlnfNjgJvjB386aaTeXq5S1ywzpcEFtFMyhMUTot8UrkRAUxbr4vOHac/Lc6hsCgKXbidgOnGflQA1yRui1uq/WFb1ye/EB1LI3jJwuXVjkQYQ1FZ7MklahsQu7C1sQ2cldG2m6usofjo43RwO1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NpOPlhSj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NpOPlhSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649E1C2BCB4;
	Mon, 20 Apr 2026 16:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701005;
	bh=PpbXOlA6YII2abyPFCVsLmV7G6NEDNckdEtxbR3t56U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NpOPlhSj3ZTX1BoecieOaSxbMPqWAxchd4DEC/J+vQMpEjcA/beraWjPOncYqrZB3
	 5rV2Fqv3K5JGnO3tDq8OgD0Auh/8Wrq0oSMw5X5BsDTHxzVKf9ltavEJjud+RRwkD1
	 pZpYl+X4KfUCTjEz1zyfyjMnHI3iP9zJ5hg/3tzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Koskovich <akoskovich@pm.me>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 111/198] net: ipa: fix GENERIC_CMD register field masks for IPA v5.0+
Date: Mon, 20 Apr 2026 17:41:30 +0200
Message-ID: <20260420153939.601324140@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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



