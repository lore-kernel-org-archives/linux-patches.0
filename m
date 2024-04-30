Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA50F128816;
	Tue, 30 Apr 2024 10:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474599; cv=none; b=poeJTHI+5TnKH/5GpMnkRmmTof+VoOQcBmDErk4hHCtOkY04qaOYTgWLJfLKpJegVhsJsRhVKKSYn43BjM+0Tr6hW9KDkIxGuS4+q4TKTDRgSWPaf5fqyfvwCBoWpv3ybPS2O5SeskxumBhOmBzsxSQHriUyPKBS7z5qy442rSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474599; c=relaxed/simple;
	bh=tVvF6Nf5OTNXNxA3IoMoQ+/Gydnuhce2PUgqhAbFQiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWUhxAIowwf0ZIYEOdX+stla6c85rKKekHAkn/N1xltqErQB20B8PMIGihlNjTjFjzXCiB2J2C3rtnUxNFZzdRVS8qnyxTsgUkhFLxCfa6+YnTK88sU7IyNm/sO/rBWiwRFN7s+WwS1fc8awxfTlr1+XmTyi/BFZ+LYDUWKmUhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xc2KF1Y8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xc2KF1Y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32376C2BBFC;
	Tue, 30 Apr 2024 10:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474599;
	bh=tVvF6Nf5OTNXNxA3IoMoQ+/Gydnuhce2PUgqhAbFQiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xc2KF1Y8pl5WVu1G9ehAbQIyrArj5E3zSgipGjWnFRa8HqDV3P+LIUwdPklPsjlFu
	 3xUaXipinriseT/1KZyMSkq4xjFBAN+RmKXZsaGTSvWyRCZ/oFIUHjB+RlT+iHk0pC
	 5j6qB3thZnESu+4pfhGPXgdNgSzHloS7XMHp2Nxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kobuk <m.kobuk@ispras.ru>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 205/228] phy: marvell: a3700-comphy: Fix hardcoded array size
Date: Tue, 30 Apr 2024 12:39:43 +0200
Message-ID: <20240430103109.716295234@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Kobuk <m.kobuk@ispras.ru>

[ Upstream commit 627207703b73615653eea5ab7a841d5b478d961e ]

Replace hardcoded 'gbe_phy_init' array size by explicit one.

Fixes: 934337080c6c ("phy: marvell: phy-mvebu-a3700-comphy: Add native kernel implementation")
Signed-off-by: Mikhail Kobuk <m.kobuk@ispras.ru>
Link: https://lore.kernel.org/r/20240321164734.49273-2-m.kobuk@ispras.ru
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/marvell/phy-mvebu-a3700-comphy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/marvell/phy-mvebu-a3700-comphy.c b/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
index e2d0bf92a9ada..27f221a0f922d 100644
--- a/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
+++ b/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
@@ -603,7 +603,7 @@ static void comphy_gbe_phy_init(struct mvebu_a3700_comphy_lane *lane,
 	u16 val;
 
 	fix_idx = 0;
-	for (addr = 0; addr < 512; addr++) {
+	for (addr = 0; addr < ARRAY_SIZE(gbe_phy_init); addr++) {
 		/*
 		 * All PHY register values are defined in full for 3.125Gbps
 		 * SERDES speed. The values required for 1.25 Gbps are almost
-- 
2.43.0



