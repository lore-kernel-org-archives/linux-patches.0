Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591044;
	b=W3w7tnCwd7o6iTdQT9nmWv4yQ8wP2MJw9p3WAwqZRiZtRPAmnsfqTAfq2FNyCN5Xi53R
	 ejTGe/6CZtPY6TrWbbNfzKOchfWyYL45W/3Qepk+AIinREXk4hpLyfD+rg+/hPNubE89E
	 Ca2v1sLxL635UnBzWkphX9Ew4pQ3NI97dy27aHYwpDZKB9TJMeTRDUbvLZ8Hiz7xht1z7
	 /agu8h7FRr4D52w/TmEBNvOqkQFFptF/jWHpQotRf1ypCOPs1lxq++jeng+XWKj5HNMFe
	 WPOR/u32lvUQBjfrw3+GZWQQ0gci/HvE0eVGE6qPDvueO4w1pwyskTBSbrbbecIk9rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6mGlHLjaXRDBM8isq6fpKMS01NEE0INBLgYIUeOehSY=;
	b=jZ3HhbneRXuHaqBDU9yNpiPxDg+4JeXfvJXDMh1zNn7URO66CYk6kpQGIJ63C5JfXNOv
	 YCmt9gtd4LxOaecEMbU6kdTfzBd7AQlm/VooJc2L3xM3fczxUmqa6QHKDeTSFxYgm8uBV
	 OtPcFEb7giHov+1vB0M3TTT58BzOuuzCt8eIReA0b4S4GWJCS1FRWBt7QosnhZ7adZ4C+
	 3rVS/AgUSMcTCVQHMeuu/QBNKGrWWWw0XlKS2DoDH4lpdxPfJpWmASm+csMo1+lBbsdOD
	 K55MJIQyuDsqupKeikODDAMmwqwB/UjcAHTKhGBmjI2pW7OamitVBOnw2TorzYc4akg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iIrfMOI8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CBA606B471;
	Fri, 13 Nov 2026 17:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iIrfMOI8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C471F000C4;
	Fri, 13 Nov 2026 17:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591044;
	bh=6mGlHLjaXRDBM8isq6fpKMS01NEE0INBLgYIUeOehSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iIrfMOI8vD430XhGYnPescvRM2QgBkCZSJw88FZPSaaXh/akySj2rDOLN9lJY+y+Z
	 oE2juEhF2P3qtUxqxJk4klPfa1uL/YVVNyPzHp7H02AdmfSmng7XlSEP7oLHRgZ+m6
	 5JatoZdJaZ9mHxBgvQZ/i1iNdsME8Errt9uHNXH8=
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
Subject: [PATCH 6.12 209/670] drm/loongson: Fix framebuffer selection in async cursor updates
Date: Fri, 13 Nov 2026 10:46:13 -0500
Message-ID: <20261113153819.017646951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d227a2c1dcf16..df6cc5d11d797 100644
--- a/drivers/gpu/drm/loongson/lsdc_plane.c
+++ b/drivers/gpu/drm/loongson/lsdc_plane.c
@@ -227,7 +227,7 @@ static void lsdc_cursor_plane_atomic_async_update(struct drm_plane *plane,
 
 	new_state = drm_atomic_get_new_plane_state(state, plane);
 
-	new_fb = plane->state->fb;
+	new_fb = new_state->fb;
 
 	plane->state->crtc_x = new_state->crtc_x;
 	plane->state->crtc_y = new_state->crtc_y;
-- 
2.53.0



