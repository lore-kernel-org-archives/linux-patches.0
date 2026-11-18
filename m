Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045364;
	b=OzixdINfuXezgrhayFppnCrMa9zNba4/tr7UfU//dWRU/eGSS5nUYK1qgNHU//RoMd5T
	 4VoNPxSPwAiCk1ecQtA8R4/CuxqC8323Xzh413oP/ydjE8v1meZYXOUqMw/rofRTy+fLv
	 F6nbhKluhP4fZVTh1LfVvC/8P7Mdar7dQtB6Dm2n1FqoofJU39qdexzxcLQ9VkrHAZi27
	 o3BOlqHzw1IrkZLy+JWGOECu4QGszK9vScRTUO/vfiUelauNQw8sRgnQeirVD+1CX8yYR
	 IdJS+itb22xhlWOiYQeOWR82984tY7dYz7Ra6Ibgb+8RjR0Uj5KzsLlzBJKycSAzKwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HKVQFJBSwHyFwtZAawjZz0EIFE3faj4g35HOEzqmvwk=;
	b=2uUHP5A9eeZlfGxfCQM2q/yt35tg4cBqLpZmGOO15ySAANAV1xckjIPAVG9O3YFxCatV
	 V9R3uSYItDXUnMlMs832S8YaGLnbydV+HCY2W3r1lHZDXl2XxUkHV2AKwEP5IYfE31QfF
	 LFuhuYwisnQX2vcG4MnsexX5PXcAUGzZqoXQt7WtczFiYp++MNXrDqOVUX8MxU3F/743Z
	 /25wIFyzeODzsbVoOphVqICurvvj07SVPMLh8oaL5hRClWupCEdqxHdnIlxURRLrDWgLX
	 vGJwYKlyeIgIp7ohUueC8wcNmKTsgYUU2chjQGuNFOH3W02xzQWRjGfdjEGTvb/szUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NTKNZ/fD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7D760A2610;
	Wed, 18 Nov 2026 23:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NTKNZ/fD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C1D1F000C4;
	Wed, 18 Nov 2026 23:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045364;
	bh=HKVQFJBSwHyFwtZAawjZz0EIFE3faj4g35HOEzqmvwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NTKNZ/fDLICoRCc5qDnF7Lak06RsrVJF5mFkL6ynKAKD+MxUABnFBse2uYu3+LDfU
	 0fSLfpffsiWjwAMY7w1zpHeIHSHfJ8EZHiOYP5TpcCRu6xU236EwVrgzAXalu9QCUX
	 I0/vdPpwyI9THJJDl3tl8c5PjEG2rLqUZN8vx+d4=
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
Subject: [PATCH 6.1 0890/2857] ocfs2: skip uninitialized lockres in ocfs2_mark_lockres_freeing()
Date: Wed, 18 Nov 2026 15:32:04 +0100
Message-ID: <20261118150233.600081344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8e2c43824fb82..a91fdc7a638f8 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3529,6 +3529,10 @@ void ocfs2_mark_lockres_freeing(struct ocfs2_super *osb,
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



