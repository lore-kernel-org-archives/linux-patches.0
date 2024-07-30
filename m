Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EE11A618D;
	Tue, 30 Jul 2024 16:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356653; cv=none; b=sIeOJpOgh5pjmcqDz2p4d2Jry7in9AceLdlSo/3OV8+H8tlW3j0GhfgYomSHR+1c3zDGb6VSlrqvM4Nn4sixzI0H/Z16u99AQUsHRWFmjBnWu+u6eDDKg6pP1x43WIGejyHRY4WjGKHbtvlGWWxr1QSGC2eoCP3w3+0Od7weQMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356653; c=relaxed/simple;
	bh=InpgMew2tWuRXwi0qLsWU6SqYYFTdUd3uEQfSyYH8b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfHUZWsJVlawvrAJdSyPM9Oykq7ZZkB68GkRUzdTVIV+z2dC0zwd4PQ3voHW+H4JKCwFenFaIffmWhfMVcOH10gAdPdsTKujNMrGcjzPmDlxV69D+spNDY8j3N0Yo0ISgPOtUfwZ/iVxQ4vHpw79b1hzqqRLsq4+InpxSeMwJ48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J98TTxTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J98TTxTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F159C4AF0A;
	Tue, 30 Jul 2024 16:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356653;
	bh=InpgMew2tWuRXwi0qLsWU6SqYYFTdUd3uEQfSyYH8b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J98TTxTdxKScSyRjJe+YS0uOx3dmZZiSfxupaIXIqBqVUxMU4TbwD7j1IXg6kQDX7
	 zovC2sQem1Kkn2O0Ql9ZI+F07/IPNSeGI/jC5ohVx9kMwGJ8D6KFTZrfafIzt5BpA9
	 97pnMN3Gn7gqpROYBO2ujiqmw3WK+LoKjQVNYNPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@svenpeter.dev>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/568] Bluetooth: hci_bcm4377: Use correct unit for timeouts
Date: Tue, 30 Jul 2024 17:44:37 +0200
Message-ID: <20240730151646.529698431@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sven Peter <sven@svenpeter.dev>

[ Upstream commit 56c695a823e4ee1e5294a8340d5afe5de73828ec ]

BCM4377_TIMEOUT is always used to wait for completitions and their API
expects a timeout in jiffies instead of msecs.

Fixes: 8a06127602de ("Bluetooth: hci_bcm4377: Add new driver for BCM4377 PCIe boards")
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_bcm4377.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_bcm4377.c b/drivers/bluetooth/hci_bcm4377.c
index cf36cdac652d6..0dc3ca3d41073 100644
--- a/drivers/bluetooth/hci_bcm4377.c
+++ b/drivers/bluetooth/hci_bcm4377.c
@@ -32,7 +32,7 @@ enum bcm4377_chip {
 #define BCM4378_DEVICE_ID 0x5f69
 #define BCM4387_DEVICE_ID 0x5f71
 
-#define BCM4377_TIMEOUT 1000
+#define BCM4377_TIMEOUT msecs_to_jiffies(1000)
 
 /*
  * These devices only support DMA transactions inside a 32bit window
-- 
2.43.0



