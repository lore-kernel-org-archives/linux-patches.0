Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793837630;
	b=rrZk3atKutY3XwBuUI9syYZtqnbYJw8A4vjywwv2N35iNR1mwQN9SNWnBjA7pbiK27CZ
	 f4/8rHDuEsl7S8PusNhCJGf1vDXab1LFLZnRvr2ssBZOQlFkTzBfJ1k0oqodGa+QcW6C8
	 J2PtCtPkgYpdErMKBNzmL91wSJ5vq89XVIQCjXGgeJGNUBzL+m69TGQsEymtOIlBfm5X0
	 +iol1lBrGSHEpWxAGRE83TpaXUjBqYs+ALIGs97CGMPUVw/1ePL04sdip/cV/XZugcBJZ
	 7h7LmE6VpfYRYcN/3R6RuwHNj2igLs69/LBnsGAs7PWK4SS/XM9GHCABq3jYEHdZQ8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793837630;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1mo23AzDeQt7AuLMqEQSWvRHD3CTdPe2exkzVKMjzms=;
	b=DpG6we05jpQK7hzNmV7bdt6qxHKtistaBvShixIioXiPbruwJs9EctSeQy0ClKi7iC4M
	 kIO4GNH61bK7D1KwQ2smwUhQsOZgN+Kgk60OrO2eNmeRy5gV9UCI8Bxrezm/j5AmYlFF9
	 EvTWL2RxeRJ8q35+ES4QJYMuMkTFf4ijrFUesB/yZcnc+TrzPbWd1AAoJFFo9Q6DFj65n
	 OqOYzoVv/SzS5vSuknrhz10yDZg0zWyDd/Z6ykyr9LTn7qB1wmiL+Zf3Xftq7gTPcgq8v
	 IYmuO/zV3VzkVFHcx8oUMI+534if9aN/kyZezeyVR7OgJ2RKBAE+zVIh2XUe3QEnRzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=WFnXJ0nh;
	arc=none smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53CC606A338
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 00:13:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A53CC606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=WFnXJ0nh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793837629; x=1825373629;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2wWILsu7y+ptge+HJaqCOHpDots9zge0TIhiYsJH79s=;
  b=WFnXJ0nhlqqgAUEhrmNDC11lGzL8CCMNnmwwTiaSN8jhh5EslsIE6pTf
   zqWSNwpjNiG7k8QMmGivUgIrt8Oo8Cj4bps6ovL07m8nN7hGmjAlswa5x
   +m8cOu+y3Q8Jbjy9oYb1XBDpMryIuHuMPo+0ZrWUf907LuSwb5xUwfgSI
   boRhyqpEPJqsV2nYBDGtdGnk85Zd3W0qEF6CmTJduRuMYs/66ZjMV3H8G
   7zsv/Xb7PWngGCP4NXo7EOhDNEN10GOz/UMp/KwN0dPYcm7PY+an6TN3g
   PqMQZ6vGPOCIYVRpffwN57IAukzF4zILEAwfQESFO2HaJrHAXphIt9Y4v
   A==;
X-CSE-ConnectionGUID: 4yWtWIL9S4K/N7KmPBq9pQ==
X-CSE-MsgGUID: 8+GaGwP3TxOnkhvkTlPrNw==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2512744"
X-IronPort-AV: E=Sophos;i="6.27,196,1787036400"; 
   d="scan'208";a="2512744"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 16:13:47 -0800
X-CSE-ConnectionGUID: 5oFdrrUIRtuS4DozwDVpew==
X-CSE-MsgGUID: ZehaHuOcRmywCH9aV1WUNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,196,1787036400"; 
   d="scan'208";a="7168840"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 16:13:47 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v3 1/5] x86,fs/resctrl: Remove unused non-linear bandwidth delay mapping
