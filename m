Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44EF50253;
	Tue, 23 Jan 2024 01:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974710; cv=none; b=lV5DNGuZWg59j8GjrvRUHp8X87ioByweMag3YUJwmpnM68okVL5ZHuehnABkobdV8QiubsI70YIJ1JJMYB9rlQWnt4MJZvMr+R3os3225/eaBqIQjr8LGUqOS+1UHADfEUrJ1zvtHtUSnBcTr4lm8Iu7py3SXeh/5hsWS+qXSuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974710; c=relaxed/simple;
	bh=L2CNNZYzOPkhexrBBSrgqN+HfBBKGx+MMTYNULhPmpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVHQ5f0uRJZ4rFhMw0RY2MyGgfYNnVp5jlhkQprVVTZiubc4/VvpasP2nGgo7z4ip9TNQwf8T/WHkmvsqhdhxl5MfRAZ9zrGdzX75pwQkw7SUA5UZ2/GuGe3bg2EG7k3SBkTU//s1rA33MRyxWKlWQOd2lXtgKdILmtPdu95nVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2m2w6gba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2m2w6gba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC06AC433F1;
	Tue, 23 Jan 2024 01:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974709;
	bh=L2CNNZYzOPkhexrBBSrgqN+HfBBKGx+MMTYNULhPmpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2m2w6gba+UwyiVg2C1hrjRAukOKcLLM4e/DdmKrZXUdYIPK0h/GTnNMK1kSNo98Lr
	 +8soUNvJu09qmfNWKYVvi/UJPgl+lgPjYOytY6Fhw4J1uItng7xsoA4WsvZAkfsHiw
	 zUbK3mNtJsjPSP7ovFSetH11Tj7lfolonkXO7oFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sujuan Chen <sujuan.chen@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/583] wifi: mt76: mt7996: fix the size of struct bss_rate_tlv
Date: Mon, 22 Jan 2024 15:53:08 -0800
Message-ID: <20240122235816.304307117@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Sujuan Chen <sujuan.chen@mediatek.com>

[ Upstream commit 4aa9992674e70074fce450f65ebc95c2ba2b79ae ]

Align the format of struct bss_rate_tlv to the firmware.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index e4b31228ba0d..dc8d0a30c707 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -221,7 +221,7 @@ struct bss_rate_tlv {
 	u8 short_preamble;
 	u8 bc_fixed_rate;
 	u8 mc_fixed_rate;
-	u8 __rsv2[1];
+	u8 __rsv2[9];
 } __packed;
 
 struct bss_ra_tlv {
-- 
2.43.0



