Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251A2257426;
	Thu, 17 Apr 2025 18:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915261; cv=none; b=qCVkQ3CGrUA0md9oZj8sOWpbUWtRcg/HDP6P+zlcJ6OdwLadOUQo3966wG6DDjw0ecVn/VeyEDPl71VMiXKk9oXvigC123e034dn/cRDQih0QZ0KyZoh87HoHFgzTKmn8B+4KLE24kw4MqDn7dVe67CcuJOG7o6zekZg+nSS0cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915261; c=relaxed/simple;
	bh=eqYfotZkv3LovPYAfuFZrTHKerRYrni5mYkAiciouwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YK6vy+iUF2cCwFD2iaxNEmWERux4sDGV4GnNY0JTRe1Jw5hP4sGGfzXkoOf79XfBaXV2KPj4SMx+bOy5KqoHLtq00U9qq1G/cSCmlrFnXqiV7hfojX29/E/d5py/BK8kwCyzbHOEr8T7eignQpDBCF9zjS2TjgnzEKNRLO+04cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dufuq5GQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dufuq5GQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCD9C4CEE4;
	Thu, 17 Apr 2025 18:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915261;
	bh=eqYfotZkv3LovPYAfuFZrTHKerRYrni5mYkAiciouwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dufuq5GQmh8W3/WH5lMggkbvcOXWTIB8VblaT7nKW9D06qyPY9YuuJ573qQhoQqNP
	 usaGumqz7kDdadERxHq14GIricVLMCHusVD1os8kA1611KnfC1yll6QeKO6kLRlYqe
	 v2lZsdjBgriGdw15b7ZZBBTrn2fRnVsXzREuNuoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/393] ASoC: amd: ps: use macro for ACP6.3 pci revision id
Date: Thu, 17 Apr 2025 19:48:00 +0200
Message-ID: <20250417175110.451405277@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 4b36a47e2d989b98953dbfb1e97da0f0169f5086 ]

Use macro for ACP6.3 PCI revision id instead of hard coded value.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20250207062819.1527184-3-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/acp63.h  | 1 +
 sound/soc/amd/ps/pci-ps.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/amd/ps/acp63.h b/sound/soc/amd/ps/acp63.h
index 39208305dd6c3..f9759c9342cf3 100644
--- a/sound/soc/amd/ps/acp63.h
+++ b/sound/soc/amd/ps/acp63.h
@@ -11,6 +11,7 @@
 #define ACP_DEVICE_ID 0x15E2
 #define ACP63_REG_START		0x1240000
 #define ACP63_REG_END		0x125C000
+#define ACP63_PCI_REV		0x63
 
 #define ACP_SOFT_RESET_SOFTRESET_AUDDONE_MASK	0x00010001
 #define ACP_PGFSM_CNTL_POWER_ON_MASK	1
diff --git a/sound/soc/amd/ps/pci-ps.c b/sound/soc/amd/ps/pci-ps.c
index 5c4a0be7a7889..aec3150ecf581 100644
--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -559,7 +559,7 @@ static int snd_acp63_probe(struct pci_dev *pci,
 
 	/* Pink Sardine device check */
 	switch (pci->revision) {
-	case 0x63:
+	case ACP63_PCI_REV:
 		break;
 	default:
 		dev_dbg(&pci->dev, "acp63 pci device not found\n");
-- 
2.39.5



