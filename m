Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D742D3ED6;
	Tue, 12 Aug 2025 18:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023785; cv=none; b=EGQIyJ4/wdzXmVlCq2TJzZCXaUofbXv+H3otJZlvUcRDbulXYZYGPopgbC3ugsP86bAquiVrKg+JfjCVf7g0bP79MsyOsup1y/vj//YF5yVL9gErI0EE8pJEDJRcS1NfX2B9gCGj5RMSJlefRTOzy1rOtlkmMwTlCKnQ/1ymJRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023785; c=relaxed/simple;
	bh=4+TP+vDaANsfEdrN8dJA6q07wBeSD83ftfk1OycsK0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KILUm5pZlVzCc/Oz1wWLnNJh7zHyIkTTDjxv9I6q8rCgWVTmTXVShXlHmzen8O9/gDtSouZYRfOEd0kbwRR1SxzViEsGvhJl/F66E/qSMFDNJ90F3ht723D6Q5KXwgLzPse7ju3hhTglLGmV1HoCp7cMetT5Ut9KdKCYtBJnKZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOAhWAQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOAhWAQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874C3C4CEF1;
	Tue, 12 Aug 2025 18:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023784;
	bh=4+TP+vDaANsfEdrN8dJA6q07wBeSD83ftfk1OycsK0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOAhWAQBiXNU/oy6l7g/C/+r+cMEOPxH+swds+zeHcyaclbAxKQsXSDtfaL6a907D
	 zIwL74ofOstzO0bLXKc9xGJoaWdYKwbnsiF/u9BWJ+jAzUcz0QxK8mo7ffJ5b5siMl
	 GiphBSoLox0FAbMvJ5bY/vGY6tSnWg3lwqwmx7oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 181/627] drm/msm/dpu: Fill in min_prefill_lines for SC8180X
Date: Tue, 12 Aug 2025 19:27:56 +0200
Message-ID: <20250812173426.166093013@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index d6f8b1030c68..6c04f41f9bac 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
@@ -383,6 +383,7 @@ static const struct dpu_perf_cfg sc8180x_perf_data = {
 	.min_core_ib = 2400000,
 	.min_llcc_ib = 800000,
 	.min_dram_ib = 800000,
+	.min_prefill_lines = 24,
 	.danger_lut_tbl = {0xf, 0xffff, 0x0},
 	.safe_lut_tbl = {0xfff0, 0xf000, 0xffff},
 	.qos_lut_tbl = {
-- 
2.39.5



