Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AC32C15B5;
	Tue, 12 Aug 2025 17:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021291; cv=none; b=n3ar3AiinxiwDKHLBNA+K7WMDtGVY8yuLQak+je0JBjhlYMBsWeXAQ97qfmMjDQdENHW9yQ28Qmv2NRlpqpCkyOr0E0XG7AsXwvIJC7EgPuZiERL8hGNe4hmxLqlqqtBCC+Z3uVpyYT3LinbgOZj4vaQKi3CpGAQRQIr8DctdgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021291; c=relaxed/simple;
	bh=qT/k8Xp3OuCJJjNn97zyn+Y1GrorI63buJae1ugLKfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJqRBh0FRYJnb3JAzykqVtl4QBGxHuoV1xAsPhsZ3u2m+uhMBt5yYE3Bbr9QQ9vdZBi6pk7m7+ozI0+864X1+gU5ZhnBw0J3uBGOYOFmQ+2NGkrNDdiJFHTpXOAO0uh2VUkMCDOiT8E3NRJCExLktk0+0ylKu+F44La/K9R2qtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMOz2dj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMOz2dj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCB0C4CEF0;
	Tue, 12 Aug 2025 17:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021291;
	bh=qT/k8Xp3OuCJJjNn97zyn+Y1GrorI63buJae1ugLKfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMOz2dj0PUQnbNGEggj5VgXROtcGBRNUlUI60/4aDZndMu0nIc9QXQKXdXTFmuyY/
	 PK89t2qAsTDHYsWaNMQvJSZ2vXppnBX//dj5glul0Xi1bB4QB/WX9hPThFDOdjoAEV
	 oQjXP0Qj/U4sUTELTkjM2oXAFyBNIBUFU7Vw8d7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/262] drm/msm/dpu: Fill in min_prefill_lines for SC8180X
Date: Tue, 12 Aug 2025 19:27:34 +0200
Message-ID: <20250812172955.803079175@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 5136acc40afc0261802e5cb01b04f871bf6d876b ]

Based on the downstream release, predictably same value as for SM8150.

Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: f3af2d6ee9ab ("drm/msm/dpu: Add SC8180x to hw catalog")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/657794/
Link: https://lore.kernel.org/r/20250610-topic-dpu_8180_mpl-v1-1-f480cd22f11c@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
index 427dec0cd1d3..b77ecec50733 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
@@ -378,6 +378,7 @@ static const struct dpu_perf_cfg sc8180x_perf_data = {
 	.min_core_ib = 2400000,
 	.min_llcc_ib = 800000,
 	.min_dram_ib = 800000,
+	.min_prefill_lines = 24,
 	.danger_lut_tbl = {0xf, 0xffff, 0x0},
 	.safe_lut_tbl = {0xfff0, 0xf000, 0xffff},
 	.qos_lut_tbl = {
-- 
2.39.5



