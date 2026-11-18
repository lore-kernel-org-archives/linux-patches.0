Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026294;
	b=rCgTXUvWK9xoyC7j+b9TYCmdtwFf1JfqmDM/OvB70wRnqp8i0U1UX09PleTXymTxiTN9
	 qYDLCZZKvnyYffT5hwNL5MxAi/gHTP3z+4V3Vn9jyIKcLPQ3GA68Qs+yGKBK7MjvRakb9
	 be6DSSeFlIG7xtM7sgIaY/8pjp1RmQIp8uv47Dk87eopIXpYIGAXfX9sF5j8SupzVkmud
	 YDTKcCtFZ3OIJGTU7TKqIctGcYzRNHNR43Fj8lAQeE0U6ERW5BwGrS/LveW3QU6gH263m
	 J+rwywQ4r76yP5xEgnl0G/IMkBLw1K+MW0i2OV6GckD+wpz1CDXllR8zaYzdlcbQjQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=SuhmXo9piOXo99rLzKCrCOdiD0KXsSaXt5Oaxeb1urA=;
	b=OTspH9j8cq+MM5YUx1KVqXHQfq5Sun2PhL2dU49KYhdyo6UkczmaGWg2UzABdbVVSTxZ
	 YXnf+JV+wxIideHvMirB7nWP7oFxqYwnixN4mjYbZcr1pzSUR3PUNXM9mLhRlHCySqr9I
	 jlucRv7zi+6uggOioncDZVRfri/diRDlN3qUFQGMTt/ahz7p8+if1QJUs4aX6zrr59Zu6
	 qzErDSpiK3JhYcOkhvkoTH8F5r4V0Tdahx+2Oxvr0LSRDyIi/YYh1xvvBNEmKCHUUvkBM
	 m5YcGXSRE09oVGXOLPg62twMmhoXZFMpx4nP1lCULuZhiBEKzNLl7mci+Y39W4OLT2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NzE90BRw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACA7606A32C;
	Wed, 18 Nov 2026 18:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NzE90BRw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DFB1F000C4;
	Wed, 18 Nov 2026 18:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026294;
	bh=SuhmXo9piOXo99rLzKCrCOdiD0KXsSaXt5Oaxeb1urA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NzE90BRwNi16co0r5Mm/ZYCvJQyjX4Cnb2b4nop5EuURjiGqAMc7dQ+HifhMuafUZ
	 vHpFRxo/tJ1FsN7T9H92t5eWk/0m8q2EzQgMm171LqtFddw7MSctnLvltsWySMdjr4
	 8vVVR1D938h4T84Ehckrqqi9o2RXX1eSX5mfC1fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1385/2151] platform/olpc: Reserve space for a string terminator
Date: Wed, 18 Nov 2026 15:52:00 +0100
Message-ID: <20261118150212.454927643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 1fe88b1741ff655bb59e4fd78178fe2c557b9185 ]

ec_dbgfs_cmd_write() copies user input into a zero-initialized stack
buffer and passes it to sscanf(). A write that overwrites the entire
buffer leaves no terminator, so the subsequent parsing can read beyond
the buffer.

Limit the copy to leave room for the trailing NUL.

Fixes: 6cca83d498bd ("Platform: OLPC: move debugfs support from x86 EC driver")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260926121250.3258285-2-yaojiale02@163.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/olpc/olpc-ec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/olpc/olpc-ec.c b/drivers/platform/olpc/olpc-ec.c
index 48e9861bb571f..c264c9b888f94 100644
--- a/drivers/platform/olpc/olpc-ec.c
+++ b/drivers/platform/olpc/olpc-ec.c
@@ -269,7 +269,7 @@ static ssize_t ec_dbgfs_cmd_write(struct file *file, const char __user *buf,
 
 	mutex_lock(&ec_dbgfs_lock);
 
-	size = simple_write_to_buffer(cmdbuf, sizeof(cmdbuf), ppos, buf, size);
+	size = simple_write_to_buffer(cmdbuf, sizeof(cmdbuf) - 1, ppos, buf, size);
 
 	m = sscanf(cmdbuf, "%x:%u %x %x %x %x %x", &ec_cmd_int[0],
 			&ec_dbgfs_resp_bytes, &ec_cmd_int[1], &ec_cmd_int[2],
-- 
2.53.0



