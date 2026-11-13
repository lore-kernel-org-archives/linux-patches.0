Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590523;
	b=AL0kpUIdrZRMjWI2fvuLkDyK3pB1gdWxwJyOr/U4/57zPjgcTxLpc1bBv4BxDJOIL/HS
	 UR8lo2GsLhBJLC5zUub2c9RhdoGvqke7t9BuBh9s3exlWrq0BAdRwuE5MtoKw8Ogq86Qd
	 UWz/eQIovBEce2wim1Mqxnx/yIDziPSdoPpCzks/U/0cUv2UEUiKc5iwMBqUqj1xxUPWd
	 gOCX75Nz0xE+NKXr4UBgncCpzQ4EPsPfOAAudpicP07Qvz495i1Lv1sWmPo4bw51QE8Pn
	 fQFPYLEOQXSjgto9VoGbfnUGZtoVCXdjh4Tvbi6fTJuBAKw+xA+9lvMWOZ2pkfr8jow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/CYGwy+wGhFogt/z1GCTC60035UhRhXUVx4PD7bxGE0=;
	b=THY1kZ8NXOoOvkO0fq7RHYY59ggVMrXQS3aYLU5RmeYClA73GHJa0WiNYnG8FtALIYaZ
	 ied8fscqxYeDREsJ6DIGclZkT7kYs3U3ZaoBpN5Sh6F5X90PSArPpo7poYtPlMKUFBlas
	 xi/NXe4nFsvSwYBRlD82VGngDkszqavtk7Iw4HSkFzjdTE3rB8CwO7VIUSCk3moYgpa4G
	 jurPgv166OpdvulOsTw7FzBufHSxwxEpQDN6nHt5vk27m7+l5ddaM5pWT6jmyVZanTnH6
	 gGTRO+lQo9slc20T5W2cCyqwNzauCQ8cNnRh587nriAiSoV34gydc+AnTGaFMlKInZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kR5Hwn2X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBA3606A33A;
	Fri, 13 Nov 2026 17:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kR5Hwn2X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794B11F000C4;
	Fri, 13 Nov 2026 17:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590523;
	bh=/CYGwy+wGhFogt/z1GCTC60035UhRhXUVx4PD7bxGE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kR5Hwn2XoUmdqvIXA7fODsH4YUMAJWYGpHwcYm6CwXscq5fHTRQWpN00WthXudjYQ
	 PQWErZOAdMudDp3tjj75QSAtzc40Vq6AwkUXEU+RyavpkU5uYroUEh4wLTuRzSYsD0
	 NHxSTm0cI7Adx11qJ3UddO/8b0FuemOmxH1W2oiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	shaos <shawnq1@163.com>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 468/686] timekeeping: Require permission to set auxiliary clocks
Date: Fri, 13 Nov 2026 10:50:01 -0500
Message-ID: <20261113153836.753466158@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

commit 524d95c8a2000cba6cb80a173d76cb746c561244 upstream.

The generic clock_settime() entry point delegates permission checks to
each clock-specific callback. aux_clock_set() does not perform one. Once
an administrator enables an auxiliary clock, any local process can
therefore change the global clock offset.

A test process running as UID and GID 65534 with no effective, permitted,
inheritable, or ambient capabilities set CLOCK_AUX0 successfully, and a
separate process observed the new value. The same process was denied by
clock_adjtime(). An AppArmor profile denying sys_time also blocked
CLOCK_REALTIME changes but did not see the auxiliary clock operation.

Call security_settime64() before mutating the auxiliary timekeeper. This
matches CLOCK_REALTIME's permission model, enforces initial-user-namespace
CAP_SYS_TIME, and gives LSMs the settime hook while preserving authorized
clock changes.

Fixes: 60ecc26ec5af ("timekeeping: Provide time setter for auxiliary clocks")
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: shaos <shawnq1@163.com>
Acked-by: John Stultz <jstultz@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261019080324.4147815-1-4ncienth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timekeeping.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 32f59de2ba4ce..bf25112b01568 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -14,6 +14,7 @@
 #include <linux/sched.h>
 #include <linux/sched/loadavg.h>
 #include <linux/sched/clock.h>
+#include <linux/security.h>
 #include <linux/syscore_ops.h>
 #include <linux/clocksource.h>
 #include <linux/jiffies.h>
@@ -2937,11 +2938,15 @@ static int aux_clock_set(const clockid_t id, const struct timespec64 *tnew)
 	struct tk_data *aux_tkd = aux_get_tk_data(id);
 	struct timekeeper *aux_tks;
 	ktime_t tnow, nsecs;
+	int ret;
 
 	if (!timespec64_valid_settod(tnew))
 		return -EINVAL;
 	if (!aux_tkd)
 		return -ENODEV;
+	ret = security_settime64(tnew, NULL);
+	if (ret)
+		return ret;
 
 	aux_tks = &aux_tkd->shadow_timekeeper;
 
-- 
2.53.0



