Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618771;
	b=JDhE8N6/N1wB41JvJuHxmBGbUC24dM5E9LGFYaJfbhoWNCvcGaXc80AFpK6/E347tWHv
	 RbYoK/7Fm4T3TOtjcq7qRIjSB1T/oVFVat4d0Mc1/UnmNOTydHFUWpHrJLHKxS3QLolj0
	 TWCoKTFK6DNwcZR+himoNsxtTQgiIeS395HmON6sjR62leJfISCg2xr5OiVUhZvi/P6kY
	 rwDMXt9ilGtl8WSxD5E9jkDx0s++KyNbcQphqmWCDnSKAY/Hlmf07YxYnQHU4HuZTV+jP
	 e6cdSXIgmaPsiAAqdvBwgFZHai9Va+tM4vV/fVG0Bsq6+teH/yEUf8dZ8w6xsbVZ+JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618771;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=tX7iitDavLU/7kx7EgYsUvGi5BzrnRYdKJ/tLRO3qls=;
	b=B1n3aKDIzGtfTWxSRg4Jf54DZ83KnLKzWIUTFE1b1ulaEttyRKJTBAY2R2uBKSBKeTyQ
	 yqY/WhvYMJU7F3kTSkf7UYSES801J9+Kd1CiZSe9OfQ/lSUHGcKDNyNQZ9HIbWbijfwCo
	 aLY7NvG1roiQux2CSpTXplSXGzpi/l2/71t5cJhIRvv/feOnI61g6HA5W5iVkwLrZAUot
	 djz9kuPEK7OJP3sF1taSsJlDU/WMnRkJiNvCxnX0Pzdb9c3EY7/9Ed9S5ggW72WUfEw4C
	 0LyMiA2V9UaDl8X7Kx3UDlYjD3i+ouGzyCALdRUZSFRfqJs6bau9qcLHWvDe7yDo/YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v85XfoQq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7F7606A321;
	Wed, 25 Nov 2026 14:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v85XfoQq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AE31F000D3;
	Wed, 25 Nov 2026 14:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618770;
	bh=tX7iitDavLU/7kx7EgYsUvGi5BzrnRYdKJ/tLRO3qls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v85XfoQqbrSUX6L2fjKyLmSXL22d+yAsiRQqPCf8vaCtdZ9D6R10lqEQogYU5/wIU
	 wDGGEgosH/Y/YPUHC3YOV28V5hY4zXykklkvB4Uzd1Z3Ndx4Qq3SX3em+eTEKf/JbI
	 XKwA7kYi4f5WYYu3/WY8YOEfH2Mg9yKwLT+grFiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Grzelak?= <michal.grzelak@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0384/1005] drm/xe/pcode: match argument naming with PCODE_DATAx
Date: Wed, 25 Nov 2026 15:28:42 +0100
Message-ID: <20261125143830.733546407@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Grzelak <michal.grzelak@intel.com>

[ Upstream commit 68b966310260924a9dc6a5a96fd91cd190edbe2a ]

Variable naming of val and val1 should match register macro naming.

For xe, register macro naming of PCODE_DATA0 and PCODE_DATA1 is already
synced with register name. Nevertheless there are still functions
declaring val and val1. Rename val into val0 in functions declaring val1
in xe.

v4->v5
- clean changelog's versioning

v3->v4
- split i915 changes from xe (Jani)

v2->v3
- resolve conflict from rebase

v1->v2
- rebase onto drm-tip (Jani)

Bspec: 19978, 19979
Suggested-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Michał Grzelak <michal.grzelak@intel.com>
Link: https://patch.msgid.link/20260828190956.2622350-3-michal.grzelak@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: 94099304b80e ("drm/xe/hwmon: Fix pcode power limit handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/xe_display_pcode.c | 4 ++--
 drivers/gpu/drm/xe/xe_pcode.c                 | 4 ++--
 drivers/gpu/drm/xe/xe_pcode.h                 | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/display/xe_display_pcode.c b/drivers/gpu/drm/xe/display/xe_display_pcode.c
index f6820ef7e666d..8dc9cbdb18ec0 100644
--- a/drivers/gpu/drm/xe/display/xe_display_pcode.c
+++ b/drivers/gpu/drm/xe/display/xe_display_pcode.c
@@ -6,12 +6,12 @@
 #include "xe_device.h"
 #include "xe_pcode.h"
 
-static int xe_display_pcode_read(struct drm_device *drm, u32 mbox, u32 *val, u32 *val1)
+static int xe_display_pcode_read(struct drm_device *drm, u32 mbox, u32 *val0, u32 *val1)
 {
 	struct xe_device *xe = to_xe_device(drm);
 	struct xe_tile *tile = xe_device_get_root_tile(xe);
 
-	return xe_pcode_read(tile, mbox, val, val1);
+	return xe_pcode_read(tile, mbox, val0, val1);
 }
 
 static int xe_display_pcode_write_timeout(struct drm_device *drm, u32 mbox, u32 val, int timeout_ms)
diff --git a/drivers/gpu/drm/xe/xe_pcode.c b/drivers/gpu/drm/xe/xe_pcode.c
index ccc3bdeed6bb2..ccdfc33cf5876 100644
--- a/drivers/gpu/drm/xe/xe_pcode.c
+++ b/drivers/gpu/drm/xe/xe_pcode.c
@@ -136,12 +136,12 @@ int xe_pcode_write64_timeout(struct xe_tile *tile, u32 mbox, u32 data0, u32 data
 	return err;
 }
 
-int xe_pcode_read(struct xe_tile *tile, u32 mbox, u32 *val, u32 *val1)
+int xe_pcode_read(struct xe_tile *tile, u32 mbox, u32 *val0, u32 *val1)
 {
 	int err;
 
 	mutex_lock(&tile->pcode.lock);
-	err = pcode_mailbox_rw(tile, mbox, val, val1, 1, true, false);
+	err = pcode_mailbox_rw(tile, mbox, val0, val1, 1, true, false);
 	mutex_unlock(&tile->pcode.lock);
 
 	return err;
diff --git a/drivers/gpu/drm/xe/xe_pcode.h b/drivers/gpu/drm/xe/xe_pcode.h
index 8fb3e4ba13a6e..ba8a1d1b21521 100644
--- a/drivers/gpu/drm/xe/xe_pcode.h
+++ b/drivers/gpu/drm/xe/xe_pcode.h
@@ -23,7 +23,7 @@ int xe_pcode_probe_early(struct xe_device *xe);
 int xe_pcode_ready(struct xe_device *xe, bool locked);
 int xe_pcode_init_min_freq_table(struct xe_tile *tile, u32 min_gt_freq,
 				 u32 max_gt_freq);
-int xe_pcode_read(struct xe_tile *tile, u32 mbox, u32 *val, u32 *val1);
+int xe_pcode_read(struct xe_tile *tile, u32 mbox, u32 *val0, u32 *val1);
 int xe_pcode_write_timeout(struct xe_tile *tile, u32 mbox, u32 val,
 			   int timeout_ms);
 int xe_pcode_write64_timeout(struct xe_tile *tile, u32 mbox, u32 data0,
-- 
2.53.0



