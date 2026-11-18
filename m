Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042554;
	b=DBOcq10YfXHDlnQo/edqLIveGYf8FA3Pg5I/rT35vdjOtESd3YiSqoeujzGClvZzVtXJ
	 tcjc0huX4c4IFIdzULrGewt7Tx5Xt6qTSQ03TGv0Dixcah3EV2lOHuR7Zv9UddzIoLLI/
	 1m8GVBM86BgtYBZnb9go6ukxpfSQM+F4l67wq0fKp3T1owLl+iJ+2IhfO3ohoxsIGGzTr
	 7ZvShxC+TEeH97syFey23FnPW1dV7EgA0himVW2qilCV3VQsHkAe/ur5wwm/L8I8SoQ/i
	 ZjZasxtDG5DQ/KZ3iAQs7/4wMCPhQn6l+ZP6kySStL1xi9143MDrg+XfBAOsPvQmVZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p572rTHg9g1ZuGm8kf5aM9IX/zs4bwC8u7mEQzJot30=;
	b=MqlC06zgQbGN/HP282ncey9nlS9dgDVgMlvyZm4i19DU0sjC14fJzGODng+LPwElzGzQ
	 ynUJqI7tVAzqsM81jocG6f9hiofLh50H9SzMpJOFUgvMO04L7lHvyc/P0HSdwf8XIPKKs
	 VeL/PkDso4nKh+1fNt+aD6u7CqfjrWbsUrZ4ZA/UgWjomAnFboXVXYQtstrFxMUPCPWFT
	 kt4LcVnc0S3/oRKYWoX6T+vzuu0pjPW1WN8GOMd03pPgXYg9dExuk2aGQifoRWyN1nzzc
	 tNCKpXgfOKYasQUnJB3AXlbLp2g9PLN9ks71BKF+qG349x7wr2YmfKsp/eMdO9sjPrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EYqFKFIC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB040606A31C;
	Wed, 18 Nov 2026 22:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EYqFKFIC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAD91F000C4;
	Wed, 18 Nov 2026 22:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042554;
	bh=p572rTHg9g1ZuGm8kf5aM9IX/zs4bwC8u7mEQzJot30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EYqFKFICbKi2fOfaMoeWRGKr+SFUCj/puuTPiPN/woHtGZU3PwD/UzUdhMdAlYmwk
	 gJJkAM8CC1Nk8EL4Shob99hsGpSfvC1dfo/ru/JXHui2A3YJaE5azDOVMSQCpwYCPT
	 jWtz/5lYCAnXdcD6yXpxW0poZFPZ6GZh/WakP7T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c98b21427617af7f547a@syzkaller.appspotmail.com,
	Rongzheng Wang <testwrzwrz@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3213/3318] nvmet: use the enabled transport when disabling a port
Date: Wed, 18 Nov 2026 16:03:55 +0100
Message-ID: <20261118150456.133540017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 049c7f8226a15..7faac9242ae11 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -318,10 +318,15 @@ static ssize_t nvmet_addr_trtype_store(struct config_item *item,
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
@@ -329,7 +334,8 @@ static ssize_t nvmet_addr_trtype_store(struct config_item *item,
 	}
 
 	pr_err("Invalid value '%s' for trtype\n", page);
-	return -EINVAL;
+	ret = -EINVAL;
+	goto out;
 
 found:
 	memset(&port->disc_addr.tsas, 0, NVMF_TSAS_SIZE);
@@ -338,7 +344,9 @@ static ssize_t nvmet_addr_trtype_store(struct config_item *item,
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
index 1373e96dac729..342d5b73041b5 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -375,11 +375,13 @@ void nvmet_disable_port(struct nvmet_port *port)
 
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



