Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEF93563EB
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 18:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772477190; cv=none; b=MFhK5XRYA/t7uQsU8MgHFv2R/vzq62S7a43JpH0NfXQCTqBcZD4jJiR+Q90hkJUn5mBjrzrBKkvwMSQ60weOjK96BfqaVNE0PN3gkStzDuZ1v3fV2xFSRinvPgwYYPBJvbyZu9hAa5bpYwhsrBP4nb51rEFUpzmwX+56iwN+ONI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772477190; c=relaxed/simple;
	bh=zWYgo2TYhNeEHB8V8WV2tR63dZU59nyuZTE5XHA2GX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C+coYHHo/aG6qSqKRfloSRpcz8vDzf56COz13KgGOyRKLjgrxNyfHBFc2JpENMEqPVBSwGcOZnJm1ieIfygA7mcGSQtvKaAeQ+YHxOIbzEBPGKthTo6+ihTzBSB3+M5YypuS3wstMfMl5B3Oln+4Wj1NhgZQ+SRtg6wJn0Tturk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G86vJgLm; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G86vJgLm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772477189; x=1804013189;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zWYgo2TYhNeEHB8V8WV2tR63dZU59nyuZTE5XHA2GX4=;
  b=G86vJgLmsaIFjiDVCH6VTg3fpbhVGsye1sF+JtRPo0XhkXK7qn0vsTw7
   zrg6CpNlR4rBCUvCg7ZUheqJl0i6YsqlVjKfmW48HuS69AF8bi2Imb0gI
   yzc0bXef76whtOoxoWDL2z6Fk2INs24PkO/V9STsD4WqN76+8pzhgKYx2
   K33IostS1GNj6sQAwdrALEN5GirvlFQkbdyzLKO0FmSkp745fI56x+s6H
   cU8ADNFGjxIsYJ0hrLH9mECwWwvtVfXYr+TmxIc9eqT86RFR1m20Qnx55
   jQW86Xb/DF1ESnPR+WwGNq4YhVR4qKkgd2SL+ev7tjsR5380CcYQFGPYf
   w==;
X-CSE-ConnectionGUID: lIe6ApCvQQKn/73fzQVq4g==
X-CSE-MsgGUID: DsPUWnerSXuPWROyNQB2RA==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="84135435"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="84135435"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:26 -0800
X-CSE-ConnectionGUID: 1XwbRuMhS66K1jMpdPpFag==
X-CSE-MsgGUID: N5b0hfajT3qS6OpKgAyjbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="255604080"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:26 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH 02/11] fs/resctrl: Avoid "may be used uninitialized" warning
Date: Mon,  2 Mar 2026 10:46:08 -0800
Message-ID: <71100a0c6f616bbb2da30d045dfeeaedf18bcd0f.1772476561.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1772476561.git.reinette.chatre@intel.com>
References: <cover.1772476561.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Building resctrl with extra checks ("W=12") produces the following warning:
 .../include/linux/ucopysize.h:22:17: warning: ‘buf’ may be used uninitialized [-Wmaybe-uninitialized]
   22 |                 __check_object_size(ptr, n, to_user);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 .../include/linux/ucopysize.h: In function ‘pseudo_lock_measure_trigger’:
 .../include/linux/ucopysize.h:10:13: note: by argument 1 of type ‘const void *’ to ‘__check_object_size’ declared here
   10 | extern void __check_object_size(const void *ptr, unsigned long n,
      |             ^~~~~~~~~~~~~~~~~~~
 .../fs/resctrl/pseudo_lock.c:754:14: note: ‘buf’ declared here
  754 |         char buf[32];
      |              ^~~

__check_object_size() ensures the provided buffer is within a valid location
but does not read from the uninitialized buffer. Even so, initialize the
buffer to silence the warning to help resctrl have a cleaner build.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 fs/resctrl/pseudo_lock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/resctrl/pseudo_lock.c b/fs/resctrl/pseudo_lock.c
index e81d71abfe54..a857e51580e2 100644
--- a/fs/resctrl/pseudo_lock.c
+++ b/fs/resctrl/pseudo_lock.c
@@ -750,8 +750,8 @@ static ssize_t pseudo_lock_measure_trigger(struct file *file,
 					   size_t count, loff_t *ppos)
 {
 	struct rdtgroup *rdtgrp = file->private_data;
+	char buf[32] = {};
 	size_t buf_size;
-	char buf[32];
 	int ret;
 	int sel;
 
-- 
2.50.1

