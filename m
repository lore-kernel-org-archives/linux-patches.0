Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063865;
	b=g6P3IXECgbiLxAKv90lkbeAi9rKFT7454WFvdSVgYbZ1QPBfkzUYo3yAH93pn9XW+G3n
	 1paYhwSh5lc3+1MkDL5N88oRsRABuM4LfaBTeJjK3UF0efk3AHW9G4QoC23h2lxPbvk32
	 82y3lP5PxbQQVfRucIICNRDF/qiVwxp9obiY12VmU5G7J+OYfM5nlClv+9bX/NzNUr3Y3
	 vtMWMze1CSVABIuYxZTLWJ60Ff2sOah2xGpTIl/nhdbFAJj7N9/Uk7fkBjw7qx8Xsyk0y
	 aFpY3DlGkdF/+molKCuKqz+fmvIIvyJaDSr0OmZn5yPHaWX4puthK0hrppJ0bt9MYPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q6aSJtVgTIUL+g/vOtKIN0+wPCR7Xn6wdSpCpU+qMGA=;
	b=Cdq3Q7NVgP3ztP/VXLZakAGLIBXJOi67nYq9pFo2RTcmXc5f5V3vmEheUiMAQGxm8VjA
	 S6zytDc1vg1ih1jv8PF1nzipW6Fps+U0P1IAlxzYZs51MI/iH5NU72VQfrGW3Leq+OEeb
	 ywO84MzleCUDDR78kwwyg/3EPDcsm7gu4DpHXxYBKkWP+MtX40gW1tmcyKehFocmBFT5a
	 huzOp+PdUBYP3yK2lCtXLCKE5VnSceTeUHKJY9q53TfYXiXZguYj7UX7CVR/JIw0tOk66
	 R0WqgQflBBNHgiFFw2FQbXP4nfcJTgLs48pmht8RZVRHQYoQ/Z64Voyn7ttjiE/outA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oQKLI7W1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E684A606CE71;
	Sat,  7 Nov 2026 15:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oQKLI7W1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A231F0089F;
	Sat,  7 Nov 2026 15:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063864;
	bh=q6aSJtVgTIUL+g/vOtKIN0+wPCR7Xn6wdSpCpU+qMGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oQKLI7W1mFdwXb71uk2l0Y4x9jlgNm346pS4eGGJrBQe1w1CRk+fVgJCas5iXWHPt
	 WMRua2KVtXcckgE1EKZDruYFsyHGdMNnig68X2iQpJXJdb3ahIaGV7XccE33bAYS86
	 nVwQU3yVule37suwKl8qQrCCeaX/qptVowP9M8gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serin Yeh <serin.yeh@intel.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0071/1257] media: i2c: ov8856: fix debug message to report actual CSI-2 lane count
Date: Sat,  7 Nov 2026 08:39:27 -0500
Message-ID: <20261107134941.350720703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serin Yeh <serin.yeh@intel.com>

[ Upstream commit a15976e69b1c70ea16ef1f7172a846f6ef5dfa14 ]

The driver currently prints the number of data lanes using
ov8856->cur_mode->data_lanes in ov8856_get_hwcfg(). However,
the ov8856->cur_mode structure is not assigned to a clearly
supported mode at that point. Due to the missing pointer,
enabling dynamic debug may lead to a kernel panic.

Instead, the correct number of CSI-2 data lanes should be taken
from bus_cfg.bus.mipi_csi2.num_data_lanes, which represents the
real hardware configuration determined at runtime.

Fixes: c492ec9ae9ed ("media: ov8856: Add support for 2 data lanes")
Cc: stable@vger.kernel.org
Signed-off-by: Serin Yeh <serin.yeh@intel.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov8856.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov8856.c b/drivers/media/i2c/ov8856.c
index 9d2b0469a5761..6011233a218d4 100644
--- a/drivers/media/i2c/ov8856.c
+++ b/drivers/media/i2c/ov8856.c
@@ -2318,7 +2318,8 @@ static int ov8856_get_hwcfg(struct ov8856 *ov8856)
 		goto check_hwcfg_error;
 	}
 
-	dev_dbg(dev, "Using %u data lanes\n", ov8856->cur_mode->data_lanes);
+	dev_dbg(dev, "Using %u data lanes\n",
+		bus_cfg.bus.mipi_csi2.num_data_lanes);
 
 	if (bus_cfg.bus.mipi_csi2.num_data_lanes == 2)
 		ov8856->priv_lane = &lane_cfg_2;
-- 
2.53.0



