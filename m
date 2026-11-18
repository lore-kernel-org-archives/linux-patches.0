Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039183;
	b=WBw8L2qu+OjQrgeqyFx7x+tO495BsAcZinuMoTJm9xe0JSxcbb5eXY6vbdNEbkgjEml/
	 JDv/dz4Gzq2M8rC++LayGkZ/D2m2NWAK2jR3heAUJ8C0szcD3X+wlTU4hrFv9O1vQBPrr
	 rU4ANzcqheKxudhoTS5Uzrr4Lop4rUzSvDp0YnyKyMRM98jhZum09EpWP5tBtzTYklEiZ
	 o+PC1TvyDAhETSPy38AEcvyOAToVlHJnyuYD8XuogkztyqaQufU+8/mHpArYB8EriQ5TZ
	 b0q9R3qbiEC19HqS97lr+eL1H8cOHUqcqpHGpLkWWDpxUrKgsiUfGWtQojSVoRItn7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EORb1JvXJVo8TraaAFsNlxTgXCx17do+19WsfwVnbXs=;
	b=EyC1CYkAfji8leSswivLJKcDV7qz7/fBVu87TzPkbBhJzVPVAki4DfUC9Solfed/gqxp
	 mAIAwBoMxNX+Rsn33Qy8IkvnEcozjPhxormYqtyU1j34Og55fBdVD6tn2o8JWJnhZP08l
	 edWTtcPlsaeEgCDm3csQ+nglOOZcGEn+EQQB75s4Az/4fu6I2mE+j4v/Gb3KdPO3M7nGY
	 +Nyl375iuGd0pqJaly4+EBbqvpd7GfoLiVvGq9Ov+Y0dpLbRfc9AeNTxt6DsJ7bOC+QgI
	 02FNWltRrj3/M7rlXgewQ72P376Kz5Cfey37yFEPKV6oOs2wug/CTRWE7OgNe6EO0Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a43sUelT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DE3606A31C;
	Wed, 18 Nov 2026 21:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a43sUelT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD49C1F000C4;
	Wed, 18 Nov 2026 21:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039183;
	bh=EORb1JvXJVo8TraaAFsNlxTgXCx17do+19WsfwVnbXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a43sUelTed1b7p4j5nCPaS9cE88Aas7yd2ne6/91pb3ikJMx78jR4gPJU9FPoZC0I
	 btyf8Pb9KDpyhvXyxKCvmk+oX0ctGY9q/xX32otxO7C/gN4UOlxsb0EdpPbI83RulA
	 El8o4AZ7P68TuEEY2pdp36SJj4OouRkOeSJP59NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1967/3318] srcu: Add NUM_ACTIVE_SRCU_POLL_OLDSTATE
Date: Wed, 18 Nov 2026 15:43:09 +0100
Message-ID: <20261118150421.098517947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 395e73bd8d35fa9b8505e44f63a2a10abde09cce ]

This commit adds NUM_ACTIVE_SRCU_POLL_OLDSTATE, which gives the maximum
number of distinct return values from get_state_synchronize_rcu()
that can, at a given point in time, correspond to not-completed SRCU
grace periods.

Reported-by: Kent Overstreet <kent.overstreet@linux.dev>
Closes: https://lore.kernel.org/all/irycqy4sinjdgm2hkyix2bffunpcmuwgeufsx6nlljvqme3wiu@ify3zdnrmzph/
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: d06917d0ba22 ("srcu: Add list_splice_init_srcu()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/srcu.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 236610e4a8fa5..f664cba7a80c2 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -61,6 +61,10 @@ unsigned long get_state_synchronize_srcu(struct srcu_struct *ssp);
 unsigned long start_poll_synchronize_srcu(struct srcu_struct *ssp);
 bool poll_state_synchronize_srcu(struct srcu_struct *ssp, unsigned long cookie);
 
+// Maximum number of unsigned long values corresponding to
+// not-yet-completed SRCU grace periods.
+#define NUM_ACTIVE_SRCU_POLL_OLDSTATE 2
+
 #ifdef CONFIG_NEED_SRCU_NMI_SAFE
 int __srcu_read_lock_nmisafe(struct srcu_struct *ssp) __acquires(ssp);
 void __srcu_read_unlock_nmisafe(struct srcu_struct *ssp, int idx) __releases(ssp);
-- 
2.53.0



