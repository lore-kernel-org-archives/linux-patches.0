Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C471494DF;
	Wed,  5 Feb 2025 14:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764536; cv=none; b=V+taNtGpOAQ5jKjVsDBH+0jBjFlEyHKFdPEfpNnfe98DliwaorokcANeLLwUbKtfpztZX5/UPMVK8hu6WBRxOQ3+M5KOOeJzAFLiAXb7l0cOd89Z9/J3UJcHLOj7hEljfFaGouZaChHEZN1BM92mRMYNl3CSF1EKYXE0NijLZBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764536; c=relaxed/simple;
	bh=vn6HUnyUANZcYbPGi5nK0TN/k38nzMhtDoR6ansR8lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vu9ekxANUB0ucWdcApVWpAZkNvjLroNffYgSlW1kW7xu2svB40OcB0IAaeLX9KCQ4SJ3J9+du4ZaOaabwYQtTB8TQyTl+lLasOSRXw1ZwO5M2ZG6SuSmC8FkOJCUR+gzzdNC0NT8BOq5QMP3Stb9n38TFzKxwOO3PMA/rrBW7U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4W1dKtZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4W1dKtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24830C4CED1;
	Wed,  5 Feb 2025 14:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764535;
	bh=vn6HUnyUANZcYbPGi5nK0TN/k38nzMhtDoR6ansR8lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4W1dKtZeVg8YwYuCNQUR2zSUSeKXKJeGQNVBiz3H/agWWC06nMfWWEnIkeE5DdfU
	 PPKMKQBWFp/6EP+WD2IlzU4suSokGy819R0wAzPJbzQZRSA1nZ1RWdAFMd3Yl8a8K+
	 fRo+SUqxE9OUQL26kfT8lvJL5zia349wN/GdDOQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 180/393] ASoC: Intel: avs: Do not readq() u32 registers
Date: Wed,  5 Feb 2025 14:41:39 +0100
Message-ID: <20250205134427.188064189@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit bca0fa5f6b5e96c03daac1ed62b1e5c5057a2048 ]

Register reporting ROM status is 4-bytes wide.

Fixes: 092cf7b26a48 ("ASoC: Intel: avs: Code loading over HDA")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250109122216.3667847-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/loader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/loader.c b/sound/soc/intel/avs/loader.c
index fe0340c798efe..5c4ae3927ed24 100644
--- a/sound/soc/intel/avs/loader.c
+++ b/sound/soc/intel/avs/loader.c
@@ -306,7 +306,7 @@ avs_hda_init_rom(struct avs_dev *adev, unsigned int dma_id, bool purge)
 	}
 
 	/* await ROM init */
-	ret = snd_hdac_adsp_readq_poll(adev, spec->sram->rom_status_offset, reg,
+	ret = snd_hdac_adsp_readl_poll(adev, spec->sram->rom_status_offset, reg,
 				       (reg & 0xF) == AVS_ROM_INIT_DONE ||
 				       (reg & 0xF) == APL_ROM_FW_ENTERED,
 				       AVS_ROM_INIT_POLLING_US, APL_ROM_INIT_TIMEOUT_US);
-- 
2.39.5



