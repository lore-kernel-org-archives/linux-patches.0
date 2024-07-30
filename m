Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225131A619B;
	Tue, 30 Jul 2024 16:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357143; cv=none; b=r79eQpkMs/cGtG+/QQ0lHIcpcZJBrRI4W27z5u9wsFSiFxad4mdBxb8EQ/HwLiZEp50J31pDeWDorzZ2Uo68GVzpI+dA8zScaAvA7vdfa/M1awloCYoEXLTHYjkQiwrbeeFjOxdHZR4myLakiuIPri+LpOXrjmW8OikKnxwx44A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357143; c=relaxed/simple;
	bh=OXnPpRqv21Se+oB7r0SWzMhTLM6wsQFaMI/V04HtEEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIHIakLEB4celnmb8baE5yJsvy75MVDqlms/V7bB+VxtHmZbEGwKk7pYevXYZKUbV2VZwKHE2vCfLpydEmkgckC5Kk8snH2PxLlXbJHveoKgvBo3rd+eJbthZfag7XTo00eo9xIm0WMFkfZyOUpo/upjMWaSKPZ0ht1zJG6FTW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxvK6ibB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxvK6ibB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F12C32782;
	Tue, 30 Jul 2024 16:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357143;
	bh=OXnPpRqv21Se+oB7r0SWzMhTLM6wsQFaMI/V04HtEEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZxvK6ibB0IDgCVYymeUI4H99Efd0Tr1o9VClER10cfgnKFjn5gRrSv4bPv+H3x1hq
	 crDxiNVTnjbW54QsY8FekDcVHYOSaEUW1cmNW4JHeuieTmXQiCE9nxCzxA3Ub7KYj0
	 u3yd2dyzMtln4W7Qny3sZSeX6qvvHdysAxx5ezGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 226/809] perf/x86/intel/cstate: Fix Alderlake/Raptorlake/Meteorlake
Date: Tue, 30 Jul 2024 17:41:42 +0200
Message-ID: <20240730151733.533340341@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9d6e8f13d13a7..dd18320558914 100644
--- a/arch/x86/events/intel/cstate.c
+++ b/arch/x86/events/intel/cstate.c
@@ -81,7 +81,7 @@
  *	MSR_PKG_C7_RESIDENCY:  Package C7 Residency Counter.
  *			       perf code: 0x03
  *			       Available model: NHM,WSM,SNB,IVB,HSW,BDW,SKL,CNL,
- *						KBL,CML,ICL,TGL,RKL,ADL,RPL,MTL
+ *						KBL,CML,ICL,TGL,RKL
  *			       Scope: Package (physical package)
  *	MSR_PKG_C8_RESIDENCY:  Package C8 Residency Counter.
  *			       perf code: 0x04
@@ -90,8 +90,7 @@
  *			       Scope: Package (physical package)
  *	MSR_PKG_C9_RESIDENCY:  Package C9 Residency Counter.
  *			       perf code: 0x05
- *			       Available model: HSW ULT,KBL,CNL,CML,ICL,TGL,RKL,
- *						ADL,RPL,MTL
+ *			       Available model: HSW ULT,KBL,CNL,CML,ICL,TGL,RKL
  *			       Scope: Package (physical package)
  *	MSR_PKG_C10_RESIDENCY: Package C10 Residency Counter.
  *			       perf code: 0x06
@@ -637,9 +636,7 @@ static const struct cstate_model adl_cstates __initconst = {
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



