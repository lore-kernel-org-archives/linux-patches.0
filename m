Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056908;
	b=HS1w4XTTk6O27XWWHSF40hzGXT4WGvCMxhIhZbDT6dQa17b9DmrUaCnddOHvFsbZ1YuB
	 W1Isqx49vsr6Io4FSOtykOEYsv6sae5PLaH+nuG1KZHfhkvv99tGAdQJLNQp0ZH4iNi+V
	 9o0mZcYGmxKT43XfFWYQLIeBLxvhTso73k8qyqktt9XTiPw7gjBazMwXEpbReX+sRo94p
	 QK8Dow4wC3f1UZMG3A10yQTeH7gmsS0N8RoPUTCgoAZdJr9+gNUK3lxaJvSn1yJM3HRAL
	 QO6M96z+o7mV7gy3T4GaRhtmmTjJN7eJahn/Pjn1CYQgI4C3w3XlHu6MxBItiZBiGFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DcLDx/fCUTA08L229xSglSJogY1GBrwYbZEaYhfMJbo=;
	b=VOKqwV3h8BEWBW/58DkAltGh+HdhOdL4mY2TTwxgktqIh3oK5aA5wXVox+498IQiHJh/
	 9826YhUfjONAidGZZ8j/mRAJV2v+XRfcTKim8OsUSne7vvZqJ0HtjudmI0/parJSLNPaf
	 vmE2ZuQ0WGm37P3pzFaBQoJZgGANBHHiCKWxlTRQITHo7+WNGt4NMaJHLpJJb/giYw9H+
	 zRrAIbC6qwAAxT0l7jmmwAk2qfCYC8TzCPIq8qp910LxPMkoj4r/nuXwnIPa2H5gVheeN
	 winN0GX+zcsrTeeExip9o7auXxf20P0FJIvwaIUFueqAON6qXviG1C0Nxg12qslY3EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ROTfX7oF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7850A606A31C;
	Thu, 19 Nov 2026 02:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ROTfX7oF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF981F000C4;
	Thu, 19 Nov 2026 02:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056908;
	bh=DcLDx/fCUTA08L229xSglSJogY1GBrwYbZEaYhfMJbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ROTfX7oF7J35xfvruiEfgyzdZgFL0jQxCB74X+lzjnlY6Lv+ZA4FDKtKGAQD++7dl
	 Dx6/OaftE8aVZMWjl++vSCoZjER+CbrA4ktLJXjKd1gfC6w34VsJKnqetyEfUUj8RU
	 I/LtlcBPqofyVB5VafnvK3Pfe6t3AmsDHmh875h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c98b21427617af7f547a@syzkaller.appspotmail.com,
	Rongzheng Wang <testwrzwrz@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2154/2214] nvmet: use the enabled transport when disabling a port
Date: Wed, 18 Nov 2026 16:03:50 +0100
Message-ID: <20261118150136.633078845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e235898b80a36..142c941ea4b56 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -311,10 +311,15 @@ static ssize_t nvmet_addr_trtype_store(struct config_item *item,
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
@@ -322,7 +327,8 @@ static ssize_t nvmet_addr_trtype_store(struct config_item *item,
 	}
 
 	pr_err("Invalid value '%s' for trtype\n", page);
-	return -EINVAL;
+	ret = -EINVAL;
+	goto out;
 
 found:
 	memset(&port->disc_addr.tsas, 0, NVMF_TSAS_SIZE);
@@ -331,7 +337,9 @@ static ssize_t nvmet_addr_trtype_store(struct config_item *item,
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
index 8e2ac39ce3263..171644b315334 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -371,11 +371,13 @@ void nvmet_disable_port(struct nvmet_port *port)
 
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



