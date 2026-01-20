Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1663347DD61;
	Tue, 20 Jan 2026 19:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768937711; cv=none; b=g8asWGDD7pwT93GC/FMcYWxRynf+LWr9tQRDr3w+NEA+YPwrgozvyV1F79LvQ7VsWwERscS4pgOm9eOchmcayLGGewedLw9WT8gRFJFwuOX9s+0Eyxyq9lEWjpfgt+iF21XY02kMy6JQL82lAgH9oeHE/Rrrn1moJiYJn7v6Ejk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768937711; c=relaxed/simple;
	bh=pJlsRew5eftP2Jsy6yH4nSxgh1li+FzDMGa47OhgI6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6Oavx5v3w/v3gauN3kTZYmmHuHLan8DB3Ex7AeYfkkFd8PCOHiOGuIVWMlyAKuY9e/KILerlxQTCUmXZnGggX6B0AzPv+dsvFcGd60Whe7MBDN6gmp9OApNjC245wEyaOY+OYAp4/1OlFgQxNOF7LNZBU3pV6MopcJp3vhMw2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=atdmEiwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="atdmEiwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7086C19422;
	Tue, 20 Jan 2026 19:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768937709;
	bh=pJlsRew5eftP2Jsy6yH4nSxgh1li+FzDMGa47OhgI6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atdmEiwzQUF3JaW1ecAAfXzXtuFk5NawHGbxEvNmT7YmvgI+93i++dD4bE/aIt22w
	 Ks3zmHA2fCPWNirWLxCHdKd7N4w/qx7v9YIiHs6kszK5lymCmBAhzr5FOzYicSQ892
	 gHfhOjrah22a4HetSBeBX3h61JVkU3+3eo7sy+TthYFYXXeh4mljfGYYYIec1ktukg
	 DlUKt09PGEfaAFytIDdCF1MXqAJfWvlp+NHGNjt2cClkJjAXyOWJVCkSvfLR7x++4H
	 0WrtauT6aZfZ+L2zK6nf/mHHO01KdOdb8dc/Yvx9zUZYTyQ5us133p2Ih7iPAIOR+u
	 /V4Pz22fJ1Cfg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shengjiu Wang <shengjiu.wang@nxp.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-sound@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ASoC: simple-card-utils: Check device node before overwrite direction
Date: Tue, 20 Jan 2026 14:34:51 -0500
Message-ID: <20260120193456.865383-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260120193456.865383-1-sashal@kernel.org>
References: <20260120193456.865383-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.6
Content-Transfer-Encoding: 8bit

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 22a507d7680f2c3499c133f6384349f62f916176 ]

Even the device node don't exist, the graph_util_parse_link_direction()
will overwrite the playback_only and capture_only to be zero. Which
cause the playback_only and capture_only are not correct, so check device
node exist or not before update the value.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/20251229090432.3964848-1-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The commit seems to be describing a new patch to be analyzed. Based on
my full analysis, let me now synthesize my evaluation:

## ANALYSIS SUMMARY

### 1. COMMIT MESSAGE ANALYSIS

The commit message describes a bug where:
- When a device node doesn't exist (is NULL), the
  `graph_util_parse_link_direction()` function still overwrites
  `playback_only` and `capture_only` to zero (false)
- This causes incorrect behavior when these flags should remain as they
  were set by previous calls

The commit has:
- **Acked-by:** from the subsystem maintainer (Kuninori Morimoto)
- **Signed-off-by:** from the maintainer (Mark Brown)

### 2. CODE CHANGE ANALYSIS

**The Bug:**
Looking at the function:
```c
void graph_util_parse_link_direction(struct device_node *np,
                    bool *playback_only, bool *capture_only)
{
    bool is_playback_only = of_property_read_bool(np, "playback-only");
    bool is_capture_only  = of_property_read_bool(np, "capture-only");

    if (playback_only)
        *playback_only = is_playback_only;
    if (capture_only)
        *capture_only = is_capture_only;
}
```

When `np` is NULL:
1. `of_property_read_bool(NULL, ...)` returns `false` (since NULL node
   has no properties)
2. The function unconditionally overwrites `*playback_only = false` and
   `*capture_only = false`

**Call Pattern (from simple-card.c and audio-graph-card.c):**
```c
graph_util_parse_link_direction(top,    &playback_only, &capture_only);
graph_util_parse_link_direction(node,   &playback_only, &capture_only);
graph_util_parse_link_direction(cpu,    &playback_only, &capture_only);
graph_util_parse_link_direction(codec,  &playback_only, &capture_only);
```

The intent is hierarchical: if `top` sets `playback_only = true`, it
should remain true unless a lower-level node explicitly overrides it.
But if `cpu` or `codec` is NULL, the current code wrongly resets
`playback_only` to false.

**The Fix:**
```c
- if (playback_only)
+   if (np && playback_only)
        *playback_only = is_playback_only;
- if (capture_only)
+   if (np && capture_only)
        *capture_only = is_capture_only;
```

Adding `np &&` check prevents the function from overwriting the values
when `np` is NULL.

### 3. CLASSIFICATION

- **Bug fix:** Yes, clearly fixes a logic error
- **Security:** No security implications
- **Feature addition:** No

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** 2 (very minimal)
- **Files touched:** 1
- **Complexity:** Very low - adding a simple NULL check
- **Risk:** Very low - defensive programming that only affects behavior
  when np is NULL, which is already an edge case

### 5. USER IMPACT

- **Who is affected:** Users of ASoC simple-card and audio-graph-card
  drivers
- **Severity:** Audio routing could be incorrect (playback-only or
  capture-only configuration not being honored)
- **Visibility:** Users with device trees that set `playback-only` or
  `capture-only` on higher-level nodes where some lower-level nodes
  don't exist

### 6. STABILITY INDICATORS

- **Acked-by:** Kuninori Morimoto (maintainer of the code)
- **Signed-off-by:** Mark Brown (ASoC subsystem maintainer)

### 7. DEPENDENCY CHECK

- The function exists in stable trees starting from v6.10 (introduced in
  commit d29351e8c20d61)
- The fix applies cleanly and has no dependencies on other commits

### 8. FINAL ASSESSMENT

This is a clear, minimal, and well-reviewed bug fix that:
1. Fixes a real bug that causes incorrect audio configuration
2. Is small and surgical (2-line change with simple NULL check)
3. Has low regression risk (only affects edge case of NULL np)
4. Has been reviewed and acked by the appropriate maintainers
5. Would apply cleanly to stable trees (v6.10+) where this function
   exists

The fix is small, surgical, and meets all stable kernel criteria.

**YES**

 sound/soc/generic/simple-card-utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/generic/simple-card-utils.c b/sound/soc/generic/simple-card-utils.c
index 355f7ec8943c2..bdc02e85b089f 100644
--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -1179,9 +1179,9 @@ void graph_util_parse_link_direction(struct device_node *np,
 	bool is_playback_only = of_property_read_bool(np, "playback-only");
 	bool is_capture_only  = of_property_read_bool(np, "capture-only");
 
-	if (playback_only)
+	if (np && playback_only)
 		*playback_only = is_playback_only;
-	if (capture_only)
+	if (np && capture_only)
 		*capture_only = is_capture_only;
 }
 EXPORT_SYMBOL_GPL(graph_util_parse_link_direction);
-- 
2.51.0

