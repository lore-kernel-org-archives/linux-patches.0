Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028C1385D7B;
	Sat, 17 Oct 2026 16:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256037; cv=none; b=Q/wy8wBP5KoJu3rODbYLHHTwI8XmzSsNkh3Jkp5/bMyq5lBKm/BVumUk+z7OnnCcs07PPQhWR5SqMf+9g/LslFWvISyhcTkoGOh+7X1xzVELrQJ0nyJm+PXIKU/YdTzVPgX6rSxl8x5JVd2xiQPS9xKuaGPu8X4D644OjTaFyXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256037; c=relaxed/simple;
	bh=gKsucygL1ZfvsfXO0TuWJFFXjZvidsU+N18LILLjSgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNt8Vdj6BM3TrpojH93+maTSS4+r1gME6g7qyoheFl9cmG+MiB86nunG3vskipIYuSZ1cQzhAZTaXpVlhqtqx18mt6dVOsZ4N869MU0Xwcf7BzLCEjO6dHzW3Uc2Cyjtj83loosEVR8gHR73oOV2B+egi5xn5wFzYvlW/zI6kls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GUJNLQWt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUJNLQWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92EE1F000C4;
	Sat, 17 Oct 2026 16:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256035;
	bh=IsR+WqTRMnMWY39Xo/DWVD5z4guNp2tppAyPzXWW8Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GUJNLQWtc7KLzyII+Ib+JsvQ5PQ0ivAu0hds3e2C+WBJUfduZXgDKOxaHNMib+3in
	 9oX46+CHNig/65CTTXRc3F5NgvoniNxvekgwnn/7KbO1yzBLLRU4GhZuWhjoqMQdIg
	 SMnf9eof5ie+qh1R+DaHC6sCcq6kdRPiIVmBbSRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0102/1674] drm/sysfb: ofdrm: Fix is_avivo() constant comparison bug
Date: Sat, 17 Oct 2026 17:39:34 +0200
Message-ID: <20261017160433.765557347@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Shixiong Ou <oushixiong@kylinos.cn>

[ Upstream commit 958f35cbb8955ca3fa439cd9f2092cb42414aa8c ]

The is_avivo() function has a logic error where it compares a constant
to another constant instead of checking the device parameter:

  (PCI_VENDOR_ID_ATI_R600 >= 0x9400)

Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: f496834e1674 ("drm/ofdrm: Add per-model device function")
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: <stable@vger.kernel.org> # v6.2+
Link: https://patch.msgid.link/20260731111729.703116-1-oushixiong1025@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/ofdrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tiny/ofdrm.c b/drivers/gpu/drm/tiny/ofdrm.c
index 2c59e501112b8..1caef717e4cf8 100644
--- a/drivers/gpu/drm/tiny/ofdrm.c
+++ b/drivers/gpu/drm/tiny/ofdrm.c
@@ -233,7 +233,7 @@ static bool is_avivo(u32 vendor, u32 device)
 	/* This will match most R5xx */
 	return (vendor == PCI_VENDOR_ID_ATI) &&
 	       ((device >= PCI_VENDOR_ID_ATI_R520 && device < 0x7800) ||
-		(PCI_VENDOR_ID_ATI_R600 >= 0x9400));
+		(device >= PCI_VENDOR_ID_ATI_R600));
 }
 
 static enum ofdrm_model display_get_model_of(struct drm_device *dev, struct device_node *of_node)
-- 
2.53.0



