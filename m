Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3371DF72D;
	Wed, 19 Mar 2025 14:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394996; cv=none; b=FY/PQ5MqUR3qApwMoTzZtXIce9awq0SKcWQ4LmufKmz5MA4L7YucYxUtA74fumqO8xen6XA+VLU/FoDygTHH8JhGd4BvouhIUnzOcUNkizAMmLjcVI0VtPReM3ZJkFNgUg0rn+dB8fnf4dVzEupiGINLL93NyqLWWJxDUWtDyBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394996; c=relaxed/simple;
	bh=Bel+YEXHvxPvHHW4cAOlOyXTNdjB91CXKYjKF+HfEWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aq9xKfzjpYR3Spo+kYjK2+cJ3DfhaiOweH8hSuDvCRwbMstm2cZoMoJtFzPDPO7cP4CXCTquD32EOe72nLPaLOeiaUyguzeyE5Rro7mm/qbqLWbqs6D6c+TKsakuZTcjXsDnPApuA/BF4t1DD30TaguzMxFhq0BtINFibcZb/x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bz8ng0kb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bz8ng0kb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2483C4CEE4;
	Wed, 19 Mar 2025 14:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394996;
	bh=Bel+YEXHvxPvHHW4cAOlOyXTNdjB91CXKYjKF+HfEWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bz8ng0kbUDT50XBoNdphDv6ZHMrcuOOfI+w9nbn61uLgjEOAUhaX/GdqLf3E02ECc
	 s4LapYvxrGRxwL24nOmAMw92gaQQiY2uwkHoSdyvq2NEq8LwFfZAAIlGovI6/IAnEJ
	 MclaUF4yJD/xJDMB7EDLsmBpOIataVq0Xh6YnVkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.13 193/241] ASoC: tegra: Fix ADX S24_LE audio format
Date: Wed, 19 Mar 2025 07:31:03 -0700
Message-ID: <20250319143032.497226305@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 3d6c9dd4cb3013fe83524949b914f1497855e3de upstream.

Commit 4204eccc7b2a ("ASoC: tegra: Add support for S24_LE audio format")
added support for the S24_LE audio format, but duplicated S16_LE in
OUT_DAI() for ADX instead.

Fix this by adding support for the S24_LE audio format.

Compile-tested only.

Cc: stable@vger.kernel.org
Fixes: 4204eccc7b2a ("ASoC: tegra: Add support for S24_LE audio format")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20250222225700.539673-2-thorsten.blum@linux.dev
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra210_adx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/tegra/tegra210_adx.c
+++ b/sound/soc/tegra/tegra210_adx.c
@@ -264,7 +264,7 @@ static const struct snd_soc_dai_ops tegr
 			.rates = SNDRV_PCM_RATE_8000_192000,	\
 			.formats = SNDRV_PCM_FMTBIT_S8 |	\
 				   SNDRV_PCM_FMTBIT_S16_LE |	\
-				   SNDRV_PCM_FMTBIT_S16_LE |	\
+				   SNDRV_PCM_FMTBIT_S24_LE |	\
 				   SNDRV_PCM_FMTBIT_S32_LE,	\
 		},						\
 		.capture = {					\
@@ -274,7 +274,7 @@ static const struct snd_soc_dai_ops tegr
 			.rates = SNDRV_PCM_RATE_8000_192000,	\
 			.formats = SNDRV_PCM_FMTBIT_S8 |	\
 				   SNDRV_PCM_FMTBIT_S16_LE |	\
-				   SNDRV_PCM_FMTBIT_S16_LE |	\
+				   SNDRV_PCM_FMTBIT_S24_LE |	\
 				   SNDRV_PCM_FMTBIT_S32_LE,	\
 		},						\
 		.ops = &tegra210_adx_out_dai_ops,		\


