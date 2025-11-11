Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D26253944;
	Tue, 11 Nov 2025 01:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824104; cv=none; b=SW8KvaKJks/s1onz+i3BBfDPjj6XzZXLv+ewauHkPD7ygeYtji8RR1uQQXib0N/yPlpmmS99pWk07FhixRc885igs1yxfRVTB3sQtJiEheqeFgL5LJhxHwMNMwjbhMNpQUGFk0hutQ6vTok8sFDFZLs8pzcq+vw/hqA60x2m9Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824104; c=relaxed/simple;
	bh=lV1mpWq12QNLkCPfkt0EajkhOwouBaigRLkEDKsIbb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfJxoSey4xxZ4wZW/Jb8gUsODe/djGZucsplQlQ4Govd32oKAU2avEAHtJdlTFuKoGdOQoc6mup+1RxbSERzcYJpYacoawqCM7ZzSwXmoiGybFYd191Kq11G4KvXZKjaqUDJhq1B+K9Vpsenxk7ssrcrlthdwocdXvK6yz0pfpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdytfc1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdytfc1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C20C113D0;
	Tue, 11 Nov 2025 01:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824104;
	bh=lV1mpWq12QNLkCPfkt0EajkhOwouBaigRLkEDKsIbb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdytfc1hE7SjRfh+8Z6c++4XcHCju6jnVh9ASAe9Nsh0Mx5Grkacv+ht+k6lAPnci
	 mXs+c9SA7PQqjqobW1ubrYZSauEAvTmfmBSpxKrzTTQvsxyzx+59kEsf1KjdL6buum
	 xX8GWhGT1/u6Gn06sm9HckDEeKR17MOA2Aj86gqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 388/565] RDMA/irdma: Update Kconfig
Date: Tue, 11 Nov 2025 09:44:04 +0900
Message-ID: <20251111004535.599027257@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index b6f9c41bca51d..41660203e0049 100644
--- a/drivers/infiniband/hw/irdma/Kconfig
+++ b/drivers/infiniband/hw/irdma/Kconfig
@@ -4,9 +4,10 @@ config INFINIBAND_IRDMA
 	depends on INET
 	depends on IPV6 || !IPV6
 	depends on PCI
-	depends on ICE && I40E
+	depends on IDPF && ICE && I40E
 	select GENERIC_ALLOCATOR
 	select AUXILIARY_BUS
 	help
-	  This is an Intel(R) Ethernet Protocol Driver for RDMA driver
-	  that support E810 (iWARP/RoCE) and X722 (iWARP) network devices.
+	  This is an Intel(R) Ethernet Protocol Driver for RDMA that
+	  supports IPU E2000 (RoCEv2), E810 (iWARP/RoCEv2) and X722 (iWARP)
+	  network devices.
-- 
2.51.0



