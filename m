Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029013;
	b=gqVmWtEa3MsXoTi0EvDc927u+mpF0mDJDV8EGIsQaqWvBc/4adnFu6XX6lw5w3u0cbRA
	 nxjgjmTTx+RY5u7aVzsB6pItu/Sic+CoUknE3hG+puuX8nK0SxJL0skGttKa0tyq+IkjI
	 x6ntoTDVgKpXY24gGeS26dsu51f3VkxyrjMsvDw72euUP2mksm7mFIeg1eHO1bT7WmV8Y
	 NXGZO85EdFI7Wz95RV8f3rRQZJmvdD9AKuT60mi+dvEvILRahlH7qpKDoYukted6NcT3Q
	 cx3I1gBtEOSMKZa78fDuXCZRivuJz8B0lB7Rcxg3uzU62yTOMsqcs1lj5L+cfzVbe3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZMkIwF5iwutQfBDIBq367OXXhQeUG+zQy1Bso04sz18=;
	b=X6PF1Hpvgqor9+zwY7miFID8AxJLVz6e6BaZmOYfWwtPpgHbVoA05DZyMaxeKErV3En3
	 2sRNUTEHxfIQ1zcs8M8/BmvHWnxyKwte6nR1hIxR0yhRPx2XYvIKBo2bBbhSit+7IZW5w
	 u/lyae/rd0SjHAAYWaKI/YxwknKIVYvjYcON3jVi2d6B8739UI6TZfGJ9ITqRJCWcw1PW
	 ru1m8N9GinM52Ikxc0SyUNePW9SnHnP/7GnnG8+T+3W0jMHGBWKmOe8Oc/uIUdnh9ez9E
	 E2+WsQvDjXMtTZ2c+g7yKJttVVNwPT7zSBRUKegzWFuee/m8dqdxpWQTZw2o2UsAw2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HuDB8M9m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDE0606A325;
	Wed, 18 Nov 2026 19:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HuDB8M9m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72271F000C6;
	Wed, 18 Nov 2026 19:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029013;
	bh=ZMkIwF5iwutQfBDIBq367OXXhQeUG+zQy1Bso04sz18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HuDB8M9mRvrdCh+cV9uLF+C26C0Pwu+MjOxgWAUyT4xMsacGjsRHocgIAeRo50ST4
	 KWZnXANdsuwHnoekPrWlTkCzZnAgdMhrLEjIhoXoFl5rqgLzjfFncbpWpnOl7uwt0+
	 W5IwL7YoK1NaNf8CiRw8tjNnqaDcZXwyb0fzUQrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0198/1756] wifi: rtw88: debugfs: dont vzalloc(0) when rsvd_page is read unconfigured
Date: Wed, 18 Nov 2026 15:38:45 +0100
Message-ID: <20261118150016.266189115@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index c26a6905fd15a..ca38bc12dce26 100644
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



