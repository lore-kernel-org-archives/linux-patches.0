Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BAF222590;
	Mon,  2 Jun 2025 14:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875699; cv=none; b=StfLITfZEBJLHYBwZI1GxXXRPJpbhQ5DsJsYb0rlgEqNTxHLmEd5l1QZMc//srbL21WW+QLbUkynUEOozFpxBrxCNLTDiX2vikU2VLbLXpFgSQhu5BKYfvWnkvgLmt/fz8KvN0dxO16BEmS04i5wcjjHpKYrtVPpOiijbKPis5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875699; c=relaxed/simple;
	bh=n2hLuEf7SkSc+LA5LzaX4vsvrowqYPkHCG0A13+AGyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsvPVEzDP1p24Qq2IW54GCqVvmY4zBoNK7lmFjpOBLx8y37/KMO6Mq63Es7QUxc7g4a/FDSwCzUpb3LAFaHZ5KmJtrvtIhZxAtpbJ9dj2863FfAegUUidvywNh2CT+sJdbubzluTF3tNgUDiRNH8xXxeaVY0f178ELA4l0gAu94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqPp+DnA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqPp+DnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42110C4CEEB;
	Mon,  2 Jun 2025 14:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875699;
	bh=n2hLuEf7SkSc+LA5LzaX4vsvrowqYPkHCG0A13+AGyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqPp+DnAeUGan7RzEj8jMtfCXJBkYx4FVeR5qmprkMTmpYc1nMVUI1xtJwOVyUiHM
	 P2tGA+MWT2Oy09beRfZdt28GFG6LLnYgza2sm8wNUU4ibBNEcI+ljXcLzyYZmxN8sT
	 5JBLTvW4CE6exwN7beHd04vY+GJzxhpaGxRNR4mk=
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
Subject: [PATCH 5.10 216/270] rcu: fix header guard for rcu_all_qs()
Date: Mon,  2 Jun 2025 15:48:21 +0200
Message-ID: <20250602134316.017930367@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 59eb5cd567d7a..92f04fcb89473 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -64,7 +64,7 @@ extern int rcu_scheduler_active __read_mostly;
 void rcu_end_inkernel_boot(void);
 bool rcu_inkernel_boot_has_ended(void);
 bool rcu_is_watching(void);
-#ifndef CONFIG_PREEMPTION
+#ifndef CONFIG_PREEMPT_RCU
 void rcu_all_qs(void);
 #endif
 
-- 
2.39.5



