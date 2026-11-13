Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590242;
	b=YTCyW68OE8P12DATxleOgKSJC2nLah25W8bYt4ur8z3m+8LffjSdUP08QTzI4gx4foW+
	 p6AR79SvdYVSO1xHG4RyNyB1uvZwvdHwmsNbBfR8U1sF5bjGHoRCG9nmtP3FoPn5iHWzW
	 QKIEWPf6tbHetCHiPE/jYdjwxn+M14XVYFgXEReRDwtLC7FOJrgthmGcCnm/2MiP4C0vX
	 Hc9M2c67Ch0d+3/5uhXK2kOJX7/pNxDnlIXeBO+LUwCODGFI50YosQH8KJ36nVWs++yqw
	 GklLw9CI/hj+dHa4Dj0wPTw98UF4gBSvauHU0nDGDGc1tMblpGR7W79pmUjS3Jn9/EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=VEZZUaQVXVaBTR22Gbry51P1s7PtV6rKMEC3K+BJKho=;
	b=O1JxKFfdOR+ABQtXnBnj+T4eYD/XBJ3JDQ+ENZkwBntTmiOpOb8iLipum7JJYh7MlC0V
	 8Jl6ZPt2ED3ECBcE5RhG4dG5dRBE+xvfYqbmgPOJT3RQteoWn1FglDxRf/lZZ+6Ts5Tb2
	 WRln6aaIayPnp+KxDnl96MIAKAieM88zBYQuF6aLjqd07QUmyjU3wH2OxH6HLXSCA/BWm
	 MXtxw8aBaCYcYV6KPv2H8boxuKXwR5zqYpQoj0nzn6MmGZuc+pPFLzTpdWcmvoqdiIdRQ
	 D/u1o/iZCUZfGNNmOyIIsxOOLL9EUg5ZFbtFLV6Y9DFfaJpmVO6F4fPLKVKMnU1/g1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zfjCVgt5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097BB6075E1D;
	Fri, 13 Nov 2026 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zfjCVgt5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1C51F000C4;
	Fri, 13 Nov 2026 17:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590241;
	bh=VEZZUaQVXVaBTR22Gbry51P1s7PtV6rKMEC3K+BJKho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zfjCVgt5TiTh/gXWoqR5N9iNVcwB9WM1cSoIjVl0m2+npwZTQ+8c9WaNI4YcwNWBu
	 vr0YG43YUn1dYod37Uplp6eNUJuBJh6EXnPcIXgu4DOxUcDk0RH0wmnMuSkbvocUBv
	 gmJeIXoTDugBT6smop1GSeUULRf7WKDZy3qKF0vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 240/686] drm/i915/psr: Fix SFF and CFF CTL register bit definitions
Date: Fri, 13 Nov 2026 10:46:13 -0500
Message-ID: <20261113153829.185964713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 15b3187740291c4705b995bbf984da462e9f1e35 ]

Single full frame bit in SFF_CTL and continuous full frame bit in CFF_CTL
are bit 0. Fix the definitions accordingly.

Fixes: 3b5bf853e309 ("drm/i915/psr: Add register definitions for SFF_CTL and CFF_CTL registers")
Cc: <stable@vger.kernel.org> # v6.15+
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patch.msgid.link/20260929094434.77129-5-jouni.hogander@intel.com
(cherry picked from commit 95ca8fab5232dfb7459989d54f09501704a8d7ad)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr_regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr_regs.h b/drivers/gpu/drm/i915/display/intel_psr_regs.h
index 8afbf5a383353..1e85860eefb83 100644
--- a/drivers/gpu/drm/i915/display/intel_psr_regs.h
+++ b/drivers/gpu/drm/i915/display/intel_psr_regs.h
@@ -254,12 +254,12 @@
 #define _LNL_SFF_CTL_A				0x60918
 #define _LNL_SFF_CTL_B				0x61918
 #define LNL_SFF_CTL(tran)			_MMIO_TRANS(tran, _LNL_SFF_CTL_A, _LNL_SFF_CTL_B)
-#define  LNL_SFF_CTL_SF_SINGLE_FULL_FRAME	REG_BIT(1)
+#define  LNL_SFF_CTL_SF_SINGLE_FULL_FRAME	REG_BIT(0)
 
 #define _LNL_CFF_CTL_A				0x6091c
 #define _LNL_CFF_CTL_B				0x6191c
 #define LNL_CFF_CTL(tran)			_MMIO_TRANS(tran, _LNL_CFF_CTL_A, _LNL_CFF_CTL_B)
-#define  LNL_CFF_CTL_SF_CONTINUOUS_FULL_FRAME	REG_BIT(1)
+#define  LNL_CFF_CTL_SF_CONTINUOUS_FULL_FRAME	REG_BIT(0)
 
 /* PSR2 Early transport */
 #define _PIPE_SRCSZ_ERLY_TPT_A	0x70074
-- 
2.53.0



