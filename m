Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039599;
	b=4OLhZ7NaZDFCfWVUMgKPkLqVNqKIbb0w3p2BM8M3HGFXnfhS7iT+YfWIEyWi1tw5uhnQ
	 lVS4amhQGHmG6JdsoXQRzi21WSK+5tS91BE1/Tlt9JXtby69h5s28TEP+aNyzT3rVMFT7
	 6+SZQXzgrgbj/W1wZqO/+QVFmdWnjnjEAANFI5FI8Ja1GdwEZ+KvsJ+MzPGbaU7JErkav
	 S7b3EEbQhyXnNIVrUtBFF1ZSxsyPlwI8kSNVrmabci9yr6yGYuKLcBA49GwhlOrVXz6le
	 8AktvPuXjlbHfGlEcNnWe5Vt4l4eUUaEfxQIBqz+Cfnp4EfbQ8LEQ7K1c+OcW+BAu3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rgz/v6CFyYeLeWg4qqB3WGVHmZTY81EENsiafzCo0vo=;
	b=vsGegg2pv8LrJcdoglTvZN3G8iMiN8KWkJBMeozbCl1+sKtEuMfRjKKsUSndjLeOPokE
	 UszgcZHXXYuRmCaQ7SdYBP5/+oNxTYZedlSJcOe63gGQtxRElTRU9IJhMhYqIuczc0IhY
	 yXc++s1EW+LBSFZFYCTdMyol1+SuWAXHZ2QPdzA2l/lDCcmRyKkU5W3S1VzK0KqayqGO6
	 ePDAYGtWhh59cdeuLnctuRzwx/e9iLErm1/QDdBJGgaScUmyUKK6/SFxRzmZZRp/y9fCC
	 TS0wXDZITqteSTQmPtcGEvWA9kocQnrE/f+tNCdPmbyzK2qQNwh/7WeUQx1+e0dBlqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GD/tME96";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8DE606A320;
	Wed, 18 Nov 2026 22:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GD/tME96
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C871F000C4;
	Wed, 18 Nov 2026 22:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039598;
	bh=Rgz/v6CFyYeLeWg4qqB3WGVHmZTY81EENsiafzCo0vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GD/tME96GJCcAiPYKK8CtV38Y0ktcmtdVyIY7EhEDagDeYdshKtmSkooiTCTqiZuF
	 mn8V0qQVczdRqUtKrRDfzb2TdxvxCn1q/mOnX/TSyGU+FYbcSzdviLqcyCp+YaeAWB
	 0C8FfXKIZDX1ZCsuA56Zbsv5nXOPlkFnyrAecvFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2158/3318] dmaengine: dw-axi-dmac: Fix CH_CFG2 channel priority position
Date: Wed, 18 Nov 2026 15:46:20 +0100
Message-ID: <20261118150426.759928673@linuxfoundation.org>
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

From: Jia Wang <wangjia@ultrarisc.com>

[ Upstream commit 2a9013c20c46216b92ff09e2283b5244a91c59da ]

The CH_CFG2 channel priority field occupies bits 51:47 of the 64-bit
channel configuration register, corresponding to bits 19:15 of CH_CFG2_H.

The driver currently shifts the priority value by 20, programming the
wrong bits. Use bit 15 as the field position.

Fixes: 824351668a41 ("dmaengine: dw-axi-dmac: support DMAX_NUM_CHANNELS > 8")
Signed-off-by: Jia Wang <wangjia@ultrarisc.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260902-dma-fix-v3-3-414c6449fbcc@ultrarisc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
index 2b49ba6355525..408ada52cc7a9 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
@@ -321,7 +321,7 @@ enum {
 #define CH_CFG2_H_TT_FC_POS		0
 #define CH_CFG2_H_HS_SEL_SRC_POS	3
 #define CH_CFG2_H_HS_SEL_DST_POS	4
-#define CH_CFG2_H_PRIORITY_POS		20
+#define CH_CFG2_H_PRIORITY_POS		15
 
 /**
  * DW AXI DMA channel interrupts
-- 
2.53.0



