Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5731422CE;
	Thu, 11 Apr 2024 10:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831208; cv=none; b=XEDrdHmLCSjOVsqsD+logSB6pCXNEFr3iEoyRgICbhKYhkKTWbTKPrUod7elqDGOWQ9Q8fM6GNujybl2V4KVnpxbIJQB+k7h+luxyEK8fBAq6hAotvsnOExwShX34jIdbL4DV5Ocbrl4SmdJr8qJyErBXDSIA77jFEeMqDlQil8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831208; c=relaxed/simple;
	bh=KLHg4jQlea+Pmp5K1aqEVPVRDZ6sSHhKfaMPVSXspsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6wNsp/A67mOjGHtGeRO9OW1FgKUHKsfl9o3nSnxiVufk/Q3ToQeonb26QLGbiZ6zHGSq8kRizcmO4ZrdF6rnxbUsa3+PCDPCfabbWPV/+v58VwnfqVX7eRxJj0a9Fjagu/Wu0/rzd2oZYLkf1y/DXVlqtyOqGAy+XP74G6QwLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPv29PB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPv29PB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9889EC433C7;
	Thu, 11 Apr 2024 10:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831208;
	bh=KLHg4jQlea+Pmp5K1aqEVPVRDZ6sSHhKfaMPVSXspsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPv29PB/eU+Hy5UJJlPFixYRZX1YGBKdaFPt53rDGIfY6N06k3uDShhKCTzxHMIRh
	 sk1Dmwv2L3HvIGTdTB2+6qVd7uwLVmt/Un/ARIlcwn8+R+mdNsaWBINTTDhzT4ijxz
	 Ng4hM4XWZkuuIfVAIfKZK7oMgj7IfFJ32tMOI/qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/114] Bluetooth: btmtk: Add MODULE_FIRMWARE() for MT7922
Date: Thu, 11 Apr 2024 11:56:11 +0200
Message-ID: <20240411095418.212187438@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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
index 285418dbb43f5..ac8ebccd35075 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -422,5 +422,6 @@ MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(FIRMWARE_MT7622);
 MODULE_FIRMWARE(FIRMWARE_MT7663);
 MODULE_FIRMWARE(FIRMWARE_MT7668);
+MODULE_FIRMWARE(FIRMWARE_MT7922);
 MODULE_FIRMWARE(FIRMWARE_MT7961);
 MODULE_FIRMWARE(FIRMWARE_MT7925);
diff --git a/drivers/bluetooth/btmtk.h b/drivers/bluetooth/btmtk.h
index 56f5502baadf9..cbcdb99a22e6d 100644
--- a/drivers/bluetooth/btmtk.h
+++ b/drivers/bluetooth/btmtk.h
@@ -4,6 +4,7 @@
 #define FIRMWARE_MT7622		"mediatek/mt7622pr2h.bin"
 #define FIRMWARE_MT7663		"mediatek/mt7663pr2h.bin"
 #define FIRMWARE_MT7668		"mediatek/mt7668pr2h.bin"
+#define FIRMWARE_MT7922		"mediatek/BT_RAM_CODE_MT7922_1_1_hdr.bin"
 #define FIRMWARE_MT7961		"mediatek/BT_RAM_CODE_MT7961_1_2_hdr.bin"
 #define FIRMWARE_MT7925		"mediatek/mt7925/BT_RAM_CODE_MT7925_1_1_hdr.bin"
 
-- 
2.43.0



