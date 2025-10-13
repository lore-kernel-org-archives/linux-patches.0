Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4243930C37C;
	Mon, 13 Oct 2025 15:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368030; cv=none; b=a4jTHz6eRez617P684asq/dvPauSm0EWqCwnr8IsCe916eylwHEW/ktOP1qPudZhbbsqGE7DOZarEbw+j8I7tR9AAGPFLDHoKisYQKR0GKDmT4WBam8mFe5GG8sQt61JSih5q/fhvHW2ZWX5STpTA6UdYsyf6snPihdqCLDIDio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368030; c=relaxed/simple;
	bh=N/5BPihtvYNt2xoIYNvQ/k1uW41pannJLsELDzTDOg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHB54O+AlU//GAZukt65lQrIJry5H6YWKpgWI/dO5iHuw7AEi+2cqbfWKrwB9KTGOLo7y63A8DgwcbBi3xpDKi41kNdw1cGN+QoSyGNopnDRQt1yFkUU+6Y9/RN7j52NJAbluSpjJqlLONoOx27StbjmYlnxSeMjtEmCTapNy/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfWEjm4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfWEjm4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED63C4CEE7;
	Mon, 13 Oct 2025 15:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368029;
	bh=N/5BPihtvYNt2xoIYNvQ/k1uW41pannJLsELDzTDOg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfWEjm4/U4lZ2pQknJA19khgAh55BfLrBDyDso5G2rrCfs9U5NcW8fFw2sgnDSfe8
	 sViwyl8Z5/o/IdoRKA9l7mfXuigWHthHmC4RU/BYD2bNLfbDmcw16z2qODMyPHiEof
	 /F2CQivlTNskKh75EEzvla1SsXTy0mtC3Oq74CGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Martin Wilck <mwilck@suse.com>,
	David Disseldorp <ddiss@suse.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/262] init: INITRAMFS_PRESERVE_MTIME should depend on BLK_DEV_INITRD
Date: Mon, 13 Oct 2025 16:42:24 +0200
Message-ID: <20251013144326.210839070@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 45990792cb4a6..219ccdb0af732 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1440,6 +1440,7 @@ config BOOT_CONFIG_EMBED_FILE
 
 config INITRAMFS_PRESERVE_MTIME
 	bool "Preserve cpio archive mtimes in initramfs"
+	depends on BLK_DEV_INITRD
 	default y
 	help
 	  Each entry in an initramfs cpio archive carries an mtime value. When
-- 
2.51.0



