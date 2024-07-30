Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3409418E04A;
	Tue, 30 Jul 2024 16:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355860; cv=none; b=qb9G7+XIAlGP+TGU4AaDyxJKPKzDb61todF7UceIYUTqte2isnpL7ADIWLmtreq1uaYGGfZldIlqbzL87r6yNX/Y0Myo0RskOOuYS0Gi0aQV5eRKRl1jrAx8daNbvQnuw6kdoGrndkfed3qGSpIDtfbeDEqdSHNJD8yH0aGcpVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355860; c=relaxed/simple;
	bh=45XmFBfQagen9Cew1nv1ObvGZ/pOsvs83w4EcNxFkis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+YRknINsySwtn0mzFv58gP+RpcAMY8fPimTjVfwmyC18yyflGBRI2P/gYGWIUdgYcTeEzJs4sD0QnGFrpmQuvoCX50oYclPT6l4BqA4F/6ttjb4Ya3SqK/DkJJ9M0L6wiOYmF0pb/eedEg4jWubUqRTxCmEhaRyLQ12Ne4as0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gK5KBDc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gK5KBDc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C68CC32782;
	Tue, 30 Jul 2024 16:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355859;
	bh=45XmFBfQagen9Cew1nv1ObvGZ/pOsvs83w4EcNxFkis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gK5KBDc+HTbIn/jjt4PMMTclrkOv8j6GyY1hN3gnl/V0vpWkDZosR09xc7hCZvjS8
	 F9EnuPv/CmdO2woP9ex5dyFcHOsG8J2bjfXM6UyEra3xnBW8LvKAWw2ezynTIywY2e
	 8233TEGxxJ8uzfRFpn7WiarCpbKtPGVULUznOkD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/440] perf/x86/intel/cstate: Fix Alderlake/Raptorlake/Meteorlake
Date: Tue, 30 Jul 2024 17:45:46 +0200
Message-ID: <20240730151620.305351733@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 2c3aedd9db6295619d21e50ad29efda614023bf1 ]

For Alderlake, the spec changes after the patch submitted and PC7/PC9
are removed.

Raptorlake and Meteorlake, which copy the Alderlake cstate PMU, also
don't have PC7/PC9.

Remove PC7/PC9 support for Alderlake/Raptorlake/Meteorlake.

Fixes: d0ca946bcf84 ("perf/x86/cstate: Add Alder Lake CPU support")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20240628031758.43103-2-rui.zhang@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/cstate.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/events/intel/cstate.c b/arch/x86/events/intel/cstate.c
index 551741e79e038..8175bff77efa7 100644
--- a/arch/x86/events/intel/cstate.c
+++ b/arch/x86/events/intel/cstate.c
@@ -80,7 +80,7 @@
  *	MSR_PKG_C7_RESIDENCY:  Package C7 Residency Counter.
  *			       perf code: 0x03
  *			       Available model: NHM,WSM,SNB,IVB,HSW,BDW,SKL,CNL,
- *						KBL,CML,ICL,TGL,RKL,ADL,RPL,MTL
+ *						KBL,CML,ICL,TGL,RKL
  *			       Scope: Package (physical package)
  *	MSR_PKG_C8_RESIDENCY:  Package C8 Residency Counter.
  *			       perf code: 0x04
@@ -89,8 +89,7 @@
  *			       Scope: Package (physical package)
  *	MSR_PKG_C9_RESIDENCY:  Package C9 Residency Counter.
  *			       perf code: 0x05
- *			       Available model: HSW ULT,KBL,CNL,CML,ICL,TGL,RKL,
- *						ADL,RPL,MTL
+ *			       Available model: HSW ULT,KBL,CNL,CML,ICL,TGL,RKL
  *			       Scope: Package (physical package)
  *	MSR_PKG_C10_RESIDENCY: Package C10 Residency Counter.
  *			       perf code: 0x06
@@ -584,9 +583,7 @@ static const struct cstate_model adl_cstates __initconst = {
 	.pkg_events		= BIT(PERF_CSTATE_PKG_C2_RES) |
 				  BIT(PERF_CSTATE_PKG_C3_RES) |
 				  BIT(PERF_CSTATE_PKG_C6_RES) |
-				  BIT(PERF_CSTATE_PKG_C7_RES) |
 				  BIT(PERF_CSTATE_PKG_C8_RES) |
-				  BIT(PERF_CSTATE_PKG_C9_RES) |
 				  BIT(PERF_CSTATE_PKG_C10_RES),
 };
 
-- 
2.43.0



