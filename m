Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF663146D52;
	Thu, 11 Apr 2024 10:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832378; cv=none; b=Z0enGj5+EnSSaHhsA91FAKkvV50G0J13DlRovtolYoLz6xh/zJPV7v5wv0mKmkKnYg+GtBwgckkV0tbG53jurkoXl2lUE64r9jrABTi88QJnjg0S/BU7B9kiObPGYCQaRxZpm02YV7P3jl/bIoT89cqr8HeuJQbYwxSWLsLEOlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832378; c=relaxed/simple;
	bh=hQ9D75srD9U6bMn4kG8eFiIGYu8k2/L+HaGYUuO7uds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUPC+Ht8XR3qczz/aVr6ZcVDfDbNyzTBj7446HhzZcpWK0txZkyeGXRLMlySkbyXA2L54Kv+IgveDBNkFPjq43KX4jqrmadaQvqQuDpHbENbiUQ+RE1ElaZcmeCBWQwLNzyeQM12bnIzy3mXEBs5Cu64aAJkaGl4dVCkWjQRBnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqzUNnKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqzUNnKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BF9C43399;
	Thu, 11 Apr 2024 10:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832377;
	bh=hQ9D75srD9U6bMn4kG8eFiIGYu8k2/L+HaGYUuO7uds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqzUNnKwHujCKGv+YzU3iES//psKpoS7meYOI47gF7u8u0wxtxacDH/ElmNtdCFs8
	 7Dog2DgVYVXuFDg5Bte0tQa0puvrUG7ZnYGrDsXdZkNktYrVzr6AeIzpn1vnGeUwJs
	 Ahz/A4LAFF0T9o4xOJtUYso5K4rtLQQ4aKb2yMpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 28/83] Bluetooth: btmtk: Add MODULE_FIRMWARE() for MT7922
Date: Thu, 11 Apr 2024 11:57:00 +0200
Message-ID: <20240411095413.525049026@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 3e465a07cdf444140f16bc57025c23fcafdde997 ]

Since dracut refers to the module info for defining the required
firmware files and btmtk driver doesn't provide the firmware info for
MT7922, the generate initrd misses the firmware, resulting in the
broken Bluetooth.

This patch simply adds the MODULE_FIRMWARE() for the missing entry
for covering that.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1214133
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 1 +
 drivers/bluetooth/btmtk.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 809762d64fc65..b77e337778a44 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -288,4 +288,5 @@ MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(FIRMWARE_MT7622);
 MODULE_FIRMWARE(FIRMWARE_MT7663);
 MODULE_FIRMWARE(FIRMWARE_MT7668);
+MODULE_FIRMWARE(FIRMWARE_MT7922);
 MODULE_FIRMWARE(FIRMWARE_MT7961);
diff --git a/drivers/bluetooth/btmtk.h b/drivers/bluetooth/btmtk.h
index 2a88ea8e475e8..ee0b1d27aa5c0 100644
--- a/drivers/bluetooth/btmtk.h
+++ b/drivers/bluetooth/btmtk.h
@@ -4,6 +4,7 @@
 #define FIRMWARE_MT7622		"mediatek/mt7622pr2h.bin"
 #define FIRMWARE_MT7663		"mediatek/mt7663pr2h.bin"
 #define FIRMWARE_MT7668		"mediatek/mt7668pr2h.bin"
+#define FIRMWARE_MT7922		"mediatek/BT_RAM_CODE_MT7922_1_1_hdr.bin"
 #define FIRMWARE_MT7961		"mediatek/BT_RAM_CODE_MT7961_1_2_hdr.bin"
 
 #define HCI_EV_WMT 0xe4
-- 
2.43.0



