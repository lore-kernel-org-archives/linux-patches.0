Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2428451993B;
	Wed, 30 Sep 2026 17:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790094; cv=none; b=Os+KbSxzTElYStInYRgrWTuvEaKrfgPat3L9yUUl/eXzWpaumg77b5OnCcLR/HC59pOEGIHbczsTrsNKCoPKTNFXZA4Ff4q8ssJfETd+wZItLpdOumvVRBMsiMZd1zYfoVM9o7LziEBS8+cV9cXqM8Chy0xrw4s2uCiUBM8nYmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790094; c=relaxed/simple;
	bh=3Cwbh5pWa0vKKN70dmgl0hwHj8UhAiDAKruFNxq+d/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxysAz+J7JmkVniJVhFxryUEGojb+89e1G7i0Vpuy2hB2XXJX1NXlNpqZmM3VhyVaW1jLpQ5ADB5yNt+zON+ro/ZuI014g3vCpVIYAfr+eSbvtWWh2ikB8CJVsDjw2FZ4/o26Qp/8h8pNiopU68TP2ACmPnPujRKPRiAtOfGvr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9+0tYtd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9+0tYtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792A71F000FF;
	Wed, 30 Sep 2026 17:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790093;
	bh=jjVpCE2vbL5cHm0JkbzjgsVHwFYse9Q4g9HPU6PQq50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9+0tYtdMp4vBclO0c4tP0ga0Dxna8mMoqok9CAUTSjnv1uR9BjNMQVazflqSc1ED
	 85WTSxIbZv7gczvgJNlN4tvwac/zzRvqfQ2VWIgQtg9jx2QkYWKaCQk79JCoV1waDT
	 bqO/07INXNAT5qtOBQ7MYOSy6UVxXqnJVXErbwaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 708/877] drm/sysfb: ofdrm: Fix is_avivo() constant comparison bug
Date: Wed, 30 Sep 2026 17:26:59 +0200
Message-ID: <20260930152429.961457624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tiny/ofdrm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/tiny/ofdrm.c
+++ b/drivers/gpu/drm/tiny/ofdrm.c
@@ -232,7 +232,7 @@ static bool is_avivo(u32 vendor, u32 dev
 	/* This will match most R5xx */
 	return (vendor == PCI_VENDOR_ID_ATI) &&
 	       ((device >= PCI_VENDOR_ID_ATI_R520 && device < 0x7800) ||
-		(PCI_VENDOR_ID_ATI_R600 >= 0x9400));
+		(device >= PCI_VENDOR_ID_ATI_R600));
 }
 
 static enum ofdrm_model display_get_model_of(struct drm_device *dev, struct device_node *of_node)


