Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045514;
	b=45hAAjjpu05VCL56VtJRExNpEuNHFKkLXCV6z8PT3OCqCh6QrbdN4UUNjGsAahj9tQJs
	 znQKXtkV7KRCr+YmMGDmXrmJywlUYTrRQQRde9gnozJezXiViL+d5P+PJzOeQZfNcwKvt
	 1MvmIFLZZ8OSktuIXfRozTQXZCwlm6tPQOmCuH4gYes7T22VZSnayGduoJSvAY7Hb7lJ+
	 dm9gQDyOOQgpgdv157FcIE89s5GRCJgH3egid2OL3vyLH/0m6uw0fKL71rEEiXfYBjuSl
	 CdQTQyLjG2sWVH2I12KRl8H4fUh96S52yWNhye7BdbIGg6NEDNdG6qUMffIILLfEi0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q1dzFpn8lPHYHZ1Jt+s6r/Xqxp/6jEOCNzWlvIJtBq0=;
	b=USI4K+AmAX3pu1EiI1C+6KNUtWZUlJEYem3fOIw5XfdvJ5Jm7bM9Ot9yF8A2BSdaAtRM
	 SuFGf9CZujz4f25WpS7/YH5vc11qmNeR/C6LbyusaOZj33FuN113CtGFU7tE2CFSfWJw2
	 5VCWycuLt7rCu030uzXJ91/izkDV53UAXewg0DlXQ8UCLh9XK/vkfoS355NNdSCooaJXm
	 mpIfy+UL7EqeIlmqnsJg20fWIMqNAtIu9aNZ9TDJVeWvNl+UkUnqpFkS1Xn/8IfzqFiHr
	 9o2sDJCz6tcoeVnLoizxqYIAFJv6h+lV6UrNILxbiAWTx87ml0S3+JMOh5EOQFhAhvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s1h0mZuf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18490606A32C;
	Wed, 18 Nov 2026 23:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s1h0mZuf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A411F000C6;
	Wed, 18 Nov 2026 23:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045514;
	bh=q1dzFpn8lPHYHZ1Jt+s6r/Xqxp/6jEOCNzWlvIJtBq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s1h0mZufeMP7hgGU/jU7SxHcvIsBLhNsEkNxCoOIpki+7QqI9j9mmHILUrzb4LlAl
	 L0UOknwIpZjuz23fuKFgAx9CBU25DbqlWdYi09kRQcwYJX0H11wmg3QjrNYRhtL55H
	 1UQYJI79dMHNScM/UYX7g2NPgkWHWwpauI8ckbco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0951/2857] Bluetooth: 6lowpan: Pin module for 6lowpan_control debugfs file
Date: Wed, 18 Nov 2026 15:33:05 +0100
Message-ID: <20261118150235.849101454@linuxfoundation.org>
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

From: Bui Viet Dung <dungvn2345@gmail.com>

[ Upstream commit 8368f0c2cde48c09ed70644059f24172b0c59f52 ]

An open debugfs file retains lowpan_control_fops in the debugfs proxy
state. However, lowpan_control_fops has no .owner set to THIS_MODULE.
As a result, full_proxy_open_regular() calls fops_get() which succeeds
without taking a reference to the bluetooth_6lowpan module.

With CONFIG_BT_6LOWPAN=m, a userspace process can keep the debugfs file
descriptor for 6lowpan_control open across module unload
(delete_module / rmmod bluetooth_6lowpan). When the process subsequently
closes the file descriptor, full_proxy_release() accesses the already
freed and unmapped lowpan_control_fops table, causing a kernel page fault
or oops.

The issue was discovered via manual code audit of
net/bluetooth/6lowpan.c.

Set .owner = THIS_MODULE on lowpan_control_fops so that debugfs pins
the module until all open file descriptors have finished.

Fixes: 6b8d4a6a0314 ("Bluetooth: 6LoWPAN: Use connected oriented channel instead of fixed one")
Cc: stable@vger.kernel.org
Signed-off-by: Bui Viet Dung <dungvn2345@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 1b5a5bee3d07f..ff93a81940bb0 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -1201,6 +1201,7 @@ static int lowpan_control_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations lowpan_control_fops = {
+	.owner		= THIS_MODULE,
 	.open		= lowpan_control_open,
 	.read		= seq_read,
 	.write		= lowpan_control_write,
-- 
2.53.0



