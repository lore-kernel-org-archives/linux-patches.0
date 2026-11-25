Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623166;
	b=XQyye8auI+L43qlIJ9XA5ZM16tJw5J/WN6mbu4GRSzW5tUi6vNZzRWmUz8eodaxoo2me
	 nY+s+UGOsWCdwilPYTmlMtZ9ii3IuP2r+laJWXcvfjmabrbseod3e/eDNykSejtc6HXR5
	 OT5p6g/hoXFN2hmTf2+e0ruf4HC1GdRZjQtndI3pkfID6ZU200igMHZ6Dwh1aar/MAv7p
	 5JalneKcL7Us+zvmlBlSXVcynSLOhGIeefiTYIkeK1IMNqWvZXjj1ILxIr0wV/0JgL6K3
	 eMeD9MK+ATJqlRwwypIGHcZPfCfAzeqJFhCb72rFGKKv3wUMEAldTDwFsHhiBiKj7mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HYH/bSlO9JCFdcbm3UyecwHFK3TW+OmEkINOTMb4vFk=;
	b=uH9gUI2IJPOlLVZ1ewr03GT0nmPGYNTwx6fw632HWm/Ce6xzKw/tVF2jPsfBDhUBfBrh
	 YW+wTyz9Khf5NIQGtN9IiyMalCGzrIGT7PBvkR/T+pL7JcfjDNBD7MjqV00h3gaM0qwpW
	 uRsk84rtLdS3pMXhp96+ijh43RTUcBmVU1Ub/0Y8ke+U+0D+9f44pXOJ8C44zVFwKe2By
	 iPVWUBnFTb9J6fpEE3V1je0inWREp7nlspIVa8ddN1UjkF9luwMx+KTw5U2jWbdtpyIcE
	 Vx2j+QKipUFmKlifjv7KVI/WwX373HcPWxyZQN/fEG3FDKED1zXmGHyDk1FTb8t8FWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ReHJt6FH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E102D606A680;
	Wed, 25 Nov 2026 16:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ReHJt6FH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23961F000C0;
	Wed, 25 Nov 2026 16:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623165;
	bh=HYH/bSlO9JCFdcbm3UyecwHFK3TW+OmEkINOTMb4vFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ReHJt6FHFze0WF119V8BPMMJogGAse67C8eYR1xL4lc0I9Or5gsikrDlt1KVyoXmD
	 T3VGFrX+ggHg6HtIl1HyTYSmFltzttlxDOJmX5GjmeHcP2KuER8bqDlsgnA6yb3LLS
	 5rUS70++HTMz4spSV0GlgeQKdNS6sSFELY6uLoZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengyu Liang <hengyul@cs.unc.edu>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.18 771/990] x86/video: Preserve the default VGA fallback for legacy modes
Date: Wed, 25 Nov 2026 15:35:38 +0100
Message-ID: <20261125143840.114831085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hengyu Liang <hengyul@cs.unc.edu>

commit 3b4c98b47ba7c3c57bcf54fb85f54a854622041c upstream.

Commit

  596b3678326d ("x86/video: Only fall back to vga_default_device() without screen info")

made video_is_primary_device() rely exclusively on screen_info resources
whenever any are available.

However, screen_info_resources() also returns legacy I/O and memory ranges for
VGA text modes. These ranges are not PCI BARs, so pci_find_resource() does not
find them and the default VGA fallback is skipped. As a result, no device is
primary in VGA text mode.

On a SeaBIOS QEMU guest with bochs and VKMS, the boot VGA (bochs) loses its
DRM boot_display attribute. VKMS registers fb0 and bochs registers fb1. VKMS
is not a PCI device, so it is not primary either. With no primary device,
fbcon keeps the console on fb0 and never remaps it to bochs. This can be
checked with:

  cat /sys/class/drm/card1/boot_display
  stty -F /dev/tty1 size

Without the fix, boot_display is missing and tty1 is 48 rows by 128 columns.
With it, boot_display contains 1 and tty1 is 50 rows by 160 columns. VKMS only
makes the console part visible. Without VKMS, tty1 has the same size with and
without the fix, but boot_display is still missing without it.

Use resource-based selection only for linear framebuffers. Fall back to
vga_default_device() for legacy display modes, while keeping EFI and VESA
framebuffer ownership authoritative.

Fixes: 596b3678326d ("x86/video: Only fall back to vga_default_device() without screen info")
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261103031630.2085194-1-hengyul@cs.unc.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/video/video-common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/video/video-common.c
+++ b/arch/x86/video/video-common.c
@@ -45,7 +45,7 @@ bool video_is_primary_device(struct devi
 
 #ifdef CONFIG_SCREEN_INFO
 	numres = screen_info_resources(si, res, ARRAY_SIZE(res));
-	if (numres > 0) {
+	if (numres > 0 && __screen_info_has_lfb(screen_info_video_type(si))) {
 		for (i = 0; i < numres; ++i) {
 			if (!(res[i].flags & IORESOURCE_MEM))
 				continue;


