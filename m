Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017577;
	b=yeYRNocSVIodIuZRJI+uzBcrElvRa8DxIzy9ANAy+p5WBDPD7fpU2I85tl9inK0fNKzI
	 ZA1L7AEwAESZgly5xm4dWJaxzjKENXwg9Z1pbexd6PLi2IXcOpsNsdazhIuWHKQujv8Q8
	 UHZf0bnE2YOD+OvmLmHVNedbsar0WPvWok93j0AgKoJxEEWhv0LApdGf4hgOeFTdh8T6s
	 EkKYdHIwDqF5I3kH/d/EOB0289AeiNIx/P9nE8MFGHgpiPL0tkbz9IB8F3ZFBSvIf54Ed
	 7i+TaZwbPTDyFBBBCgLIaCmBOSBOVgwGAdIlNwd6kyCGDCFlek+GkCGWuyyhBVI1xWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SslzATc85YvyaUUY8ajG11CZWRDY11itiSyr5ZcT1yM=;
	b=ZE2FCEERe50t0OiA/CNwpSyE9SQoLO/l41fGHMBikg/KGmL/9uUy87bnqtQpBBP6JFhR
	 U6vWPiu/hhzZnwlTbdCd+QDSra5lfX9bTHclLi8fSL/1t9+FpO4d5XrKTp7TrkeN+ed48
	 V5JB24v5YpY6b/8YHjIE8cWpOucUZ9drJMdKza98Vz4O5/ZtOFK9tU/TaeC79tZYujRVd
	 A4Y65pJLGh/+9/XUGXo7PMGlrtrO9DNWSZeoKa5vOI6JGsc3zIzqKWlsXnz5HMsbuQU/j
	 gKtsATgwF2YE1+p9PlbTpOSZPg2/hdPECd08lFHYJXlVtuTm1vUn4DAhJ7PIXalhW6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IBNT9wGU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF30B606A32A;
	Wed, 18 Nov 2026 15:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IBNT9wGU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D8E1F000C4;
	Wed, 18 Nov 2026 15:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017577;
	bh=SslzATc85YvyaUUY8ajG11CZWRDY11itiSyr5ZcT1yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IBNT9wGUAgH9kyEEUjHdS55u/8xZsLUeIks6C+7a3kYaJUUYzTvVlfHHHV6Eu1xVW
	 ddkYoBjaLVxcuH6tduDKXBTPlOmL0M7ORWfdmEpXzSbeE/VIPBVEsXu/ye7+Eut+to
	 LxU0gLhPG/axrl3/+ZFqeDlm2qODR3+VrXj0v5hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0934/2651] RDMA/irdma: Free IRQ when CEQ vector mapping fails
Date: Wed, 18 Nov 2026 15:36:14 +0100
Message-ID: <20261118150321.509182466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Serhat Kumral <serhatkumral1@gmail.com>

[ Upstream commit 952f18e04fa9790e347e09263c25318afe723d86 ]

irdma_cfg_ceq_vector() registers an IRQ handler before requesting the
CEQ-to-vector mapping through the virtual channel. If the mapping
fails, the function returns without releasing the IRQ resources.
The caller destroys the CEQ, leaving the IRQ handler registered
and potentially referencing freed memory.

Call irdma_destroy_irq() on mapping failure to release
the IRQ resources and drain the associated tasklet
before the caller destroys the CEQ. Use the same dev_id
passed to request_irq(), accounting for CEQ0 sharing
its interrupt vector with the AEQ.

Fixes: b800e82feba7 ("RDMA/irdma: Add GEN3 support for AEQ and CEQ")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Link: https://patch.msgid.link/20260918110428.36586-1-serhatkumral1@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/hw.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index c345cc6542566..b060ddc8b67bc 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -1252,12 +1252,21 @@ static int irdma_cfg_ceq_vector(struct irdma_pci_f *rf, struct irdma_ceq *iwceq,
 	}
 
 	msix_vec->ceq_id = ceq_id;
-	if (rf->sc_dev.privileged)
+	if (rf->sc_dev.privileged) {
 		rf->sc_dev.irq_ops->irdma_cfg_ceq(&rf->sc_dev, ceq_id,
 						  msix_vec->idx, true);
-	else
+	} else {
 		status = irdma_vchnl_req_ceq_vec_map(&rf->sc_dev, ceq_id,
 						     msix_vec->idx);
+		if (!status)
+			return 0;
+
+		if (rf->msix_shared && !ceq_id)
+			irdma_destroy_irq(rf, msix_vec, rf);
+		else
+			irdma_destroy_irq(rf, msix_vec, iwceq);
+	}
+
 	return status;
 }
 
-- 
2.53.0



