Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017541;
	b=nZbhsc/6s01ZXmWvf3necJFSeZQKGMKMfroJmr1W7qBPIx+MB8yGb2URjdkXrSJl+KCj
	 BdbWzXCiOLDg8gWfkc5Ci+IHw21uGYa/GOYlN7J+QkEHZCeMP53fd4MK5f+7QPGj+eONo
	 dQIz9Ij/kLg9mJEANJgDRoWJil3TwR2FGCGGKTBLdKLDARJz/NrRa9eWcYKWeMACl8sDV
	 sCzWEoV7dtizobxIIqF8D23Y/xgjyQbYtG8YNmam1FRhWKzr4jTSa9ZIX7o+zi/GHswPU
	 evrVR/j0mtWziREhKQq0ujYfGIXAToRHUoXTd597p+8YcQbsCyPzFr5H4hzAL0n1PQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dmPW+cPKWpTjgVWJ0xqMB8hOrh9e8aHHnpcNaIuAhhE=;
	b=Pt1Wa6ge3D1rUi9er1FTi6B7O33TBmLmwdBEVlVnxNdWsJK63kBy51vRSnt+EPR7oroe
	 Rc0G7SL9PJuAKxxuDXYhThXOiGErNBeEauba9YGn4YF/pqEbZ9LP/bC5BUFu44reLbJRd
	 UN1/GheLKHEYvjn3LbTX6V+ZPJ6NZT+60zUW4vJJ+Cfw3xD7Qn1DFamxZb7KE+q/kpYVt
	 xztZDx5R5m8uXj5AdygDlflxWLc7N5BYypjgU6+e36bFnwnY3HB3jJZEiXHAd4MZHGXTA
	 T47jHSaGoZtFtvM98M6VEI6xmTvVb5bGN7XeY11m+goxbX4wYSvKAw3r2d8kUyoSUPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E08wlwqO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22330606A33D;
	Wed, 18 Nov 2026 15:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E08wlwqO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E45D1F000C5;
	Wed, 18 Nov 2026 15:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017541;
	bh=dmPW+cPKWpTjgVWJ0xqMB8hOrh9e8aHHnpcNaIuAhhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E08wlwqOitexTg5Ygm2JUsS+dmTkESTlMGCg8SKGNgIiQy2SmqL56I6V0IPpFX3b/
	 3DshCD1X3ifo4YO6BkJ0HKh+eVXY95VovEGo/mmdWgczyFhGfSFyTocZrPB2ruKaLI
	 BTbJR6qbbs/WPrv6CzR7v/Xf+iLOHqMDxeD3A7yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0922/2651] um: time-travel: fix sched_yield() behaviour
Date: Wed, 18 Nov 2026 15:36:02 +0100
Message-ID: <20261118150321.084748191@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 0e70b1de88ef1973cf752ae27930683eb2acd338 ]

Just incrementing tt_extra_sched_jiffies can make this
drift enough to hit the softlockup detector, e.g. with
ping using sched_yield() in a loop to measure short
intervals. Make the simulation actually pass time, this
requires going to the external scheduler but actually
makes this sort of thing behave much better and avoids
the soft lockup.

Fixes: 887c5c12e80c ("um: work around sched_yield not yielding in time-travel mode")
Link: https://patch.msgid.link/20260924134223.1672004-2-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/skas/syscall.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/um/kernel/skas/syscall.c b/arch/um/kernel/skas/syscall.c
index bc117733e8eff..914b90af42ed2 100644
--- a/arch/um/kernel/skas/syscall.c
+++ b/arch/um/kernel/skas/syscall.c
@@ -35,12 +35,13 @@ void handle_syscall(struct uml_pt_regs *r)
 	/*
 	 * If no time passes, then sched_yield may not actually yield, causing
 	 * broken spinlock implementations in userspace (ASAN) to hang for long
-	 * periods of time.
+	 * periods of time. Advance the time-travel clock a bit so sched_yield()
+	 * in a loop (like ping does for small intervals) also works correctly.
 	 */
 	if ((time_travel_mode == TT_MODE_INFCPU ||
 	     time_travel_mode == TT_MODE_EXTERNAL) &&
 	    syscall == __NR_sched_yield)
-		tt_extra_sched_jiffies += 1;
+		time_travel_ndelay(1000);
 
 	if (syscall >= 0 && syscall < __NR_syscalls) {
 		unsigned long ret;
-- 
2.53.0



