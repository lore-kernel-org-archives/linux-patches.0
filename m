Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C67335BCF;
	Mon, 18 Aug 2025 13:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524267; cv=none; b=NVlbyyke9Cyh+0dOND2u0udSyhuDXkMGW88QZdYnpAnqrgBSnKNB5deawlZYXrAdTl2cTBo2dORLtt74GPxrrW88pzw/fPdacYBrjDTQvtJyu9ZjLj2QabNEz2Me8dUGU5HtJz0LfYRhE1mjVcrZBWXxXq5vDC98b+UE58NgyQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524267; c=relaxed/simple;
	bh=O1mJkTu456w+PEHeDmEzLo+eF1sUyKdQdhU6uOQhKRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1q3JaJfLF/Sp3UmSkhdjpZF86+CScB0SIc8PbD3OyMwBBz7ID94SM2TxalLr/73QjUnvCpMfkmYThvTLBmQE7iakJexUT2xJP8M9vCqZuIYnSCe/s31qK8G6HQNmGcbopfPQywi6V6EL1k3q2bJRAWo7v4Dez8/dGNr19W3EDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Me5H3xmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Me5H3xmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3A9C4CEEB;
	Mon, 18 Aug 2025 13:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524266;
	bh=O1mJkTu456w+PEHeDmEzLo+eF1sUyKdQdhU6uOQhKRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Me5H3xmL+uZhB0oEw/gN+jdRDZEA8fDarINTaQ2BPokyp4jI7duq1cZvR/vfLpLoS
	 odPaBi7cr/3YxnZ4uKfw+lKFD0pqAPqFCaCTUylAH4H74xyrTSpgDKdyEHyuhD+oCJ
	 OsAmYG/qQDb6mDE851DrP1Owth0Bd7Vwkjlnl1d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calvin Owens <calvin@wbinvd.org>,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 419/515] tools/power turbostat: Fix build with musl
Date: Mon, 18 Aug 2025 14:46:45 +0200
Message-ID: <20250818124514.560230916@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Calvin Owens <calvin@wbinvd.org>

[ Upstream commit 6ea0ec1b958a84aff9f03fb0ae4613a4d5bed3ea ]

turbostat.c: In function 'parse_int_file':
    turbostat.c:5567:19: error: 'PATH_MAX' undeclared (first use in this function)
     5567 |         char path[PATH_MAX];
          |                   ^~~~~~~~

    turbostat.c: In function 'probe_graphics':
    turbostat.c:6787:19: error: 'PATH_MAX' undeclared (first use in this function)
     6787 |         char path[PATH_MAX];
          |                   ^~~~~~~~

Signed-off-by: Calvin Owens <calvin@wbinvd.org>
Reviewed-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 3e97b69b1dfb..2c77ec8df67d 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -67,6 +67,7 @@
 #include <stdbool.h>
 #include <assert.h>
 #include <linux/kernel.h>
+#include <limits.h>
 
 #define UNUSED(x) (void)(x)
 
-- 
2.39.5