Date: Wed,  4 Nov 2026 16:13:29 -0800
Message-ID: <1ea0fed164eaa321a4eb151b14704134024dde88.1793834224.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793834224.git.reinette.chatre@intel.com>
References: <cover.1793834224.git.reinette.chatre@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intel MBA throttles memory bandwidth with delay values, while resctrl
exposes memory bandwidth to user space as a percentage. When delay values
are linear there is a direct mapping between the two. Support for
non-linear delay values would need a pre-calibrated table mapping
percentages to delay values.

Commit

  05b93417ce5b ("x86/intel_rdt/mba: Add primary support for Memory Bandwidth Allocation (MBA)")

added a placeholder for such a table to the resctrl_membw structure, but
the table was never populated and never read. rdt_get_mb_table(), which
would provide it, always fails. As a result, an Intel MBA resource with
non-linear delay values is never marked as capable of allocation, and its
control values are never written to hardware.

Remove the unused mapping table and fold the linear percentage-to-delay
conversion into the function that writes the control values to hardware.

Keep the check that delay values are linear as a defensive measure in
preparation for supporting multiple controls, which turns the memory
bandwidth control into a generic scalar control that indicates whether it
requires linear values.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes since RFC v1:
- Also drop separate delay_bw_map() and instead integrate the only
  mapping to when control value is written.

Changes since RFC v2:
- Rework changelog.

Changes since v1:
- Rewrite changelog, fix subject prefix.
- Match error message about linear support with similar message during
  enumeration added in next patch.
- Add Chenyu's Reviewed-by tag

Changes since v2:
- Add Jinjie and Tony's Reviewed-by tags.
---
 arch/x86/kernel/cpu/resctrl/core.c | 23 +++++++----------------
 include/linux/resctrl.h            |  2 --
 2 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 55214d6fdc49..f9677e52790e 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -323,29 +323,20 @@ static void mba_wrmsr_amd(struct msr_param *m)
 		wrmsrq(hw_res->msr_base + i, hw_dom->ctrl_val[i]);
 }
 
-/*
- * Map the memory b/w percentage value to delay values
- * that can be written to QOS_MSRs.
- * There are currently no SKUs which support non linear delay values.
- */
-static u32 delay_bw_map(unsigned long bw, struct rdt_resource *r)
-{
-	if (r->membw.delay_linear)
-		return MAX_MBA_BW - bw;
-
-	pr_warn_once("Non Linear delay-bw map not supported but queried\n");
-	return MAX_MBA_BW;
-}
-
 static void mba_wrmsr_intel(struct msr_param *m)
 {
 	struct rdt_hw_ctrl_domain *hw_dom = resctrl_to_arch_ctrl_dom(m->dom);
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(m->res);
 	unsigned int i;
 
-	/*  Write the delay values for mba. */
+	if (!m->res->membw.delay_linear) {
+		pr_warn_once("Non-linear MBA delay values not supported\n");
+		return;
+	}
+
+	/* Program bandwidth percentage mapped to linear delay value. */
 	for (i = m->low; i < m->high; i++)
-		wrmsrq(hw_res->msr_base + i, delay_bw_map(hw_dom->ctrl_val[i], m->res));
+		wrmsrq(hw_res->msr_base + i, MAX_MBA_BW - hw_dom->ctrl_val[i]);
 }
 
 static void cat_wrmsr(struct msr_param *m)
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 10dfdca7f4bf..b63dc62690ca 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -253,7 +253,6 @@ enum membw_throttle_mode {
  * @throttle_mode:	Bandwidth throttling mode when threads request
  *			different memory bandwidths
  * @mba_sc:		True if MBA software controller(mba_sc) is enabled
- * @mb_map:		Mapping of memory B/W percentage to memory B/W delay
  */
 struct resctrl_membw {
 	u32				min_bw;
@@ -263,7 +262,6 @@ struct resctrl_membw {
 	bool				arch_needs_linear;
 	enum membw_throttle_mode	throttle_mode;
 	bool				mba_sc;
-	u32				*mb_map;
 };
 
 struct resctrl_schema;
-- 
2.56.0

