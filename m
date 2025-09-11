Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A273279334;
	Thu, 11 Sep 2025 20:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757622299; cv=none; b=GU2khXoN6vy7fl9jhwvNuaIsDmJdzMdxKw+HitTN2Zesyx0odZX87EHFuk/RhD8HH7f8aXnwWsh7QBrip/Cp26qeywmQ/lb/Q9wSIJAM5v/neO4sSXfFpo741IFhMjKorIhmvJ7cyWlBmLnIGJ1RuQTwENgOyGOMilebq/Lc98w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757622299; c=relaxed/simple;
	bh=22VCHFy4KNRQGaf9uaDJFhGbMiUhnhRsXF9X0lLDmRI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=OAiIme8IQ0zkq3RpEi/Tp8QOe1vRSpRK5tkWUeLNvyNJtcPKT6KtgTpjAeVW961V+ic56gvkwv/1rAokSq7bi1nN25F6Jjv3RprHzebn5WcLrONdgr8l+LMTzBmd8ZezFBzWIH57MJ3XL5QERsVYv/uk9CXtyxDCAydlCIflGYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PVjxgDun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PVjxgDun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2ECC4CEF0;
	Thu, 11 Sep 2025 20:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757622299;
	bh=22VCHFy4KNRQGaf9uaDJFhGbMiUhnhRsXF9X0lLDmRI=;
	h=From:Date:Subject:To:Cc:From;
	b=PVjxgDun/nBFFjYBgdawOyp86YFHQXxV7QXbbULLBIZ4dVAZyDxSRoVim2nsg8CTT
	 g0KfqpySU62vHHbKSJzDwcgSU4VxJj9tAV2pBHM48YIweNtWHs7COz7qGmFzsqowP2
	 K6FhR8PZpR8Jiv/srq5SZ058rvCCEWjNGr5MKmq3xlXRbTHXHHgxKgHkjfi+dlPlz5
	 1XV6sjI97eyPAHPoBLv84ORmTNif1Wfni6sQRYhqUh+gE1nYJCDnf2AeIUg/CLfceI
	 aMFuBBxmWs53YI/9a+dB+0E+mRsoHMFK/vJMIK1TyNILII18Yfdjq0Azw6+MSlG2PB
	 vWuF9N3uWEX5Q==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 11 Sep 2025 13:24:42 -0700
Subject: [PATCH] drm/omap: Mark dispc_save_context() with
 noinline_for_stack
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250911-omapdrm-reduce-clang-stack-usage-pt-2-v1-1-5ab6b5d34760@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAkww2gC/x2NQQrCQAwAv1JyNtBdUYhfEQ/pbtSgbZekFaH07
 waPA8PMBi6m4nDpNjD5qOs8BaRDB+XJ00NQazDkPp96SgnnkVu1EU3qWgTLOyT0hcsLV+fw24I
 ZiYmF8vk4UIJoNZO7fv+f623ffw0tGOF3AAAA
X-Change-ID: 20250911-omapdrm-reduce-clang-stack-usage-pt-2-9a9ae9263b91
To: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>
Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Arnd Bergmann <arnd@arndb.de>, dri-devel@lists.freedesktop.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2203; i=nathan@kernel.org;
 h=from:subject:message-id; bh=22VCHFy4KNRQGaf9uaDJFhGbMiUhnhRsXF9X0lLDmRI=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBmHDST8z4jMDLDKfqKZ6vBvynr32y9bzK3mme6InOd85
 +k5d32ejlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjARdS9GhgVOCW4v/t60St8+
 NeW7U4G//nfmnwFOe8NXZ8ibBu61XcrwvySlpq1a2Ktwj5vr368PFx2S9t0+f9oSvihNOY0rwdL
 B/AA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

A recent innocuous internal optimization change in LLVM [1] causes the
same issue that necessitated commit 660942f2441d ("drm: omapdrm: reduce
clang stack usage") to occur in dispc_runtime_suspend() from inlinling
dispc_save_context().

  drivers/gpu/drm/omapdrm/dss/dispc.c:4720:27: error: stack frame size (2272) exceeds limit (2048) in 'dispc_runtime_suspend' [-Werror,-Wframe-larger-than]
   4720 | static __maybe_unused int dispc_runtime_suspend(struct device *dev)
        |                           ^

There is an unfortunate interaction between the inner loops of
dispc_save_context() getting unrolled and the calculation of the index
into the ctx array being spilled to the stack when sanitizers are
enabled [2].

While this should obviously be addressed on the LLVM side, such a fix
may not be easy to craft and it is simple enough to work around the
issue in the same manner as before by marking dispc_save_context() with
noinline_for_stack, which makes it use the same amount of stack as
dispc_restore_context() does after the same change.

Cc: stable@vger.kernel.org
Link: https://github.com/llvm/llvm-project/commit/055bfc027141bbfafd51fb43f5ab81ba3b480649 [1]
Link: https://llvm.org/pr143908 [2]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/omapdrm/dss/dispc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/dispc.c b/drivers/gpu/drm/omapdrm/dss/dispc.c
index cf055815077cffad554a4ae58cfd7b81edcbb0d4..d079f557c8f24d1afd0bc182edd13165cb9c356c 100644
--- a/drivers/gpu/drm/omapdrm/dss/dispc.c
+++ b/drivers/gpu/drm/omapdrm/dss/dispc.c
@@ -417,7 +417,7 @@ static bool dispc_has_feature(struct dispc_device *dispc,
 #define RR(dispc, reg) \
 	dispc_write_reg(dispc, DISPC_##reg, dispc->ctx[DISPC_##reg / sizeof(u32)])
 
-static void dispc_save_context(struct dispc_device *dispc)
+static noinline_for_stack void dispc_save_context(struct dispc_device *dispc)
 {
 	int i, j;
 

---
base-commit: 76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c
change-id: 20250911-omapdrm-reduce-clang-stack-usage-pt-2-9a9ae9263b91

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

