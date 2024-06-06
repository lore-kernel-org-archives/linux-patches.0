Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D171A1894;
	Thu,  6 Jun 2024 14:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683730; cv=none; b=Cj1Cs4jAziJjOhPV28d6E4FVFDF4CDn0L3+EGfa3wSD9HAe8uIzJL7NWdjuiveTa2jogIS+M25R2xgVZwk3jS7J0ma2aoL/s7R0/NGZo1W1ymjKHSZfxknrg4BjQCmSOCCF3vegGX7rWuDbOQL62X6MxFSsA36DEy3nCXjZBesE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683730; c=relaxed/simple;
	bh=KolspdsRc4dZx+NkQDpNg0I151Eqzkr6Ny9cbIAOPgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7jPXt59d168sRAD7osPYfXdcjmfLs/IuAO7q/VnOJxvH3xWqq4Fq6E6z+ECtZnbgFF1hroOZ+vwz51ox1OyIkrf4ZHLvUSAcEpmAMSWIchzIYwf3x990SFowIL/Pqtk5IZSvtfGzqEfuFpORAF7D5o26qrTfj/rVa01s7rBuIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y11CN85q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y11CN85q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC09DC2BD10;
	Thu,  6 Jun 2024 14:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683729;
	bh=KolspdsRc4dZx+NkQDpNg0I151Eqzkr6Ny9cbIAOPgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y11CN85qf2sECUzOiFMO9wOJXqBTeyBMTOmUYp/Kfma1kBT2LMVgFCo8Q8xoJcFyf
	 x/UigT2nkcZgGT/cBseFwZOTnV0MmFxpSSMqpODp9CHht471K+ghlAN6ihN0ureQRM
	 LYpcWbZNUcnKKCfSQvQPNbXj86HY7p+feY2yNWS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 680/744] nvme-tcp: add definitions for TLS cipher suites
Date: Thu,  6 Jun 2024 16:05:52 +0200
Message-ID: <20240606131754.297206917@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit a86062aac34d100a3117c0fff91ee1892ebfb460 ]

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: a2e4c5f5f68d ("nvme-multipath: fix io accounting on failover")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nvme-tcp.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/nvme-tcp.h b/include/linux/nvme-tcp.h
index 57ebe1267f7fb..e07e8978d691b 100644
--- a/include/linux/nvme-tcp.h
+++ b/include/linux/nvme-tcp.h
@@ -18,6 +18,12 @@ enum nvme_tcp_pfv {
 	NVME_TCP_PFV_1_0 = 0x0,
 };
 
+enum nvme_tcp_tls_cipher {
+	NVME_TCP_TLS_CIPHER_INVALID     = 0,
+	NVME_TCP_TLS_CIPHER_SHA256      = 1,
+	NVME_TCP_TLS_CIPHER_SHA384      = 2,
+};
+
 enum nvme_tcp_fatal_error_status {
 	NVME_TCP_FES_INVALID_PDU_HDR		= 0x01,
 	NVME_TCP_FES_PDU_SEQ_ERR		= 0x02,
-- 
2.43.0



