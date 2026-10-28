Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215312;
	b=HRBbcVzs/s70cF4lpTK3Re/scPlMPeWRKPw0SVKssndtMym9yvG5+ALWA8qY+KKb3RC1
	 VhDqhGQ49C8Snu07o/f7z81F8Yx4ppwe7928zLXkYg4IZ6BvQ1V/uztrHMjt9K74jSXZ8
	 jVa1MbnJMCkvwho9tqGiXJVRIT091YkbqgyIKu60f613gOkF4T5DUoqtXu2gIEXx2MWTX
	 Qa1GpiRIiTBJ2fh3iGWOtyK/fIEAl9cyoHR6W7r008iihPS7souNoimb17brlOgjHSF04
	 JVxSfYONhTt4UntWL08GtuOaGoCeScRQ7OjVItNnNbSyKJuXvW1WbTTutjjneFVpFYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0bSD7jHwD5EK+279SHQSLcq2+o4NMyiYIxfgWeX5dUA=;
	b=maWtIWddEB94PUFQKE2e4jA0Qe5gcuaHw+6PeVsvgjfGIlx451THkcK2GiCLVbIBwWgK
	 6qkh3kvfaqDyt+bRIM01QyJl+HrIFrEyIDaaF8YjlgHasp9FOj2SxZRS5zmKHyuEsMb4F
	 sodu8v8VD/lC2/klaWaYpsRwanTT5aPKzoiyQQN8aMZMEw5AqCLPFtF3QhLv7+xGT6BZY
	 Ziad4S7joMWhWYgXkAOtpBfVCbnV5yOyFsKpeMrGXSBTlMoHOrR7RYW3qllNALb7QMpu1
	 Q4F4TSCHcYJvlxjBCQ1gJlQE2w8pKI1mhaZaxRH/nWvuMXv/2tZMavXRTAKWz3ABGFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XZMbuB/C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B587606A31A;
	Wed, 28 Oct 2026 19:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XZMbuB/C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFD81F01825;
	Wed, 28 Oct 2026 19:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215312;
	bh=0bSD7jHwD5EK+279SHQSLcq2+o4NMyiYIxfgWeX5dUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZMbuB/CFrrVk40xDktdGffUbfLTlua36KPQ8Gk7mli4YDKd/UvOKR9O3i7WMJjgH
	 hbtIPncyAKFBaAYKrUQrI+Kh+Lco6virTAsxNwV2VIQIjuwm7ND99X/jPAPLxRoe6C
	 kk4l05ueP9OPJbMaR2mZyeGygsb1SUbZ5/mJ/Wmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1166/1887] drm/vc4: Shut down BO cache timer before teardown
Date: Wed, 28 Oct 2026 17:54:22 +0100
Message-ID: <20261028170525.937156802@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 6273dd3ffb54ec581855b82ae77331b66028249c ]

The BO cache timer callback schedules time_work, and time_work can rearm
the timer through vc4_bo_cache_free_old().

vc4_bo_cache_destroy() deletes the timer and then cancels the work, which
does not break that cycle: the work being cancelled can rearm the timer,
and the timer then queues work again after teardown.

Use timer_shutdown_sync() instead, so the timer cannot be rearmed and the
cycle ends with cancel_work_sync().

Fixes: c826a6e10644 ("drm/vc4: Add a BO cache.")
Cc: stable@vger.kernel.org
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260720084426.1632508-1-lilinmao@kylinos.cn
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_bo.c b/drivers/gpu/drm/vc4/vc4_bo.c
index d687afb3c4426..898aabca45a71 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -1050,7 +1050,7 @@ static void vc4_bo_cache_destroy(struct drm_device *dev, void *unused)
 	struct vc4_dev *vc4 = to_vc4_dev(dev);
 	int i;
 
-	del_timer(&vc4->bo_cache.time_timer);
+	timer_shutdown_sync(&vc4->bo_cache.time_timer);
 	cancel_work_sync(&vc4->bo_cache.time_work);
 
 	vc4_bo_cache_purge(dev);
-- 
2.53.0



