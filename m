Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A4354903;
	Tue, 14 May 2024 10:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683159; cv=none; b=t+Qiyk3TgF0tRqAeO9gi/m1fRAxk5aayQkFtvVhYunqYKjPDShU+qrxcdS5yDDTh/s5D93VGXKJcs1yH/sGVMC00NMsbEyflOoytDGHKKUpYRIdwurMwqhr2LZjZIXXFJO1cFvmrc0Cz2gXxkNtrE22LVNtWpR+ZwkQCZtzKZJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683159; c=relaxed/simple;
	bh=/47mo8Rx+iz3sUts4k9QgnQeEfOWbR0Er/bsqtlPCv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuhN+xJx4ua2lYjzgQez0pRg/0RTKDv7ibV4FtsaohTRCf+PqlpxVg2209/AvrQOZlrtmCLhER5xKSmrf5A8UPaGfy8KUf1dWCbY9h2QV6mQH7Dcw+L6qlr/oOVifPW9zgkRyrn+FlclIAF4/vYJlfJJEkJ1z+BlrcTuGuWWDs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXYJPaSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXYJPaSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E84C2BD10;
	Tue, 14 May 2024 10:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683158;
	bh=/47mo8Rx+iz3sUts4k9QgnQeEfOWbR0Er/bsqtlPCv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXYJPaSGNUPIrF3q3bT8GC6TnKhKSESqOEyXJ0JAPXjfEcxBYpKBgLbBglpivpq90
	 FciBeRLEBwwULfFj4PkCklWN1YrEX79ofx+jwuYyG0bC+DhnuClW+8UTZicrKNhSDJ
	 rh8AX5NrPEU4zS5YfM2iFkeMrAkAVxZ3lYcZm5bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 174/336] drm/xe: Label RING_CONTEXT_CONTROL as masked
Date: Tue, 14 May 2024 12:16:18 +0200
Message-ID: <20240514101045.171847996@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

[ Upstream commit f76646c83f028c62853c23dac49204232e903597 ]

RING_CONTEXT_CONTROL is a masked register.

v2: Also clean up setting register value (Lucas)

Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240404161256.3852502-1-ashutosh.dixit@intel.com
(cherry picked from commit dc30c6e7149baaae4288c742de95212b31f07438)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_engine_regs.h | 2 +-
 drivers/gpu/drm/xe/xe_lrc.c              | 5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/regs/xe_engine_regs.h b/drivers/gpu/drm/xe/regs/xe_engine_regs.h
index 5592774fc6903..81b8362e93406 100644
--- a/drivers/gpu/drm/xe/regs/xe_engine_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_engine_regs.h
@@ -120,7 +120,7 @@
 #define RING_EXECLIST_STATUS_LO(base)		XE_REG((base) + 0x234)
 #define RING_EXECLIST_STATUS_HI(base)		XE_REG((base) + 0x234 + 4)
 
-#define RING_CONTEXT_CONTROL(base)		XE_REG((base) + 0x244)
+#define RING_CONTEXT_CONTROL(base)		XE_REG((base) + 0x244, XE_REG_OPTION_MASKED)
 #define	  CTX_CTRL_INHIBIT_SYN_CTX_SWITCH	REG_BIT(3)
 #define	  CTX_CTRL_ENGINE_CTX_RESTORE_INHIBIT	REG_BIT(0)
 
diff --git a/drivers/gpu/drm/xe/xe_lrc.c b/drivers/gpu/drm/xe/xe_lrc.c
index 0aa4bcfb90d9d..72f04a656e8b1 100644
--- a/drivers/gpu/drm/xe/xe_lrc.c
+++ b/drivers/gpu/drm/xe/xe_lrc.c
@@ -523,9 +523,8 @@ static const u8 *reg_offsets(struct xe_device *xe, enum xe_engine_class class)
 
 static void set_context_control(u32 *regs, struct xe_hw_engine *hwe)
 {
-	regs[CTX_CONTEXT_CONTROL] = _MASKED_BIT_ENABLE(CTX_CTRL_INHIBIT_SYN_CTX_SWITCH) |
-				    _MASKED_BIT_DISABLE(CTX_CTRL_ENGINE_CTX_RESTORE_INHIBIT) |
-				    CTX_CTRL_ENGINE_CTX_RESTORE_INHIBIT;
+	regs[CTX_CONTEXT_CONTROL] = _MASKED_BIT_ENABLE(CTX_CTRL_INHIBIT_SYN_CTX_SWITCH |
+						       CTX_CTRL_ENGINE_CTX_RESTORE_INHIBIT);
 
 	/* TODO: Timestamp */
 }
-- 
2.43.0



