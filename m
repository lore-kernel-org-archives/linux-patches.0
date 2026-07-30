Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2788540B360;
	Thu, 30 Jul 2026 14:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421384; cv=none; b=St1wIeGANjIzXo932brLPYsfJc7bep/ee6qN4nNaprMWTYhwAMkllijofo8OYe5XfA/1Y+Qe07gdEvd04hM6TV6QcocBLV1Ju4mEZv9+GMK4CQ3optJxKBgXPZLL7vSFRBnVMMzOcVUl8RRtCmWfLQ77OT7B3PbE0o6u6qz0GrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421384; c=relaxed/simple;
	bh=xbAjFC7c5iDE+PCwn2cKO2dhlnF9wTtrJAN3183zmQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxhZ5sdcQKX+VG/FYs9Nkmpe/xfIlqHCfYIJPHJJhJl+EjvG1EzUmkWhPBaVct4VZ1ZyQSnXR28M3PwgupWcrt5DDmjT4wJTXALwxZHAFPnXIRGags7VLtcMUOFzK8F9TEiMX305iiRPJH83a00p9awsE5W9Q+xg24y8zVizFzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJWM412f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJWM412f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2021F000E9;
	Thu, 30 Jul 2026 14:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421383;
	bh=8sLEcnRfVezgUAqKmbdsIJuVCK+XK6gEx7iIb+U5a8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TJWM412fDH2g/TGEElh86OOPKp0ICkVyMnIM7pdDWsvjnF8UMBfzx8hPH0evXl2p6
	 gbIM4732t5SCjngb4OsT6B8rw7yWqJpib/RDgtZoX6tcgo5s9+BeS54kWCtTS8YDS/
	 G8J4fI09ULx8/aHxDn10gRu0goLwMfuCylljo82c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 078/744] ASoC: amd: ps: fix wrong ACP version string in pci_request_regions()
Date: Thu, 30 Jul 2026 16:05:51 +0200
Message-ID: <20260730141445.929522981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index cccf9d85c860f0..edff7f274a39d5 100644
--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -601,7 +601,7 @@ static int snd_acp63_probe(struct pci_dev *pci,
 		return -ENODEV;
 	}
 
-	ret = pci_request_regions(pci, "AMD ACP6.2 audio");
+	ret = pci_request_regions(pci, "AMD ACP6.3 audio");
 	if (ret < 0) {
 		dev_err(&pci->dev, "pci_request_regions failed\n");
 		goto disable_pci;
-- 
2.53.0



