Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024918;
	b=V7TE3oHaIsJJsYoWp5MNNV9gvtTMjoXotd80KlFfTxB5gkPHzOBMHT/TmAVzvuAMMckq
	 6fANHciLNr9owiGE3hAeMYtFOmJOH93rpWrdp6osO61nXVgitTHn5s5xCN+tiypX7DP7t
	 QTkqS/ias0+EbVeALx6PeyAemh8k8QIBoeTcMf0Ip3rEjl7qR0SvMNbr+/7QR71tk8hiM
	 PA3vDPw2R/S2b9baDtRbzgMwPBNuoXkxVSjkhYvEe+saSq+/CuD1b5sS2V1HecpynnK7Q
	 ZzHGpi0hLvfumobHwqKQsab5RXQS0lmwoYhdh4lhmuxj7WEARPIGQq+538JJiq+4TSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x1LrfoRTYYq3Yj4rinXZu4KZQZ0e74cChFHN+/QOFZM=;
	b=eGN9lTSbctUySvnIdN2+pOPtvYqDMgLTlhTQeITlifrBhgObjxBDpDeqmriLrTALJYt5
	 glMB3mcPr6rpVwKuW4pMfZHldSZwtpHPzhECXNDWr9HV4W6LNkCZpkO9j0xR4kZToIn22
	 xCGXOdV9HBmyycv/gWk6HmIvFEnpc8Jo1MrYV1nqZFb3V1EOn2PV+ATpCZNK7gJF2PNGO
	 8pnri9yiI6MA3M9KGLLBd1KSSPsmQu+W9YiveLfiyubiYRT1zulBfGyodKQr9tUUPk3tt
	 n852rk1smP3A/gAPnD+ObfSbB+qYd+5y+tRaRnjJD8E0fRnDvvaR296J8f5uGoDeuTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TiRQkvBA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27856606A31C;
	Wed, 18 Nov 2026 18:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TiRQkvBA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785BB1F000C4;
	Wed, 18 Nov 2026 18:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024918;
	bh=x1LrfoRTYYq3Yj4rinXZu4KZQZ0e74cChFHN+/QOFZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TiRQkvBAn4gd/Tm7wdL/4eGid56sbudtWT5Sm0QtuC43Msi3CeR0pyMfJE+pvHPEK
	 zqAdB/SWi6RnujSc7VkYGSm0E2LdFwgtVY1yxU5IWycpPVg3NHvFd2Ohyuj7OTwtNE
	 IPJsmHnevDyUOAHlXRa9LbrRwEjTsOUvK48XUdu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0895/2151] RDMA/hfi1: quiesce SDMA asynchronous cleanup on exit
Date: Wed, 18 Nov 2026 15:43:50 +0100
Message-ID: <20261118150154.900825028@linuxfoundation.org>
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

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit e95d076bc1fca7cc36fc8f2f0e9687f79fd314bd ]

The SDMA state reference and completion cover the software cleanup
tasklet, but not the hardware cleanup tasklet, err_halt_worker, or
flush_worker. Queued instances can therefore access an SDMA engine after
per_sdma is released.

After the state machine has stopped, cancel err_halt_worker first
because it can publish the hardware cleanup tasklet. Then kill that
tasklet and drain the remaining flush work.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260928134148.977-1-getshell@seu.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/sdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 5cfa4f8fbf3d9..3ae1eaaac9c6a 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -1566,6 +1566,9 @@ void sdma_exit(struct hfi1_devdata *dd)
 		 * it is not running.
 		 */
 		sdma_finalput(&sde->state);
+		cancel_work_sync(&sde->err_halt_worker);
+		tasklet_kill(&sde->sdma_hw_clean_up_task);
+		cancel_work_sync(&sde->flush_worker);
 	}
 }
 
-- 
2.53.0



