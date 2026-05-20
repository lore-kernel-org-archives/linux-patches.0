Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F9836F421;
	Wed, 20 May 2026 16:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295419; cv=none; b=sEo4MDJ+GyeNjsaVYu928rQTOD3QdhahogN9kpwHtjoz2ZWorG8If35KzZPL0HGY9PX9L/bbiATu5CRYIAc/eKI4BPgPJmr+GhEFZ78vVpKut4PCCTgfqCM4ZTPmBjOWCt0VOQqRR1iGKxuN6GcuSgbIj+3iI3wEZGKfPu8ZTYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295419; c=relaxed/simple;
	bh=9Q/6hCU0BYqvE4HKFYa2zKzL0yNAqNcj2H7QoWeQWro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbpACQLx84PezxgxMWIOc5NH81F6ZYPrpQOxGtPbOnvV/AkUDZ5klLPcDJYqjVqghigqrQiwX4E983VAUzQfpB96ubz8eQAxcwC5clIh+R1i0oD7+KMPYgbWGHeInSuMeLTrQQwwgafLOPYS9CjnJPlDWc4433Lq6CvmxOjBJeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+K14lrC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+K14lrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DB11F000E9;
	Wed, 20 May 2026 16:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295416;
	bh=dz53RuGyMP12RHTzsYmOMm9z/EG4xFUIeiOC19hacBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+K14lrCskOChO7N1TRlGuWaEwJm5ZQp902CmI39Xibx0CgbTC4GEOKUQEPcQ9Q+X
	 zN3QTzDks+xigYbQ4EhnE0FCByAaYBJOgxCCjhKHLgFyGxy2NIaJApuK3csSBsZtk2
	 eBd49Qj3ZI6BJconX6Zk1ytIefS0bITRCK0pWJDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0411/1146] ASoC: soc-component: re-add pcm_new()/pcm_free()
Date: Wed, 20 May 2026 18:11:01 +0200
Message-ID: <20260520162157.500630296@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 68130eef1e0d3c1770952e738f7f8d9f340bd42d ]

Because old pcm_new()/pcm_free() didn't care about parameter component,
to avoid name collisions, we have added pcm_construct()/pcm_destruct() by
commit c64bfc9066007 ("ASoC: soc-core: add new pcm_construct/pcm_destruct")

Because all driver switch to new pcm_construct()/pcm_destruct(), old
pcm_new()/pcm_free() were remoted by commit e9067bb502787 ("ASoC:
soc-component: remove snd_pcm_ops from component driver")

But naming of pcm_construct()/pcm_destruct() are not goot. re-add
pcm_new()/pcm_free(), and switch to use it, again.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/87a4w8lde4.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 3666dc0c47c3 ("ASoC: amd: ps: fix the pcm device numbering for acp pdm dmic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc-component.h        |  4 ++++
 sound/soc/generic/audio-graph-card.c |  1 +
 sound/soc/soc-component.c            | 10 +++++++++-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/sound/soc-component.h b/include/sound/soc-component.h
index 2a2b74b24a609..0435ba376369a 100644
--- a/include/sound/soc-component.h
+++ b/include/sound/soc-component.h
@@ -90,6 +90,10 @@ struct snd_soc_component_driver {
 			     struct snd_soc_pcm_runtime *rtd);
 	void (*pcm_destruct)(struct snd_soc_component *component,
 			     struct snd_pcm *pcm);
+	int (*pcm_new)(struct snd_soc_component *component,
+		       struct snd_soc_pcm_runtime *rtd);
+	void (*pcm_free)(struct snd_soc_component *component,
+			 struct snd_pcm *pcm);
 
 	/* component wide operations */
 	int (*set_sysclk)(struct snd_soc_component *component,
diff --git a/sound/soc/generic/audio-graph-card.c b/sound/soc/generic/audio-graph-card.c
index 8a5f417047397..74e8f2ab7ffc9 100644
--- a/sound/soc/generic/audio-graph-card.c
+++ b/sound/soc/generic/audio-graph-card.c
@@ -77,6 +77,7 @@ static bool soc_component_is_pcm(struct snd_soc_dai_link_component *dlc)
 	struct snd_soc_dai *dai = snd_soc_find_dai_with_mutex(dlc);
 
 	if (dai && (dai->component->driver->pcm_construct ||
+		    dai->component->driver->pcm_new ||
 		    (dai->driver->ops && dai->driver->ops->pcm_new)))
 		return true;
 
diff --git a/sound/soc/soc-component.c b/sound/soc/soc-component.c
index 89f236ab30341..77ad333839744 100644
--- a/sound/soc/soc-component.c
+++ b/sound/soc/soc-component.c
@@ -1042,6 +1042,11 @@ int snd_soc_pcm_component_new(struct snd_soc_pcm_runtime *rtd)
 			if (ret < 0)
 				return soc_component_ret(component, ret);
 		}
+		if (component->driver->pcm_new) {
+			ret = component->driver->pcm_new(component, rtd);
+			if (ret < 0)
+				return soc_component_ret(component, ret);
+		}
 	}
 
 	return 0;
@@ -1055,9 +1060,12 @@ void snd_soc_pcm_component_free(struct snd_soc_pcm_runtime *rtd)
 	if (!rtd->pcm)
 		return;
 
-	for_each_rtd_components(rtd, i, component)
+	for_each_rtd_components(rtd, i, component) {
 		if (component->driver->pcm_destruct)
 			component->driver->pcm_destruct(component, rtd->pcm);
+		if (component->driver->pcm_free)
+			component->driver->pcm_free(component, rtd->pcm);
+	}
 }
 
 int snd_soc_pcm_component_prepare(struct snd_pcm_substream *substream)
-- 
2.53.0



