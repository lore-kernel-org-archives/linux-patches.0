Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D141C35C6AC;
	Tue, 21 Jul 2026 22:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673586; cv=none; b=c0GrXi4qe7/U+AmDgBK6M2uF01wdA6+qWHKglUuM6tMynI+sFsSm5ZMPjhHt1MpdTh+2nwuzLa9GDtr5lpGMXESsSmxab545b08vRiQlbs0Jd1HmeWqCIueVvkwYAA/mUBhM4guTtuSBokzL3IKVpYbSo5gnqBGRFqstXcbBMCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673586; c=relaxed/simple;
	bh=gt1oiuXek8G7p84HkLOzblg5ma1Npy9V/Hdl/ops+50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ER1WapwZh8cQ1qTlRzTbQCYX/1az8uq2MqCsOC9Yr/5fuveKqhpx3IUzlY3fJBvrQqnVoMvFIklymojguZujQ0vVPXJh0JAeDzkwq71kX+/xWOw0ZgR45+Zhyl9n/R7WwBonRYCyGmzVXy4mQkY17apT9tOA75iKM0Fb3F287SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=05WwjdSJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="05WwjdSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15A51F000E9;
	Tue, 21 Jul 2026 22:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673585;
	bh=qgantw8NHmOOkOHKSTDHRYweoOheoHUyFKJMVEk7/Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=05WwjdSJGiRFQu4s7rofIHEAXoIKPDallc9maSKse9s8Ff6klGD9CsRFQPIi8Q9df
	 ez/HpdAo1xW348YH5PQQOsmNyVuBolnjlPWdAB1ugspIFmCNAdbnOPtzrjiFJo3qPL
	 6dbiwNaa19KqSz3hgR1x3seUi9ZjKeFJrDs5r4HA=
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
Subject: [PATCH 5.10 216/699] drm/msm/dp: Fix the ISR_* enum values
Date: Tue, 21 Jul 2026 17:19:35 +0200
Message-ID: <20260721152400.573295429@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4da8cea76a1159..89010b7a6a5414 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -34,9 +34,9 @@ enum {
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



