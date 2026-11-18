Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025922;
	b=mkYZ/vLQbD6JIcLzremI90ClakV+rvEPQ0uc3qdDpq2nIOMI14LbKbis45RErBZoYD/n
	 XH6tMZ+xlN5ZOQeIa9JyfnCt5t6cGwoEDbTxYjcIzygw7PPRwjseNs1LJOD4MetEHT9T7
	 9H7nNJ8ZXFNR8qJswcR8e06oQMwzoKC9gxtF0dvtiAFsTOKm8BxqhkKkm9I49T+VGSG2G
	 /naaIp8Qir7JW7wS6xIM00JGGXrxj9Zs3sc7m4fKaWdOAxMPeJAW0RKkbnJN3tnNuJzdP
	 2OnouSeJnFCwL01MR3gyQiTgKwZ90x7soL9gRZfNFKMYGeND8n8wYicYHtafELGyjfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZQ3G2Xp9cca4K5H96GPpB4uJcHzCvUNh/t0BNHdv+Kc=;
	b=A/61to1N4w6/BPcP5ZyrjX8+zL3UDGQOmo4Vu8+cLlsFdKciYYZKhvrcRU7ULzoPVizD
	 WweX4mbWGQH/IsFJU6JbjsGaBfGm00jaJhQmaNS1VxBjgg2V9Zvk4/oUNP5AdV5AWzm9c
	 EIwx2HK5MO9V5fQXPE7JA46lVfAe2H4qhexWo/lPV/YcFIqRtm5e2AVbGiyNvcCsAPy35
	 f0imXlcAFDriZlfIVJzJhYWT8MKr/PK8C2SZ6qDTqkxdFyr6B8Sd9SU0Ziw9OVkwR3xaz
	 UAGxMoAccX8bszkl+acA2gH0UJiyRqG6WUprIxh7hMKsINAjKapZxofDna3Bat4x3ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qt8aGXGo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10293606A31C;
	Wed, 18 Nov 2026 18:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qt8aGXGo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F401F000C4;
	Wed, 18 Nov 2026 18:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025921;
	bh=ZQ3G2Xp9cca4K5H96GPpB4uJcHzCvUNh/t0BNHdv+Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qt8aGXGomdYIbY9hwotD4FSVwgxMBkUCfdCbzerDHYerzeBgaZATpF30WK8myp8K5
	 BwCJU4zoFuL8U7v5BySWuWfKjGe51BEJ6WXExLcn2MkiMHfV5SAR4H0B5789tLSNbs
	 3SqmPGDvsU4rb5wvnlWEthRXzdFCnqh8S8SMuTKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1252/2151] ASoC: mediatek: mt8365: Handle constraint return value in FE startup
Date: Wed, 18 Nov 2026 15:49:47 +0100
Message-ID: <20261118150207.772204392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 8de3f4e8e81148dd4cdd19e622d4be1fe07a7f52 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from mt8365_afe_fe_startup(). ASoC only treats 0 as success when marking
the DAI as started, so .shutdown() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: e1991d102bc2 ("ASoC: mediatek: mt8365: Add the AFE driver support")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261007110858.509341-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8365/mt8365-afe-pcm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c b/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c
index bf92c8922c236..880266509925d 100644
--- a/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c
+++ b/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c
@@ -514,11 +514,14 @@ static int mt8365_afe_fe_startup(struct snd_pcm_substream *substream,
 	snd_soc_set_runtime_hwparams(substream, afe->mtk_afe_hardware);
 
 	ret = snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(afe->dev, "snd_pcm_hw_constraint_integer failed\n");
+		return ret;
+	}
 
 	mt8365_afe_enable_main_clk(afe);
-	return ret;
+
+	return 0;
 }
 
 static void mt8365_afe_fe_shutdown(struct snd_pcm_substream *substream,
-- 
2.53.0



