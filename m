Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590799;
	b=CNK43rrC4oejiVFuHjP5kTbabUaSzE1b6O6Iu9FprnbYAcV/nk7RvqLjKyICaTJ5sgsP
	 t93/fWBjNq9M25JyR6fjMCBki9PPs9qavYsnjoM9AeRL+r1KrLeGIQoFxFqq2TrbY3PHB
	 Mv9tamNor/rjOcy5AKPfjNj7m7rlSz5DiCgY0545zwSyXUtYn/vrXeoZfJ42jBJfqld6a
	 +Ch3dYU6xizP0knmzoXhiixV6+REOoJcNrE5Xn9pbqJNjaCffQCgyWhA0x6sgqcqL+rWW
	 dbKEzyAb3duTEZuHLw9I6HmTQc/rgpue4i/7Un1KReN3V28vlWjF6FQXBG9cqYjR6ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/SZDbg+TW5DHbwtBxxljAewnWPrZHdJYhIr9sAaQvl8=;
	b=yzdguWrheqf1ikRXEWHr4se+F3d9l/d0+HRB7pvVFXuzg9MO8zhwUZGu+uyyVQzNNsS3
	 hwCqMZ6t/VKRNLKDMY5CRzBKxK6Vgc398gF/6SrX8Cqm7Lz773SGNQn/Kn1z0nWYUJg/9
	 ehYmSCI7RzYCgEodJdmrHxzOJSBFgX1kmqqcnaiQj+4mQiSzc0TvAzafkDzAXTxqTvkoi
	 8h+u9aeNSCBrtlkCyedfK181tobmh4GGeyLSLY53/HIWlGv+D37dA3p0QvTnfYtf67F7S
	 a+qAFYGWi0O3RIvhC+DFERFsYBTtx7rfAVB9Aot1SupQlBcfF4LYUf9SLBDXE7eCvKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eteG6IQf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0A6607D2E3;
	Fri, 13 Nov 2026 17:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eteG6IQf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA211F000C4;
	Fri, 13 Nov 2026 17:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590798;
	bh=/SZDbg+TW5DHbwtBxxljAewnWPrZHdJYhIr9sAaQvl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eteG6IQfGK1qiyjYsW+gIFHLi1h4JhIoXpPnswCoxT3U39e1l81AF4VcBiRxyhu8A
	 xnJhzuEb9rgVVZ/rCw2IFCO7kOlNpNr0ovkOZmoZZGr9i4f5Kax+xQDA4V2bvuCIny
	 OLeLEiRjBgBA4V+v7HkmqTdkLtwOuN9Fxv6f8Ios=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Yingjie Wang <1075151112@qq.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 651/686] nvme-tcp: validate the TLS handshake timeout
Date: Fri, 13 Nov 2026 10:53:04 -0500
Message-ID: <20261113153843.824453015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Yingjie Wang <1075151112@qq.com>

[ Upstream commit 799203afd298b1f8e9ee49815eb38f775f211299 ]

tls_handshake_timeout is writable but stored as a signed int. Multiplying
the value by MSEC_PER_SEC and HZ therefore uses signed arithmetic.

With HZ=1000, setting it to 2147484 overflows both multiplications. If
the handshake request is accepted and its completion remains pending,
schedule_timeout() reports a wrong timeout value with a stack dump and
returns zero. The handshake then fails immediately with -ETIMEDOUT,
while the handshake agent was given about 24.9 days. Negative values
such as -1 have the same kernel-side effect.

Store the parameter as an unsigned int and reject values that cannot be
represented both by tls_handshake_args::ta_timeout_ms and by a safe
jiffies delay. Take one snapshot so a concurrent parameter update cannot
give the handshake agent and completion wait different timeouts.
Document the accepted range for built-in use.

wait_for_completion_interruptible_timeout() returns the remaining
jiffies as a long after a successful completion. Keep that result in a
long because an accepted timeout can exceed INT_MAX jiffies on 64-bit
systems.

Negative and oversized values now fail with -EINVAL. Keep zero valid,
preserving the existing immediate-timeout behavior.

