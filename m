Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FB0415F14;
	Tue, 21 Jul 2026 19:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661779; cv=none; b=MU6g597FVRIBz3aib3yHmiuCXWoUatah+KVVpIYwD5Gpje8TNaSoO9EAE7ivamlBhHOMXoz9lhiOwCdtcELPjOYesGZMxnggU0yNIwohce0GXLym4Ju3Ic9bt/dNrwFxGYQ02Hzm9kFs71zqxIO462FOQNbUNEtt0jawglDH/FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661779; c=relaxed/simple;
	bh=kHLJgvlZ3mpymoE7ngorDsPPXZU1je2Nhuy5h6gqDdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbTgY2zu0RmO94jYl4hCvh7a4kW1o2s8HTnSy9XIAk+DpZB7DSu3lpY2UvEq0iATiK5M3E+NsHnm3sDpQFcDHNAKmk+pNmztzn7Nqs3GjRiaRSg9mnp9nOs2Dg2Xs6RviuPwfclDk6KW8lUf2E/wZ5uEnv1bkJSUXdZIkO6g0Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfUrQJV7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfUrQJV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433481F000E9;
	Tue, 21 Jul 2026 19:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661778;
	bh=BSihnFPeEA0PU9nZc906yml6U+9t58VvMBSqGplMbaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pfUrQJV77c7tbT374OoByiKmBznsqkjd88XlRbg7Ogb2BtfjH13WYgspv5/lBRFr9
	 fd/u02mGDIfCoSsExoKHpP5Dcr9dkIP6GOq44rM2y0FyUihq5ETYjodONJGbvh3jjz
	 bQjWJ/S471vubGYb2ZWQ0lOT/8zQlEm8H1d2Sob0=
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
Subject: [PATCH 6.12 0196/1276] drm/msm/dp: Fix the ISR_* enum values
Date: Tue, 21 Jul 2026 17:10:39 +0200
Message-ID: <20260721152450.470947644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jessica Zhang <jessica.zhang@oss.qualcomm.com>

[ Upstream commit 3fbfdc3b1d48cc115a86953e5df0c76cd2efc42b ]

The ISR_HPD_* enum should represent values that can be read from the
REG_DP_DP_HPD_INT_STATUS register. Swap ISR_HPD_IO_GLITCH_COUNT and
ISR_HPD_REPLUG_COUNT to map them correctly to register values.

While we are at it, correct the spelling for ISR_HPD_REPLUG_COUNT.

Fixes: 8ede2ecc3e5e ("drm/msm/dp: Add DP compliance tests on Snapdragon Chipsets")
Signed-off-by: Jessica Zhang <jessica.zhang@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Tested-by: Val Packett <val@packett.cool> # x1e80100-dell-latitude-7455
Tested-by: Yongxing Mou <yongxing.mou@oss.qualcomm.com> # Hamoa IOT EVK, QCS8300 Ride
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/727602/
Link: https://lore.kernel.org/r/20260524-hpd-refactor-v6-2-cf3ab488dd7b@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index a5c1534eafdb1a..3bb8010f2efe00 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -37,9 +37,9 @@ enum {
 	ISR_DISCONNECTED,
 	ISR_CONNECT_PENDING,
 	ISR_CONNECTED,
-	ISR_HPD_REPLUG_COUNT,
+	ISR_HPD_IO_GLITCH_COUNT,
 	ISR_IRQ_HPD_PULSE_COUNT,
-	ISR_HPD_LO_GLITH_COUNT,
+	ISR_HPD_REPLUG_COUNT,
 };
 
 /* event thread connection state */
-- 
2.53.0



