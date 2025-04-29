Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269BF2512D9;
	Tue, 29 Apr 2025 16:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945723; cv=none; b=ryRjfpRDLMUF6K0/Jjpq9bZobrXr8+QywLiJ1gdj2lUWIuz567iNr217tpBmatkrDtvFRFMAPl8KrxKuUlIPQD4ka6bebgxoaXi8znNlyg0msCPUKvZ8xp597iJtKXCRGE537XKmLalurjv6qzkgiB7V5BQfXdtjv7mDRPGnKv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945723; c=relaxed/simple;
	bh=gHV3pY57KtVMq+C2d8BfSY/vJhUk5qDg4pbwHFugiAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLo3tGGeP0nPdg8WhN3nwgS7Ci2hwxgE7x3lmS6Q8cx1uOkSW5nY9NdFBindftEvmWXgNLSJ9xwvp1aD1HVytekUlaruq9L+xLw+jJQ94KCgGvbEIW+16aAQvcz1viiX0kBaWABcKwQcYl5l91ejV00jnaSUe+6QlZya3SqfS7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jF0yBird; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jF0yBird"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDD0C4CEE9;
	Tue, 29 Apr 2025 16:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945723;
	bh=gHV3pY57KtVMq+C2d8BfSY/vJhUk5qDg4pbwHFugiAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jF0yBirdtA/kky+D/YzH5bC1DJrIKG2l5tTjBq7Mv4oYOoZGPFdfK+WZ+S7/oFgf0
	 Ry/sVT/7pGbykBEpl1kF7OcqCN9qJZQSP9vBxn+yKKjM3Lq3TgeOdZxoEXoAXyTW32
	 PSydTwc0zydqC/t4luv4kX+fKA89H9a3Md8mYUA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 028/311] drm/xe/xe3lpg: Add Wa_13012615864
Date: Tue, 29 Apr 2025 18:37:45 +0200
Message-ID: <20250429161122.190626078@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

[ Upstream commit 2399bcc07c01189737858e0a88ac4ffdd1d4b03d ]

Wa_13012615864 applies to  xe3lpg

Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250221112200.388612-1-tejas.upadhyay@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Stable-dep-of: 262de94a3a7e ("drm/xe: Ensure fixed_slice_mode gets set after ccs_mode change")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h | 1 +
 drivers/gpu/drm/xe/xe_wa.c           | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/xe/regs/xe_gt_regs.h b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
index b4283ac030f41..d0ea8a55fd9c2 100644
--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -475,6 +475,7 @@
 #define TDL_TSL_CHICKEN				XE_REG_MCR(0xe4c4, XE_REG_OPTION_MASKED)
 #define   STK_ID_RESTRICT			REG_BIT(12)
 #define   SLM_WMTP_RESTORE			REG_BIT(11)
+#define   RES_CHK_SPR_DIS			REG_BIT(6)
 
 #define ROW_CHICKEN				XE_REG_MCR(0xe4f0, XE_REG_OPTION_MASKED)
 #define   UGM_BACKUP_MODE			REG_BIT(13)
diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index ac471e2454d34..db99663963010 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -618,6 +618,11 @@ static const struct xe_rtp_entry_sr engine_was[] = {
 		       FUNC(xe_rtp_match_first_render_or_compute)),
 	  XE_RTP_ACTIONS(SET(TDL_CHICKEN, QID_WAIT_FOR_THREAD_NOT_RUN_DISABLE))
 	},
+	{ XE_RTP_NAME("13012615864"),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(3000, 3001),
+		       FUNC(xe_rtp_match_first_render_or_compute)),
+	  XE_RTP_ACTIONS(SET(TDL_TSL_CHICKEN, RES_CHK_SPR_DIS))
+	},
 
 	{}
 };
-- 
2.39.5



