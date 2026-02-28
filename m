Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF8E36920B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300955; cv=none; b=KJPH9UF0AbvgXZ7tOibbcGB27rGhCSzTi7/gCH9szgIZR824SSj2AeZvX7xkCmpvBM5PiSiaEHp7SD/6kip+mzUSiAxkBrFWQHdY7wxYmpUOWZ7LZOGZHDB0rFIGIxm4NPOECXGLzSaIyfxrL2YG2MhRE73UXEoldpDqyTwNSJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300955; c=relaxed/simple;
	bh=/sFLEGoPvy247x726FRzRMzSVwRs0/oyefh2ZLMQ6Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWmHyOIwcBSSA69UepISVUy+qpNpyKOhG4rzevZnxCoUJRRbSpCvI88XGJ+siTWa24m7FOiY6RmM7I5GVtVteGoCexfED3Lp6o/8oKeBx5+Sdg934MgdOAQnKVMrp6tG2UnREhLEnmluofTap6u3smRWujtRE/CL0qNhakl/RRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RGaDqzj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RGaDqzj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16335C116D0;
	Sat, 28 Feb 2026 17:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300955;
	bh=/sFLEGoPvy247x726FRzRMzSVwRs0/oyefh2ZLMQ6Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGaDqzj/luCMnbN52KtUS3hemjBhl5u/bFVS3mYGFoGBM39VnUq7vd3qNOj85ujx7
	 38ggnH69jMGMERWF43p3tUstDxQC8gFJUjzpdVbPlMVbPiYiJH3MvXaFEcamAUdXkW
	 yg+dckjhFmLRsfYchROlTYGXIqr0eks2s3/maK3H+nC+0GzhRkqYBuSy5oA0i45Wwv
	 GwQRCWDlAfhXvVxMxqE1yKZiZ5JzQx8VEdxgWiXHQh1ZNel7EAp98xzurarNHw66lb
	 9g920jyyulZbZfMsBuaPIeaHcRoYH3NGZFJlzjrRrcaUWgM4g23CnQm9szwIJWwX0q
	 k8sB8k0f7QkkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Martin Schiller <ms@dev.tdt.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 079/752] perf/x86/intel: Add Airmont NP
Date: Sat, 28 Feb 2026 12:36:30 -0500
Message-ID: <20260228174750.1542406-79-sashal@kernel.org>
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

[ Upstream commit a08340fd291671c54d379d285b2325490ce90ddd ]

The Intel / MaxLinear Airmont NP (aka Lightning Mountain) supports the
same architectual and non-architecural events as Airmont.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20251124074846.9653-3-ms@dev.tdt.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 32d551f2646a7..55d8df7b0fdaa 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -7029,6 +7029,7 @@ __init int intel_pmu_init(void)
 	case INTEL_ATOM_SILVERMONT_D:
 	case INTEL_ATOM_SILVERMONT_MID:
 	case INTEL_ATOM_AIRMONT:
+	case INTEL_ATOM_AIRMONT_NP:
 	case INTEL_ATOM_SILVERMONT_MID2:
 		memcpy(hw_cache_event_ids, slm_hw_cache_event_ids,
 			sizeof(hw_cache_event_ids));
-- 
2.51.0

