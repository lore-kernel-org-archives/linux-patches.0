Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8B4233D9E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300954; cv=none; b=rQ0diITk8Hzi/o2ids2Sy3NjKdoOSmwZEI37fqm2bj1npHtorB07aU4//5qAeuOwZUrGZsAYh0qHVdvcIOjXS3/gbxgEAx9d+sZRWK/TxvdMoB3RFBrpPfx2J7sYWmukdo6wR81umhY1fuzcg3jODzabQ3vgw9sYBASXfDbbTQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300954; c=relaxed/simple;
	bh=H5FE0biINAPqcQj2mRaD4fEdEN96p45GPqIJtXKgFHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzoanZ9IjIMsxiHwKADIGbJKI0NmY0jtHYXSKSbw9orbIU2U7glErS5BLv+JRdmb+jDOf4OS/2l/h6p/UC9oYJj6ZcP0elY5S1D8i14iVpXdKIEW8sUlLNYVpjYLu4bGHL8MTjQ1IOflrMPY68ifoVSp7HtUZUwCLekfpEVTvnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OeivPWov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OeivPWov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FCCC116D0;
	Sat, 28 Feb 2026 17:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300954;
	bh=H5FE0biINAPqcQj2mRaD4fEdEN96p45GPqIJtXKgFHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OeivPWovjs2oqoXJyoGB8TMAhYF+xnXJKzoxMhwuJMkyM3D8K6bda1U1AqTZkd9dm
	 7A1MyGwILZU7M7NGkUblvuA2NB5N0awZF3RScTVJnl+VuvIgXTph4o9DAUGZjUBKBg
	 tqz6Tf5iWrmZ58uDDHr14VGmyzzxI45KJ6lEJI+P+g4R1t2RZlni8si5AUfEe8URDd
	 F+TRaJq7isUOt1iLSJyfAwtMIzHUKBhN+8pN38ghRe1VrKXeUvi5oMpu9kAY9qQYz6
	 2xMb+xOpj/mNZ042uOuRHg/d3Nuv1VyUa7CXtVfi6QEdnGXyBuWGWPuhAVkNaQ0wBa
	 uBk5v93xRlbOQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Martin Schiller <ms@dev.tdt.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 077/752] perf/x86/msr: Add Airmont NP
Date: Sat, 28 Feb 2026 12:36:28 -0500
Message-ID: <20260228174750.1542406-77-sashal@kernel.org>
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

[ Upstream commit 63dbadcafc1f4d1da796a8e2c0aea1e561f79ece ]

Like Airmont, the Airmont NP (aka Intel / MaxLinear Lightning Mountain)
supports SMI_COUNT MSR.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20251124074846.9653-2-ms@dev.tdt.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/msr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/msr.c b/arch/x86/events/msr.c
index 7f5007a4752a1..8052596b85036 100644
--- a/arch/x86/events/msr.c
+++ b/arch/x86/events/msr.c
@@ -78,6 +78,7 @@ static bool test_intel(int idx, void *data)
 	case INTEL_ATOM_SILVERMONT:
 	case INTEL_ATOM_SILVERMONT_D:
 	case INTEL_ATOM_AIRMONT:
+	case INTEL_ATOM_AIRMONT_NP:
 
 	case INTEL_ATOM_GOLDMONT:
 	case INTEL_ATOM_GOLDMONT_D:
-- 
2.51.0

