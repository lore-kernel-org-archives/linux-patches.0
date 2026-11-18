Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036711;
	b=FgrYlu6QfEsbo2f8nHpKJj+oXwuWzS5fQbPNSIx8E3LBD4wgHGdQkO2UI4vgtIYNYlGU
	 /CpS7Zd1hS7h2M2XZ4aIn3o1dtRuqQctFYXxMq3lH1UpRcMGk6nnHkxn+M3uPaGUfOzVw
	 KDQPEdlgWItPv7q0VzDLwg09mkCQ02gXnBt8Um9TroPl+lxyY6zI5cbNMZT9E7qe2fAoJ
	 96Ce6FpoNl8A6IQyInQjbXwLjY2kfGubUKBiajg22El5yIeID3xbky6JAaPA18UrR02u0
	 qy9CWQSKfZBWZsZ7dwJSjHoLtNKy4Q3J+2chJPHpEky97bVC9W6xsA84oZNqKRY0HEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WSW7ENEu0fxn1CpPG/4PxtettrsZcbKTTS730FnqNic=;
	b=LvfQnM/RahA2mAlWmsj39mheuHHa0zkLWjda7sdqmXtoF5NZfB84aF7wwa0L2dH9YYma
	 9Ei5L0Ir8OMOlL2WxO1uGrKQHbBG46WJGvX8iEBlaBDR0jqAtqWz1xkfeCCbhg333N+px
	 MK/WRuQOArj1kyXIsV4u8HCKeFmvOMlfKbiAaChNG7bihD48mEXMxI8KJXqsuHKIoj+4f
	 y0YP6Ihe0cQrekg2fCVFb5xBgwtPGPCW1M0QEsvhhIxxQufjS6Dz5qU9aGPHzAr7iSIFB
	 8Y6DyhY+m6O9PRY/8z7qAX/iTXQh2wuVqYcXQtQKThjl/lqU121ETVDOCA9JmHzpzKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hyI4/DjD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E42D606A31C;
	Wed, 18 Nov 2026 21:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hyI4/DjD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38281F000C4;
	Wed, 18 Nov 2026 21:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036711;
	bh=WSW7ENEu0fxn1CpPG/4PxtettrsZcbKTTS730FnqNic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hyI4/DjDp6BlmeAMA8cnZvYds9GBaLFW+AREywfexi3WVcnAwPRTMojYvJgOGvDzt
	 LAkAWU6uS7aRxsa3CMA2C8WCMlwadmyB60dd7IWgMxITcQWbC+hX8Ky/BlvJGEI9Nc
	 yHcjHxO+lSlZtO7/Yv2ESaKfqyA6Yh0Kqi4ad9mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1113/3318] Bluetooth: 6lowpan: Pin module for 6lowpan_control debugfs file
Date: Wed, 18 Nov 2026 15:28:55 +0100
Message-ID: <20261118150353.394923042@linuxfoundation.org>
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
index 53b09639cba52..5197d3726ea50 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -1200,6 +1200,7 @@ static int lowpan_control_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations lowpan_control_fops = {
+	.owner		= THIS_MODULE,
 	.open		= lowpan_control_open,
 	.read		= seq_read,
 	.write		= lowpan_control_write,
-- 
2.53.0



