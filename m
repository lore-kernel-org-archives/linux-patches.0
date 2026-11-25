Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621980;
	b=OBlXFbR5V4fW7YmCnYa0ZSPLnJKhjZdH3Pq18gUWwRtCbu37+uVngWMdj76t6YDZqPzL
	 83wW1az7dkZM1ihlF/Z7m07cVp52wV1GRf3TWO53lFMah4yWSrCf345hfZEvFzCVGIZyO
	 YDG1eA8q7t/ViC08KH0sXh5lu21NGdyVjulSjFRy8jVPeXQmDaUzBUblWYQFgqTx7MF8M
	 G2OgCB4ypTzDqSIoQYWe2LZCBvLABHi1kBPkDKJAM4NdZUoWhLX15P5gLs7A1Hisl5jrM
	 7LTv+CthSgKTR0RqnM8u5hEKwsPfL5/arFqSdNj1/zb3//o+BXJPL6zHzcP3Va/+vyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GxCJFU9sLhLfSmItODrIxB0/0n0vQLkPfw6HO2RXfUI=;
	b=339ntSIhe79/2ArAQfrPsaQGyHB7MdNqtCcdATIiHuoJTfkB+6G+tTKOARKubiOaVAAu
	 BYePcDe4egU6vesX2fJA956wLn4g0nx353H9dnPLe/moZNWPjVQVplNzPMHx3Ve+tRaLl
	 5cY5d3/zxMJzDtfigRkRlAvFlLFSXPbHsnotceyC8m2UaSIWXUqSo1tG1PZlnZA+ZcWZ3
	 5b0lRefQYD40nBB4TlQ1BjAmwbTpd4X6NJBn94MKQlJaG1GIPIx78sAdk57WP3AYH1fOy
	 nOOqtpzdFim7Zdg8Iwh6b3ekI/RwqlSV5FQGBJNMHp9loB0ovWCPJXhu1Uc6ViQ4DIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0FCcvCHt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A180606A321;
	Wed, 25 Nov 2026 15:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0FCcvCHt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28ED71F000C4;
	Wed, 25 Nov 2026 15:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621979;
	bh=GxCJFU9sLhLfSmItODrIxB0/0n0vQLkPfw6HO2RXfUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FCcvCHtsIqiG0I1JJAryuYzRoY4FUwZjfMEFMWrqw13Ztaqxz8y3aOE+S7VXoSHe
	 /BTh82kZyxDZFkj7gZbcibilvwO1VLT5gPe/G1pKWzzweO/68fRUPysguSuzFYDPb0
	 OSR1JpGgHcB4U2z4YAWo7Qlq/UhBqO1xcjkzGK0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyler Baker <tyler.baker@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 355/990] ASoC: soc-core: copy the DAI link names into the card
Date: Wed, 25 Nov 2026 15:28:42 +0100
Message-ID: <20261125143830.407880416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Tyler Baker <tyler.baker@oss.qualcomm.com>

[ Upstream commit 33a130f6ed8c75ed59b12889a417a57fb80d0abf ]

snd_soc_of_get_dai_link_codecs() and snd_soc_of_get_dai_link_cpus()
keep a DAI name owned by the component, which is freed when the
component unbinds, so the card cannot bind again afterwards.

Copy the name onto the card device, as simple-card and audio-graph-card
do since commit aa173b70d372 ("ASoC: generic: keep fallback dai_name
stable across rebind").

Fixes: e894efef9ac7 ("ASoC: core: add support to card rebind")
Fixes: 900dedd7e47c ("ASoC: Introduce snd_soc_of_get_dai_link_cpus")
Signed-off-by: Tyler Baker <tyler.baker@oss.qualcomm.com>
Link: https://patch.msgid.link/20261106054333.2748248-2-tyler.baker@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index feecf3e4e38b4..34f350b75b18c 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3701,6 +3701,18 @@ void snd_soc_of_put_dai_link_codecs(struct snd_soc_dai_link *dai_link)
 }
 EXPORT_SYMBOL_GPL(snd_soc_of_put_dai_link_codecs);
 
+/* dai_name belongs to the component, which can unbind before the card. */
+static int snd_soc_of_dup_dai_name(struct device *dev,
+				   struct snd_soc_dai_link_component *dlc)
+{
+	if (!dlc->dai_name)
+		return 0;
+
+	dlc->dai_name = devm_kstrdup_const(dev, dlc->dai_name, GFP_KERNEL);
+
+	return dlc->dai_name ? 0 : -ENOMEM;
+}
+
 /*
  * snd_soc_of_get_dai_link_codecs - Parse a list of CODECs in the devicetree
  * @dev: Card device
@@ -3730,6 +3742,8 @@ int snd_soc_of_get_dai_link_codecs(struct device *dev,
 	/* Parse the list */
 	for_each_link_codecs(dai_link, index, component) {
 		ret = snd_soc_of_get_dlc(of_node, NULL, component, index);
+		if (!ret)
+			ret = snd_soc_of_dup_dai_name(dev, component);
 		if (ret)
 			goto err;
 	}
@@ -3785,6 +3799,8 @@ int snd_soc_of_get_dai_link_cpus(struct device *dev,
 	/* Parse the list */
 	for_each_link_cpus(dai_link, index, component) {
 		ret = snd_soc_of_get_dlc(of_node, NULL, component, index);
+		if (!ret)
+			ret = snd_soc_of_dup_dai_name(dev, component);
 		if (ret)
 			goto err;
 	}
-- 
2.53.0



