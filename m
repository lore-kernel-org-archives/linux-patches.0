Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CB74F5E0F;
	Thu, 17 Sep 2026 17:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665615; cv=none; b=gKeveTgOCVLIvrTrMcO0BWWW6obxi+L6nwyiGs7bXqjuiNQ3VwAFNT1YGovTqEO8rFnrcvUFQB/c8/nC78QNUr5Yrt6Mm+YkvJQ4KrwWenXEWPc3/Xp8AM2uYNTN88Z4mYUtRgD/7TeqeIN2pi3ofQqxVwlB3x4vB4bkfGsjYn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665615; c=relaxed/simple;
	bh=zjxsyCBr3AusmE5fR7EApUTtqXvuuGvB5mMwF/RN2Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uLqLkg3alU0nknX654oFZjNgYT2wvXLTrBjYivuAIZffg3F6/Sn/E9GLCyaeZ181bv+FX1QT+zk1BQIrt1MqF71Oy1y2oABbCPm0jvzdGtyFqrECkh3sfu0Hdp5fgsJ7XL2CjSUXhcZb0Cw47yfALBCraNMPl9xr8nfq3N5AeGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4mx3XNV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4mx3XNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8014A1F00893;
	Thu, 17 Sep 2026 17:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665614;
	bh=cUBdg3S+vC/K7JFlNIQhQ2qbH4PT+OBQhqqC73XeACE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s4mx3XNV78HvPplYAhQYAR/PkBmFmCkvyQtG6cio1GWDwp7Rtn3eWYnjw1zuL2vQI
	 /JvlU9S9U1GzBi22rzX5tf0yiareYH4MT/WngMgPBFOo45nmjfureVXykkzfO/RBK7
	 4vZJh5bTsGZFoQLXQ9WaKYElB5u1TcO11ZTcMebQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0762/1250] ASoC: Intel: avs: Clean up the bus when fetching ML caps fails
Date: Thu, 17 Sep 2026 16:09:17 +0100
Message-ID: <20260917151612.531731672@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 559ea14b7ae7c7562b48759fa545b64958f35b73 ]

snd_hdac_ext_bus_get_ml_capabilities() may fail and its return code
shall be checked and accounted for. Address the issue by updating the
error-path for avs_pci_probe().

At the same time, if the function in question succeeds but the next part
of avs_pci_probe() fails, the hlink list shall be cleaned up before
leaving the scope.

Fixes: 1affc44ea5dd ("ASoC: Intel: avs: PCI driver implementation")
Co-developed-by: Amadeusz Sławiński <amade@asmblr.net>
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260902081814.1590883-5-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/avs/core.c b/sound/soc/intel/avs/core.c
index 6e0e65584c7f8..061d97603abbf 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -473,8 +473,13 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	}
 
 	snd_hdac_bus_parse_capabilities(bus);
-	if (bus->mlcap)
-		snd_hdac_ext_bus_get_ml_capabilities(bus);
+	if (bus->mlcap) {
+		ret = snd_hdac_ext_bus_get_ml_capabilities(bus);
+		if (ret < 0) {
+			dev_err(dev, "failed to get ml capabilities: %d\n", ret);
+			goto err_ml_cap;
+		}
+	}
 
 	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)))
 		dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
@@ -516,6 +521,8 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	snd_hdac_bus_free_stream_pages(bus);
 	snd_hdac_ext_stream_free_all(bus);
 err_init_streams:
+	snd_hdac_ext_link_free_all(bus);
+err_ml_cap:
 	iounmap(adev->dsp_ba);
 err_remap_bar4:
 	iounmap(bus->remap_addr);
-- 
2.53.0



