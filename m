Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053254;
	b=igFIgZJoh45CyP/dTZIVdaiedw/O4JmtLqNtrFyC/fFeM4wQz1X6Zzaq37CBSdVz3hqj
	 nkHUyDDX1S6w5urZrClGf2hX/nUqrDuTCpBqiiIYodq0CTtRv3c062pIHbjDT1uSxppTW
	 iAajGiFtFIxrJ4PM2cxvPXLYW2IhPoK+acJXp4NXWWw3QHhcNSSk5jRk2cSR9MzW7zmdE
	 ijiQJ8M+4qdMu5D80XrCgRRR/ZHdAb9NbkK0QV7N7LkRlS5lriA9IYigS11GLgCKO0zf5
	 e8sfHUZr15HT84vt3YezPS5I5iXjWDCyH9HLFfmjFNcVSd585e/LyPZbp9J3R1NCkuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053254;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1l61uqLM5lAKt/jEN7Y3+tL4BtHlppJPV7EVmhEzOmk=;
	b=HA2vpPmbQQL9k1LDNkMyAO0IxXiTVmUIzLkW4MXYwgKR01P2x2lXRmO2YPvcBjShkJA+
	 MMK/5XErXoxibkpn9rWrVdZsDLIhtJ4AV7sdjf55+V6uRgmAgZ8BYcAy8a58h59VLr5OT
	 lsNCtfNU+U4knSSg4pYuDPKmqt2p+f2UtpQuCAuCqYgv/RNdtN8IbhwYcs8LQ4kXNj2IN
	 KYKtGCgfU0nFxOrg6Qr7dTy/vLqFJHhpXrH00ObWOiFXzNpWism/VoKZFu3yq7ua+uURf
	 PaHAOwyYvL6ta68G8yAAGdGJnxoCdkHgvp8WXrKSwgPsfqJbfICuQVF986JaWQ+Yr3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hpsz9ZVM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D16606A31C;
	Thu, 19 Nov 2026 01:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hpsz9ZVM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFC71F000C4;
	Thu, 19 Nov 2026 01:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053254;
	bh=1l61uqLM5lAKt/jEN7Y3+tL4BtHlppJPV7EVmhEzOmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hpsz9ZVM6iBYks9g17+M8bM5mcAr9Odlgc8sd0pLqy3OY+UfKprqYSb3YmEM/Z8O/
	 xNCrSzt8bAXfqtKjZKiAHWsSrQlndlxC0xBRsXPjegImqOSOhpNOiOMy4KS2pDuXw+
	 ikSZKbCoRBIGhwtJuYFYSUDMniVHUijp8XTe2+ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0855/2214] ALSA: us122l: Add missing NULL check in usb_stream_hwdep_mmap()
Date: Wed, 18 Nov 2026 15:42:11 +0100
Message-ID: <20261118150046.375887703@linuxfoundation.org>
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

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

[ Upstream commit f5d3eb483fed59fc0f3b059b8b6a32cedc922360 ]

usb_stream_hwdep_mmap() reads us122l->sk.s and dereferences it without
checking for NULL.  The stream object is released by usb_stream_free(),
which is reached through us122l_stop() both when the device is
disconnected and when us122l_start() fails, and it leaves us122l->sk.s
set to NULL.  The hwdep file stays usable after that, so a later mmap()

	KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
	RIP: 0010:usb_stream_hwdep_mmap+0x107/0x890 sound/usb/usx2y/us122l.c:182

crashes while reading s->read_size, which sits at offset 0x10.

That NULL is an expected state for this field: usb_stream_hwdep_vm_fault(),
usb_stream_hwdep_poll(), usb_stream_hwdep_ioctl(), usb_stream_stop() and
usb_stream_free() all test it before use.  Only the mmap callback misses
the check, so let it return -ENODEV, matching what the other hwdep mapping
in usx2yhwdeppcm.c does when its shared buffer has not been allocated.

Fixes: 030a07e441296c372f946cd4065b5d831d8dc40c ("ALSA: Add USB US122L driver")
Cc: stable@vger.kernel.org
Co-developed-by: Bin Yu <byu@xidian.edu.cn>
Signed-off-by: Bin Yu <byu@xidian.edu.cn>
Co-developed-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Link: https://patch.msgid.link/20261028042525.8737-1-25031212351@stu.xidian.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/us122l.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index 21c5a7fcea768..1e90c183761d7 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -208,6 +208,8 @@ static int usb_stream_hwdep_mmap(struct snd_hwdep *hw,
 	offset = area->vm_pgoff << PAGE_SHIFT;
 	mutex_lock(&us122l->mutex);
 	s = us122l->sk.s;
+	if (!s)
+		return -ENODEV;
 	read = offset < s->read_size;
 	if (read) {
 		if (area->vm_flags & VM_WRITE) {
-- 
2.53.0



