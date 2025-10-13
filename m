Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE61277C8D;
	Mon, 13 Oct 2025 14:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367460; cv=none; b=iT0EL2WPvMAkqObxtilIeIpXRLNK6MxEDdiknkzSxPm8gp7DMh0iEZiWcnZmD9wHhwLtBGy+2ArBAO592y5sMv/uaa6W/GPJeQNzLJTz9kAZTnxJIHuh2H4Cg8eZNKdzxpF/0ieFUlXnAny7dbgCIMh1kbSgzLiE8vI39mtcrss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367460; c=relaxed/simple;
	bh=gsvY83+6RnqglEN/DjpCp5AZNvFRsrU4robCg0i4k74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOEBMfyl7bINtZUoBRsbKxHk6ImcklZwZrjD6Quo6JGvUjKahAQvbeg3kWRaY67FYg5r/SQKIBZZgK5jAToBzAeHL6doY9fV1bn+XqmODfMIe16hF2xClibkNr8LtewTM/DsuSzUvEGmgzWlnxPlihglT1WD7JrPFmbhShYTY7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c86MBTi/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c86MBTi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8792EC113D0;
	Mon, 13 Oct 2025 14:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367459;
	bh=gsvY83+6RnqglEN/DjpCp5AZNvFRsrU4robCg0i4k74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c86MBTi/g9tZqtKQe+jAXvNiMgxLTl2sXpWzhJa1IGb6rr0cwArbjS1n5sMaHwERl
	 dSFvK1xBQfgJTMUii7R/RCeFnDbxmLK/c0MuQj8p7TwlO9+risc0z7f/uzs7xYJ0pS
	 Gk4TzGb6KE+FNH/cvk6mxkqPEEJNz6LaI3+bSQig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Martin Wilck <mwilck@suse.com>,
	David Disseldorp <ddiss@suse.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/196] init: INITRAMFS_PRESERVE_MTIME should depend on BLK_DEV_INITRD
Date: Mon, 13 Oct 2025 16:43:13 +0200
Message-ID: <20251013144315.276235986@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8b630143c720f..461591503bf43 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1367,6 +1367,7 @@ config BOOT_CONFIG_EMBED_FILE
 
 config INITRAMFS_PRESERVE_MTIME
 	bool "Preserve cpio archive mtimes in initramfs"
+	depends on BLK_DEV_INITRD
 	default y
 	help
 	  Each entry in an initramfs cpio archive carries an mtime value. When
-- 
2.51.0



