Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86812C1A5;
	Mon, 12 Aug 2024 16:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480332; cv=none; b=EFJL2VsFLfAErD6E31Qo7Gaexp9xik74lQ/viaadZpOYU50ypMvWyj9AiQ7WOUqmToNOWqaP733P+nZFwy2ZEemdUHrKYz3n1yHR2Uu9+w01C7nVrpKR+paA6wEfE3CkOUL7wTMbc2jRFQ7wOnJ6SUJ3j1CFFkMklhc3RtxBdJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480332; c=relaxed/simple;
	bh=MQI5LO58t9geenFfHxRQ0wN/IZgXXQvRpdtNXJxYaVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGw0kBa7X2vsG2TvradeAyu8pxgPsWRMMO6+pbDb2/PuEtT145jgZR0iKVQbJnXsyRTC3PbW87JEDdiVWHdprMPsTNpXWh//wUUoiDxoRm968GV7tXC76KzJBpqFRP+oExTtNtKy21Nby5Q0kM7fy3Alk5KIHc7BbZ4UpdLa7ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xuSdBqpp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xuSdBqpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31A6C32782;
	Mon, 12 Aug 2024 16:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480332;
	bh=MQI5LO58t9geenFfHxRQ0wN/IZgXXQvRpdtNXJxYaVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xuSdBqppKcOW0EBFf9R5WphRiDfB8LkEqEEQkltidI+ExR0YiGaxpItUHPigKIwZP
	 AvyQHRkalE6D8u5QU/zxaeEBO0dmWejwVjgAZ2if3e7bgkS46ej3JJ7nfGYLzcHhqR
	 sZKNfdjQWN8qZA8sxhv3FwfQPu4+rsqaUrmr3YqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 166/263] drm/xe: Minor cleanup in LRC handling
Date: Mon, 12 Aug 2024 18:02:47 +0200
Message-ID: <20240812160152.902221234@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>

[ Upstream commit 85cfc412579c041f1aaebba71427acec75ceca39 ]

Properly define register fields and remove redundant
lower_32_bits().

Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240507224255.5059-2-niranjana.vishwanathapura@intel.com
Stable-dep-of: 642dfc9d5964 ("drm/xe: Take ref to VM in delayed snapshot")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_engine_regs.h | 4 ++--
 drivers/gpu/drm/xe/xe_lrc.c              | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/regs/xe_engine_regs.h b/drivers/gpu/drm/xe/regs/xe_engine_regs.h
index af71b87d80301..03c6d4d50a839 100644
--- a/drivers/gpu/drm/xe/regs/xe_engine_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_engine_regs.h
@@ -44,9 +44,10 @@
 #define GSCCS_RING_BASE				0x11a000
 
 #define RING_TAIL(base)				XE_REG((base) + 0x30)
+#define   TAIL_ADDR				REG_GENMASK(20, 3)
 
 #define RING_HEAD(base)				XE_REG((base) + 0x34)
-#define   HEAD_ADDR				0x001FFFFC
+#define   HEAD_ADDR				REG_GENMASK(20, 2)
 
 #define RING_START(base)			XE_REG((base) + 0x38)
 
@@ -135,7 +136,6 @@
 #define   RING_VALID_MASK			0x00000001
 #define   RING_VALID				0x00000001
 #define   STOP_RING				REG_BIT(8)
-#define   TAIL_ADDR				0x001FFFF8
 
 #define RING_CTX_TIMESTAMP(base)		XE_REG((base) + 0x3a8)
 #define CSBE_DEBUG_STATUS(base)			XE_REG((base) + 0x3fc)
diff --git a/drivers/gpu/drm/xe/xe_lrc.c b/drivers/gpu/drm/xe/xe_lrc.c
index 615bbc372ac62..760f38992ff07 100644
--- a/drivers/gpu/drm/xe/xe_lrc.c
+++ b/drivers/gpu/drm/xe/xe_lrc.c
@@ -1354,7 +1354,7 @@ struct xe_lrc_snapshot *xe_lrc_snapshot_capture(struct xe_lrc *lrc)
 	if (!snapshot)
 		return NULL;
 
-	snapshot->context_desc = lower_32_bits(xe_lrc_ggtt_addr(lrc));
+	snapshot->context_desc = xe_lrc_ggtt_addr(lrc);
 	snapshot->head = xe_lrc_ring_head(lrc);
 	snapshot->tail.internal = lrc->ring.tail;
 	snapshot->tail.memory = xe_lrc_read_ctx_reg(lrc, CTX_RING_TAIL);
-- 
2.43.0



