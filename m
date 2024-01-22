Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2839913398C;
	Tue, 23 Jan 2024 00:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969294; cv=none; b=dgKKo59yMMq7IVtBt0EhFQ7SyjlBq+hm3SyZ+rkxNOZTB7OrFlxvBOfL5LZiM0orvKbagJnWOsu+0hRXTKZo2RjCavU3e4sDl4v1Zq5+MsO42Dox+1bmH13jh6Fxeb89YuNZoWSYeTP9U7/y1VdrPwkjlXs4f2+qa4TYTAQp7qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969294; c=relaxed/simple;
	bh=aIR8gdg9xDvNpSlk67EA9tUBzuxl9QhkzzmfrGP06S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXAuSVVzWZZgGQ38+mBBSatY/KdzzYzfyNRtlKWKYXaGRKhYqcW9GlvdGO0LmxrNGl62+tgntvEHMXLkgQf7yKnSMzPa3uOIWkMIHJQzbRtU/4aVXWezVssnxCZNFU2tt/ol13zZCF/0JoJOZ2BxpNAUFP0cBVVgp0ssvFip/is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPphcDnW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPphcDnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E7FC433C7;
	Tue, 23 Jan 2024 00:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969294;
	bh=aIR8gdg9xDvNpSlk67EA9tUBzuxl9QhkzzmfrGP06S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPphcDnWOUfyWRgCLGT/rOQ7EbgGDBuicCsq8nJ0NFvelj2OvReF/WgmdNZY8vv70
	 hgi8N0r3VEE8rNUOqKcAm+TyzkOZmiWFoIH3IZsspcTf8PHecbpIdpHZfd7exsa8S4
	 9z7z3ZG7Pmv0zOoLUOb33aUmYC7jOsspmTzQ1sFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 151/641] wifi: mt76: mt7996: fix alignment of sta info event
Date: Mon, 22 Jan 2024 15:50:55 -0800
Message-ID: <20240122235822.763349637@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit d58a9778f7ca0634622d2fc2e9f76163467bdf5b ]

Fix the alignment of struct mt7996_mcu_all_sta_info_event.

Fixes: adde3eed4a75 ("wifi: mt76: mt7996: Add mcu commands for getting sta tx statistic")
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index ebe96a85ca9e..14c0dd31387a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -160,7 +160,7 @@ struct mt7996_mcu_all_sta_info_event {
 	u8 more;
 	u8 rsv2;
 	__le16 sta_num;
-	u8 rsv3[2];
+	u8 rsv3[4];
 
 	union {
 		struct {
-- 
2.43.0



