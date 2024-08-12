Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F385178CE4;
	Mon, 12 Aug 2024 16:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479457; cv=none; b=fbhvpqnuI+67duiYUzHy8SiQ34AM0mfqvEHLLJqMJIxXkPCepiT6FGKO8CABA8RDj4u4GkNAtneIDVU3QTxZ5TqtFlig74P7Zr/axOP6Lf5FyygIl4pPM5EbRYpvVK9Phfz/0bdQ56VWSS7QDj3xWCwStjOxfmK3yJkpyhg6qU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479457; c=relaxed/simple;
	bh=kkwbrbKqYraIXjF7dWqJlGpRUykoDry0waKIeD4RmnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVLeIVjosM6tclg/snhPctJkAKNInl9wSjGG0HOuPBnqngrSIGQkkjyLItnw1waJ9gCULZIXUSHJMQuDje8YiJ1x1h4F8H7PbXS3I4qdPTfO+G9EURU0OlOzJH+dB0+Q9QKsTnDVP8MLRC8DELH76y0+3/O4xE0nJ/gXa3bg2Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0LWAlrS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0LWAlrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2877C32782;
	Mon, 12 Aug 2024 16:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479457;
	bh=kkwbrbKqYraIXjF7dWqJlGpRUykoDry0waKIeD4RmnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0LWAlrS+Mu8JTrrbnl0csk46J9O+wwpdAIbs1pX7LGj2HqpJeysKj/W8upVfMFcW
	 SjAtquOZTa0sb8FcHV7GPWSsIzk6EAafw1ix0npkVyBJNeutrS2u6ozhItVYy+cJid
	 rbFbow0EBY45bSDy42doHKCvmEEiiBNNqJ5DE+w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/189] ASoC: codecs: wsa884x: parse port-mapping information
Date: Mon, 12 Aug 2024 18:02:28 +0200
Message-ID: <20240812160135.684233854@linuxfoundation.org>
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

[ Upstream commit e1bc5c324bcca3acdbe817ccbf9aa7992d89479d ]

Add support to parse static master port map information from device tree.
This is required for correct port mapping between soundwire device and
master ports.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patch.msgid.link/20240626-port-map-v2-4-6cc1c5608cdd@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: dcb6631d0515 ("ASoC: codecs: wsa884x: Correct Soundwire ports mask")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa884x.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/codecs/wsa884x.c b/sound/soc/codecs/wsa884x.c
index 993d76b18b536..ed8110511a5b1 100644
--- a/sound/soc/codecs/wsa884x.c
+++ b/sound/soc/codecs/wsa884x.c
@@ -1858,6 +1858,14 @@ static int wsa884x_probe(struct sdw_slave *pdev,
 	wsa884x->sconfig.direction = SDW_DATA_DIR_RX;
 	wsa884x->sconfig.type = SDW_STREAM_PDM;
 
+	/**
+	 * Port map index starts with 0, however the data port for this codec
+	 * are from index 1
+	 */
+	if (of_property_read_u32_array(dev->of_node, "qcom,port-mapping", &pdev->m_port_map[1],
+					WSA884X_MAX_SWR_PORTS))
+		dev_dbg(dev, "Static Port mapping not specified\n");
+
 	pdev->prop.sink_ports = GENMASK(WSA884X_MAX_SWR_PORTS, 0);
 	pdev->prop.simple_clk_stop_capable = true;
 	pdev->prop.sink_dpn_prop = wsa884x_sink_dpn_prop;
-- 
2.43.0



