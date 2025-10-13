Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF5D2F83BA;
	Mon, 13 Oct 2025 15:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368372; cv=none; b=X2QQSQBErtblX6PkXzf4Fu389gF6Advqvt54esEpUN4iwoc7BA3Jd0hQsxvJiKqPowOl8QsYktFgN8yWwk5CFuxCsR7KakssXcEI/M2Rt/SGqiRelVWNXSJ9eNGUUq1WpppJI7SxQXSI+hNIt2N+frD5NgCyVvIoz4jqebBur50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368372; c=relaxed/simple;
	bh=ECFo0pJ+d1o3ApQtNsY+XjHYfl6q82N3I7WEVx1BPoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSyxLItHxiIhUYElyJvzBKbtQRpicDIQOmhpuEo6dcxiqZvsxmsC/KKj/G0mchqv2mdXY2bDjbcWk163Hcctv+JU4xT1dPHvy4Tvz/QuGkF69xA70ZMfnwZrR5uU33L4PFfBYS1O8RsC8yMh4nxM2CV96maWd8DWVfzOz/DObnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqsqNpTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqsqNpTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEC4C4CEE7;
	Mon, 13 Oct 2025 15:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368372;
	bh=ECFo0pJ+d1o3ApQtNsY+XjHYfl6q82N3I7WEVx1BPoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqsqNpTLTSGaqPMk8no3/Xsyih+Qe9danckElXRUVKR/63m1kHbLR/wDTUnAPdvMd
	 KR//81pmk9vMCC/W26z6NMfr1RC9/HL79kC0MbULv6GSTE469xeSF/s9S8m3AinTI+
	 kHohFB9YtZGx+KTvj4yZkutaLpsN5qCJ5uEXQd4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/262] drm/msm/dpu: fix incorrect type for ret
Date: Mon, 13 Oct 2025 16:44:39 +0200
Message-ID: <20251013144331.058022916@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 88ec0e01a880e3326794e149efae39e3aa4dbbec ]

Change 'ret' from unsigned long to int, as storing negative error codes
in an unsigned long makes it never equal to -ETIMEDOUT, causing logical
errors.

Fixes: d7d0e73f7de3 ("drm/msm/dpu: introduce the dpu_encoder_phys_* for writeback")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/671100/
Link: https://lore.kernel.org/r/20250826092047.224341-1-rongqianfeng@vivo.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
index 07035ab77b792..4597fdb653588 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
@@ -445,7 +445,7 @@ static void _dpu_encoder_phys_wb_handle_wbdone_timeout(
 static int dpu_encoder_phys_wb_wait_for_commit_done(
 		struct dpu_encoder_phys *phys_enc)
 {
-	unsigned long ret;
+	int ret;
 	struct dpu_encoder_wait_info wait_info;
 	struct dpu_encoder_phys_wb *wb_enc = to_dpu_encoder_phys_wb(phys_enc);
 
-- 
2.51.0



