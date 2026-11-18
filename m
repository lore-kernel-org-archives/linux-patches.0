Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059011;
	b=BvR2xN+IA7t+yA72NYePa7sIKQNxykYFDuclsbhuH48B74Nx4a4R3amPKxxFYGlk2Zap
	 le3NotmKPUJGUyAFVcKvecemg+1tem5JnSP+YuFcqWjPtmnix/Ax40Y+8c65Qibz2ZGXd
	 ITxNzRgHl6XuULVcPn2CL/N3wTVzedLzBXnEA9uc5joIim+XQ6JSsGmvgMQhaeJYwPRTC
	 JCFnG+nDlxolnBKAUVzFPzVZ6gMBAVymfX6WdM6nAQ4+fN73T0SOlZyt0KJl15uXUu+H+
	 BfMNJ/g/wTIXbxkngiC92oBIl4jLZUPftU8/V44Ny2ZFrqpRnVLNoOZIcVZXr7w1M3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059011;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qTjHFhV+mlEOp+IwPrhLITXoC7mnTssA5SFjY2iYoH0=;
	b=sq8qcjpT7YDt2P8adP2YlFyPogGNh+a51JcU8RaQqnFLjooLh/aJVko+IZQMb6Le6jS2
	 m3Syeo5XziiPfzB4+hiZ3ZZqEq6CSu/ob+I4FTK480etTJS7zzs9fvTjJ8JzmOhgdYaO0
	 2YOie3y3CBiVO0nU4GP2TZ6wILpG8BITC24AlLyP1K/F1s8dGZ+ppiy44Xq9jkw53T8Fd
	 IfSHmGcIUpzwuSQrnb9RI7SmXe+SS3DSg5k+5njy3ttyZ73WEISJYieu0ZBWVTKP9CK3A
	 LXEHdXbTORz0Jvy7ddWK+3zdjnVAriSnDAlOXi7Pqw81tn3QRtEgWmoCiUE0xCi3rgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CMJ0MdJl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC23606A31C;
	Thu, 19 Nov 2026 03:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CMJ0MdJl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2D51F000C9;
	Thu, 19 Nov 2026 03:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059011;
	bh=qTjHFhV+mlEOp+IwPrhLITXoC7mnTssA5SFjY2iYoH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CMJ0MdJlLeDS5+YUVqAAMghnOsBYQOsemXvIBuBCR/35H0xZPxG4BRC7uWrOD0Q9Z
	 g/5o8o0egdzd2dUd30GhC4uDP4HdS7ocC12S5lnjhmO7R7ARiyU0kFGJb3dBS6MQmt
	 Df8/BqaUaOJeqWHuckXjq4FqP7wbT1DohWWP4ed0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0690/1848] ALSA: us122l: Add missing NULL check in usb_stream_hwdep_mmap()
Date: Wed, 18 Nov 2026 15:45:28 +0100
Message-ID: <20261118145944.816191732@linuxfoundation.org>
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
index af92ebaf6e998..0b86dfd5abf9e 100644
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



