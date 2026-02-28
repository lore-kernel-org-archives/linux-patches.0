Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BBA33FE12
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300955; cv=none; b=f/0KZ5Bdg0eMmJIVfX0EruMY3c1joZmxZ/G7mBGjryCn1HTQNRNolM3jgeYiVOC9Mr36ki2+BcYO9KP+5IiiJsrTJMa0r5yUzjVb/7FVrUGB1Y9QZWCjRIId8NZbLOtP+/BBBpLhnNIoupp/JufcGKl+tXVzLfQzfmXWwUeoNRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300955; c=relaxed/simple;
	bh=Tg4RGDVD0NnnIeNO1/eistvIgbxgngcA6NWpIyaLKhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tngjJOBXJA82SFyRw7qhwW/GypHl68Blq4B5QZLc1eFvSjcDOPjY1watcO4uidlyR2tIvZFU6ngEGFQ4dXm7HGDsCxYU81LPjyj8nxAd/SBzeGABkAtbYcT0XK44wESVYm8DWVWrTolhcOYt4WHnOdU1KnKIwaT944sR5KptLtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=THfg2hpC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="THfg2hpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4130CC19423;
	Sat, 28 Feb 2026 17:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300954;
	bh=Tg4RGDVD0NnnIeNO1/eistvIgbxgngcA6NWpIyaLKhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THfg2hpC7BmJBOY5xd6MR3C2slHXOdqW45AlGC14OFmC0t0z21WCLfcVHKLv9nbQm
	 RDHMjte4ukp6QXL7iWA0VzyGT/v0t6Z+6bjpvhiICPR3gqVf+3NeLEqL+E0AloLYZr
	 e5nNGv6hsyZkejUhKpBEsT9/2M2+t78LMppCsA2sadz5sdmp/GATZu7IoUYlcUmLiF
	 uNWzwO70ibANdUY9npZXBxfzcVQ/OAu+au1+mBGob9fkXPnDy6UEbAJ83JgD+yQSUj
	 UQwNGJrAE+GdIWTz7h+bTX/rPNc/1bAPvknRLZ+u7sYYVTAqSXLDTuHQskv0LI/cOt
	 PlmSOgu6zSkjA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Martin Schiller <ms@dev.tdt.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/752] perf/x86/cstate: Add Airmont NP
Date: Sat, 28 Feb 2026 12:36:29 -0500
Message-ID: <20260228174750.1542406-78-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Martin Schiller <ms@dev.tdt.de>

[ Upstream commit 3006911f284d769b0f66c12b39da130325ef1440 ]

From the perspective of Intel cstate residency counters, the Airmont NP
(aka Lightning Mountain) is identical to the Airmont.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20251124074846.9653-4-ms@dev.tdt.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/cstate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/cstate.c b/arch/x86/events/intel/cstate.c
index 6f5286a99e0c3..15db12647b2f8 100644
--- a/arch/x86/events/intel/cstate.c
+++ b/arch/x86/events/intel/cstate.c
@@ -598,6 +598,7 @@ static const struct x86_cpu_id intel_cstates_match[] __initconst = {
 	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT,	&slm_cstates),
 	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_D,	&slm_cstates),
 	X86_MATCH_VFM(INTEL_ATOM_AIRMONT,	&slm_cstates),
+	X86_MATCH_VFM(INTEL_ATOM_AIRMONT_NP,	&slm_cstates),
 
 	X86_MATCH_VFM(INTEL_BROADWELL,		&snb_cstates),
 	X86_MATCH_VFM(INTEL_BROADWELL_D,	&snb_cstates),
-- 
2.51.0

