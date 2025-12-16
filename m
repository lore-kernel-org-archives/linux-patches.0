Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC98332BF22;
	Tue, 16 Dec 2025 11:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884337; cv=none; b=TrSm5mZ4CAVJ6wWd4bY3PoqD+4JL7emVcpfM4foemKU8DAgUqCXg+AZMe+ZFhkjiCpPsyBLlQ1CUU8pbPWp/X1QzJ0MxRtNvLUOB873tWPjJVsmT/47LYQDO/l74n7RearvJN5FC84qL24F0YLQ3E0nZcfi9wb2c77eo4IwsHzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884337; c=relaxed/simple;
	bh=RbzGbwUgkttWrkvU4tU+0foZ6k5tIHuaIkXyNxWAt5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdQZ4JYnAeQ+I/H58EWCxToWEeIN7RmjAaeQ3d/O1IfJeYUvNqnyloSE23xkcmV+D7eKk099Wr4fTM7HUdTqyYhEnb9OYXFyGzvpI8iPWrT4lLPDsAmCD9loSk8CoQZz2kh52d3n8dXAj+US938gNJXauj0w8wRXQUSeVabSmZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GzOxHix0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GzOxHix0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0542C4CEF1;
	Tue, 16 Dec 2025 11:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884336;
	bh=RbzGbwUgkttWrkvU4tU+0foZ6k5tIHuaIkXyNxWAt5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GzOxHix0Wx7gB/xPElxzXAq4hg+WUW2HEJC/NO/C8QVY+iJHJTV2XG1zIiGH6MQ1+
	 XEp1YhER9I0TowYsfND463Z2/XZkKfa+IKLHgK7asUrXdEtWDXXw8KighjuioAxixZ
	 4K6APm4yIEq4cTI6ZsXIuliANbdQpCq1lIOfgxyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jessica Zhang <jesszhan0024@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 162/354] drm/msm/dpu: drop dpu_hw_dsc_destroy() prototype
Date: Tue, 16 Dec 2025 12:12:09 +0100
Message-ID: <20251216111326.783389840@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index 989c88d2449b6..2214b25afac45 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.h
@@ -84,12 +84,6 @@ struct dpu_hw_dsc *dpu_hw_dsc_init_1_2(struct drm_device *dev,
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



