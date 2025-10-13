Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E97C27AC21;
	Mon, 13 Oct 2025 15:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368779; cv=none; b=G1bCqNsUej6q5hAtmZvcPwp9bIWZIieef3iIpv0VODq3Uj63GuiPFocY7lLEjH1zdfiyY3+kjCaqssJvUszf2Emk0qFrud2nImVlkJZzojrk5BisHlIcfNG4vn5Bln1gS89ouDYcDwpkXcqZxwgdmTZ6C1No9emDhgJFn68+K98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368779; c=relaxed/simple;
	bh=dORXQrDYKByMbWopKelZ+Q7bu8pxt7/XB18UYYhlp0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=os5BBHWHltWdbq4uishG0HSAoqGeDGD7M6E9QgjJMLS8/5qeg+YL8rvfMsH9PRpV1pBDFAKQ3X4o4o4tisCN78AFH0D3taN7pivOJa5NzTWmwwMthrFdPR3FgN/hQzmCCdzilAUCkrr6QcC0THYWbgzsxEwf6ovjR5jQLFARTzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iScOys8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iScOys8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE174C4CEFE;
	Mon, 13 Oct 2025 15:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368779;
	bh=dORXQrDYKByMbWopKelZ+Q7bu8pxt7/XB18UYYhlp0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iScOys8cS3LM8950Kcq8bZZK1icQ1SLzqGLQ5J+j41Ds79tY89qmQXvYHfeAXBw7B
	 ERhYxfHRcIdF/dFlEwn8BB4EkKxp0FyJkVKw28HbI7Pgmh0afRIQsotV9q6H8Df4x3
	 iUb3fuwGLPZJpwkwb6v1D7GJZwD+tEB2kAayLXIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Martin Wilck <mwilck@suse.com>,
	David Disseldorp <ddiss@suse.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 003/563] init: INITRAMFS_PRESERVE_MTIME should depend on BLK_DEV_INITRD
Date: Mon, 13 Oct 2025 16:37:44 +0200
Message-ID: <20251013144411.410558218@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index ecddb94db8dc0..e5d6d798994ae 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1504,6 +1504,7 @@ config BOOT_CONFIG_EMBED_FILE
 
 config INITRAMFS_PRESERVE_MTIME
 	bool "Preserve cpio archive mtimes in initramfs"
+	depends on BLK_DEV_INITRD
 	default y
 	help
 	  Each entry in an initramfs cpio archive carries an mtime value. When
-- 
2.51.0



