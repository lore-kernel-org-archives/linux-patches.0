Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060435;
	b=CJLy0/lfXVc3fJRGmeyVcEmU3bvm+C8Rho1cf6tfZdgCmKeMg9MbW0qKC6XurrUr0SdI
	 9SQDnl/wucHU3jGW/vt904PB1rIsCfESWVZkdr7UqtQ3BVIvzMzlXeS0qmi6wk5B1VnDd
	 IbAVZXIUl1z5MNSOJ68yftZH4ISEcICSQMHB11MzOal9SxAH81W0ca/tsODFQrDeIfvYm
	 GIkaZaJdrTJjgpZImHh68fsENufdqz73L/Za/Odipk3q29j+/W8EL+K8k643Abu9949CZ
	 agN5RdICjUugdEqZIcYzPDvuyj0I06EbcrjTKU+XU8CXll6BiHOJIGZDEAUi6qOuBVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HPRXKeaz1ajHqSLF0Iopk5EDMtWdABYJKkU/11xQrBw=;
	b=DclOOXwCwL0YY+y4vHGjS8VZqhfIsD3fXAxvteV44ZTS8BPxHmjxGWzcUfICIbKhMtpP
	 z0WoMOCpQ4gFO6jXynyGuPbZGqFf6/hVb/WQtLSes+9c4p3e+LVpTTh/4FKqtqS1B7Eay
	 n4qMITZ6CgGipdzLW1pDLHFW9EWXADdDsDPbmM59hV2KT+RUU6l2ilYDrThe8A8yJF++q
	 im69EdaXHrolIhLVEjaVk/fUZL7Q/YWEmlWL7/0I9DEVgt45el2Lt4gFT/51wetZj25AU
	 Ui7WV3OjEnP2MaaBb9uMhEtgoJShOA4VjjHxzcv5kkvSQnptSrG9iyqr945PGBEojqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bpuRDyuN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AA1606A320;
	Thu, 19 Nov 2026 03:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bpuRDyuN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CD91F000C5;
	Thu, 19 Nov 2026 03:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060435;
	bh=HPRXKeaz1ajHqSLF0Iopk5EDMtWdABYJKkU/11xQrBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bpuRDyuN7k1WFXEL96zVEIogzMU2NErFd2QZUzkAECfocSn5hTTdk2xB4v9XIGO5S
	 WUzidUZpN4xYBc4wSBr+a9lzQEUWnrd18fgNinD6A39rrVfAgOEdPsIgwFlwavjr5r
	 ywOCX3bVNVzO4rndvGxjUJyF+n4GR3sBXVA8w7zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1157/1848] wifi: rtw88: debugfs: dont vzalloc(0) when rsvd_page is read unconfigured
Date: Wed, 18 Nov 2026 15:53:15 +0100
Message-ID: <20261118150008.155334679@linuxfoundation.org>
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
index 83413cda9bc5e..97b9984438d6f 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -227,6 +227,11 @@ static int rtw_debugfs_get_rsvd_page(struct seq_file *m, void *v)
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



