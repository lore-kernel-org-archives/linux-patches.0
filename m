Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050607;
	b=YGsfkluoqGwJ9iVXvmsOKtioCo5y+2/yX0MnXCIqscrW4s/ZKTb/kdR3ZeZORHsvyCOo
	 FX7h8/hdmEh2ohjk7YKS0NLnMKH/2e4VYdtJFldUXAD+M4c7XBCRn2h0MFRXfI/tqlFdG
	 0Zu/G6EEYb7A/qV3OgoLUz048EH85UBjSOHcbCPae7kMimxxW/F54SvIR/37CgSlv4FUz
	 9c6aXCpBHG+epzcYs/e0DsEf89UXwcwduaz2n3m3GPcDh7AkREXzAdz3emvAt04BzbKPr
	 zsGMqYjB8liOtqEy893/SmP8q8xq+7+L9sg//9YiFVv4VxKP7afPUKcK9llBSWu9lOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KTted/iaydlYjCBEKynLnB/hDwoUf3SkD0MZG6A+inU=;
	b=ThWjcxkRqjtcXR3OJCpN/8C9ShlhHWp5GrBpGj6uND7RRFK9nsJdcz9j9fthXbCTXfB4
	 YgQIWUTjnAKHqQeWkSZIEMHQ6TYKyxIzsO3VMlHfvgy9q4pzFYgA0wEUDCOwu3qb3I+U+
	 JLyAwc1XI+Lp59LMyjFo2h6KkrkqPjtWMNuhzn2IRd7SIiTkCJBARkh/c4UMuL66OlvZL
	 LzWL8qpyKUQiKQX0y1wa2xJkT6qDaRfCD8Vwv4BQMtQSxKlFWBk45BL+zRqRMZjt7XpqR
	 OiAhrNMJcf70k6uozDMAz6UdPaeTME6qz6+mBgF92Ho7GT3lA3bb8j2R7kQH+yhk3VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cM1X7YFn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0D5606A320;
	Thu, 19 Nov 2026 01:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cM1X7YFn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1FF1F000C4;
	Thu, 19 Nov 2026 01:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050607;
	bh=KTted/iaydlYjCBEKynLnB/hDwoUf3SkD0MZG6A+inU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cM1X7YFnROFRfJ+YV9RpVLNlpcrEFRgtbeSXe4nUYO6ukEAj1uvWB2WU2eyQ6qc76
	 B3ZRftLZf1WUppBg0ajojJH9Y1ZxIGUv8xyJY/eVTQ9aGs88/LKie4C7Drz0x9Eya0
	 //h4ep1r1IKGJ09w1gVxXiW3PDiLuZNwgZygHcx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c98b21427617af7f547a@syzkaller.appspotmail.com,
	Rongzheng Wang <testwrzwrz@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2769/2857] nvmet: use the enabled transport when disabling a port
Date: Wed, 18 Nov 2026 16:03:23 +0100
Message-ID: <20261118150341.303981072@linuxfoundation.org>
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
index cece01a22d153..2ccbcf2baf481 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -317,10 +317,15 @@ static ssize_t nvmet_addr_trtype_store(struct config_item *item,
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
@@ -328,7 +333,8 @@ static ssize_t nvmet_addr_trtype_store(struct config_item *item,
 	}
 
 	pr_err("Invalid value '%s' for trtype\n", page);
-	return -EINVAL;
+	ret = -EINVAL;
+	goto out;
 
 found:
 	memset(&port->disc_addr.tsas, 0, NVMF_TSAS_SIZE);
@@ -337,7 +343,9 @@ static ssize_t nvmet_addr_trtype_store(struct config_item *item,
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
index 817127153f73d..e2367e6f566a3 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -373,11 +373,13 @@ void nvmet_disable_port(struct nvmet_port *port)
 
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



