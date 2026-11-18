Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017149;
	b=IkiV8kYHo3rxWj6G9uFaC4v3aaHX2SILTw7MdPo3qLx7QUxmtrY1iGYmmZB/1wGuPlTe
	 CGI+Dft9rfJ9S/uk2NXQtM8wYIFgS5wgnS5YcFpHPxL6YXgUwrrKmI7h2yWUZIKV6Zpyl
	 0Qzb4s4pqhLJ6t4nAOGewqYDmtZQ/c3zXGxaY7x6FSwfCwORSrmG35ovdQn2T8Wu3Z/IG
	 NsAFPSvFqaDjBoW5McbmdN5EosI7kBdGWCuOfWoYQpoLvE+krIS6TU6GFYxWX7+lblqKZ
	 sNjT/U7keWywl924OXPhtr+iGZLizk7oi0ZPa3spY/msxHy7z5PjKWgDslM+zDbPebQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=VRuu5UPi6sUF9j/5dlf02hQTNAG2n+VFVsChetT8F3U=;
	b=SXOyDUKENnZYZIGnjZPNd0I7xvIaUh2apj+tNQheyCjs20ujzhzfMOFHUeYFoBjvssCi
	 TUaiUa9EnQAKm0TIA+VXuSPM9fJNMBggGf2GiTnNJkgPhl0jdLEwfe5v+KQu1SxAYtDVO
	 SwRZOLfxVHDLNL7zwM7jkpL2XuY1QbPikBeTK3pYgW1ELpfz4tVWwVyEeGYdgFSKSOnD3
	 tZCmtjIiRLttSxiO69mZ6wXXaMv3uXmSMxffwjw36f8V63yhuW5eZvsYIAa+BYBsfJ0TD
	 jqEBwZp3aFcL0x3uewAihf7PC11aYNmJQAEXTLzbwJxGihzupmVVQxg8NUIwNv9UVdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1j6m42pv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED3E606A31C;
	Wed, 18 Nov 2026 15:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1j6m42pv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FE01F000C6;
	Wed, 18 Nov 2026 15:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017148;
	bh=VRuu5UPi6sUF9j/5dlf02hQTNAG2n+VFVsChetT8F3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1j6m42pv/pxr4wbFtOuuf0861mX6wQdnFNdM9SVJDQ5o9hq5TSQKFy4+LI8OSEarB
	 OrAUz3oWHHmDieZ4x/3hjsiBqluamHFKbwH26FD7uotgSt9OrcHR7LbdSVMPCnhn3s
	 YPPji2D1gwTuigjyI3ZI9eta4UwQkkefyYmalPs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Varun Gupta <varun.gupta@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Maxime Ripard <mripard@kernel.org>
Subject: [PATCH 7.3 0739/2651] drm/pagemap: Drop ratelimiting from dev_unhold_work debug trace
Date: Wed, 18 Nov 2026 15:32:59 +0100
Message-ID: <20261118150314.481629998@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Varun Gupta <varun.gupta@intel.com>

[ Upstream commit 0a6310dde13dca8252a48ec8e2e65752c0fced86 ]

Reference-drop trace in drm_pagemap_dev_unhold_work() was changed
from drm_dbg() to drm_dbg_ratelimited() to reduce serial console
bottlenecks.
However, when the ratelimit kicks in, the kernel's ratelimiting subsystem
logs a "callbacks suppressed" notification at the KERN_WARNING level.
Revert the trace macro back to drm_dbg()

Fixes: b66b036c959f ("drm/pagemap: Prevent CPU stalls during unbounded pagemap teardown")
Signed-off-by: Varun Gupta <varun.gupta@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Acked-by: Maxime Ripard <mripard@kernel.org> # For merging through drm-xe only. (IRC)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patch.msgid.link/20260921062648.1166903-2-varun.gupta@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_pagemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index c66c58f85c345..743988036a5f8 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -1102,7 +1102,7 @@ static void drm_pagemap_dev_unhold_work(struct work_struct *work)
 		struct drm_device *drm = dev_hold->drm;
 		struct module *module = drm->driver->fops->owner;
 
-		drm_dbg_ratelimited(drm, "Releasing reference on provider device and module.\n");
+		drm_dbg(drm, "Releasing reference on provider device and module.\n");
 		drm_dev_put(drm);
 		module_put(module);
 		kfree(dev_hold);
-- 
2.53.0



