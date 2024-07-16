Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CC7CA40;
	Tue, 16 Jul 2024 15:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144145; cv=none; b=Tg19d2QHk4KBgvIk9t9ZUNJwpBiGbwfl4/ZGH8K3v/ijWKwCPlLkcS+GEA5oQebIfCADjiOzf7ysSCwtbPS3ZsXwALKId4Oanj78XV+yS37sEJW3Fq7YnW6m2b/VtpqA/pusfiD6rh2FcxE0EmilCavPp7VKcTQtIcI+vxqMe1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144145; c=relaxed/simple;
	bh=z+gNaf4voSBCb3ZaG2lsuTvA0eyQjGgWHmLDs5jHHtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l82hvcnjcrvU7G4KwZPB5NVWZGC+UqYwDDJaf1B1VZOgzmxabLMRuVj5VssaezDWgNdffESQEaXVJ8PrVXedErc4eqD0lYihMtY1uYPHmqYMkmnJ+fiqjNCLB4/HSSwLcyqNhTesbEcbamfK9LACyQvyzsZ5gCEw7LwmBBHAaHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EW8K2Eh3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EW8K2Eh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15CAC116B1;
	Tue, 16 Jul 2024 15:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144145;
	bh=z+gNaf4voSBCb3ZaG2lsuTvA0eyQjGgWHmLDs5jHHtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EW8K2Eh36oXYMhoNjJzNpAVXyi/hDsdBbB2qsGPOt06UNXPL7UqPB14p5Gt2oqOWm
	 o60zclm3JY3e6ogDEktDgMKv/btjFkul7kLM4+SSk9O7L0aTCLTmKcnmwI+WP+cGYD
	 GinTn1zl/eRc4+KCBsf7wpr0Ci8/5PNTCI2/Bs4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Paulo Zanoni <paulo.r.zanoni@intel.com>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 42/66] drm/i915: make find_fw_domain work on intel_uncore
Date: Tue, 16 Jul 2024 17:31:17 +0200
Message-ID: <20240716152739.774712015@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit cb7ee69015aaba5e1091af94e73bc72483c08e37 ]

Remove unneeded usage of dev_priv from 1 extra function.

Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>
Reviewed-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20190319183543.13679-6-daniele.ceraolospurio@intel.com
Stable-dep-of: 0ec986ed7bab ("tcp: fix incorrect undo caused by DSACK of TLP retransmit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/intel_uncore.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_uncore.c b/drivers/gpu/drm/i915/intel_uncore.c
index 50b39aa4ffb88..c6cd52b8e4e27 100644
--- a/drivers/gpu/drm/i915/intel_uncore.c
+++ b/drivers/gpu/drm/i915/intel_uncore.c
@@ -836,13 +836,13 @@ static int fw_range_cmp(u32 offset, const struct intel_forcewake_range *entry)
 })
 
 static enum forcewake_domains
-find_fw_domain(struct drm_i915_private *dev_priv, u32 offset)
+find_fw_domain(struct intel_uncore *uncore, u32 offset)
 {
 	const struct intel_forcewake_range *entry;
 
 	entry = BSEARCH(offset,
-			dev_priv->uncore.fw_domains_table,
-			dev_priv->uncore.fw_domains_table_entries,
+			uncore->fw_domains_table,
+			uncore->fw_domains_table_entries,
 			fw_range_cmp);
 
 	if (!entry)
@@ -854,11 +854,11 @@ find_fw_domain(struct drm_i915_private *dev_priv, u32 offset)
 	 * translate it here to the list of available domains.
 	 */
 	if (entry->domains == FORCEWAKE_ALL)
-		return dev_priv->uncore.fw_domains;
+		return uncore->fw_domains;
 
-	WARN(entry->domains & ~dev_priv->uncore.fw_domains,
+	WARN(entry->domains & ~uncore->fw_domains,
 	     "Uninitialized forcewake domain(s) 0x%x accessed at 0x%x\n",
-	     entry->domains & ~dev_priv->uncore.fw_domains, offset);
+	     entry->domains & ~uncore->fw_domains, offset);
 
 	return entry->domains;
 }
@@ -886,7 +886,7 @@ static const struct intel_forcewake_range __vlv_fw_ranges[] = {
 ({ \
 	enum forcewake_domains __fwd = 0; \
 	if (NEEDS_FORCE_WAKE((offset))) \
-		__fwd = find_fw_domain(dev_priv, offset); \
+		__fwd = find_fw_domain(&dev_priv->uncore, offset); \
 	__fwd; \
 })
 
@@ -894,7 +894,7 @@ static const struct intel_forcewake_range __vlv_fw_ranges[] = {
 ({ \
 	enum forcewake_domains __fwd = 0; \
 	if (GEN11_NEEDS_FORCE_WAKE((offset))) \
-		__fwd = find_fw_domain(dev_priv, offset); \
+		__fwd = find_fw_domain(&dev_priv->uncore, offset); \
 	__fwd; \
 })
 
@@ -980,7 +980,7 @@ static const struct intel_forcewake_range __chv_fw_ranges[] = {
 ({ \
 	enum forcewake_domains __fwd = 0; \
 	if (NEEDS_FORCE_WAKE((offset)) && !is_gen8_shadowed(offset)) \
-		__fwd = find_fw_domain(dev_priv, offset); \
+		__fwd = find_fw_domain(&dev_priv->uncore, offset); \
 	__fwd; \
 })
 
@@ -988,7 +988,7 @@ static const struct intel_forcewake_range __chv_fw_ranges[] = {
 ({ \
 	enum forcewake_domains __fwd = 0; \
 	if (GEN11_NEEDS_FORCE_WAKE((offset)) && !is_gen11_shadowed(offset)) \
-		__fwd = find_fw_domain(dev_priv, offset); \
+		__fwd = find_fw_domain(&dev_priv->uncore, offset); \
 	__fwd; \
 })
 
-- 
2.43.0



