Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FE214B959;
	Wed,  5 Feb 2025 14:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765717; cv=none; b=TnrRdHCksS/OBj/M8FB98vD2dOxOb6w0aSqKthDP+4hL6m3y7OM0Xsh8dG9CY00Hq3nJbh8r/LEocjbsMBrGXwLI6J9+cj0oRvnwNkIHaBGpRdTSUBCUI+vJ7DKGOdunB1QKWEbu3FLbf/Ftd8RWYV9Y6X15FAYArx34pudSmSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765717; c=relaxed/simple;
	bh=oUZSv87kMfzGZY/he1gmFLiHpyl5uj7rczah5zmJ4TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+KMP6FOVMsWnyzXKsyd8oWOnfEM6ZAV//6fPLec1ZukSi6d1RNFmxQpg3kCJUBJy71f3+xMG3dS/vXsOAOO953QpUPdyxJnZjkBEfRC9SPKAxl4yHBaIhKWREFEpU/lrtdw9zBBvI9Fa0mX72nhPQ893zAIEhf0UEdBwe9uRIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UeqO7pg7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UeqO7pg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21B8C4CED1;
	Wed,  5 Feb 2025 14:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765717;
	bh=oUZSv87kMfzGZY/he1gmFLiHpyl5uj7rczah5zmJ4TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UeqO7pg7v2o87pgx7OMc6UyUrA+llEdN1QvtDIU+Sk4L924nHeOk+R2BEvYvDvRUB
	 ktuTQV69Cvz/wxaXFDlG96LdkYPmX+rbQd8z48tatM6sLM+MJY+Gu3BzKcoqI0Le2n
	 JB2LyBzq5jGvW3eNLPXgjrzNvfT9qakhmveeLpU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shengyu Qu <wiagn233@outlook.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 207/623] wifi: mt76: mt7915: fix register mapping
Date: Wed,  5 Feb 2025 14:39:09 +0100
Message-ID: <20250205134504.148420921@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 44e112b8b5b36..2e7604eed27b0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
@@ -484,7 +484,7 @@ static u32 __mt7915_reg_addr(struct mt7915_dev *dev, u32 addr)
 			continue;
 
 		ofs = addr - dev->reg.map[i].phys;
-		if (ofs > dev->reg.map[i].size)
+		if (ofs >= dev->reg.map[i].size)
 			continue;
 
 		return dev->reg.map[i].maps + ofs;
-- 
2.39.5



