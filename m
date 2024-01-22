Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473D812A17E;
	Tue, 23 Jan 2024 00:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968764; cv=none; b=B5TNxFuf/r8k3SnXNsQ30e9T8dbKLdW2K3zCKVDHg4vtcIWcHz8we/9IUeCXvvBjOG0XBXGbC9qAcs0VZ+MRCrvqfYxMgq/NNR4jpyoX3M6Q+CDUumHMS3x3Wbgvb68JZhsB7fMHuSeJSb/3LnibJIDeT6/QVMEfOEWtpdCXNt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968764; c=relaxed/simple;
	bh=7LQ128VjMgVIzjBGj5h7gkauR82TWVETu7Rm4HGjBsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RE7w4YJ4bk4zwREjXTHuoClPwE83vONEczZJR4i56r/jH9SXQ7nCiQcr0piSsUfmr1a3mFLCdjTuJcNOlyNCSOM/bcFLta2lbJ+mpQJ0KvvH/bK801+dig3LhMcuU2mMLzA94ISPRvuKVaJFOrF2cwJOce/XkVnY4Qf85xu9IxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+cdpfyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+cdpfyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971ADC433C7;
	Tue, 23 Jan 2024 00:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968763;
	bh=7LQ128VjMgVIzjBGj5h7gkauR82TWVETu7Rm4HGjBsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+cdpfyYuMLfHVTCzKQO1e0pE2J4FKgmHnz2XmZqUie7kH+YlTJhvvkOW1n819T8Y
	 5Qw9S4muQ0dyKpPbUBpjRoBsyBrk06Sc5C9Y+ovnmgW04T/fY6NSVaIe5VPP09VzNW
	 jjbdLwL5V2rtLsH7fkf1d+dK45lqA9MVclLiBIlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rau <David.Rau.opensource@dm.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/194] ASoC: da7219: Support low DC impedance headset
Date: Mon, 22 Jan 2024 15:55:42 -0800
Message-ID: <20240122235719.722871578@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index befe26749bc2..e4e314604c0a 100644
--- a/sound/soc/codecs/da7219-aad.c
+++ b/sound/soc/codecs/da7219-aad.c
@@ -655,7 +655,7 @@ static struct da7219_aad_pdata *da7219_aad_fw_to_pdata(struct snd_soc_component
 		aad_pdata->mic_det_thr =
 			da7219_aad_fw_mic_det_thr(component, fw_val32);
 	else
-		aad_pdata->mic_det_thr = DA7219_AAD_MIC_DET_THR_500_OHMS;
+		aad_pdata->mic_det_thr = DA7219_AAD_MIC_DET_THR_200_OHMS;
 
 	if (fwnode_property_read_u32(aad_np, "dlg,jack-ins-deb", &fw_val32) >= 0)
 		aad_pdata->jack_ins_deb =
-- 
2.43.0



