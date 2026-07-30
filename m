Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D24331A48;
	Thu, 30 Jul 2026 15:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425459; cv=none; b=L/Cp8+kqvIB9kjnBDPYIA6ll/nkvRVRVcdBR2MndM3xtOQBdyhQYV72c9HXJk2u79jbsbmzTjkaTsWMM0ShNyN8GUuxDw6UnRgJs8adg0HmropVfOiiUWH0eIU1xqSfsW8WUfaE390fyXlHDGUUquTZ+V/c01sVv0C6v3LjIRik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425459; c=relaxed/simple;
	bh=RkRSfvDRB0tgdONlFO7Wct7nzqjKdRMqy05rbqGoKw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psQRKbgFGCi4PKK7W5Td8lwM3ZAJHbeBxHl+km3Jqs2UgWesXNX6yTNkOkple9xnZqILWgZPmEMbyTC6abxnytM/dRgXF9UO6znbnVUWPa62vZfREqXl0k0seAuXDJ5c/2EhCd109/GqU43ooKyP3LuCaWChI5oY9OutzgROcTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrsZfsz1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrsZfsz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4161F00A3A;
	Thu, 30 Jul 2026 15:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425457;
	bh=+0IhReM2k4XRlZuvfGJ5ozZavIKakQ5wmVtP1QFPV+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WrsZfsz1mdiu6uJ2KXc9uOmPYp89/6iOFYqKJK0eOK6LaU9m2MgUKmmd9S3+dmK+r
	 a0wIh3b9tX3m1Fp9r4ejCG7s97CIVzY+nwjAFkqFChWEW84E+Klut1s/XTcuM0Q9J+
	 956pcYuW5x/Sw/WzcYDQ7g8vmEfWQ+c9Q1KHFaiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/602] ASoC: amd: ps: fix wrong ACP version string in pci_request_regions()
Date: Thu, 30 Jul 2026 16:07:47 +0200
Message-ID: <20260730141437.574011207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit f7697ecf6eab9d4887dd731038b3dc405c7e755e ]

The driver handles ACP6.3/7.0/7.1/7.2 platforms but the region was
claimed with the stale name "AMD ACP6.2 audio" left over from the
original ACP6.2 driver. Correct it to "AMD ACP6.3 audio".

Fixes: 95e43a170bb1 ("ASoC: amd: add Pink Sardine ACP PCI driver")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260707060130.2514138-3-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/pci-ps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/ps/pci-ps.c b/sound/soc/amd/ps/pci-ps.c
index aec3150ecf5812..eb4b552c942417 100644
--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -570,7 +570,7 @@ static int snd_acp63_probe(struct pci_dev *pci,
 		return -ENODEV;
 	}
 
-	ret = pci_request_regions(pci, "AMD ACP6.2 audio");
+	ret = pci_request_regions(pci, "AMD ACP6.3 audio");
 	if (ret < 0) {
 		dev_err(&pci->dev, "pci_request_regions failed\n");
 		goto disable_pci;
-- 
2.53.0



