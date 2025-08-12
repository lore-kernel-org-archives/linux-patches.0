Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A272C21D4;
	Tue, 12 Aug 2025 18:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024451; cv=none; b=CuXg4AuezUaWm9P1ze/MlG+xPeC8ZLoSHuOJqyixp194/dqizGDcqCWSMKjcQb5UeUwRHL60zfmufZoneGDFiduyi/EMdeF8ik25kEPGJuHp5yivuu8pFOjkVt2sM6rWuWYFEO47gSXE7O9rzgsZ3gOdc2NItByXIM0G5FH/t+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024451; c=relaxed/simple;
	bh=j0VpzSgIVbNZA7cdxPWsMRsZZbl5RJDcMWiRtTgjSq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogTn2YVUOxmxZdXbycqUnx+U/jO6qllnOFVpg/aj1l6WfY/w3s27N0WwetHgRIF5YdsmREkaMBIOIT9h8zs52h5WyCk9p/trR72Dty6CQVrtFbI9OOPRWSRQMkzGyaq40oSKmWiujIMwuQNnfrNq/SeDgqi6qVMH8/e7kL5yphA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxcpSJ+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxcpSJ+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30BCC4CEF1;
	Tue, 12 Aug 2025 18:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024451;
	bh=j0VpzSgIVbNZA7cdxPWsMRsZZbl5RJDcMWiRtTgjSq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxcpSJ+8MEBpV1U1jD2sjNHV6QkKkj0G3Q6V6VxDJfEo3eiQV7uvsnsHZyWK+pW4X
	 eLemqK0TbsGC8xw6KbaleJ3wokNT81k5oQ5FPtEdXq+O++eORJP0n75moYwHU7Jba0
	 jLCNONjzGyF1r787aPYEv5tGTxpmZRXl9mptru7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 376/627] RDMA/uverbs: Add empty rdma_uattrs_has_raw_cap() declaration
Date: Tue, 12 Aug 2025 19:31:11 +0200
Message-ID: <20250812173433.603781458@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 98269398c02ab20eb9ed6d77416023a2627049d8 ]

The call to rdma_uattrs_has_raw_cap() is placed in mlx5 fs.c file,
which is compiled without relation to CONFIG_INFINIBAND_USER_ACCESS.

Despite the check is used only in flows with CONFIG_INFINIBAND_USER_ACCESS=y|m,
the compilers generate the following error for CONFIG_INFINIBAND_USER_ACCESS=n
builds.

>> ERROR: modpost: "rdma_uattrs_has_raw_cap" [drivers/infiniband/hw/mlx5/mlx5_ib.ko] undefined!

Fixes: f458ccd2aa2c ("RDMA/uverbs: Check CAP_NET_RAW in user namespace for flow create")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507080725.bh7xrhpg-lkp@intel.com/
Link: https://patch.msgid.link/72dee6b379bd709255a5d8e8010b576d50e47170.1751967071.git.leon@kernel.org
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/rdma/ib_verbs.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 087048b75d13..6353da1c0228 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4794,15 +4794,19 @@ struct ib_ucontext *ib_uverbs_get_ucontext_file(struct ib_uverbs_file *ufile);
 
 #if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
 int uverbs_destroy_def_handler(struct uverbs_attr_bundle *attrs);
+bool rdma_uattrs_has_raw_cap(const struct uverbs_attr_bundle *attrs);
 #else
 static inline int uverbs_destroy_def_handler(struct uverbs_attr_bundle *attrs)
 {
 	return 0;
 }
+static inline bool
+rdma_uattrs_has_raw_cap(const struct uverbs_attr_bundle *attrs)
+{
+	return false;
+}
 #endif
 
-bool rdma_uattrs_has_raw_cap(const struct uverbs_attr_bundle *attrs);
-
 struct net_device *rdma_alloc_netdev(struct ib_device *device, u32 port_num,
 				     enum rdma_netdev_t type, const char *name,
 				     unsigned char name_assign_type,
-- 
2.39.5



