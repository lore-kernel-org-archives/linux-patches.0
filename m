Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062374;
	b=XYhML9CIwl55dcUjcm5TtCtMqdlebGowrnKzMXTKaJzHn6lyjO6SwlF+LkGJ5EPwyud/
	 waNmJvNulsoeDznW6IISJ8W+RCT8mUkBgL/AEol8+/beLWg0Q3bC+ck4PbMsybIX6vilm
	 5ha1Uu3XMDvP5YRjbWzneFakPndSSFGOgxFLuTDog2Q6YHTuTPyrELbAryrOn/CCnuZMh
	 j1Z8IyKizCQLugXx+drOQ7HKTTnLRfLzROyAGD9vlY+CaQrQ9zzdlbErZlahqPkepkHwX
	 GhvyUebK7oOB3B+uggkwX55zWrYv3rg5DzWns5jlxzT3zH6jbW1cL/Y2KVAr3K4Gs9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5fy2XKZ738ovi9hR+pilxVsTAHC7kiYe1BaDcmTAWy4=;
	b=n05UBLmydvd0jEwoYjRYADccho4AvLs2bD+5TQNMEa8HmwJCZfEP4oVwivGEwwOXOxHT
	 VTKAeoVcg/zaFGmhn2ZnUTMoQbrHj60axYAqy1FiAAUSWVkmtrYMBTZrP/wmbxVOLdUFO
	 2EBNRbJd6lPu9aAeLp3kG7l7sUQBeYBUWpVAITXrFG2pnPThlehtbS3DN6dEBSgr8CiQ1
	 hq9Tba040uwvu3mN5i2N2GDHQuoLbrSVH10J82RKad+KDKqXk/F3ezIqVKNOJHIX6mrh8
	 aY0HzL8p/Ww9CQ20DduRQcvXUY8FPU2rX6pz0sQ/A8eHVyumESWsWVq+uzNX8tMmSlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iRItTZIN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35F8606A33A;
	Sat,  7 Nov 2026 14:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iRItTZIN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A006A1F0089F;
	Sat,  7 Nov 2026 14:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062373;
	bh=5fy2XKZ738ovi9hR+pilxVsTAHC7kiYe1BaDcmTAWy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRItTZINmMbNUJG7tIwlu6iT8rG7/Y2REVPqSiFBanlrpLWLGvPX+zoTsBSDio4bO
	 d2W7uvh+u23LpgQ0vNf1HkaLfLTm7k8joMbMnJkcp8QZPOE9L63ALT/tm9izR/TluW
	 X5/2hJ2Izd6xsqJJPcyT1TUU12qz4gNfNpZhF8UY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1297/1536] Bluetooth: 6lowpan: Pin module for 6lowpan_control debugfs file
Date: Sat,  7 Nov 2026 08:55:13 -0500
Message-ID: <20261107135034.217306585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1cb37fbb668f9..c0cdb99c44e2c 100644
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



