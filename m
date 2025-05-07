Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B90A2116E9;
	Wed,  7 May 2025 18:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644134; cv=none; b=GyhldxMKAun+uE29cPuP52UU3qe3YKyv1xajHu/s+Ndv4vo3ZS7TymGq3ZNOP2zQGoxxlxkZs8+7A5YJ1mIRQe/D6lAMVlrrlXBaj1bfRpMMQygaU5D/5ZlrKug9h7m9BPAmpI2O1bc5YELzqtOPzJvbdfzXtAH0WftbH5m1gLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644134; c=relaxed/simple;
	bh=+bcWZVEahSHHPW27d2lkq3Zi6Kf2Jrv7Pq+M8AKfsLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcHcG1yYNTWolDAWvafGc1Xoio+sMD180ddb9DeRO1hDDkAbiGry+c/Yv6HbqC8cn2knjwl7+VJImXAS3+BcorcrgnhOB1sAVNdNniyz+hAlT9Xoc38sOE2nH2pLNGuwHpKH0cGb5o7WHFavEGh1mRgvuMRzOoCt1W2IZMYHhpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7uZv7ec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7uZv7ec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A94C4CEE2;
	Wed,  7 May 2025 18:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644133;
	bh=+bcWZVEahSHHPW27d2lkq3Zi6Kf2Jrv7Pq+M8AKfsLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7uZv7ecQp2b9y3robgdGKEuj61ZlP454PdKuR7v0n1jzKsaW5jHbTvtXKotMZy9k
	 gNyWJW8PPLQSmJzWQeEJ0/psstADiHc5uvBWLRsBifMDtGcWHrgYcFeTB3NNC/r5K8
	 rULoywkFPOw440fheC0tirJifN582uqUlHTuiFUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Francis <alistair.francis@wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 130/183] nvmet-tcp: select CONFIG_TLS from CONFIG_NVME_TARGET_TCP_TLS
Date: Wed,  7 May 2025 20:39:35 +0200
Message-ID: <20250507183830.087331627@linuxfoundation.org>
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

From: Alistair Francis <alistair.francis@wdc.com>

[ Upstream commit ac38b7ef704c0659568fd4b2c7e6c1255fc51798 ]

Ensure that TLS support is enabled in the kernel when
CONFIG_NVME_TARGET_TCP_TLS is enabled. Without this the code compiles,
but does not actually work unless something else enables CONFIG_TLS.

Fixes: 675b453e0241 ("nvmet-tcp: enable TLS handshake upcall")
Signed-off-by: Alistair Francis <alistair.francis@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/Kconfig b/drivers/nvme/target/Kconfig
index fb7446d6d6829..4c253b433bf78 100644
--- a/drivers/nvme/target/Kconfig
+++ b/drivers/nvme/target/Kconfig
@@ -98,6 +98,7 @@ config NVME_TARGET_TCP_TLS
 	bool "NVMe over Fabrics TCP target TLS encryption support"
 	depends on NVME_TARGET_TCP
 	select NET_HANDSHAKE
+	select TLS
 	help
 	  Enables TLS encryption for the NVMe TCP target using the netlink handshake API.
 
-- 
2.39.5



