Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F2F1A3178;
	Thu, 17 Apr 2025 18:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913998; cv=none; b=LJE3cxXT4v89u4cSjjdixTikn+MsHMwrv39AHI/YIEWKGJvST7zb/m69kITAJFoSNUdvm16dDU8KN6FTL+ya1GAUbfaw4jdUU73/e0jwciVOuoYSXMVH4cjpNGqWgDsf5iNwDF40Q5kcm6hEzgH2t3m0INOmI3PeuZP8vj6Csl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913998; c=relaxed/simple;
	bh=6Z4oulzru7oqRi7y6Et5aG0X6GTRzocNUlArun4924c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvVuBlGd9bysIZD/ABrOyUlZWOxckV1GQP9UbyZGaNmrg/KRSWj5RLca+qtOqeZweudK6acUTzbvJwgc90fXP4aP1EQIS+yFz25HGQ+qEZMuhEULBwNZqHsCuM/PINGRPWwzI4nDUkKCf6bb8xVZ32dFENU2XnUPgZGXWXxhqwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X3Yq0DbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3Yq0DbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E225C4CEE4;
	Thu, 17 Apr 2025 18:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913998;
	bh=6Z4oulzru7oqRi7y6Et5aG0X6GTRzocNUlArun4924c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3Yq0DbNT8dV684ZesyspHChq7c2SGjO6zxLZLs0/VKmcOvb2qpFYApvpz5bcCqVt
	 aX7U8B/6niFm/QemQGIHKpiU2mMSnX5hIAjwmQ+Kwdnsp6XDmLB3y6bcZshVWxRi5G
	 C5S6Blc9TnsGt3WYdUrVNOiGlksK2LBWLcVbvWGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 071/414] ASoC: amd: ps: use macro for ACP6.3 pci revision id
Date: Thu, 17 Apr 2025 19:47:09 +0200
Message-ID: <20250417175114.297675606@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index e54eabaa4d3e1..28d3959a416b3 100644
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
index 4575326d06352..b0b4a47cf7c25 100644
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



