Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041308;
	b=IBL/fApIhkizlmfmq/YBgfuQjTnzMmTT478GwJa59CazMMA1FDhq7JEL1u8cyWSRIeXb
	 DBadkOXqwYAdcG7D5XOW5+jBOFyUN5NLRlPjM1qFSzkZA/FcjWaichnxSoxqaLUo+qbyQ
	 NBZCBilMbsvqKWCIdsoeAc43HMXZu4tW+kWH4jE9Xdf1yJBLMCYTO8d0uQT4UtJeGCnu2
	 f97fqkxb4Ikgc3DBm59rVETYm3H4K/xjE8XUW15pDk9uk5jGRm/9tJzxZ4X/5jIGQDFga
	 1ASvzCvoHbCLtR8r6BbF2SLP1aqNmVdI6xeJJqFLlW+Rm6wibwjRHlBm8KHEkSRxeVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CszhdA4Yzp5HUmDssCFT3xh6rt60ewIlAsEspLEOgXM=;
	b=z6KsDOYGJh2RreGJ/TLTCl/vT+amoFx175nctVMirZRQuavo5R6iJ2O3yZdIFei7HJzG
	 a1r86g/yoe0lUz+ZmgtMqfMqzM0zrj6Oj3q1bvJpqI7uHlBf5A9Jw+xvFyzb6n3S0yKim
	 2Fwn3cRQfolYK+ELMOfCLpILwv5xQr44eE2enUuGxcuC5khKlh5xL7PUIF9NcAdpkWEGB
	 RJrhg10VH7itt7iiYqL7pUvUNu+HvCP9FTu8F0Er+FqxkV5HLQUKUoggKgucsHQwOp7md
	 aTBroTdMuIKKFGyto7JZCluCkBZU/+2hdTO44ez1BGIn5qoJGphY4PNdb+ozhFUTMLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ugDSvAkP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C927606A31C;
	Wed, 18 Nov 2026 22:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ugDSvAkP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933A41F000C4;
	Wed, 18 Nov 2026 22:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041308;
	bh=CszhdA4Yzp5HUmDssCFT3xh6rt60ewIlAsEspLEOgXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ugDSvAkPI9qynB5GZdygV3UDMdbdcepDdDmU28WjcjnapoUpDZReRpSEJRH8pYt3t
	 LdT44/sq+4NekjDjIjOu2T5zB8ceUTslbJvRtLL9RsB9MVfb+183StoJFkxVGeZitk
	 nwxOpW0TheBQwXBnlr+Wij1ZDuK2tHBjbri4+E04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2768/3318] platform/olpc: Reserve space for a string terminator
Date: Wed, 18 Nov 2026 15:56:30 +0100
Message-ID: <20261118150443.759374754@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 921520475ff68..9e9d20343faab 100644
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



