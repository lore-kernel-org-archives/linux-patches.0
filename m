Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792447678;
	b=LvXqTEj5qpNTkBFg98x5+mcIqbU2LmrumWNlEOOoBU8O+LPG/D9G9w2nkpL6I/ZbzYoA
	 mAgihmVfpt+cRCW9CyEVAO4H21ynIKDIiCxKHD6RZRaReVLK0WVIYImwXF6g0hk/6AgSc
	 B6oe7imfAQGhv7vyWAOOT709ddbhPMxUJTCHizsctyYrVgIDKR0JzJs7UB7MsfoSSmiWH
	 qoJfPciAFxPK/g7EVI61zVAPtDFR5vZmeezvN+nJRLr3qxBll+Wfrr4Wwq/w3MrRtA7Y6
	 Y5T9+CfBEZO3Z/CkApnx3kzv/Zm0h2LsNbuFKrEeZqpoNDcSrnoY1ILakVSl/j/o6Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792447678;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=S4jhFytiI66cmmm6AXrsnro4R7bcDCLYlnTCIFvr7kE=;
	b=0wKr6/iKWbxUYy7oQuGfMFLfdpV/1ITI+GTnBSLlpjXDSV9g03Gp/EKroY7tbWeusCKq
	 p/AFBksERImibGs/1D21Gh3PV1+NGotwQ21LYayQmuVlEdoFCC2y4ptBM+DsTw/0PrCjS
	 a6rtflop0t3DjBw3zBIPue6zOXJaPYkjmSkY+45ScUiQoVMAJUZftKNfPjdU56QoitB0C
	 yenrm7c2qAwwO3+Vb9h6mP9ur/UFKc7ilQA9oumAidGneQ4sY3nbdpqrjERMEPj+lJGI3
	 K29JFpiD7jEN4EPSVUF82vg7q5Hongs3mhKglk0kVs7FUHiD4LgvndSlN3Ij2PsAvfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=RCItmiej;
	arc=none smtp.remote-ip=192.198.163.17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC80606A31A
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 22:07:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FC80606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=RCItmiej
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792447679; x=1823983679;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QQ9Bpf+tsb027Xat4FCScbe4wCVN+lfOpBdhngzVWbE=;
  b=RCItmiejCztd7CV0qzv20O3pnDMRDWOL62/34fnbr8qT5FWyu+6pUEFC
   hSdvol3A+iI/6dTSxMKu4HVuubTzQghuAXsEZYurBts6ame9kysx4DDoR
   0rQGL8PLgB5i/1py8jKH0Sq6TbtEJQn4kvXKV2ke4kLQa2KeJrdxBg0Bv
   /PNOSpCb+ELhhunr6qBG/74nuHQ+DSrmjBpJMpOtzrSMAbCzA5bxnTwbC
   Aw3JXcHFPnO0s8MlSxq+JlUe6vK4/v+ZvF3zT9AK+laKJW5+DjbCJWtQp
   A527dZJ80swPpBTbyoK1VmEuPkGOtuxZnn1gOr5YEK0cxWMxjE1/MPyIf
   g==;
X-CSE-ConnectionGUID: bCs9sPjeSRC0bkvlvGKeew==
X-CSE-MsgGUID: U1U5Vz1gQbecLORtctEpPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1144168"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1144168"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 15:07:58 -0700
X-CSE-ConnectionGUID: MDzYSIG1SLubFn/53ZVIWQ==
X-CSE-MsgGUID: 0up9jIBoS/GQn2uwDl7dZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2708324"
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
Subject: [RFC PATCH v2 00/10] arm_mpam: resctrl: Separate MPAM domains
Date: Mon, 19 Oct 2026 15:07:34 -0700
Message-ID: <cover.1792443633.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.55.0
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

RFC v1: https://lore.kernel.org/lkml/85ca29e89eacf12cfa7071249419e7cadb8f0691.1788220029.git.reinette.chatre@intel.com/

The MPAM driver represents a resctrl domain with a single structure,
struct mpam_resctrl_dom, that holds both a control domain and a
monitoring domain. On a system that supports both allocation and
monitoring, one instance is created for each domain and its two
domains are added to the resource's control and monitoring domain
lists.

Holding both domains in one structure requires control and monitoring
to be done at the same scope, and ties each control domain to a
monitoring domain. This does not fit the proposed support for multiple
controls per resource [1]. There, each control of a resource, for
example a "min" and a "max" memory bandwidth control, has its own list
of control domains while the resource keeps a single list of
monitoring domains. With one structure for both, every control domain
would come with a monitoring domain of its own, which does not reflect
the resource.

This series gives control and monitoring domains their own structures,
set up and torn down independently as CPUs come online and go offline,
in preparation for supporting multiple controls per resource. Along
the way it stops failing CPU online when a domain cannot be set up,
and adds checks when setting up a monitoring domain.

  1-2   Preparatory cleanups of domain allocation
  3     Do not fail CPU online when domain setup fails
  4-6   Separate the control and monitoring domain structures
  7-9   Checks when setting up a monitoring domain
  10    Comment update, kept separate for review

An earlier version of the domain split was posted on its own [2]. This
version incorporates the feedback from that discussion. It gives each
type of domain its own structure instead of duplicating the shared
one, sets up each domain independently instead of undoing one domain
when setting up the other fails, and adds the checks in patches 8 and
9.

Patch 7 turns a WARN_ON_ONCE(0) into a warning that fires. It is a
separate patch because it is not clear whether the silent failure was
intended. If it was, the patch can instead drop the dead
WARN_ON_ONCE().

This is an RFC because I am only able to compile test MPAM changes,
which is also why the patches are small and each change is justified
on its own. Patches can be squashed if preferred, for example patch 10
into patches 5 and 9. Testing on MPAM hardware would be greatly
appreciated, as is any other feedback.

The series is based on the for-next/mpam branch of the arm64 tree:
git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git

[1] https://lore.kernel.org/lkml/d258a32f-12d5-464d-abe9-4720fb3e44b3@intel.com/
[2] https://lore.kernel.org/lkml/85ca29e89eacf12cfa7071249419e7cadb8f0691.1788220029.git.reinette.chatre@intel.com/

Reinette Chatre (10):
  arm_mpam: resctrl: Use find_component() when allocating a domain
  arm_mpam: resctrl: Rename ctrl_comp in mpam_resctrl_alloc_domain()
  arm_mpam: resctrl: Do not fail CPU online when domain setup fails
  arm_mpam: resctrl: Split control and monitoring domain setup into
    helpers
  arm_mpam: resctrl: Give the monitoring domain its own structure
  arm_mpam: resctrl: Rename struct mpam_resctrl_dom to
    mpam_resctrl_ctrl_dom
  arm_mpam: resctrl: Warn when no monitoring component is found for a
    CPU
  arm_mpam: resctrl: Require a component for each monitoring event
  arm_mpam: resctrl: Require monitoring components to cover the same
    CPUs
  arm_mpam: resctrl: Update the comment on monitoring domain setup

 drivers/resctrl/mpam_devices.c  |   2 +-
 drivers/resctrl/mpam_internal.h |  11 +-
 drivers/resctrl/mpam_resctrl.c  | 325 +++++++++++++++++---------------
 3 files changed, 181 insertions(+), 157 deletions(-)


base-commit: 8ea457f746d915d55f78b43d33b1cd618f3d93ad
-- 
2.55.0

