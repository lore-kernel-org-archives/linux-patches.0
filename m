Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591049;
	b=XrCxFxG0p06zOz4uMs6vEGI/D4q2dqgjftkaxknUpASFrjalKAOD0HZQEvdDq4KH8KLc
	 7wpp3USu1UgtoRw4ldElCMWfH337sxfwQ4Sf2BJ/bzzrKMgjhvoW9bcneEtdIcxqg3hmg
	 GBMMExIIGA/maYplj80osCqlcYqRcSJmrPMoI4K+lhcNuWNBkLVMZI36dy9NLnfpiL/SN
	 dUKNPJF1fVMzamDBn0gl375pmcXMfH2CAaR7EBrIlNqIri7MnQNHatiLRChfBXxfgex5l
	 AeIYAtdanCd3ne8sF3J44A2PoPxnh/Z8BSdYJ9UFKbho2LISSE/rqImEagZgaH/L+RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2JSXHNsho6Y8bC6qc7n4Cbhmz+qW1ucVvXBS0hOWa/8=;
	b=c7AksjxeHFfHWU89UM8hClm93/QRs2PrC3SWtu3csW7KohqTWe7I0Z0ME7c6K3e7F9iw
	 smRFHWOq/DF+CEVdo7oVEB+9ZYR5Nzjwh6l48N53QJJlU/d6I8XnOoHE5cTcd3sHeU2qQ
	 JtHpyZ7/KSui+talW2cHSQOJwJfkmrht0uw+oieOItEmedcwwxXqDqkBK7BRdIO80Ruwu
	 9gjAoF5oiTdNdyVsYmDIBX3ntZCsIKNh+EGpNQ1w+h0UwAciG0LJgaxkY/7a9rwkgK6zT
	 yZSO5rE/N9jgT671chAq/6NcdsG6pT+lAhVE0KEtSGWs2qQgnaXawfuzgl00zd2M3jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dNGfDyoO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CBF606B357;
	Fri, 13 Nov 2026 17:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dNGfDyoO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036BF1F000C4;
	Fri, 13 Nov 2026 17:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591049;
	bh=2JSXHNsho6Y8bC6qc7n4Cbhmz+qW1ucVvXBS0hOWa/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNGfDyoO6PBV8200Duxm4Kb6xqh4MsTzVbuRQXBWS6uJ87Db/YmoK4bpVJqNWEhaU
	 OK5fUdVggVWvUYZO28EMMTYkw71ZUwlA+fL5enQH3mFAyxKDUURZ1yhiULfRnB1UNN
	 mFBZLnKDVa4uehJGg6q62aXdYQYUO+t0ZjQG8jRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 212/670] ALSA: us122l: Add missing NULL check in usb_stream_hwdep_mmap()
Date: Fri, 13 Nov 2026 10:46:16 -0500
Message-ID: <20261113153819.109596172@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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



