Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062130;
	b=XumGlMCJq+KdlcOKB3xmN1GxZqy4WiU6Na2DrjrqeE6I8eNT4NfNVbjFmC5JzfizHjRT
	 rbMRF/Xirr6Mlp5zjJnnmS5n33FMvtt8ZoeFkeVZvTzLuMzaqNZNEJyZ6dQuq8F2IANe9
	 tuaZ3ud7i8bPZSTBesxEUa6ZPiXm/Q+rn3o1nhNdHDQziCt1eWePXb43QY+z43OjlvWpL
	 Fu0HfCQ3NBBZaNUoXeDhhZUBruWquudhCtcGZtUPw2fZTl5FtZbGVPd1JSz4Yinx1Sa04
	 wA8aaijfsxnVR5qiQEEzplY+pRNyG6mLhfKQ5jttEn3ukt/CBjiZWqRAKLFTPIldybA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N1QHtGop3CD8OE+e8bKcxJB3xZEPu86O2jlEH8b1oEg=;
	b=peTKKwMmCP5CDvS9WoIDEbtwUM4OSJq5VN8/v6GYstCFTZphJHR97ywDGBydtQS8ZxAt
	 zVFfaAyekF7EBw5DNUi5+hRJutNUJaqkeuCTcK3ctazYCkJ1PPWYqn6fe+0+xOaxkyWnx
	 IER7fIwqUf4HMmyS/AP0iFu0KjyW07phoGykLi0ess+2/h1kfc6LdNUuGcy9eTJYAO2fi
	 Gvx0guZe0Edcg1nSpz97w7KTZGMuG2NWSBrSJKRh2LAIwpsCwWWuKXTEsTp4nsBc5x0XN
	 EZuJAw+90xCbz1Rr5Hde3GdtcBUprReFfuZaZT2s8uWEKMTKYMxtlkx255hlkmGHXtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=THUO1zwS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02747606A320;
	Thu, 19 Nov 2026 04:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=THUO1zwS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5517A1F000C4;
	Thu, 19 Nov 2026 04:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062129;
	bh=N1QHtGop3CD8OE+e8bKcxJB3xZEPu86O2jlEH8b1oEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=THUO1zwSSZMBJgxGzZqDWGRKzHbYQKtGlZ50lH3kb0XOF5FznPvt+/hzq6dUe+sGY
	 9ngk3nyTO3zkVgmld6l6v4yRxccAgCdlMgQ4Omrj4Ac0LO1Iat6vZeWFoZmADY1TuE
	 klPw1sOIOrLOCU3OZN1bHVuOCBOSemp5ri/6jP2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c98b21427617af7f547a@syzkaller.appspotmail.com,
	Rongzheng Wang <testwrzwrz@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1800/1848] nvmet: use the enabled transport when disabling a port
Date: Wed, 18 Nov 2026 16:03:58 +0100
Message-ID: <20261118150034.610743356@linuxfoundation.org>
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
index 299f7854acd83..e4eb3b10071dc 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -313,10 +313,15 @@ static ssize_t nvmet_addr_trtype_store(struct config_item *item,
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
@@ -324,7 +329,8 @@ static ssize_t nvmet_addr_trtype_store(struct config_item *item,
 	}
 
 	pr_err("Invalid value '%s' for trtype\n", page);
-	return -EINVAL;
+	ret = -EINVAL;
+	goto out;
 
 found:
 	memset(&port->disc_addr.tsas, 0, NVMF_TSAS_SIZE);
@@ -333,7 +339,9 @@ static ssize_t nvmet_addr_trtype_store(struct config_item *item,
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
index f1a8918156ea7..a9b2dc434a2e4 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -367,11 +367,13 @@ void nvmet_disable_port(struct nvmet_port *port)
 
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



