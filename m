Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269CB330B00;
	Mon, 27 Oct 2025 18:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591040; cv=none; b=bWqAAkLaQhDnSuVtUbaKuN7OH/6tET6+XaGdocaVJV1mHcHpWR7DbpfR2dFPnPFHz+XUZJnP722hWvPeyJAo/HvgPwNqfQEbsd7VQaeYUcLaNzEWmTKTr/9SxVbvhiIfFgmKUydLhPSS3vw3i/8sESRD4rNxUAhuZtS2Th1ivwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591040; c=relaxed/simple;
	bh=WPD4GUoGI6IJix7l8AvXrBPmyfWsBi/S1YnACYKz+XY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2dV0e9OlzCZRFj4qgT5tkgHPabf52oJf468dvrWuBkz7r8s3FFZhY7l1Ffv+/e/K4BQFc/z58adg9SOCDc6ZssHzDgcpwzcnbygcbdYLLjqSzpBef4wvlqbcDE/5XZtF7NMOo9IhBOvoGMuzML6qwoPa9nNmC8PaQTOY0HwaOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kxpxeu+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kxpxeu+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBA4C4CEF1;
	Mon, 27 Oct 2025 18:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591040;
	bh=WPD4GUoGI6IJix7l8AvXrBPmyfWsBi/S1YnACYKz+XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kxpxeu+Xtc7MNGdnI2RbmJSPw8OdZj+h1EMxyBFtCbMl1M/oFoLvVfbysum058OKH
	 jnLfO2ZH6Uq2F5FXXyUKzrSlEMFoOsNbb9wNohKbsKn+fhVOuajfQUzLfOBJZbHUlV
	 VdVviZ4loHdM0W+IftbEBIoGZ+lYQmIl354VOpwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/332] ALSA: lx_core: use int type to store negative error codes
Date: Mon, 27 Oct 2025 19:31:38 +0100
Message-ID: <20251027183525.809925305@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 4ef353d546cda466fc39b7daca558d7bcec21c09 ]

Change the 'ret' variable from u16 to int to store negative error codes or
zero returned by lx_message_send_atomic().

Storing the negative error codes in unsigned type, doesn't cause an issue
at runtime but it's ugly as pants. Additionally, assigning negative error
codes to unsigned type may trigger a GCC warning when the -Wsign-conversion
flag is enabled.

No effect on runtime.

Fixes: 02bec4904508 ("ALSA: lx6464es - driver for the digigram lx6464es interface")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Link: https://patch.msgid.link/20250828081312.393148-1-rongqianfeng@vivo.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/lx6464es/lx_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/lx6464es/lx_core.c b/sound/pci/lx6464es/lx_core.c
index a49a3254f9677..7b387886c0efd 100644
--- a/sound/pci/lx6464es/lx_core.c
+++ b/sound/pci/lx6464es/lx_core.c
@@ -316,7 +316,7 @@ static int lx_message_send_atomic(struct lx6464es *chip, struct lx_rmh *rmh)
 /* low-level dsp access */
 int lx_dsp_get_version(struct lx6464es *chip, u32 *rdsp_version)
 {
-	u16 ret;
+	int ret;
 
 	mutex_lock(&chip->msg_lock);
 
@@ -330,10 +330,10 @@ int lx_dsp_get_version(struct lx6464es *chip, u32 *rdsp_version)
 
 int lx_dsp_get_clock_frequency(struct lx6464es *chip, u32 *rfreq)
 {
-	u16 ret = 0;
 	u32 freq_raw = 0;
 	u32 freq = 0;
 	u32 frequency = 0;
+	int ret;
 
 	mutex_lock(&chip->msg_lock);
 
-- 
2.51.0



