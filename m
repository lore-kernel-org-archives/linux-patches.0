Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F641A618F;
	Tue, 30 Jul 2024 16:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357928; cv=none; b=R907ohne/De258Y5t9p9cO/SZ2RS9Ewq45GYBtRvQUsdfIjLWEJkuVHUEFQhkyMeZzaO1+QMutiuA0DpPr6Gv+P8hK8LnwTZ+9dSN3VWbj3/oJfZ550/toiZ8Y0W6UhoyPwma/t7ubwjt0zYUnjXSWrxzWpB8wNmG/4bbICDcTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357928; c=relaxed/simple;
	bh=M6oewx1rLCoECeCGCs1N1JLMZKuib6heUU1ZVRkxWBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QpgYNix45oKbhT7pvegMnjC1zKvXKQl/dMuy49JSSPF97E+7aAZirallNlR87IrlvCD37mflQOiMDYbIFKM/l+7UMkElr4vNJvHnICE94KAPioMo0SMA1cRFze5rQLQtYySX6J5OU1TRVPnv37nI/F0f4REI8UJ4tqle2EL1veg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpPPqJJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpPPqJJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ECA3C32782;
	Tue, 30 Jul 2024 16:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357927;
	bh=M6oewx1rLCoECeCGCs1N1JLMZKuib6heUU1ZVRkxWBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpPPqJJoVqOc/zC92NTAxq5J/KYXYPheHXqTkyKyWTgsnNjn8XGgzWQ92SRMA50gb
	 NPDSoduiXcayqNE1QnRzyYxRgmWmI8UgZ63IY0oHNDEL3amD/nZIiATK0AhpT5y98A
	 S+U5WnsC390w1hskaX8hYZQAB4KlQSr/32iwCwdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Animesh Manna <animesh.manna@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 305/809] drm/i915/psr: Print Panel Replay status instead of frame lock status
Date: Tue, 30 Jul 2024 17:43:01 +0200
Message-ID: <20240730151736.638217913@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 51ee1f29a9aceb8a52037ba4759d44c70e966fe5 ]

Currently Panel Replay status printout is printing frame lock status. It
should print Panel Replay status instead. Panel Replay status register
field follows PSR status register field. Use existing PSR code for that.

Fixes: ef75c25e8fed ("drm/i915/panelreplay: Debugfs support for panel replay")
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Animesh Manna <animesh.manna@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240607134917.1327574-10-jouni.hogander@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 58769197a1277..2b4512bd5b595 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -3694,16 +3694,9 @@ static int i915_psr_sink_status_show(struct seq_file *m, void *data)
 		"reserved",
 		"sink internal error",
 	};
-	static const char * const panel_replay_status[] = {
-		"Sink device frame is locked to the Source device",
-		"Sink device is coasting, using the VTotal target",
-		"Sink device is governing the frame rate (frame rate unlock is granted)",
-		"Sink device in the process of re-locking with the Source device",
-	};
 	const char *str;
 	int ret;
 	u8 status, error_status;
-	u32 idx;
 
 	if (!(CAN_PSR(intel_dp) || CAN_PANEL_REPLAY(intel_dp))) {
 		seq_puts(m, "PSR/Panel-Replay Unsupported\n");
@@ -3717,16 +3710,11 @@ static int i915_psr_sink_status_show(struct seq_file *m, void *data)
 	if (ret)
 		return ret;
 
-	str = "unknown";
-	if (intel_dp->psr.panel_replay_enabled) {
-		idx = (status & DP_SINK_FRAME_LOCKED_MASK) >> DP_SINK_FRAME_LOCKED_SHIFT;
-		if (idx < ARRAY_SIZE(panel_replay_status))
-			str = panel_replay_status[idx];
-	} else if (intel_dp->psr.enabled) {
-		idx = status & DP_PSR_SINK_STATE_MASK;
-		if (idx < ARRAY_SIZE(sink_status))
-			str = sink_status[idx];
-	}
+	status &= DP_PSR_SINK_STATE_MASK;
+	if (status < ARRAY_SIZE(sink_status))
+		str = sink_status[status];
+	else
+		str = "unknown";
 
 	seq_printf(m, "Sink %s status: 0x%x [%s]\n", psr_mode_str(intel_dp), status, str);
 
-- 
2.43.0



