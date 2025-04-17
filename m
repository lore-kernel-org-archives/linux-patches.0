Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E682C2566FF;
	Thu, 17 Apr 2025 18:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913265; cv=none; b=ZjH/4EmOqbUEUKtFz//W/q64HOP8IHc4NdvX9h8Pk1m4phQFmyzhLOFsv23G/CUniBLuo+IvuLKSUjJ3iQgBHbSPAtKQ4AnivRYhxOyaT/lfNJEBs2NmuxXS0zbe/sTUs5kOpt0nW5ulmUuDj8X90I2WFuy514B62bGzpJxzh3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913265; c=relaxed/simple;
	bh=sQ82n1zxTn+H1o3EQO2wniuev7I3wmT1IxHvD8W5z+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSibY/5CUeKQDie36m0+UWigt5BziH46dWQY+JqDTZOnzyPU3onsBHyaN/8YXcUx3fLSN/MCwJXa632a31c1QJ8oy0QMRzry8AnikBHxmj7SBUDbKEmNkqxBIgfarVXAb9fQHNchXioC+dbLx9Z716ASKnJQGUIGtEajN2MWOvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkgeO5oV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkgeO5oV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAC5C4CEE4;
	Thu, 17 Apr 2025 18:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913264;
	bh=sQ82n1zxTn+H1o3EQO2wniuev7I3wmT1IxHvD8W5z+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vkgeO5oVUS5IGOrC3iKpINLgsJT4ZKYDxlnD9u2Jx//nM1nYwZtGIwJtGGuyN9mMj
	 xAyGRJMV9CfbcGUErMzAbytHby2KQ2HYcWRi/rrzgSAz22Qc1/wNOUj3D7XKcAXWB4
	 WXOBO1oDaGlRyvZg8zyuxyNOZH46K9P4yarxLFSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.14 281/449] wifi: mt76: mt7925: ensure wow pattern command align fw format
Date: Thu, 17 Apr 2025 19:49:29 +0200
Message-ID: <20250417175129.378649539@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit 8ae45b1f699bbc27ea8647093f794f671e77410b upstream.

Align the format of "struct mt7925_wow_pattern_tlv" with
firmware to ensure proper functionality.

Cc: stable@vger.kernel.org
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250116055925.3856856-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
@@ -566,8 +566,8 @@ struct mt7925_wow_pattern_tlv {
 	u8 offset;
 	u8 mask[MT76_CONNAC_WOW_MASK_MAX_LEN];
 	u8 pattern[MT76_CONNAC_WOW_PATTEN_MAX_LEN];
-	u8 rsv[7];
-} __packed;
+	u8 rsv[4];
+};
 
 struct roc_acquire_tlv {
 	__le16 tag;


