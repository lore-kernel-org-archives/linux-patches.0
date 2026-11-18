Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046251;
	b=5GUUsRlF8gHSLg3mp2eeVLPrkFP7lGSJ2CVrCU4U3/Ali7StXGGZnB75Yq/93ZLf14HM
	 qneAEUD85+11UzCNWRdDIleCyMk1htgUattCePZn94AF2C08h0HuE2i+8y1DAcOzHNfti
	 Zl2IIpyNq3MWrSZwnocatQWnEFGcXGAXjKLLNm2nntFOP+9oD+5tq5AvB2rZpoLSYzNG6
	 mGo6sJ2ZfOLGTJb0KB+kwr9VQOYI9RchN7OpfBlujHVMyANj/SFrOjCoKVETPI4WXJ4S5
	 6tWzUG6s6EdvxpvrsLSiL8RBy2muw/df8LfVMdB8xiwFRU31GubvnljEdh0XKuNUfFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nx2NVAwQ1mXx1HkJ2Sr8IiLL41XBk8oGhysgU6JqZIQ=;
	b=1xFVWIap45XgjRel14tcxgWYhvv0+y7cTXcuUB5Ef54kEYeisTrb+ufy39D5PTRHK9Db
	 RXse7oY7zH91QOkaVp9WErh2xiMC2Rg+h2z8WsyKRJaOYDWvuOA1VtK1XDdu6CS3QkqHa
	 I6JeSGqSLCNL+oE63b7TzzB7pwYNRzM6/pGvWXvuqLAsNMQHrfKRwBb+ohlF7iK1XiGsp
	 Ao8IQPfkBIpVlHGT1N2IPckCLfacE6pEsCrSg+DVKpn5N1+/EMuEnnT971s1dxuDjTN2V
	 JxP3zZ7EmR2DZ3cBXIuLFjrFmz+GPUQiRVYvBZ1vvp5Mc5qyvsGbN20VuO+ef0gaJBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a+Gcl9II;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46158606A325;
	Wed, 18 Nov 2026 23:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a+Gcl9II
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939741F000C9;
	Wed, 18 Nov 2026 23:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046251;
	bh=Nx2NVAwQ1mXx1HkJ2Sr8IiLL41XBk8oGhysgU6JqZIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a+Gcl9IIj4FgKsbe0IY5NqIkljKENFZGBX19mDdRrZ4jPoIw5J3eXKeTPaBCHJi0h
	 lw8kEgaSsQjQ3GpXX2jeapt5Q0ZhNREuwSKjKPE9tf034GXNV1cdfAusP+1mRKlnX0
	 v5LIMIl6l/P/BqGicw40k0VGzj46T5J24LtaummU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1215/2857] ALSA: us122l: Add missing NULL check in usb_stream_hwdep_mmap()
Date: Wed, 18 Nov 2026 15:37:29 +0100
Message-ID: <20261118150245.329840799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



