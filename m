Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DD8199920;
	Tue, 21 Jul 2026 20:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665923; cv=none; b=oWRMWp1OZTBZh2uV3fQ4FO3HKRfJuo4aBl3N7jF0lwuaWo87+V5EXR2rMnm8KgnGXJDHvhJkHfqvNb3mj34A1o2f0B4rW+T0ZzYY3r7Jt46PcYBZ+AIrFXIvO04ud7CnbnFXVRaAook6Ew6TRlQz6usyYxOuW7b+hbk4c+hmIB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665923; c=relaxed/simple;
	bh=BtIMipUed1NkukhHl2YrZ8vlr+TQOEo/JeNTr624I6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbz/gp6N7XP+OYQHIs81ie3nWlcgIzMy05jEIDDSR40pYprmOiFXD6JH/1IV0Gu0mLUlBHSTNelNuAAAp+0Jqa4oNUaWSe6RJeEZr2sP/NWghwbFIoNTv2D+/aXPbkWQUnADCJQEjy8U88Oi+m5Ezuutdo/n2zVQwPVmUR8t368=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJWsjIe8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJWsjIe8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0231F000E9;
	Tue, 21 Jul 2026 20:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665922;
	bh=zyg40CYLts3/ZzGzjF3HCuwgrYUcugKVwX6A0hHdmTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uJWsjIe86BW0wFQrMNwDeW00QL8ibR0/MhMddwcIq5Vy4U25s8W2N/2phaTRtARpa
	 sHVDkXNKvtkEd+Cw9/DKhz94OWn/FfOxtREfemdxL5AXlejlGf337q6xOj+vhbX3wo
	 WBG4JlU6Tq3aKoJswWD/2WAzZnIR+bXSyWzUOefM=
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
Subject: [PATCH 6.6 0460/1266] drm/msm/dp: Fix the ISR_* enum values
Date: Tue, 21 Jul 2026 17:14:57 +0200
Message-ID: <20260721152452.128405038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ed77c957eceba3..9c8f6a0458c8a7 100644
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



