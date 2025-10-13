Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA9C308F01;
	Mon, 13 Oct 2025 14:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366975; cv=none; b=tve0CY4vC8ac7SQxmS6OWt7UCp9yTvfNznc7Mq/38EvkpjQ38nr9AJx1slhFtaUA8PUJnUpHmlSz72s4LvKLqI5+SsWflmZCOE3VKx0WzOhq0p8TFCxUOj5gQr3Kf/3TeuvTo90fQm2rwltvOp9vsHVtInEGxusxjAfaJlRgUOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366975; c=relaxed/simple;
	bh=LTINxT0qULXGB909hgq00VgsRihINk2ylhBK6DMwChA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfssAXxlPR1U+w5a9Nf4fhi9/3eJwxDHOQIFIo1R/0O1W3hmW187u4GmlFvJXT0j0x85vZMERklULDsMGMkKjiLaQYrDggkjdtpGP1G0ZFdG039lNahlebtbZPoGwB+IWUbBvNLKZRp9qWGZfJ4aRZNLVlBRBDGZ4m58C2eHLcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srkClh/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srkClh/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B0DC4CEE7;
	Mon, 13 Oct 2025 14:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366975;
	bh=LTINxT0qULXGB909hgq00VgsRihINk2ylhBK6DMwChA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srkClh/e+w61yck85YbjbY0QcuANS1tP3kYSCctvJAoh/1ZmDjetzUJ1vAJ89/HQW
	 m1v+s7bQlkJpC0i91KRHojd++FMoz99V7nkiAjcelSJsB3Hfk2699qzaLcTE7Oz/j/
	 uY0givN90jBTBUF//xL0gsQeCWcJk4xxrKutdf4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Martin Wilck <mwilck@suse.com>,
	David Disseldorp <ddiss@suse.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/196] init: INITRAMFS_PRESERVE_MTIME should depend on BLK_DEV_INITRD
Date: Mon, 13 Oct 2025 16:43:40 +0200
Message-ID: <20251013144316.287214879@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 74792608606a525a0e0df7e8d48acd8000561389 ]

INITRAMFS_PRESERVE_MTIME is only used in init/initramfs.c and
init/initramfs_test.c.  Hence add a dependency on BLK_DEV_INITRD, to
prevent asking the user about this feature when configuring a kernel
without initramfs support.

Fixes: 1274aea127b2e8c9 ("initramfs: add INITRAMFS_PRESERVE_MTIME Kconfig option")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index 8b6a2848da4a5..b70e0e05a1856 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1405,6 +1405,7 @@ config BOOT_CONFIG_EMBED_FILE
 
 config INITRAMFS_PRESERVE_MTIME
 	bool "Preserve cpio archive mtimes in initramfs"
+	depends on BLK_DEV_INITRD
 	default y
 	help
 	  Each entry in an initramfs cpio archive carries an mtime value. When
-- 
2.51.0



