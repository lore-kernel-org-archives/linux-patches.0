Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79DF126C02;
	Tue, 16 Dec 2025 11:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883828; cv=none; b=uIyhTBW8j6jZm/BPlYZwFnqviyIS314tT2gwBUEaIUJFkOaJl0Crg7/3vqYU2mZYsQOkYaplVtl8adZooo+WhMOT2o8WulNXZ9UWp+A9ABH+2J+Cky6B61k63/3ELOw2qs76vkxPcY8NPsy9ypyIs9O2Rp7XR/dlno4jI2JbgqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883828; c=relaxed/simple;
	bh=IBHkBQ+ZJA6mvFke7g6RtAhP6ZEgzJszcoRfZfGxrdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soPw/qPQ+7OMMRpbjeG7tpxTWlY5mkm2ODx6RvNM/sy7XmyrxbI5mNWJwqKBfBdOJ3xZfkpXLYUJmGJg0Bbo6CekNQc+oshiMQx9A0ff7vpO9VOqkFr0F0Co2+Qb1IcKnDeeEhbE0VlhF3CynxKTMGyTmw/6devs4CAUcEAg1dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOy0alBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOy0alBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24FDC4CEF1;
	Tue, 16 Dec 2025 11:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883828;
	bh=IBHkBQ+ZJA6mvFke7g6RtAhP6ZEgzJszcoRfZfGxrdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOy0alBLrgTE8INfAaaAYRnDdds8+4TXQF8auIFazZcN+suhUMYPXFXXuox+FP7yT
	 U9BtIxhcSEfF+ZVQi7K+ctHLVnkMyZhuhxrXE+FcAgxhZxzld+ysAxHj//fKq9pIM+
	 UPOIISBIHgwDfJJdb+PPOE70OPkTkp1DXXKOQx8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Hou <lizhi.hou@amd.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/354] accel/ivpu: Make function parameter names consistent
Date: Tue, 16 Dec 2025 12:09:39 +0100
Message-ID: <20251216111321.352410151@linuxfoundation.org>
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

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

[ Upstream commit cf87f93847dea607e8a35983cb006ef8493f8065 ]

Make ivpu_hw_btrs_dct_set_status() and ivpu_fw_boot_params_setup()
declaration and definition parameter names consistent.

Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://lore.kernel.org/r/20250808111014.328607-1-jacek.lawrynowicz@linux.intel.com
Stable-dep-of: aa1c2b073ad2 ("accel/ivpu: Fix DCT active percent format")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_fw.h      | 2 +-
 drivers/accel/ivpu/ivpu_hw_btrs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_fw.h b/drivers/accel/ivpu/ivpu_fw.h
index 1d0b2bd9d65cf..e6a1a1d0960c7 100644
--- a/drivers/accel/ivpu/ivpu_fw.h
+++ b/drivers/accel/ivpu/ivpu_fw.h
@@ -44,7 +44,7 @@ struct ivpu_fw_info {
 int ivpu_fw_init(struct ivpu_device *vdev);
 void ivpu_fw_fini(struct ivpu_device *vdev);
 void ivpu_fw_load(struct ivpu_device *vdev);
-void ivpu_fw_boot_params_setup(struct ivpu_device *vdev, struct vpu_boot_params *bp);
+void ivpu_fw_boot_params_setup(struct ivpu_device *vdev, struct vpu_boot_params *boot_params);
 
 static inline bool ivpu_fw_is_cold_boot(struct ivpu_device *vdev)
 {
diff --git a/drivers/accel/ivpu/ivpu_hw_btrs.h b/drivers/accel/ivpu/ivpu_hw_btrs.h
index 3855e2df1e0c8..7650f15b7ffa4 100644
--- a/drivers/accel/ivpu/ivpu_hw_btrs.h
+++ b/drivers/accel/ivpu/ivpu_hw_btrs.h
@@ -35,7 +35,7 @@ u32 ivpu_hw_btrs_dpu_max_freq_get(struct ivpu_device *vdev);
 bool ivpu_hw_btrs_irq_handler_mtl(struct ivpu_device *vdev, int irq);
 bool ivpu_hw_btrs_irq_handler_lnl(struct ivpu_device *vdev, int irq);
 int ivpu_hw_btrs_dct_get_request(struct ivpu_device *vdev, bool *enable);
-void ivpu_hw_btrs_dct_set_status(struct ivpu_device *vdev, bool enable, u32 dct_percent);
+void ivpu_hw_btrs_dct_set_status(struct ivpu_device *vdev, bool enable, u32 active_percent);
 u32 ivpu_hw_btrs_telemetry_offset_get(struct ivpu_device *vdev);
 u32 ivpu_hw_btrs_telemetry_size_get(struct ivpu_device *vdev);
 u32 ivpu_hw_btrs_telemetry_enable_get(struct ivpu_device *vdev);
-- 
2.51.0



