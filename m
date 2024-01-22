Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA3414D42C;
	Tue, 23 Jan 2024 00:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969291; cv=none; b=CUpTUd5fClmPtDYWC+VDvdXkdgltQd4Qxqr6mUN0mDxwpq78hZSXkIxjrx6sy23NnYh5KxR7BSrBvj3Ej/BX12S7IffN2HQ8cgQWACMtInLJwwZTzjFPCyWiS+FPKaMntnCjDl+1JiJ0hNQWHT33FrXzYxLcDkrhR/ynGLoomx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969291; c=relaxed/simple;
	bh=FMwU3Bxy9shFNtQD5WYN984EFK0ZHjaXR1jDwQArY6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Exn0Tpp8rKkeuMZ0rffT8Ip83oAb5VkUNmvzR745aJuavP4iDH8vrgXH/6y/tTSKOdt5yhOooLa5XEgdKlVRIVIF5RfuIfoaAl1RktmnrL+VHofE+VujG28NqWRBLhLhDZEOQU2sb9+OEkGjnyxQwvx9QzGt7Goh9c2677NCPJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oICdKBc2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oICdKBc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD1BC433F1;
	Tue, 23 Jan 2024 00:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969290;
	bh=FMwU3Bxy9shFNtQD5WYN984EFK0ZHjaXR1jDwQArY6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oICdKBc2uSbqt7DvZ6PgonogPcR0C3UIQmLqiw3Hd/mkCvXKrwsJhZSX5anWjl8El
	 80EqtnpC3ZsHL3RUPab6boVtZO5Ca3jrXdH1dxlQgDxO5Lp7AUMMPz6nOPK/VhGO0j
	 +7hYuSN4crE0efQjX6ASXDlOHhxJSg2WJrrTu8ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sujuan Chen <sujuan.chen@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 149/641] wifi: mt76: mt7996: fix the size of struct bss_rate_tlv
Date: Mon, 22 Jan 2024 15:50:53 -0800
Message-ID: <20240122235822.702298900@linuxfoundation.org>
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
index a88f6af323da..ebe96a85ca9e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -247,7 +247,7 @@ struct bss_rate_tlv {
 	u8 short_preamble;
 	u8 bc_fixed_rate;
 	u8 mc_fixed_rate;
-	u8 __rsv2[1];
+	u8 __rsv2[9];
 } __packed;
 
 struct bss_ra_tlv {
-- 
2.43.0



