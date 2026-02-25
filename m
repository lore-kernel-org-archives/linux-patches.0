Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B2A2505B2;
	Wed, 25 Feb 2026 01:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983120; cv=none; b=pHWQ3K4JAsskbMIp5KhQcorUvnWymrLJRvrkoGrSHnJuq5UbMAqkpQCwxlfZLNBPlLI54YcU5pi872rnzNBJiPsYIrFpq7L2p8Z/KVnwchfr6BFk4f4KN/m4dfI5Hoy7b5yXf6/rBOuEcXdXagwuBsg8yqOx//0YpU5BYDxtHKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983120; c=relaxed/simple;
	bh=reR33B0CFW+kjIITQoXms7m8EEkI0mtxmn8QxsMnUu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQLvXYJG3HusGrN3U5SjSZ1Ryn3xAfuJeFUww7zuQ06rFDrzwW7eF8QJh1nDa5tOo0Wf/kb7YE3efE6kfjz5XPIjFiBhdyGpUHMpe/0OIyhImIayEsu7rGVBmqBEIAXIyoAmmlN85+MNOAQ7P6KtYpY6nU+OXZepm+6NBVR+3lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqKHGk/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqKHGk/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6ADC116D0;
	Wed, 25 Feb 2026 01:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983119;
	bh=reR33B0CFW+kjIITQoXms7m8EEkI0mtxmn8QxsMnUu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqKHGk/lGaOodMlNrVjrxfP1EGv47tdjMdUl5rqZ/DY6Ftk6he9SfBurOWYjGUDJV
	 CkLr0HrtU5PS8Lc++t+hEYbsomJI2EjKHYmaXWd83UmHCGDSMPKGa2ysUKV/qKays0
	 VTb+W7WzazD9C2QZFwTjqp9EYKDKS10E/wPdcdCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	Val Packett <val@packett.cool>
Subject: [PATCH 6.19 279/781] drm/msm/dpu: offset HBB values written to DPU by -13
Date: Tue, 24 Feb 2026 17:16:28 -0800
Message-ID: <20260225012406.540769444@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 7ead14d4b9742b5ed244f35b999f0fe26dc23586 ]

As in all other places, the Highest Bank Bit value should be programmed
into the hardware with the offset of -13.  Correct the value written
into the register to prevent unpredictable results.

Fixes: 227d4ce0b09e ("drm/msm: Offset MDSS HBB value by 13")
Tested-by: Val Packett <val@packett.cool> # x1e80100-dell-latitude-7455
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/699276/
Link: https://lore.kernel.org/r/20260119-msm-ubwc-fixes-v4-2-0987acc0427f@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_sspp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_sspp.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_sspp.c
index 6f1fc790ad6d8..b66c4cb5760c9 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_sspp.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_sspp.c
@@ -270,30 +270,32 @@ static void dpu_hw_sspp_setup_format(struct dpu_sw_pipe *pipe,
 		((fmt->bpp - 1) << 9);
 
 	if (fmt->fetch_mode != MDP_FETCH_LINEAR) {
+		u32 hbb = ctx->ubwc->highest_bank_bit - 13;
+
 		if (MSM_FORMAT_IS_UBWC(fmt))
 			opmode |= MDSS_MDP_OP_BWC_EN;
 		src_format |= (fmt->fetch_mode & 3) << 30; /*FRAME_FORMAT */
 		DPU_REG_WRITE(c, SSPP_FETCH_CONFIG,
 			DPU_FETCH_CONFIG_RESET_VALUE |
-			ctx->ubwc->highest_bank_bit << 18);
+			hbb << 18);
 		switch (ctx->ubwc->ubwc_enc_version) {
 		case UBWC_1_0:
 			fast_clear = fmt->alpha_enable ? BIT(31) : 0;
 			DPU_REG_WRITE(c, SSPP_UBWC_STATIC_CTRL,
 					fast_clear | (ctx->ubwc->ubwc_swizzle & 0x1) |
 					BIT(8) |
-					(ctx->ubwc->highest_bank_bit << 4));
+					(hbb << 4));
 			break;
 		case UBWC_2_0:
 			fast_clear = fmt->alpha_enable ? BIT(31) : 0;
 			DPU_REG_WRITE(c, SSPP_UBWC_STATIC_CTRL,
 					fast_clear | (ctx->ubwc->ubwc_swizzle) |
-					(ctx->ubwc->highest_bank_bit << 4));
+					(hbb << 4));
 			break;
 		case UBWC_3_0:
 			DPU_REG_WRITE(c, SSPP_UBWC_STATIC_CTRL,
 					BIT(30) | (ctx->ubwc->ubwc_swizzle) |
-					(ctx->ubwc->highest_bank_bit << 4));
+					(hbb << 4));
 			break;
 		case UBWC_4_0:
 			DPU_REG_WRITE(c, SSPP_UBWC_STATIC_CTRL,
-- 
2.51.0



