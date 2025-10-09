Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF99B2EF655;
	Thu,  9 Oct 2025 15:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025570; cv=none; b=Owvdexyp4wJsl49D1cH/KR0XOm+oimK4fr/xQrNKjGaPEcOi1Nc5L+ZbWHME5JicMwyiEcpohoIo9ptEulbrbpsuIGfOx1mn9Xiob0KtUsgmnef19gMnrWdskV2MMTrf9KhTc2X/pIwN6Z3oG/7s/y1w2VOlQK9+0i+uJAWN4A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025570; c=relaxed/simple;
	bh=GmcTaTF8RNclO7yRzpSlmGBF5rADwZQUifSfhyoe5NA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NCrjvofPstYGXSCPmwOnKlI53z/Ft8/Q5R0qGSNb7xgHX46QJ5d8d9w7SLgizR5UYMvWo9hnAGuO1SCf7yWULklHT6+4CcCb0hXqFMQw4nMuWKAh4XCHoK9ctX0nnsIY55BbpDRpjWKnE9vJO0p4ix52/+6GxG9YfuLU7RBgK0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KlGZBJww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KlGZBJww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E988C4CEE7;
	Thu,  9 Oct 2025 15:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025570;
	bh=GmcTaTF8RNclO7yRzpSlmGBF5rADwZQUifSfhyoe5NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlGZBJwwf5OoNDYIA216z+O8IiBoo+NCNFo5BRsAEOWDyAxkavqvD5zZO2yrKYgcv
	 rR07ihKxYdE5JkPbVQpWOD8m8KnhFLry5Mn8nF66a7kvTXudsH12tw7bdj8+Tx9TzA
	 A8wONMqCS10OpMSjxZQi1PnvEYCTsVSLXjcEgq/YCHFfXsh8IbgNNNzUtJucUry6ah
	 Jacty9BotfgQAHVTEN4NWVkN25Z0oBUC5KZTa/600RglXXiF8OLRo+uVzXwcWH41xx
	 Jfy+2zc/evhzVrcB7g3E91GjJkT3VGwL395g0c8QJwZe1hKXafQXKq6H44BA26pXdM
	 6LE/FgX9gP09A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexander Stein <alexander.stein@ew.tq-group.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-5.4] mfd: stmpe: Remove IRQ domain upon removal
Date: Thu,  9 Oct 2025 11:55:18 -0400
Message-ID: <20251009155752.773732-52-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 57bf2a312ab2d0bc8ee0f4e8a447fa94a2fc877d ]

The IRQ domain is (optionally) added during stmpe_probe, but never removed.
Add the call to stmpe_remove.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20250725070752.338376-1-alexander.stein@ew.tq-group.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - Adds missing cleanup in `stmpe_remove()` to tear down the IRQ
    domain: `drivers/mfd/stmpe.c:1486`
    - New lines: `if (stmpe->domain) irq_domain_remove(stmpe->domain);`
  - The IRQ domain is created in probe via
    `irq_domain_create_simple(...)` in `stmpe_irq_init()`:
    `drivers/mfd/stmpe.c:1222`
  - The domain is passed to children via MFD core (`mfd_add_devices(...,
    stmpe->domain)`), so it persists beyond probe:
    `drivers/mfd/stmpe.c:1295`

- Why it matters
  - Bug: Resource leak and stale IRQ domain on device removal/module
    unload. The driver creates an IRQ domain during probe but never
    removes it, leaving mappings/structures alive after unbind/unload.
  - User impact: Rebind/unload scenarios can accumulate leaked IRQ
    resources; at minimum this is a memory/resource leak, at worst it
    risks stale references in debug/introspection paths.

- Scope and risk
  - Minimal change (3 LOC), confined to removal path in
    `stmpe_remove()`.
  - No functional/architectural changes; no runtime behavior changes
    while device is active.
  - Standard API usage: `irq_domain_remove()` is the canonical teardown
    for domains created with `irq_domain_create_*()`.
  - Children devices don’t require `stmpe->domain` during removal;
    `mfd_remove_devices()` triggers child driver unbinds using Linux IRQ
    numbers, and `free_irq()` does not depend on the domain object. So
    calling `irq_domain_remove()` at the start of `stmpe_remove()` is
    safe.

- Historical/context checks
  - Domain creation present: `stmpe_irq_init()` uses
    `irq_domain_create_simple(...)`: `drivers/mfd/stmpe.c:1222`.
  - MFD children use the domain only at registration time for IRQ
    mapping: `mfd_add_devices(..., stmpe->domain)`:
    `drivers/mfd/stmpe.c:1295`.
  - Upstream commit already merged (57bf2a312ab2d), indicating
    maintainer review and acceptance.

- Stable backport criteria
  - Fixes a real bug (resource leak on driver removal) that can affect
    users in unbind/rebind or module unload workflows.
  - Small, self-contained, and low risk.
  - No new features or architectural changes.
  - Touches an MFD driver only; not a critical core subsystem.
  - No external dependencies beyond long‑standing IRQ domain APIs.

- Notes
  - This commit doesn’t address probe-failure paths (domain created then
    probe fails before `stmpe_remove()`); that’s a separate improvement,
    but not required for this backport.
  - If any stable branch differs in function signatures/locations, the
    change still trivially adapts: just add the
    `irq_domain_remove(stmpe->domain)` in that branch’s `stmpe_remove()`
    implementation.

 drivers/mfd/stmpe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 819d19dc9b4a9..e1165f63aedae 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1485,6 +1485,9 @@ int stmpe_probe(struct stmpe_client_info *ci, enum stmpe_partnum partnum)
 
 void stmpe_remove(struct stmpe *stmpe)
 {
+	if (stmpe->domain)
+		irq_domain_remove(stmpe->domain);
+
 	if (!IS_ERR(stmpe->vio) && regulator_is_enabled(stmpe->vio))
 		regulator_disable(stmpe->vio);
 	if (!IS_ERR(stmpe->vcc) && regulator_is_enabled(stmpe->vcc))
-- 
2.51.0

