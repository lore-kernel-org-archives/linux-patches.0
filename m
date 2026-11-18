Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016025;
	b=NyK4v6tPTC1zmFy5xfcNqREKGgxyx/luc+pyjvYzVF9R7NgFTlnAStBZaOqeC2yNkjpV
	 1BVBenacgSQthaDHKg3qAV20MhmoN9FzJVN8SlzTzUvfn8B3dVXdEnZIiTlU7WeP26Kth
	 RwGSh312hgOlaXRp9r9xlXepbQ5SA5Au+rtwlOQqLllQZev0O2J+QS5pkAvrr+bmSKSFT
	 mJOmOo7RtARrhU29xjTnBdtoEopKN8jh1M7JV8Ykj+i7IHM2KgpNvWY/iAtbn8aXCyLXV
	 V4GkwT+HBkhEJHRJkmg4oUWWbNEN/+8hXQA6RxHn3IMZDZPPzUbT4yeDYFIcY2143cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1cMGqbAnMW5Q1rzUdZhd2tAWtgX/K7o2I8Sk9kKdF2g=;
	b=GQ3d/cvtRMA+h0OdS6jSeiv/RTmTYlYmRMxWqUV+MPAzBta9sLa2yDXSu/GemEbRBC/R
	 cDOZkunSXT5o/JiVBmOU66aYNIRv6EEeVirtdqPAdioTT3CXkwW90LAN5s+owUh6OEfJu
	 c72mdkmuLR6e4bAth2lVOsU8zEzNhTymJksf4Iiq/Y0nEzDeCSB7dg23ONSJPU0LAhZ6o
	 ErWHfO2879dEocojtqK7840pZm6cWHPHVamhuPP3Y/CuwsJz+lEJPRLQQuoX/RRny4wNp
	 Hf0RLteBAiW6G5q8AZRchH9tpqc1qmdBvzXDfWYNe7EAgA3ISMEsOKrmcvnFzlGJnrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RX/aThtl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33003606A31C;
	Wed, 18 Nov 2026 15:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RX/aThtl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858081F000C4;
	Wed, 18 Nov 2026 15:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016025;
	bh=1cMGqbAnMW5Q1rzUdZhd2tAWtgX/K7o2I8Sk9kKdF2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RX/aThtlhXI4Kfs3jUqKHRA20V7sz9TMMt5s8e3VlltOwbOCdvrVAcbjf6GTrjv7+
	 CZdrTsoNCfpvLivkNo6EBSg/4UJEdX02OJ3EhVUPeq5zbn/0PhDTaqgatdfFbbXBYM
	 Fx/pM5kuLz+CLbES/zE7evTmF6K0gLwK4HQVO5TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0341/2651] scsi: mpi3mr: Fix out-of-bounds phy array access on link change
Date: Wed, 18 Nov 2026 15:26:21 +0100
Message-ID: <20261118150300.122494567@linuxfoundation.org>
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

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit f67caaa2521a3c8f931d1e679d831ba5ca654794 ]

The phy number that comes with a link change is used to index the node's
phy array without being compared against the number of phys allocated for
that node.

Check it first.

Fixes: 42fc9fee116f ("scsi: mpi3mr: Add helper functions to manage device's port")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-13-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 232af978d7372..29013d0fea547 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1090,6 +1090,13 @@ void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
 		return;
 	}
 
+	if (phy_number >= mr_sas_node->num_phys) {
+		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+		ioc_err(mrioc, "%s: phy_number(%d) >= num_phys(%d)\n",
+			__func__, phy_number, mr_sas_node->num_phys);
+		return;
+	}
+
 	mr_sas_phy = &mr_sas_node->phy[phy_number];
 	mr_sas_phy->attached_handle = handle;
 	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
-- 
2.53.0



