Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B009B28DF21;
	Wed,  7 May 2025 19:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644796; cv=none; b=WW2t3gJboZsVqUxWnWYOJevk5UL9HxC3U3CT8fk8s2l+WYiYVBdHmzn3hOjkVC8vVBiZPZDLtwpr3BmM3pxhA9fsaE1hY/acZrL8YWRhypK3VkA5WRyPAmZj1RnhYAV5iNkb7M9/weeKnNT6Y4NwTIRDA9xwQjpP1AOVIKYLXSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644796; c=relaxed/simple;
	bh=At5Tgm9CcEgdPXB1yQDyJ1vyYirWqDxxH8APrvMleBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=liFQT58jskYRLsH71U6r8FcpkZH0WiIdaUS+tKE4Dcknh40N8PsPgvi7VrJxftXodggllIRxn/R55oDoiL09T3YQVOZvY7tkVlwTQ1yIh7jDN2PAmnQ+o66lSRu5f7mtuVdn9Y0F2wnNfszqwZBJHmeNT8Ust17DmiyjoMKd2JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YN4KxoZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YN4KxoZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7EEC4CEE2;
	Wed,  7 May 2025 19:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644796;
	bh=At5Tgm9CcEgdPXB1yQDyJ1vyYirWqDxxH8APrvMleBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YN4KxoZPxBQrf8k567WcFrcGaSu4nASHhzY1H0P8lJqnhvDzXBUvmCqiE/tWWCN+1
	 jVEa+sgN6aVnyPsiIBc1EMHSb3+xvzpv1acfK/BO4cU///SKJr9rcdxHw+jZs/3n4m
	 SvxQsQNdB0bewo5YtuhL5O9rRCSNrPAB2Q+AFFYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Francis <alistair.francis@wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/164] nvmet-tcp: select CONFIG_TLS from CONFIG_NVME_TARGET_TCP_TLS
Date: Wed,  7 May 2025 20:40:05 +0200
Message-ID: <20250507183825.831844860@linuxfoundation.org>
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
index 46be031f91b43..34438cec32b90 100644
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



