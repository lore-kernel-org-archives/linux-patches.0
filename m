Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016659;
	b=C5TU5LbVWC+tGR3QsSPlc4fcIvwrkR61NM0SZLxh5VLsVurqxhHBMQToNQEsjz4vVU/B
	 +QGMbY8O8RzFzRYz6sle1c93AOZ8Fv4EGKS2EOYhouVolsZWf0/nkD5+AIHkM3u1k0rlr
	 H7GHD1SZW3FDsKy1d1+WtM6CaGiYoCDwJN3i+5Y38YgxpjeQgNJaGaBaZCmvK6VYIbplY
	 8hRj5uhB3e2366hsXxXA5yIfclLebZToGwMgMd5lxKRqkJYbKv52TV7eCRN0sfoCWT+v+
	 q/GV/vAAEes1ztGJC7TTQK/8g0gOTVw5TK/gHynMMVhhQP5dw8C5zK33QAc4vS5Qw7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XqKIr1PPp2mYv48EeSm33RjyrQ9kv+52bxt5IhqyOKc=;
	b=U6T3i4i3ZZyQO7IA1VWMAkcdqqjtWn/oOu4550v/7luaC0sTeyYz6IPcSwSpAVMHOt9u
	 6bxQ5d0Z8SLXN6EHp8Ww7JeYL/ZYmXjylNMS3lANcmz314VEGV0qLRpHU5QsCzRvhNFs1
	 FlP+esd/c8QUGvzPYt3dGr/Y0VlocSAmn4nF/hnb+ta17SkVxm9PXZ8UEqA7Kxge8FU37
	 M2z2CbXCwN8Olv14Yzn6rCULNgiJvS7pLyArT5FmL+L4RPeJRD6zKbBR2QCyc9nEi3CaY
	 A19jqfIf6L3+wQIPRnt8D6xEz9G/w9mqFdH8GfjGR0PswHYtmS8z3Oiq+orBoJGR9og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thgHQ9Eq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01E1606A31C;
	Wed, 18 Nov 2026 15:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thgHQ9Eq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334D11F000C4;
	Wed, 18 Nov 2026 15:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016659;
	bh=XqKIr1PPp2mYv48EeSm33RjyrQ9kv+52bxt5IhqyOKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=thgHQ9EqrV6G1AcvgGhOwVcm/BxA5RsBfIEVjqVFVcfzCWM4Z2hJgWQDUD+HEwv+k
	 1xkDK5vehLakpbTkhJJ8sVXysV4y3xPEQJcdhgksR7YTxX9wQDsJHSPRJIl3VuXwy0
	 TW5npyujcZYvRpf0LbKX19O5Vn0RvcK1mGhsZnJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Richard Cheng <icheng@nvidia.com>,
	Li Ming <ming.li@zohomail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0566/2651] cxl/core: Fix dport use-after-free via the einj_inject debugfs file
Date: Wed, 18 Nov 2026 15:30:06 +0100
Message-ID: <20261118150308.116805512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 0de71a1ab211694be7e88d56fc35c9bf72078ad1 ]

The per-dport einj_inject debugfs file retains a pointer to the
'struct cxl_dport', but its lifetime is not tied to the dport. Unbinding
the dport host frees the dport and leaves einj_inject behind, so writing
the file dereferences freed memory.

The stale directory also prevents recreation on rebind.

Remove the per-dport debugfs directory when the dport host is released.

Found by code inspection, then reproduced on a QEMU CXL topology with
KASAN (the einj_cxl_is_initialized() guard had to be forced open, as
QEMU emits no EINJ table). Unpatched, writing the leftover file after
unbind gives a KASAN slab-use-after-free report in cxl_einj_inject(),
and rebind hits "already exists in 'cxl'". Patched, the directory goes
away with the dport and rebind recreates a working einj_inject.

Fixes: 8039804cfa73 ("cxl/core: Add CXL EINJ debugfs files")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260914121843.718493-1-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 20df3de45bb95..2ebf24655cda0 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -823,6 +823,11 @@ static int cxl_einj_inject(void *data, u64 type)
 DEFINE_DEBUGFS_ATTRIBUTE(cxl_einj_inject_fops, NULL, cxl_einj_inject,
 			 "0x%llx\n");
 
+static void remove_debugfs(void *dentry)
+{
+	debugfs_remove_recursive(dentry);
+}
+
 static void cxl_debugfs_create_dport_dir(struct cxl_dport *dport)
 {
 	struct cxl_port *parent = parent_port_of(dport->port);
@@ -841,6 +846,8 @@ static void cxl_debugfs_create_dport_dir(struct cxl_dport *dport)
 
 	dir = cxl_debugfs_create_dir(dev_name(dport->dport_dev));
 
+	devm_add_action_or_reset(dport_to_host(dport), remove_debugfs, dir);
+
 	debugfs_create_file("einj_inject", 0200, dir, dport,
 			    &cxl_einj_inject_fops);
 }
-- 
2.53.0



