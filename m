Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086E43148DA;
	Sat, 30 May 2026 17:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161227; cv=none; b=IqyqIRp9K37WS6bbFTPgkKCqqdR9xRr28CrKupDegV6nwj9I+KYMnnCTOO6AhIIhkI0tSXZTJg32Tpkp7kX4GFLl9i01aEsc6preYuiDJEaZqfZ16cuBu2R7vNIM+RmPMPIIS0GeC8qCkY1vVmrk8VJ2E7JJrBLHPjao2aQMTlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161227; c=relaxed/simple;
	bh=t2jDMXcwilPtuJt4SLEw6USoM4rtGPhy+bZj7iU/oJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8w4GpYThBAFn+luAJEtXD3m/xW1jqdEY9dX9MzgabcOFo/QzEdBQgfWMlQT5YJ+H04EMHReTQ8wShh8/MF9n95t+2/1ik1DCPhv23pYvoaQSboYiSIjl385zlJqMN4VzSsFhXJXUvHd+17J8pbontsW1T/KDKm9CgelMhshiTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LzPxINTT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LzPxINTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EEB1F00898;
	Sat, 30 May 2026 17:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161226;
	bh=1BHOxmurWVDJExdCMJz5owPrrJGZdyJkUv7P3zKs39M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LzPxINTTmmbW87xs/j4iidKG+W385kYAhAaL6qI7xX7wdCtYdGCZH0tdO8ReNCoHv
	 QaAyNWvHirnN5r7niMKaFeD+Kyz+50dNIOqrhb7fmz3kIOw/MyDFnv4P8YP2vRd8Xu
	 icNnwpuMCXaWMP4JMjYOYIRpblZULUI218mk/Be4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 535/969] ASoC: fsl_easrc: Fix value type in fsl_easrc_iec958_get_bits()
Date: Sat, 30 May 2026 18:00:59 +0200
Message-ID: <20260530160315.140971795@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit aa21fe4a81458cf469c2615b08cbde5997dde25a ]

The value type of controls "Context 0 IEC958 Bits Per Sample" should be
integer, not enumerated, the issue is found by the mixer-test.

Fixes: 955ac624058f ("ASoC: fsl_easrc: Add EASRC ASoC CPU DAI drivers")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260401094226.2900532-11-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_easrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_easrc.c b/sound/soc/fsl/fsl_easrc.c
index bb8bad04fb47d..05aacebee884f 100644
--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -73,7 +73,7 @@ static int fsl_easrc_iec958_get_bits(struct snd_kcontrol *kcontrol,
 	struct soc_mreg_control *mc =
 		(struct soc_mreg_control *)kcontrol->private_value;
 
-	ucontrol->value.enumerated.item[0] = easrc_priv->bps_iec958[mc->regbase];
+	ucontrol->value.integer.value[0] = easrc_priv->bps_iec958[mc->regbase];
 
 	return 0;
 }
-- 
2.53.0



