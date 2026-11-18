Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023960;
	b=Ox1mSG5rtzx7kqc/CLSgSxdnPnf9PTcjOF7wajiZkban0Qi/i2ZnSPfz09M0sjFC6c24
	 W3F9xHwheQ1YT02h3v+QJV1eXHfYBvpENZJ7QHF1/fm+ECqw4WJ86rIl6JFX5VFi451vL
	 DXGBLKxYI6t/KDoxncSM6yaWVSIyH2KZznKk0HiZIK4wFCj+vf8qaEOtfz6kVw8Gc+zfl
	 pXN0oyKOmVf27XeKoXgyFnOiru3owlubnDwXQmOyuMh0dn2MuKs9b60uz3OvH3ygSYrZ8
	 btUEtsVhE03k+5Y4E2HneT5DsCoIM8APdRcQDYmdfCYlORDn0Rfb/b2w5LwsOwatNxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nw8clo9mmyo/825djvLHU861AFFTOqVkEoKqaMCojIk=;
	b=Y/n6/AbbTvVYmM4I07jjeeQfiUWqsd7iNe4pqyf8Zk35U46MpaWuLg5pe6NMh5NZJcUo
	 klapqdrLi9HwehJd4BYNlpeAah2WpNukjS4yDjzWLYtNUcozkoGVInp9zT31TUd8mqhDF
	 gmNZDZBo0xcY8T78Fdd/Lpd/m2SbKW21IRr0E6PYb3RbtvkpCg22Oe04JhPU+Vza5xFZ9
	 JlqwYKLVSAwkRfznDhkLombRABMXapmq5gVwoxhNOh04SJxGDlpm4FzqcssiQtvveO3PK
	 pGpl/v7++l60lAzqOZWBPNHivBwKG7998F1806XBrfGrEfBjSVPNwbZoah1pnqDvUqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O36rvupo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC9F606A31C;
	Wed, 18 Nov 2026 17:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O36rvupo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88AE1F000C4;
	Wed, 18 Nov 2026 17:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023960;
	bh=nw8clo9mmyo/825djvLHU861AFFTOqVkEoKqaMCojIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O36rvupoA7Q99VPeWlT77aDfexCrOfahsRbImsEvUgUEXPkGtaLhuko7Q9ECGXCSL
	 tJKG8VkzQHwKATQgh2bQ+83U0JVEOne8Pmxiw83wFfeQjshler0JyLcDAKjxdz8goe
	 idtRIQ5qPVATlZ91nKsbclzylJVGxvHm659Ipp/8=
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
Subject: [PATCH 6.18 0518/2151] cxl/core: Fix dport use-after-free via the einj_inject debugfs file
Date: Wed, 18 Nov 2026 15:37:33 +0100
Message-ID: <20261118150140.911922900@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index c049b0e5eca7c..bfb2e457fa223 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -835,6 +835,11 @@ static int cxl_einj_inject(void *data, u64 type)
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
@@ -853,6 +858,8 @@ static void cxl_debugfs_create_dport_dir(struct cxl_dport *dport)
 
 	dir = cxl_debugfs_create_dir(dev_name(dport->dport_dev));
 
+	devm_add_action_or_reset(dport_to_host(dport), remove_debugfs, dir);
+
 	debugfs_create_file("einj_inject", 0200, dir, dport,
 			    &cxl_einj_inject_fops);
 }
-- 
2.53.0



