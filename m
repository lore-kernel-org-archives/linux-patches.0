Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015395;
	b=NXxLHTatdrTzc+kcj4P0/y2O+LT6KEq+D7QYs7apCFlwRc6DuCzr/z2xV9GZFWYf8gV7
	 pH6EH+8m+Qk21Ge5BlvfBQ6f+HgyWIuC1OTQCTTqFAsw+BafEjI771SgcYDAtqjNHhl2D
	 XxZ5XcE6moBipw+fAf2l/+BfURnCE6tlP5z6E1ldFjpvKrxi4ZhARkQFCBkxMPe/9VGCP
	 9ebv3Ja1NVvB3Qpa1c1eCd6biVEISa0CicSAHpxZFuB9Ujz8uLlncX5V79iK4X1R8GqkO
	 HI+R6UCL14jDoY3nivsNEJRHuDWW9AfNRhCBDwu6ZMrGMSFmyUx+ptohfJoPoA0N3ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M0MTN3mBTG29P+HJ9ADYNBaP81ADcqYmDeAZqMxWaII=;
	b=0qYJRa0DwbzseAS0U8gJ6aREJ1Ojr5BVmA7Vd/lMEOpRGuIaaRbVruv+ocyhKcKR+Y7I
	 YdVaL8Td8jAuhfL6yn1ZIz5+9HOOj+m2SStiQz9Y7y/IMz1OWXY1w0JBpOgUcjiEyWmd8
	 WPH3W5/3yOhbQT0CtisIy/DXFxjBZDW2surrkYRMMTYL30Fx3JQyBcZvEm3K2kzg1SnWM
	 SFHgqo/d5HoGrUGvfFuTWTmqdgEAnU+agLHuprUxcjrRT3bOfyX4GbOzVa0EfeACSQ7bu
	 K7IW7AzGjZHJptBa61pwdp7PvGzNVqSX3jXU9ws5XeWg5lDoY8ssrJ2PoGrSU5cKNUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lz4ltD9k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687EA606A31C;
	Wed, 18 Nov 2026 15:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lz4ltD9k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87551F000C4;
	Wed, 18 Nov 2026 15:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015395;
	bh=M0MTN3mBTG29P+HJ9ADYNBaP81ADcqYmDeAZqMxWaII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lz4ltD9kZDISQbZNEjwwM0rwCKXeiMJowfsma2ZIX2goZ73wUVgz1gxCNqK7d+Ukr
	 wB0m8o7FSjvYejSUwShScSyX8XByu+qdZITJ/X2aIepsMutey9SI3B/dszyAEHnj6+
	 w9xf8d3jH4IPIZdnuA8SeZarFCVRFPqUdfBsof8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0156/2651] wifi: rtw88: debugfs: dont vzalloc(0) when rsvd_page is read unconfigured
Date: Wed, 18 Nov 2026 15:23:16 +0100
Message-ID: <20261118150253.469153779@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>

[ Upstream commit 81510c3d6f2199889a4a936d8cf8b9e05911b10e ]

Reading the rsvd_page debugfs entry before writing a page offset and
count to it calls vzalloc() with a size of zero, because
rsvd_page.page_num defaults to 0.  vmalloc warns about this:

  WARNING: mm/vmalloc.c:4019 at __vmalloc_node_range_noprof+0x9ac/0xa30
  ...
  Call Trace:
   __vmalloc_node_noprof+0x4c/0x70
   rtw_debugfs_get_rsvd_page+0x4c/0x110 [rtw88_core]
   seq_read_iter+0x132/0x4b0
   seq_read+0x12e/0x1c0
   full_proxy_read+0x6f/0xc0
   vfs_read+0xdd/0x490

rtw_fw_dump_fifo() would reject the zero size anyway, but only after
the allocation.  Check for a zero buffer size first and print a short
usage hint instead of allocating.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260827131244.35623-1-abdurrahmankaradag19@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index b67d69b01f879..84e45af26f525 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -315,6 +315,11 @@ static int rtw_debugfs_get_rsvd_page(struct seq_file *m, void *v)
 	int i;
 	int ret;
 
+	if (!buf_size) {
+		seq_puts(m, "usage: echo <page_offset> <page_num> > rsvd_page\n");
+		return 0;
+	}
+
 	buf = vzalloc(buf_size);
 	if (!buf)
 		return -ENOMEM;
-- 
2.53.0



