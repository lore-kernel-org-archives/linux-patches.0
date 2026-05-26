Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BF73C8C47
	for <patches@lists.linux.dev>; Tue, 26 May 2026 22:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779835110; cv=none; b=QgZC6GY0KE8uO70uIr0IEHzi0xC46N2zNHDuC8ancolPLtrnRCNU6ySJEPsfC9A0Wgir5GG7MvfqiduLWsv3dySf/c2prDmupejZx1ETytuyYyK9Xi1xjrhqaZiwHD3Y3qYf6jB3anncFSS7EYpM/PPYiaWU2H4wwl586c+uFeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779835110; c=relaxed/simple;
	bh=h6K3DKMQcOvxA1KWW3Z08ZOsxxlH0uMAXtHawD4i0gM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AZ3tFQ3N+PDfvOFcNSStn0brO8fgKpncsgtFhmyn6zGL0tpxWR/GcGWqgXQoo3XP9lNpOCIlEOq8l2OZQTXuN0KXwid4Ow/XgDZSrAC7t8OkAaIvQM9NHVT6uZ3Igo5KO8GRDRqE2UDJeG+4yqFwErpp82NbbB+q3u/hr9z2o4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ef/3JZI+; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ef/3JZI+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779835108; x=1811371108;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=h6K3DKMQcOvxA1KWW3Z08ZOsxxlH0uMAXtHawD4i0gM=;
  b=ef/3JZI+8QoqrTcC3WPfSs4Rp+00OufpGc0A5T7US++ffx67FG8BZgJn
   KVlQ9gMSpngZjPrQjAvJya5N1dxoSmonsApMBEytT7wNYHhQWronLXC00
   koIhRu26VGybWjs6GZbCeyiQJBCwTm5oolSlDIt1/qbfjTBM0LoaYbzAR
   1TqueWZfgoVm+FzfU86nbXgScaiUFRSDAq9glNtTo4fQij8ClRZlLBoBd
   Z0yrho2g5kTTg9U5btdacwkFzJvqPwXANTUzwoC/DrVw14E3GLYcHFzCU
   F0Fl2oKnBegOj4F557fMVbikrak9wK9E2rhNdTPMRfV0POE5OfiW4XMWY
   g==;
X-CSE-ConnectionGUID: 0LBGnpVsS9a6brHhpGC+VQ==
X-CSE-MsgGUID: HejlwmBCRja1c39ePrOJUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="79808483"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="79808483"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 15:38:28 -0700
X-CSE-ConnectionGUID: n5I69XSaTZ2C7u4zT86r7w==
X-CSE-MsgGUID: 5B4eJEk1RpqyHAZMb872Wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="242217081"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 15:38:28 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: reinette.chatre@intel.com
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH RESEND v3 0/3] x86,fs/resctrl: Fix long-standing issues
Date: Tue, 26 May 2026 15:38:19 -0700
Message-ID: <cover.1779834897.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

V3: https://lore.kernel.org/lkml/cover.1779476724.git.reinette.chatre@intel.com/

Sashiko encountered failure while reviewing the original V3 submission of
this series. This partial submission of only the last three patches of V3
is only intended for Sashiko so that it can consider the patches missed during
V3 review.

This submission lists the last three patches as 1/3, 2/3 and 3/3 since Sashiko
considers a submission only consisting out of 7/9, 8/9, and 9/9 as "incomplete":
https://sashiko.dev/#/patchset/cover.1779832265.git.reinette.chatre%40intel.com

Reinette Chatre (3):
  fs/resctrl: Prevent deadlock and use-after-free in info file handlers
  x86/resctrl: Ensure domain fully initialized before placed on RCU list
  fs/resctrl: Fix UAF from worker threads when domains are removed

 arch/x86/kernel/cpu/resctrl/core.c      |  18 +-
 arch/x86/kernel/cpu/resctrl/intel_aet.c |   5 +-
 fs/resctrl/ctrlmondata.c                |  38 ++--
 fs/resctrl/internal.h                   |   3 +-
 fs/resctrl/monitor.c                    | 100 ++++++----
 fs/resctrl/rdtgroup.c                   | 244 ++++++++++++++++++++----
 6 files changed, 301 insertions(+), 107 deletions(-)


base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d
-- 
2.50.1

