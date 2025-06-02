Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19648221297;
	Mon,  2 Jun 2025 14:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873873; cv=none; b=G8deheaeNHx8sU3lrh5afkpNfl1FZoUQ0qXTXzUme6TKSDqgE+4FwVRLlDTnVFHR13aRJckKM7Fev9oiYKRPvD51XPYXPaZ8nmb7E+3Em8h0+qVYnbcL4Ob81x4hj4cSmWaHDEzRId2EEHfvpKr2og2LWK7yswNhfMkBDpQpdBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873873; c=relaxed/simple;
	bh=J0O3v4jEwDshND+cfziSE1tsemArhldLP96xNYhTHsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NURJQH/QF3nMoKtugy2knuzXAU+/pKhJeJ5YSKvXHzHlfUkcMVv3tAQdRsmB0zwi/hVaCTyYVUWpMQGr8MPoNnY4pE9/xNTf3rXonc5Sm7gEeVQL7BNdX2Bti/pEttzq8fg2Fsed0vcpPGYhtGgVwbv9KrY6u09BJK6F3E31FRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYVL6OwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYVL6OwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E6BC4CEEB;
	Mon,  2 Jun 2025 14:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873873;
	bh=J0O3v4jEwDshND+cfziSE1tsemArhldLP96xNYhTHsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYVL6OwFsYMJZ3Ebc/BynQB7c8cvSMzE9hBp3lhGw/sxpmDNU0eHuaKG54unjzwVs
	 pq7ZtumBvFLLyUixzDfFSG/3zlMPgP/mA6nPt/CYHmHQ20sztgooWfs4bMCjJG29Cn
	 PihFA9Xsx8IKBvAcQqE0Z37RakBaA6W/W8qlHfpo=
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
Subject: [PATCH 6.6 282/444] rcu: fix header guard for rcu_all_qs()
Date: Mon,  2 Jun 2025 15:45:46 +0200
Message-ID: <20250602134352.401704583@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 126f6b418f6af..559f758bf2eaa 100644
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



