Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DFB241EA;
	Thu, 18 Jan 2024 10:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575216; cv=none; b=NuZGJjwStlFlVjwzLPs2FhGSTP7ZBX9uovL2fv/IKM412+FgDP6TWnR+aSigWYULkghQwjRfIImCKu+WiyZIKa3PJZQM1KmjdSlVwl7I3xmHfO2BuKlZ2yemX7njHyWILn/nwtT4mhB3yfM7/HMnRMNs6jhVBh6ypwwQLYx2I8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575216; c=relaxed/simple;
	bh=7iNMqLpJZ2Qv6X/uVrras+wNQChRnTvmhM5syrXRAoc=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=hfRvJSkTqbnPqvxpM+tjNLrcfE1aSC52kKnLZwc47AbdxpbG5Arct0t5jKtCp0nAQzDUKz8TMxZ6bwYTxe2vfAnDSoSzYJA0ERVbV+kUBqRXvX7qysIbE8zz1GwRw4CGOkRkzvsr0CP/jXpukWWfD7K+Of08NXilm/lxQktq31c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ry9p3dNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ry9p3dNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89710C433C7;
	Thu, 18 Jan 2024 10:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575215;
	bh=7iNMqLpJZ2Qv6X/uVrras+wNQChRnTvmhM5syrXRAoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ry9p3dNj+xFbQmbFdZBqpWgvocR2FsPQNAuTSaBzhVWogBUZDq9RW9yYfPyugj7+1
	 BkAnGd+0K6Sp7z1T9wkLVIeKyEQ3apEDuOCD3EI87rjQQLLi7TtBUiIdz70MIp8/0d
	 fgvLFYs6nYU3XZzjAWTwnLkjuUKQhyeLYZunJ5js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rau <David.Rau.opensource@dm.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/150] ASoC: da7219: Support low DC impedance headset
Date: Thu, 18 Jan 2024 11:47:54 +0100
Message-ID: <20240118104322.409950449@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3bbe85091649..8537c96307a9 100644
--- a/sound/soc/codecs/da7219-aad.c
+++ b/sound/soc/codecs/da7219-aad.c
@@ -696,7 +696,7 @@ static struct da7219_aad_pdata *da7219_aad_fw_to_pdata(struct device *dev)
 		aad_pdata->mic_det_thr =
 			da7219_aad_fw_mic_det_thr(dev, fw_val32);
 	else
-		aad_pdata->mic_det_thr = DA7219_AAD_MIC_DET_THR_500_OHMS;
+		aad_pdata->mic_det_thr = DA7219_AAD_MIC_DET_THR_200_OHMS;
 
 	if (fwnode_property_read_u32(aad_np, "dlg,jack-ins-deb", &fw_val32) >= 0)
 		aad_pdata->jack_ins_deb =
-- 
2.43.0



