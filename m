Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5047563B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3603C433EF;
	Mon, 20 Feb 2023 13:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900495;
	bh=ajj83f9+ELHNoozrWSpbI6Bbm11cWGoPv67RrFru4SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LB22A6B+4FPer7jRVXohHoK+ROtI44IPpbG6k1NWgWHyTaChvTBa1/3iRzgYWD3XT
	 OTp2EhEQRvoc9rzEf3ECdnX3iDj7nFxPLGLgcfnW0qXRST3BRlo4D4Ez+ajBoHNMb3
	 YKJKEIaFd5YHw/rQ72u5WdSf6GMqkF/JOaWCDmC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 46/89] net: phy: add macros for PHYID matching
Date: Mon, 20 Feb 2023 14:35:45 +0100
Message-Id: <20230220133554.758402527@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit aa2af2eb447c9a21c8c9e8d2336672bb620cf900 ]

Add macros for PHYID matching to be used in PHY driver configs.
By using these macros some boilerplate code can be avoided.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 69ff53e4a4c9 ("net: phy: meson-gxl: use MMD access dummy stubs for GXL, internal PHY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/phy.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 42766e7179d38..86a3792c568c2 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -667,6 +667,10 @@ struct phy_driver {
 #define PHY_ANY_ID "MATCH ANY PHY"
 #define PHY_ANY_UID 0xffffffff
 
+#define PHY_ID_MATCH_EXACT(id) .phy_id = (id), .phy_id_mask = GENMASK(31, 0)
+#define PHY_ID_MATCH_MODEL(id) .phy_id = (id), .phy_id_mask = GENMASK(31, 4)
+#define PHY_ID_MATCH_VENDOR(id) .phy_id = (id), .phy_id_mask = GENMASK(31, 10)
+
 /* A Structure for boards to register fixups with the PHY Lib */
 struct phy_fixup {
 	struct list_head list;
-- 
2.39.0



