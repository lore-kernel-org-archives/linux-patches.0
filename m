Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB75C1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE70C433EF;
	Mon, 20 Mar 2023 15:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325501;
	bh=l+Ly64Qp9tCr6CUM0lX6NjmdAOWDFMOQd0OEX8I4liw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPtnm37uPfEpNI6XNklNKOY0z3PjzBewq8sCv154ZgPTLLiQd2N7W4PkrksWeyxJ+
	 u+xbPjMUn5DqegLN2M4w//fKtuO9s1cJONAltEyd1T3hShuBMicva6tOatTQcpEgQk
	 nyA7sTFtUtZbQekc1+dEQLRyFc8H9egKQdqB7O1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 050/211] net: dsa: mt7530: remove now incorrect comment regarding port 5
Date: Mon, 20 Mar 2023 15:53:05 +0100
Message-Id: <20230320145515.332662190@linuxfoundation.org>
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

From: Arınç ÜNAL <arinc.unal@arinc9.com>

[ Upstream commit feb03fd11c5616f3a47e4714d2f9917d0f1a2edd ]

Remove now incorrect comment regarding port 5 as GMAC5. This is supposed to
be supported since commit 38f790a80560 ("net: dsa: mt7530: Add support for
port 5") under mt7530_setup_port5().

Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Link: https://lore.kernel.org/r/20230310073338.5836-1-arinc.unal@arinc9.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 003672d71a3bf..9876aedc0f360 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2206,7 +2206,7 @@ mt7530_setup(struct dsa_switch *ds)
 
 	mt7530_pll_setup(priv);
 
-	/* Enable Port 6 only; P5 as GMAC5 which currently is not supported */
+	/* Enable port 6 */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
 	val |= MHWTRAP_MANUAL;
-- 
2.39.2



