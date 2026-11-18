Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061498;
	b=zCvWPJN6LpvhtnjaWPbA9dbT70rmzx9BrfUmKIq8o4TuAQzST9m6+DZQAX+uWwbtnr3b
	 NW8FZT8Ht0jdFfWBAiBujtIzbRG06VYFVcA9M6795ahXEQpwPBhrQrJHqYZOGiKgGp5iv
	 6MtoW2dz1c2uWhY/+JkPPYos6ReFAAdHBsKAuuU872nJA9B1sRKCL3zqpJ8YGWuULdNhP
	 Et/5UM4W+Dm9rBvSP9qGvApt1hPTNz7xP95QaYqkkxgEWdDESx54CI6fFl31JroePcQv3
	 mo4AZxYsldyotoiHYTOMQprSdV2eLa6E+KAi2wmxM3CMm54PoL0qrlkh/oR4DcuXDxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4s9LGNXT2WRzQ1wTSBAFSKYwf5EquXqFQSHycZiT044=;
	b=YBJW4lkwCkVJGW0Pkxn3w3lLugE9AJoOkxmvfOUnOKaxyfRlg/0sMlf0dr29IYWFKvQI
	 Tgl9g9Sse9skziWBUUkZURo3s+4ZHbsddtbNHchmjCNfDijYSYZQdhLiGKtPdokYoHlb0
	 3KTOWjSEUYdgM9qoXzIHVg3rzUGdUQwYoZF2ohmroHAlEmqjAUA7w2XA4vp8f4jYBQPef
	 TzeFSnIf5jK/n01RRSMQ+wwJGGhKX+DvrFuAZg90xVoUmdYEoHFEEppzZb5g/p6TzpSdv
	 b1Koccg1TIrMfgPUea5FW/cwYwLjXcj1jL2D9AylMPVlgvxmrTQnYpcFxOeNzWBW1TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1h9gF1l5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F59606A326;
	Thu, 19 Nov 2026 04:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1h9gF1l5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961811F000C4;
	Thu, 19 Nov 2026 04:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061498;
	bh=4s9LGNXT2WRzQ1wTSBAFSKYwf5EquXqFQSHycZiT044=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1h9gF1l5HXtBVxMRxIu0YHE3jOxkkv5genIyvpuuULGdwx+sDZqLshDE+wRjzOFgV
	 tbZY2PajBupd5VFCFrQYFu02qTaHHCKBTuOohmvIPHpCku+F+4eEgELXlwix4trCqN
	 TL9ttck/tzMtm+zAsKLdWkro5H4JRifE0nt9BV50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1574/1848] platform/olpc: Reserve space for a string terminator
Date: Wed, 18 Nov 2026 16:00:12 +0100
Message-ID: <20261118150025.489448776@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 89d9fca02fe9d..84fa64fdb90da 100644
--- a/drivers/platform/olpc/olpc-ec.c
+++ b/drivers/platform/olpc/olpc-ec.c
@@ -270,7 +270,7 @@ static ssize_t ec_dbgfs_cmd_write(struct file *file, const char __user *buf,
 
 	mutex_lock(&ec_dbgfs_lock);
 
-	size = simple_write_to_buffer(cmdbuf, sizeof(cmdbuf), ppos, buf, size);
+	size = simple_write_to_buffer(cmdbuf, sizeof(cmdbuf) - 1, ppos, buf, size);
 
 	m = sscanf(cmdbuf, "%x:%u %x %x %x %x %x", &ec_cmd_int[0],
 			&ec_dbgfs_resp_bytes, &ec_cmd_int[1], &ec_cmd_int[2],
-- 
2.53.0



