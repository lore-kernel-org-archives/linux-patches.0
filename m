Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1371F8722;
	Mon, 23 Jun 2025 21:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715997; cv=none; b=rQdNMK+Yv+tt1QDMcRAZOyWG1Y2ritpjaYs3LOU2ESoIYKQMtK797qnRokfcYhny8vfz1LqUkyaJcjG3BdNTQLOiehVQx/mW1KCXdbwJECW1wxPF1fRAFIsnkaP5FIsifkVuELW4bJfjRLoQ4OcxBwzZMMw0RzrZn3Lip8rIti0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715997; c=relaxed/simple;
	bh=J3ANYhVj4MuSqBR/GEnqz+Y4Jha8yOIP9ti4Q5J6p3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ypus4sc1HieU73Q5b8+irVI1OaW5QAuGDX8uIhDaDmdDddOx1kJTJpYBLNEabsgo+fSiUsgIpj6KMsE2GqAEaXEgRFAJi/3YMD/hbuAbqFlZvBz3q0LJ+076MykE1/0lxiZiKJgN2EGVO86dTqVd37y4SjuzMKuVfBFRQS2ox+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sU+wdIp4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sU+wdIp4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35963C4CEEA;
	Mon, 23 Jun 2025 21:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715997;
	bh=J3ANYhVj4MuSqBR/GEnqz+Y4Jha8yOIP9ti4Q5J6p3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sU+wdIp4jvdS1+/Gc8AJVVMkcmk1JqAEfnmQvkMznX02jEBko8GEX1WY7t7zLYSyo
	 bzv1u8b0XHVXPXgRd1VOUMN6SAo+OyppE6JreREF13BSYxyr4nGxoO4xlDHTGFsjTX
	 FBx+XZctxOId+VRK6teL9vZhH/EjxzJKugJq63ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.15 296/411] drm/msm/dpu: dont select single flush for active CTL blocks
Date: Mon, 23 Jun 2025 15:07:20 +0200
Message-ID: <20250623130641.100379559@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit e93eee524bb78f3ee4b78654d0083382f98b3d23 ]

In case of ACTIVE CTLs, a single CTL is being used for flushing all INTF
blocks. Don't skip programming the CTL on those targets.

Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/641585/
Link: https://lore.kernel.org/r/20250307-dpu-active-ctl-v3-5-5d20655f10ca@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
index 7c58e9ba71b77..7ddb4df885b0f 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
@@ -360,7 +360,8 @@ static void dpu_encoder_phys_vid_underrun_irq(void *arg, int irq_idx)
 static bool dpu_encoder_phys_vid_needs_single_flush(
 		struct dpu_encoder_phys *phys_enc)
 {
-	return phys_enc->split_role != ENC_ROLE_SOLO;
+	return !(phys_enc->hw_ctl->caps->features & BIT(DPU_CTL_ACTIVE_CFG)) &&
+		phys_enc->split_role != ENC_ROLE_SOLO;
 }
 
 static void dpu_encoder_phys_vid_mode_set(
-- 
2.39.5



