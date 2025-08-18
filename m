Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DDA31CA6E;
	Mon, 18 Aug 2025 13:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524007; cv=none; b=B3lG8VX5VVeuubuICJxHQYhzKbhrKPlRg91+vKJ9PiWDrsB3iCll/ZBMIbFswc9K4bfeSNbgnU4hgChMzltANjS3hvGrXF5ECWO7Zkd2FVDzGBjr0zEbcqEV5py3FyS4BDUhUFLltuqv3bZFINLAUKJOWUSPiWN+M66VC9Ih5XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524007; c=relaxed/simple;
	bh=Xjp9ATl8+FscIJ/rOlI19c5wwOld3ZCF8YYuAsWkNqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOXGuKfk7jnPWktsGbVNRghk3WHeyRg7F8tgYjsNGZzm0evTI5tLhB7zMjnxrRp25TARN7/2Faub2br3KLoQVDUPnSRwe0kPtlQwGJqU8kocXZkIe0Ro+l5pvjj99xQbsyLOQ5HoSTsigAEjFGe7i/bHs36idappygnKeijE2V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xJIituxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJIituxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BD6C4CEEB;
	Mon, 18 Aug 2025 13:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524006;
	bh=Xjp9ATl8+FscIJ/rOlI19c5wwOld3ZCF8YYuAsWkNqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xJIituxmynQlVaPgqH6QJi3E5skkEnEeFqQE2SElvAGgYw2HmRAsb1tO32CbcD1vg
	 ZhxuzfZBGsGcF5tO1FqmtK7Ni3j94UbrbNniJJ4GIDBJ/Nycw1J87yVR0HQBxhUQGm
	 SdHJ6TyhakCzfVNJo4om0W09nd+LZ0q/BKf/9L1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Geraldo Nascimento <geraldogabriel@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 340/515] phy: rockchip-pcie: Properly disable TEST_WRITE strobe signal
Date: Mon, 18 Aug 2025 14:45:26 +0200
Message-ID: <20250818124511.519851111@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geraldo Nascimento <geraldogabriel@gmail.com>

[ Upstream commit 25facbabc3fc33c794ad09d73f73268c0f8cbc7d ]

pcie_conf is used to touch TEST_WRITE strobe signal. This signal should
be enabled, a little time waited, and then disabled. Current code clearly
was copy-pasted and never disables the strobe signal. Adjust the define.
While at it, remove PHY_CFG_RD_MASK which has been unused since
64cdc0360811 ("phy: rockchip-pcie: remove unused phy_rd_cfg function").

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Geraldo Nascimento <geraldogabriel@gmail.com>
Link: https://lore.kernel.org/r/d514d5d5627680caafa8b7548cbdfee4307f5440.1751322015.git.geraldogabriel@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-pcie.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-pcie.c b/drivers/phy/rockchip/phy-rockchip-pcie.c
index bd44af36c67a..63e88abc66c6 100644
--- a/drivers/phy/rockchip/phy-rockchip-pcie.c
+++ b/drivers/phy/rockchip/phy-rockchip-pcie.c
@@ -30,9 +30,8 @@
 #define PHY_CFG_ADDR_SHIFT    1
 #define PHY_CFG_DATA_MASK     0xf
 #define PHY_CFG_ADDR_MASK     0x3f
-#define PHY_CFG_RD_MASK       0x3ff
 #define PHY_CFG_WR_ENABLE     1
-#define PHY_CFG_WR_DISABLE    1
+#define PHY_CFG_WR_DISABLE    0
 #define PHY_CFG_WR_SHIFT      0
 #define PHY_CFG_WR_MASK       1
 #define PHY_CFG_PLL_LOCK      0x10
-- 
2.39.5



