Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7978A2377A;
	Thu, 18 Jan 2024 10:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575598; cv=none; b=ANn9p2rTuVAMeLQNYrV744LePirv7WohnepxpPVi4p3qBoCZYMai5x6/oZ7tUag59iI3XyDDc5tiHasAuzXvSVi/AAMddAHk61cyH3/xrprrnpDnmONEpk8e1Ddyy6Srgl2Oxwm9ri7xl3F2bY0EGIxw4PPB0CF7YD26CK7HO1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575598; c=relaxed/simple;
	bh=xPHEc3fhmS835VGl1WBt2XibKmzZ11hVopAQt3yuKdo=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=GP+LtwDlLI6FW2i0GhV/dF+17cpzojxX7mpINs5rDNRxL46wAYyF6F3d1Lwmb47XGlTBSgt4qs80YtSoXVvtpvhNJWkiltyUUw7CSm5tYrjiO2OQXQSh/YCdOugOda+Soj4a/e3apJB9JUbAeIO4CjQArm6dzZFtakcQpIvjQrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJKzj5SK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJKzj5SK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E5EC43390;
	Thu, 18 Jan 2024 10:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575598;
	bh=xPHEc3fhmS835VGl1WBt2XibKmzZ11hVopAQt3yuKdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJKzj5SKzwxHpczkamMT3qqPSULcPGB1qwbFC/RaM7WkDBW5Q9paN1JE20yXdRdkw
	 3Vx/AQ5B9HadLAP9HbNEPKUmE7DXXCMLgVgvXTMhU0JcOQVAmfMzyMBcvjlVx1dWCe
	 ue3cSw+/7Jgw2l7Zql92y8eGCiq9GmaDEIatGQM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rau <David.Rau.opensource@dm.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/100] ASoC: da7219: Support low DC impedance headset
Date: Thu, 18 Jan 2024 11:48:39 +0100
Message-ID: <20240118104312.272306553@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9251490548e8..c8410769188a 100644
--- a/sound/soc/codecs/da7219-aad.c
+++ b/sound/soc/codecs/da7219-aad.c
@@ -663,7 +663,7 @@ static struct da7219_aad_pdata *da7219_aad_fw_to_pdata(struct device *dev)
 		aad_pdata->mic_det_thr =
 			da7219_aad_fw_mic_det_thr(dev, fw_val32);
 	else
-		aad_pdata->mic_det_thr = DA7219_AAD_MIC_DET_THR_500_OHMS;
+		aad_pdata->mic_det_thr = DA7219_AAD_MIC_DET_THR_200_OHMS;
 
 	if (fwnode_property_read_u32(aad_np, "dlg,jack-ins-deb", &fw_val32) >= 0)
 		aad_pdata->jack_ins_deb =
-- 
2.43.0



