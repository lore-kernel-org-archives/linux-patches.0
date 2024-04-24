Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C861C0DF8
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982536; cv=none; b=c1nmrt4/SCt+393Qz60IsPm29iXMQUSmqWDfcVYEOkiIVyCpQYY8IU5BXKEIC++FsSQ2qX//NVWUEgmM3QHoctE5Sr4Zwp9/U3oqRAiAjUIocum732KtrDujqCjy3jUHj87sdNcUmHRC0BbaM6yrJXky7+nSx1Qzx5Dz530Hzt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982536; c=relaxed/simple;
	bh=xK5hwg6ILPkC2v4d4nuHc6WucRElJH7HgJqquuK12yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hb0g8LybFE0kYJzJeWYdfbw5Uen+kdI9ZXDmkpEoms/XNGGlrueOJumsoYhfd5YrA39mMLTptzrrqHBD01fUWGqPwIKI2OJipBRnCM/CZiLlTDooetxki9BbUE/hrbj8OwGuvqfckOPACZpOMQMkNdbeEfBTFQXYP+QFDjMaruQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f5GuHdxZ; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f5GuHdxZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982534; x=1745518534;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xK5hwg6ILPkC2v4d4nuHc6WucRElJH7HgJqquuK12yY=;
  b=f5GuHdxZvomP+utw5/vYnB6/6xejUzOpoHM7JgjeJOg/AWSsCabnf9LR
   TYBj5zdfLloHIetqK//amXR2lat9Bd7Ah0SUYTx0bjB7HC41y/bXwLRxx
   85K6xyPH+fNtpLdSCgjrjSypya7arCdq7UfB6df2W8lXFfKMzbNuu4waH
   lLfeCn+EybTpKG9B44unohKTQ2DMexNaEa8oDjOHtQTnZ+i8l9uH1C+p9
   Ofov7ABhfNNrBTi23BmK38h+iZFz2I8DZghzbn2KzaY5hD9BvD4pQK2Ec
   gG9SXNxQkltMBYljsHENgg7YCRAhQalFYvRdCwoxprtLhPK46LTc/C+KJ
   w==;
X-CSE-ConnectionGUID: c/XZTxr4QOqldFtQhi2XNg==
X-CSE-MsgGUID: bpFh44XWR/CVeerO0P73nQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9503641"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9503641"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:33 -0700
X-CSE-ConnectionGUID: g73wVqPSR2S9jaEoDl2w+g==
X-CSE-MsgGUID: 7OARLnhRQjGS6vNr5SQNMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="55750215"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:33 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Chen-Yu Tsai <wens@csie.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 53/71] extcon: axp288: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:32 -0700
Message-ID: <20240424181532.42178-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424181245.41141-1-tony.luck@intel.com>
References: <20240424181245.41141-1-tony.luck@intel.com>
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
 drivers/extcon/extcon-axp288.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-axp288.c b/drivers/extcon/extcon-axp288.c
index a703a8315634..d3bcbe839c09 100644
--- a/drivers/extcon/extcon-axp288.c
+++ b/drivers/extcon/extcon-axp288.c
@@ -108,7 +108,7 @@ struct axp288_extcon_info {
 };
 
 static const struct x86_cpu_id cherry_trail_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,	NULL),
+	X86_MATCH_VFM(INTEL_ATOM_AIRMONT,	NULL),
 	{}
 };
 
-- 
2.44.0

