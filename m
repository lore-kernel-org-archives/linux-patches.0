Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E834717A2FC;
	Wed, 20 May 2026 18:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302050; cv=none; b=rDYqq4hIJ/XVX1w6hjRLDY0YLB1itCq/gIR3iItPMpKA9Trm2Jw1LtTNO7w8nJTgHmLrWkO0Nw5N0SibvyXieD43wMX9yopoI2res3by00cQlc2m7MQ1KPhja8day50HtmkFcXVGabkpfZ+gw5WXcYDJjS60INlHBYRPv0E1wGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302050; c=relaxed/simple;
	bh=O/ivgddiUHIOXGnAPS9g8oIvKijQLtpFCN5XOwoBpVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iE/UTYKFqVuqmrI5TV+NelMFJ+DUxjSPnn1U1e7XiLBrVdjHXC7Zu3+I+o/gltFTL57FZWcCvyakV7KWfhPJX458ZBlbQ9vGFKrfZKjO8rxXAt7zAGisl5lr1znJC4lf/Rsz+OL+jYfNin1iQ9KVgu105YUm8Q0zj2+JGZ0buxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjprFnfv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjprFnfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2D21F000E9;
	Wed, 20 May 2026 18:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302048;
	bh=YfQDO8AXuhnryrGdmoaAHzUJ/rD724KV9a/PAd/BFTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zjprFnfvmukCAkG0o0yb36gYXAEfV3HkhT0R32MxtTFPT74hk+aXLKp2KW9GacD1L
	 Oa8qGWXw4W4xAjHe3DP3NgbFNugtW8sHj8h4Hr8woiNHWeH7D7GU1+y0EpnklHY9ao
	 3XIdrngQ1tiLML4UfimrJfR53I+Wgn8e4NJjkWjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/508] drm/msm/dsi: add the missing parameter description
Date: Wed, 20 May 2026 18:19:00 +0200
Message-ID: <20260520162101.163817677@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Pengyu Luo <mitltlatltl@gmail.com>

[ Upstream commit 958adefc4c0fddee3b12269da5dd7cb49bac953f ]

Add a description for is_bonded_dsi in dsi_adjust_pclk_for_compression
to match the existing kernel-doc comment.

Fixes: e4eb11b34d6c ("drm/msm/dsi: fix pclk rate calculation for bonded dsi")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603080314.XeqyRZ7A-lkp@intel.com/
Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/710112/
Link: https://lore.kernel.org/r/20260309100254.877801-1-mitltlatltl@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 6077331deba97..771ac34561037 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -533,6 +533,7 @@ void dsi_link_clk_disable_v2(struct msm_dsi_host *msm_host)
  * dsi_adjust_pclk_for_compression() - Adjust the pclk rate for compression case
  * @mode: The selected mode for the DSI output
  * @dsc: DRM DSC configuration for this DSI output
+ * @is_bonded_dsi: True if two DSI controllers are bonded
  *
  * Adjust the pclk rate by calculating a new hdisplay proportional to
  * the compression ratio such that:
-- 
2.53.0



