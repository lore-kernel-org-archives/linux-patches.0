Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892B03659E6;
	Tue, 16 Dec 2025 12:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887145; cv=none; b=aJV0/qss+ByoiizVwmzYfJT7sgWFLujMpZMyy+jJ7UBRw5SY/qhtSUW9fGkeI3dPvbqvgGCZig5cDMs2qSfYXSm3r7Gv2DxpZV1+SFIteXkrrj9yc+Iy8OfDb08OyguiE5spJJ7flvZiQAuz26QeBaAcW33Xd2jrhs8kehP2F2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887145; c=relaxed/simple;
	bh=3RpKji1Zi4DFBifB4darXs07ChOqqIGKo/VMHr3EMAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNpHEAJcukEFJUnH8w5bJy3wsRI2zEltaesJAHoBLNSB4mrNnaGWuf0uWU2iqABws5K+9XiUHKzpmY0KrN0UYZMUgWbMoeNxpxPcZZNhcWX4qP4lVcDZhKZLxVvWjGl+6p/4LREKFclBcmU4wnn/sLv+HDi/yZ/EFKn1vN+hqHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqwH/onx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqwH/onx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D756C4CEF1;
	Tue, 16 Dec 2025 12:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887145;
	bh=3RpKji1Zi4DFBifB4darXs07ChOqqIGKo/VMHr3EMAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqwH/onx2fuMJju93ijjozVVgfu9j4rVkO4qckp1VYiz4csFiBNAeD/rRpTxclfa6
	 Hf7bZ5jzHztDu/bo6q4e5+/8SGUO+ynSc1NI6XhzplAcDs8mkGbrKLJLG1/md3FOPg
	 U/isqVfDzm/VVzx4ZWHvSee1FXbHq6GbywBajkEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 141/614] perf/x86/intel/cstate: Remove PC3 support from LunarLake
Date: Tue, 16 Dec 2025 12:08:28 +0100
Message-ID: <20251216111406.443599389@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 4ba45f041abe60337fdeeb68553b9ee1217d544e ]

LunarLake doesn't support Package C3. Remove the PC3 residency counter
support from LunarLake.

Fixes: 26579860fbd5 ("perf/x86/intel/cstate: Add Lunarlake support")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20251023223754.1743928-3-zide.chen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/cstate.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/cstate.c b/arch/x86/events/intel/cstate.c
index ec753e39b0077..6f5286a99e0c3 100644
--- a/arch/x86/events/intel/cstate.c
+++ b/arch/x86/events/intel/cstate.c
@@ -70,7 +70,7 @@
  *			       perf code: 0x01
  *			       Available model: NHM,WSM,SNB,IVB,HSW,BDW,SKL,KNL,
  *						GLM,CNL,KBL,CML,ICL,TGL,TNT,RKL,
- *						ADL,RPL,MTL,ARL,LNL
+ *						ADL,RPL,MTL,ARL
  *			       Scope: Package (physical package)
  *	MSR_PKG_C6_RESIDENCY:  Package C6 Residency Counter.
  *			       perf code: 0x02
@@ -522,7 +522,6 @@ static const struct cstate_model lnl_cstates __initconst = {
 				  BIT(PERF_CSTATE_CORE_C7_RES),
 
 	.pkg_events		= BIT(PERF_CSTATE_PKG_C2_RES) |
-				  BIT(PERF_CSTATE_PKG_C3_RES) |
 				  BIT(PERF_CSTATE_PKG_C6_RES) |
 				  BIT(PERF_CSTATE_PKG_C10_RES),
 };
-- 
2.51.0



