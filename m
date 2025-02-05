Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA8C282EE;
	Wed,  5 Feb 2025 14:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765225; cv=none; b=qjGpl16urgzVW2xo531qKJMrpWaOfNBulekoemj90RhOwrLMpAVo85ZsqfGhcJhjI8y1Kk7A2J+6yjPnqNnWE9tGGlXisB4PFZSxRKYyIQdFHbUewU/kwMr6OGwmjkfeB53GvQBNBxWn1bNhrPt5Hhg2Qe2KoFTkCgnV2RliuXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765225; c=relaxed/simple;
	bh=HB6ddLAhoJclGfS/zxE9b/2wshvH6P8G1xqbjm4ei8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZjluHhDG4DB0HWVRLw/xAw2HVCnFPCt9hFHg/IRaMQFddE8XkeubxFSZFiwyPZWr4NIayD7Hm7zun1Y7grLYVqMWRnNvCYBtO5TenuW0QS7y/i3qH41tyQuxymygZDa8Vh3/Yx57Tn/qNM+dxBcoY6uHnoD/ZSx7RJVedoOo8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rs/IWzjV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rs/IWzjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8786FC4CED1;
	Wed,  5 Feb 2025 14:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765224;
	bh=HB6ddLAhoJclGfS/zxE9b/2wshvH6P8G1xqbjm4ei8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rs/IWzjVQC0fJQ73Pi7QV0Irn0KGb86cr+Jcrjftac5zhWCPof6fThzCcSWNNyk0p
	 hbXtFH1ByMGxWV06xCqHdELNoEs2w4DIp3ItTkDaTiluCJrEYzUIkjqaeqbodFVmMJ
	 b3AojfTBS95W9gxpJuRSv7bz2mVYbjzrcvOP/rxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shengyu Qu <wiagn233@outlook.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 201/590] wifi: mt76: mt7915: fix register mapping
Date: Wed,  5 Feb 2025 14:39:16 +0100
Message-ID: <20250205134502.970760774@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



