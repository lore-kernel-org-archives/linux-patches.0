Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271621487CF;
	Tue, 23 Jan 2024 01:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972075; cv=none; b=mp3G0u2cK7XxDdqaFjMErzpVvTry1PMG2ZWiUgLnCkNaYKdK3QTu9PrvWWIroqPJN2nhwKl0BfdMKoAkxPJBlfLjBBbsalXAsVl9yiYKm/Mbkcjh+o+1fzBwO2sEgtwFdl9KRo0hwrUar9D7xASUeIrWhe5bgzyKwomw0xL3+xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972075; c=relaxed/simple;
	bh=W7q6BIdnOOcZDvZj7PLIezJ6gmCDdrPBmbCdLlou8+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hc/Sr19P+LQdh5BzFuMQYD98uU1M/aWhSGOgy+3aK14Z86ToGf6X2NW177H00JT/ISK/6dgaFLsU8LxFqsrzROAv3XvSu3cTz3LN0AiFmm8DckIR/0Vsa+2TJCuEP+mtYuhjsforolLzJkvpheoEQPKjCL+vQy3HiyxFAquLrMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwILD3y5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwILD3y5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E71C43399;
	Tue, 23 Jan 2024 01:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972075;
	bh=W7q6BIdnOOcZDvZj7PLIezJ6gmCDdrPBmbCdLlou8+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wwILD3y5Itl5VWClOwHASsAdl1/RVjzmN+BrdYlMB9+iYBMING7+rf94QZ3lDhI0J
	 h8/LIDJD1quQUj74A5ppfHrksEO1Qc2geyFYntdWF7u9srfczVM0AELlVKHaZyD+r9
	 I6pOMT39JqkYJZxdlPmevIT1IKi0NJaotnOXsVZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rau <David.Rau.opensource@dm.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/374] ASoC: da7219: Support low DC impedance headset
Date: Mon, 22 Jan 2024 15:54:34 -0800
Message-ID: <20240122235745.270037836@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rau <David.Rau.opensource@dm.renesas.com>

[ Upstream commit 5f44de697383fcc9a9a1a78f99e09d1838704b90 ]

Change the default MIC detection impedance threshold to 200ohm
to support low mic DC impedance headset.

Signed-off-by: David Rau <David.Rau.opensource@dm.renesas.com>
Link: https://lore.kernel.org/r/20231201042933.26392-1-David.Rau.opensource@dm.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/da7219-aad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/da7219-aad.c b/sound/soc/codecs/da7219-aad.c
index 7d18de959439..4dc6eed6c18a 100644
--- a/sound/soc/codecs/da7219-aad.c
+++ b/sound/soc/codecs/da7219-aad.c
@@ -654,7 +654,7 @@ static struct da7219_aad_pdata *da7219_aad_fw_to_pdata(struct device *dev)
 		aad_pdata->mic_det_thr =
 			da7219_aad_fw_mic_det_thr(dev, fw_val32);
 	else
-		aad_pdata->mic_det_thr = DA7219_AAD_MIC_DET_THR_500_OHMS;
+		aad_pdata->mic_det_thr = DA7219_AAD_MIC_DET_THR_200_OHMS;
 
 	if (fwnode_property_read_u32(aad_np, "dlg,jack-ins-deb", &fw_val32) >= 0)
 		aad_pdata->jack_ins_deb =
-- 
2.43.0



