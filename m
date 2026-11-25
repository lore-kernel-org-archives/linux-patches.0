Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618995;
	b=aUZtkcVOOio/fZud9ni53RnwExClQm1pmKUWkuDrd3xswGFZ7/YJGt7senQwIfYT/qTM
	 OXLabepoHaHw+z52tpU1QZEcmgLbmZx8nad5DYjKFi4cqYnjuGesJyA/NVIc6lUez3Mqx
	 W4hNi/Vn6eQhKgHmmy32iVEJb2FHxbHCqloVPoaOHmCojt6TaPmUsQj+xOw3+8ODBVqeV
	 1qJ7B4ygSTyQ9PC07mftUwjPI+OgD2+HWW6eRfhfh9igfHumid+wFnljG/cvz+Nc4pjFj
	 MWGySBGD4GeFEe5cJAK9KYceCBv0D46yDFpUcXNuQrPUPROH6dNE0302uRcEmQqAAOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vJH9TAgRfTGVsnUTfVZAx6obhq9aWNrHFj6oZwtl5SM=;
	b=Umk2cOrBRbamakewRzyX1rCdq/ISyqxsTdo0NQsOjHgZR++vv05oR4tfThkfWRHAX9Zg
	 jXDLM002r77zG22PwL93mj+zIEmZ3eeYvDqfpTIBbtgK0JU8htUE3k9XLkNTm8oQQ+Xo5
	 ickLg6kjkWiMk1ISG378pJRHNu16EkRqMaSprKFwQIPJXkvPCbztTafCCG++L/+Se+5HQ
	 sHFNqMzp0OzqxezC4X91uwaOtWvrYWzHJ3h4Cz13qhEOTzOnvs1BYawlqMIAHVd8Ypzm5
	 LEArBr9T5n3mYJnX2OsWh3lHNE5jpHGpu7dyxezCXTjKKLtK1ICyrsBLG4u1zcKhjeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bvptcaqp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FE6606A31E;
	Wed, 25 Nov 2026 15:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bvptcaqp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0387A1F000C4;
	Wed, 25 Nov 2026 15:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618994;
	bh=vJH9TAgRfTGVsnUTfVZAx6obhq9aWNrHFj6oZwtl5SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bvptcaqp+Wg44IvtMgQyNufIT+mCelqtLrQrwKaTIET3F5A49MUtqkyy+cqPMkiOs
	 iQ5zOUds+CbBzxv8W9NVPT3iSq/qZcrFDLgzWOLI75wSK6KGSOFmT7Px4RT5W/qq4h
	 Ir82K6vgH5XT601mUKwwKPcUjQiz3UW0H819cpA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyler Baker <tyler.baker@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0410/1005] ASoC: soc-core: copy the DAI link names into the card
Date: Wed, 25 Nov 2026 15:29:08 +0100
Message-ID: <20261125143831.355925339@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b9c70268d49fe..2ba53102a6302 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3610,6 +3610,18 @@ void snd_soc_of_put_dai_link_codecs(struct snd_soc_dai_link *dai_link)
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
@@ -3639,6 +3651,8 @@ int snd_soc_of_get_dai_link_codecs(struct device *dev,
 	/* Parse the list */
 	for_each_link_codecs(dai_link, index, component) {
 		ret = snd_soc_of_get_dlc(of_node, NULL, component, index);
+		if (!ret)
+			ret = snd_soc_of_dup_dai_name(dev, component);
 		if (ret)
 			goto err;
 	}
@@ -3694,6 +3708,8 @@ int snd_soc_of_get_dai_link_cpus(struct device *dev,
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



