Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058428;
	b=ARjM3vcSyClIw7WGRaJy/a3+Ovx1eQmtRpfk7Nmrpe9jffxbOVf9R79MKn615FAgyzZu
	 O/3Y5DmzPMX3FA+rC2smwqXlFBxibI5v6E54QzN10TO6xRdUb8/eAt91VbE2dw6jFMpBa
	 YsHt0YGqt7ysCWz0pWrCUSl4lqOqwmV7C5Kjm8erEQHXSLLXVisSU/zi6oqL+xEv4Xt+z
	 v0oiQImKaYDDaG6kqpdRaCPElSzBFeePd0KL7Z4hcZXYfX6BBTfgdviU0j+2Lpx8TswaX
	 nZQhUR4R8W1gjABULbmRsf8SxuRcxAoDidtvI7kU4ibaZo+juOOoh1MSP4teIQISJHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BcCJtmzkzURb8eafgiEK6lFXD1JRijoz6kgsNue93l8=;
	b=xLwI7K/vhsfwkUDFucj5zZBCz9hpJDKgpcMzdK+YMWo/nsUZVtNCYBJJoycIZ/2gwpat
	 /yWKDwcnirydumf09qDdvCqpe4u78pd9fe40CiQ4H1Wr1Yel2KEG/sqRe8qpmQCirRD09
	 7U+IvWtnpQo1q4CUUwXU03IFOim3JsTEZBA7FWaBinCrY5MSfiqR76I6sVmniaBtf1QAg
	 cuBxdzA6VN7Vd1QMlHG2qu65roKTBz8L/rQeOTsHdMd6OaFxj1tKZGQWKOpOX1Zjt+43l
	 z92fn9/6qs0E9KCEIaO5HW3Asz8ge9Yx2dbdabq2nMHwvboa4HmEmMM/q55shMoW0VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cbi30PIu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858B4606A325;
	Thu, 19 Nov 2026 03:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cbi30PIu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68A11F000C4;
	Thu, 19 Nov 2026 03:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058428;
	bh=BcCJtmzkzURb8eafgiEK6lFXD1JRijoz6kgsNue93l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cbi30PIu7mMhgDSmi2kJgQmUn0XXuQ7XEbmK4hjlkC/fGZKvWtrAxcmNFQKNHJFsj
	 P3pg+K+rMvkMqIciGPX6CKADbatOrTeotTGDYOBo8jPQh/2M4PrekPXrqGnXLpSjze
	 GT3g7rlJm5RwD8pgzjg1dAhczitb5yNOczGAXLaI=
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
Subject: [PATCH 5.10 0480/1848] ocfs2: skip uninitialized lockres in ocfs2_mark_lockres_freeing()
Date: Wed, 18 Nov 2026 15:41:58 +0100
Message-ID: <20261118145934.326641656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 48378b91b280e..a8ec22045ccaa 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3522,6 +3522,10 @@ void ocfs2_mark_lockres_freeing(struct ocfs2_super *osb,
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



