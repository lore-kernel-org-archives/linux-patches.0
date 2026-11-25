Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624712;
	b=4AoBWLUn+szbTlQcrwy1GqdnTzKx75+3BOORbSco++7sAz1yQyzXeM4nr++E+fVdyOYd
	 m36OOfqEWrcb637l/nwEJ3m4rJma80vPSbFXo1Nx++tVvjf8ILUrgZARZ0IHIQdmT0ScH
	 tRCt+nKSku7+txdNL6cqV3FJYNqa92x/Oz78kLnQ1UE1laPrTUbUjGljs4HYDNAo213HI
	 Cs0lcvQVZyeELiQgZ12ltvFB7PIRWq1Ii9PBPmqzR0Vlg/9rUAos1b6BogzI62zt2mQYg
	 yMuiiyTeEXf+CufJ+fLdgs2y+fiaopvq8AJd4lBxoWiR3ecubv8zw1f+BCr7A/7j0zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZeUb+BqoxjitliAwJXBb/4Mmu5xcWLHV3+q5lMf/i+4=;
	b=SUFNMbutAWf9A/etIVDSV2BiBxOPKtZPUQJEdW95lCwJLrNV786a+v5oEUJ9dYRMZiOX
	 nuVro9+BU1Ht+u7EBMpnOBqVxhRRrxBgANpJl/+IYBlbPy2NsH168GtkjYZ99OxWvHgw4
	 czJTWUa8Eewa9VxPPRAKPi4pv5JVU6q7XbEmt+LNYCuot3iwJBaF7LQPldI9Xc0ikVb2U
	 beJHJ9Z6oqnpO1VLJUi8raIpDmm5ig22TZAdJ+1+8iVDyqSXzitz0118epQf5A0pDDJi2
	 cSQuLum7XZO59nGu/O5i3khwl02Ro3Fune/TdXs1Y0rJyeSuTLmWRmtu7Q2pDTOFyBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jke+kJzX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C733B606A33B;
	Wed, 25 Nov 2026 16:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jke+kJzX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C461F000D0;
	Wed, 25 Nov 2026 16:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624712;
	bh=ZeUb+BqoxjitliAwJXBb/4Mmu5xcWLHV3+q5lMf/i+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jke+kJzXPtgmOl4JUf+yTvVbTiNfN1/kVw0RZ0JqIwbLqtpdvfsyBFBe8ooLZD4Og
	 spONPy97865fkE5GNyW1+D9y2b0R+1O8OqaELyGaQEg59/gTA1sfdCDhX/P43EOT1C
	 vVg++QQDaKtsboGVZjq6vVObRcgkA+TyKuw/RYQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyler Baker <tyler.baker@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 284/816] ASoC: soc-core: copy the DAI link names into the card
Date: Wed, 25 Nov 2026 15:30:32 +0100
Message-ID: <20261125143855.781739047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 5097b287b889a..eb76d71de65e9 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3674,6 +3674,18 @@ void snd_soc_of_put_dai_link_codecs(struct snd_soc_dai_link *dai_link)
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
@@ -3703,6 +3715,8 @@ int snd_soc_of_get_dai_link_codecs(struct device *dev,
 	/* Parse the list */
 	for_each_link_codecs(dai_link, index, component) {
 		ret = snd_soc_of_get_dlc(of_node, NULL, component, index);
+		if (!ret)
+			ret = snd_soc_of_dup_dai_name(dev, component);
 		if (ret)
 			goto err;
 	}
@@ -3758,6 +3772,8 @@ int snd_soc_of_get_dai_link_cpus(struct device *dev,
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



