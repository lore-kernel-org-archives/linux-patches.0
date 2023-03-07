Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0066FBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E28C433EF;
	Tue,  7 Mar 2023 17:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209216;
	bh=TVRUv4I2oZngPSvgikGd3K51JQpnfAyuNvCsFPqbE1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWneAqzdXZlfbzDYd/L/MFK4CRRGqUycWqAj1WOfB2wp5LQtQf6L+TAUXBa2uv8Ms
	 97vfYvWCq1crM7Zvm0068GAewyY4fUd0dsKrGNyJh444Qe+r0rYT+cMql2HwByU6AI
	 TcHT04OGWGH9xIGHQ0CRD7aZ0mkRnRBtWChuJRaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	coverity-bot <keescook+coverity-bot@chromium.org>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0147/1001] wifi: mt76: mt7921: resource leaks at mt7921_check_offload_capability()
Date: Tue,  7 Mar 2023 17:48:39 +0100
Message-Id: <20230307170028.432188602@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 47180ecf4541146836c5307c1d5526f8ac6a5a6d ]

Fixed coverity issue with resource leaks at variable "fw" going out of
scope leaks the storage it points to mt7921_check_offload_capability().

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527806 ("Resource leaks")
Fixes: 034ae28b56f1 ("wifi: mt76: mt7921: introduce remain_on_channel support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 542dfd4251290..d4b681d7e1d22 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -175,7 +175,7 @@ u8 mt7921_check_offload_capability(struct device *dev, const char *fw_wm)
 
 	if (!fw || !fw->data || fw->size < sizeof(*hdr)) {
 		dev_err(dev, "Invalid firmware\n");
-		return -EINVAL;
+		goto out;
 	}
 
 	data = fw->data;
@@ -206,6 +206,7 @@ u8 mt7921_check_offload_capability(struct device *dev, const char *fw_wm)
 		data += le16_to_cpu(rel_info->len) + rel_info->pad_len;
 	}
 
+out:
 	release_firmware(fw);
 
 	return features ? features->data : 0;
-- 
2.39.2



