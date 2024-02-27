Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E2F13A87C;
	Tue, 27 Feb 2024 13:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040896; cv=none; b=MZ9kKNQHTaSA5bGkGlLXn0fPYSUKGL3Ic8FljwwciKfEgF/OQkBlkLDYCg0NUImj0VPAEqFagIJtFWFKrExgAFd51VmXG/g8oliG6RPpGrf9pS3RAOKLTHJ+EN+f0IUxBWAjXrZRcSs8PSeAPEAUFW2WRoWabT9R7L2WUB83o/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040896; c=relaxed/simple;
	bh=3VQHGZ2ZhCU9iNQSDqo9El6HIRW7ktAqfub278UK1Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jl7uPCFHte1500H4jZftwvE6X1xvMyBCYJvcToEvF8OsJSs5nKyPeTnuv8PmXKrQP0yhHXam6W9uq+rTAvn+HZLl9lzkwrFuTHxlt+sR4jmPvWyqXwIXAHcE3n3fTUVcTEbv/VBaTjqwuNm5DywyojMLWMldOQz0bYC5JrAkHcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VRD8LZ5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VRD8LZ5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC83C433C7;
	Tue, 27 Feb 2024 13:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040895;
	bh=3VQHGZ2ZhCU9iNQSDqo9El6HIRW7ktAqfub278UK1Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRD8LZ5ivG+QG97f0qihxDOrFM+pJmHOkH9yqX4OAGeBMluOgthCaMiqvL0AKlL+U
	 BtIQX9oir86F8evw2x0dAoSqzCfDkD2ms6XVsla0eqTiMrj9wrfH5zfEhb9GSAdtAD
	 3DVGpqgreILTRkWnGPbpvnFpbCbGcteXPbCpR4mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krystian Pradzynski <krystian.pradzynski@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 120/334] accel/ivpu/40xx: Stop passing SKU boot parameters to FW
Date: Tue, 27 Feb 2024 14:19:38 +0100
Message-ID: <20240227131634.348741792@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krystian Pradzynski <krystian.pradzynski@intel.com>

[ Upstream commit 553099da45397914a995dce6307d6c26523c2567 ]

This parameter was never used by the 40xx FW.

Signed-off-by: Krystian Pradzynski <krystian.pradzynski@intel.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240126122804.2169129-7-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_hw_40xx.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_hw_40xx.c b/drivers/accel/ivpu/ivpu_hw_40xx.c
index 8a7440bcd6df6..a7c976256ed32 100644
--- a/drivers/accel/ivpu/ivpu_hw_40xx.c
+++ b/drivers/accel/ivpu/ivpu_hw_40xx.c
@@ -700,7 +700,6 @@ static int ivpu_hw_40xx_info_init(struct ivpu_device *vdev)
 {
 	struct ivpu_hw_info *hw = vdev->hw;
 	u32 tile_disable;
-	u32 tile_enable;
 	u32 fuse;
 
 	fuse = REGB_RD32(VPU_40XX_BUTTRESS_TILE_FUSE);
@@ -721,10 +720,6 @@ static int ivpu_hw_40xx_info_init(struct ivpu_device *vdev)
 	else
 		ivpu_dbg(vdev, MISC, "Fuse: All %d tiles enabled\n", TILE_MAX_NUM);
 
-	tile_enable = (~tile_disable) & TILE_MAX_MASK;
-
-	hw->sku = REG_SET_FLD_NUM(SKU, HW_ID, LNL_HW_ID, hw->sku);
-	hw->sku = REG_SET_FLD_NUM(SKU, TILE, tile_enable, hw->sku);
 	hw->tile_fuse = tile_disable;
 	hw->pll.profiling_freq = PLL_PROFILING_FREQ_DEFAULT;
 
-- 
2.43.0



