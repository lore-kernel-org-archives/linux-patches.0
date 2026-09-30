Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920774D2EFE;
	Wed, 30 Sep 2026 17:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787826; cv=none; b=dnv0VafXtSv40GOocW/3rfF4JlRknATS+0uHhTivn3rNMzs3PyT1KaKKAxNQXXTkttoZVQvoseVg1k00GIWixNprmS+bsrAFqP17+k9vyX3471obPzLjVppEOj3uSduPwvJWhMshRgtpjZyCceu2QGaHl6skPeZEULvMlyR/1ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787826; c=relaxed/simple;
	bh=6kgoSormM1X1kFb1oypxaQOkuwiHUZ26fGdRxFJpGWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsQUT7u38//fgUKcycDy6i8dASYu8NZFcR7Fzb8HzjS+4xtEkZpl7/0ysbiWicq657C8WzIbtSfX/qpqbPNh3w7EcpExVNOEQa3h3k5eNLWgtu3krvN+U4Y7zNeGICOKQGCyS2p4n+m1RQDQEIBWRhH2xjJihlZ0ASP3/d1yVCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qy+wJ4Y4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qy+wJ4Y4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4FD1F000FF;
	Wed, 30 Sep 2026 17:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787825;
	bh=/fT2ZYtGMNveoDwHY829+NMbJdi9xg+Pv89xGx8ZgUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qy+wJ4Y4yOa5sBdvuVqIM+hAKtSW5m1DJwG4TCMD+pHJ2Ynkwf0JyKhSiRVcTxg91
	 /b4cLjdQBEj/gxW8jl64tViJy+xyhE8KIztwA+/PTTTM9itT98donphitEbj4D4GRc
	 eztpnOdgNvyeXbja3o4qfn86sYAzzJNadla80x+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 7.2 367/457] perf/x86/intel: Fix Panther Cove PEBS data-source snoop states
Date: Wed, 30 Sep 2026 17:27:52 +0200
Message-ID: <20260930152353.927060321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

commit 0ac5d6ca2c3b7d047963b67dccef17902dc6c017 upstream.

For Panther Cove, the snoop states for the data source encodings
"Prefetch Promotion" and "Cross Core Prefetch Promotion" should be
SNOOP_NONE instead of SNOOP_MISS.

Fix the incorrect snooping states for Panther Cove.

Fixes: d2bdcde9626c ("perf/x86/intel: Add support for PEBS memory auxiliary info field in DMR")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org> # v7.0+
Link: https://patch.msgid.link/20260917015234.981153-8-dapeng1.mi@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/ds.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 72179bcf6d0d..d0329a7eb8a5 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -277,8 +277,8 @@ static u64 pnc_pebs_l2_hit_data_source[PNC_PEBS_DATA_SOURCE_MAX] = {
 	0,							/* 0x06: Reserved */
 	OP_LH | P(LVL, L2)  | LEVEL(L2) | P(SNOOP, HIT),	/* 0x07: L2 Hit Snoop HIT */
 	OP_LH | P(LVL, L2)  | LEVEL(L2) | P(SNOOP, HITM),	/* 0x08: L2 Hit Snoop Hit Modified */
-	OP_LH | P(LVL, L2)  | LEVEL(L2) | P(SNOOP, MISS),	/* 0x09: Prefetch Promotion */
-	OP_LH | P(LVL, L2)  | LEVEL(L2) | P(SNOOP, MISS),	/* 0x0a: Cross Core Prefetch Promotion */
+	OP_LH | P(LVL, L2)  | LEVEL(L2) | P(SNOOP, NONE),	/* 0x09: Prefetch Promotion */
+	OP_LH | P(LVL, L2)  | LEVEL(L2) | P(SNOOP, NONE),	/* 0x0a: Cross Core Prefetch Promotion */
 	0,							/* 0x0b: Reserved */
 	0,							/* 0x0c: Reserved */
 	0,							/* 0x0d: Reserved */
-- 
2.55.0



