Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08C217E90E;
	Mon, 27 May 2024 19:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836814; cv=none; b=gcemYhOxIvWwoyZOOc87njjHoCbr9Mh9wVapfk12cSdhIoPIvEN26zq9bojlmJImtkOmLxeVA6PToMYgapAubet9frxg4FCqmncX940yR5NeahdkytuLGLwyooVSFu79lP2s/l8LsWuMRZsheRcp7HaVo+cWKGHtxixLXbCv+bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836814; c=relaxed/simple;
	bh=tYYo/cByGVNI7Gg4BpvjN+IVen7jUNkjA8qmG3f3QUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkZpnesG39k8Q/Am4LbPw+D9bc0pIDRSWPplbjmhwd0cL6NiqgupiFHOb+7FX4K6SJTuN92MB1872X85/fNI0+g4lfbfywUj935jDvsyeaclvPYayvURX4kj7yJV49aBZijdHz7TvYuz/PfcCV9ialVbVb41XQJCV5hAq1KIErw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRGpGh5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRGpGh5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F9FC2BBFC;
	Mon, 27 May 2024 19:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836814;
	bh=tYYo/cByGVNI7Gg4BpvjN+IVen7jUNkjA8qmG3f3QUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iRGpGh5wqv2acklNhysU/c479R3MMdHs3gTwl3iaJF19zkBPtbQZ24bP23Is5PMfP
	 pAovoSRfzipER0txFm0ie0XG3odw9q5gWCt3w4bxG4hgl+szfs5BulEjBw2qNKmoi8
	 HsovbdIRritm6XqnLafyB39+x48Ip2878hFOKXiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 199/427] wifi: mt76: connac: check for null before dereferencing
Date: Mon, 27 May 2024 20:54:06 +0200
Message-ID: <20240527185620.839227149@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

[ Upstream commit cb47c7be0e93dd5acda078163799401ac3a78e10 ]

The wcid can be NULL. It should be checked for validity before
dereferencing it to avoid crash.

Fixes: 098428c400ff ("wifi: mt76: connac: set correct muar_idx for mt799x chipsets")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index af0c2b2aacb00..7af60eebe517a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -283,7 +283,7 @@ __mt76_connac_mcu_alloc_sta_req(struct mt76_dev *dev, struct mt76_vif *mvif,
 	};
 	struct sk_buff *skb;
 
-	if (is_mt799x(dev) && !wcid->sta)
+	if (is_mt799x(dev) && wcid && !wcid->sta)
 		hdr.muar_idx = 0xe;
 
 	mt76_connac_mcu_get_wlan_idx(dev, wcid, &hdr.wlan_idx_lo,
-- 
2.43.0



