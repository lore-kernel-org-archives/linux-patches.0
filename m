Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8E83F12C6;
	Mon, 17 Aug 2026 15:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979342; cv=none; b=MU8uUSj34jwYpEI25+cJ1rgnL7wxvjzS94kmRqloBMsUYde3UCQotWew5Ll4bvTN/+rmoQeaIeexfZ+2aa7nUkwpo9/DG30qZhWsmi9bzGTlOvhpuAl8+G14OZeSTP5bxx/bLy/wTqsBAvYt80KHJ/hhXlkWQgM9YLD+6hs/AgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979342; c=relaxed/simple;
	bh=O7B1KdOcBeBp4DuRVsBDQAOEojBC0H2Ld/v3nIe1wCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjwNFs1PgL6k/KtQU9ustTAJtglw7yP8NTVmvb1HVPrR1a/RvrCMDP3UITJF17W/xhkf20vwhAcGZhXYRvONTe/a1PXcIYuKNPVAJB45b3pPfG7l7xX+OPp0qbFj9aj2CzXhdPIclBwFYTQCIQUUQHo/e1fYKc3oq80PMn15hmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzBh0iio; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzBh0iio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EF31F000E9;
	Mon, 17 Aug 2026 15:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979340;
	bh=S5VAQYVuuNsvq+TUIURKZKC4mBEvgR+c+ZMJ3u66qJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MzBh0iio7CA3Z+hTdrYrHwrGwg55dHdaqM94iEET3EP1X5gYNlsTIrXZw3VC9ezns
	 xz1usMlBOodXW+DpOESgUlAI/EE/jYA/C5iqz4Fu8asw2vusQcdvdbPNlNRPS5aDGK
	 selR/LPXS9qTmr9FB1qlZvZCDdbS/fnjinlZiUuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan G Thomas <rohan.g.thomas@altera.com>,
	Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Raczynski <j.raczynski@samsung.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/609] net: stmmac: reset residual action in L3L4 filters on delete
Date: Mon, 17 Aug 2026 15:27:30 +0200
Message-ID: <20260817132549.164493702@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>

[ Upstream commit a448f821289934b961dd9d8d0beb006cc8937ba2 ]

When deleting an L3/L4 flower filter entry, the action field is not
reset. If a filter was previously configured with a drop action, that
action may persist and affect subsequent filter configurations
unintentionally.

Clear the action field when the filter entry is deleted.

Fixes: 425eabddaf0f ("net: stmmac: Implement L3/L4 Filters using TC Flower")
Signed-off-by: Rohan G Thomas <rohan.g.thomas@altera.com>
Signed-off-by: Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260714023716.29865-5-muhammad.nazim.amirul.nazle.asmade@altera.com
Reviewed-by: Jakub Raczynski <j.raczynski@samsung.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 6bf198b3f12369..e9aac51c1b9b78 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -671,6 +671,7 @@ static int tc_del_flow(struct stmmac_priv *priv,
 	entry->in_use = false;
 	entry->cookie = 0;
 	entry->is_l4 = false;
+	entry->action = 0;
 	return ret;
 }
 
-- 
2.53.0



