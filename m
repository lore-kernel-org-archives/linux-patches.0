Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024721;
	b=4GgALJjboPUAO6RD79wWjbKeE6zqgzGdYAj7GTMwU6SVyfmsrMwPRy/zN2M8Hr9PkXoc
	 x5bFRlDCiPIcNZnEasURYbNT5+0nfBfMyXpSY3ViY8NwD0RvHPROa76c+D/cUX5BH/x9K
	 agE1DB0ysHbE5rjDcyxy/U2ktRxEgl4cjLaDv8Tu/EF7Y7fuknln4ywu8FLyrOGrxJC47
	 /fy8A3QbsxXF4BN4dBUU2Qh0YW9yJAf6+SNttywqb5QhfnI6IFMJ5R67/6tf7fwZfQhZM
	 N+C6Ok6HtRMjV2cqg1jPDr0+QnxiQrayBu5Ey/MNJmyOh7IezGC+iUQa4nMFLgV+hLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7QL9fUx+pdk7iMOlsAgmzlEBCHMlF+1afy1SMJhcX4Y=;
	b=gXogCsgDmuHIbTr6FLVaMa6RYjDJLJuaTkotahmVluE3xK6xzRFyv/xPJKGqbFYkYDek
	 VXDHDq9qjfCQWRp0CASvTlpjquSEJgbcHM7NdzVhzJyuh4Xn/7uGopE4FGWcz/z1FdlrA
	 meaFiLl4Ts6druCJZ00EwvMVK9uEVa/Qluq/i62yTqebo6f6HtiMEfKBYArFU6cu1MRpV
	 Q+2mbQ9YqkG7P4LWjHp0UsinYNlmjhbAQo8/Oqnt3nlSTSmauFoEUovFLIqJULqPvf0Rz
	 tcfT2UBIvgAX5DbTbw2T6KK7y/7vCcgZ1cbrVrdFm+pg99d7XQEootwZ60u7cOgVZWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vdl5Ht3X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A908606A32A;
	Wed, 18 Nov 2026 17:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vdl5Ht3X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02F11F000C5;
	Wed, 18 Nov 2026 17:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024721;
	bh=7QL9fUx+pdk7iMOlsAgmzlEBCHMlF+1afy1SMJhcX4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vdl5Ht3XM+BPy0Mau9dv6FXi1DoG0KsDiPsS95PVzXGq22wEWVYxjZyTckpQP4cqu
	 M3qT4jiJv3zg5O/3TxPox+W0mUHeGXd+YMW72/K1GiFFv3H589vD29eEVRRoNvdYqh
	 /gXtrfGSiBTcSek3x2jbmOTWi1/EFVRK+ug1kH0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0785/2151] um: time-travel: fix sched_yield() behaviour
Date: Wed, 18 Nov 2026 15:42:00 +0100
Message-ID: <20261118150150.700748685@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index ba7494f9bfe41..8914ca587ce98 100644
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



