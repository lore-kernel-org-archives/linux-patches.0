Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065534;
	b=jzZEavsFF2IifixPN/I3B9OZh8Ki/8q5JjjtDJwH/4YLP8XsVET19OBGdf+DpVB2+hLW
	 PX90U8VYwBSvD4rRSAWz8Ep8ELGNuwby6xsUY6DflzHA+PgZwjQMy+6UrP2SDtRZukMfg
	 p2RIUWX3CM7LUyWUmapVpG3HZgZgp1ldiWpEIYLXXRlV/I5Wk2lvPifUTEV+S103TgzAw
	 dFpBd/MZUaSEQoh+KNq2HdjNDV/Cn39lOUhqWnUwkEphfXhkK8sF2z9xQg+Z9oDwx8otA
	 1LtM4En1Bfs+pa/AZMOPtPXg7iVkyrDWnKmEUSRTpCTzzEKsRnHUf5shgrsZ2Hk2mCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mHPUhCxIf1sVubspN6ZJLyB6M/N0ITvNsZK1vbNKMOM=;
	b=XFN0bPrGv4Q6HP8/JgBwwa4dbdR6Qkz3za4I1jOEzzIJMOWEjU/y5G7N7BvMaj73C+hx
	 9WBfXUU7etOrm59TKMXK7ctDvK5YPaNMZh0eCAGY8+xXKssLZpufuter1ccggS7HJr3TW
	 atgSmR6JUkD2EF/1WPW6oNb27VkL2GsbVzyNUxMwltz34F/Pkwxk162o2c0GXfRLpEQos
	 7359EXd2xC9nlhL5E3wj+OIqS4YWJEd5bsBJ3p5PadDTFy2dQJZfUn/tcxWYTFk8+yrnX
	 DJlm0Dn33Q6YdQv14vLoggq2amuLOkOQ9qOV8sM++fTvQ/VZ+dnp6SROlsdS+PgFG+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YtNbWgvL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462AC606A32C;
	Sat,  7 Nov 2026 15:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YtNbWgvL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50DA1F0089F;
	Sat,  7 Nov 2026 15:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065534;
	bh=mHPUhCxIf1sVubspN6ZJLyB6M/N0ITvNsZK1vbNKMOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YtNbWgvLjiv4lZi3rNWemR/xfnfGwcQzZOq5wu4ohZ/iNzD4AbyuqgZtimd2aMiQa
	 pNhK2SSNbXW1aE4wt8ZK8t7rfuLAO6gLrB2iqc0SV7nnNjs7RO0YPq13tLo92w65fZ
	 PydJSjiQlVW2LKLxW/MEdl0T7JcTCVOBPcnJJDMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Andrea Parri <parri.andrea@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1204/1257] nvmet: pci-epf: report transport errors in command completions
Date: Sat,  7 Nov 2026 08:58:20 -0500
Message-ID: <20261107135012.604269252@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 46ed7310a60029826eedb01081a4556643ed5f3b ]

When the PCI endpoint target fails a command itself, the host receives a
successful completion. This happens for a data length above MDTS,
malformed PRPs or SGLs, a buffer allocation failure, an SQ that is not
live, and a failed DMA of the command data. A write whose data cannot be
fetched from the host is thus reported as written, though nothing was
executed.

Each of these paths sets iod->status and calls
nvmet_pci_epf_complete_iod(), which then reloads iod->status from
iod->cqe.status. The nvmet core only fills that field when it completes
the request, which these paths never do, so it is still zero and
nvmet_pci_epf_cq_work() posts a success status to the host.

Drop the reload. Every path already sets iod->status before completion:
nvmet_pci_epf_queue_response() copies it from the request's CQE, and
the transport error paths set it themselves.

Found by code inspection.

Fixes: 0faa0fe6f90e ("nvmet: New NVMe PCI endpoint function target driver")
Cc: stable@vger.kernel.org
Tested-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/pci-epf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvme/target/pci-epf.c b/drivers/nvme/target/pci-epf.c
index c683450df4227..4c5fff232fb99 100644
--- a/drivers/nvme/target/pci-epf.c
+++ b/drivers/nvme/target/pci-epf.c
@@ -1152,7 +1152,6 @@ static void nvmet_pci_epf_complete_iod(struct nvmet_pci_epf_iod *iod)
 	unsigned long flags;
 
 	/* Print an error message for failed commands, except AENs. */
-	iod->status = le16_to_cpu(iod->cqe.status) >> 1;
 	if (iod->status && iod->cmd.common.opcode != nvme_admin_async_event)
 		dev_err(iod->ctrl->dev,
 			"CQ[%d]: Command %s (0x%x) status 0x%0x\n",
-- 
2.53.0



