Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEC8205501;
	Thu, 12 Dec 2024 16:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021220; cv=none; b=hVWpZK74ofqn2OHyMQygGDzmrbLZAXCkMmg8ij8ug+wCjdUtJIHuX22Dltqv/KEMwuz6j+5C5J45KtstE2TkOgINX03MKlFC3PDjKsq6iYax0/2MkJ1Z+MQagRKkXxyrer0mS5Spp3C3Xuv0bYvDK29Fb7SsAea8piEjLxbT8PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021220; c=relaxed/simple;
	bh=VvaUJW1klt3ugoPH9rCxfFhUYkfcdexXnen5ZLcTWAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCAfsNeexm3FH4n+wkXrpKktDbOLLslBHHs0MHtsy+3Wc8GatJgUGpHTG4Di18VKPQ+LNxKHqzkRYvqqwvUGMGHQIG71PfAmSqYKjEBQ80mD9nzvmRADDd0sTKc916Pl2+QfRwSbT+M+z8HeT3r8sUo0AX/pB+gva0BuVEviMvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNltkFmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNltkFmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A46C4CECE;
	Thu, 12 Dec 2024 16:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021219;
	bh=VvaUJW1klt3ugoPH9rCxfFhUYkfcdexXnen5ZLcTWAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNltkFmh0Eo1mLw+fcgY4+4vGycdVhPQJLyzpqEsPF53bWXL74c+n2Sp/ppDlX/qb
	 /KyK3mAbvmkgzDaR1IjMNVM8nkrOnpz74sx/bFTY5kDVO7t4sRJo72FC/FOOCOtLsd
	 kKbc2xPzKecd1Xaj3qwQrmlS3tdZTKIm9AEsaXsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengyu Qu <wiagn233@outlook.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 677/772] net: sfp: change quirks for Alcatel Lucent G-010S-P
Date: Thu, 12 Dec 2024 16:00:22 +0100
Message-ID: <20241212144417.893861175@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Shengyu Qu <wiagn233@outlook.com>

[ Upstream commit 90cb5f1776ba371478e2b08fbf7018c7bd781a8d ]

Seems Alcatel Lucent G-010S-P also have the same problem that it uses
TX_FAULT pin for SOC uart. So apply sfp_fixup_ignore_tx_fault to it.

Signed-off-by: Shengyu Qu <wiagn233@outlook.com>
Link: https://patch.msgid.link/TYCPR01MB84373677E45A7BFA5A28232C98792@TYCPR01MB8437.jpnprd01.prod.outlook.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 06dce78d7b0c9..0666a39dc4859 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -386,7 +386,8 @@ static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
 static const struct sfp_quirk sfp_quirks[] = {
 	// Alcatel Lucent G-010S-P can operate at 2500base-X, but incorrectly
 	// report 2500MBd NRZ in their EEPROM
-	SFP_QUIRK_M("ALCATELLUCENT", "G010SP", sfp_quirk_2500basex),
+	SFP_QUIRK("ALCATELLUCENT", "G010SP", sfp_quirk_2500basex,
+		  sfp_fixup_ignore_tx_fault),
 
 	// Alcatel Lucent G-010S-A can operate at 2500base-X, but report 3.2GBd
 	// NRZ in their EEPROM
-- 
2.43.0



