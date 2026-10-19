Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792447680;
	b=DoE+VIRLN00McCoXXm8U2lj1cwYyM2pRvVMQxF5GjOyRN/L+8TbM00Ee14uipvbFxuBu
	 hDXXLL1wTLO+otNvXEb3t4Qwwa2G+D2aIi9oJlx3ROPRkcnp7pED3TB9DL3n9KLPzDHne
	 UpKCPJAKD9bKOV0u6dJkKiufTiuzHjLEDuLMpY2YRJXY3WeGaUPapB93fZbF09vsCkAVx
	 nyT4917mSkyjqCCy1UiS/l3KZTgw4qYyS7KRFGghwdqhBaL1K1aw14BpGveGeL6W0BVow
	 9gljpkFYPGmB9VzyAFGZ2/uBiBv0P0aIKFv565eLgpmaSuyzUpFhRXo2RzPANEDoBTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792447680;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uMh63T5YwfVNuBDByuzphHs8PVFbK99F0ZI38rcR9bE=;
	b=ofwMYZgeb5Iu1o6UhtiIuAohRxSSsog1iKkntLsglgcVzmJF4TsBaUpK1lyJoRHYZlu5
	 Q8TC/Lecvh8RZ8xJI7uwtomFZFBtbtuM+uMXvxrwv0BhdIj5QH+YH472KsOMJk6+H4Cr1
	 EbcB/ApUnRjgqn4FmVDqvPa9la6w0LID4wK51pl2QrGGBj2g0JZRi+KFT6wUxbgC0l9yB
	 IoqbRN6MEXF2zvQyfXk7YJs8MEmkNkG31WuyG29yvaPHS15JL24989XJ/ZaBJXah0Ww54
	 eX+rKO6wKDVMdG6brOBKA0JvIV/WOUVUuHhEdMnTEGT3L+dnT5yS/VlzfS13MEfg+YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=RvGK4d3Y;
	arc=none smtp.remote-ip=192.198.163.17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E93606A31F
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 22:07:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07E93606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=RvGK4d3Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792447680; x=1823983680;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A/4iI36wx+KlAM4dI0iaxXZnnncEDWki1Hc3YEPdd3Y=;
  b=RvGK4d3YzpSkVyIxO2MWcMgYxbcFS4Fq3Syb3eMMBMP6Tkm0/bmxd2ik
   U8XO0+vKx/k3bEgcThoWZRxks7y2l/UtN19CSTsuVaEej6K1I9KbWenxA
   5kcjmYQikGzrdg0otnPwYzYyzb1RQTurYBF5ke9YJmF2J5h/HrNCA+NX7
   Atgg2Y3kt/cUNmySIi2pn4vvvrrjqwvT4LRndl9SZ3lGsI/ILjHxeOtUK
   YPXfG+RGKO8juFexvjrR4HYO7pSt9Ps4x7nZL34y/lEZW3BReaiKHj+vd
   fJRU1LJuDniOUzFE4OjvzhCyh4bWp/icmMF/Q4viWedlB0wph3SyCR6YY
   w==;
X-CSE-ConnectionGUID: dZi3+vyDSWK5ZdB6WTtbSw==
X-CSE-MsgGUID: fLGmC2Z7QL2O7UalKMr5Mw==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1144182"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1144182"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 15:07:58 -0700
X-CSE-ConnectionGUID: w1bfUud+RPubKmRNHnRaFg==
X-CSE-MsgGUID: W6aN0PCAQqe5Sh2hmIkKzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2708330"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 15:07:57 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	fenghuay@nvidia.com
Cc: tony.luck@intel.com,
	yu.c.chen@intel.com,
	babu.moger@amd.com,
	fustini@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [RFC PATCH v2 02/10] arm_mpam: resctrl: Rename ctrl_comp in mpam_resctrl_alloc_domain()
Date: Mon, 19 Oct 2026 15:07:36 -0700
Message-ID: <adeb2b33540572b5da5edb79d2ddacc9fc098e01.1792443633.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1792443633.git.reinette.chatre@intel.com>
References: <cover.1792443633.git.reinette.chatre@intel.com>
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

mpam_resctrl_alloc_domain() looks up the component of the resource's
class that contains the CPU and fails the domain allocation if there is
none. The component is held in a local variable named ctrl_comp and, when
the resource supports allocation, it also backs the control domain.

The lookup and its check apply to every resource, including one that
supports only monitoring. For such a resource the component does not
back a control domain, so the name ctrl_comp is misleading. The name also
makes a comment in the same function ambiguous. The comment notes that
there may be no ctrl_comp for the L3, which is true of the control
domain's component but contradicts the local variable, which always
refers to a component once the lookup succeeds.

Rename the local variable to comp. Keep the ctrl_comp name for the
control domain's reference to its component because it only ever refers
to the component that backs the control domain. Leave the comment
unchanged since it now unambiguously refers to that component.

No functional change.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/resctrl/mpam_resctrl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 3d5f90f9f1f3..b07e5dd895dd 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1623,14 +1623,14 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 	struct rdt_l3_mon_domain *mon_d;
 	struct rdt_ctrl_domain *ctrl_d;
 	struct mpam_class *class = res->class;
-	struct mpam_component *ctrl_comp;
+	struct mpam_component *comp;
 	struct rdt_resource *r = &res->resctrl_res;
 
 	lockdep_assert_held(&domain_list_lock);
 
-	ctrl_comp = find_component(class, cpu);
+	comp = find_component(class, cpu);
 	/* class has no component for this CPU */
-	if (WARN_ON_ONCE(!ctrl_comp))
+	if (WARN_ON_ONCE(!comp))
 		return ERR_PTR(-EINVAL);
 
 	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
@@ -1638,10 +1638,10 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 		return ERR_PTR(-ENOMEM);
 
 	if (r->alloc_capable) {
-		dom->ctrl_comp = ctrl_comp;
+		dom->ctrl_comp = comp;
 
 		ctrl_d = &dom->resctrl_ctrl_dom;
-		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, r->rid, &ctrl_d->hdr);
+		mpam_resctrl_domain_hdr_init(cpu, comp, r->rid, &ctrl_d->hdr);
 		ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
 		err = resctrl_online_ctrl_domain(r, ctrl_d);
 		if (err)
-- 
2.55.0

