Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD08309DA4;
	Mon, 13 Oct 2025 15:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368638; cv=none; b=NVXUMJVcudqvq/lYdFh9PDvTTMNgiFp7WsbfMiEg2twjrhPegC4DouZ4igAoa4K2L19iueAzq/IG0fLuKIk0RAgheRKJBVKijc+/z8dbyLzI3PnuPk3cr1i366Y+PHJ4Ncd0lHTuiztk3NSXS0+uB7H2tlIBudwhQFXD0YHKBO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368638; c=relaxed/simple;
	bh=cJ2uQvmTgbrVNw0Ov1wP5XUqfz4CuScEhFRuU+py4/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t32Tu6D+196BjRyNxJCwsZsycYnY7W6bRotsql0/TsBpOntifWsidnKLVvG4noE3VrSppPtsloiX8FkIG9pXRR1oRFZNm/bedG1NIOXpkeBLUkmymO4UuR08/o170cMTTXvY2UM9c1lSHQpJyAT+72cf4qBHWjfjwrOCzIOXLjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LomPWMe2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LomPWMe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723F0C4CEE7;
	Mon, 13 Oct 2025 15:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368637;
	bh=cJ2uQvmTgbrVNw0Ov1wP5XUqfz4CuScEhFRuU+py4/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LomPWMe2G+yRIn+joet+F5Az7v47vyg86VnIzvPG6Eq4oDrQ77hJt4+3l8nRlag14
	 F03tD8ECioNS4SXuIjaa7yjI6VLorQmRQj0C0tTeeBMurR+1vwVi1qZGpONtGKxLuP
	 vW61TG87lZPK2Qu+IBNPUnMEdgIaX13+RHYemmHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 230/262] ASoC: codecs: wcd937x: set the comp soundwire port correctly
Date: Mon, 13 Oct 2025 16:46:12 +0200
Message-ID: <20251013144334.524472561@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit 66a940b1bf48a7095162688332d725ba160154eb upstream.

For some reason we endup with setting soundwire port for
HPHL_COMP and HPHR_COMP as zero, this can potentially result
in a memory corruption due to accessing and setting -1 th element of
port_map array.

Fixes: 82be8c62a38c ("ASoC: codecs: wcd937x: add basic controls")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Reviewed-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://patch.msgid.link/20250909121954.225833-2-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd937x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/wcd937x.c
+++ b/sound/soc/codecs/wcd937x.c
@@ -2039,9 +2039,9 @@ static const struct snd_kcontrol_new wcd
 	SOC_ENUM_EXT("RX HPH Mode", rx_hph_mode_mux_enum,
 		     wcd937x_rx_hph_mode_get, wcd937x_rx_hph_mode_put),
 
-	SOC_SINGLE_EXT("HPHL_COMP Switch", SND_SOC_NOPM, 0, 1, 0,
+	SOC_SINGLE_EXT("HPHL_COMP Switch", WCD937X_COMP_L, 0, 1, 0,
 		       wcd937x_get_compander, wcd937x_set_compander),
-	SOC_SINGLE_EXT("HPHR_COMP Switch", SND_SOC_NOPM, 1, 1, 0,
+	SOC_SINGLE_EXT("HPHR_COMP Switch", WCD937X_COMP_R, 1, 1, 0,
 		       wcd937x_get_compander, wcd937x_set_compander),
 
 	SOC_SINGLE_TLV("HPHL Volume", WCD937X_HPH_L_EN, 0, 20, 1, line_gain),


