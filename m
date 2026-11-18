Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058532;
	b=jTd3TNASkjnHUDLQ+d/H5fgNHJRssX2OEzmDeIneQgKafOgT8ZgX4iBSHy2mAA7/lW6g
	 mRL2NVNfulvqn2SghEClJjRN6E4OkCNrqFZ0Ajdxalak3IDGWuKIsr//UzKN7HoEIBiiU
	 D8tjH5fc4JOCl5GzRsdVq0QltVpgZfDbTecgZQsBeEJAZ8bBz9fMB9Vrnm9LsYt9ZABSL
	 DoBILo9OQV4EiZqjOa500caw57g60J4FNidqIOLlhNSywaeXnOfooNfCePbG40nlFoMj3
	 CTE8TsXN9qMcni8+eqX52wfEHxy3llXhGZFnItfs1XJx4hW7XvO9lK+veKWyN38Aapw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MOHgjCcJxjpv5gS4uXNJs6jiquEIZx12s5pZAXlnMfc=;
	b=4q+8PT5KXWP5d8Gbefyr3cVH4e23euVwsdSFn0p+214Kgd9PoIEWxdWtmcTo/GcaER0F
	 j5a3BMw06GYpbZiQn4KMeY6v1pmiFlHU5YKX2//tRJrVGlkv5MSJL5Jqj5USFpvGOsXEi
	 9BPRfldhK8+DpFdT1iGVYSKW22Hfxh4MYyLTYwDz5cYdM44IcSL+iLOOmJ+wt0wenJtN4
	 kgVeAiFb5GEWHVQKGkUKhV+CAlSSVKa5+N4l7d5HlF+f0R47YWRVZYBzqfqT60tidDUvO
	 8Za5macd43P4TbyNFUKAzrry9auRz3YahdYDgCG3Llx3oKyT3umJli/zGWVAzKBx7qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GrJyu1YN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E443F606A31C;
	Thu, 19 Nov 2026 03:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GrJyu1YN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D1E1F000C4;
	Thu, 19 Nov 2026 03:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058531;
	bh=MOHgjCcJxjpv5gS4uXNJs6jiquEIZx12s5pZAXlnMfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GrJyu1YNQHar+8Vn4jksRe9YeK8PCtVHKqaV6tI72T0zOFaD+xTkEiOCpXMOYcj6Q
	 P5t48n7C1Io99cD9DXL4XJD27I4OP5qA09l2xQExA1+iZ/fcvlNtBbYq35Z1Jwoh+D
	 0J7bYAroO7NKq1ZUentXmB3Wo14GgF8RZ9Mduvlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0518/1848] Bluetooth: 6lowpan: Pin module for 6lowpan_control debugfs file
Date: Wed, 18 Nov 2026 15:42:36 +0100
Message-ID: <20261118145936.357201096@linuxfoundation.org>
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
index 9a9b1c13ca91f..17c9af8d4bc68 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -1264,6 +1264,7 @@ static int lowpan_control_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations lowpan_control_fops = {
+	.owner		= THIS_MODULE,
 	.open		= lowpan_control_open,
 	.read		= seq_read,
 	.write		= lowpan_control_write,
-- 
2.53.0



