Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655A81B6D08;
	Tue, 27 May 2025 16:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364632; cv=none; b=ok/5FdioiI8Dt5ys1P4JGDjTdsWFSNcCFz86tCh0priD7ZcFy1ozhJ5QDb0aH1CD6iQvmC2pE/fmtVZPoOzoZu8ma+hJEGcJNhSEtFdFv8xHgDWMga6iVeoqKY3rsT21el8p+8+j9KJbkNJt5M4l4Gun+G/V1W8OChs9jMifcP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364632; c=relaxed/simple;
	bh=3+BL7a+1r7fLd30SGbxoh7AjJ9SEcyfD3k7mxFtF6f0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geoSF55SazZgMf9fTrR5xIfagcw6jHoj9bMKwarIymPzqI0RW03/gImjbErTNylYLp8M6ApOiIi2Q2iVwJry6Ry/0yhjj50/zOJZzRcATtW5lKnyhAIzBhRkRk7T6Hte1Bwpn9/VkaZS8SovIvAjzlgQLSanKcXJ3r6JcI3E6bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afHoTvCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afHoTvCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1CEC4CEE9;
	Tue, 27 May 2025 16:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364632;
	bh=3+BL7a+1r7fLd30SGbxoh7AjJ9SEcyfD3k7mxFtF6f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afHoTvCpxEtNeRnZp5XbTDegdGG7vlcEESo3tJzOR5zwpIOJUPFK4C798TlgYsNbf
	 iapBVJ/k1EQP2dnH9GaUrq+w0Xq9/UqIBxxJAt6770X2RIozHcbwdX5I7LvGxtp51Y
	 aSVUVdV5kuX+6fZzcmhX/aIE9KaPcpVuHiIVl9yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/626] ASoC: codecs: wsa883x: Correct VI sense channel mask
Date: Tue, 27 May 2025 18:19:29 +0200
Message-ID: <20250527162448.138832421@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit ed3b274abc4008efffebf1997968a3f2720a86d3 ]

VI sense port on WSA883x speaker takes only one channel, so use 0x1 as
channel mask.  This fixes garbage being recorded by the speaker when
testing the VI sense feedback path.

Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20250312-asoc-wsa88xx-visense-v1-1-9ca705881122@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa883x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wsa883x.c b/sound/soc/codecs/wsa883x.c
index 47da5674d7c92..e31b7fb104e6c 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -529,7 +529,7 @@ static const struct sdw_port_config wsa883x_pconfig[WSA883X_MAX_SWR_PORTS] = {
 	},
 	[WSA883X_PORT_VISENSE] = {
 		.num = WSA883X_PORT_VISENSE + 1,
-		.ch_mask = 0x3,
+		.ch_mask = 0x1,
 	},
 };
 
-- 
2.39.5



