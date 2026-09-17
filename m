Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B09C50254F;
	Thu, 17 Sep 2026 17:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665012; cv=none; b=j7ykZcy3Sg7LSWqcxWOPZZT2ziMQVXGsJVY7gyqIl5xW1s70k7822bxWNuNbBgvSNFWWe8BqJUFoxwwqHj3UoDZ3IxvNTDMjUmR4GzUn+AnHrpRgHVEzRp2QBb1uqoavhtflFWJ0fvl+kpzifIS1HZWFGXyxRk+O9y8HUtMuiwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665012; c=relaxed/simple;
	bh=VI2hHtmYmBRPM+zN3TMoS33eXuOQyM1ip4OaZrOYZaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWbDAcGi/KNq7jbrlsevZ5tKdLzePdIaLW080GP6aYu8reFZajbnZQqZ66RvHgOM6Z7ez7In50anxlVAL+TRBvm3BapPyCaL+VPzDwc3yqSL1kwHwBndJZCcGOrigwOGPVWdtchrrxzcStmb+p8gcUSg3R7Db+OVjwopv6fyXHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkRuE96z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkRuE96z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C31E1F000FF;
	Thu, 17 Sep 2026 17:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665011;
	bh=Wx61SxgBTr51fY17Me/926ZWTX3J7eRxthqTgKBY3KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NkRuE96z5bXZntFEDQGFCh9RDW2tlJSxsPbLjQVW8AkwPd+Blm5cywTndsW+Q7Mvf
	 NxiooIbFegFgL2Nvb2MHh6KzXaUKdDuBpCfFgnIDpnw6FrhJ86zj0VDX3lykSIeCzB
	 QxueujUXtOwQqQvFpdTWOwYBpl8VC58Xi2Kiy/i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0556/1250] ata: libata-core: Disable LPM on WD Green 2.5 480GB
Date: Thu, 17 Sep 2026 16:05:51 +0100
Message-ID: <20260917151607.001168017@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit d549df8a0ace611bff0a336a907f93420648b462 ]

According to a user report, the WD Green 2.5 480GB has problems with LPM.

Link: https://lore.kernel.org/linux-ide/CAGiKK17Fg4SgS+y0GzD3new44QzD_yPZU5V3ZeHdUr9mFnfn1Q@mail.gmail.com/
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ae1e5f82026c5..a7a89b675a912 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4379,6 +4379,7 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	 */
 	{ "WDC WD100EFGX-68CPLN0",	NULL,	ATA_QUIRK_NOLPM },
 	{ "WDC WD102KFBX-68M95N0",	NULL,	ATA_QUIRK_NOLPM },
+	{ "WD Green 2.5 480GB",		NULL,	ATA_QUIRK_NOLPM },
 
 	/*
 	 * This sata dom device goes on a walkabout when the ATA_LOG_DIRECTORY
-- 
2.53.0



