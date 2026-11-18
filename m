Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018081;
	b=i0W/epKvBVV+WLZroyygPMUR11fyP8hyT52m2ThwPGDYrRRKC1HO+JKDxWoEOir94Rnq
	 LAk+RA7PNk1EWr3v7kK5ZiaqL7QzeCFuCIrnBBvPkH0sPg3sZ3VjMRG/fcMOQAljWIr6N
	 MxbaVwAvjXwPw7Fnj4kCgHiyn7tMetfBlRIRvJvNk2WiMXpBKLYZ/qLv7wKzNhkMZrM4e
	 2J3g4XVbX1V+LOH8TyZXQRkkRWDoTptMwWxBA0D/OBh7RGdwXMm3LM0tAx+hEH7Fm2B+r
	 fX0PhEwkYsfmiTiCK50VWaiCjgR1AMlTlP5rzomkAvXBnXbl6vwN5Wii96Iz35AUsdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QRCLBgerfSWpVfjmEmTy0BxNHTXHeafoyvy3bu8SEYY=;
	b=OnHhXFStMeRZP/0QvFGSXay7Z/UFKNua+RL1cMjN32VVYHyKImZoYiwLKSXSDy9H7k8a
	 QTuglH4/ICTbvicpIZz9hXGNrhcb1CUZCiyjcTJp8/dfbe21zhWBrP2bElfKX7aa3zzRB
	 x6pKve1+/Rff8w7YUZdl/GBy4sst5G6ty+s181TPyn0RCwTAiRdlw7eruV8Ly8nhi1Y46
	 kPoWUkYPuvsmsk3PPLar/XnpoVTJxZIOdaLuZu+H9lCVYlKtei4MotzQlk2jpKLB/IPfc
	 0h4/KOCdjCav6ZCmsbVmaOTohmMT0cSYYmfSeT2YPR5+Eq9SX8uR8lLiN5E0ns2C6dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UChvUCVZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF0860A2606;
	Wed, 18 Nov 2026 16:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UChvUCVZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27A91F000C5;
	Wed, 18 Nov 2026 16:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018081;
	bh=QRCLBgerfSWpVfjmEmTy0BxNHTXHeafoyvy3bu8SEYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UChvUCVZ32vlFuTMcxx+wU9mGKzftf5SrUOgGQ1+pA9MDlNn/Pd7z1JSHERn/Nsdf
	 WxJuEM4OhdATsbIMYY7j1Is1a7Dyv+au4ep8LChzbKaQIDpw/ZzDrTwbWKsD0MUcpb
	 /gp6mRI6VDdofv1HUnTnOoG5QrK0XwrzmgJz38Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1089/2651] drm: Add drm_timeout_rel_to_jiffies()
Date: Wed, 18 Nov 2026 15:38:49 +0100
Message-ID: <20261118150327.204951518@linuxfoundation.org>
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

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 421cf7ccfc61cb990f38d671ddfe3a901519e21d ]

drm_timeout_abs_to_jiffies() covers the drivers whose wait UAPI takes an
absolute deadline, but there is no equivalent for the drivers that
express a wait as a duration. Drivers such as i915 and v3d convert the
value themselves.

Converting a nanosecond duration to jiffies needs some care.
nsecs_to_jiffies() returns unsigned long, so on 32-bit a large
userspace-supplied timeout overflows its range and is silently truncated.

i915 already handles both cases in a local helper, which v3d has a copy
of. Add the same conversion to the core, so that it is available to any
driver and both copies can be dropped.

Differently from drm_timeout_abs_to_jiffies(), the new function enforces
that a timeout in jiffies is a positive value and therefore, returns an
unsigned value.

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patch.msgid.link/20260915-drm-timeout-helpers-v3-2-f2ae987d861f@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Stable-dep-of: 88b7a9fb64af ("drm/vc4: Use drm_timeout_rel_to_jiffies()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_timeout.c | 45 +++++++++++++++++++++++++++++++++++
 include/drm/drm_timeout.h     |  1 +
 2 files changed, 46 insertions(+)

diff --git a/drivers/gpu/drm/drm_timeout.c b/drivers/gpu/drm/drm_timeout.c
index 9329bceb02366..1a823607c633a 100644
--- a/drivers/gpu/drm/drm_timeout.c
+++ b/drivers/gpu/drm/drm_timeout.c
@@ -9,6 +9,7 @@
 #include <linux/export.h>
 #include <linux/jiffies.h>
 #include <linux/ktime.h>
+#include <linux/math64.h>
 #include <linux/sched.h>
 
 #include <drm/drm_timeout.h>
@@ -48,3 +49,47 @@ signed long drm_timeout_abs_to_jiffies(s64 timeout_nsec)
 	return timeout_jiffies64 + 1;
 }
 EXPORT_SYMBOL(drm_timeout_abs_to_jiffies);
+
+/**
+ * drm_timeout_rel_to_jiffies - calculate jiffies timeout from relative value
+ * @timeout_nsec: relative timeout in ns, 0 for poll
+ *
+ * Calculate the timeout in jiffies from a relative timeout in ns, for drivers
+ * whose UAPI expresses a wait as a duration rather than as a deadline.
+ *
+ * The result is clamped to MAX_JIFFY_OFFSET. That keeps it positive once it is
+ * converted to the signed long taken by dma_fence_wait_timeout() and friends,
+ * which matters on 32-bit, and keeps it distinct from MAX_SCHEDULE_TIMEOUT so
+ * that a finite wait is never understood as an infinite one.
+ *
+ * It's strongly discouraged to use relative timeouts in uAPIs, as they do not
+ * survive a restarted ioctl. A signal-interrupted ioctl is re-entered with the
+ * same arguments, so the duration starts counting from zero again. New uAPIs
+ * should take an absolute deadline and use drm_timeout_abs_to_jiffies().
+ *
+ * Returns:
+ * 0 if @timeout_nsec is 0. Otherwise the equivalent number of jiffies and
+ * clamped to MAX_JIFFY_OFFSET.
+ */
+unsigned long drm_timeout_rel_to_jiffies(u64 timeout_nsec)
+{
+	u64 secs;
+	u32 rem;
+
+	/* Make 0 timeout means poll, as for the absolute variant. */
+	if (timeout_nsec == 0)
+		return 0;
+
+	/*
+	 * As nsecs_to_jiffies64() does not guard against overflow, split
+	 * the timeout into whole seconds and nanoseconds. This way
+	 * nsecs_to_jiffies64() is always handed a value below a second.
+	 */
+	secs = div_u64_rem(timeout_nsec, NSEC_PER_SEC, &rem);
+	if (secs >= MAX_JIFFY_OFFSET / HZ)
+		return MAX_JIFFY_OFFSET;
+
+	return min_t(u64, MAX_JIFFY_OFFSET,
+		     secs_to_jiffies(secs) + nsecs_to_jiffies64(rem) + 1);
+}
+EXPORT_SYMBOL(drm_timeout_rel_to_jiffies);
diff --git a/include/drm/drm_timeout.h b/include/drm/drm_timeout.h
index cd9621c520623..6ee222a3e97ca 100644
--- a/include/drm/drm_timeout.h
+++ b/include/drm/drm_timeout.h
@@ -12,5 +12,6 @@
 #include <linux/types.h>
 
 signed long drm_timeout_abs_to_jiffies(s64 timeout_nsec);
+unsigned long drm_timeout_rel_to_jiffies(u64 timeout_nsec);
 
 #endif
-- 
2.53.0



