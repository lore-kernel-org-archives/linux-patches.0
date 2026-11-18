Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022067;
	b=zGj+mDnQ8SyQqGONo132sF3Mj7SWAqYZxBK5G20AshGKCZi0AhsCaVEIBOl0eS8K3Spr
	 9HaUxpy/Ye1Do5DFk29Hj/iB3/PYHKEcObCT6fWfwnocWpWo5cdz6xKNW03w9QfWYul0T
	 KR6xqjfrPgb2NaMtWQgFf3RhEkfmBEKS6YiBZYcallaz3nlVGluM9BCXDjAZUih0NTCtC
	 f4WgnGbIo+bQA6wP1eKFibSJFzp/yqIt4mErkYrVc7pDvHE1SgW2hy6NI3Ga3Uxc2xD5i
	 ZNqk2+baCDdO+COu5cRFaUYUsu9jRx4/9B/PEPvf3LmnZvQbsBSORq4XQ3k2p3zPWwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ICzQQ6v7vfr3RTWrOeVo57Q3dC1kseg29JExTDpzgmo=;
	b=FGR/i9qMLmS746242mmdVAJv+1oPVQP12t8Y9YUBYasYdLKgRgektcokKyIiuNLcu+g1
	 fzB93QkDx0vRtj3UYGr/i2Rs7GhK3ahv0YROLIKKzivhcL98FN5jyDxwHakqEhOSKZ/Fg
	 vVrAF/brPZP35ruWZQ1WiRZ1bT3u4Bl7IKSQiIVu+v1JW/6hIVRujjVy478v9TjhiIguU
	 NFOMTyxCqc6tKe3G7B5SGpq96fJ4hhC/SfnJLhuTYWMaDGmxQ27FXYiVxHxJTWUuHb8Xc
	 PESWCiNrEpdbtuoxu+Ir9bw0uifnyhUCgHL5xB2Ab3P95FMk6/awQr4ufGTwY+nxLjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5CWCkpL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE90606A31C;
	Wed, 18 Nov 2026 17:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5CWCkpL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64731F000C4;
	Wed, 18 Nov 2026 17:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022067;
	bh=ICzQQ6v7vfr3RTWrOeVo57Q3dC1kseg29JExTDpzgmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5CWCkpLShP6jj3J3n3/BeSZr+JSVeVKISpw9IltJqmcP4J+hgSO3rqP9r2BAMpTZ
	 wu0S4gC2UPWuUFKX81zfoIoYXZRaiiev1oA7dhQ7nz8hvW7jZNpuNxNx3KL8e8hC4t
	 LxSgyuCJfooXo1rLUvyiW84QKFO0+fBlG2QO68dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c98b21427617af7f547a@syzkaller.appspotmail.com,
	Rongzheng Wang <testwrzwrz@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2529/2651] nvmet: use the enabled transport when disabling a port
Date: Wed, 18 Nov 2026 16:02:49 +0100
Message-ID: <20261118150415.677207025@linuxfoundation.org>
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

From: Rongzheng Wang <testwrzwrz@gmail.com>

[ Upstream commit 60385038754ed9fb05dab127b35f88c702252505 ]

nvmet_disable_port() looks up the transport from the current
disc_addr.trtype, while nvmet_enable_port() records the transport in
port->tr_ops.  If trtype is changed while a port is being enabled, the
port can be removed through a different transport, passing the private
data of the original transport to the wrong ->remove_port().

The same mismatch is reachable with loop and RDMA: loop add_port()
leaves port->priv NULL, and RDMA remove_port() dereferences it.

Use port->tr_ops for removal and serialize trtype changes with
nvmet_config_sem in nvmet_addr_trtype_store(), so the transport that
added the port is also the one that removes it.

Fixes: 8f000cac6e7a ("nvmet-rdma: add a NVMe over Fabrics RDMA target driver")
Reported-by: syzbot+c98b21427617af7f547a@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=c98b21427617af7f547a
Link: https://lore.kernel.org/all/6acbc835.a150a118.27e199.003c.GAE@google.com/T/
Signed-off-by: Rongzheng Wang <testwrzwrz@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 16 ++++++++++++----
 drivers/nvme/target/core.c     |  8 +++++---
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 0c9d02299bcf4..81d7ada2fa05f 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -387,10 +387,15 @@ static ssize_t nvmet_addr_trtype_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct nvmet_port *port = to_nvmet_port(item);
+	ssize_t ret = count;
 	int i;
 
-	if (nvmet_is_port_enabled(port, __func__))
-		return -EACCES;
+	down_write(&nvmet_config_sem);
+
+	if (nvmet_is_port_enabled(port, __func__)) {
+		ret = -EACCES;
+		goto out;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(nvmet_transport); i++) {
 		if (sysfs_streq(page, nvmet_transport[i].name))
@@ -398,7 +403,8 @@ static ssize_t nvmet_addr_trtype_store(struct config_item *item,
 	}
 
 	pr_err("Invalid value '%s' for trtype\n", page);
-	return -EINVAL;
+	ret = -EINVAL;
+	goto out;
 
 found:
 	memset(&port->disc_addr.tsas, 0, NVMF_TSAS_SIZE);
@@ -407,7 +413,9 @@ static ssize_t nvmet_addr_trtype_store(struct config_item *item,
 		nvmet_port_init_tsas_rdma(port);
 	else if (port->disc_addr.trtype == NVMF_TRTYPE_TCP)
 		nvmet_port_init_tsas_tcp(port, NVMF_TCP_SECTYPE_NONE);
-	return count;
+out:
+	up_write(&nvmet_config_sem);
+	return ret;
 }
 
 CONFIGFS_ATTR(nvmet_, addr_trtype);
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 8f791d5651bd3..c3c94bb7fb846 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -393,11 +393,13 @@ void nvmet_disable_port(struct nvmet_port *port)
 
 	lockdep_assert_held(&nvmet_config_sem);
 
-	port->enabled = false;
-	port->tr_ops = NULL;
+	if (!port->enabled)
+		return;
 
-	ops = nvmet_transports[port->disc_addr.trtype];
+	ops = port->tr_ops;
+	port->enabled = false;
 	ops->remove_port(port);
+	port->tr_ops = NULL;
 	module_put(ops->owner);
 }
 
-- 
2.53.0



