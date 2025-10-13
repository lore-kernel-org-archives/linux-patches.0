Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E29C3081D7;
	Mon, 13 Oct 2025 15:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370171; cv=none; b=QQnku9PV9/LRboY+DSpHI/My9JLrLSWZGAt3yb5uqwKoP0SDh5L7Ni2iVQ0nDj2ZKomVatr343vV6nE2OwJdw6/oKPkGC7r+ikfmQLuz5x83IOjClE7HfZfS7SnGiPSp9uxMnTlCk3cns6g0k2WRGdz4uWus0/Idob75hnJBMfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370171; c=relaxed/simple;
	bh=qkvL1xmjGts9FD/+vobkAzVQXLX7ruZEimxTEYUSfhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rldwy73O2xaUt1L5ha4nFB4E1n+u2mVxaa/XdpKt9oKshXu7WJZQ5RydMr+wbmLvppJOawd8dwdJFr6nsl3muvYJa0BfaRn5iuGf5gdJZ/9OBurgA21DJiZs2PFckNeUtQykQhmyfAm72TdcRTRaNXcChiMONHfWohI2BLraM8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmrM9NKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmrM9NKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA452C4CEE7;
	Mon, 13 Oct 2025 15:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370171;
	bh=qkvL1xmjGts9FD/+vobkAzVQXLX7ruZEimxTEYUSfhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AmrM9NKSKTWHtmJn7dF6VM0ZMIOXWVqHB820LFEoDgL5zwOXEUz8FP9dQIfWD/xiK
	 yua3KfpC0yapEtJVM1cgyIwlY1o3Mhzksd75nvIhF7Cur2WJ4SJDlIWs8n8dM57Ybr
	 YJYySqNDJ6B3oCr4mDWqJImyK93N9GsG0GzruxZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.17 503/563] ASoC: codecs: wcd937x: set the comp soundwire port correctly
Date: Mon, 13 Oct 2025 16:46:04 +0200
Message-ID: <20251013144429.532681993@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2046,9 +2046,9 @@ static const struct snd_kcontrol_new wcd
 	SOC_ENUM_EXT("RX HPH Mode", rx_hph_mode_mux_enum,
 		     wcd937x_rx_hph_mode_get, wcd937x_rx_hph_mode_put),
 
-	SOC_SINGLE_EXT("HPHL_COMP Switch", SND_SOC_NOPM, 0, 1, 0,
+	SOC_SINGLE_EXT("HPHL_COMP Switch", WCD937X_COMP_L, 0, 1, 0,
 		       wcd937x_get_compander, wcd937x_set_compander),
-	SOC_SINGLE_EXT("HPHR_COMP Switch", SND_SOC_NOPM, 1, 1, 0,
+	SOC_SINGLE_EXT("HPHR_COMP Switch", WCD937X_COMP_R, 1, 1, 0,
 		       wcd937x_get_compander, wcd937x_set_compander),
 
 	SOC_SINGLE_TLV("HPHL Volume", WCD937X_HPH_L_EN, 0, 20, 1, line_gain),


