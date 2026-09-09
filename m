Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F94158E2C5;
	Wed,  9 Sep 2026 14:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964394; cv=none; b=hT/Sp1I+dJhd1NwNuWgwrb2h2NjCTe9sJ2geKc4X9+lweuE4vwSgkTF5yxZgghdQCQy8BfhbNTOpJmWB8C8dXnFLgWaZjp3eMhnNnwnZkvAN5I6V0LcIjKDt0Hem7cOXOyXCQ5rpRheS2YAoJSPQqOabkngYMT4aCyThjNMU0aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964394; c=relaxed/simple;
	bh=bFBOGHoCFa07eeJZPDh7MraTkPelizo7ga6fHUopF+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsxam0bHtdeUAnfSoJFWDd6sSyhOoVULsUbAYtsbzXUbVqJFvmC0aSubtx0+kAnSoXwJfAvEIxifme2TZPy/GCI8gRsfRgBPvkRUEeyYBPQ7MqNvzKJuoSy0jWC4kpjE7rnIqYEzviaoGjMeKth0odQIwzM33QNYVWkBx/ZjgoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BL8wllEv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BL8wllEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE6B1F00A3D;
	Wed,  9 Sep 2026 14:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964393;
	bh=jZn8twf3rqtaR3GfdIsFxJvQxdW6nzWCeghiktw140I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BL8wllEvMcJ3+9q6YeSxsfx/pf/8a4msnlNqRKSm4h//t3lomcrA3NMZWqtM3XpNL
	 I7M2VRV2ht9yPWgqx3qdFhcavvJ276uyTmEwt9gM6JYdyzTVme65gr/sZnPoyiw6gr
	 qcnqoJqGkEoYaRAKLYrzUBr0LC2fPHvg4bfxDKtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.18 408/583] drm/sysfb: ofdrm: Fix is_avivo() constant comparison bug
Date: Wed,  9 Sep 2026 15:41:33 +0200
Message-ID: <20260909134252.119875892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -236,7 +236,7 @@ static bool is_avivo(u32 vendor, u32 dev
 	/* This will match most R5xx */
 	return (vendor == PCI_VENDOR_ID_ATI) &&
 	       ((device >= PCI_VENDOR_ID_ATI_R520 && device < 0x7800) ||
-		(PCI_VENDOR_ID_ATI_R600 >= 0x9400));
+		(device >= PCI_VENDOR_ID_ATI_R600));
 }
 
 static enum ofdrm_model display_get_model_of(struct drm_device *dev, struct device_node *of_node)


