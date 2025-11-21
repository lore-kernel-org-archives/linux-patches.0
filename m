Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60924350A2F;
	Fri, 21 Nov 2025 13:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732808; cv=none; b=cefTX897rEDDteU04xqZSyMBlazNb3vU2FjAy8ODYMvL2Mn1HJ0KUwEjQV2P70Xlo/0eI6tREeb0exq//VWxk2We8EZnyQBhgkpGSNxBUHgnlhAbCL+DFDtKAMV9b5YaaC8YOrJxlZ9uUGHY6T3Gw/Xl22kmhu9lzCDOldJRQpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732808; c=relaxed/simple;
	bh=2UIODLEmcZ9YgjrBqTlAeSIosYHVIP7yDnliJFvIGAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i507MkQvffKaRSW93G30YBeVO0lMq/UXV29HBEQ3ctNgoDe74+dE8P2/LFB0plH3HvRaaOVmQcntBmQ+vkyHA74zXzSO+fwZvrgU4bdtyuns1Iuziy/UIWEr6GM5s6zHZZc+pJpc3PB7dmkq5BFagZHekF8XA4PIgc80l3gk+Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdrlbLqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdrlbLqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915B4C4CEF1;
	Fri, 21 Nov 2025 13:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732807;
	bh=2UIODLEmcZ9YgjrBqTlAeSIosYHVIP7yDnliJFvIGAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdrlbLqyciDTD4ALHbcPPUaiWr04Y9dUQeFMveHJgpSz+qRtPi73+6sTN9hFP0bZo
	 D7id/Vrmzv9KiCWGRQdaBmQACkKXBN392xZumbJli0EWYeL4telPtzjHWxmv/RoyX/
	 o5pGpcKRojjBC/ZqT9+FH2qKldkEy656iYUSjP+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 251/529] RDMA/irdma: Update Kconfig
Date: Fri, 21 Nov 2025 14:09:10 +0100
Message-ID: <20251121130239.948035019@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



