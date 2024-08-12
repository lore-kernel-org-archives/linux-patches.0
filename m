Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FDA178CE4;
	Mon, 12 Aug 2024 16:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479450; cv=none; b=kS2Fx9yGZnBkv3RZHypAoxmhbxX6vCdGYggArLsjWmg7uI2L+zQE3f92J3J+l20X/TUB5a7k4F6wMGl7PRL603wI68k2E6TDBvhk6kJKj6Fv1za593W7k5Lml/OUgnpCQO3tHh8T5a88/tmemj4JLQ/PBRyv9VhP167yGOigBCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479450; c=relaxed/simple;
	bh=gAWzKp9WGdDw1DmqueVi08DkR8uiXbGzFJ3rSQaPSdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASvNwYBXETJK5TNixDOGIK2kz/Al0+U4WUXLAn5LPmk7RBJS9BsvkkU8zaxXWqBKjrpb1iSQJZZjTU3QHKCaBgPCUG/SYhwpiTQ9y/FtC0fT+52V7VnIoztJM5SvL0/Vgpmsvbf6nSHC5/cppwOcwQQiZgF8j4LxMwRhEKXEFao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BuSFNZYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BuSFNZYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57025C32782;
	Mon, 12 Aug 2024 16:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479450;
	bh=gAWzKp9WGdDw1DmqueVi08DkR8uiXbGzFJ3rSQaPSdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BuSFNZYuyiEqOu9yJz4hAgHAg1H5W+FOWt/Sb9Mi8M/oZVA4/CWgOH6ZRLCaQxqjt
	 Tu2DX+TCBrRvm4PwfkI0pqcPk2mTl5Sh8v1oLoTibdnx74Ni8mhQy3DFO2SD/c7ySo
	 qQQCc3JxzLR4lSCbIo1noB5s4DY3Z9YDfcD8YOlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.6 090/189] ASoC: codecs: wsa883x: parse port-mapping information
Date: Mon, 12 Aug 2024 18:02:26 +0200
Message-ID: <20240812160135.605478965@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 1cf3295bd108abbd7f128071ae9775fd18394ca9 ]

Add support to parse static master port map information from device tree.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patch.msgid.link/20240626-port-map-v2-2-6cc1c5608cdd@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 6801ac36f256 ("ASoC: codecs: wsa883x: Correct Soundwire ports mask")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa883x.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/codecs/wsa883x.c b/sound/soc/codecs/wsa883x.c
index a2e86ef7d18f5..5443a5c4100c0 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -1399,6 +1399,14 @@ static int wsa883x_probe(struct sdw_slave *pdev,
 	wsa883x->sconfig.direction = SDW_DATA_DIR_RX;
 	wsa883x->sconfig.type = SDW_STREAM_PDM;
 
+	/**
+	 * Port map index starts with 0, however the data port for this codec
+	 * are from index 1
+	 */
+	if (of_property_read_u32_array(dev->of_node, "qcom,port-mapping", &pdev->m_port_map[1],
+					WSA883X_MAX_SWR_PORTS))
+		dev_dbg(dev, "Static Port mapping not specified\n");
+
 	pdev->prop.sink_ports = GENMASK(WSA883X_MAX_SWR_PORTS, 0);
 	pdev->prop.simple_clk_stop_capable = true;
 	pdev->prop.sink_dpn_prop = wsa_sink_dpn_prop;
-- 
2.43.0



