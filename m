Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053098;
	b=GRNaZLvbfv1tC5q/AiTypXFav/L3yceCEOgNMpUuc+bcWRvD8kbOX0mpnG80G46Vgwpi
	 HnK/09yCK1KrFH9FR1ch23cufYl5En2v1ZGonc1W3PySaRHfJEQwxjoYa5SgRDll9KBJ7
	 y2sHbpvQyZyN2HWkep70CefWUY/iSMsZbX9pm/81R838Haud8L9Kmp2AY4m8UGhogcgYm
	 FOWP3bIVZCb2+79dcOUCL/rQ2ApoE5bLVuWrlLEb2lrMUpI+EmDlMc+pUTl47IU5Uij05
	 e1Q3U6xZEmNUAHXxY+voGONxZRrkCPjQfnaGvM9A+Ccvj/2EduQIoxHl2cSis/NHK3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YAK7o9BxC3k7gzK8MKMceEPwdQwZEdUkdLEhTrp3UiM=;
	b=OBzV3GwV4uRHrndGYZPZHaX0XQujGGdo9UgAmBDi+hNIklN4yLZP1JYVtsnyX9USFwOp
	 MJcyy6cL8ZyvqeKvxiBDI0L61xHJfZ3mXuTYjoZfOd0AhpOT+DPGQndA7bwdfX+8/B3Uo
	 Uo2ZEk8lzWeaHjoca2bplvVVpXSVsKeRtVTKVhux0NdNL89iv5wO/xh2PfQmcpWg7hG8P
	 0c0LMRSF3b8W0SG979Dn1G/wfRbclDhnd6nzFbsh9EGRM553cnKVEr0mAUI95LFZ9NYZO
	 q+o5xZLVkLcU2668TreZ+lCopN63vuVJBcE4kxS9ZN6SEdgGNd221lVvBSh7CiyrNIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pe7xGYXB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C89606A31C;
	Thu, 19 Nov 2026 01:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pe7xGYXB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6611F000C4;
	Thu, 19 Nov 2026 01:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053098;
	bh=YAK7o9BxC3k7gzK8MKMceEPwdQwZEdUkdLEhTrp3UiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pe7xGYXBW+gj4nei9DPf2HVtMTNpURUgesjPOWUB+bGJyOEsxmT7sDpO4Y4wlVx3v
	 81pzE1c9X2TGTLxb28UERZz/9LZMGDYGJeTLAIpG/tTSAUHdmq+ZzCqAxqNdc3Kx3W
	 0FjJ3MuWwuxUc8wejDtFHr2o10DCJI51O9u5513Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Christian Loehle <christian.loehle@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0800/2214] debugobjects: Use LD_WAIT_CONFIG instead of LD_WAIT_SLEEP
Date: Wed, 18 Nov 2026 15:41:16 +0100
Message-ID: <20261118150043.522037748@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 37de2dbc318ee10577c1c2704de5a803e75e55a2 upstream.

fill_pool_map is used to suppress nesting violations caused by acquiring
a spinlock_t (from within the memory allocator) while holding a
raw_spinlock_t. The used annotation is wrong.

LD_WAIT_SLEEP is for always sleeping lock types such as mutex_t.
LD_WAIT_CONFIG is for lock type which are sleeping while spinning on
PREEMPT_RT such as spinlock_t.

Use LD_WAIT_CONFIG as override.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://patch.msgid.link/20251127153652.291697-3-bigeasy@linutronix.de
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/debugobjects.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 29b495adac242..513de56d0ea98 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -616,10 +616,10 @@ __debug_object_init(void *addr, const struct debug_obj_descr *descr, int onstack
 	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || preemptible()) {
 		/*
 		 * Annotate away the spinlock_t inside raw_spinlock_t warning
-		 * by temporarily raising the wait-type to LD_WAIT_SLEEP,
+		 * by temporarily raising the wait-type to LD_WAIT_CONFIG,
 		 * allowing the allocator's spinlock_t and local_lock_t locks.
 		 */
-		static DEFINE_WAIT_OVERRIDE_MAP(fill_pool_map, LD_WAIT_SLEEP);
+		static DEFINE_WAIT_OVERRIDE_MAP(fill_pool_map, LD_WAIT_CONFIG);
 		lock_map_acquire_try(&fill_pool_map);
 		fill_pool();
 		lock_map_release(&fill_pool_map);
-- 
2.53.0



