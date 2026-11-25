Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618758;
	b=YAFmXboJZyWYsnc/iREx1HZNL17UfvrYl0UiaRvKYiTaotoUmhN6lu2FVgUiMJ7hr+wr
	 donHSrdWCi4qNVCKxIC7nuBtrjqOAaCy2IflBVzEiBygiLGtxU4CuS4bhVetXSQtsEKIt
	 iNFC7UyKyQkjzQy35cEYVU1xlBayGr7OyBC2ZARLUt4ThA/xQDNQhnddXW9RVJHrykiF3
	 8ZETnmYCSAWaEgG18MAC6VPEX7/732v7MSxBvAynNuO29WhFmLZ4Bv3scbCjjqG4zzI1S
	 fEhuQzzunS0m+jh/osft6bM0REaYgk1TIp5kI282hX0TbBZgcpj6RQ/HJZljh6LymXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d7Wngl4BV5BXV9hsvwagjOdGFU0gbV5qvmz5iO+4kh8=;
	b=MeCEW1enqeT+7+qMKyLVCB45kjmbNDViYVOlOOQzVth5xTgUNMFhQoipQztfY19GGEIk
	 3F61w03r7xZVjfwQEWwJjwQoL9OOiBflxeSDvK+cMYwhes7XU7WC/WsuCEeEzI09zGxjD
	 j5y05d2FDQAC/k2QxBw+aCycjwCvcWvukOhRQ++BrrstHCAyrl1jX4RMKlkynFBGVgwM4
	 i/gV0BhAnACO+wpFFlZYxvM0devyuE3QuFUFLTxKAiaivcOZ1OjeoIlSpGcQOvurRLh7i
	 rJVNuJhuKiMbfd7M4WvwtdH+mcDpM/TkXEJl1uM8j+bwZOuYetlZXfNQc3dbwEhP+dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QgPSkWwP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E46606A321;
	Wed, 25 Nov 2026 14:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QgPSkWwP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2001F000D1;
	Wed, 25 Nov 2026 14:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618757;
	bh=d7Wngl4BV5BXV9hsvwagjOdGFU0gbV5qvmz5iO+4kh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QgPSkWwPHmVN6PmiqfVYgwmLyYo/odVuiVZ4H0eo4+JserFcqRZcqWx4mc1+qUo+i
	 3zf6UmRFLVM15Dv8HlOdeIOb8e2jZgSwX8MbPR0BLKN3gKSyXmAYNI0kygSphUJY02
	 GlWLf7o2cSqTNaxpHhCkKziaGCh2dYuajPW3KrBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Mallesh Koujalagi <mallesh.koujalagi@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0380/1005] drm/xe/pat: Return error from xe_pat_init_early() on unknown platform
Date: Wed, 25 Nov 2026 15:28:38 +0100
Message-ID: <20261125143830.639335924@linuxfoundation.org>
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

From: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>

[ Upstream commit 7539edbca32d63ce309f5e29cb9d595b0959466a ]

xe_pat_init_early() currently only logs an error when the platform's
graphics version doesn't match any known PAT table, but continues
probing with an uninitialized pat.ops. This can lead to a NULL
pointer dereference later when pat.ops is used.

Change xe_pat_init_early() to return an int and propagate -ENODATA
to xe_device_probe() so the driver fails to load cleanly instead of
continuing in a broken state.

Fixes: 152d7f2db978 ("drm/xe/pat: Handle unicast vs MCR PAT registers")
Signed-off-by: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Reviewed-by: Mallesh Koujalagi <mallesh.koujalagi@intel.com>
Link: https://patch.msgid.link/20261012122522.2307625-8-dnyaneshwar.bhadane@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit e952337c3dbccf600ddae3bb1d38e996172ac8f8)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c |  4 +++-
 drivers/gpu/drm/xe/xe_pat.c    | 11 ++++++++++-
 drivers/gpu/drm/xe/xe_pat.h    |  4 +++-
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index 6dc02ec55b902..e76edcf15159e 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -958,7 +958,9 @@ int xe_device_probe(struct xe_device *xe)
 
 	xe_uid_probe(xe);
 
-	xe_pat_init_early(xe);
+	err = xe_pat_init_early(xe);
+	if (err)
+		return err;
 
 	err = xe_sriov_init(xe);
 	if (err)
diff --git a/drivers/gpu/drm/xe/xe_pat.c b/drivers/gpu/drm/xe/xe_pat.c
index a5fe1beec652d..0ac64a6a3098a 100644
--- a/drivers/gpu/drm/xe/xe_pat.c
+++ b/drivers/gpu/drm/xe/xe_pat.c
@@ -590,7 +590,13 @@ static const struct xe_pat_ops xe3p_xpc_pat_ops = {
 	.entry_dump = xe3p_xpc_pat_entry_dump,
 };
 
-void xe_pat_init_early(struct xe_device *xe)
+/**
+ * xe_pat_init_early() - Init early pat table operation.
+ * @xe: the &xe_device
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_pat_init_early(struct xe_device *xe)
 {
 	xe->pat.idx[XE_CACHE_WB_COMPRESSION] = XE_PAT_INVALID_IDX;
 	xe->pat.idx[XE_CACHE_NONE_COMPRESSION] = XE_PAT_INVALID_IDX;
@@ -688,12 +694,15 @@ void xe_pat_init_early(struct xe_device *xe)
 		 */
 		drm_err(&xe->drm, "Missing PAT table for platform with graphics version %d.%02d!\n",
 			GRAPHICS_VER(xe), GRAPHICS_VERx100(xe) % 100);
+		return -ENODATA;
 	}
 
+	xe_assert(xe, xe->pat.ops);
 	xe_assert(xe, xe->pat.ops->dump);
 	xe_assert(xe, xe->pat.ops->program_graphics);
 	xe_assert(xe, MEDIA_VER(xe) < 13 || xe->pat.ops->program_media);
 	xe_assert(xe, GRAPHICS_VER(xe) < 20 || xe->pat.ops->entry_dump);
+	return 0;
 }
 
 void xe_pat_init(struct xe_gt *gt)
diff --git a/drivers/gpu/drm/xe/xe_pat.h b/drivers/gpu/drm/xe/xe_pat.h
index 7060f66e1d638..6398c3ab48055 100644
--- a/drivers/gpu/drm/xe/xe_pat.h
+++ b/drivers/gpu/drm/xe/xe_pat.h
@@ -42,8 +42,10 @@ struct xe_pat_table_entry {
 /**
  * xe_pat_init_early - SW initialization, setting up data based on device
  * @xe: xe device
+ *
+ * Return: 0 on success or a negative error code on failure.
  */
-void xe_pat_init_early(struct xe_device *xe);
+int xe_pat_init_early(struct xe_device *xe);
 
 /**
  * xe_pat_init - Program HW PAT table
-- 
2.53.0



