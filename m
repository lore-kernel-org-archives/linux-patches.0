Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5413451CF;
	Tue, 16 Dec 2025 11:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885018; cv=none; b=pYpIKli9uYupkvQC0f86Y+a/GcKjdZDW5vxvirNobMfECf1K//qO7hD3cYjppjzTts9KwR5a7l9ilrfmdlAJr6YYodZa9HU25hS60sKXAEGWsumw7L/RwBMd95B11JMUwBNmAgJuwCDs/2K1491zY3jYE08iKs3c1G6LZ0Alx2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885018; c=relaxed/simple;
	bh=0KGgH2kZLZxr1yZkSf1mPDwlAwKZRAaXEGtP1FHF5E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVRtJEGCVKk2o1iM2lvz92d10pnSfDqEGs98zIpKpzq/tQgv0RU+JGQBnK/V7OIaj/+3ofvm8Go56VJJ5F110yQzPzG0lOf+bJpVBpUsHdk3Icxw52xcaDuzuweAEi6rcT3NNq8Ds+T1LYMCWdvuJbtfgUlNZYYvXSMEAOfk1vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BYO1s/tP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BYO1s/tP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D371EC4CEF5;
	Tue, 16 Dec 2025 11:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885018;
	bh=0KGgH2kZLZxr1yZkSf1mPDwlAwKZRAaXEGtP1FHF5E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BYO1s/tPIFgiYoo7LNRzUwKW8QiIMXtFDZOkBXliEyih9Atz3EPoYolA3f8YPXBFB
	 6FCGCGSnTucd0T2zEPMRA+LX0iX0Ik8Wk3isAxhmFZt3KQV+nJsn9eZzQoUsbsUB5a
	 jS9YYFq3MF2pVQKOEgo7SfqT4zQMOfi8DyLpR2P8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Hou <lizhi.hou@amd.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 014/507] accel/ivpu: Make function parameter names consistent
Date: Tue, 16 Dec 2025 12:07:35 +0100
Message-ID: <20251216111346.051714079@linuxfoundation.org>
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
index 9a3935be1c057..7081913fb0dde 100644
--- a/drivers/accel/ivpu/ivpu_fw.h
+++ b/drivers/accel/ivpu/ivpu_fw.h
@@ -45,7 +45,7 @@ struct ivpu_fw_info {
 int ivpu_fw_init(struct ivpu_device *vdev);
 void ivpu_fw_fini(struct ivpu_device *vdev);
 void ivpu_fw_load(struct ivpu_device *vdev);
-void ivpu_fw_boot_params_setup(struct ivpu_device *vdev, struct vpu_boot_params *bp);
+void ivpu_fw_boot_params_setup(struct ivpu_device *vdev, struct vpu_boot_params *boot_params);
 
 static inline bool ivpu_fw_is_cold_boot(struct ivpu_device *vdev)
 {
diff --git a/drivers/accel/ivpu/ivpu_hw_btrs.h b/drivers/accel/ivpu/ivpu_hw_btrs.h
index d2d82651976d1..032c384ac3d4d 100644
--- a/drivers/accel/ivpu/ivpu_hw_btrs.h
+++ b/drivers/accel/ivpu/ivpu_hw_btrs.h
@@ -36,7 +36,7 @@ u32 ivpu_hw_btrs_dpu_freq_get(struct ivpu_device *vdev);
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



