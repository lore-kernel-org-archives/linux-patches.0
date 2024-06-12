Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BEB16D31B
	for <patches@lists.linux.dev>; Wed, 12 Jun 2024 08:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718180269; cv=none; b=j9ZYcAGIGepRxcxFuIMEdAVnmRL40kf8Bm7ddxbU5tl2O8reE8qDdsgF47Vs6SWv3f0j4ZX6HWG1OEkA/QDw7T1zDJWVc7vLKhm6hDINxGQutwYIgZyk5Sj2XmmHwDjCusZoU9iPk3c7EJfZbG+BDKGSoLjU7Lt/f2f3yE0njTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718180269; c=relaxed/simple;
	bh=QcEF0sKXV5ZBAmtYMHhZHVLLMVcw7FqLHJp1lyXLpYU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=cDdr+YeZhfjT2To/5WdXBU7Yqft0TosXX6061sbpEWrFm1tvyTsI8W5USF5bvJ6kxvtlXvVQRcW7O7fhVU/J0OAVV00ZbjE/pdND8hag1I63vliEcqMduXQB01iH+WO25JxzgkM6+KvOC1sL4new7dWxNu6NYCjRg+JdJOH0H+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S282lu6h; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S282lu6h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718180268; x=1749716268;
  h=from:to:cc:in-reply-to:references:subject:message-id:
   date:mime-version:content-transfer-encoding;
  bh=QcEF0sKXV5ZBAmtYMHhZHVLLMVcw7FqLHJp1lyXLpYU=;
  b=S282lu6hU9ZWt2YvQi97XdbnKkHl9bPr8RwdkOzczyfeeABo2su7/52E
   kf9Jgr5uBV7p+iFqjGQfwQfju+9qwaBu4tb+O0pSBrHUAe8i42kSLJU59
   fiasRonVv4FrwT3kHR4/ML1M/AAzc8rJ/w+wWIQt2vjKs5EbkrhcjKxCx
   mB8oIet8givDNDzECW+p56poHic1npVMdafmd7GhZ5vbCgI3oSr3cmCcs
   5x61ArvP56t3hUV7bgp3Ig2tNFZiCreiqSj/UufpoY2qXS9cxSDBp0yqm
   b6zys4NWbTknJE+0p5ztycBmpBGsypk4mROD9NL9q1QO5qihuSwpVXirn
   Q==;
X-CSE-ConnectionGUID: g5cq1QCNTBKxy3q02eLcIQ==
X-CSE-MsgGUID: yhY37k4RQVST87pOPK29oQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="40337113"
X-IronPort-AV: E=Sophos;i="6.08,232,1712646000"; 
   d="scan'208";a="40337113"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 01:17:43 -0700
X-CSE-ConnectionGUID: WyntrCBfRuKPHpdPJp1Kdg==
X-CSE-MsgGUID: ApWrOod5RFCqLD/zMVAtzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,232,1712646000"; 
   d="scan'208";a="40180479"
Received: from unknown (HELO localhost) ([10.245.247.204])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 01:17:40 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>, 
 platform-driver-x86@vger.kernel.org, x86@kernel.org, 
 linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
 Jithu Joseph <jithu.joseph@intel.com>, 
 Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <20240611171455.352536-1-tony.luck@intel.com>
References: <20240611171455.352536-1-tony.luck@intel.com>
Subject: Re: [PATCH v6 04/49 RESEND] platform/x86/intel/ifs: Switch to new
 Intel CPU model defines
Message-Id: <171818025089.1855.17784413167917645490.b4-ty@linux.intel.com>
Date: Wed, 12 Jun 2024 11:17:30 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13.0

On Tue, 11 Jun 2024 10:14:55 -0700, Tony Luck wrote:

> New CPU #defines encode vendor and family as well as model.
> 
> 


Thank you for your contribution, it has been applied to my local
review-ilpo branch. Note it will show up in the public
platform-drivers-x86/review-ilpo branch only once I've pushed my
local branch there, which might take a while.

The list of commits applied:
[04/49] platform/x86/intel/ifs: Switch to new Intel CPU model defines
        commit: 490d573b5a8579178beb648a69a2cbab91495a7b

--
 i.

