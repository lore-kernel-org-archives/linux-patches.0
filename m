Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C783E1311A0
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643316; cv=none; b=TuI69Ami5xmR/QKf6YxUWUBHQz4d3mp5emal3HC9oNXkSmyCkWwJcUQx9zHdVofh8PET+5xsRlk4JMbQX3Xd2eDgH2N+ukB59CRdWcONM4tdmC614DQEXlv8eYq0/vlzAJfLFdENqN3UMWAtu/j6Db7Vn9dRRbm2KCg4ydGhBis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643316; c=relaxed/simple;
	bh=WV3qnx6+50b42Jf/GqLJUpAXvV6x1yHw3SQJ/gD5Xpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAmMmWBNIEssvxTwEhA2QtwqvgbQ+mdCEfxUwQZT9wYRJe68GbSuNRudf3jkzug/8tALb9a27OkqAtBmKl9isdcpcRJFmjkg5yas4ElZWIlqzjsXy8IwmJWJYzf0gr5Mla/GWuTrmErhrBZQtDQhUW3w8VJkvjbYiDGAg+y3W7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ivnDFZho; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ivnDFZho"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643313; x=1743179313;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WV3qnx6+50b42Jf/GqLJUpAXvV6x1yHw3SQJ/gD5Xpk=;
  b=ivnDFZhoSiwMtokDZeh590YHLrk1otR84TieqLECtd9Yw0cAWxqd2v7Q
   Ng/I/2d3c1pgZsYOii+B7mcHJWJr7klOenIwuqj7jTw7PS//E4zce/kJN
   3XC13rMgBDJqotyBkccZTy9DIY24d7JjdGYK8eZ31JtgE0FH3Nmu9eBG6
   KhJc9gTycWn/y6HTcFc1/lDrAzNUcIsy/KW3i3+OYlTwURtp6orGYKk8F
   peZlfur3pi4q/beArOa3EmqTj+FsJ2BOF0KnWvZRwfjMo/jtFYR7p2bnu
   4pdhr6LgE7OQDfXkMCJ85zkxIamWi5uaAL8awA9Vk+JgITMGWvGsLques
   A==;
X-CSE-ConnectionGUID: xAlPUwA4Ttabl1dURwwJlA==
X-CSE-MsgGUID: Cv4MAoicTZCzukf6LBzHjw==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294770"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294770"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726090"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 43/74] x86/cpu/vfm: Update drivers/edac/skx_base.c
Date: Thu, 28 Mar 2024 09:27:37 -0700
Message-ID: <20240328162820.242778-43-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328090459.242500-tony.luck@intel.com>
References: <20240328090459.242500-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/edac/skx_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/skx_base.c b/drivers/edac/skx_base.c
index 0a862336a7ce..af3fa807acdb 100644
--- a/drivers/edac/skx_base.c
+++ b/drivers/edac/skx_base.c
@@ -164,7 +164,7 @@ static struct res_config skx_cfg = {
 };
 
 static const struct x86_cpu_id skx_cpuids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(SKYLAKE_X, X86_STEPPINGS(0x0, 0xf), &skx_cfg),
+	X86_MATCH_VFM_STEPPINGS(INTEL_SKYLAKE_X, X86_STEPPINGS(0x0, 0xf), &skx_cfg),
 	{ }
 };
 MODULE_DEVICE_TABLE(x86cpu, skx_cpuids);
-- 
2.44.0

