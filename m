Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FDE353A75;
	Sat, 12 Sep 2026 11:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212643; cv=none; b=K5azMBN5JjA+CwOolIQNKO1TEzZ+n8vKd2OtvexBZRE7AN0H9OEZ1lBQxiDSaBCPAobr7BhJBhKt6YKA0W9UfaEORIicugFLvzVw7V/Kq8O23HYLXN8DinTerqBV5gJcHIjje7fsghgXww0eA7MS/Ri5+2Wft+zYOM0kIKYIcJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212643; c=relaxed/simple;
	bh=PyROBf5fMGuBY39PlhPIsTWsgC1f9eHBrR/2aqB2Oz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPYGJijUWQxa9PM9xbhRfiAvuwReKLnnx6Oc/PlXlZfamC7OfHbd4U7BLNVxW/xUPi1saDRW1Wu/GcROL4exG8AEPlpjKvbOkGuJDdjlFD53CcgJ0Vw2fqfaQy4RzOiqT2NZzCxU4tnj75AS0MR/Y7JO5OiAIID3dzaW5/ebmu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJ2GsJsj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJ2GsJsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3919F1F000FF;
	Sat, 12 Sep 2026 11:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212642;
	bh=ojbjSd3Tne4JiA+xiSrbePwpVlex4ZEoBpXXhSJoOZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJ2GsJsjQWqsmvHQVYmfraGCkgoxCgZxPfyoF5TCKdkTVfxhCNRsh3v+CyXPUlNAp
	 s+Favs3c/Vuatnkiyz2yOBOmIdAFfaf6WUCeMsCTqaTO/miyQ0NQ87taqkLbWt4Ngf
	 4wbpJ66HIY5eSHu/8V4GQRzYsJH6G5zmH24/YSjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@airoha.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1479/1518] wifi: mt76: npu: Add missing rx_token_size initialization
Date: Sat, 12 Sep 2026 09:00:48 +0200
Message-ID: <20260912065657.015718267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 25e3203a2192f2b0d697b2410126bad87e62d4f0 ]

Add missing rx_token_size initialization for NPU offloading.

Fixes: 7fb554b1b623 ("wifi: mt76: Introduce the NPU generic layer")
Tested-by: Kang Yang <kang.yang@airoha.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260122-mt76-npu-eagle-offload-v2-2-2374614c0de6@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/npu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/npu.c b/drivers/net/wireless/mediatek/mt76/npu.c
index ec36975f6dc94..9679237f73984 100644
--- a/drivers/net/wireless/mediatek/mt76/npu.c
+++ b/drivers/net/wireless/mediatek/mt76/npu.c
@@ -457,6 +457,7 @@ int mt76_npu_init(struct mt76_dev *dev, phys_addr_t phy_addr, int type)
 	dev->mmio.npu_type = type;
 	/* NPU offloading requires HW-RRO for RX packet reordering. */
 	dev->hwrro_mode = MT76_HWRRO_V3_1;
+	dev->rx_token_size = 32768;
 
 	rcu_assign_pointer(dev->mmio.npu, npu);
 	rcu_assign_pointer(dev->mmio.ppe_dev, ppe_dev);
-- 
2.53.0



