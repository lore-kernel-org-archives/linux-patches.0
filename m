Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9030234CDE
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 19:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709149039; cv=none; b=H7WHDNElRbzNYgTlqmeUDpD7FUyT5qtDuQG+KZQvm7lbkKLQf0NEDv7Fsud+gIU/6irHnU7v1keGSnLU9sc+rHsjehjQ4hFyr+IC2QM+79UGXAQ0LRttuFjXz4efXQrRpJ6f6AR0eBEbNYkrq1og/ofx4NUBowf2xrutJkuZiRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709149039; c=relaxed/simple;
	bh=AhfxLr/83mflKKSZVwlaixwiAXN8C4YuoVO5+sBcaaY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QTKx0iJcUMFcEDgbX3Llf+go1iAn7RXUJfMeD2PcQsXWq1pKyJKKgpPuqBMybrXf/ct3CCfdde9v9KYlH10Rz0f5q3m5B1LLAxuia8EWdEgu00USUpWDdWdyBTsOIO7M7Sx6sYUla0lCgAiB+Se/8rB8SAWLRwFbj8KrXGZLB5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h6Tu05pI; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h6Tu05pI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709149038; x=1740685038;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AhfxLr/83mflKKSZVwlaixwiAXN8C4YuoVO5+sBcaaY=;
  b=h6Tu05pIyEz5+s7fPZVoe9839xtGiuIa3JCeITzPbtHNfFy1dETUhaDg
   N7IqlUd5ipXEM1ZH0VscITO/Ykam1J4jwXPSvi4WSUjLenDXG786LSrxe
   fWQnh3ixfMj0QL/SxhzRIxCjyctCzwaNU28CEyQUM9efnkts+1a6ePENJ
   jBkSto1HYV8RcxXrV39zE2Sz6aEhO1yuoaFqx5pjj15UAByqLlWablOoX
   XgOOyy8dzfgrqLDelk0aThk7VI8e45KvcenTaOIRNJL4zGmZ3+lFFflKF
   bI9kmzGyPAGl8poZG5PX1I+2u4bcMHXSuMpyuqNJq43Tj9ShxEbakfYxl
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3495435"
X-IronPort-AV: E=Sophos;i="6.06,191,1705392000"; 
   d="scan'208";a="3495435"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 11:37:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,191,1705392000"; 
   d="scan'208";a="7485359"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 11:37:16 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Drew Fustini <dfustini@baylibre.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev
Subject: Cover-cover letter for two resctrl patch sets
Date: Wed, 28 Feb 2024 11:36:51 -0800
Message-ID: <20240228112215.8044-tony.luck@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hook these two series together in threaded mail clients
since the SNC series is based on top of the two patch
cleanup.

-Tony
