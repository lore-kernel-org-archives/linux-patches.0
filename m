Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBE32116E9;
	Wed,  7 May 2025 18:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644128; cv=none; b=YrDCUYfReuEGT91RTgh0pfBQc4ycw4GbnahnDdbHnOKnPzr4Om6bfwmvqPF4Wbw2DLFmSxFwHhRs9Q6uAq7UpwjRZSeWptdNLjvKrfClU5a3kTonwezSXYb01f1XjjZp1MQ7/hFBCaTI2FBhZrnhkpwSx+/1qaXZvuT+mMWnWjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644128; c=relaxed/simple;
	bh=QlvQljSVuf5J06R1fAgXg3jOcZbsYoq1URbDrp5plnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePcZCi1F37MPR0Tlhqfzp28tcB1iDtWz9wZsyj5uCGE96u9wB/7KTtGhH5/bKpyWfpo/5X8FvnOgqBYiw4U8M1hlOsym/TOUqfCXfrAK7TcpyW/n8wXpXoO9CBsHMP1ILMW1V+WZztudzZ2yDx55PYJniuq+7pP6TXsvEvnW2sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ub8FmiHx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ub8FmiHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51997C4CEE2;
	Wed,  7 May 2025 18:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644127;
	bh=QlvQljSVuf5J06R1fAgXg3jOcZbsYoq1URbDrp5plnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ub8FmiHx2TB73ehyjqwdXXy8d9uJd+PEWkLTF88j4kSFQOYCM1MuS85/0TzKbP78C
	 ZDKENlTGjvjLBAvypkliBSqhZmB/vxgQa6Q398WJq3G6OgfnmVkNTiRY3eRHoMZQGy
	 8TfEaK92az2uibkSAPVdRZY0x/VE/D37R46/V7G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Francis <alistair.francis@wdc.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 129/183] nvme-tcp: select CONFIG_TLS from CONFIG_NVME_TCP_TLS
Date: Wed,  7 May 2025 20:39:34 +0200
Message-ID: <20250507183830.047965228@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



