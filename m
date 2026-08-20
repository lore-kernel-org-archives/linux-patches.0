Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701B92931C0;
	Thu, 20 Aug 2026 17:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248449; cv=none; b=QZlLQO9HoH70yjsW1bQDlo2FlAmgPsrX2k0COEgaDK39/aLG+xS3f+HDQzqy8UEyjwHJ+XoDZjWWgk8GXiRwXhyonkVkvkKCtZBdyIbSPXMuxyyeJyA7HoAyJGmLIfqzgFnkNmU4tFpZy3hS2xlSTNLYuAbbmeQX4VxCPj3WdUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248449; c=relaxed/simple;
	bh=J5ini2/lHjSKhhZja+Gy7mByD2M19PIMTqwdXhYOvn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Np+x9+rhX1i0AkhD8DxZJRG/qZorDSnIIvsaW1zGTWP+wa0966JCZ59RcVkHwJnN30SqZxm0WVFah+vevl8ATnnHMl1EOpWnbP0ZWcI7HR2lFeB+Sc4rGWD0yoQsIRKqhfWd4kJR5EhbVOopJpQsQGBz5MhZQDGBhDaBYPQ2VTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qod44h1Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qod44h1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB051F000E9;
	Thu, 20 Aug 2026 17:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248448;
	bh=zwjujhDktDNl4hUyjkebaTI1MxnHyq1XxDbEi44tD0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qod44h1ZWiQDNGoctHTz7re+y2BROCOKuTj4TDaTtPyUd3AwYd3VIeY0kiSj2OlvT
	 11V0pMdPr0HGP3UtdEt9SxNACvp6xzzhY9G+0Qy48c0Jc0AMhrc9XTulvaXPOc4wnd
	 u21jAyTKAauXT2wWQ2elUHsC+me4JjZjdV+/0SNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/303] drm/i915/hdcp: Move to using intel_display in intel_hdcp
Date: Thu, 20 Aug 2026 16:55:28 +0200
Message-ID: <20260820145259.085422930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Kandpal <suraj.kandpal@intel.com>

[ Upstream commit e35bf8f6a0ff06ceeff15bb032351cd5d006f92b ]

Move to using intel_display wherever possible in intel_hdcp.c
as a part of code refactor.

--v2
-Move intel_display to the first line wherever possible [Jani]
-use the closest reference when using to_intel_display [Jani]

Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240911090540.643155-2-suraj.kandpal@intel.com
Stable-dep-of: db9e64c983dc ("drm/i915/hdcp: require monotonically increasing seq_num_v")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display_core.h |    3 +++
 drivers/gpu/drm/i915/display/intel_hdcp.c         |   12 ++++++------
 drivers/gpu/drm/i915/i915_driver.c                |    3 +++
 3 files changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display_core.h
+++ b/drivers/gpu/drm/i915/display/intel_display_core.h
@@ -244,6 +244,9 @@ struct intel_wm {
 };
 
 struct intel_display {
+	/* drm device backpointer */
+	struct drm_device *drm;
+
 	/* Display functions */
 	struct {
 		/* Top level crtc-ish functions */
--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -1634,8 +1634,8 @@ out:
 static
 int hdcp2_authenticate_repeater_topology(struct intel_connector *connector)
 {
+	struct intel_display *display = &to_i915(connector->base.dev)->display;
 	struct intel_digital_port *dig_port = intel_attached_dig_port(connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
 	struct intel_hdcp *hdcp = &connector->hdcp;
 	union {
 		struct hdcp2_rep_send_receiverid_list recvid_list;
@@ -1655,7 +1655,7 @@ int hdcp2_authenticate_repeater_topology
 
 	if (HDCP_2_2_MAX_CASCADE_EXCEEDED(rx_info[1]) ||
 	    HDCP_2_2_MAX_DEVS_EXCEEDED(rx_info[1])) {
-		drm_dbg_kms(&dev_priv->drm, "Topology Max Size Exceeded\n");
+		drm_dbg_kms(display->drm, "Topology Max Size Exceeded\n");
 		return -EINVAL;
 	}
 
@@ -1672,23 +1672,23 @@ int hdcp2_authenticate_repeater_topology
 		drm_hdcp_be24_to_cpu((const u8 *)msgs.recvid_list.seq_num_v);
 
 	if (!hdcp->hdcp2_encrypted && seq_num_v) {
-		drm_dbg_kms(&dev_priv->drm,
+		drm_dbg_kms(display->drm,
 			    "Non zero Seq_num_v at first RecvId_List msg\n");
 		return -EINVAL;
 	}
 
 	if (seq_num_v < hdcp->seq_num_v) {
 		/* Roll over of the seq_num_v from repeater. Reauthenticate. */
-		drm_dbg_kms(&dev_priv->drm, "Seq_num_v roll over.\n");
+		drm_dbg_kms(display->drm, "Seq_num_v roll over.\n");
 		return -EINVAL;
 	}
 
 	device_cnt = (HDCP_2_2_DEV_COUNT_HI(rx_info[0]) << 4 |
 		      HDCP_2_2_DEV_COUNT_LO(rx_info[1]));
-	if (drm_hdcp_check_ksvs_revoked(&dev_priv->drm,
+	if (drm_hdcp_check_ksvs_revoked(display->drm,
 					msgs.recvid_list.receiver_ids,
 					device_cnt) > 0) {
-		drm_err(&dev_priv->drm, "Revoked receiver ID(s) is in list\n");
+		drm_err(display->drm, "Revoked receiver ID(s) is in list\n");
 		return -EPERM;
 	}
 
--- a/drivers/gpu/drm/i915/i915_driver.c
+++ b/drivers/gpu/drm/i915/i915_driver.c
@@ -844,6 +844,9 @@ i915_driver_create(struct pci_dev *pdev,
 
 	pci_set_drvdata(pdev, i915);
 
+	/* Add drm device backpointer as early as possible. */
+	i915->display.drm = &i915->drm;
+
 	/* Device parameters start as a copy of module parameters. */
 	i915_params_copy(&i915->params, &i915_modparams);
 


