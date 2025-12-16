Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103D533DEE1;
	Tue, 16 Dec 2025 11:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884086; cv=none; b=bP3gG40c7kqUy8PPdEoOjQxkbQJI91AvRExGP6MCwGd91/zyU1HnQbYLqGy7LAsdbBet44Csllej5z9hXUtLj0KQo/hW1LsOvkE/r6CgkdxcDZkFVVwXrpBYIKPIclDFxIvi7lY2heYInNqwaZBmeQw1Wp+za09y0E7UcnF9By8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884086; c=relaxed/simple;
	bh=4nJb3bN+mwbQHxK+kx9csPgU/Z1wEqa1EMsUqcPwzGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGaXUBXbqV/s+wbfLx9Or9/OZn3+IcpGtY4s7X4lfdq24Uu+VCL9IYzQDpzOC83ebIgpDGsRduVw/aryYcJa39znXBxnllK+u4NJ8b+VZIh6c97IgqCbdc4qZYpAq/oHebmxb7TQY/g37IREPT2IDFhPXclFAn2NFNG0RaiAX/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m31PkCTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m31PkCTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F62C2BC86;
	Tue, 16 Dec 2025 11:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884085;
	bh=4nJb3bN+mwbQHxK+kx9csPgU/Z1wEqa1EMsUqcPwzGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m31PkCTDKCgW2B1ukqF+/08Uy1lywL1uwemUKEDDcxAodGiq2HcXMHvJCkXrmQLD8
	 vAcS136LRIcw3jU9FcZVWFHw9da+4O1NcA5Briqe9zHVAVImbQy/7LYha2nwAa3Y+a
	 +ssVAD9tBG/SyEaE3+Gp1+HRnhwEHghpYv8VplzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/354] perf/x86/intel/cstate: Remove PC3 support from LunarLake
Date: Tue, 16 Dec 2025 12:10:55 +0100
Message-ID: <20251216111324.111646388@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ae4ec16156bb0..aee2dfc108408 100644
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
@@ -521,7 +521,6 @@ static const struct cstate_model lnl_cstates __initconst = {
 				  BIT(PERF_CSTATE_CORE_C7_RES),
 
 	.pkg_events		= BIT(PERF_CSTATE_PKG_C2_RES) |
-				  BIT(PERF_CSTATE_PKG_C3_RES) |
 				  BIT(PERF_CSTATE_PKG_C6_RES) |
 				  BIT(PERF_CSTATE_PKG_C10_RES),
 };
-- 
2.51.0



