Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024634;
	b=e8ufv8TeBWSYTUQnccrAJLdl3fjQe+8M4lc/yW9tS1CiGsrnj6rag0p/GsZvJ0omJD9p
	 Qe7oEg5UiN4R1F7NxSpCdClfeMqSP+mpiwSW+j963p61gQKSSNhBRS3DKvYwuC0SbQCJL
	 m7hDSYn4xZ7Bl6jetvlRCeOoDaGqcWIzUPsKdp7TGM4zcPTYhJ3qEyyKI60t76C2EYVsy
	 zC+t2bzsR42wi7GqORUenRKCuJ6joTThe2Lxd6C6KgG3oP2Eyx40t7Ckhd0ZTSOetHNwu
	 UnDJRwvNpsE/FIGNAiOwrs6TWGqc7SkKraXegu8uaJy7xsIhotpUy0dIxYm0A8iJ4cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lhKUGroMwpk3mmQWvG6UPTaLQcgU2W+wwf3cZNPT4fQ=;
	b=4R3y0sTBoGIbDjxm+W7QWzJeB6m4YtKChgph91im6EUgCB2E5TuIGivfAdrU0ghtTBiL
	 DPGUJ2vmJGnU5qGh35BGVw8rJ3pls8XBFe9h/TPg3Oyj45/mRVVxepP+QN4sY5NYrWwZa
	 kr8Bpw78OBcfZn2jaI+XDMSsbFjTsJax8E+rGdwUHXgP9HE5B0lkIFcN5hFoLddXAFIZ1
	 o+jzuzv8ayWUHE0H6sfSmXXaappjEwLQGAaDbYStvr5qYgF3cokjpD9U1Lp1qfFxaq+D+
	 3O/VYxzbtltrN2abaTUO3u200AuRixOul/Q4m/xY0+chhak9idIiWoMopzbanqkZeMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1dNgkr8l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE63B606A31C;
	Wed, 18 Nov 2026 17:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1dNgkr8l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101781F000C4;
	Wed, 18 Nov 2026 17:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024634;
	bh=lhKUGroMwpk3mmQWvG6UPTaLQcgU2W+wwf3cZNPT4fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1dNgkr8lKoNQhgzp7i66NswLTw4KV80KVvFq1C0KXN7I3QbAX9OAadGebX/vqA3X3
	 iZAewoU8kOyPBMp8gAxI9uEqLxguR7B7LxkVcp8AKD6oI4bUD1FtsvIgm6JkTLygJ8
	 zTenqDP+0gS8iDAOKKr/ygIEsN3bAZc9CqoxAfCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0796/2151] RDMA/irdma: Free IRQ when CEQ vector mapping fails
Date: Wed, 18 Nov 2026 15:42:11 +0100
Message-ID: <20261118150151.081364515@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index cbf7f4d75e5ea..1baffb595898c 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -1184,12 +1184,21 @@ static int irdma_cfg_ceq_vector(struct irdma_pci_f *rf, struct irdma_ceq *iwceq,
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



