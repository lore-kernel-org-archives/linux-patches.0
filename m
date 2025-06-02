Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EB922D4F9;
	Mon,  2 Jun 2025 14:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874850; cv=none; b=TEbPkHbajjyMKA3/3X18lMeVz3jCIu14bvv4Xb8yiyUod4WKmveUqTySd/rYzZCooTEqhfRSaa7/z927y0vK62PBQyD12NjPrqCjjApdUb7reDv5x8hbwrHoUPVqKrLBidhudnVcrNWzaId503EmqrSk+JPC+J7Xx3sc70taDh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874850; c=relaxed/simple;
	bh=PqE8WJBtyf3QIbQ9CsXzWUOMlATvsKN2/8cKfizdcIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDWHTDfGhwIPvqIHCUxB1A4JY4VFa+HYIAU16oGlueaQDP48TuVdY9BrhG8z1UxyuuHLAMb1iOP7mmmE+UOm+aDTvBlhu1KrgskWQT2CReZeT25QZDQ/fCKsutaqY3+WgwQr+IYyXbW2OLrESQIXYmJnCk87AUNe17cXrEZHNI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iyVzDT+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iyVzDT+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C62C4CEEB;
	Mon,  2 Jun 2025 14:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874850;
	bh=PqE8WJBtyf3QIbQ9CsXzWUOMlATvsKN2/8cKfizdcIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iyVzDT+z1LK0yFGhel6SSqeqZm+uFpclG1XqoMXRJPJPji0AH9+HpmLmpbe9mOKlU
	 fbMyX2Nj046PHeyXyfD1qyyD9afvg5hk6QSNLDuP5YJ9AdIR3EMPcAODtOgP4l2gHq
	 QFe6RfUmQ6OPzQ6jJ+aq94hhinLIefC7ZEU4Zbd4=
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
Subject: [PATCH 5.4 156/204] rcu: fix header guard for rcu_all_qs()
Date: Mon,  2 Jun 2025 15:48:09 +0200
Message-ID: <20250602134301.789648133@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 18b1ed9864b02..5d39875c6594e 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -53,7 +53,7 @@ void rcu_scheduler_starting(void);
 extern int rcu_scheduler_active __read_mostly;
 void rcu_end_inkernel_boot(void);
 bool rcu_is_watching(void);
-#ifndef CONFIG_PREEMPTION
+#ifndef CONFIG_PREEMPT_RCU
 void rcu_all_qs(void);
 #endif
 
-- 
2.39.5



