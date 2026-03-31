Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CE43E559E;
	Tue, 31 Mar 2026 16:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975216; cv=none; b=JC/KTFurzfP8ua+denmPfmkVU6jPnM3izcQI/N/3FvB6vVTF69ozCbePjKJGRzcqwdkf9mq+I71Vrr5wGaCG6kRJ/IaJCIt3ewHCA5lTM4x+S8g4wpSNBrXPkDnrkbIY53bQRDWakqz8KZhP5DFl0xPlDLJURFTycT+ynSx5lGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975216; c=relaxed/simple;
	bh=gggfqyLzBn8va7ecmV1TEm+8hJcvwi8XYd0haqUOSf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PonCaR2+Dh06ttwdmHij38Gy/bI9Xv6qvHVgoDif0Vayb5K/704SLawjw8XCnpmvRkQYt4UFpAaG/VzhvtmJRYMDPoY3Y6fz0ReG47bHCZxYThgbzk2ps43iB99mNB6HYu+QMLJ00mesZRjfwRU03Ge5gi8a0BCMsnmXrkPY2UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7bbL7/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7bbL7/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1D6C19423;
	Tue, 31 Mar 2026 16:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975216;
	bh=gggfqyLzBn8va7ecmV1TEm+8hJcvwi8XYd0haqUOSf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7bbL7/ErfqdNIw1BCQGK49v7ERphw4dFAjMh6U2Ltxl8e50OquqKLrxWATkDcO2z
	 Oon00azYz/2NOxTFp9CMTs1w9oHP25dVaDVLseWWUO/lLToU8yxP+YoXHJExpCuO3z
	 08WitGs+MNKv1RCzHTkw63K5Wo3UC8plFuojNhLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Joel Selvaraj <foss@joelselvaraj.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.19 209/342] ASoC: codecs: wcd934x: fix typo in dt parsing
Date: Tue, 31 Mar 2026 18:20:42 +0200
Message-ID: <20260331161806.671464988@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit cfb385a8dc88d86a805a5682eaa68f59fa5c0ec3 upstream.

Looks like we ended up with a typo during device tree data parsing
as part of 4f16b6351bbff ("ASoC: codecs: wcd: add common helper for wcd
codecs") patch.
 This will result in not parsing the device tree data and results in
zero mic bias values.

Fix this by calling wcd_dt_parse_micbias_info instead of
wcd_dt_parse_mbhc_data.

Fixes: 4f16b6351bbff ("ASoC: codecs: wcd: add common helper for wcd codecs")
Cc: Stable@vger.kernel.org
Reported-by: Joel Selvaraj <foss@joelselvaraj.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260323231748.2217967-1-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd934x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -2172,7 +2172,7 @@ static int wcd934x_init_dmic(struct snd_
 	u32 def_dmic_rate, dmic_clk_drv;
 	int ret;
 
-	ret = wcd_dt_parse_mbhc_data(comp->dev, &wcd->mbhc_cfg);
+	ret = wcd_dt_parse_micbias_info(&wcd->common);
 	if (ret)
 		return ret;
 


