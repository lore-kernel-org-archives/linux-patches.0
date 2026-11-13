Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585445;
	b=FOiwQsw3Z0X6QCDWzBqLZd4+MAyJN+22dYkf9xA/h/CLvMemL7se+yerK7vcc9xeFfxY
	 5UbGLJTkb2LV/G/XR4iP28rJHvHGpKOEiGUMLJ4Ux8Y9ix3nBp8yzuV7UEJEsp4lWh4Ep
	 jVuskiwihEBWsrx7iJaazjsrZ0HWJeAx8PFAP9nYMXXRQd5ppUpgX9iBrNSTUjSQ+7G7s
	 qYwcl633vR7ng7bU6UxNlR8Y0W6ibBpDpa77uttutPCpUvGwIxqM+YbYlEnGuhNLxosoh
	 0tNt295dDj5jOgdxGnmrvaWC0+QKDiYPp+nBDcWhxhqwH1n9KeWFI4toNm259ikVvcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wCmW33gzzCYddPHpAzsmr1emH57ZGV2C6+nQJrJNwUY=;
	b=ULKMpw3PyNbCfY7mT5cvKvBc0aNq+VGDjho8wgHbiHmDk256xBPGnw2kmHIHwrHhFAVT
	 p2+DznueA9qPu2Psjt9H1wDnRFZKfNHoz9PTJXvPBjYSOMktAUGmAzuJrmBRlnQpiLfve
	 Q10/sNxFHKdVhsF/dgdSWBGFXgZ3cxozdmoKa8Wfv2xF5VL64sSUlqLNonXXj7cwORY+1
	 IORl162my9739Dw0vynnFYU9lpcaPwGVgE0CpgJx+zwRYqzEh9VSPTVTkVVCDA1oxWeOH
	 +TlrDTG/+hv542aol32Rgv14i+H208E7XIRYkbi8uR6mzLFPSJ4JFCMy256fUyGUddQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sWF7PH2J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C6F606A8B5;
	Fri, 13 Nov 2026 15:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sWF7PH2J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AAB1F000C5;
	Fri, 13 Nov 2026 15:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585445;
	bh=wCmW33gzzCYddPHpAzsmr1emH57ZGV2C6+nQJrJNwUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sWF7PH2JluOihSc4RKe7IWvOuTsrtD0WjZwCWcE6BX1ZF8Xa85Cv1ey8FPOjEbaJ7
	 mRN+L3WUfFHfeV5h+B3062qSndNhVropQofkeIgRpd5Xlu0m0oC+9lnyn8sqc52gkQ
	 WttXMQVv3AAY89HPyC/+Yt1bK9CknDzFdA6NzbwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 106/507] ALSA: us122l: Add missing NULL check in usb_stream_hwdep_mmap()
Date: Fri, 13 Nov 2026 10:46:50 -0500
Message-ID: <20261113153757.919080856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index a5db0d044ef96..27b6b0bd57681 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -179,6 +179,8 @@ static int usb_stream_hwdep_mmap(struct snd_hwdep *hw,
 	offset = area->vm_pgoff << PAGE_SHIFT;
 	guard(mutex)(&us122l->mutex);
 	s = us122l->sk.s;
+	if (!s)
+		return -ENODEV;
 	read = offset < s->read_size;
 	if (read) {
 		if (area->vm_flags & VM_WRITE)
-- 
2.53.0



