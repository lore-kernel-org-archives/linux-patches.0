Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6E2305E15;
	Tue, 11 Nov 2025 01:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824862; cv=none; b=lbMy+EnuePbnHRzio5NqAjd2PrJADCVWGgc60v5URZeEJDgNmBnUKm4DMh4Pz93kDLqvuWciv8JVjLUmf/aTaMjYl4ttvY/tFuavSFdeezoDqOWvx9eua9olzb1wVcAU5ol5occ4HYMC3cKg1fRFqvh4MY2o0M77Z50xfTakxsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824862; c=relaxed/simple;
	bh=5L8AASuC6xpp72TNjZ+wXDmqf+UYBw/quzr7gFuz208=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjpbQ29ZRilXq5yDuc1j5jbfdaqYiYtD2hjLtg5CDvziENxSlqg+9pAO+GFFVUNG/SWAX+3acsfv4oIih4ZLTWTRpWHIqBWl20Bs8drrrRU8IbcITLehgw8nCS9Bf9GTc/69ik9THK7u+iyxuP8RN7sCI5maFLRiXj2/4XDigQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9MwIFWE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9MwIFWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47ADCC16AAE;
	Tue, 11 Nov 2025 01:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824862;
	bh=5L8AASuC6xpp72TNjZ+wXDmqf+UYBw/quzr7gFuz208=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9MwIFWEA9Lbolt7Eh0hKCz5UQqkpqqgGHMnlEvSGxwqJJ71wSdSdcESODbG1y1v3
	 ii4f2eyLdFZQ4DTCMJFydhbVMngdIV+kUL/PUcCrhWGVAoq/7gMP1e4r+O1P2GeYNU
	 Y7b0DoE7tTmRck/Nn9e4hUfCx9e1yG6Z30YAtrrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 587/849] RDMA/irdma: Update Kconfig
Date: Tue, 11 Nov 2025 09:42:37 +0900
Message-ID: <20251111004550.616147638@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tatyana Nikolova <tatyana.e.nikolova@intel.com>

[ Upstream commit 060842fed53f77a73824c9147f51dc6746c1267a ]

Update Kconfig to add dependency on idpf module and
add IPU E2000 to the list of supported devices.

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Link: https://patch.msgid.link/20250827152545.2056-17-tatyana.e.nikolova@intel.com
Tested-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/Kconfig | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/Kconfig b/drivers/infiniband/hw/irdma/Kconfig
index 5f49a58590ed7..0bd7e3fca1fbb 100644
--- a/drivers/infiniband/hw/irdma/Kconfig
+++ b/drivers/infiniband/hw/irdma/Kconfig
@@ -4,10 +4,11 @@ config INFINIBAND_IRDMA
 	depends on INET
 	depends on IPV6 || !IPV6
 	depends on PCI
-	depends on ICE && I40E
+	depends on IDPF && ICE && I40E
 	select GENERIC_ALLOCATOR
 	select AUXILIARY_BUS
 	select CRC32
 	help
-	  This is an Intel(R) Ethernet Protocol Driver for RDMA driver
-	  that support E810 (iWARP/RoCE) and X722 (iWARP) network devices.
+	  This is an Intel(R) Ethernet Protocol Driver for RDMA that
+	  supports IPU E2000 (RoCEv2), E810 (iWARP/RoCEv2) and X722 (iWARP)
+	  network devices.
-- 
2.51.0



