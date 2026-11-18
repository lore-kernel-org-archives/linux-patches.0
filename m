Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032492;
	b=ioNLhhn+L9ISbWTdsPZEU0hf6Od+apUFmfH+JzJisVzmNvwpX64U4g+5izkAxj5aePkM
	 xe9Va7h+dXcsfv7kh1eXO9SJ6/jrgb8nz1HcbhpCiD4b/BKkrHKe7Kc+Q3tfwCVQaW7X3
	 Wc+Zs8b8U7tEZ7j9s6iRvwqp+Ddqaoa+q4TBgW8x8nXHw8CUg6uYL1Nu4ueDEtOO6RoXT
	 ezoTXBH9w+VWfWDQELWPtQJE4cBH/MwYC03+EN5fH3rXTS5omBRM0QIcglK2ZUBszPkVm
	 bpNxR1AJ4WN69bTrOESdjkhvV1qOghTc1qwlnSUB3r5yHPdH6HllSiP4uQYMTnTVfxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032492;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f0oGwE9Mxhvq2iitEAYcGPockTme0+FK47Y3x07iFZk=;
	b=kcwkXejF7kflK53vLFvrWYjIxcYrqjQ4Y8Q/StW3nFw+qEFYlIN53tPVX5/u8pgtMxkL
	 i7snE0Ynd41nSXfMuF6rVCiEJFdUvu+fmjlHMRxKRF6LHgttzNeDm5BInRbGwAVOBpIkL
	 Q/0smZTE+4GirWkwuLY9scHgUAWMxYogsRpZ5sBtjY+ioV4XBc2MuHfjpvArUFfvSr68c
	 CyhrTLUNc4H8KCfd50OFZWHOEivWfMEgjMVfD+4XBnOJCh9GTYdX/JwiNxPi6/WoflwAO
	 gtfaG811WLFbWaaLHmilv59LrqSP7TT6l0hyAvjxp/nnjhq0wqp+LEYEY+YlNdLutbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=crHEtaj0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5B5606A85A;
	Wed, 18 Nov 2026 20:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=crHEtaj0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87D61F000C4;
	Wed, 18 Nov 2026 20:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032492;
	bh=f0oGwE9Mxhvq2iitEAYcGPockTme0+FK47Y3x07iFZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=crHEtaj0PZ4gstCuDdheflIzBGKg+1eF7QrMU+0b8se2PP1eKliuclQewVvbTFnzW
	 JKzxx6Zwgnlv+AAoSun0/YAW2YK2aTm07j67MUoEVVgTPAhiSt+SGt1EIWrmhVOoTT
	 MmOHEyXWzwHRoJYTD7W/qrfIYY9Rdmk8G3I0pb70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Hao <haohlliang@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1432/1756] timers: Clear pending_map on CPU hotplug
Date: Wed, 18 Nov 2026 15:59:19 +0100
Message-ID: <20261118150106.198072569@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Liang Hao <haohlliang@gmail.com>

[ Upstream commit e7cad586d73276cbd4466de81b2092287d7475c0 ]

CPU hotplug migration leaves pending_map bits set on the outgoing CPU
while its wheel vectors are empty. After re-online, a later next_expiry
recalc can treat those empty buckets as pending and temporarily pull
next_expiry forward until collect drains the bits.

Clear pending_map under the base lock after migration in timers_dead_cpu().

Fixes: 500462a9de65 ("timers: Switch to a non-cascading wheel")
Signed-off-by: Liang Hao <haohlliang@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260930063621.37740-1-haohlliang@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 666cb78c24829..053735a4ac997 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -45,6 +45,7 @@
 #include <linux/compat.h>
 #include <linux/random.h>
 #include <linux/sysctl.h>
+#include <linux/bitmap.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -2722,6 +2723,7 @@ int timers_dead_cpu(unsigned int cpu)
 		for (i = 0; i < WHEEL_SIZE; i++)
 			migrate_timer_list(new_base, old_base->vectors + i);
 
+		bitmap_zero(old_base->pending_map, WHEEL_SIZE);
 		raw_spin_unlock(&old_base->lock);
 		raw_spin_unlock_irq(&new_base->lock);
 		put_cpu_ptr(&timer_bases);
-- 
2.53.0



