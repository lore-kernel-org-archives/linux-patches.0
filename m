Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9244F5E0;
	Wed, 20 May 2026 18:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300532; cv=none; b=U4GJTkC0XqC+oyeJuKZeAML0fCup6U13whWXUoysu7uT6REZFvkQ3cDqZaWWXD5aIDJRBlnBiJgvCAuZo2rgNhIKgSsbl2pMs6sn5koVX4FizExsFQfiIZKod2EGoTQ7mHMuMtS8v/URaL3dtsNFySTEd8HHg8MSGx9NbL5/+L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300532; c=relaxed/simple;
	bh=LmjZ0CXX4tZWkAGZ1gQCH0zz5tY4IMXy8IlSRUivFWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtiJ0ZnFmJl1/95Mmf+0dlhHKZNSn3Eh7Ne99H+Wcobr1S5giPu8t5349i6VbOeKy+GW8VhlNDSk+EsUBk1BJi1q8RX24BLa4dribS+rJowHrsuoDHbIMry4L9XzZOHzPDpv6rPG2WbuvkSVhBtiLnvd4G2h6ttAXEF2XXmjIa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2aa4jVjk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2aa4jVjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD301F000E9;
	Wed, 20 May 2026 18:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300530;
	bh=JO9z5EsX0ugEdlirX0u5qdyOHxWyROHff/ZK6o8pqfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2aa4jVjkVnlGcr+leDU8beOsWCToFPV4fSc12ZeiNqK4qOSTkNN+G3C/hHe9/0ddo
	 ukdC5fBI+dznhSmj35ajZT0e0SBOkXFdS7c9c2TUdpLIohBapS5RLuWaxuqLZZTCq6
	 9IDnKGGx28ZtfXATeTflFtAIYLoPj/U210g1MrA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 168/666] drm/msm/dsi: add the missing parameter description
Date: Wed, 20 May 2026 18:16:19 +0200
Message-ID: <20260520162114.846364258@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index 0c360e7903295..1027434b72620 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -519,6 +519,7 @@ void dsi_link_clk_disable_v2(struct msm_dsi_host *msm_host)
  * dsi_adjust_pclk_for_compression() - Adjust the pclk rate for compression case
  * @mode: The selected mode for the DSI output
  * @dsc: DRM DSC configuration for this DSI output
+ * @is_bonded_dsi: True if two DSI controllers are bonded
  *
  * Adjust the pclk rate by calculating a new hdisplay proportional to
  * the compression ratio such that:
-- 
2.53.0



