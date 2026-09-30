Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A504F30E3;
	Wed, 30 Sep 2026 16:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785271; cv=none; b=fuDgc+5LZVaDpchorJ2FHn+pPUC962FNLHpWm3u5Rt9xl8+2SYBhaKfYtJtyHOVce4Rt/H9nHuNETtFVuNtxLCiV/AeMXng3rBv3AV5In9zq8rxcdKJHi6xbf6vg8oJGzlE2uM1Kt79QhX4J08f4VKWG8xXNxuT89rjIftAmZI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785271; c=relaxed/simple;
	bh=2KaW0F5Bp5YxQvM4ehxgVXZ2mJeQzDaKsmO7m+YjcQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lK/Zxhwwj3FO0QXcP0Wt2Us0KA5+hjy2xo3Q2DbsuAB9mWph3OigMn/8hqVQwhmryhqd0PJNt6JqHhZeFmBOhlNshYoXct7g9aLcPCS8v6HjZF8Ptb/YwNvlL8i79D8veQiSSr722Ix5y8EEGrwNF67uwR5TVMEbTHRrslbBFQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxcCQMXl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxcCQMXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0444F1F00893;
	Wed, 30 Sep 2026 16:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785265;
	bh=O+XgyBvNUXridHT6v1Z8/zuWVU8wqQa7z6w4naGbZvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zxcCQMXlH0HAqPg0s4qvP+OMNGuTwP0Wtc36tHYMo9mE5n/EvDhf5YIMiWCNm5aBS
	 1pNdLLX6QL+c7rtx3LqeEfAzfOWzCSJps+nXoNbehnvpWmjFIJ/EzSFxNkjFHg+hNp
	 azPymW/tdUpD6MXi5+M2g6i9wMM1agal7SgA95sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 403/982] ASoC: Intel: avs: Clean up the bus when fetching ML caps fails
Date: Wed, 30 Sep 2026 17:18:59 +0200
Message-ID: <20260930152425.466153278@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 44e5d2ed2b95a..102acaa545902 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -438,8 +438,13 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
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
@@ -469,6 +474,8 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
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



