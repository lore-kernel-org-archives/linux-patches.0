Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D40D8634E;
	Wed,  5 Feb 2025 14:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765983; cv=none; b=gpHYKuaLDKQKA87HWndXM1MmGcNbbvwAqPIK6aSMIshBvh7wn0AOwQ8QR9ZM/voWu75p5cZti3limSk6BdfDZWYT8UruKJ17l1x9dS50cmhUgVOwbjWwNExa5MFRpbe03/aVZByGFAQDo0PkdNH+SklMsASx4A3pDAkhTVYYIGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765983; c=relaxed/simple;
	bh=Rd/JUikFIQZ/YQTAxVlV3JPLbRQu6S8GAMBAosSVprI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ws9IrtCkUcr0Wwxq7EpKJ4/s1/68wJ4QZs7qgkbC2JKyNJv3EYfUr0w9IHr3bWFn/qNNiBGaJFvWjzaCOZJ9eW9oFZ2qKStoCh5AaoZaBhiymsl++11EtZlewRhg9gxMn2vKGYcuMubKX7Fo7iU/xTnaIlcI8dZwMpFiZo/o6Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+OBivJE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+OBivJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB2DC4CED1;
	Wed,  5 Feb 2025 14:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765983;
	bh=Rd/JUikFIQZ/YQTAxVlV3JPLbRQu6S8GAMBAosSVprI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+OBivJEVRG5ahvpsUK0l6CsSIjAY41amZj/jvaw38haYzUzK2L/D3/E1mCnjKEue
	 XaDdU8np4KBGV6nYSF4Lq/hO6NbxocTxwNJ5xHoWEjxh3bCuGCipUx/411K73uPigK
	 nkb8zNK+sulQMpombkmNNQocrXpsPmSj0aJhUZco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 273/590] ASoC: Intel: avs: Do not readq() u32 registers
Date: Wed,  5 Feb 2025 14:40:28 +0100
Message-ID: <20250205134505.718557624@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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
index 890efd2f1feab..37de077a99838 100644
--- a/sound/soc/intel/avs/loader.c
+++ b/sound/soc/intel/avs/loader.c
@@ -308,7 +308,7 @@ avs_hda_init_rom(struct avs_dev *adev, unsigned int dma_id, bool purge)
 	}
 
 	/* await ROM init */
-	ret = snd_hdac_adsp_readq_poll(adev, spec->sram->rom_status_offset, reg,
+	ret = snd_hdac_adsp_readl_poll(adev, spec->sram->rom_status_offset, reg,
 				       (reg & 0xF) == AVS_ROM_INIT_DONE ||
 				       (reg & 0xF) == APL_ROM_FW_ENTERED,
 				       AVS_ROM_INIT_POLLING_US, APL_ROM_INIT_TIMEOUT_US);
-- 
2.39.5



