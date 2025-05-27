Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5960570831;
	Tue, 27 May 2025 17:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365687; cv=none; b=RYzMzv5jwqSHuE8ZsY2itXn5qq8h0pPw/edBaWHgDFYRIgK+GDtwmYNqm5tOXW4AOOQ4/vJ+VTJGKGawXgw657UzowwNfb/cSheLcHSKBEJkx4z4M8Baomj7mUS/MWUhfrQ+ZRCbxkQjyRLc3HgZR+znwXWEJiViXpglIBEL8x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365687; c=relaxed/simple;
	bh=wtMH3o4ZlT2Pdn8MV6QH7D3ybMgsYU3t6BD4u1yy4Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iB7f5qtVwa969K1kzGnM4TcTdLxmv+hSL/g24MBoO77k102jjRAlF7+HCbQ4cPmTz6V4xKzVd2r88eIensqLckpise1UeOgvXN2SqVGr/GJHQ9Qz6c5xv5Rtmfk+2uL6eCJ4FB/nxHuS0yM0MsiACHhKYc7eoKmOGW+RXxG4n9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7E7L1kk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7E7L1kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A364C4CEE9;
	Tue, 27 May 2025 17:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365687;
	bh=wtMH3o4ZlT2Pdn8MV6QH7D3ybMgsYU3t6BD4u1yy4Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7E7L1kkYx+KTXmgNFdPRnxQP5XaGM0V+YNO3kCcd3xihkxOgu28GN/baowK2u9xd
	 YJyzvOX8/jPMZ5AhMEeRu3AQesVM3/38xrcRAtIlHzA9JpqBeJsgljqAyF49bumEJl
	 FUZYIBkOdslFW8tV3Jg3ZepkoGsaCIzt28OLxQRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 457/626] rcu: fix header guard for rcu_all_qs()
Date: Tue, 27 May 2025 18:25:50 +0200
Message-ID: <20250527162503.562852177@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankur Arora <ankur.a.arora@oracle.com>

[ Upstream commit ad6b5b73ff565e88aca7a7d1286788d80c97ba71 ]

rcu_all_qs() is defined for !CONFIG_PREEMPT_RCU but the declaration
is conditioned on CONFIG_PREEMPTION.

With CONFIG_PREEMPT_LAZY, CONFIG_PREEMPTION=y does not imply
CONFIG_PREEMPT_RCU=y.

Decouple the two.

Cc: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcutree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 90a684f94776e..ae8b5cb475a36 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -104,7 +104,7 @@ extern int rcu_scheduler_active;
 void rcu_end_inkernel_boot(void);
 bool rcu_inkernel_boot_has_ended(void);
 bool rcu_is_watching(void);
-#ifndef CONFIG_PREEMPTION
+#ifndef CONFIG_PREEMPT_RCU
 void rcu_all_qs(void);
 #endif
 
-- 
2.39.5



