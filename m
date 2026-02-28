Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A3C379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302111; cv=none; b=Fu/4TVY57KLMclJiPbHmC6Hgfgffn26D7c0OrNa97KqGVmMdhQu7PXako21YAHCcwLt/+tiT3U1yp8f85T5My5io+XkMnEOkQdjIw8iN7inhW1WZs1wZLMi/89KvSN/P2iQ2hsRRT9RAH8pbvEnlLh7kIEbesxTvalBLKSh4pec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302111; c=relaxed/simple;
	bh=p4rHJPC3o4GDM2pdN5sNIKwiZ0RKIBavWvKJkyUnTbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYjw6TviqvxPU8LoI3D+ao2gV8+3ffkPPUYkmUzJXEmbiX98+UY60QYUOUXk2xaZapz20N6GVsenQg78Hkvlk+8S1H1IFMy475tzB+2BrVnCn0VscfEHcRErgilFkCn7drAZIEy7NSZbNgfSTgqx1AvB7gZM6+BOJa9g2kyLMt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJx00EcM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJx00EcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641D5C19424;
	Sat, 28 Feb 2026 18:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302110;
	bh=p4rHJPC3o4GDM2pdN5sNIKwiZ0RKIBavWvKJkyUnTbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJx00EcMsauHSo50I5XOT+NDv4r3uHIv00t0vsjjsOdpyD6tkok8rAwevnqIzH+JT
	 5f6BM9YUTXcibXjOOQHcyZOqxpVOkV7KPN2TggrqYAFDj/xD1ChTWpAx2T72EtddKI
	 i5yVqAgZoH2JrSrsKtMiHNtDaaLoBVzv6s9CTGHldz2jPO+ZZ80a72VL+I1UlpJsVC
	 nouV0yTs8QJ6VdAtZgsPBxW1MS/pBh2tDpHXNLnJ7K8pBdE2nUgOqsgBXPf0ZzyHtZ
	 sQAL4arceJarTXxYRCujYPDCHFAU4r8vzLjk1vbm3PMvgng1D5PxYxddbc/CPURStf
	 P9sz6FtpGbyIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Francesco Lavra <flavra@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/283] spi: tools: Add include folder to .gitignore
Date: Sat, 28 Feb 2026 13:04:01 -0500
Message-ID: <20260228180709.1583486-99-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Francesco Lavra <flavra@baylibre.com>

[ Upstream commit 5af56f30c4fcbade4a92f94dadfea517d1db9703 ]

The Makefile for the SPI tools creates an include/linux/spi folder and some
symlinks inside it. After running `make -C spi/tools`, this folder shows up
as untracked in the git status.
Add the above folder to the .gitignore file.

Fixes: f325b73dc4db ("spi: tools: move to tools buildsystem")
Signed-off-by: Francesco Lavra <flavra@baylibre.com>
Link: https://patch.msgid.link/20260209095001.556495-1-flavra@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/spi/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/spi/.gitignore b/tools/spi/.gitignore
index 14ddba3d21957..038261b34ed83 100644
--- a/tools/spi/.gitignore
+++ b/tools/spi/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 spidev_fdx
 spidev_test
+include/
-- 
2.51.0

