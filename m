Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E112570;
	Tue, 23 Jan 2024 00:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970791; cv=none; b=qAwPtJjHQ8v7O21SUUcx//6FipYvb5/fLbUNbEZRu6xkbcMJ89NgJeNkmtDEfrBkplru3HfIOEcQtyDKZs3GAI97tIdanNZeUK1re3aPQZW5zcIEkKdOdCAHEda3i+RzTwiWk/KI5WD7MBQQFggonGtAhmFVl4EhHS9x03wukXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970791; c=relaxed/simple;
	bh=A3B4ApZwZRc3AMbZ4Td8sPT9rFUo0rd/lLdIQ14RPRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elwXTMzMFZrR4mJWVdiuhscjEEryifm3LjQFz153ak7i4H28tMPBuobStxankbawXqLW4Hx0svA8CTXtjbFrozK3oz0LbEZU6RuuxjjbHl+2lguwb6CPVKfsrsIgfFuGfB3cSxZ40cNauF/bfU+S+1wdvPo/xep/TV5xytiuZaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8M4AjrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8M4AjrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BE1C433F1;
	Tue, 23 Jan 2024 00:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970791;
	bh=A3B4ApZwZRc3AMbZ4Td8sPT9rFUo0rd/lLdIQ14RPRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8M4AjrW5QQq0sF7tUyw2ogxUAKBJBBrXhVQGOq+p/mlXM1ZOYc5IbClpQIP2dyP+
	 doO7ReD7JLk1xdbNjc16CbdZxHLpLkT7di3t8NS2hnlQAvHdgZKx0S7f7EsiN5/yB5
	 4HZOqungqWxOwZ/HBPawF6A6XxjcNdBx87y+DGUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rau <David.Rau.opensource@dm.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/286] ASoC: da7219: Support low DC impedance headset
Date: Mon, 22 Jan 2024 15:55:23 -0800
Message-ID: <20240122235732.687713265@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b316d613a709..b6030709b6b6 100644
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



