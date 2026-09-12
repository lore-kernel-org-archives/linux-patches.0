Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41C2372B57;
	Sat, 12 Sep 2026 12:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217682; cv=none; b=IXHNGW8uGemh7CO5WkJ/lM+hn+SFqHjc7m3j7macyJ8GI0lI3uAFNSbpGDMs0nfUusIVb7kdXAx0qM5vTj2+NfG8QxZlm0D2nwpSp98gMsbAMNbZh3DbJ/Q+xIb4gYxOLka1M78dzDuZWrmbEC2AEOoNBwAkeNMSDqDrRp/dC1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217682; c=relaxed/simple;
	bh=nKbFxjGlDs5pA1750svvanaeLzZFcOwDOk4vOuvAJ0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1pHOQ3kW+S4PtFv6Ug+TlD1+g8C65hSgsWfWJejfDayVtBI92L3hbnC3Z2wibsUbgNnYSfWMzN20Qq8bSgIlg7/QWjrDk7T1uZX7cBN3dTNTyE2w/qE3Kq08cllcKx0sTEHe2g5Cqb99Y52X7Gm3xBkfcQjJ7zTZHyELMmMZ18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svAQhIV5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svAQhIV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E44B1F000FF;
	Sat, 12 Sep 2026 12:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217680;
	bh=8zPycVz1gBmYYUuzg7rlNkxb2Vw60i4Ds1AuC3buPBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=svAQhIV5Spo/1lA1mesPtr6frk/8/TPoJb50W0ptW3OyhOwSnbsdr49s6245Ay7AD
	 a6dcsreHRJw3ClxXiStU9GiVLAUeHQknP/LwUghl8Vz4JyueLSvI9zjpEcMqwTIWnI
	 9qXtHahwFKByWcLJ47GTE9oIq571BLDk7fZZp5YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sean Wang <sean.wang@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0990/1376] mmc: sdio: add MediaTek MT7902 SDIO device ID
Date: Sat, 12 Sep 2026 08:56:56 +0200
Message-ID: <20260912065629.630802740@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit cde32a92d4562b686f730fc08d4d558ecc99d516 ]

Add SDIO device ID (0x790a) for MediaTek MT7902 to sdio_ids.h.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: b0c0b3794011 ("Bluetooth: btmtksdio: fix usage_count leak when autosuspend_delay is negative")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mmc/sdio_ids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 8fb8e7e87f6ef..77edf50083379 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -110,6 +110,7 @@
 #define SDIO_VENDOR_ID_MEDIATEK			0x037a
 #define SDIO_DEVICE_ID_MEDIATEK_MT7663		0x7663
 #define SDIO_DEVICE_ID_MEDIATEK_MT7668		0x7668
+#define SDIO_DEVICE_ID_MEDIATEK_MT7902		0x790a
 #define SDIO_DEVICE_ID_MEDIATEK_MT7961		0x7961
 
 #define SDIO_VENDOR_ID_MICROCHIP_WILC		0x0296
-- 
2.53.0



