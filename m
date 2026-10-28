Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214105;
	b=v7Cot9iblzXrkH/VWDNLSvDfw8gnKDqT4AnD9CFifKtRfAu42QgJf3fUkYJ15WaoZ2sY
	 l6IZaLynHlqmlGzmc2R1lE6kQ1Z4l9oynihID+IQIVFlgSL2fKddsUqjBHCIwOnePWHqh
	 +rXh6CK6X1LV0Vfr2LhEEsn1fdHv269ZXHTNPgusmhb1Uoih7WnWUfYLjTERdTVTxvEyI
	 Vw7/sELiUJ1Cm/UGTCJ5+Fl3opg7flMxJvGRl2BPJvXv6lIQ2IJKeP1nn8ZnpAd06bjss
	 L6UMgd9mjmWdM18THJlcBaCCzCji8I+r73PEbAOSYpf1AO59Iva5agKNh7QfydUFB/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UiVIC9YFgbD7v7QPuwulGBmjd/OhYAmLzcABVjX1Jfk=;
	b=aBYwNhdfcUjA0Mis58EG6ciLRAgx4AGvNLr76G+Mv3x9oNbTqBiVw0nUomtoemu5a2W2
	 6ytxVVeiz80VYXCDRJ68SOGdSKwd2P8GfW/uxEhFgAtK6KSet6d5x8Azh876AVpHt3iw4
	 yxET94Wbgs+jQczdB9xjhNpyEb+mJyMoDz6/ZI9/TJNN4LLK4upTkV0hSZfzwuJPehwnK
	 +YD2LfKObasIpkhIxbIyc38xXErNYKuztAou3Zl89dbMgOVUnJamPhzwityzAb32ZXn02
	 AmlV4ygBnkZWzx9NZv74l1mobA8wIBsY9/3fBMeHPbkNWKjmJCvzgsCkslT78jy24lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L3pzy1RT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE81606A31A;
	Wed, 28 Oct 2026 19:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L3pzy1RT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2F41F01825;
	Wed, 28 Oct 2026 19:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214104;
	bh=UiVIC9YFgbD7v7QPuwulGBmjd/OhYAmLzcABVjX1Jfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3pzy1RThVb8bCsU4BB6zB3JJnovai55kw2JdpfOm2/s2Q3A0E7JtWbVkrqJblzNs
	 XLuNk3x8BI56IZmRPL5aBKuuspSyoTy8S6Kz2b24JUqPjiCkEqtXok5ZxUY6J6nIQD
	 3K8kAKD/zIZhOFKopFc4R/Lj8Do5QILQTzpAoag4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0741/1887] ASoC: SOF: ipc4-topology: Harden loops for looking up ALH copiers
Date: Wed, 28 Oct 2026 17:47:17 +0100
Message-ID: <20261028170516.308910320@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 6fd60136d256b3b948333ebdb3835f41a95ab7ef ]

Other, non DAI copier widgets could have the same  stream name (sname) as
the ALH copier and in that case the copier->data is NULL, no alh_data is
attached, which could lead to NULL pointer dereference.
We could check for this NULL pointer in sof_ipc4_prepare_copier_module()
and avoid the crash, but a similar loop in sof_ipc4_widget_setup_comp_dai()
will miscalculate the ALH device count, causing broken audio.

The correct fix is to harden the matching logic by making sure that the
1. widget is a DAI widget - so dai = w->private is valid
2. the dai (and thus the copier) is ALH copier

Fixes: a150345aa758 ("ASoC: SOF: ipc4-topology: add SoundWire/ALH aggregation support")
Reported-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Link: https://github.com/thesofproject/sof/pull/9652
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250206084642.14988-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index ee6f6edec970c..413dc2d8afb65 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -515,7 +515,7 @@ static int sof_ipc4_widget_setup_comp_dai(struct snd_sof_widget *swidget)
 		}
 
 		list_for_each_entry(w, &sdev->widget_list, list) {
-			if (w->widget->sname &&
+			if (!WIDGET_IS_DAI(w->id) || !w->widget->sname ||
 			    strcmp(w->widget->sname, swidget->widget->sname))
 				continue;
 
@@ -1237,17 +1237,20 @@ sof_ipc4_prepare_copier_module(struct snd_sof_widget *swidget,
 			 */
 			i = 0;
 			list_for_each_entry(w, &sdev->widget_list, list) {
-				if (w->widget->sname &&
+				if (!WIDGET_IS_DAI(w->id) || !w->widget->sname ||
 				    strcmp(w->widget->sname, swidget->widget->sname))
 					continue;
 
 				dai = w->private;
 				alh_copier = (struct sof_ipc4_copier *)dai->private;
+				if (alh_copier->dai_type != SOF_DAI_INTEL_ALH)
+					continue;
 				alh_data = &alh_copier->data;
 				blob->alh_cfg.mapping[i].alh_id = alh_data->gtw_cfg.node_id;
 				blob->alh_cfg.mapping[i].channel_mask = ch_mask;
 				i++;
 			}
+			blob->alh_cfg.count = i;
 			if (blob->alh_cfg.count > 1) {
 				int group_id;
 
-- 
2.53.0



