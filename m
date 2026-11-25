Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619894;
	b=DfQhAxGRcp3JGgNas2OAGtvB11y4zfgZXN7KGwNyyUDsxJqAE1kF1PKiPi1y7JdenXlK
	 TZfeHWEJri5mmAYCt9cy1EmMsWIqHcdW3L5IX1n6LlPBW4+kr0ESLpomca67KTyUjI9Di
	 67Q283I/N3VtIztZnWwRyGtllfHFwHhyCUovc1M47UtjaLHBViQzdPnWKvUl5NNauWsoY
	 HoUocEo4vyFKYGPqZkZ2BYHpos/4zWNLc4WzaSKfSOmre5B98TUK1Ejci+UVsDscQLDm3
	 /EUnQ9vKcaJRRRYraoFLSq+gVe2vtHYF6JEWIa5/XN33BBGQsGlUuJlUfmTYptU4c/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Om7BDLDWY+28kd5s8wV1BR+lGXEVf3yBHJkB35X8EPw=;
	b=YCw0eL2BfV3l8RozLJSxKcBktM0kMU5levcxrnrIoO7BLslgWU5oOJOCEK5qC6s7NOrf
	 abQ0rFXyrqY1emvhj1fUrsem1NWq6q5pWQum2xXwcVThUYTX9QhOnv/HsuQKe3LMpC30z
	 UIhNdY4U8npu6tQfUzxWp2+RSXa2MmCE3p2aMh80PkHf1Jkmb9nfb5JqKrSU+qXsio/ch
	 i2PbftlAIwZ3kVlDm97FYquwzAmFIeWrTqQ2FlKITLD0x5Swx9+VN2giKcGyVo/bqSKmj
	 v1xbisP9JqAZ32XiW2Y7yKa2WMfWllYqidCqmqnYB41fIcWFfZJCWr5iSOwYvwpiNIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eAyyZgv+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3F1606A321;
	Wed, 25 Nov 2026 15:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eAyyZgv+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE961F000C0;
	Wed, 25 Nov 2026 15:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619893;
	bh=Om7BDLDWY+28kd5s8wV1BR+lGXEVf3yBHJkB35X8EPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eAyyZgv+vkrczFrWUcFEqNnsedUtAqd5oJu855hPspBxwL5wRQ1TgYtl6mgHo8aVJ
	 wAETHwQ+W1cpVac+zGd22cHSYdgSbg1qrGYhis7YHFbiVGnzV0txAgm8bqhC6SmoOg
	 qIr/CJr6QhiItlNQ4L2CKF4qkdr7pN87ye0GKB34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengyu Liang <hengyul@cs.unc.edu>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 7.3 0739/1005] x86/video: Preserve the default VGA fallback for legacy modes
Date: Wed, 25 Nov 2026 15:34:37 +0100
Message-ID: <20261125143839.067880686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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


