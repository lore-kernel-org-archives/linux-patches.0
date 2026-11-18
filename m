Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031236;
	b=4n/3eAJxHiFjnmfoBAHnU44fGYAp9Uzcq+RxkH5UzHaKosOL0I8VfUo3NdbMOqI4kPL4
	 3Qj51N4ivoj3xYEzsbKGBOzQPGuqR3TbhCwnVE3Z6QYUKB9Hw2vt6CaJyMuwVCN1m3Z5S
	 xXnRr/ehYK/YLFOZPemZvFZ/u0YBaI8rDImQ9SDyMUv9Tr22LjQJUbuOEoCpsrqbHE4l6
	 9whZGCFb0dVyGvzCTt3DRwf7NWSgKy4J/KBx1wH/YHdKg7bJsHuQF2ytErXIVkrgq11qM
	 qxiBIuOjovafgAtD3VLuc4Gqa3KvZxdr9p2KSR+yTb0LkqFiYF6fSEWkgL0zDASVBIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x1oJKn4ywcbeuq6AxHLERsS9ey2PTtzgh4SJwf1Nxnw=;
	b=nk/hQ7sy2uKbmyDT+XzKe0+l2QPweiuaB+rLqv89xX4XWetfyUhkziaw2w4fNO5CBafp
	 zkaTsuX6SRzz33lLeR+Rqq9LhtxGmCc5Ha9YG0m2McfelEjjbdIL2phyznBWcSF/rWwXI
	 qbteXii67mtqFll0T43ZAMX9iRFKq90w8baH2M/k+9Wery3nx7mRQgZsGrdGFah1FnoTf
	 QpDWqHOhnZFabZ5KK2x2ucmjHRJSMB63+p4JnnF0LoNaGJXPIT43gN3JRQT/vDCBMnkRm
	 VYc9ItpZB/c93kyfGh+mQ95HdgHgAVjO+voos9WpVc6NneC3UOEanMwxrLnEzHjn8vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K0fiBruW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D923C606A320;
	Wed, 18 Nov 2026 19:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K0fiBruW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9861F000C4;
	Wed, 18 Nov 2026 19:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031236;
	bh=x1oJKn4ywcbeuq6AxHLERsS9ey2PTtzgh4SJwf1Nxnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K0fiBruWWClotTqOyh85PTtek+JiKPZdvnYjjEq30I7sMweP9xHuyQIybfsB5bpRH
	 idiylHaqk5rXMs5oewAtXfozVhQKBCF9On2JlH6TZUZfic3eqwVLG6fnm+EDSr5YoJ
	 11QIwQrTKjBoFJbO7Nh3iP5jtoZbcC5jdOnuXvgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0987/1756] ASoC: mediatek: mt8188: Handle constraint return value in FE startup
Date: Wed, 18 Nov 2026 15:51:54 +0100
Message-ID: <20261118150049.468260915@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 71253751586b8ce37570b8e15cfbc74f0dd06c3d ]

snd_pcm_hw_constraint_minmax() may return 1, which is then returned
from mt8188_afe_fe_startup(). ASoC only treats 0 as success when marking
the DAI as started, so .shutdown() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: bf106bf09376 ("ASoC: mediatek: mt8188: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261007110858.509341-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-afe-pcm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
index 884a4656c6f11..8356208132d75 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
@@ -320,6 +320,9 @@ static int mt8188_afe_fe_startup(struct snd_pcm_substream *substream,
 					   MT8188_MEMIF_DL7_MAX_PERIOD_SIZE);
 	if (ret < 0)
 		dev_dbg(afe->dev, "hw_constraint_minmax failed\n");
+	else
+		ret = 0;
+
 out:
 	return ret;
 }
-- 
2.53.0



