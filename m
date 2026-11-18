Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054720;
	b=eKbOkkfUD7Lw8Jdb3nsdmCCZ5XP5TGRjJfFG9c5FwHIrTBmlceezjpnR3yJRv6N8Ya2C
	 wJIGNVKnfN4hXvZKb3vLqaB0Pd9Wz7QDTPUL1TikFRgQdYJsRwykiKEbMytrqFtbWfjFX
	 A3r0mHVRF4Fo2o9oEITWq/6Er8bNh5YnrXeAztggL8vJJEFiI+40/9viUeqPk1PMNl8hy
	 y5hIoYMCn/j4/z1A8RJy56Ogjmda7VMmEeu9TQqz/TsziBxo1/FLh7B+vmZLFE4cdXsWc
	 WI1UUnoRCi6LnKYJ8STvz4/GBV5I8mn1d1VzfHW4SBKUdB/eCBWeAWGR+/MZvJUAx+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YKW9qZ4PS5guMK8GQq42fdOeRIPMliXuvPyAPn5naNg=;
	b=DpczEyHw4NUSCrOlH4iMqshBbI2HNfzbe11Cv9Hl+8Wo+OvDC/GcVhi9Blww2HMhZbLP
	 pgdSkwXigLk9ru+hf7Qyde9TeACIiPUSFxsoM9MzHfKJcIKksJebpU6OznsydoVvXrAAW
	 0h3XLFWFCXkv++UiD8KqysemCP2LDikGAxVuryFa5J/8cmyo7BvOKaHGI/ZQbkFJk3Xlr
	 /YGe+uvKi3ki8lbQfxQKuamnwd2zVtfOPvJiF39ykdrXO9xj+ZTZJlvkUXbZgaMfmHcoP
	 eNuE6RlfCDhEkPkEK2B8HYooasv4oG1iDzAmMAgaV2zEQr6AL+kklWyxASrixZMPkiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lubg2dc/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FE3606A320;
	Thu, 19 Nov 2026 02:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lubg2dc/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA1A1F000C5;
	Thu, 19 Nov 2026 02:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054720;
	bh=YKW9qZ4PS5guMK8GQq42fdOeRIPMliXuvPyAPn5naNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lubg2dc/2TosJF5ITlDkkUP+PkcHgZC/AnbIrfifavt06b9enYIDS10zxQzEkIi7Q
	 F+m6PVuvC/xUTFwc7yJgnlzvt3Ikpx1ZUL+GWNyFCT8oP4kSXQjY1PNcvJZQ3iFQrj
	 uWKPGeR4b4Z89wOwXRrgkS9dSnj6xsm2wpOxnZdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1373/2214] wifi: rtw88: debugfs: dont vzalloc(0) when rsvd_page is read unconfigured
Date: Wed, 18 Nov 2026 15:50:49 +0100
Message-ID: <20261118150106.334231526@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1cc2b7b948044..99a8091fc0dea 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -237,6 +237,11 @@ static int rtw_debugfs_get_rsvd_page(struct seq_file *m, void *v)
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



