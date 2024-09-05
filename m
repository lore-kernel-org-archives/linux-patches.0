Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7F3155730;
	Thu,  5 Sep 2024 09:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529827; cv=none; b=sTpjdHUM+NEyLnJl51eNmuis3thaseY5l4oQZ1s3kl2hyaFktqHL3a2P1+nNSAwQkglkZZft2Gqp2J6oTodG5hhDkmpprEC7BKVYZikR+2QK7m3Ly28AzY8kDXFBXcekmTGFbja4A4Dq3qjbBOcRJSZsKcpY+QERSxwXwyu88+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529827; c=relaxed/simple;
	bh=kolo9BdF1iEstNfE3dRPXqcs2tfLa75YXv+vVtDp+Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUJBUA2Rru8jjbOTkfQwMBLTjwOA4KVkQXcBqV1xLJGIa5XIRqbv8FXPQAGZByr0/eLdPCFuM7cOuGePkx/1c5iWhnAumqfqGEWXm0J7cTJR4ILC/gua3VfDlP89epMbhKG9PSWWHv4YNNTAXnJ+RItzh3rcj6pDTUtUJCW+DZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQeBFfIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQeBFfIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429ABC4CEC3;
	Thu,  5 Sep 2024 09:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529827;
	bh=kolo9BdF1iEstNfE3dRPXqcs2tfLa75YXv+vVtDp+Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQeBFfIe+vo8MI73FAlYe25Z0DJz7Awwy7cWQs2NZfsRfTsM4iyM4ut4VIwufZkeW
	 ddM9K7hkYQc+q8Jv0jdaLXInFJFtKZGB+qDs8RknmWRqXY71PrMRx8clXWBuR1VaO7
	 iHdmaIyqf59rL7f8Qv/OUPbyTnK7W7Q7IqJ3VnOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.10 153/184] pinctrl: renesas: rzg2l: Validate power registers for SD and ETH
Date: Thu,  5 Sep 2024 11:41:06 +0200
Message-ID: <20240905093738.311845805@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit a3a632ed87f0913779092c30bd0ea7dfd81601f3 ]

On RZ/V2H(P) SoC, the power registers for SD and ETH do not exist,
resulting in invalid register offsets.  Ensure that the register offsets
are valid before any read/write operations are performed.  If the power
registers are not available, both SD and ETH will be set to '0'.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com> # on RZ/G3S
Link: https://lore.kernel.org/r/20240530173857.164073-7-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index 60be78da9f52..389602e4d7ab 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -2583,8 +2583,10 @@ static int rzg2l_pinctrl_suspend_noirq(struct device *dev)
 	rzg2l_pinctrl_pm_setup_dedicated_regs(pctrl, true);
 
 	for (u8 i = 0; i < 2; i++) {
-		cache->sd_ch[i] = readb(pctrl->base + SD_CH(regs->sd_ch, i));
-		cache->eth_poc[i] = readb(pctrl->base + ETH_POC(regs->eth_poc, i));
+		if (regs->sd_ch)
+			cache->sd_ch[i] = readb(pctrl->base + SD_CH(regs->sd_ch, i));
+		if (regs->eth_poc)
+			cache->eth_poc[i] = readb(pctrl->base + ETH_POC(regs->eth_poc, i));
 	}
 
 	cache->qspi = readb(pctrl->base + QSPI);
@@ -2615,8 +2617,10 @@ static int rzg2l_pinctrl_resume_noirq(struct device *dev)
 	writeb(cache->qspi, pctrl->base + QSPI);
 	writeb(cache->eth_mode, pctrl->base + ETH_MODE);
 	for (u8 i = 0; i < 2; i++) {
-		writeb(cache->sd_ch[i], pctrl->base + SD_CH(regs->sd_ch, i));
-		writeb(cache->eth_poc[i], pctrl->base + ETH_POC(regs->eth_poc, i));
+		if (regs->sd_ch)
+			writeb(cache->sd_ch[i], pctrl->base + SD_CH(regs->sd_ch, i));
+		if (regs->eth_poc)
+			writeb(cache->eth_poc[i], pctrl->base + ETH_POC(regs->eth_poc, i));
 	}
 
 	rzg2l_pinctrl_pm_setup_pfc(pctrl);
-- 
2.43.0



