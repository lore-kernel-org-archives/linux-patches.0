Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019713;
	b=1hsm7MNnxiU1KvOhgHa4MQcFp0zwamWMpWTnp55t062atC56CvUq+NFJdBT04EXUwTCx
	 oVPRFhcyibymYoP8BwJGeLRGBO657EpeFDPfGk32lbhlZgxYH2u0ByoxA1jI8kYtYP0Xb
	 FQcWNg1675MQ2QM35yqsgnUfrD1JOBpdZmlYTYNNglkJZHHm7cK/ZeUH6MbckfoI07/ZI
	 XwFE4i1WGryJtbX9u/UH3L4UP6Q3CcLMPvzHPPjzs7xKpkYmo5ZRU9CyXqDS/nflmscN3
	 J6XKhX/7ejCAjDZ3uNVzaWT+MAm/j7Bm2mY0x9DVDUqHlF6x7aAa/ggZmFiy7pPqH+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=G2SaykwXXyA0XakcCSWyP6nvWPV3pKfDF+OHr0H9ngc=;
	b=nNYrHKlQiGggHvroF0q/bX9wFGzL2UetHdmzm0cuTAEZIWPvdGcCXKMxFgcJoX7Hc0jo
	 yTe6WRtYJnrrT9pmOEEFUg0EGJgN8GfHC9g8O3VvMyY1SOztIhLaaFGINJyMSTBf6BvkE
	 HFIUZ3pafrKnQAVq4PRiz4/srsWn2mWeC1P0S5ql7XiRyD3GBtODyC6ct1eazsBsDA76j
	 cXeRMSV4gvGffuf5L/oJKC8PMhXFM9YniuWmyZA0QXu5bBkDdzwIUUOeO6Sz8VvBEgujI
	 CUwQ8wIhnJVUByjG9vLubcVIwyh87T71Ey3Wglk2KNYoUTV/qrD58h3MoLglH81oTnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=coEuKfFy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD32606A325;
	Wed, 18 Nov 2026 16:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=coEuKfFy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81E01F000C4;
	Wed, 18 Nov 2026 16:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019713;
	bh=G2SaykwXXyA0XakcCSWyP6nvWPV3pKfDF+OHr0H9ngc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=coEuKfFy9L2lQD10Ul3GyrLAGmmQWWnPUmwYhuecKBJNhi5nNZmMZAJcfIh/vGTNx
	 lvdHkpXSXxy1A4/+9+ov2bZaokMSDonvOHuzfHg0vq3UaEFQFMVXofBmUIV4lFG4Fs
	 Obvou6D6OXSzV8RO8VgchhxNILHN8foiB7NU6auk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1693/2651] platform/olpc: Reserve space for a string terminator
Date: Wed, 18 Nov 2026 15:48:53 +0100
Message-ID: <20261118150348.618974145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 4a2d36f7331ea..063f7e55c421e 100644
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



