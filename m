Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621822;
	b=IHbDKghotjh+bmHNJoGl6tYGRXp6j48KTv3I4R1aINatqhYegPOudSDV7Gr94H6DzDpb
	 0o/WPZnPm1bFDlV9qlvJQP6zJNxFZVca+CZLhtzq0a8DpQWTvi2shXyZV3+FsnsfTFCnN
	 q7crqMbO9BHcpnp8zJccTm2KPw2044TKsbL89GGjgbPvQ+tBex/UbXe34hTJUJUm56i/c
	 FONZJ/fNyPYOCoxQxTfF2corWteXGXiPsSke4pDJfHye1lBKZY7Sk+6AJOLpokMEIMbwz
	 5w2QQmfMH4LUDlyV86MwYEMqzn/H6oBF7qBHi6GJJuMHzbTfQhraCJlKV38x5e6u1oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XFpd7LpVJhqMPGC1O2RVhdhSKSa/qWuwRQe21jzHb+A=;
	b=i3VSbIeNSbh+rQZYRrtEvhouGelzaXTl1cBz2ieIh8pMAzhrqAaa55BHEk3aH/GKL+Tc
	 Ddp8j4E6zGJVkyvAPMAyJtgSSZGLsuyjwY4N5cxLdzE93kxy9OwIQpuA8S2iZvjoIIjGK
	 kFPO5eSdxLFRCP4kVC7Bf5GFolWgopz+ffpGDQqi+51HVvWe1ttm7If4jxeirLtHCSdbV
	 9iG26dBg+6gepVtQBf5nh2uI9k/irGc5Qge1dVHg2I9lm+FKJn5Wvgn3hEAlJTOeoz/Us
	 MaIuOf3AiZqtiNUjjTTYNO9eEd/qpfaGeVsdCV6oWEdlEP7HPH9DL5MZ3jYqiZWUjSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iFiX8FET;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43E6606A335;
	Wed, 25 Nov 2026 15:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iFiX8FET
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E773A1F000CA;
	Wed, 25 Nov 2026 15:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621822;
	bh=XFpd7LpVJhqMPGC1O2RVhdhSKSa/qWuwRQe21jzHb+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iFiX8FETtFf6NtJBfiZPHQzhdh9+lsVsfZWODdyFEVmFrzguMaKB8NcpTOARw1ggr
	 43MdfIR8NcIWR3m2h1OSPjge/sYwbAmbm24Yt1ZDxFfalKZ9jHJaWXMwpIIixxm7Tp
	 uk8xUJtSBFwp4pTfskceH8OQxQJUYnI1/CgTBoiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Helen Koike <koike@igalia.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 344/990] drm/xe/lrc: Restore CTX_CS_INDIRECT_CTX_OFFSET programming for pre-Xe2
Date: Wed, 25 Nov 2026 15:28:31 +0100
Message-ID: <20261125143830.150453843@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helen Koike <koike@igalia.com>

[ Upstream commit badac1974e098dba1a0a7f413e53f5b6ae24ab10 ]

CTX_CS_INDIRECT_CTX_OFFSET default value is not retrieved from the GPU
by inhibit+context save mechanism since it is not part of the Engine
Context. Thus, at restore, 0x0 is programmed back to the GPU, which is
an invalid value according to the PRM.

This causes sporadic hangs on Alder Lake when executing test
IntelAngleEnd2EndTestCases (error VK_DEVICE_LOST).

Fix it by partially reverting commit c9dfd66cb91e ("drm/xe/lrc: Allow
INDIRECT_CTX for more engine classes"). Re-add the programming of
CTX_CS_INDIRECT_CTX_OFFSET for pre-Xe2 (in theory it should apply to all
platforms, but we got an unexpected behaviour on Xe2 that still requires
investigation).

Fixes: c9dfd66cb91e ("drm/xe/lrc: Allow INDIRECT_CTX for more engine classes")
Suggested-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Helen Koike <koike@igalia.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patch.msgid.link/20261016214112.1647202-1-koike@igalia.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit b99292acb2dce61ce50d37f54a66d84b768b8927)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_lrc_layout.h | 3 +++
 drivers/gpu/drm/xe/xe_lrc.c             | 8 ++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/regs/xe_lrc_layout.h b/drivers/gpu/drm/xe/regs/xe_lrc_layout.h
index b5eff383902c5..1b101edb838bf 100644
--- a/drivers/gpu/drm/xe/regs/xe_lrc_layout.h
+++ b/drivers/gpu/drm/xe/regs/xe_lrc_layout.h
@@ -40,4 +40,7 @@
 #define INDIRECT_CTX_RING_START_UDW	(0x08 + 1)
 #define INDIRECT_CTX_RING_CTL		(0x0a + 1)
 
+#define CTX_INDIRECT_CTX_OFFSET_MASK	REG_GENMASK(15, 6)
+#define CTX_INDIRECT_CTX_OFFSET_DEFAULT	REG_FIELD_PREP(CTX_INDIRECT_CTX_OFFSET_MASK, 0xd)
+
 #endif
diff --git a/drivers/gpu/drm/xe/xe_lrc.c b/drivers/gpu/drm/xe/xe_lrc.c
index 53eadea8ab38d..29a30e83f988c 100644
--- a/drivers/gpu/drm/xe/xe_lrc.c
+++ b/drivers/gpu/drm/xe/xe_lrc.c
@@ -1371,15 +1371,15 @@ setup_indirect_ctx(struct xe_lrc *lrc, struct xe_hw_engine *hwe)
 	finish_bo(&state);
 	kfree(state.buffer);
 
-	/*
-	 * Enable INDIRECT_CTX leaving INDIRECT_CTX_OFFSET at its default: it
-	 * varies per engine class, but the default is good enough
-	 */
 	xe_lrc_write_ctx_reg(lrc,
 			     CTX_CS_INDIRECT_CTX,
 			     (xe_bo_ggtt_addr(lrc->bo) + state.offset) |
 			     /* Size in CLs. */
 			     (state.written * sizeof(u32) / 64));
+	if (GRAPHICS_VER(lrc_to_xe(lrc)) < 20)
+		xe_lrc_write_ctx_reg(lrc,
+				     CTX_CS_INDIRECT_CTX_OFFSET,
+				     CTX_INDIRECT_CTX_OFFSET_DEFAULT);
 
 	return 0;
 }
-- 
2.53.0



