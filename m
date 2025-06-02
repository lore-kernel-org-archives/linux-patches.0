Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0898C228CA5;
	Mon,  2 Jun 2025 15:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877189; cv=none; b=gRo+2NsshtFlzADxsx07Iw3b1URwrzX8UAaUClnysmmB67ecosMca711j7+u8frPJYiImIbfs2L0lM1zFhpTKiqHQM8ClJe3SGVlnhEeEAqt9Z6kct2AzsFbsR7TGBdYq9IFqZTLCR+hWghpLugwlgjsIePjpuWyM3/+U0uf1l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877189; c=relaxed/simple;
	bh=OIKwZu5IpdlHe/xcAp9x/+B+LTDn5sTk3S7Z37R8IDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9SvoU7gFCC985j0Ky+amlGNZl1/JmxAb4Yzd6LX8puPDwa3RTL8dOKTeQn2kC+ZjJWnOhs0dnMA2WpdMp4mCtnBfPAOR1tTeLqaBRfpMBMLP0inOwAkuQQXCpDYR+Bk0sgNCZKAmt5Is6gf8/RtjUQUnUadQPc/OHv5WXCu1Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fo5RUlrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fo5RUlrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4D9C4CEEB;
	Mon,  2 Jun 2025 15:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877188;
	bh=OIKwZu5IpdlHe/xcAp9x/+B+LTDn5sTk3S7Z37R8IDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fo5RUlrW6LgqoYbb8+tcTaI41ULNWctkHC/UR/xfCl68DMMu6kZkApGmYX+nDiM63
	 3Lu+kzhR0iqollXntkui+Okk1Qvu4PPub0vkWXPLqtwGzZQ7rAgo28dvt/VWrsH73x
	 sRZgwrYm6FPx8NxNLfvvyzQd//yvtAjBiRZVsvAM=
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
Subject: [PATCH 6.1 199/325] rcu: fix header guard for rcu_all_qs()
Date: Mon,  2 Jun 2025 15:47:55 +0200
Message-ID: <20250602134327.884148366@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5efb51486e8af..54483d5e6f918 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -105,7 +105,7 @@ extern int rcu_scheduler_active;
 void rcu_end_inkernel_boot(void);
 bool rcu_inkernel_boot_has_ended(void);
 bool rcu_is_watching(void);
-#ifndef CONFIG_PREEMPTION
+#ifndef CONFIG_PREEMPT_RCU
 void rcu_all_qs(void);
 #endif
 
-- 
2.39.5



