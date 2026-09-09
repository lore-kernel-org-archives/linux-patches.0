Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2273D967A;
	Wed,  9 Sep 2026 14:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963222; cv=none; b=N5WbSlFhEmbfvxZ78YkCiEP325tOhpp9Y+ZweIFQPeL3PMVpA3IZQYyZH5QLNjwVdQwi9+T7+8t6pN6kFv/Ymm74q0yT7Vollo/EGkb5qwZD2DqH4JbMhypqbemhY3f3LapwHQ6YpvkkjzwssxIc3iClPfFf/RwfvEEePG4SE8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963222; c=relaxed/simple;
	bh=CvsHBDmS7eX/LvdYMYeFxxhSZ67arRkU6p0lyP320ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjfieHe7aaYq6H2P8wv4PaF8bxm+atD77u1BjS4JBh+u3G6v8uYR3QTIHM3j1B2d3QxG5J9ES+923bh9lgJIn4gSB+4tYa7tU/9o7eaPKC06nB6EFhQvzyR6bPbne2gN1WFjKrTR+F5w7s2fifPPYAr2qCtM8r9r/mTC40aEJEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZicgcqZ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZicgcqZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D472E1F00A3A;
	Wed,  9 Sep 2026 14:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963221;
	bh=Y8hO28ZwTThaXGVTrN2EglE1HM0bzND3FUc70PFiqcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZicgcqZ4vb0r1Mc48DV0+njsknDx51QbMCBa/YtxMc4A/R2tm1jU4Pd2W9Rnilme+
	 4on9qzFQQdEfbIbFcNtAwM9T+AM4EhjfR0kz7ZGBWnsfMlZ91aR3iNA6nlb02wv8PC
	 8BiDaS6vhCGOlN8Bfh9m564oEtOB/cT+g33TZwSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 7.2 524/556] drm/sysfb: ofdrm: Fix is_avivo() constant comparison bug
Date: Wed,  9 Sep 2026 15:43:24 +0200
Message-ID: <20260909134248.851634002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Shixiong Ou <oushixiong@kylinos.cn>

commit 958f35cbb8955ca3fa439cd9f2092cb42414aa8c upstream.

The is_avivo() function has a logic error where it compares a constant
to another constant instead of checking the device parameter:

  (PCI_VENDOR_ID_ATI_R600 >= 0x9400)

Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: f496834e1674 ("drm/ofdrm: Add per-model device function")
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: <stable@vger.kernel.org> # v6.2+
Link: https://patch.msgid.link/20260731111729.703116-1-oushixiong1025@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sysfb/ofdrm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/sysfb/ofdrm.c
+++ b/drivers/gpu/drm/sysfb/ofdrm.c
@@ -239,7 +239,7 @@ static bool is_avivo(u32 vendor, u32 dev
 	/* This will match most R5xx */
 	return (vendor == PCI_VENDOR_ID_ATI) &&
 	       ((device >= PCI_VENDOR_ID_ATI_R520 && device < 0x7800) ||
-		(PCI_VENDOR_ID_ATI_R600 >= 0x9400));
+		(device >= PCI_VENDOR_ID_ATI_R600));
 }
 
 static enum ofdrm_model display_get_model_of(struct drm_device *dev, struct device_node *of_node)


