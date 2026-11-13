Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590228;
	b=E5GNwN5e+hj9KXcxOI5aZxNa/UCz7Ek4hkxseCy7XH8a5Ro9I3Qys2rb0Nt1XIbs391L
	 rezFIeZuhqwKHOc9jzfkiVTjZ8PHGX1V5z3kr/S8mSvvSdr1EsfDEqpNisN8dSihZlzce
	 mJ19Ecw0peY4nFZYfPoLZC9BiY9OnciSTBXk+mLXDkKkL0pUQzhUgpyB25DWKH3OmtDiQ
	 LVcP8DqulqilosiWGAcaSuafi7V+R1LHEVndiZpz6Hf449GSxykIuVxb0GAgdL5HNzaGI
	 mfG1vQh1tBL0MtQeT6qcDWjrDIFwgCN33QDlRHaCoXE5pE2xtXJ3hETs9AuShRjC/jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5L5/z6zQJvDZWGCi/QBIVlqhiEhmk17Zliab3lxwXrA=;
	b=5jV2KlUxdWcBsW+zoLdBlOS4+p3Ja6wWQqgGjo1Mh69w6w7xiy+0HAejakxP4GcFU8c0
	 mdjh8lgMhW3hw16xBvRSerSCFhh80ctYC7KQYE78tgxarDkjPwOtZnDU+OH2suxkakbGf
	 TpzPoiGi4OA/ZeP5ru+lzXW4hidQ8Mtxn5P2YcKxcX0MIeJIgF2O4kr4aGCi1SjA4SD+J
	 MIqRFdvXbJX4Gg+NWV+MC3QlsVdOotdsto7MC/DBxxaIprsP/0NQCgLvxoWdKZkZcWzEH
	 DTgAC9LFw+8nO6hmzzIQvW5GCEeWjAe8FFOeOKSdqhsHN7qZvbffwQwpw/0yvus90Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lF+URRix;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1D4606A8BA;
	Fri, 13 Nov 2026 17:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lF+URRix
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AA71F000C4;
	Fri, 13 Nov 2026 17:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590228;
	bh=5L5/z6zQJvDZWGCi/QBIVlqhiEhmk17Zliab3lxwXrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lF+URRixpzmt71HxI8haJ38PJNsMaaIg5mHhHMJZ29N+JvaT7fXp6BlufBIIxM1Hf
	 oShVA8TYUZmP4Xsei5Kgi7YtWxfuzzepbsk9gJNC8hFA/JBm2JGegGa9SvgS6ymJ+O
	 vGBPOEcKeeokHE7YVAdYUloKDmMYluF20oawf6BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Evanshenf <archwse@gmail.com>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Qianhai Wu <wuqianhai@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 226/686] drm/loongson: Fix framebuffer selection in async cursor updates
Date: Fri, 13 Nov 2026 10:45:59 -0500
Message-ID: <20261113153828.680363736@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Evanshenf <archwse@gmail.com>

[ Upstream commit fa66daafbb6d5c984de2502809ff533ab66f6573 ]

An asynchronous cursor update swaps the new framebuffer into the live
plane state. However, the driver reads both old_fb and new_fb from the
live state before this swap. When an enabled cursor changes buffers, the
address-update condition is therefore false and the hardware continues
scanning the previous buffer.

Read new_fb from the new plane state before swapping the framebuffer
references. This updates the hardware address when the framebuffer
changes while retaining the existing behavior for cursor movement.

Verified on a Loongson 3A5000 with LS7A2000 using 32x32 and 64x64 legacy
cursor updates. Callback counters and read-only register observations
confirmed the asynchronous path, the stale address before the change,
and the new address afterward. Same-framebuffer movement and cursor
disable/re-enable also passed, with the primary framebuffer and mode
unchanged.

AI assistance was used to investigate the existing report, prepare the
fix and test tools, run the build and hardware comparison, and draft
this message.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202311152357.4KFS0M8f-lkp@intel.com/
Fixes: f39db26c5428 ("drm: Add kms driver for loongson display controller")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Evanshenf <archwse@gmail.com>
Reviewed-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Reviewed-by: Qianhai Wu <wuqianhai@loongson.cn>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Link: https://patch.msgid.link/20261003090006.4e29fdce9913-1-archwse@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/loongson/lsdc_plane.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/loongson/lsdc_plane.c b/drivers/gpu/drm/loongson/lsdc_plane.c
index aa9a97f9c4dc2..df941f13a9699 100644
--- a/drivers/gpu/drm/loongson/lsdc_plane.c
+++ b/drivers/gpu/drm/loongson/lsdc_plane.c
@@ -228,7 +228,7 @@ static void lsdc_cursor_plane_atomic_async_update(struct drm_plane *plane,
 
 	new_state = drm_atomic_get_new_plane_state(state, plane);
 
-	new_fb = plane->state->fb;
+	new_fb = new_state->fb;
 
 	plane->state->crtc_x = new_state->crtc_x;
 	plane->state->crtc_y = new_state->crtc_y;
-- 
2.53.0



