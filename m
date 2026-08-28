Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D534826F2A0
	for <patches@lists.linux.dev>; Fri, 28 Aug 2026 15:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787931016; cv=none; b=VaYbLeqNANBiECw4AWiPs0UEM+XHU+yzgTkCoUuJZTaFeecT1e+1mZcCQBHTDGPIJaYRnJ3UKo2lQKmg9DoVg4+dHmQWgwSJ1NfG4ojxeIzBQibg47E/qd4UK4Vr34dkLeKBmN7g05mcDuKV6PD+PhsRANK7oknXuoq2gNWEShA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787931016; c=relaxed/simple;
	bh=HpecKzAkGcpxLpmYZHTcW/XUvoZtgeFLIan1qLdyY6k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VWF7jZP0VzRbGlJ9n9f+mmwJ6AiNMwlPF49o6eVZS6K5mj9WWxQYFlWoip6OwnzNjMf8+4qezxuh5n6tbCDQkS8GFTU7Sfl2FEL00IE4RGGIYC4+rvwSATCoisMVKE4GCMjnHjdBqD2jf4n5xjczT93M1q2RLoEnj9CL28e7O9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gXQDiLZ+; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gXQDiLZ+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787931013; x=1819467013;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HpecKzAkGcpxLpmYZHTcW/XUvoZtgeFLIan1qLdyY6k=;
  b=gXQDiLZ+LxRuZhUadqblVdxrSdaj6lQxuOrVrpfDgTflm7TzuR5uz+bX
   x8SrPou8NIariLWAyk/NJwKy6iSi83bbvhtME7bUIJwM/HdlJXoLdnoCW
   dzwJOHdDJ23gwLhPyfrr3UEo+OcAeFPvVj09myPL/mL97Z5rGRsV0ywMK
   Upqy5o4kM+92xF38f6JXb+eLxkZ3A31FXAbhApABRWxTn8ZQmWL2RkKz8
   W+iqmVG0NUh/9hi2YIR9Yz+mz0n14X9lrPXkKHW3yosMWDBUCPuBMecoT
   nmAbdPf3w8azi5srIJZdxDd1jcVwdckr6jyXCq4n3aipyAnEuTbCIYiQm
   Q==;
X-CSE-ConnectionGUID: Gnlz+IzERFi98/pEqmovSg==
X-CSE-MsgGUID: gyyA+9mnRJuRP8osNlD7aA==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="99104579"
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="99104579"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 08:30:09 -0700
X-CSE-ConnectionGUID: XCpVCHpzQjiu2R2q0n5h7w==
X-CSE-MsgGUID: KXSngloCQxC6rC7Xu4fs7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="291682269"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.223.138])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 08:30:09 -0700
From: Tony Luck <tony.luck@intel.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Breno Leitao <leitao@debian.org>,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v2 0/7] EDAC/intel-bff: Driver to reset bitfix filters
Date: Fri, 28 Aug 2026 08:29:55 -0700
Message-ID: <20260828153002.10290-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some Intel CPUs implement a "bitfix filter" to suppress reporting of the
same corrected errors repeatedly in the case where aging silicon
develops stuck bits.

But when systems run for weeks, or months, the filters may become clogged
with transient errors.

When the filter is full (indicated by a "yellow" signature in a machine
check bank) clear the filter. This may make space for additional hard
errors.

Save a time stamp when clearing a filter. Log with "WARN" severity if
the filter overflows quickly (in tem minutes or less).

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
Changes since v1: https://lore.kernel.org/all/20260825181526.13203-1-tony.luck@intel.com/

Boris:
	Change from a platform driver to an EDAC driver to avoid
	spreading RAS code into yet another corner of the source tree.

Ilpo:
	Use <linux/bitfield.h> macros FIELD_GET() and FIELD_PREP() for
	bit wrangling.
	Did NOT add comma to last initializer for dmr_mcbanks[]. The
	list is complete, this CPU model won't add extra banks that
	support the bitfix filter.

Sashiko: https://sashiko.dev/#/patchset/20260825181526.13203-1-tony.luck%40intel.com
	Ignored complaint about lost #GP faults. The driver
	checks that the feature is enumerated, so #GP can't happen.
	Ignored complaint about overwriting bits 63:1 in the reset
	MSRs. Only bit 0 is defined in these MSRs.
	Applied suggestion to save bank number in upper 32 bits of bff_id.
	a/IS_ERR()/xa_is_err()/ for check of return from xa_store()

Miscellaneous:
	Added entry in MAINTAINERS file
	Applied some cleanup suggestions from internal AI review.

Qiuxu Zhuo (1):
  cacheinfo: Export get_cpu_cacheinfo_id() for loadable modules

Tony Luck (6):
  x86/mce: Add enumeration for Intel bitfix filter reset
  EDAC/intel-bff: Add stub Intel bitfix filter driver
  EDAC/intel-bff: Add Diamond Rapids support
  EDAC/intel-bff: Reset bitfix filter when it overflows
  EDAC/intel-bff: Compute unique ID for overflowed filter
  EDAC/intel-bff: Report frequent filter overflows

 include/linux/cacheinfo.h        |  12 +-
 arch/x86/include/asm/mce.h       |   5 +
 arch/x86/include/asm/msr-index.h |   2 +
 drivers/base/cacheinfo.c         |  17 ++
 drivers/edac/intel-bff.c         | 295 +++++++++++++++++++++++++++++++
 MAINTAINERS                      |   6 +
 drivers/edac/Kconfig             |  13 ++
 drivers/edac/Makefile            |   2 +
 8 files changed, 341 insertions(+), 11 deletions(-)
 create mode 100644 drivers/edac/intel-bff.c


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
2.55.0

