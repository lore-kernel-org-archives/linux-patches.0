Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896052144BF;
	Wed,  7 May 2025 19:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644678; cv=none; b=sJr1ydjhL0glXtVJLRxut0Hu21/RNNEyT/tqDHftgfJpcVylaLon94//ne2ltxPAK9gc33AqQ4n0r5Pk6uf36IiphZL1ktL+4D1ygZByRXJ1Pa5PmIzOGp4cVMuyk+3lUcvo2NbgsqPdaWJDl0ZrpiYHn0FVJspANZ4DyMpGigs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644678; c=relaxed/simple;
	bh=fMs1/0qiGf8/WSLbQCGZPo9Tv5l9hIUQ5bwyT28Qc30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqMUEO8NoOQ+FN1ayrD0Le/hvEdOKLu6SiJPXTKAOpUoE/clw24CYk8nHrqPZqUPbtjfAx/h6/0AVKNO0j1cuFj3cj8+jHBRswIKUCuu+JISXW4NVewvhayi8fjwL9sPvvNtxUuXIOhOFor6GrzTkeSGhMSDEeI/iwDm3b1cCvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctXvO6UC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctXvO6UC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C8EC4CEE2;
	Wed,  7 May 2025 19:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644678;
	bh=fMs1/0qiGf8/WSLbQCGZPo9Tv5l9hIUQ5bwyT28Qc30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ctXvO6UCGCabZFrZzIi9BBpwYcUKE66BHNwbrb8Uu3FUTvFKOeZZbMB6CAkPIBgaa
	 eIE8+ZlDKgISBr+6m+II6GVBsz21mzA7e4u/R2QWhGFHU7cJbk8G4u187NKTeWhEWB
	 0b6E5QdlzM5ZLruAs1N4ZvUmDQBZg20il/KA+RPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Francis <alistair.francis@wdc.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/164] nvme-tcp: select CONFIG_TLS from CONFIG_NVME_TCP_TLS
Date: Wed,  7 May 2025 20:40:04 +0200
Message-ID: <20250507183825.791801835@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alistair Francis <alistair23@gmail.com>

[ Upstream commit 521987940ad4fd37fe3d0340ec6f39c4e8e91e36 ]

Ensure that TLS support is enabled in the kernel when
CONFIG_NVME_TCP_TLS is enabled. Without this the code compiles, but does
not actually work unless something else enables CONFIG_TLS.

Fixes: be8e82caa68 ("nvme-tcp: enable TLS handshake upcall")
Signed-off-by: Alistair Francis <alistair.francis@wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
index 486afe5981845..09ed1f61c9a85 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -97,6 +97,7 @@ config NVME_TCP_TLS
 	depends on NVME_TCP
 	select NET_HANDSHAKE
 	select KEYS
+	select TLS
 	help
 	  Enables TLS encryption for NVMe TCP using the netlink handshake API.
 
-- 
2.39.5



