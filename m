Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEBA1DF962;
	Wed, 19 Feb 2025 09:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956814; cv=none; b=UvVFC6qBh0CA7O5Ib0/mIAfWNsu0hMYL/RdWiXmPK0SRicGBDHdBFIj8JuSdabPMfvKJhd2/6TuuqrTAGZN4qqm3A/+ay/y45pCRFGQA45L/stdtZNDePpkTOY7h6EprhHsmbNl2csam3HQZ2ZDJYLtm/lohCd1HbScabLLzQ/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956814; c=relaxed/simple;
	bh=h87h5HO7sM6PXb4Izy6h8lf3VKEd6hWcdzSWaYS/q9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSpltSZLRvZ0jqJx07ZMgjUdT/ywBwDboNaJp0zk2eitlxrKrysONrWQdTK9tnvsUP2k8buYFMtqwTYFELd0a/MhnNeiberNzbqfNYKGuXxPQT8HDwD1YOtDpOe6W54XKWfDYc7ewjqlfIr/5ZpPPoJdCD6uHy5YInkFIG0GcN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xyXictP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xyXictP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6BDC4CED1;
	Wed, 19 Feb 2025 09:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956814;
	bh=h87h5HO7sM6PXb4Izy6h8lf3VKEd6hWcdzSWaYS/q9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xyXictP8dkdIu5RadTtlPfU5azqI+gfed8/uGkIwqP8vZ/dAUO7c0aTj73CXA+mEk
	 zBsoW3Kknj3QGXOVIXdlz/god0s/s6dmpeHYJ2pX1bcezUED2cei9xOjz2dHTpnXg1
	 sspWWFlEmdFPvKNwRyx36NV8myJ/BtG/v8NQbKjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Hermes Wu <hermes.wu@ite.com.tw>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 282/578] drm/bridge: it6505: fix HDCP Bstatus check
Date: Wed, 19 Feb 2025 09:24:46 +0100
Message-ID: <20250219082704.109336558@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hermes Wu <hermes.wu@ite.com.tw>

[ Upstream commit 0fd2ff47d8c207fa3173661de04bb9e8201c0ad2 ]

When HDCP is activated,
a DisplayPort source receiving CP_IRQ from the sink
shall check Bstatus from DPCD and process the corresponding value

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Hermes Wu <hermes.wu@ite.com.tw>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241230-v7-upstream-v7-5-e0fdd4844703@ite.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 6140dea66e43a..7e82f36f9fd02 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2292,14 +2292,20 @@ static int it6505_process_hpd_irq(struct it6505 *it6505)
 	DRM_DEV_DEBUG_DRIVER(dev, "dp_irq_vector = 0x%02x", dp_irq_vector);
 
 	if (dp_irq_vector & DP_CP_IRQ) {
-		it6505_set_bits(it6505, REG_HDCP_TRIGGER, HDCP_TRIGGER_CPIRQ,
-				HDCP_TRIGGER_CPIRQ);
-
 		bstatus = it6505_dpcd_read(it6505, DP_AUX_HDCP_BSTATUS);
 		if (bstatus < 0)
 			return bstatus;
 
 		DRM_DEV_DEBUG_DRIVER(dev, "Bstatus = 0x%02x", bstatus);
+
+		/*Check BSTATUS when recive CP_IRQ */
+		if (bstatus & DP_BSTATUS_R0_PRIME_READY &&
+		    it6505->hdcp_status == HDCP_AUTH_GOING)
+			it6505_set_bits(it6505, REG_HDCP_TRIGGER, HDCP_TRIGGER_CPIRQ,
+					HDCP_TRIGGER_CPIRQ);
+		else if (bstatus & (DP_BSTATUS_REAUTH_REQ | DP_BSTATUS_LINK_FAILURE) &&
+			 it6505->hdcp_status == HDCP_AUTH_DONE)
+			it6505_start_hdcp(it6505);
 	}
 
 	ret = drm_dp_dpcd_read_link_status(&it6505->aux, link_status);
-- 
2.39.5



