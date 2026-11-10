Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794284361;
	b=ywveepFnOW1ko0XKmlzKMD+N2MtD7S4W6f+L5ALaaVx7forsJqWOuCofEwQDYaQEW0yX
	 5PKnfigLYbKW4qFjOMO5SQTxH23eVLHYhImrdYaaDMhUknzpzHnXn47BePRM8U6d9l0gM
	 4pQ72XjnFmy3kJOopD4CBkeUM3lpr2bZqX8JAla77pWZwaYosAIrYgeiiyMPa4Meiw2qh
	 5+uHFvrr/F/o0fLIi5RqhX27kk2ZDrsePEq8zhlGkWLXS+KssVc6GQgp5DPPNWBVjV2od
	 jesHoRtWGRA7skeWSiM/j5WhAYhh2DKdVbzp7xW9p6v/87JjtqZ0l4MdBH6/hT8AJ9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794284361;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EBhsEKZkI0T6l5ZEl4CsvjDyXBYk51vEHobMZ0URW+M=;
	b=OqKIvpIirPwkf1+eAkOU6kXqtNGk+uLx5hUyvlMXnYbALtdpJSkiLZbaoWsx9/UIaDew
	 sdgFuj9ot9loZxMz1Y2DQ5m649tubtudJw/BEspqEC4CCR81GVzikeFliei6t1YT03gjK
	 CL3CD9ABlcBbgztSKg9fAaKArgLNngm3dyZhtjMPbDRJO1N5RtJ+e9nXIDbf8LLGuyZ2T
	 VLjQRtF68+ZUg3qdly4hU9gPxBLBoU9FKUPflbTggWmbDOSekNS2kBvK66FD8cZuk68h3
	 2z2aJT6K2Ilu6zZt2yCypwd10ItiZvbCBfcdRkr1THPFaSXygGd43fsf+PHS5KGA5dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=lD0c1GXR;
	arc=none smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E7160A380C
	for <patches@lists.linux.dev>; Tue, 10 Nov 2026 04:19:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3E7160A380C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=lD0c1GXR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794284361; x=1825820361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OsiKxBUCPT9LghQtc7gN8zDNI74uP9EnNh0+wpzYPA0=;
  b=lD0c1GXR5MXzNdR/kwPcGQKyM8Sp/Fe44PTTVDac8d2xqSxyjyRG2JTn
   CC4J54ByaJdv0V6y/7IQQYfm5FqiTGNJEfiGySTmo1rF1Kf1rEtcCwa0K
   uK9JTDzCx8aimrOcSi3YIaq3gGWIkfp2cDAfg8K4O2jpMfv4HRkrmhp8H
   Le9zJhL5E3Z6ga60zHSSAssempf41ocOUn1z1ls0xF2LpVZCVsBYgQWnQ
   vXkmRc8Q/BnfgMovdZMURo45u/k+prUvzXP5mUDnhDPnLC4VUxReiDCBH
   JaNwP2ubfw0XhvLeznGsTSubQVs0YIYe6p5PooESQhqW0SPsnLqhoUMVD
   Q==;
X-CSE-ConnectionGUID: PgYiS8ERT5qtun/K/ktdVw==
X-CSE-MsgGUID: m6SZkKwyTAidlIWg7Ou0pg==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2901337"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="2901337"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 20:19:15 -0800
X-CSE-ConnectionGUID: QZKeKtlJSPOwW/MoKuGTFQ==
X-CSE-MsgGUID: m4PO8iMkQba21uMJQDXH7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="7856923"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 20:19:15 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	fenghuay@nvidia.com,
	ruanjinjie@huawei.com
Cc: tony.luck@intel.com,
	yu.c.chen@intel.com,
	babu.moger@amd.com,
	fustini@kernel.org,
	tan.shaopeng@fujitsu.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v3 6/8] arm_mpam: resctrl: Require a component for each monitoring event
Date: Mon,  9 Nov 2026 20:19:06 -0800
Message-ID: <6828c35d975ea89bc551721da9c9a5a629b6db67.1794283825.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794283825.git.reinette.chatre@intel.com>
References: <cover.1794283825.git.reinette.chatre@intel.com>
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

Setting up a monitoring domain looks up, for each monitoring event, the
component of the event's class that contains the CPU and records it in
the domain. Reading and resetting the event's counters in the domain
then use the recorded component.

If an event's class has no component for the CPU, the domain is still
set up as long as another event's class has one, and the event is left
without a component. Reading or resetting the event's counters in that
domain then dereferences a NULL component. This is not expected to
happen since only classes that cover all possible CPUs are picked for
monitoring.

Fail setting up the monitoring domain, with a warning, if an event's
class has no component for the CPU, so that every event of a monitoring
domain has a component.

Keep the check that at least one component was found. It now only fails
if no event has a class, and so captures that a resource that supports
monitoring has at least one monitoring event with a class.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since RFC v2:
- Add Ben's Reviewed-by tag.
- Add Jinjie's Tested-by tag.
- Move ahead of "arm_mpam: resctrl: Give the monitoring domain its own
  structure", which now contains a check that relies on this one.
---
 drivers/resctrl/mpam_resctrl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index db1df6e8d8c0..ca90b293b697 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1686,9 +1686,11 @@ static int mpam_resctrl_setup_mon_domain(unsigned int cpu,
 			continue;       // dummy resource
 
 		mon_comp = find_component(mon->class, cpu);
+		if (WARN_ON_ONCE(!mon_comp))
+			return -EFAULT;
+
 		dom->mon_comp[eventid] = mon_comp;
-		if (mon_comp)
-			any_mon_comp = mon_comp;
+		any_mon_comp = mon_comp;
 	}
 	if (WARN_ON_ONCE(!any_mon_comp))
 		return -EFAULT;
-- 
2.56.0

