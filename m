Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618807;
	b=ZpzIgaDsjMZobOnI5UBF3HfBhMCERQO5WnNLVZK/8PT5riA06bq6LONanI3HEgdWz3wc
	 pySAIkZIus75WWnBf0MNyVSR9CUeHDmSZMbWoN4btgtRHqp9OI4YxQTb+shWtA2+6dvxu
	 kc1k4xGoNfD9UQZHDgV0lbtpLbamy1Gf4JqoTBYTOAsCTXInta5MXZz/2dlq6snEV+qWQ
	 qVM5OxYTtdC7iMXHybxTX2T103UdJSFf2jiLQDySJiDjZ26waXjdxY08LCFoL7G3P7HBn
	 0EXOJfL+ur4ULg+gPCFqpS4LNovvQ/F+W5GS+eVd+xMPR2rCo2fNShuoHbyoZQmzldg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=enW6Fn+98HDNpkqdb1HfUlFx4H/NqaHAkj0zZOH0O3A=;
	b=5g3S8Z8yIeq6DdD8mTM14n0Qzu4XSCDTYYC+7WGhZ4tQ+3Y5I4oVx5fhl37S2tz93Ghe
	 AhtbIZeORNSASILfNZCUVPgpb2xdyWECVwLV3JQOfHsmQ4idV12CJ6dvGMb77QhS/93+L
	 Fj0S5ByeADuIZdmRu1v6jotWA8jrCJ34O7ijTg2PwsP3+YGHfywDZUFMoVqFT8yKpoORP
	 rinkwsJGzr8+Z4GbUatiB4TVh0IEHG3FNpJWOzSoRIHlL9/K66HxkP6/cl1pwfH0QWruq
	 mKIWURb/G+jn/BSkfrdtBp1dZpWk13GeRUdiog6BhPORcG0+fyqaHabrCVBf8K8l4UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MzESNtOt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22920606A323;
	Wed, 25 Nov 2026 15:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MzESNtOt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AE21F000CA;
	Wed, 25 Nov 2026 15:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618807;
	bh=enW6Fn+98HDNpkqdb1HfUlFx4H/NqaHAkj0zZOH0O3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MzESNtOtWOjvSYaNRqjl2GU+WPBtjqBYhZ5Y9Wmy+FWyA61jNaV7irhSCBNMJsRUB
	 dPm/RRR9fO3mU0tvWzMiI2uH9n6EQQiXZpYk+QpJLRpTeiL6o1OS4WSYTlIBkfXfwS
	 5N93w+aV4ad1XG7SH825aDj+Y+iDx1aps/lKGarA=
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
Subject: [PATCH 7.3 0394/1005] drm/xe/lrc: Restore CTX_CS_INDIRECT_CTX_OFFSET programming for pre-Xe2
Date: Wed, 25 Nov 2026 15:28:52 +0100
Message-ID: <20261125143830.973289305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
index 4ab86fc369fdf..e4c7c35497354 100644
--- a/drivers/gpu/drm/xe/regs/xe_lrc_layout.h
+++ b/drivers/gpu/drm/xe/regs/xe_lrc_layout.h
@@ -43,4 +43,7 @@
 #define INDIRECT_CTX_RING_START_UDW	(0x08 + 1)
 #define INDIRECT_CTX_RING_CTL		(0x0a + 1)
 
+#define CTX_INDIRECT_CTX_OFFSET_MASK	REG_GENMASK(15, 6)
+#define CTX_INDIRECT_CTX_OFFSET_DEFAULT	REG_FIELD_PREP(CTX_INDIRECT_CTX_OFFSET_MASK, 0xd)
+
 #endif
diff --git a/drivers/gpu/drm/xe/xe_lrc.c b/drivers/gpu/drm/xe/xe_lrc.c
index e4388a9604909..2e44a7000d955 100644
--- a/drivers/gpu/drm/xe/xe_lrc.c
+++ b/drivers/gpu/drm/xe/xe_lrc.c
@@ -1461,15 +1461,15 @@ setup_indirect_ctx(struct xe_lrc *lrc, struct xe_hw_engine *hwe)
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



