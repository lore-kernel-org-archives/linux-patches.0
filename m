Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF32368968;
	Wed, 20 May 2026 16:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296301; cv=none; b=NMkm55huInq4yNvLhwgAFpZw8r9q/pef8/EZLxV4Tp/i7I0RYpF5bZGMAzQZXD4XZ8oB93Lo510qAbNn0UsWosSLtKPvdlyFHTjWAQ5QFe87pVbE+tv257uc3eCWAPT+zBL7sq6kMdsTWbn9fw6SBCu4DzYLRyHpZyKceHA2opQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296301; c=relaxed/simple;
	bh=ZLe7muEFLnS2mjWvM+i7H9B+FofBsRSdYxC7/LHAyWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEtX/bUWDvwT1wvROKKF1eLnyy0RLdX8BbW018S5OVHpN2yHWLLnksY+eYenkdKEB6Gf00Cp0XMzy+X6qmMaJ87HcISNvtU5h9xdl7AuYwgEDfayujc++c65FaWjF8uAPPOumqo2aC0AefNbXKf+fbOmFLQeymL1P18TBBkVf4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZBw+MfD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZBw+MfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36051F000E9;
	Wed, 20 May 2026 16:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296300;
	bh=TBA/fZHVbOUysIEQ6WTE2D9MJv5+8DyjejOdFa9aZtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZBw+MfDJ8sR/s2ksWwyEHL107fC5GVt12dxaisYPB8DJlgc8o/RchCtQGDK4NTDp
	 Wg9/+Iw5V+GMrzyhSq7b6e6LI+94r43HYU1CroGKQptPcGFzv57fxPmkc2PyrtGYTG
	 Xq4f20gy1QVwLNBi9R+uB+ELQzEVjz8ljJM2H6Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Vladu <avladu@cloudbasesolutions.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Roman Kisel <romank@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0748/1146] tools: hv: Fix cross-compilation
Date: Wed, 20 May 2026 18:16:38 +0200
Message-ID: <20260520162205.137141255@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya@linux.microsoft.com>

[ Upstream commit ca5ee0e918115fb5cf626d75461d9fca06e06caf ]

Use the native ARCH only in case it is not set, this will allow the
cross-compilation where ARCH is explicitly set.

Additionally, simplify the ARCH check to build the fcopy daemon only
for x86 and x86_64.

Fixes: 82b0945ce2c2 ("tools: hv: Add new fcopy application based on uio driver")
Reported-by: Adrian Vladu <avladu@cloudbasesolutions.com>
Closes: https://lore.kernel.org/linux-hyperv/PR3PR09MB54119DB2FD76977C62D8DD6AB04D2@PR3PR09MB5411.eurprd09.prod.outlook.com/
Co-developed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Signed-off-by: Aditya Garg <gargaditya@linux.microsoft.com>
Reviewed-by: Roman Kisel <romank@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/hv/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/hv/Makefile b/tools/hv/Makefile
index 34ffcec264ab0..016753f3dd7f6 100644
--- a/tools/hv/Makefile
+++ b/tools/hv/Makefile
@@ -2,7 +2,7 @@
 # Makefile for Hyper-V tools
 include ../scripts/Makefile.include
 
-ARCH := $(shell uname -m 2>/dev/null)
+ARCH ?= $(shell uname -m 2>/dev/null)
 sbindir ?= /usr/sbin
 libexecdir ?= /usr/libexec
 sharedstatedir ?= /var/lib
@@ -20,7 +20,7 @@ override CFLAGS += -O2 -Wall -g -D_GNU_SOURCE -I$(OUTPUT)include
 override CFLAGS += -Wno-address-of-packed-member
 
 ALL_TARGETS := hv_kvp_daemon hv_vss_daemon
-ifneq ($(ARCH), aarch64)
+ifneq ($(filter x86_64 x86,$(ARCH)),)
 ALL_TARGETS += hv_fcopy_uio_daemon
 endif
 ALL_PROGRAMS := $(patsubst %,$(OUTPUT)%,$(ALL_TARGETS))
-- 
2.53.0



