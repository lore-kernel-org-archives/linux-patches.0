Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A2C46A610;
	Tue, 21 Jul 2026 15:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648896; cv=none; b=H6nNmWR1JbzOFg7EtfE+9zBLPb4bvulEQzNvzD5GxXEvQS1i7STfu7KmgBnGj7j2B2inC0tuFDXgiRM2dT/dgTR8W7aitQm8ZLudwLFFZuVtgJshMW335IAC3wGzsPWk81HT1GcFSAN1GYeB4N3hgRfpkOlC80+4AMIbIx3gge8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648896; c=relaxed/simple;
	bh=1XjgAPAKVgMaIl95IBGNsNtW8JGHaH8fVOhdZlTg73w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QzZhMwA2AUuAf6a3WZPOaDhid5/bqLT8iT1iD8KWCSeoF/mCtmOFtScTsjhMQHed57UwArgXJvQhgR6iq5zGKdK8nZjH4r1cWwRICory+J/duyFZRb6iQs6CBtq97anI1ZGLN4cWaxCkaZmeGB9sib523eaTjqHF016Qn1lKlzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JaXYhlbY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JaXYhlbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2721F000E9;
	Tue, 21 Jul 2026 15:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648889;
	bh=b/L91PoJ3AdHHt1m0pH/r3eG+Kz4dsZlh/co1AHE77M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JaXYhlbYaEiyNbCo5GhaHStpRu+EJkbgIYcNepm5aTxQybS7lv6tJBM1SMSmZIpo3
	 t7Qc5IcG7rQATmjmSC9YEemGcTmtLsmFKDhO1EFdA3Ixr+H4Ldd/2K+/z5wMBrekSD
	 wTfoafgTswhKJDeskudMcXWxBr8kFosGbvF5fq8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Zhang <jessica.zhang@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	Val Packett <val@packett.cool>,
	Yongxing Mou <yongxing.mou@oss.qualcomm.com>
Subject: [PATCH 7.1 0371/2077] drm/msm/dp: fix HPD state status bit shift value
Date: Tue, 21 Jul 2026 17:00:44 +0200
Message-ID: <20260721152601.439126922@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jessica Zhang <jessica.zhang@oss.qualcomm.com>

[ Upstream commit 2e6c2e81d81251623c458a60e2a57447dcbc988e ]

The HPD state status is the 3 most significant bits, not 4 bits of the
HPD_INT_STATUS register.

Fix the bit shift macro so that the correct bits are returned in
msm_dp_aux_is_link_connected().

Fixes: 19e52bcb27c2 ("drm/msm/dp: return correct connection status after suspend")
Signed-off-by: Jessica Zhang <jessica.zhang@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Tested-by: Val Packett <val@packett.cool> # x1e80100-dell-latitude-7455
Tested-by: Yongxing Mou <yongxing.mou@oss.qualcomm.com> # Hamoa IOT EVK, QCS8300 Ride
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/727611/
Link: https://lore.kernel.org/r/20260524-hpd-refactor-v6-1-cf3ab488dd7b@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_reg.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_reg.h b/drivers/gpu/drm/msm/dp/dp_reg.h
index 7c44d4e2cf1396..3689642b7fc061 100644
--- a/drivers/gpu/drm/msm/dp/dp_reg.h
+++ b/drivers/gpu/drm/msm/dp/dp_reg.h
@@ -68,8 +68,8 @@
 #define DP_DP_IRQ_HPD_INT_ACK			(0x00000002)
 #define DP_DP_HPD_REPLUG_INT_ACK		(0x00000004)
 #define DP_DP_HPD_UNPLUG_INT_ACK		(0x00000008)
-#define DP_DP_HPD_STATE_STATUS_BITS_MASK	(0x0000000F)
-#define DP_DP_HPD_STATE_STATUS_BITS_SHIFT	(0x1C)
+#define DP_DP_HPD_STATE_STATUS_BITS_MASK	(0x00000007)
+#define DP_DP_HPD_STATE_STATUS_BITS_SHIFT	(0x1D)
 
 #define REG_DP_DP_HPD_INT_MASK			(0x0000000C)
 #define DP_DP_HPD_PLUG_INT_MASK			(0x00000001)
-- 
2.53.0



