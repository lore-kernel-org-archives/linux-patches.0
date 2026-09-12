Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94A0415F36;
	Sat, 12 Sep 2026 08:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202247; cv=none; b=Ud/GIUvJazrESfftpoIh54+g4C20K28nUUR58e/Q7cUtwtnCP4wyQTzO84cC9RJPcmePPlQwxkm+Ufl/gc4nyTtlvO7p/eFHDyAv4NUvkJ8WVgGUjazKetrMiCxk3X0iYz8m5SnRljg5z4iJTeZsb7t1yvbkgFM0IU1Qk82WsHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202247; c=relaxed/simple;
	bh=YXJABJJQh6lMfI/11pCI13e72welCQUawAmoWrfy/Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQfqfh87OkSlwcCNB35ixAX/0RKFHuMhVh6XDsB4kbzMIPa9LK7a7oWS8QznQoR9woZHPdtq8ZjBRjMfRFIqTKBv1vXo7KpPJF+mFsPh+yCvP0af9lRDdnC17+uq10a2AqKIwIRiBC1kOveN6UVsG/8x9Ny/GRgYxZCmmMAillY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZ1YUOjB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZ1YUOjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE9C1F000FF;
	Sat, 12 Sep 2026 08:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202245;
	bh=HGzkBgLPGvLzMyQrLHzYYUGZxpE2B67Y819L6YEuz54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VZ1YUOjBvcCb6rk5FsnysuWqdO1k7O4OJuxm0Y6B9nv/iPz5WIs2Nh6yL5z8M1h98
	 v2rEDTZS9hNCBG/HS2JUCGDQpu5CTizhYaxrAVCJR4GZeB5ZY6pR7B1RdMqQE1T65q
	 0xhETQW0OjW3FYgljrMD5s45B9+4t+kw5Rblxra8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1163/1815] ALSA: hda: cix-ipbloq: Avoid build with 32bit archs
Date: Sat, 12 Sep 2026 08:48:33 +0200
Message-ID: <20260912065716.317708161@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 2a611c4a1cbcb179cd8079a7ccadee390dac66f6 ]

The cix-ipbloq driver has an assumption of 64bit DMA address, and
building it for 32bit dma_addr_t leads to a sparse / compile warning.
Simply disable the builds for 32bit archs for avoiding such reports.

Fixes: d91e9bd10125 ("ALSA: hda: add CIX IPBLOQ HDA controller support")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202608061559.Kxqvi5LZ-lkp@intel.com/
Link: https://patch.msgid.link/20260806104431.1300304-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/controllers/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/controllers/Kconfig b/sound/hda/controllers/Kconfig
index 5d6a77e68588e..26ca69b09a9c3 100644
--- a/sound/hda/controllers/Kconfig
+++ b/sound/hda/controllers/Kconfig
@@ -33,6 +33,7 @@ config SND_HDA_TEGRA
 config SND_HDA_CIX_IPBLOQ
 	tristate "CIX IPBLOQ HD Audio"
 	depends on ARCH_CIX || COMPILE_TEST
+	depends on ARCH_DMA_ADDR_T_64BIT
 	select SND_HDA
 	select SND_HDA_ALIGNED_MMIO
 	help
-- 
2.53.0



