Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146312FB99A;
	Sat, 25 Oct 2025 16:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409652; cv=none; b=eGqdc2NlLcVVT8MJIVcT4mmbnRkU/kbeElFXwRB1BIEK+Uq5rDRQvMgQOWA/WyCHXUQXhRReZex7TEHZJSn/mTLv3ldgVOUPS6ruDce4E4q2S+iOZkupvLAJgdGUXVtMyYZgE5xn+AYnXnCZOTKkVgsCFllKx1gN2pbQxK2KT7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409652; c=relaxed/simple;
	bh=sXUlsAQeX/AuROKLwiNRZ/qwBlXG+ys5hiXEbZAOnQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I17HLK0a4nneSA/V7fQypctvMU6nvhoFFFNl+51ljoitzz6y050JrAGNHM7smcD26FBL+akUKlpxKzgiW8jdTad5Ug7by8554fF8e+aPPNAivqmbMLKBcUgeMNpNoXEu86YkVmvnDIhaM89QaQg/MPOjeUFXWoS+GFVLsK+lrPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rEaD5dxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rEaD5dxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6A7C4CEF5;
	Sat, 25 Oct 2025 16:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409652;
	bh=sXUlsAQeX/AuROKLwiNRZ/qwBlXG+ys5hiXEbZAOnQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEaD5dxrRRwAaS4gq7rTPuo5l1COV81V2I/M0Tu8DrmWW+97kQ9koYMXXpqDsV8qp
	 nAuHBfSjiSP9v6yG/cFgCE6oZ8dYbalIh1+S+mpT482pyvIEV42sWSsBw9IeNApGsZ
	 WUu8dtNBEBfCxRAxOAHrhys92ED9ZrDqG19e03OQaAo4nHt0ml/ZaxsRoqVlk8xKac
	 t6FXOGs5CWMAtIfONi8UBA7Atwi7a7DEQY2cSGQfEdo8Amu0KlQk7OLjTLCTjYHbf+
	 5Bbzm8mUL6ZiEImzxJ6YYhe9JNtrTcrt8f/CBXiVIyWObmDxPSgWKhPXo5h2G+eVYx
	 zUI9No02DhK0A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	ethan@ethancedwards.com,
	alexandre.f.demers@gmail.com,
	sakari.ailus@linux.intel.com
Subject: [PATCH AUTOSEL 6.17] ASoC: Intel: avs: Do not share the name pointer between components
Date: Sat, 25 Oct 2025 12:00:37 -0400
Message-ID: <20251025160905.3857885-406-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 4dee5c1cc439b0d5ef87f741518268ad6a95b23d ]

By sharing 'name' directly, tearing down components may lead to
use-after-free errors. Duplicate the name to avoid that.

At the same time, update the order of operations - since commit
cee28113db17 ("ASoC: dmaengine_pcm: Allow passing component name via
config") the framework does not override component->name if set before
invoking the initializer.

Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250818104126.526442-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Rationale
- Fixes a real bug (use-after-free) by eliminating shared ownership of
  the component name. The new code duplicates the string so each
  component owns its copy: `acomp->base.name = devm_kstrdup(dev, name,
  GFP_KERNEL);` in `sound/soc/intel/avs/pcm.c`. This prevents dangling
  references when one component tears down while another still
  references the shared pointer.
- Correctly updates initialization order to align with current ASoC core
  behavior: the name is set before
  `snd_soc_component_initialize(&acomp->base, drv, dev);`. Since commit
  cee28113db17 (“ASoC: dmaengine_pcm: Allow passing component name via
  config”), the core respects a pre-set `component->name` instead of
  overwriting it. Upstream change in sound core (sound/soc/soc-core.c)
  made `snd_soc_component_initialize()` only allocate a name if
  `component->name` is NULL, ensuring the driver-provided name persists.
- Removes the old post-init override `acomp->base.name = name;`, which
  was both unsafe (shared pointer) and no longer needed given the core’s
  updated semantics.
- Minimal and localized change: affects only Intel AVS registration path
  (`avs_soc_component_register()` in `sound/soc/intel/avs/pcm.c`), not
  runtime PCM/DMA paths, scheduling, or broader ASoC architecture.
  Regression risk is low.
- User impact: prevents crashes/corruption during component
  teardown/unbind or when multiple components shared the same `name`
  source. This is a classic stable-worthy bug fix (memory safety).

Dependencies / Backport Notes
- Depends on core behavior introduced by cee28113db17 (ASoC core no
  longer overwrites `component->name` if set prior to initialization).
  For stable trees lacking that change, this patch would need
  adaptation:
  - Either keep setting the duplicated name after
    `snd_soc_component_initialize()` or backport the core behavior
    first.
- Name lifetime/cleanup in the ASoC core: newer kernels that allow
  externally provided names must not unconditionally
  `kfree(component->name)` on component cleanup. Ensure your target
  stable tree’s `snd_soc_component_cleanup()` matches modern ownership
  semantics (many trees now treat `component->name` as externally
  provided or use safe-free patterns). If not, prefer `kstrdup()` (non-
  devm) here and rely on the core’s kfree to avoid double-free, or
  backport the corresponding core cleanup change alongside.
- API drift: newer trees use the `snd_soc_add_component()`/component-
  init flow shown in this patch; older trees may have different
  signatures. If your stable branch differs, the change remains
  conceptually the same but needs trivial mechanical adjustment.

Summary
- This is a targeted memory-safety fix with minimal scope and clear user
  impact. It meets stable criteria when applied to branches that have
  the updated ASoC core behavior (or with a small, well-understood
  adaptation).

 sound/soc/intel/avs/pcm.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 67ce6675eea75..e738deb2d314c 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -1390,16 +1390,18 @@ int avs_soc_component_register(struct device *dev, const char *name,
 	if (!acomp)
 		return -ENOMEM;
 
-	ret = snd_soc_component_initialize(&acomp->base, drv, dev);
-	if (ret < 0)
-		return ret;
+	acomp->base.name = devm_kstrdup(dev, name, GFP_KERNEL);
+	if (!acomp->base.name)
+		return -ENOMEM;
 
-	/* force name change after ASoC is done with its init */
-	acomp->base.name = name;
 	INIT_LIST_HEAD(&acomp->node);
 
 	drv->use_dai_pcm_id = !obsolete_card_names;
 
+	ret = snd_soc_component_initialize(&acomp->base, drv, dev);
+	if (ret < 0)
+		return ret;
+
 	return snd_soc_add_component(&acomp->base, cpu_dais, num_cpu_dais);
 }
 
-- 
2.51.0

