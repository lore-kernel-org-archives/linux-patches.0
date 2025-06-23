Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30E721D3DD;
	Mon, 23 Jun 2025 21:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714921; cv=none; b=EPv6Dvn/SCmggX09RHShIu8H+DSAaKJhLgeNpCHDkWSKXetW2I3Hly5kSlZL9uma4QK07vYR84karKWbzjfOIR9ka3IDGLDQigLHJmnGerFuRdUjxfeomUpOocZS3bkpx8CiNIeiERyVE5HxpgELurK+8pBQiAm5oXl3MmvUJRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714921; c=relaxed/simple;
	bh=y3O3UKfi80nI9BAt01HZV6U1DZauYU+hMpkCgLgpbq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foIbRmcQqrmMBcKbeX8TAv72ssgeLEJEwIBNZmVzR2Qywdp+xtW4+w1MUTgsJWN8j2h8Z2qjKwJZzLB6LPs7dbKctTE8FblqwR4ynpU10E6UWLydvQtDCgpu7rGIgobgDSQ+rBYJFAfuJe1a9BTIl3cWGP+seyMJdwrpEseFAQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXdUZ1qw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXdUZ1qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4194AC4CEEA;
	Mon, 23 Jun 2025 21:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714921;
	bh=y3O3UKfi80nI9BAt01HZV6U1DZauYU+hMpkCgLgpbq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXdUZ1qw1hG3YEQgNfkDkf/cHRfmSWiqYo39X1SaB6Z61+KbczY4oOxlFNRzA7oxD
	 O2QIGiKriBHsvPzkrlXsACPAeYfpFE87BDtgi4auAGE0TMhc7eH2UHSt9TcJ8sT+7V
	 i9Ykl1w+O0L8Ii4fbp3c5r70XOkDLB47gNaOUDeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.10 241/355] drm/msm/dpu: dont select single flush for active CTL blocks
Date: Mon, 23 Jun 2025 15:07:22 +0200
Message-ID: <20250623130633.995432934@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 33880f66625e6..f9da379999467 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
@@ -353,7 +353,8 @@ static void dpu_encoder_phys_vid_underrun_irq(void *arg, int irq_idx)
 static bool dpu_encoder_phys_vid_needs_single_flush(
 		struct dpu_encoder_phys *phys_enc)
 {
-	return phys_enc->split_role != ENC_ROLE_SOLO;
+	return !(phys_enc->hw_ctl->caps->features & BIT(DPU_CTL_ACTIVE_CFG)) &&
+		phys_enc->split_role != ENC_ROLE_SOLO;
 }
 
 static void _dpu_encoder_phys_vid_setup_irq_hw_idx(
-- 
2.39.5



