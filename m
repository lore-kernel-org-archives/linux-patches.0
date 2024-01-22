Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0950913E236;
	Tue, 23 Jan 2024 00:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968145; cv=none; b=W5OKnbBj5JUIu+2k6sWdHD8kEYQsYq8EEJzyRHYrtsbYNyhUQdw4fNz5PEln97uMMfv83yPoXkHgWIC+lNtoSmjhzvzVlRC8nQXGvqScDV5I38X1qp7E0J3mSNi+vB5ZZ3293liv97CrV7IJUhIpZeyGhNF/zrsNwASB8UJy2Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968145; c=relaxed/simple;
	bh=6dasGNcl8jcSXopUJYDdGC5oURwBPb77JwkiLOm2QwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnqzPmD4ICS/ZRj6qYpYFJ0mFL0jwjS/18ew22zo9aYqa1fmLZRFU5SMQqgmtPhUPQfnw4RweE28l7XRgTek3Lu7gUEr8Z3bkN08MvQ5pTKYEXntIDdUF8HLkOxXN+INo8hZnv94lh4OZXEi3eolkWjfWTghp8NvHaHgyoOP71k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PmOnqcLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PmOnqcLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426A3C433C7;
	Tue, 23 Jan 2024 00:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968144;
	bh=6dasGNcl8jcSXopUJYDdGC5oURwBPb77JwkiLOm2QwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PmOnqcLPfqF9T3fJc4U0shI67N7nWlD5hK85Kq5dlJSsObgP+UlMJDqcceyJ8PEwg
	 mi/PmUptguWU+dK6vVyowRbYWLvgIHyNng7il79weHQAddY1hWl2vrtFAW7Y8U4pGe
	 AhKtqv86DzmHZaKjv84yyFHaAWNU/873RZwid3t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rau <David.Rau.opensource@dm.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 007/148] ASoC: da7219: Support low DC impedance headset
Date: Mon, 22 Jan 2024 15:56:03 -0800
Message-ID: <20240122235712.728868323@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 7e18e007a639..e3515ac8b223 100644
--- a/sound/soc/codecs/da7219-aad.c
+++ b/sound/soc/codecs/da7219-aad.c
@@ -659,7 +659,7 @@ static struct da7219_aad_pdata *da7219_aad_fw_to_pdata(struct snd_soc_component
 		aad_pdata->mic_det_thr =
 			da7219_aad_fw_mic_det_thr(component, fw_val32);
 	else
-		aad_pdata->mic_det_thr = DA7219_AAD_MIC_DET_THR_500_OHMS;
+		aad_pdata->mic_det_thr = DA7219_AAD_MIC_DET_THR_200_OHMS;
 
 	if (fwnode_property_read_u32(aad_np, "dlg,jack-ins-deb", &fw_val32) >= 0)
 		aad_pdata->jack_ins_deb =
-- 
2.43.0



