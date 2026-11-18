Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056357;
	b=5gxqnSLYaZsLGbZhLYiknrX1NYHg10wL5NFcwPh6eRl0FLyEGFWBgRq5tILQ7M+LqdH0
	 LKuUKFflwq5p6u0oK2P4iaHalCrNvbCXmDjjtGqw34IgjNUXcPoKgDSl1Fb5P0CVl3hM/
	 g03vZjJfzt3wYODrRHAhKbHp3SHKupjfgXR4Z8BhwWcKDy2bHCRjGp8CizkZ1GjbQNBxU
	 gc/2qIUB1J8DbigCsv5uOBCEOKY4UklnOG0uIaHTqhZmXoPyXTFaN2lulo8sTymI883es
	 UNi0p+cqa5hxJmjFKVRJII3R0zrRk5thnKCGheZ/1sDOKlQDv7xblpBZPwGF07/OOuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xThbVx5NNjBz/kmDOQycIdjAx85zleAh3fGUHNlSAmg=;
	b=yXXqk05HrQtEjTuLle6zzZ+94TW6tLh8zPeYIpQ4zDAwSjezB49Q6TLMjy7qyUIJbMaU
	 48dUdSIUQ3Jbyzc41w9laWmWpLDK+BI+x3hkQlJBkLjxfwWB+maKMnaGTEWvGrigbmKbZ
	 wLE8RccsLBaRUX1OJ9dqAYIV4s+hMn7pNqA4ot6crh8+zuSzkcOz/NJM4mCu7t3kEnLz1
	 ovSpM9kz5w5NvwpyphbyCBX2DyZboD2hj/azUtUmR5go8ydINa9CqXG/eAUfxecxhqJG4
	 UJl57H/u36AdSyvXJzY9bPFkahjwnwr1xbb4VR0eZPiq9fQnvWpK+nYTVqk+SGmT27Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J8I2oo4M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8C4606A325;
	Thu, 19 Nov 2026 02:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J8I2oo4M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00CC11F000C5;
	Thu, 19 Nov 2026 02:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056357;
	bh=xThbVx5NNjBz/kmDOQycIdjAx85zleAh3fGUHNlSAmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8I2oo4MJ22JD2aSYTiGUdtQuGCyoodQTb/q+qYThMsbtTDpNzJlubmkE9I1G5Q2K
	 WaBev5o64NycS+sEmtZ6xdpo3/45bAnrJOWM0RhUIBTrU/nioiB8MaGsB6xRDr31uQ
	 gEALsEI3cW/VXHiIfWtIztFSJHShJx99q82BjIZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1960/2214] ALSA: Add simple refcount helper functions
Date: Wed, 18 Nov 2026 16:00:36 +0100
Message-ID: <20261118150129.365416145@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit dcca9b6064c33c84fbeb9f09814178a206321249 ]

There are many open-code to manage the same pattern for refcount +
wakeup sync at closing.  Let's provide the common helper functions to
replace the open-code.

- The recount is kept in struct snd_refcount, where it's initialized
by snd_refcount_init().
- The user can simply reference or unreference via snd_refcount_get()
and snd_refcount_put() functions
- The user can wait for the all usages gone by snd_refcount_sync()

Note that here we use atomic_t instead of refcount_t since the current
users allow reusing the refcount after sync again.  The design of
refcount_t prevents exactly this behavior, so it doesn't fit.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260610154538.51076-2-tiwai@suse.de
Stable-dep-of: 91d0048a97e0 ("ALSA: pcm: Add refcount for races between drain and unlink")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/core.h | 21 +++++++++++++++++++++
 sound/core/misc.c    | 24 ++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/include/sound/core.h b/include/sound/core.h
index 5f6a6dde20303..b76345c8e2e0d 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -74,6 +74,27 @@ struct snd_device {
 
 #define snd_device(n) list_entry(n, struct snd_device, list)
 
+/*
+ * A simple reference counter with a wait queue;
+ * typically used for usage counts, and you can synchronize at finishing
+ * via snd_refcount_sync(), which is woken up when the refcount reaches to
+ * zero again.
+ */
+struct snd_refcount {
+	atomic_t count;
+	wait_queue_head_t waiter;
+};
+
+void snd_refcount_init(struct snd_refcount *ref);
+
+static inline void snd_refcount_get(struct snd_refcount *ref)
+{
+	atomic_inc(&ref->count);
+}
+
+void snd_refcount_put(struct snd_refcount *ref);
+void snd_refcount_sync(struct snd_refcount *ref);
+
 /* main structure for soundcard */
 
 struct snd_card {
diff --git a/sound/core/misc.c b/sound/core/misc.c
index edd29fcde4200..9012a23047f86 100644
--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -247,3 +247,27 @@ void snd_fasync_free(struct snd_fasync *fasync)
 	kfree(fasync);
 }
 EXPORT_SYMBOL_GPL(snd_fasync_free);
+
+/*
+ * generic refcount helper
+ */
+
+void snd_refcount_init(struct snd_refcount *ref)
+{
+	atomic_set(&ref->count, 0);
+	init_waitqueue_head(&ref->waiter);
+}
+EXPORT_SYMBOL_GPL(snd_refcount_init);
+
+void snd_refcount_put(struct snd_refcount *ref)
+{
+	if (atomic_dec_and_test(&ref->count))
+		wake_up(&ref->waiter);
+}
+EXPORT_SYMBOL_GPL(snd_refcount_put);
+
+void snd_refcount_sync(struct snd_refcount *ref)
+{
+	wait_event(ref->waiter, !atomic_read(&ref->count));
+}
+EXPORT_SYMBOL_GPL(snd_refcount_sync);
-- 
2.53.0



