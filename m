Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063733;
	b=j/RR7vLKbfzRCd96ridb06MGDFTlJfvZJ8X4Ak4+twvG23kAFfhgL0HkBtmvWYWVihmz
	 5JFgWm23YY/qbGKq3WSvuz0z0ED0mgzLP5D9rN9Y6wd1c/8TG+mxPrti5kgqb3bFGQ54s
	 C9MivUfc5jbt1nS0jxc9iI6S5GXFlu/U/E+w4rQxU/UL69LbuXDf9Hc8VKlFVtZcT92G4
	 pxoCvoN5YG/795A2xQIGPWGtPmdIIswSvLQNhTaskr7E1WAq/JU0jM6qX8Adb4msUVlM2
	 P2AYNOreuFTTfdYREZRNxjQONOAmYYpgWAhESKjyQ0yemdgxCvita4y8pOn4ZL32paA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iY/9DmiB+x9Q0yiWokyqLum/xCjj6r7CEq0m+l3KcmA=;
	b=sTe5+xuip5jZGJcGRqQZ5yqaAkyqbZsFrX2K+xOW2tdgTMFSuUBpaFslXY48wm8aMTOH
	 m7ucmMRZbD1wa7EI5yTd4TKtM684kSDHLrct5rawAktY+G0+X4ocyEGDYsdU5yNYifZ1G
	 EyqVbCzdCUIE198uCkJ+d6BHl/oodo7vuQc4oHIcCklXFAkOxAuYdpwPUCVAiNbeg1RYd
	 itvyq5s4A2V7ePgDf8vdJtOwmEvHxzX0Aq5iY/VqG+8T8QV1OPuoN0HeU7trP9eIhwc9q
	 B8mstZT6V3EAyUi9HDvo6PDGjfSLht32Y6dG7utOxijV0GIizLaRVwBVHwncZ8fgL+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wSpQNDz3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A8F606D802;
	Sat,  7 Nov 2026 15:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wSpQNDz3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1911F0089F;
	Sat,  7 Nov 2026 15:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063733;
	bh=iY/9DmiB+x9Q0yiWokyqLum/xCjj6r7CEq0m+l3KcmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wSpQNDz3Qx7nVgEN1d78KLOJb2ZSqSR6ffaQm6UyELM9jZ+BjJ884VTRtsMVximIA
	 8+GhcohN89NR4RB3zDMOF8Ln5tKlTrE547Qln5ojm3C4Kusd6sIWkEAkmyr21SJdte
	 LI18+MKjOo/BFaBQ/UkJb3w3+UrN4FQRcOCY26YI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Andrea Parri <parri.andrea@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 830/869] nvmet: pci-epf: report transport errors in command completions
Date: Sat,  7 Nov 2026 08:58:32 -0500
Message-ID: <20261107134921.071780753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e3815be98ee6e..a85f21a593706 100644
--- a/drivers/nvme/target/pci-epf.c
+++ b/drivers/nvme/target/pci-epf.c
@@ -1174,7 +1174,6 @@ static void nvmet_pci_epf_complete_iod(struct nvmet_pci_epf_iod *iod)
 	unsigned long flags;
 
 	/* Print an error message for failed commands, except AENs. */
-	iod->status = le16_to_cpu(iod->cqe.status) >> 1;
 	if (iod->status && iod->cmd.common.opcode != nvme_admin_async_event)
 		dev_err(iod->ctrl->dev,
 			"CQ[%d]: Command %s (0x%x) status 0x%0x\n",
-- 
2.53.0



