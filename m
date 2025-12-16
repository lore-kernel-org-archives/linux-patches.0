Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EDE352F86;
	Tue, 16 Dec 2025 11:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885773; cv=none; b=jB52R1Xg7MtBd8yDyNqmJPahLh9nvH8fqZlGUifGxfxgZGsNCMK63Ihet5N6ubHBoMEeO7vvQIgVV8fQooOKqAjxh5gvLbDMVrjDYRzJGt4QJayVFmvpOcaMDO4Ddi+0DfJlbRyiAEpPjr4i/cnzglOriMcmLIyx16doGnWYy5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885773; c=relaxed/simple;
	bh=yFQQsSsg4aNNIP4EuHmOwKc7LzGhmti/2gaKedrEeAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDGR+xBerNcLZW5wMRXrX2rrKzESzntCJUNF8ocZBjscurwZ7M92WSBrqyOZiDke04tXV69YcfYG+0nyBADnDhJzpE+8ZHeD3fin8Tk/tZ95bEzbSQdDsGJABUn/mYHZu8UKPZ6xYAZio+LRRUZ23ZjojBISok9VxphUGCvHOlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h15YRkhj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h15YRkhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BB0C4CEF1;
	Tue, 16 Dec 2025 11:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885773;
	bh=yFQQsSsg4aNNIP4EuHmOwKc7LzGhmti/2gaKedrEeAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h15YRkhjrDuqpFby8X5pnFYAgPj+N0MbdcxNoCZ9AVNQo92v/I/mhQ+37rrccNuBa
	 jalmfhesk4NYyHub/Yde/EETvFLQZt22jsU1NsqBKY7ljvKaMzBV0gP+MH75DGB0VM
	 iT7zL/BIUS6tP5BVxRGboLTd4jjhE/aILzsfgf10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jessica Zhang <jesszhan0024@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 239/507] drm/msm/dpu: drop dpu_hw_dsc_destroy() prototype
Date: Tue, 16 Dec 2025 12:11:20 +0100
Message-ID: <20251216111354.157411389@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit d9792823d18ff9895eaf5769a29a54804f24bc25 ]

The commit a106ed98af68 ("drm/msm/dpu: use devres-managed allocation for
HW blocks") dropped all dpu_hw_foo_destroy() functions, but the
prototype for dpu_hw_dsc_destroy() was omitted. Drop it now to clean up
the header.

Fixes: a106ed98af68 ("drm/msm/dpu: use devres-managed allocation for HW blocks")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Jessica Zhang <jesszhan0024@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/683697/
Link: https://lore.kernel.org/r/20251027-dpu-drop-dsc-destroy-v1-1-968128de4bf6@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.h
index b7013c9822d23..cc7cc6f6f7cda 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.h
@@ -71,12 +71,6 @@ struct dpu_hw_dsc *dpu_hw_dsc_init_1_2(struct drm_device *dev,
 				       const struct dpu_dsc_cfg *cfg,
 				       void __iomem *addr);
 
-/**
- * dpu_hw_dsc_destroy - destroys dsc driver context
- * @dsc:   Pointer to dsc driver context returned by dpu_hw_dsc_init
- */
-void dpu_hw_dsc_destroy(struct dpu_hw_dsc *dsc);
-
 static inline struct dpu_hw_dsc *to_dpu_hw_dsc(struct dpu_hw_blk *hw)
 {
 	return container_of(hw, struct dpu_hw_dsc, base);
-- 
2.51.0



