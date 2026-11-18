Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031151;
	b=suEZwT+IsD6mVyGryZQoX3BtHylrkYhAULFZneOMqpx7iuzZVh0wNb0VVhzjk6/pO1cV
	 fgICev1uiNwSbJUwnGOHu47P+2nyyB/4OUmryhukbPpGLx+WCpLPnQQKkMVSdxk23Kq0r
	 JzKYZor4INiLq0CKSZRZ+DPfsedOWAk4YbVfPxHxSf40AWipYij0HPTFohNMeU46CtoMZ
	 1RNBXMEN5cnvZpivS6YZBs/FH4tDFclpqnoAhOP+01boXGUSJT3hGm+TUAO1g7sDtmj50
	 wEdkR/OJwE+eWXfCr+Ac9oF2OB9f/xYebOKJrr/OOGGuPkS2/fHSGyfrfDt3F6NVJTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RYql7Fwh4SSFrXqun2dEL5EElXTjmwM+flbvwVfp6w8=;
	b=kqYVESDXDtN/6/EzJ2ozce0ip3oZW9/xwXb5kMI9IJdCjKXtIE6Y2hdtntaoKg1voe8I
	 DxWHRoKlOxAEptS/mSWxK+pmGjdkE2lyOk3ShsHtOTJmlnaNIFujHttRlwxhfXTZF41wB
	 xhSe43Zvsegw74j5qeTSbt9lFaM1C0FWmWGzC+nKt4ieGfyowAUT6fbqs2P7jQOW08E2u
	 7obDIdQrS5b72u7J+3gZKTzyzBs+PAHqD4naWc86z8iyx2UJBtNdrAPnf+gHtVxj5fhDz
	 JB1hbI/sRyZYnsAr40V3eG5gop7JL0CId8T4TRMa63FTfAds+qcHmiJCAwW/m9IjEHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LNCTF6Kk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF92606A334;
	Wed, 18 Nov 2026 19:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LNCTF6Kk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D516D1F000C6;
	Wed, 18 Nov 2026 19:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031151;
	bh=RYql7Fwh4SSFrXqun2dEL5EElXTjmwM+flbvwVfp6w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LNCTF6KkVveu7B53LuPHYab9JhjYGRIMHhMjvYenGKd8/Y4lKx7RczLmOfA99lhX7
	 S0RS5+8fWifJlkLpUERRvEOv81k6Paq97wlh6deq82GNkzJtc45ymyTn1KgRd3WydE
	 tsTaa+UGqyDolkO34YE1NbJ2+UkpFJVxKZqGD5/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0956/1756] wifi: mt76: mt7925: restore the reset state when fw_pmctrl fails
Date: Wed, 18 Nov 2026 15:51:23 +0100
Message-ID: <20261118150048.131885822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 8d2f5990cd429a2fe5fff05f7acf84d6799d4324 ]

mt7925e_mac_reset() returns directly when mt792xe_mcu_fw_pmctrl()
fails, leaving MT76_RESET set and the TX worker parked. Every other
error path jumps to out, which clears both. mt7925_mac_reset_work()
clears neither, so once every reset attempt fails there, TX stays
blocked until another reset succeeds.

Jump to out instead.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Link: https://patch.msgid.link/20260827162115.1449757-1-nbd@nbd.name
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
index 4587bf849a354..db0567177a2f5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
@@ -122,7 +122,7 @@ int mt7925e_mac_reset(struct mt792x_dev *dev)
 
 	err = mt792xe_mcu_fw_pmctrl(dev);
 	if (err)
-		return err;
+		goto out;
 
 	err = __mt792xe_mcu_drv_pmctrl(dev);
 	if (err)
-- 
2.53.0



