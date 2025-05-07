Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2C1214813;
	Wed,  7 May 2025 18:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644064; cv=none; b=OsHGyZJ8mGOQ3U8FA+PCC+rQvYA8GXP/blxaAB8+YHfN2GoLG7iDUSLmXejgOJXwzJlZTTHXjGiEmLZY+qlgMFVToT6ITIUsvvB+JoEIHmSPTerjk83Su68WgwvfBvQP+i7VLOwm78P0OitoMlf4u7pHjaTfniMUFzQ349BlcBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644064; c=relaxed/simple;
	bh=VKxuNaNpx/BRXGFJjI5ZeX/hyH0guYBNn92WpprXAsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bprA0mVsavJtni7/wWMO2HbAtbGQkal0uK4BDtCJaaSAXTLVPjHayCrwiQfL006wrmt2Wulb3mfAahkvS1wPpT6/oQSWqkZAT294fvdBfDxQ/zQTGbb0NAUP899tm8jYHr15FfraaCAl1DmmLYAn65QGn+EU2RfBhQTKiub3WU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTXvlUP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTXvlUP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3D8C4CEE2;
	Wed,  7 May 2025 18:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644064;
	bh=VKxuNaNpx/BRXGFJjI5ZeX/hyH0guYBNn92WpprXAsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTXvlUP3VVLduOEUqYdiWK51cYhO9TAkDrHdw/mnw3H/z24jCieq923raoDu4TG18
	 239M/WI8CRc+kDUiSxSc7wwiQMLJzyWw/Q0nhVOexoAzBpMaT0ePVovxIqQffuYxht
	 jvwnbFzpUvuhm4cM8gM7EXs9CjwrFYZf4Qj1cKvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <maulik.shah@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Melody Olvera <melody.olvera@oss.qualcomm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 107/183] pinctrl: qcom: Fix PINGROUP definition for sm8750
Date: Wed,  7 May 2025 20:39:12 +0200
Message-ID: <20250507183829.164635438@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maulik Shah <maulik.shah@oss.qualcomm.com>

[ Upstream commit 12b8a672d2aa053064151659f49e7310674d42d3 ]

On newer SoCs intr_target_bit position is at 8 instead of 5. Fix it.

Also add missing intr_wakeup_present_bit and intr_wakeup_enable_bit which
enables forwarding of GPIO interrupts to parent PDC interrupt controller.

Fixes: afe9803e3b82 ("pinctrl: qcom: Add sm8750 pinctrl driver")
Signed-off-by: Maulik Shah <maulik.shah@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Melody Olvera <melody.olvera@oss.qualcomm.com>
Link: https://lore.kernel.org/20250429-pinctrl_sm8750-v2-1-87d45dd3bd82@oss.qualcomm.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-sm8750.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-sm8750.c b/drivers/pinctrl/qcom/pinctrl-sm8750.c
index 1af11cd95fb0e..b94fb4ee0ec38 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8750.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8750.c
@@ -46,7 +46,9 @@
 		.out_bit = 1,                                         \
 		.intr_enable_bit = 0,                                 \
 		.intr_status_bit = 0,                                 \
-		.intr_target_bit = 5,                                 \
+		.intr_wakeup_present_bit = 6,                         \
+		.intr_wakeup_enable_bit = 7,                          \
+		.intr_target_bit = 8,                                 \
 		.intr_target_kpss_val = 3,                            \
 		.intr_raw_status_bit = 4,                             \
 		.intr_polarity_bit = 1,                               \
-- 
2.39.5



