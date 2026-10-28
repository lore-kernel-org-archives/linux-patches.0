Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214573;
	b=uRLPAB1tskQhu3dn7InwDXiNPUTdNFUy3kxBMRgaOLAIMigg7V3BiEsZ6NEN+23pLrYK
	 jxwnAOTAyHb+XFK/VQfEtM/ShgZrJye8UNDXrgPOqQCfNyBE6UwMHF7Pc8YzaxIV9slBy
	 Rkb22XPDxPtt9dC0bDJ3exUETvkq0jgQaCavmlInaHOCUbF2bn7fhIgwvc7wXK8K06cT9
	 ABu5GZjk/Ahbq4PRcfsG2n+9krI8hfEhxuqyYpexhjQqV18lP0+PonZ2pSL++KKfRXfgB
	 P3jRvte8COxxemiP/dW3sqagLrVWVMVXrL5cK7gAVdKdypHny1hdhN32ySZHQaUwLyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214573;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T7Zgx5C5ilhgwFKMM2GmLEsCxh5OG+J1T9wJE0PdzFM=;
	b=NEebkXB93gT3zxGp/RtrnpcRsAVIWS3ReugXgzYUZxob4nFHZy6q5G4AdE6WyO1hTJgV
	 LeUvN/Q/vp/Cal4UEL2caloc2QwSraEjejnf0aSWWSzSKsrM5T5x766Aiie8spxE79OWc
	 OuWQ4X5hynBP0nz3FaWQJRTdEGpYdVeDl9nNLTu6HUNzADex2qzqhrf/GGfCBTIal0reF
	 NO1fsUbb9+vlWcbuqtyX9GAAZ2Pqrg0pCze/H+1q0MMLpQoRxzBj/dEFS1t0wXugIjtHG
	 lN2JxwhELbsh5jr8EEbakY+oK/qdeN7TGJI5s2UVCyoOou0D61bgJ7vlKCSSWi4Qf7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y+VYdTqm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC67E60A263E;
	Wed, 28 Oct 2026 19:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y+VYdTqm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AAA1F01825;
	Wed, 28 Oct 2026 19:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214572;
	bh=T7Zgx5C5ilhgwFKMM2GmLEsCxh5OG+J1T9wJE0PdzFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y+VYdTqm7C7cvrF0HVEsRBPdnbEHryyRV503aOA1UWA9a5NziJGanpjZFn3PEhqHl
	 rm0dfMTtDSZwfInilQD1zjDylR8aFXFDbUzfPeJ0HWzjdpwfNobZ1C6l43Oa6ToDEX
	 B2L62kv7/e8cOEqtaZ+rgankS7XeraxfJ74xpNh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0853/1887] i915: Move list_count() to list.h as list_count_nodes() for broader use
Date: Wed, 28 Oct 2026 17:49:09 +0100
Message-ID: <20261028170518.836693679@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 4d70c74659d9746502b23d055dba03d1d28ec388 ]

Some of the existing users, and definitely will be new ones, want to
count existing nodes in the list. Provide a generic API for that by
moving code from i915 to list.h.

Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221130134838.23805-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

In this tree the i915 list_count() helper and its only user live in
intel_execlists_submission.c rather than intel_engine_cs.c, so the
i915 conversion is applied there instead.

Stable-dep-of: e9f35294e18d ("ptp: Add a upper bound on max_vclocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/i915/gt/intel_execlists_submission.c  | 15 ++-------------
 include/linux/list.h                              | 15 +++++++++++++++
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
index 321dbecba0f3c..1a396eb13c2e4 100644
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -4153,17 +4153,6 @@ void intel_execlists_show_requests(struct intel_engine_cs *engine,
 	spin_unlock_irqrestore(&sched_engine->lock, flags);
 }
 
-static unsigned long list_count(struct list_head *list)
-{
-	struct list_head *pos;
-	unsigned long count = 0;
-
-	list_for_each(pos, list)
-		count++;
-
-	return count;
-}
-
 void intel_execlists_dump_active_requests(struct intel_engine_cs *engine,
 					  struct i915_request *hung_rq,
 					  struct drm_printer *m)
@@ -4174,8 +4163,8 @@ void intel_execlists_dump_active_requests(struct intel_engine_cs *engine,
 
 	intel_engine_dump_active_requests(&engine->sched_engine->requests, hung_rq, m);
 
-	drm_printf(m, "\tOn hold?: %lu\n",
-		   list_count(&engine->sched_engine->hold));
+	drm_printf(m, "\tOn hold?: %zu\n",
+		   list_count_nodes(&engine->sched_engine->hold));
 
 	spin_unlock_irqrestore(&engine->sched_engine->lock, flags);
 }
diff --git a/include/linux/list.h b/include/linux/list.h
index a2f9a62c577a4..38e8ed08d598c 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -662,6 +662,21 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     !list_is_head(pos, (head)); \
 	     pos = n, n = pos->prev)
 
+/**
+ * list_count_nodes - count nodes in the list
+ * @head:	the head for your list.
+ */
+static inline size_t list_count_nodes(struct list_head *head)
+{
+	struct list_head *pos;
+	size_t count = 0;
+
+	list_for_each(pos, head)
+		count++;
+
+	return count;
+}
+
 /**
  * list_entry_is_head - test if the entry points to the head of the list
  * @pos:	the type * to cursor
-- 
2.53.0



