Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063225;
	b=nbGbbDQueUdh4LvZ9Ug3vSOBD4b2v78zBkldbNyd1o5TdWf8UIqo0V/qIwL6DOI81wSa
	 KMd5w9n5y1dK3tRI5UiWcYf1ydngM9lfy6Ft0HVNKL5JzCbfw4Adc2qRW9k7s+peteZda
	 kRESlwQAR0OoMQLBBMtFiEnYnvGiQ2JwtXEpSIrb7rW6N2ZYqCO1Qprz15WPx1kEN3cDP
	 l7pIzhnUYR0H0/CYhUrYMlVJ/y3088jNkcJkMIPnbq9bVM/qExs509j9JbcH9OcnyJ65A
	 PQVx4cb8TW+SDVisDcoRaafY9VnfaxsojLqcnY/y5icXJrS+A0Bz7ReS4DPvvwXmP/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TJIF/JzeUvNppYeOUCnJGoTe1KF+zqFUCe23h/UODvg=;
	b=1WnN53flRe3oQN8+osqskBH6DxxfwhdYxqlumHDt7J5lbye8JDsmdUazNQZqs6qxQ8Qd
	 ztFlA+yx+P1FDw6DYLP0tgQX7bMbSVxcvc3cJNB1JG+aAUfBxIWB3TG/dzfPBFnaFzGwr
	 6FuLCuAEVHI6TvVERnHfWlUpGt7gAf29uF1wY8m0Oe0bJY44Kc3PuwAheyxpiEWEbbFG1
	 Bd5EW/W/qtJfrFRl5HKQ2xCQ/nj1SQ0DjwquVKXzcP5AoS8vcnEZKcgqLANabTAkXfSze
	 1tRmEE5CBJ+o+7+2mRwR/l2UKIhBGAp1F+UspB0VaUx6d6W+4qp65AkJ1KZELSSzBwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=smU4MJIB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7F6606A326;
	Sat,  7 Nov 2026 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=smU4MJIB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C7B1F0089F;
	Sat,  7 Nov 2026 14:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063224;
	bh=TJIF/JzeUvNppYeOUCnJGoTe1KF+zqFUCe23h/UODvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=smU4MJIBjBrds2SQI/i/T/5CqLFVy2WXPXrvEtf+DuVz6f4BmWN2o+Lmfys9UiMTh
	 3hKU+RFScZebXh2dPouzffnXpwIbZuNRlxDTyk7Bn5hgxgkL2H/PjYdjQpS9vD6V2e
	 MLAYZSEfShSsrNn6jbGYuUeFbsROeM6P6FI7s6nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	ZW Tang <tangzw515@gmail.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 396/869] ocfs2: skip uninitialized lockres in ocfs2_mark_lockres_freeing()
Date: Sat,  7 Nov 2026 08:51:18 -0500
Message-ID: <20261107134906.839400688@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 6a3ed6b290513859bd27d9fcb67739347d6315fa ]

A hard readonly mount skips ocfs2_dlm_init(), so the per-osb lock
resources are never initialized and osb->cconn stays NULL.  Before commit
550842cc60987 ("ocfs2: fix freeing uninitialized resource on
ocfs2_dlm_shutdown") ocfs2_dismount_volume() only called
ocfs2_dlm_shutdown() when osb->cconn was set.  It now calls it
unconditionally, so unmounting a hard readonly mount drops the osb locks
and takes the never initialized l_lock in ocfs2_mark_lockres_freeing().
With lockdep enabled this triggers:

INFO: trying to register non-static key.  The code is fine but needs
lockdep annotation, or maybe you didn't initialize this object before use?
turning off the locking correctness validator.

ocfs2_drop_lock() and ocfs2_lock_res_free() already skip lock resources
without OCFS2_LOCK_INITIALIZED.  Add the same check to
ocfs2_mark_lockres_freeing(), which is reachable before them through
ocfs2_simple_drop_lockres(), so an uninitialized lockres is never touched.

Link: https://lore.kernel.org/20260903104744.2164235-1-joseph.qi@linux.alibaba.com
Fixes: 550842cc6098 ("ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: ZW Tang <tangzw515@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/dlmglue.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index b4055ced93d96..90d23dd7d4c8f 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3527,6 +3527,10 @@ void ocfs2_mark_lockres_freeing(struct ocfs2_super *osb,
 	struct ocfs2_mask_waiter mw;
 	unsigned long flags, flags2;
 
+	/* We didn't get anywhere near actually using this lockres. */
+	if (!(lockres->l_flags & OCFS2_LOCK_INITIALIZED))
+		return;
+
 	ocfs2_init_mask_waiter(&mw);
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
-- 
2.53.0



