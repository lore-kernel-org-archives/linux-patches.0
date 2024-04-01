Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A36C1EB37;
	Mon,  1 Apr 2024 16:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989445; cv=none; b=N/PUd28EIdNCLW8xt5Hz29SZCQ9CXFyCiOroc/FhLk1fVb0iXqQTbXG7VBAfR1ItdtXPjV+/mfzoMw2V7d6Kt+1/g0gwHUu9gFN7QxsU7Qm+rqs0eWTQvMvKYK+ym5QObyY5jiMhYxS/opxQPKXq4TxL6hll+cbr7qQp4ZKoAlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989445; c=relaxed/simple;
	bh=k2rOvLgW7lFXQTW1KE2Zal1/a7omI7j14wielRHscjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K29UGFBeYUixxvA26eEEmgOvpz+VyGg4sL4ttg/get4Li5TASfiatJgHKpoPFSRWGcG/p5T0YXI1Ihaz360MmXtD/29kQQBvWqHJknH6fy54na2/UCsM5vhTcvAA0ES7obKv3uzC+tbqmUNUhp6wc7mgTwKHZ9Rks+VeUsA/efg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3Spe3WO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3Spe3WO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE3FC43390;
	Mon,  1 Apr 2024 16:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989445;
	bh=k2rOvLgW7lFXQTW1KE2Zal1/a7omI7j14wielRHscjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3Spe3WOGDtmPImtpmqGeuhh9/fLaHCzbiw0Zcn53UEbqakd/PMAxPWbjk0TpUC3H
	 KR8Ah2mCXVnSugPVUDWVXCeuMCY2oaHDAU7I0YsMjo/nMTBGZzzSSf0ACB4fRE5ray
	 SYkMzQU8vrSX3b1Hs/AeeNl76JhcIOf+gsEyaTX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Stable@vger.kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/396] mtd: rawnand: meson: fix scrambling mode value in command macro
Date: Mon,  1 Apr 2024 17:41:39 +0200
Message-ID: <20240401152549.417468594@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arseniy Krasnov <avkrasnov@salutedevices.com>

[ Upstream commit ef6f463599e16924cdd02ce5056ab52879dc008c ]

Scrambling mode is enabled by value (1 << 19). NFC_CMD_SCRAMBLER_ENABLE
is already (1 << 19), so there is no need to shift it again in CMDRWGEN
macro.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: <Stable@vger.kernel.org>
Fixes: 8fae856c5350 ("mtd: rawnand: meson: add support for Amlogic NAND flash controller")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240210214551.441610-1-avkrasnov@salutedevices.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/meson_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index a506e658d4624..439e9593c8ed1 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -63,7 +63,7 @@
 #define CMDRWGEN(cmd_dir, ran, bch, short_mode, page_size, pages)	\
 	(								\
 		(cmd_dir)			|			\
-		((ran) << 19)			|			\
+		(ran)				|			\
 		((bch) << 14)			|			\
 		((short_mode) << 13)		|			\
 		(((page_size) & 0x7f) << 6)	|			\
-- 
2.43.0



