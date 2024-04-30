Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC9E12D745;
	Tue, 30 Apr 2024 11:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476698; cv=none; b=vC6pZ4mDDVoijaE32Y9z46RInX7KfCW3b2tlgEq+yVIK9QGFSV3XtOGDp5CrkPQHyr9zWqrV+3Hub9303hYrLkB6wTMgvq9sh5f3pkO/gdKeBDArywZTkO8HRGYFcWyRYAjyRpUHbaffXW7z/EFnLf4kokI+xPb5hkLF5zmu4jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476698; c=relaxed/simple;
	bh=DfMsGM0XCF8LhtcD8QYCMs50yhreSuSaLqtcLoC8Fks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaovRho6HXoiGjdX/QpKqVkA0NAQDgrqoz21Cxoc9I+t/AzehtrXC3EItPbVEeQbwu/edsZahxez+IEkvUQObhQ8hwaIBircDJBRH47ywYo8SOP4n0nplFTMTBkBkMpPawFd4z4etaw4JiE2OKt1Cs6xCeNwClXM+Qp5QwrOA/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oOzBrGJa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oOzBrGJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D953EC2BBFC;
	Tue, 30 Apr 2024 11:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476698;
	bh=DfMsGM0XCF8LhtcD8QYCMs50yhreSuSaLqtcLoC8Fks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oOzBrGJa8+AkIt3Rle+5mov29rb4w9gnv/YfwWix2T60ob5bNsyOSWlhmL0tNlra3
	 asXTYpOzNwS9POFqd6Nr2Djf6WkxE44IDBL2KwRxqNa9AjNgJ4U2TM8cnNOIESxWPA
	 irPZvjW8ir/RPO2ISTw43u4PSvyx5oA6qYt37jWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kobuk <m.kobuk@ispras.ru>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/110] phy: marvell: a3700-comphy: Fix hardcoded array size
Date: Tue, 30 Apr 2024 12:41:05 +0200
Message-ID: <20240430103050.407253355@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 392a8ae1bc667..251e1aedd4a6e 100644
--- a/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
+++ b/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
@@ -602,7 +602,7 @@ static void comphy_gbe_phy_init(struct mvebu_a3700_comphy_lane *lane,
 	u16 val;
 
 	fix_idx = 0;
-	for (addr = 0; addr < 512; addr++) {
+	for (addr = 0; addr < ARRAY_SIZE(gbe_phy_init); addr++) {
 		/*
 		 * All PHY register values are defined in full for 3.125Gbps
 		 * SERDES speed. The values required for 1.25 Gbps are almost
-- 
2.43.0



