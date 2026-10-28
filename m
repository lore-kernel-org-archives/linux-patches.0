Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214632;
	b=o/0hTRxbPpurl+kqiDKBWndM3ea4OBZPaADsXJRQhNpjsI6/UqXi4ArhryvvKBcCjMN2
	 8oBcS3TTRuINkvaVZ1U+E1TFyweTEyYfsA9o5Zoj2BOh/gmB9k2AF/cd5EDMqmrqJuf6l
	 uMP8oauUk588pvgyu6K0Yb8/1MvhJYyxc5i7oX267ChmSmQX3paUx5hRtT5BYFktlLDZE
	 hkVyNpJnbiYk4Kp5+uM0Zpl6O9DbNezNBBPQ7RShtuM/qKVhrGq90eQ5gocsRYdTSOgOe
	 2HRuQV8PA/utXw0FA6VunTLb2FBKc70aPQPuvEszip70LWUHtAv95/0X2a6YDyf0eDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IMKJneZE4XlACxlf90ysoMp6uS+9URHTjwNUVTlRQDc=;
	b=SH5wVG12CmlMcBBVVsbLQzwIz84jJagwDKa4OzxRuCWACMketwPtKlJlnWLGanffq6hn
	 4Es9yX1DYRuWTZvwxkX57sESL2njdywjWN9kfS7pFTYgTgjNeuqRboUkfVRcY+g6LKiMF
	 EX6oev+KZEmkemmtFjpK9w0nYGeknYpaE6ikUtEn6ep4XPyvGsRe+eJKlbsoxoO7TPpg/
	 zQUY1BG4HQK2MZJ3Fx3iN5XAloW1JvMUAZBduOTLymDBX7qx6rYrwIEaxmZww4dDSn/0K
	 cV3sLpKjgx7TJ+e4m3ySwPBPoKq/jyKJtJ9tTz5WOehSYeERrjXxPJGQHm+cedR+elw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W3xSnkyH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734DD606AB21;
	Wed, 28 Oct 2026 19:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W3xSnkyH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47601F01825;
	Wed, 28 Oct 2026 19:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214632;
	bh=IMKJneZE4XlACxlf90ysoMp6uS+9URHTjwNUVTlRQDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W3xSnkyHNSJzE5x+/1LSyL9GdKDeMjdtvLDZEvLQUUXDytbNCRL9kpvkUuDuo/aY7
	 pJ4BoDS5zM6TnAir2JLw8cGY3Orj1iysCXIaBFWOV007Lq+Fv8St8iXFBjCFtLcKr+
	 3L9LzDM7Hl4IER/qcoZAcfrNR23WNBJ7Stg6l5hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>,
	Zilin Guan <zilin@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0927/1887] of: unittest: Fix memory leak in unittest_data_add()
Date: Wed, 28 Oct 2026 17:50:23 +0100
Message-ID: <20261028170520.511142152@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 235a1eb8d2dcc49a6cf0a5ee1aa85544a5d0054b ]

In unittest_data_add(), if of_resolve_phandles() fails, the allocated
unittest_data is not freed, leading to a memory leak.

Fix this by using scope-based cleanup helper __free(kfree) for automatic
resource cleanup. This ensures unittest_data is automatically freed when
it goes out of scope in error paths.

For the success path, use retain_and_null_ptr() to transfer ownership
of the memory to the device tree and prevent double freeing.

Fixes: 2eb46da2a760 ("of/selftest: Use the resolver to fixup phandles")
Suggested-by: Rob Herring <robh@kernel.org>
Co-developed-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Link: https://patch.msgid.link/20251231114915.234638-1-zilin@seu.edu.cn
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 598e0891533fd..2dc62174e1679 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -1546,7 +1546,6 @@ static void attach_node_and_children(struct device_node *np)
  */
 static int __init unittest_data_add(void)
 {
-	void *unittest_data;
 	void *unittest_data_align;
 	struct device_node *unittest_data_node = NULL, *np;
 	/*
@@ -1565,7 +1564,7 @@ static int __init unittest_data_add(void)
 	}
 
 	/* creating copy */
-	unittest_data = kmalloc(size + FDT_ALIGN_SIZE, GFP_KERNEL);
+	void *unittest_data __free(kfree) = kmalloc(size + FDT_ALIGN_SIZE, GFP_KERNEL);
 	if (!unittest_data)
 		return -ENOMEM;
 
@@ -1575,12 +1574,10 @@ static int __init unittest_data_add(void)
 	ret = of_fdt_unflatten_tree(unittest_data_align, NULL, &unittest_data_node);
 	if (!ret) {
 		pr_warn("%s: unflatten testcases tree failed\n", __func__);
-		kfree(unittest_data);
 		return -ENODATA;
 	}
 	if (!unittest_data_node) {
 		pr_warn("%s: testcases tree is empty\n", __func__);
-		kfree(unittest_data);
 		return -ENODATA;
 	}
 
@@ -1602,6 +1599,7 @@ static int __init unittest_data_add(void)
 			__of_attach_node_sysfs(np);
 		of_aliases = of_find_node_by_path("/aliases");
 		of_chosen = of_find_node_by_path("/chosen");
+		no_free_ptr(unittest_data);
 		of_overlay_mutex_unlock();
 		return 0;
 	}
@@ -1622,6 +1620,7 @@ static int __init unittest_data_add(void)
 	EXPECT_END(KERN_INFO,
 		   "Duplicate name in testcase-data, renamed to \"duplicate-name#1\"");
 
+	no_free_ptr(unittest_data);
 	of_overlay_mutex_unlock();
 
 	return 0;
-- 
2.53.0



