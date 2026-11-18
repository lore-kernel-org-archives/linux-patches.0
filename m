Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039258;
	b=Ee9NXMpRnnEJs2yA3tX+6TDo/XBIyu7BoMbdgLvT1Bj9u2edb26bLWftH84oWu/6Mi/O
	 ZjLIbIUPBKaFpWOBcGz09h2kSMSY067UwxOpy36Ka618MJGADnsjZsKuJ1feRWw8BccD1
	 im0548GvXhs8aN07JmWSeOzGR7aF6EdC5EZcapO1NXX2sq6PaLtUsTHKmy1B4TpYYm3l2
	 vaPdUqiDXqnNO9Xt0lvYIPsbYDimvfNAstGnD+N0VwQm3YMcbqJLSfFzs1dAelc+OCK5G
	 Zyo4uF+DN7R3nO1b8Umum7tFRgad0GZEHVGLz6Z/Wk9RqjSwEYhazMrjG2EEPt/Vjgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8EnYPVYeTR0TmOqoR4i7PmGODuPZ2g+AFn1O0q+9fzc=;
	b=lTJnyFA59z542I5RTbxtqk3u3CmpJJjZHWRIrWwLCvAHZYM15M7YSVcLIe/OHOjDC9wD
	 nUGucjURg0WgEHV6TQLXZOOyowzmEpH7+j4P2PxzRjMMgnFWhC6OBGvZOh4F2lKhj1ziS
	 mnGw1fGDE8O8EH43jy17e+/IXQ4yqwpCryElbKyKrqrmQikZEth9I/dUmrXukgQuLyNZm
	 E1LyTBXTZvMKi7+4XaodFTirR43BqxWGybSXh4fFUWwxg4scIa6heIAJQ2goToUG/b7O7
	 /kXR1OJki03Lv09FNl7iKwdEQIR5TE7vEAoxfiZO/J59Su3YODR84G5bwmMO4saCQdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wv1hILc4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AC5606A31C;
	Wed, 18 Nov 2026 22:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wv1hILc4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8F11F000C4;
	Wed, 18 Nov 2026 22:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039258;
	bh=8EnYPVYeTR0TmOqoR4i7PmGODuPZ2g+AFn1O0q+9fzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wv1hILc4VprIm2hFH3JjK0v8z6s9/W75GZ/20SxzM/jHw4axMTHm6vF2i0fTjo/92
	 13fhlB1m57b33uPsHO1cv+PbXx2ib74Zex6vznSavEWkMYhswovPeB21g5c17AD6BA
	 Rnukvjm6H5lKFYWFtiHV2hh5/2421ok6b+5ljJk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2035/3318] wifi: rtw88: debugfs: dont vzalloc(0) when rsvd_page is read unconfigured
Date: Wed, 18 Nov 2026 15:44:17 +0100
Message-ID: <20261118150423.093826277@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 83376a6c9abb1..28597eca574e3 100644
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



