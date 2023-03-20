Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1951C32
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D10BC433EF;
	Mon, 20 Mar 2023 15:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326191;
	bh=WZcpLRaJ38rETLsEeDRuOU7hG1w5FdMNAeoi3tqxS4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXKO18d1gYlR7e49XoUYdqSzqxTPMcIO7Iwx2P0nrksZUTca6Ak3kmuSU7YfgudIl
	 ACbSph/O/9fo1T/nai5EAKk5Q3DYLl16hnGvx/PMe6WxV46LwoxeJjrK5Y9xaj0gnX
	 JbW8HuoGZOQw7qht+PasXnNI3z3xUhiNf/EWrjv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.2 194/211] net: phy: nxp-c45-tja11xx: fix MII_BASIC_CONFIG_REV bit
Date: Mon, 20 Mar 2023 15:55:29 +0100
Message-Id: <20230320145521.653487824@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>

commit 8ba572052a4b8fe5b205854d27e54e3486049b71 upstream.

According to the TJA1103 user manual, the bit for the reversed role in MII
or RMII modes is bit 4.

Cc: <stable@vger.kernel.org> # 5.15+
Fixes: b050f2f15e04 ("phy: nxp-c45: add driver for tja1103")
Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
Link: https://lore.kernel.org/r/20230309100111.1246214-1-radu-nicolae.pirea@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/nxp-c45-tja11xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -79,7 +79,7 @@
 #define SGMII_ABILITY			BIT(0)
 
 #define VEND1_MII_BASIC_CONFIG		0xAFC6
-#define MII_BASIC_CONFIG_REV		BIT(8)
+#define MII_BASIC_CONFIG_REV		BIT(4)
 #define MII_BASIC_CONFIG_SGMII		0x9
 #define MII_BASIC_CONFIG_RGMII		0x7
 #define MII_BASIC_CONFIG_RMII		0x5


