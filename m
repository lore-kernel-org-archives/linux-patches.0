Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036014;
	b=2my5kDlL9qPh5rIsFn2hCnDNbqtv48gKk8yB+IT4LfrYnMLZyhM/GXHU7Og8lImX8lbu
	 dgv5eHb9+tU8vZTPj5OmwprU00ZC7e3MVFeU5/KsGqRhYVU/0v2wt/sWUD7BuuGcl/6XH
	 8jcDyc/CMx0qQz9cQKsdbPSn2eu1r9RlYIa56xxxz/G1nsqyNd8viEBjUuJcd/bMBU7WV
	 QVqCR1iYj1a++73IyKd73IHMtS339x2v2zfrNCRHxZ0kdxVi83U0ksXvDuwm9Cykz7mN+
	 Xs6HM4OXE7r/s34ixVg5cfJDgNJ78BXZSSuWq/J5eGuXM1iUkFX6UmZ4z5RCWCaRs9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=92cJgbiUQiV+mN9ikuBsx6i5XSFCxG2jAjDMcYeybnU=;
	b=Ha8LB/HB/UTzMM3DoRNioCQCYGYeIESp6g/W9uF2PeEDSVRtPshW5Pt84+x3I+lYhWcA
	 mxD2xKZ1T21I+S0wgdQsl19Wg4/dURGrWlcKr5sqBRjEV8Df9bh0+wq3mipwgMmukY1lS
	 eXfmNgtxxguZOM+0yudef1PUf6KyizGhF+9TZ7H3c4Kg/L/Lmhsdxr1lNcanJIYNI3sYk
	 Kcj/vZ99uXopEZXj4kiwKasecgUnw9qeqBji5UaJ+e69c0L1nke5SCqBI8FWQ8zAewi7g
	 f3G2HFZ7CYT9a2tJqESt8eK0DzkFWflqOk0cFD6IJV5o6GNCoPL0FCGq9oLMKxwd3cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IKXYY3WN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB13A606A31C;
	Wed, 18 Nov 2026 21:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IKXYY3WN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE781F000C4;
	Wed, 18 Nov 2026 21:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036014;
	bh=92cJgbiUQiV+mN9ikuBsx6i5XSFCxG2jAjDMcYeybnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IKXYY3WNl2NQXUuqMUnzYNybE+NoOW5/Dtq+H+EPYcKhPn1de2DPjezZWmTRioVo+
	 4k3/bZ7Iglfih7XGEjW8urVZpHrp5pQ/xArN9pcj0AO03K8ScWNK3K5CK38BYfDnTu
	 D3oWYf691HgRsHSTYh4jD2V4i3htF97uoUWnGJ6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0907/3318] drm/mali-dp: Fix runtime PM leak in malidp_crtc_atomic_enable()
Date: Wed, 18 Nov 2026 15:25:29 +0100
Message-ID: <20261118150346.714889355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 73ef663c75688168e31dbe9c585b939be410a945 ]

malidp_crtc_atomic_enable() resumes the device with
pm_runtime_get_sync() and returns early when the resume fails.  The
runtime PM usage count is incremented by pm_runtime_get_sync() even
when the resume fails, so returning without dropping the reference
leaks it and, once the error has been hit, prevents the device from
ever suspending again.

Drop the runtime PM reference with pm_runtime_put_noidle() on the
resume failure path before returning.

Fixes: 85f6421889ec ("drm: mali-dp: Enable power management for the device.")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260916102112.2018372-1-vulab@iscas.ac.cn
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/malidp_crtc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/arm/malidp_crtc.c b/drivers/gpu/drm/arm/malidp_crtc.c
index dc01c43f61930..0b3a296413767 100644
--- a/drivers/gpu/drm/arm/malidp_crtc.c
+++ b/drivers/gpu/drm/arm/malidp_crtc.c
@@ -56,6 +56,7 @@ static void malidp_crtc_atomic_enable(struct drm_crtc *crtc,
 
 	if (err < 0) {
 		DRM_DEBUG_DRIVER("Failed to enable runtime power management: %d\n", err);
+		pm_runtime_put_noidle(crtc->dev->dev);
 		return;
 	}
 
-- 
2.53.0



