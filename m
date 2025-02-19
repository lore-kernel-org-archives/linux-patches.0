Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9779E1E8327;
	Wed, 19 Feb 2025 09:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956158; cv=none; b=WJbYr6hyEAk4wJWjwCbxgZN7JAleLJhnwqWnhNhAEVq5EtXXp0NH6PBNjh1CVIL8tJPzSifh+7KOQe5vAHYJtpqyPUMeLi5P53P8wpO+zWQX8xSdjna5dz0MI//5AAQUNP2GB7P47Ua7YYhKjM75YvcIpLUm6JAm5d4DKclHe9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956158; c=relaxed/simple;
	bh=cFJ0wEMXXEL7ZhYSYkLRaKZZzg/XwN4N5KUOFCUzzCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHJZzKhgFuG8QuR7e+BqNGZl153ZSNj11/h74Up0kHz+ZU7gDUVh9J0ki7cT0FUWm7iwXCKlE3Fcly5KrddIha+VkQU3P2PIwLPyWf6R1LfPqdQUWrkSUtgYXgNwEae9+KfWnHL/+nQy+VfMFcMmW7R2eRoAcefgJoCCwfJtud4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhwxbVWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhwxbVWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6F9C4CED1;
	Wed, 19 Feb 2025 09:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956158;
	bh=cFJ0wEMXXEL7ZhYSYkLRaKZZzg/XwN4N5KUOFCUzzCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhwxbVWnwG7v7dlnNWKfS390s5iOlThShLjp9+EjVCT3mWD30WVjWvNOL5YfFljbu
	 LHyEka4agSz/UqCrIDKKYwRES/yUcZjrdhZ66xcPoMftc8HAZcmBh+MvTV9Lqu+kEI
	 tt9WlErFzFyK56iZwQhSO+/GdRWDBJhyv+e5DiN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shengyu Qu <wiagn233@outlook.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/578] wifi: mt76: mt7915: fix register mapping
Date: Wed, 19 Feb 2025 09:21:29 +0100
Message-ID: <20250219082656.307417804@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit dd1649ef966bb87053c17385ea2cfd1758f5385b ]

Bypass the entry when ofs is equal to dev->reg.map[i].size.
Without this patch, it would get incorrect register mapping when the CR
address is located at the boundary of an entry.

Fixes: cd4c314a65d3 ("mt76: mt7915: refine register definition")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Shengyu Qu <wiagn233@outlook.com>
Link: https://patch.msgid.link/OSZPR01MB843401EAA1DA6BD7AEF356F298132@OSZPR01MB8434.jpnprd01.prod.outlook.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
index bc68ede64ddbb..74f5321611c45 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
@@ -423,7 +423,7 @@ static u32 __mt7915_reg_addr(struct mt7915_dev *dev, u32 addr)
 			continue;
 
 		ofs = addr - dev->reg.map[i].phys;
-		if (ofs > dev->reg.map[i].size)
+		if (ofs >= dev->reg.map[i].size)
 			continue;
 
 		return dev->reg.map[i].maps + ofs;
-- 
2.39.5



