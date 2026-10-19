Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792447683;
	b=ovIl8il4KO2eHYT8pmsnyYbW0SsIZJKa16bkVdHJPstJTQ22q/gf7bVr/Eq7Lz1cQ+eL
	 PPFo/CojRRlIQ84g3BFjY0EgxxuwuHrdgdyT55apBUQk1VwwEkz4qWdfgDLFsGz0Y6jSD
	 F+Nuk1Qa0DOCO1c7HWp0bS7Bd9qm67Zf68TBNv9BKbfQiLcy7dNI7akTbdyeCriwSiIVw
	 q5Kp7hQLFeBTFt+xIGbaPVpOGEO2XsDoGQB8pAZfthRPcaSeKueXSWji1L5pYc90RJjrF
	 d8a/TFP8B88reG7fbNh3riKfwk1g4s6ZFrMJZF/Xq6LZiavhJYmDTgFCIExQwSX54uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792447683;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YeZNYunybcxy/NfWb6jCfz+TaK9LyyfOatz74eHc0KM=;
	b=juJ46cEokXVS6ceDfM1Dysmc1ByjzCC9wNia5rRn+0PxxQMo+1wVoLj0zBXl2BzmkLvb
	 ikeV0iDEnZxHHnxm5E1PfzMk47wEFskX3CUChSb2Z2ne9GQ0kQqCFF7I9gpDNek7mfYTc
	 wSAWHcGQ8N9jEgAf9GI6D2G8Wm9Bmg9jvUmm3fHxpgmnnBtPe5vfJH/DxsKLLjqEiAagi
	 0YXYs0IODatRA4YXmXdN6A9+y1num79Kta1ivCnN5LSDKdRyOZNkjc1KgGmvlGeGr5aXZ
	 K6WeZajKpImmln553MEdd/jAdwAjbUiufluZqZCwWIvlKgHXNfNb9AWhpf023hiQ7Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kOaBxOLk;
	arc=none smtp.remote-ip=192.198.163.17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B14606A336
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 22:08:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7B14606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kOaBxOLk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792447681; x=1823983681;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9RK0cTSErpvZvdFlmTLHSVOodu/G/WUGFbYDPDtGi7Y=;
  b=kOaBxOLk7Z9rBmdn/3tv7RGV5eWhdtrH0JP5OlHGFGG3I18f9E3YWdaH
   e6C+TknuJMyD8wtHFzkMaEuQPF2O6u1xMYfvsw0oRU82/Abgt404e79hn
   XOQ7rjqMcqCeeOQrXYlUJhdtc379BorBw0OCPG5+1+L3W0PamVPzIeZXY
   ZElkc3nc1Q8Sa4G+MPlzOXfudW0s7hI1JQIPpXGnjUQobMqk/GhUXo/IJ
   Eu38GhDCBAfC4TZ2RMNuJfnh945218cTgEBTVqHvYyM0VIQHgv0zxHZ26
   Clcty0fqBmUvFqAO1jybaO7KMF4TfY7o6SAEKtjMWtZFb3NSwFyX7zS4N
   w==;
X-CSE-ConnectionGUID: wBZ6ts9NRpiOE+vOi9+HzA==
X-CSE-MsgGUID: bko6Yu4QRiSKQ3GecaSOxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1144218"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1144218"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 15:08:00 -0700
X-CSE-ConnectionGUID: Jy1DBh7uTJOEd+iqTAl12Q==
X-CSE-MsgGUID: QVEI9MElQH+S/ejUvlxmHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2708346"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 15:07:59 -0700
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
Subject: [RFC PATCH v2 07/10] arm_mpam: resctrl: Warn when no monitoring component is found for a CPU
Date: Mon, 19 Oct 2026 15:07:41 -0700
Message-ID: <1c68a6ae981095ec93250cf0e394bb4df15c7e66.1792443633.git.reinette.chatre@intel.com>
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

Setting up a monitoring domain fails if no monitoring class has a
component that contains the CPU. This is not expected to happen: a
resource only supports monitoring when at least one monitoring class
was picked, and only classes that cover all possible CPUs are picked
for monitoring.

The failure path calls WARN_ON_ONCE(0), which never warns. The
unexpected failure is thus silent and the CPU is left without a
monitoring domain with nothing reporting why.

Warn when no monitoring component is found for the CPU, as is already
done when setting up a control domain finds no component in the
resource's class.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/resctrl/mpam_resctrl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 022920be1862..63c5bf45856d 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1665,10 +1665,8 @@ static int mpam_resctrl_setup_mon_domain(unsigned int cpu,
 		if (mon_comp)
 			any_mon_comp = mon_comp;
 	}
-	if (!any_mon_comp) {
-		WARN_ON_ONCE(0);
+	if (WARN_ON_ONCE(!any_mon_comp))
 		return -EFAULT;
-	}
 
 	mpam_resctrl_domain_hdr_init(cpu, any_mon_comp, r->rid, &mon_d->hdr);
 	mon_d->hdr.type = RESCTRL_MON_DOMAIN;
-- 
2.55.0

