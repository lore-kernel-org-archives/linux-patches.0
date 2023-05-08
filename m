Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3B2168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1096AC433EF;
	Mon,  8 May 2023 10:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540240;
	bh=yAL749hsSqszIfiksmwunE4Nu8vEw9qA1wqbLM9Osdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxti1MKCVxQUlgraw1bYkB0e5ZZ9VSglZdGI90LJjTeIaQu2is71T1Cg1jkoKpIAb
	 y4N8aZIbDKM0wB5iVo2y+DZNfkPqwRPVuOHBcZzosN8OpYFIk7bnLs9f2d9+a1+r3D
	 VZa/95uVSbBkw3eyXPGzWbBD+/uz4339Br8C1/I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 290/611] net: dsa: qca8k: remove assignment of an_enabled in pcs_get_state()
Date: Mon,  8 May 2023 11:42:12 +0200
Message-Id: <20230508094431.820025459@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 9ef70d0130f282638b28cfce24222f71ada00c9c ]

pcs_get_state() implementations are not supposed to alter an_enabled.
Remove this assignment.

Fixes: b3591c2a3661 ("net: dsa: qca8k: Switch to PHYLINK instead of PHYLIB")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/E1pdsE5-00Dl2l-8F@rmk-PC.armlinux.org.uk
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index fbcd5c2b13aeb..7a6166a0c9bcc 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1365,7 +1365,6 @@ static void qca8k_pcs_get_state(struct phylink_pcs *pcs,
 
 	state->link = !!(reg & QCA8K_PORT_STATUS_LINK_UP);
 	state->an_complete = state->link;
-	state->an_enabled = !!(reg & QCA8K_PORT_STATUS_LINK_AUTO);
 	state->duplex = (reg & QCA8K_PORT_STATUS_DUPLEX) ? DUPLEX_FULL :
 							   DUPLEX_HALF;
 
-- 
2.39.2



