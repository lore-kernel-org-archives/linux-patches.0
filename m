Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60A3296BBC;
	Thu, 27 Nov 2025 14:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255479; cv=none; b=Pn7txyf4b3xccTC42lCbHH1w7Ofdb/SBAj7LknN0+huz5dStukdpc2wtKAUwiFWteYzGnJnqfUncVF19Q/RU9K8YrldoG+Jvye1bV/v/f56KOQjDLuc0803YfdlGsf1l/gJAMNPVPhDIemkqUxcIKss0G8umUfQmx3nZdnD/3+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255479; c=relaxed/simple;
	bh=H26oG23LLgvvmmjgFSPOBl6HNZKl2cjphe5R3XLV1SI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZsb60/loR4hpaUX6SsNg4ILbSSkvJp5l6fan3F3F5S2JttWj5/ezg1M1z7WmiXAcTSWIvDRx5idfcH6BnCkxhBAmH8m8ABJOyPBCL9H01y+4LRiVM/WL+0zTitRqzSfpsaXxtE4SL1yaMSTuryrWIpzREhfHGAZO65E7DHHOrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3Q8OBfr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3Q8OBfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4800EC4CEF8;
	Thu, 27 Nov 2025 14:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255479;
	bh=H26oG23LLgvvmmjgFSPOBl6HNZKl2cjphe5R3XLV1SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3Q8OBfr5P2DDIcrSAR+f/T65m8CiLh5myyJSBLIptZYep9GMhuq1czBV9lFQWSy0
	 ayc3rSYqcSfto5J66vBtXjrZ475Ay1ICNynkg0wHFFBlel/a4L2Xx+H/a+Xre8wvYz
	 G+B2yMIaxInhtw1INuBNwuoO+mSiIiPbgaZ63rk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/112] Revert "RDMA/irdma: Update Kconfig"
Date: Thu, 27 Nov 2025 15:46:37 +0100
Message-ID: <20251127144036.318080212@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

Revert commit 8ced3cb73ccd20e744deab7b49f2b7468c984eb2 which is upstream
commit 060842fed53f77a73824c9147f51dc6746c1267a

It causes regression in 6.12.58 stable, no issues in upstream.

The Kconfig dependency change 060842fed53f ("RDMA/irdma: Update Kconfig")
went in linux kernel 6.18 where RDMA IDPF support was merged.

Even though IDPF driver exists in older kernels, it doesn't provide RDMA
support so there is no need for IRDMA to depend on IDPF in kernels <= 6.17.

Link: https://lore.kernel.org/all/IA1PR11MB7727692DE0ECFE84E9B52F02CBD5A@IA1PR11MB7727.namprd11.prod.outlook.com/
Link: https://lore.kernel.org/all/IA1PR11MB772718B36A3B27D2F07B0109CBD5A@IA1PR11MB7727.namprd11.prod.outlook.com/
Cc: stable@vger.kernel.org # v6.12.58
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/Kconfig | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/Kconfig b/drivers/infiniband/hw/irdma/Kconfig
index 41660203e0049..b6f9c41bca51d 100644
--- a/drivers/infiniband/hw/irdma/Kconfig
+++ b/drivers/infiniband/hw/irdma/Kconfig
@@ -4,10 +4,9 @@ config INFINIBAND_IRDMA
 	depends on INET
 	depends on IPV6 || !IPV6
 	depends on PCI
-	depends on IDPF && ICE && I40E
+	depends on ICE && I40E
 	select GENERIC_ALLOCATOR
 	select AUXILIARY_BUS
 	help
-	  This is an Intel(R) Ethernet Protocol Driver for RDMA that
-	  supports IPU E2000 (RoCEv2), E810 (iWARP/RoCEv2) and X722 (iWARP)
-	  network devices.
+	  This is an Intel(R) Ethernet Protocol Driver for RDMA driver
+	  that support E810 (iWARP/RoCE) and X722 (iWARP) network devices.
-- 
2.51.0



