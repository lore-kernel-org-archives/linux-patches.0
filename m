Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC7F1D5ABA;
	Wed, 25 Feb 2026 01:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982826; cv=none; b=D9CW5k535DuwYYGLaV9LauGTnWpeEs7m9wqtH2aXwu/OIh0LgU1xqgHj95hg9LgH3umkW6Dtq+hpZEoXWQyvyrsdGjb3h/s4SF4bJIQPSv4uotcHYlA1637xIaPBkRVDn2fGLlMqiv8pWd+GqNb53Zyk640vMWc132FcwEbSBco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982826; c=relaxed/simple;
	bh=ddcXQspGlSAP4EQvxXkFocBGbEGiHAAYgzlerI33Vpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtzRGU9xDAm7aHnWU3YlMAbjL7VINl74CsezfybaCR0ZoFfOrAPEmUOnfycISHVcIHHw1gVBVPqFEOeKMZ/vaBpg7v8DyyGNHMqyqq4mV79v+ivC33wpCg5apGOVwVGiV/qxRuipJ0EtvIcvpMLeJgdCE8o3YMexNkYGzCe/8KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W71KWxoq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W71KWxoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A7BC116D0;
	Wed, 25 Feb 2026 01:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982826;
	bh=ddcXQspGlSAP4EQvxXkFocBGbEGiHAAYgzlerI33Vpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W71KWxoqHrzhTZjvDff4aR3tcfk5cLEYs1kBmMCnTEy7N42d++CRFsP7jZAvarXZm
	 JP/xuOOvDcqc36g0X0kHh1CQ7A42eGfEw7nI4vTiNoB+1XvxQKEppXwW7gKkDPSNd0
	 VyA8FMI45oN81bt7Sqiid1BMyPo7qDC4jxgaFKcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 005/781] rcutorture: Correctly compute probability to invoke ->exp_current()
Date: Tue, 24 Feb 2026 17:11:54 -0800
Message-ID: <20260225012359.828483495@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 37d9b475077b5096d41ebdc416a9019bd4fcfdb9 ]

Lack of parentheses causes the ->exp_current() function, for example,
srcu_expedite_current(), to be called only once in four billion times
instead of the intended once in 256 times.  This commit therefore adds
the needed parentheses.

Reported-by: Chris Mason <clm@meta.com>
Reported-by: Joel Fernandes <joelagnelf@nvidia.com>
Fixes: 950063c6e897 ("rcutorture: Test srcu_expedite_current()")
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcutorture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 07e51974b06bc..83934402a287b 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1750,7 +1750,7 @@ rcu_torture_writer(void *arg)
 					ulo[i] = cur_ops->get_comp_state();
 				gp_snap = cur_ops->start_gp_poll();
 				rcu_torture_writer_state = RTWS_POLL_WAIT;
-				if (cur_ops->exp_current && !torture_random(&rand) % 0xff)
+				if (cur_ops->exp_current && !(torture_random(&rand) & 0xff))
 					cur_ops->exp_current();
 				while (!cur_ops->poll_gp_state(gp_snap)) {
 					gp_snap1 = cur_ops->get_gp_state();
@@ -1772,7 +1772,7 @@ rcu_torture_writer(void *arg)
 					cur_ops->get_comp_state_full(&rgo[i]);
 				cur_ops->start_gp_poll_full(&gp_snap_full);
 				rcu_torture_writer_state = RTWS_POLL_WAIT_FULL;
-				if (cur_ops->exp_current && !torture_random(&rand) % 0xff)
+				if (cur_ops->exp_current && !(torture_random(&rand) & 0xff))
 					cur_ops->exp_current();
 				while (!cur_ops->poll_gp_state_full(&gp_snap_full)) {
 					cur_ops->get_gp_state_full(&gp_snap1_full);
-- 
2.51.0



