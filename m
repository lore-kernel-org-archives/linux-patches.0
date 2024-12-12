Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA472210E1;
	Thu, 12 Dec 2024 15:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018228; cv=none; b=cemgVVg0v7bV5G4AHDWAkunzcQ631db1iWFztvKKPLDypnvMaO83NalvmmHvBtVYKxoCefYIBoreNkSprdBYw5VGiaIlJeFHg9p4+ovmFp1psV0CTLc2Bz2JQqEIn64RsgOrz9HUVwIMtIfm1FPenmi4evvw27mLUDVvzcODQzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018228; c=relaxed/simple;
	bh=YUUK0oRypr5OxhAL8lPU5fHgLODDRdVtirP9hMY0784=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4MNWx/b8aJQjYumkQV8kqklCUy8L+V/s7QZ3qm9VQOp5P4neX3ezAu3XIOhrffV9DS70JRgyjf8yeq0hO3uJs7utCq6dalITUwbcYV1kIAunUBKEVSxc72srIWzjl58+NGGnn0nhPeRnDDkTkI/rlFCncvp/3ucAa6bmNh6/fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GiuLEu7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GiuLEu7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F6FC4CECE;
	Thu, 12 Dec 2024 15:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018228;
	bh=YUUK0oRypr5OxhAL8lPU5fHgLODDRdVtirP9hMY0784=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GiuLEu7Fr0LoYN/QzqxS/T7keXisw1ID1SvbV9BrgvgrFtQNrd2/mZSgoxO7nyPOd
	 fvJCLbtYorPyt2+THi61Wgq50XaRO171tdu0oJtkwGAyxfSKZzyEZGKXv2JXmwSY6q
	 VJlC90tG2jgFexKjIK+ED/YiJtT5Q/CYM0wJNVxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengyu Qu <wiagn233@outlook.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 235/356] net: sfp: change quirks for Alcatel Lucent G-010S-P
Date: Thu, 12 Dec 2024 15:59:14 +0100
Message-ID: <20241212144253.904197382@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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
index 4278a93b055e5..e0e4a68cda3ea 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -441,7 +441,8 @@ static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
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



