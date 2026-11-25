Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622690;
	b=KwgxbTm0O9os71I5majluzFk60pOF1dfmM4dpnCA1LjdccxCqoiMFGwhBiYWQHDOXs8T
	 jXsJyXQfOEv9WZ+rRbJBy9kJSMwD1K7ILC2JatFl6m2l6+/p+VhZtV3Jh4Oub7FJf4ydj
	 vxwMJHF9lx1Tl/T14zkU6tI+CKdhHI3Q+4zitPo6kfvCfCQvlzVcmuy6IEyVSPxhPE/zH
	 DMumOB+QUkQv0CDdw/O2JlTUj2TNpjzplsdh2iFHjKa50mLBRoAtcKuKtwn3e+v7w9cJk
	 55j8kQLd+q0RSfJ0ztpjm0BztyUX2II5SZ0FlSwpCJzHYbqJ2V29HSHlhsoVmubl8xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622690;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NWi+fYk1fsgYpoNCiy8p7T54i8hh0FooBF9w8wN0jKY=;
	b=F4/GDcY6Qxo/mCyxxv+Wu2wS7vYoIJwzarNq/Wg+Xc/5d9Vf4Gm3IrQetULDIumRJcP+
	 xLPLqMCeT3jnPOkYnCPX3VyDyCYGSDxi0Xd+bzjExXrYQRATwkcYBN5iXsTHXGeIsn9Ne
	 7rvoVoRYuyT6ormnFAJdTzHhAiXgnijC0XeuI4f2zFGfARzeYW/dHePRxW6EYxw0MMLPI
	 yESvUDMtnFc2136SRlGQJPfQmRJXwHfzPgZ6+Ffvd6aJRMBZxaLd7KX3Ptqo8BEy8rAWr
	 Cco3ZTRlvupq6OuHI1S4QjXH/0hwI64u1CvuGxHqxQi6DYw4xiyOXoMVvGzdehTGB/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w7V6XfGm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFA3606A321;
	Wed, 25 Nov 2026 16:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w7V6XfGm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF351F000CF;
	Wed, 25 Nov 2026 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622690;
	bh=NWi+fYk1fsgYpoNCiy8p7T54i8hh0FooBF9w8wN0jKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w7V6XfGmTL96CXou7p13y/rHcNmXvqy/xuuy5Ks0bV54MytX4EeRsILauiLDMITLX
	 0gDvmjqZ8HTnnavW8ZT/jJIH7f6htuSPKpVHdqwCjRkq9CtbJqj1CEiNwEcPnk2riM
	 5+Zk9jLb7azuAQ4MxXS840nIyhvZQoI3SXU2i7sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 617/990] RDMA/mlx5: Validate priority in STEERING_ANCHOR_CREATE handler
Date: Wed, 25 Nov 2026 15:33:04 +0100
Message-ID: <20261125143836.550718797@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Serhat Kumral <serhatkumral1@gmail.com>

[ Upstream commit bb75e5580b15cd23ededf15683a5ad67d7b61aab ]

In MLX5_IB_METHOD_STEERING_ANCHOR_CREATE, the user-supplied u16 priority
is passed directly to _get_flow_table() without an upper bound check.
This can lead to out-of-bounds array accesses on dev->flow_db priority
tables.

Check that priority does not exceed MLX5_IB_FLOW_LAST_PRIO before calling
_get_flow_table(), matching the existing validation in raw_fs_rule_add()
and mlx5_ib_create_flow().

Fixes: 0c6ab0ca9a66 ("RDMA/mlx5: Expose steering anchor to userspace")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Link: https://patch.msgid.link/20261018144907.20123-1-serhatkumral1@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
[ sashal: Kept the branch's kzalloc(sizeof(*obj), GFP_KERNEL) as context instead of upstream's kzalloc_obj(*obj), with the same 3-line priority bounds check added before it. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/fs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index b67994df98f2c..af3fd7781e685 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -2999,6 +2999,9 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_STEERING_ANCHOR_CREATE)(
 	if (err)
 		return err;
 
+	if (priority > MLX5_IB_FLOW_LAST_PRIO)
+		return -EINVAL;
+
 	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
 	if (!obj)
 		return -ENOMEM;
-- 
2.53.0