Fixes: be8e82caa685 ("nvme-tcp: enable TLS handshake upcall")
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yingjie Wang <1075151112@qq.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  5 +++
 drivers/nvme/host/tcp.c                       | 34 ++++++++++++++-----
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 1b53bc0671249..e9ffe9c877b1a 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4652,6 +4652,11 @@ Kernel parameters
 			See Documentation/admin-guide/sysctl/vm.rst for details.
 
 
+	nvme_tcp.tls_handshake_timeout=
+			[NVME] NVMe/TCP host TLS handshake timeout in seconds.
+			Valid values range from 0 to the smaller of
+			UINT_MAX / 1000 and MAX_JIFFY_OFFSET / HZ. Default: 10
+
 	nvmet_tcp.tls_handshake_timeout=
 			[NVME] NVMe/TCP target TLS handshake timeout in seconds.
 			Valid values range from 0 to the smaller of
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 190eac661e7da..fad2f2f969a08 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -6,6 +6,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/jiffies.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/crc32.h>
@@ -46,9 +47,24 @@ MODULE_PARM_DESC(wq_unbound, "Use unbound workqueue for nvme-tcp IO context (def
 /*
  * TLS handshake timeout
  */
-static int tls_handshake_timeout = 10;
+static unsigned int tls_handshake_timeout = 10;
 #ifdef CONFIG_NVME_TCP_TLS
-module_param(tls_handshake_timeout, int, 0644);
+static int tls_handshake_timeout_set(const char *val,
+				     const struct kernel_param *kp)
+{
+	return param_set_uint_minmax(val, kp, 0,
+		min_t(unsigned long, UINT_MAX / MSEC_PER_SEC,
+		      MAX_JIFFY_OFFSET / HZ));
+}
+
+static const struct kernel_param_ops tls_handshake_timeout_ops = {
+	.set = tls_handshake_timeout_set,
+	.get = param_get_uint,
+};
+
+module_param_cb(tls_handshake_timeout, &tls_handshake_timeout_ops,
+		&tls_handshake_timeout, 0644);
+__MODULE_PARM_TYPE(tls_handshake_timeout, "uint");
 MODULE_PARM_DESC(tls_handshake_timeout,
 		 "nvme TLS handshake timeout in seconds (default 10)");
 #endif
@@ -1912,8 +1928,10 @@ static int nvme_tcp_start_tls(struct nvme_ctrl *nctrl,
 {
 	int qid = nvme_tcp_queue_id(queue);
 	int ret;
+	long wait_ret;
 	struct tls_handshake_args args;
-	unsigned long tmo = tls_handshake_timeout * HZ;
+	unsigned int timeout = READ_ONCE(tls_handshake_timeout);
+	unsigned long tmo = (unsigned long)timeout * HZ;
 	key_serial_t keyring = nvme_keyring_id();
 
 	dev_dbg(nctrl->device, "queue %d: start TLS with key %x\n",
@@ -1927,7 +1945,7 @@ static int nvme_tcp_start_tls(struct nvme_ctrl *nctrl,
 	if (nctrl->opts->keyring)
 		keyring = key_serial(nctrl->opts->keyring);
 	args.ta_keyring = keyring;
-	args.ta_timeout_ms = tls_handshake_timeout * 1000;
+	args.ta_timeout_ms = timeout * MSEC_PER_SEC;
 	queue->tls_err = -EOPNOTSUPP;
 	init_completion(&queue->tls_complete);
 	ret = tls_client_hello_psk(&args, GFP_KERNEL);
@@ -1936,10 +1954,10 @@ static int nvme_tcp_start_tls(struct nvme_ctrl *nctrl,
 			qid, ret);
 		return ret;
 	}
-	ret = wait_for_completion_interruptible_timeout(&queue->tls_complete, tmo);
-	if (ret <= 0) {
-		if (ret == 0)
-			ret = -ETIMEDOUT;
+	wait_ret = wait_for_completion_interruptible_timeout(&queue->tls_complete,
+							     tmo);
+	if (wait_ret <= 0) {
+		ret = wait_ret < 0 ? -ERESTARTSYS : -ETIMEDOUT;
 
 		dev_err(nctrl->device,
 			"queue %d: TLS handshake failed, error %d\n",
-- 
2.53.0



