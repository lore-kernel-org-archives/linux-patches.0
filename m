Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037652;
	b=fdYy4hwvgJBsGarAJi0W9sBMguy/hnhC8ry+whRv+ENmKPHZcsXzfcci4ET/WmI4lTcb
	 m0dR90Isp5IlOYkdglTfz+cWD1MThw84Y5f4nzYPl8StrKyeOX2BCOip14MnOBIchG4yb
	 cjrli6xUN3rof7AN5KZtyC4h3DQ6KBSassjuL95e/v55Bx6Tlr6DSa1EIFQ0AkDPFL1D0
	 PxqTh3UvfUBUxfDHIHHMe163Zy6rXVARKp4fg9gwKiyooBX2DJuItkfqs8kt9fIeFte78
	 JcZ4Ne5g7hpqYqG6/VSOJG8dbATmLbs638sqtDaEzvBplLAMcWQFhVWz17hdXWxQvzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6u+eFrErLq+NVG+gDCy7Z17lNpZyaANVVLNnmAP2kXM=;
	b=Io+C6X0jUVndwmqRlGzPjzeFqnI4ZEiBj9uc+292KD+YadUWrIWtCDtcSgbJz4Tor/1s
	 1RTLNbyW9WKPMY+TJYudGR6i5hzWF8n/8Sz2BHeJ735uNVdtSbQ+HPISkui/DDy3aJDDv
	 Awr2/X8IYbX0dd/aDUaM+n6qXZF84V7xt6HKiEwkC/ybrbcWeFbzVAf7fRZ9ms6h8hN85
	 L0gz5K6ShaD4/c03IV610QUD1hwDZIPRYYkY1Q7MOp89XRYC4Wouymjm97PWQQgM2IYP+
	 TpNymnV6Z6APZ1GyxOv4A9cyDdGYDkAx4O9o0EeoHx+7l1gFSGKbdOZZIsnythqVXSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0hhGQ0q+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D62606A325;
	Wed, 18 Nov 2026 21:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0hhGQ0q+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740311F000C6;
	Wed, 18 Nov 2026 21:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037652;
	bh=6u+eFrErLq+NVG+gDCy7Z17lNpZyaANVVLNnmAP2kXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hhGQ0q+hhBSQdWEaB09o+QraYF7XO3yW41itY92ibVworp6QOS+BH+TPCe7lNvIs
	 qQaxielcqwQ1m5MECCWGcFUmUvLlLLjoGxG6FIMa6Xnw56Hgi6zF6ngfmMWM4PLHie
	 8z2g/Bi6JMRYfea5CXivPCrsH0p7OZicJTL8rHuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1430/3318] ALSA: us122l: Add missing NULL check in usb_stream_hwdep_mmap()
Date: Wed, 18 Nov 2026 15:34:12 +0100
Message-ID: <20261118150403.665981033@linuxfoundation.org>
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
index 2a107803af880..1458dd16711fe 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -200,6 +200,8 @@ static int usb_stream_hwdep_mmap(struct snd_hwdep *hw,
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



